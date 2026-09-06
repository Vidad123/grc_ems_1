// Main portal renderer. Each role page supplies its view configuration via window.PORTAL.
const P = window.PORTAL,
  C = document.getElementById("portalContent"),
  D = document.getElementById("actionDialog");
// Portal API helper: sends CSRF data and returns normalized error messages.
async function api(action, body = null) {
  const o = body
    ? {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": P.csrf },
        body: JSON.stringify(body),
      }
    : {};
  const r = await fetch("../api.php?action=" + action, o),
    text = await r.text();
  let j;
  try {
    j = JSON.parse(text);
  } catch (_) {
    throw Error(
      "The server returned an invalid response. Check the Apache error log and PHP 8.1+ configuration.",
    );
  }
  if (!r.ok || !j.success) throw Error(j.error || "Request failed");
  return j.data;
}
const money = (n) =>
    new Intl.NumberFormat("en-PH", {
      style: "currency",
      currency: "PHP",
    }).format(n || 0),
  date = (s) => new Date(String(s).replace(" ", "T")).toLocaleString(),
  esc = (s) => {
    const d = document.createElement("div");
    d.textContent = s ?? "";
    return d.innerHTML;
  },
  title = (s) =>
    String(s || "")
      .replaceAll("_", " ")
      .replace(/\b\w/g, (c) => c.toUpperCase());
