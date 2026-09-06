const form = document.getElementById("accountForm");
const message = document.getElementById("accountMessage");
const role = document.getElementById("roleName");
const studentNote = document.getElementById("studentNote");
let csrf = "";

function show(text, type = "error") {
  message.textContent = text;
  message.className = "account-message " + type;
}

async function prepareForm() {
  try {
    const response = await fetch("api.php?action=csrf", {
      credentials: "same-origin",
    });
    const result = await response.json();
    if (!response.ok || !result.success)
      throw new Error(result.error || "The account service is unavailable.");
    csrf = result.data.token;
  } catch (error) {
    show(error.message);
    form.querySelector('button[type="submit"]').disabled = true;
  }
}

role.addEventListener("change", () => {
  studentNote.hidden = role.value !== "Student";
});
form.addEventListener("submit", async (event) => {
  event.preventDefault();
  const button = form.querySelector('button[type="submit"]');
  const data = Object.fromEntries(new FormData(form));
  data.must_change_password = form.elements.must_change_password.checked;
  button.disabled = true;
  button.textContent = "Creating…";
  show("Creating account…", "ok");
  try {
    const response = await fetch("api.php?action=account_create", {
      method: "POST",
      credentials: "same-origin",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": csrf },
      body: JSON.stringify(data),
    });
    const result = await response.json();
    if (!response.ok || !result.success)
      throw new Error(result.error || "The account could not be created.");
    show(
      `${result.data.role_name} account created for ${result.data.email}.`,
      "ok",
    );
    form.reset();
    studentNote.hidden = true;
  } catch (error) {
    show(error.message);
  } finally {
    button.disabled = false;
    button.textContent = "Create account";
  }
});

prepareForm();
