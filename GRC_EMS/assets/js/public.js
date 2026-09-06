// Controls the multi-step public application form and prevents double submission.
let step = 1,
  publicCsrf = "",
  submitting = false;
const form = document.getElementById("publicApplication");
const msg = document.getElementById("appMessage");
const appStepTitle = document.getElementById("appStepTitle");
const appStepMeta = document.getElementById("appStepMeta");
const prevStep = document.getElementById("prevStep");
const nextStep = document.getElementById("nextStep");
const submitApplication = document.getElementById("submitApplication");
const programSelect = document.getElementById("programSelect");
const names = [
  "Personal information",
  "Academic background",
  "Document requirements",
  "Review & consent",
];
// Lets the API recognize a repeated click or retry as the same submission.
const submissionToken =
  sessionStorage.getItem("grc_submission_token") ||
  (window.crypto && crypto.randomUUID
    ? crypto.randomUUID()
    : Date.now() + "-" + Math.random().toString(36).slice(2));
sessionStorage.setItem("grc_submission_token", submissionToken);

// API helper: gets CSRF protection and turns API errors into JavaScript errors.
async function call(action, options = {}) {
  if (options.method)
    options.headers = {
      ...(options.headers || {}),
      "X-CSRF-Token": publicCsrf,
    };
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 12000);
  try {
    const response = await fetch(
      "api.php?action=" + encodeURIComponent(action),
      { ...options, signal: controller.signal, credentials: "same-origin" },
    );
    const text = await response.text();
    let result;
    try {
      result = JSON.parse(text);
    } catch (_) {
      throw new Error(
        "The PHP API returned an invalid response. Confirm Apache is running and open the site through http://localhost/GRC_EMS/.",
      );
    }
    if (!response.ok || !result.success)
      throw new Error(result.error || "Request failed.");
    return result;
  } catch (error) {
    if (error.name === "AbortError")
      throw new Error(
        "The server took too long to respond. Check that MySQL is running in XAMPP.",
      );
    throw error;
  } finally {
    clearTimeout(timer);
  }
}

// Show the active form step and update navigation buttons.
function show() {
  document
    .querySelectorAll(".application-step")
    .forEach((x, i) => x.classList.toggle("active", i === step - 1));
  document
    .querySelectorAll(".progress i")
    .forEach((x, i) => x.classList.toggle("on", i < step));
  appStepTitle.textContent = names[step - 1];
  appStepMeta.textContent = "Step " + step + " of 4";
  prevStep.hidden = step === 1;
  nextStep.hidden = step === 4;
  submitApplication.hidden = step !== 4;
}

// Read active programs from the database for the Program select field.
async function loadPrograms() {
  programSelect.disabled = true;
  programSelect.innerHTML = '<option value="">Loading programs…</option>';
  msg.className = "";
  msg.textContent = "";
  try {
    const { data } = await call("programs");
    if (!Array.isArray(data) || data.length === 0)
      throw new Error(
        "No active programs were found. Import GRC_EMS_latest_setup.sql in phpMyAdmin.",
      );
    programSelect.replaceChildren(new Option("Select a program", ""));
    data.forEach((program) =>
      programSelect.add(
        new Option(
          String(program.program_code) + " — " + String(program.program_name),
          String(program.id),
        ),
      ),
    );
    programSelect.disabled = false;
  } catch (error) {
    programSelect.innerHTML = '<option value="">Programs unavailable</option>';
    msg.className = "error";
    msg.textContent = "Could not load programs: " + error.message + " ";
    const retry = document.createElement("button");
    retry.type = "button";
    retry.textContent = "Retry";
    retry.addEventListener("click", loadPrograms, { once: true });
    msg.appendChild(retry);
  }
}

call("csrf")
  .then((x) => {
    publicCsrf = x.data.token;
  })
  .catch((error) => {
    msg.className = "error";
    msg.textContent = error.message;
  });
loadPrograms();
nextStep.onclick = () => {
  const xs = [
    ...document
      .querySelector('[data-step="' + step + '"]')
      .querySelectorAll("input,select"),
  ];
  if (xs.every((x) => x.reportValidity())) {
    step++;
    show();
  }
};
prevStep.onclick = () => {
  step--;
  show();
};
// Client-side upload validation. The PHP API repeats these checks for security.
function validateFiles() {
  for (const f of form.querySelectorAll("input[type=file]"))
    for (const file of f.files) {
      if (file.size > 5242880) throw Error(file.name + " exceeds 5MB.");
      if (!["application/pdf", "image/jpeg"].includes(file.type))
        throw Error(file.name + " must be PDF or JPEG.");
    }
}
// Send one application and replace the form with the Reference ID confirmation.
form.onsubmit = async (e) => {
  e.preventDefault();
  if (submitting) return;
  const original = submitApplication.textContent;
  try {
    submitting = true;
    submitApplication.disabled = true;
    submitApplication.textContent = "Submitting…";
    msg.className = "";
    msg.textContent = "Please wait while we securely save your application.";
    validateFiles();
    const fd = new FormData(form);
    fd.append("mode", "submit");
    fd.append("submission_token", submissionToken);
    const { data } = await call("application_save", {
      method: "POST",
      body: fd,
    });
    sessionStorage.removeItem("grc_submission_token");
    form.innerHTML =
      '<div class="success-card"><b>' +
      (data.duplicate
        ? "Application already received"
        : "Application submitted") +
      "</b><h2>" +
      data.reference_id +
      "</h2><p>Save this reference ID. Admissions will email you after reviewing your application.</p></div>";
  } catch (e) {
    submitting = false;
    submitApplication.disabled = false;
    submitApplication.textContent = original;
    msg.className = "error";
    msg.textContent = e.message;
  }
};