// Fetch data for the active dashboard/module, then pass it to the renderer.
async function load(view) {
  if (window.EMS_MANAGEMENT && window.EMS_MANAGEMENT.canHandle(view, P.role))
    return window.EMS_MANAGEMENT.load(view);
  C.innerHTML = '<div class="status-card">Loading…</div>';
  try {
    const d = await api("portal&view=" + view);
    render(view, d);
  } catch (e) {
    C.innerHTML = '<div class="status-card">' + esc(e.message) + "</div>";
  }
}
// Select the correct HTML layout for the requested portal view.
function render(v, d) {
  if (v === "admin-dashboard") {
    C.innerHTML = `<div class="title-row"><div><h1>Enrollment operations</h1><p>Review applications and monitor student services.</p></div></div><section class="metrics">${[
      ["Applications", d.counts.applications],
      ["Action required", d.counts.action_required],
      ["Active students", d.counts.students],
      ["Open tickets", d.counts.tickets],
    ]
      .map(
        (x) =>
          `<article><small>${x[0]}</small><strong>${x[1]}</strong><span>Current total</span></article>`,
      )
      .join("")}</section>${applicationTable(d.applications)}`;
    bindReviews();
    bindApplicationDeletes();
    return;
  }
  if (v === "teacher-dashboard") {
    C.innerHTML = `<div class="title-row"><div><h1>Teaching dashboard</h1><p>Published subjects, rooms, teachers, and class schedules.</p></div></div><article class="table-card">${scheduleTable(d)}</article>`;
    return;
  }
  if (v === "applications") {
    C.innerHTML =
      '<div class="title-row"><div><h1>Application review</h1><p>Verify details, request corrections, approve applicants, or delete invalid records.</p></div></div>' +
      applicationTable(d);
    bindReviews();
    bindApplicationDeletes();
    return;
  }
  if (v === "students") {
    C.innerHTML = `<div class="title-row"><div><h1>Student records</h1><p>Sections and enrollment standing.</p></div></div><article class="table-card"><table><thead><tr><th>Student</th><th>Student no.</th><th>Program</th><th>Section</th><th>Status</th></tr></thead><tbody>${d.map((x) => `<tr><td><b>${esc(x.name)}</b><small>${esc(x.email)}</small></td><td>${esc(x.student_number)}</td><td>${esc(x.program_code)}</td><td>${esc(x.section_name || "Unassigned")}</td><td><span class="badge approved">Active</span></td></tr>`).join("")}</tbody></table></article>`;
    return;
  }
  if (v === "academics") {
    C.innerHTML = `<div class="title-row"><div><h1>Academic assignments</h1><p>Published sections, subjects, and schedules.</p></div></div><article class="table-card"><table><thead><tr><th>Code</th><th>Subject</th><th>Section</th><th>Schedule</th><th>Room</th></tr></thead><tbody>${d.map((x) => `<tr><td><b>${esc(x.subject_code)}</b></td><td>${esc(x.subject_name)}</td><td>${esc(x.section_name)}</td><td>${esc(x.day_of_week)} · ${esc(x.start_time)}–${esc(x.end_time)}</td><td>${esc(x.room)}</td></tr>`).join("")}</tbody></table></article>`;
    return;
  }
  if (v === "announcements") {
    C.innerHTML = `<div class="title-row"><div><h1>Announcements</h1><p>Campus updates visible to your audience.</p></div>${P.role !== "Student" ? '<button class="primary" id="newAnnouncement">New announcement</button>' : ""}</div><div class="workspace"><article class="table-card">${d.map((x) => `<div style="padding:20px;border-bottom:1px solid #eef2f6"><b>${esc(x.title)}</b><p>${esc(x.body)}</p><small>${date(x.published_at)}</small></div>`).join("")}</article></div>`;
    const add = document.getElementById("newAnnouncement");
    if (add) add.onclick = announcementDialog;
    return;
  }
  if (v === "helpdesk") {
    C.innerHTML = `<div class="title-row"><div><h1>Helpdesk tickets</h1><p>Tracked concerns and registrar responses.</p></div><button class="primary" id="newTicket">${P.role === "Student" ? "Submit concern" : "View queue"}</button></div><article class="table-card"><table><thead><tr><th>Ticket</th><th>Subject</th><th>Category</th><th>Status</th><th>Updated</th></tr></thead><tbody>${d.map((x) => `<tr class="ticket" data-id="${x.id}"><td><b>${esc(x.ticket_number)}</b></td><td>${esc(x.subject)}</td><td>${esc(x.category)}</td><td><span class="badge ${x.status === "resolved" ? "approved" : "under_review"}">${title(x.status)}</span></td><td>${date(x.updated_at)}</td></tr>`).join("")}</tbody></table></article>`;
    if (P.role === "Student") newTicket.onclick = ticketDialog;
    document
      .querySelectorAll(".ticket")
      .forEach((x) => (x.onclick = () => ticketDetail(x.dataset.id)));
    return;
  }
  if (v === "student-dashboard") {
    C.innerHTML = `<div class="title-row"><div><h1>Good day, ${esc(d.student.first_name)}</h1><p>${esc(d.student.student_number)} · ${esc(d.student.program_code)} · ${esc(d.student.section_name || "Section pending")}</p></div></div><section class="metrics"><article><small>Outstanding assessment</small><strong style="font-size:25px">${money(d.balance)}</strong><span>Current semester</span></article><article><small>Today’s classes</small><strong>${d.today.length}</strong><span>Published schedule</span></article><article><small>Open tickets</small><strong>${d.open_tickets}</strong><span>Helpdesk concerns</span></article><article><small>Enrollment</small><strong style="font-size:20px">${title(d.student.enrollment_status)}</strong><span>${esc(d.student.section_name || "Awaiting section")}</span></article></section><section class="workspace"><article class="table-card"><div class="card-head"><h2>Today’s schedule</h2></div>${scheduleTable(d.today)}</article><aside class="program-card"><h2>Latest announcements</h2>${d.announcements.map((x) => `<div class="program-row"><b>${esc(x.title)}</b><small>${esc(x.body)}</small></div>`).join("")}</aside></section>`;
    return;
  }
  if (v === "profile") {
    const s = d.student;
    C.innerHTML = `<div class="title-row"><div><h1>My profile</h1><p>Your personal, enrollment, section, and subject information.</p></div></div><article class="table-card"><div class="review-grid">${field("Full name", [s.first_name, s.middle_name, s.last_name].filter(Boolean).join(" "))}${field("Student number", s.student_number)}${field("Email", s.email)}${field("Birth date", s.birth_date)}${field("Contact number", s.contact_number)}${field("Address", s.present_address)}${field("Program", `${s.program_code} — ${s.program_name}`)}${field("Section", s.section_name ? `${s.section_name} · Year ${s.year_level} · ${s.school_year} ${s.semester}` : "Section pending")}</div><div class="card-head" style="margin-top:24px"><h2>Subjects, schedule, and teachers</h2></div>${scheduleTable(d.schedule)}</article>`;
    return;
  }
  if (v === "schedule") {
    C.innerHTML =
      '<div class="title-row"><div><h1>Schedule & subjects</h1><p>Your current academic load and assigned teachers.</p></div></div><article class="table-card">' +
      scheduleTable(d) +
      "</article>";
    return;
  }
  if (v === "finance") {
    C.innerHTML = `<div class="title-row"><div><h1>Assessment & Billing</h1><p>Tuition and fee records only. Online payment is not enabled.</p></div></div><section class="metrics"><article><small>Total assessment</small><strong style="font-size:25px">${money(d.assessment)}</strong></article><article><small>Recorded as paid</small><strong style="font-size:25px">${money(d.paid)}</strong></article><article><small>Outstanding</small><strong style="font-size:25px">${money(d.balance)}</strong></article></section><article class="table-card"><table><thead><tr><th>Description</th><th>School term</th><th>Due date</th><th>Amount</th><th>Recorded paid</th><th>Status</th></tr></thead><tbody>${d.items.map((x) => `<tr><td><b>${esc(x.description)}</b></td><td>${esc(x.school_year)} · ${esc(x.semester)}</td><td>${esc(x.due_date || "—")}</td><td>${money(x.amount)}</td><td>${money(x.amount_paid)}</td><td><span class="badge ${x.payment_status === "Paid" ? "approved" : "under_review"}">${esc(x.payment_status)}</span></td></tr>`).join("")}</tbody></table></article>`;
    return;
  }
}
function applicationTable(d) {
  return `<article class="table-card"><div class="card-head"><div><h2>Applications</h2><p>Review, update, or delete enrollment applications.</p></div></div><table><thead><tr><th>Applicant</th><th>Reference</th><th>Program</th><th>Status</th><th>Actions</th></tr></thead><tbody>${d.map((x) => `<tr><td><b>${esc(x.name)}</b><small>${esc(x.email)}</small></td><td>${esc(x.reference_id)}</td><td>${esc(x.program_code)}</td><td><span class="badge ${x.status}">${title(x.status)}</span></td><td><button class="review" data-id="${x.id}" data-name="${esc(x.name)}">Review / Edit</button> <button class="danger delete-application" data-id="${x.id}">Delete</button></td></tr>`).join("")}</tbody></table></article>`;
}
function scheduleTable(d) {
  return `<div class="table-wrap"><table><thead><tr><th>Subject</th><th>Units</th><th>Day</th><th>Time</th><th>Room</th><th>Teacher</th></tr></thead><tbody>${d.length ? d.map((x) => `<tr><td><b>${esc(x.subject_code)}</b><small>${esc(x.subject_name)}</small></td><td>${esc(x.units || "—")}</td><td>${esc(x.day_of_week)}</td><td>${esc(x.start_time)}–${esc(x.end_time)}</td><td>${esc(x.room)}</td><td>${esc(x.instructor || "—")}</td></tr>`).join("") : '<tr><td colspan="6">No class schedule is assigned yet.</td></tr>'}</tbody></table></div>`;
}
function field(label, value) {
  return `<div class="review-field"><small>${esc(label)}</small><b>${esc(value || "—")}</b></div>`;
}
// Admin review controls: request correction, approve/send credentials, or reject.
function bindReviews() {
  document.querySelectorAll(".review").forEach(
    (b) =>
      (b.onclick = async () => {
        dialogTitle.textContent = "Review · " + b.dataset.name;
        dialogBody.innerHTML = "<p>Loading application details…</p>";
        D.showModal();
        try {
          const d = await api(
              "application_detail&id=" + encodeURIComponent(b.dataset.id),
            ),
            a = d.application;
          const docs = d.documents.length
            ? d.documents
                .map(
                  (x) =>
                    `<li><a href="../api.php?action=application_document&id=${encodeURIComponent(x.id)}" target="_blank" rel="noopener">${esc(x.original_name)}</a><small>${esc(title(x.document_type))} · ${Math.ceil(x.file_size / 1024)} KB · ${esc(title(x.validation_status))}</small></li>`,
                )
                .join("")
            : "<li>No documents were uploaded.</li>";
          dialogBody.innerHTML = `<section class="review-details"><h3>Applicant information</h3><div class="review-grid">${field("Reference ID", a.reference_id)}${field("Email", a.email)}${field("Full name", [a.first_name, a.middle_name, a.last_name].filter(Boolean).join(" "))}${field("Birth date", a.birth_date)}${field("Contact number", a.contact_number)}${field("Address", a.present_address)}${field("Enrollment type", title(a.enrollment_type))}${field("Program", (a.program_code || "") + " — " + (a.program_name || ""))}</div><h3>Academic background</h3><div class="review-grid">${field("Last school attended", a.last_school_attended)}${field("LRN", a.lrn)}${field("Strand", a.strand)}${field("Year graduated", a.year_graduated)}</div><h3>Uploaded documents</h3><ul class="document-list">${docs}</ul><label>Message / additional instructions<textarea id="reviewMessage" rows="4" placeholder="Correction details, approval reminders, or rejection reason">${esc(a.review_notes || "")}</textarea><small>This message is saved with the review and included in the decision email.</small></label><div class="dialog-actions"><button class="secondary decision" data-s="action_required">Request correction</button><button class="primary decision" data-s="approved">Approve & send credentials</button><button class="danger decision" data-s="rejected">Reject</button></div></section>`;
          document.querySelectorAll(".decision").forEach(
            (x) =>
              (x.onclick = async () => {
                const buttons = [...document.querySelectorAll(".decision")];
                try {
                  const message = reviewMessage.value.trim();
                  if (x.dataset.s === "action_required" && !message)
                    return alert(
                      "Enter the corrections the applicant must complete.",
                    );
                  buttons.forEach((button) => (button.disabled = true));
                  x.textContent = "Processing…";
                  const result = await api("application_review", {
                    id: b.dataset.id,
                    status: x.dataset.s,
                    message,
                  });
                  D.close();
                  alert(
                    result.email_sent
                      ? "Application updated and email sent."
                      : "Application updated, but email delivery failed. Check email_logs and your mail configuration.",
                  );
                  load("applications");
                } catch (e) {
                  buttons.forEach((button) => (button.disabled = false));
                  alert(e.message);
                }
              }),
          );
        } catch (e) {
          dialogBody.innerHTML = '<p class="error">' + esc(e.message) + "</p>";
        }
      }),
  );
}
function bindApplicationDeletes() {
  document.querySelectorAll(".delete-application").forEach(
    (button) =>
      (button.onclick = async () => {
        if (
          !confirm(
            "Delete this application and its uploaded documents? This cannot be undone.",
          )
        )
          return;
        try {
          button.disabled = true;
          await api("application_delete", { id: button.dataset.id });
          await load("applications");
        } catch (error) {
          button.disabled = false;
          alert(error.message);
        }
      }),
  );
}
// Student Helpdesk: create a tracked question or concern.
function ticketDialog() {
  dialogTitle.textContent = "Submit a concern";
  dialogBody.innerHTML =
    '<label>Category<select id="ticketCategory"><option>Enrollment</option><option>Academic</option><option>Assessment</option><option>Technical</option></select></label><label>Subject<input id="ticketSubject"></label><label>Details<textarea id="ticketMessage" rows="5"></textarea></label><button class="primary" id="sendTicket">Create ticket</button>';
  D.showModal();
  sendTicket.onclick = async () => {
    await api("ticket_create", {
      category: ticketCategory.value,
      subject: ticketSubject.value,
      message: ticketMessage.value,
    });
    D.close();
    load("helpdesk");
  };
}
async function ticketDetail(id) {
  const d = await api("ticket&id=" + id);
  dialogTitle.textContent = d.ticket.ticket_number + " · " + d.ticket.subject;
  dialogBody.innerHTML =
    d.messages
      .map(
        (x) =>
          `<div style="padding:12px;background:#f4f7fb;margin:8px 0;border-radius:8px"><b>${esc(x.sender_email)}</b><p>${esc(x.message)}</p></div>`,
      )
      .join("") +
    `<label>Reply<textarea id="replyText"></textarea></label><button class="primary" id="sendReply">Send reply</button>`;
  D.showModal();
  sendReply.onclick = async () => {
    await api("ticket_reply", { id, message: replyText.value });
    D.close();
    load("helpdesk");
  };
}
function announcementDialog() {
  dialogTitle.textContent = "New announcement";
  dialogBody.innerHTML =
    '<label>Title<input id="annTitle"></label><label>Message<textarea id="annBody"></textarea></label><button class="primary" id="publishAnn">Publish</button>';
  D.showModal();
  publishAnn.onclick = async () => {
    await api("announcement_create", {
      title: annTitle.value,
      body: annBody.value,
      audience: "all",
    });
    D.close();
    load("announcements");
  };
}
// Confirm the session before loading portal data; enforce first-login password change.
async function startPortal() {
  try {
    const response = await fetch("../api.php?action=session"),
      text = await response.text();
    let result;
    try {
      result = JSON.parse(text);
    } catch (_) {
      throw Error(
        "The server returned an invalid response. Check the Apache error log and PHP 8.1+ configuration.",
      );
    }
    if (!response.ok || !result.success)
      throw Error(result.error || "Authentication required.");
    const session = result.data.user;
    if (!P.allowed.includes(session.role_name)) {
      const routes = {
        Student: "../student/index.html",
        Staff: "../staff/index.html",
        Teacher: "../teacher/index.html",
        Registrar: "../registrar/index.html",
        Admin: "../admin/index.html",
        "Super Admin": "../admin/index.html",
      };
      location.href = routes[session.role_name] || "../login.html";
      return;
    }
    P.role = session.role_name;
    P.mustChange = Boolean(session.must_change_password);
    P.csrf = result.data.csrf;
    document.getElementById("profileEmail").textContent = session.email;
    document.getElementById("profileRole").textContent = session.role_name;
    document.getElementById("profileInitials").textContent = session.email
      .slice(0, 2)
      .toUpperCase();
    document.querySelector(".logout").addEventListener("submit", async (e) => {
      e.preventDefault();
      await api("logout", {});
      location.href = "../login.html";
    });
    if (P.mustChange) {
      const close = D.querySelector(".dialog-close");
      close.hidden = true;
      D.addEventListener("cancel", (e) => e.preventDefault());
      dialogTitle.textContent = "Create your new password";
      dialogBody.innerHTML =
        '<p>For your security, replace the temporary password before using the portal.</p><form id="passwordChangeForm"><label>New password<input type="password" id="newPassword" minlength="8" maxlength="128" autocomplete="new-password" required><small>Use at least 8 characters.</small></label><label>Confirm password<input type="password" id="confirmPassword" minlength="8" maxlength="128" autocomplete="new-password" required></label><div id="passwordError" class="password-error" role="alert"></div><button type="submit" class="primary" id="changePassword">Change password</button></form>';
      D.showModal();
      const passwordForm = document.getElementById("passwordChangeForm"),
        passwordButton = document.getElementById("changePassword"),
        passwordError = document.getElementById("passwordError");
      passwordForm.addEventListener("submit", async (e) => {
        e.preventDefault();
        passwordError.textContent = "";
        const password = document.getElementById("newPassword").value,
          confirmation = document.getElementById("confirmPassword").value;
        if (password.length < 8) {
          passwordError.textContent = "Password must be at least 8 characters.";
          return;
        }
        if (password !== confirmation) {
          passwordError.textContent = "Passwords do not match.";
          return;
        }
        try {
          passwordButton.disabled = true;
          passwordButton.textContent = "Changing password…";
          await api("password_change", { password });
          passwordError.classList.add("success");
          passwordError.textContent =
            "Password changed successfully. Loading your portal…";
          setTimeout(() => location.reload(), 700);
        } catch (error) {
          passwordButton.disabled = false;
          passwordButton.textContent = "Change password";
          passwordError.textContent = error.message;
        }
      });
    } else load(P.module);
  } catch (error) {
    location.href = "../login.html";
  }
}
startPortal();
