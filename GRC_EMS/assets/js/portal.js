/**
 * Role portal controller.
 * Static role pages set `window.PORTAL`; this script requests JSON from the API
 * and renders the dashboard, profile, schedule, billing, and Helpdesk modules.
 */
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
// Upload helper: the browser supplies the multipart boundary, while the CSRF token
// protects the request in the same way as the JSON API helper above.
async function uploadApi(action, formData) {
  const r = await fetch("../api.php?action=" + action, {
      method: "POST",
      headers: { "X-CSRF-Token": P.csrf },
      body: formData,
    }),
    responseText = await r.text();
  let result;
  try {
    result = JSON.parse(responseText);
  } catch (_) {
    throw Error("The server returned an invalid response. Check the Apache error log and PHP configuration.");
  }
  if (!r.ok || !result.success) throw Error(result.error || "Upload failed");
  return result.data;
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
// Fetch the active module's data, then choose the matching interface renderer.
async function load(view) {
  if (window.EMS_MANAGEMENT && window.EMS_MANAGEMENT.canHandle(view, P.role))
    return window.EMS_MANAGEMENT.load(view);
  C.innerHTML = '<div class="status-card">Loading…</div>';
  try {
    const special = {
      profile: "profile_get",
      "teacher-sections": "teacher_sections",
      payments: "payment_list",
    };
    const d = await api(special[view] || "portal&view=" + view);
    render(view, d);
  } catch (e) {
    C.innerHTML = '<div class="status-card">' + esc(e.message) + "</div>";
  }
}
// Select the correct HTML layout for the requested portal view.
function render(v, d) {
  // All roles can manage profile details; students additionally see academic information.
  if (v === "profile") {
    const fullName =
      [d.first_name, d.middle_name, d.last_name].filter(Boolean).join(" ") ||
      d.username;
    const academicTab =
      d.role_name === "Student"
        ? `<button type="button" class="profile-tab" data-panel="academic">Academic Info</button>`
        : "";
    const academicNav =
      d.role_name === "Student"
        ? `<button type="button" data-panel="academic">Academic Info</button>`
        : "";
    const academicPanel =
      d.role_name === "Student"
        ? `<section class="profile-panel" data-profile-panel="academic"><div class="profile-section-title"><h2>Academic Information</h2><p>Your official enrollment and class assignment details.</p></div><div class="profile-facts profile-facts-grid"><div><span>Student number</span><b>${esc(d.student_number)}</b></div><div><span>Enrollment status</span><b>Enrolled</b></div><div><span>Program</span><b>${esc(d.program_code)} — ${esc(d.program_name)}</b></div><div><span>Section</span><b>${esc(d.section_name || "Unassigned")}</b></div><div><span>Academic term</span><b>${d.year_level ? `Year ${esc(d.year_level)} · ${esc(d.school_year)} ${esc(d.semester)}` : "Pending"}</b></div><div><span>LRN / Strand</span><b>${esc(d.lrn || "—")} · ${esc(d.strand || "—")}</b></div><div><span>Last school attended</span><b>${esc(d.last_school_attended || "—")}</b></div><div><span>Year graduated</span><b>${esc(d.year_graduated || "—")}</b></div></div><div class="profile-schedule"><h3>Subjects, schedule, and teachers</h3>${scheduleTable(d.schedule || [])}</div></section>`
        : "";
    C.innerHTML = `<div class="profile-workspace"><aside class="profile-rail"><div class="profile-avatar">${esc(fullName.slice(0, 2).toUpperCase())}</div><h2>${esc(fullName)}</h2><span class="profile-status">${d.role_name === "Student" ? "Enrolled" : title(d.status)}</span><div class="profile-rail-divider"></div><small>PROFILE NAVIGATION</small><nav><button type="button" class="active" data-panel="personal">Personal Info</button>${academicNav}<button type="button" data-panel="account">Security / Password</button></nav></aside><article class="profile-main"><div class="profile-main-head"><div><span>Profile Management</span><h1>My Profile</h1></div><div class="profile-account-meta"><b>${esc(d.role_name)}</b><small>${esc(d.email)}</small></div></div><div class="profile-tabs"><button type="button" class="profile-tab active" data-panel="personal">Personal Info</button>${academicTab}<button type="button" class="profile-tab" data-panel="account">Account Settings</button></div><section class="profile-panel active" data-profile-panel="personal"><div class="profile-section-title"><h2>Personal Information</h2><p>Update your personal and contact details.</p></div><form id="profileSettings" class="grid2"><label>First name<input name="first_name" value="${esc(d.first_name || "")}" required></label><label>Middle name<input name="middle_name" value="${esc(d.middle_name || "")}"></label><label>Last name<input name="last_name" value="${esc(d.last_name || "")}" required></label><label>Birth date<input type="date" name="birth_date" value="${esc(d.birth_date || "")}"></label><label>Email address<input value="${esc(d.email)}" disabled><small>Contact an administrator to change the login email.</small></label><label>Contact number<input name="contact_number" value="${esc(d.contact_number || "")}" placeholder="09XXXXXXXXX"></label><label class="wide">Home address<textarea name="present_address" rows="3">${esc(d.present_address || "")}</textarea></label><div class="profile-actions wide"><button class="secondary profile-cancel" type="button">Cancel</button><button class="primary" type="submit">Save changes</button><span id="profileSaveMessage" role="status"></span></div></form></section>${academicPanel}<section class="profile-panel" data-profile-panel="account"><div class="profile-section-title"><h2>Account Settings</h2><p>Enter your current password before choosing a new one.</p></div><div class="profile-facts profile-facts-grid"><div><span>Username</span><b>${esc(d.username)}</b></div><div><span>Login email</span><b>${esc(d.email)}</b></div><div><span>Role</span><b>${esc(d.role_name)}</b></div><div><span>Account status</span><b>${title(d.status)}</b></div></div><form id="profilePasswordForm" class="profile-password-form"><label class="wide">Current password<input type="password" name="old_password" autocomplete="current-password" required></label><label>New password<input type="password" name="password" minlength="8" maxlength="128" autocomplete="new-password" required></label><label>Confirm new password<input type="password" name="confirmation" minlength="8" maxlength="128" autocomplete="new-password" required></label><div class="profile-actions"><button class="primary" type="submit">Change password</button><span id="profilePasswordMessage" role="status"></span></div></form></section></article></div>`;
    const activateProfilePanel = (name) => {
      document
        .querySelectorAll("[data-profile-panel]")
        .forEach((panel) =>
          panel.classList.toggle("active", panel.dataset.profilePanel === name),
        );
      document
        .querySelectorAll("[data-panel]")
        .forEach((button) =>
          button.classList.toggle("active", button.dataset.panel === name),
        );
    };
    document
      .querySelectorAll("[data-panel]")
      .forEach(
        (button) =>
          (button.onclick = () => activateProfilePanel(button.dataset.panel)),
      );
    const originalProfile = Object.fromEntries(
      new FormData(document.getElementById("profileSettings")),
    );
    document.querySelector(".profile-cancel").onclick = () => {
      const form = document.getElementById("profileSettings");
      Object.entries(originalProfile).forEach(([key, value]) => {
        if (form.elements[key]) form.elements[key].value = value;
      });
      document.getElementById("profileSaveMessage").textContent =
        "Changes cancelled.";
    };
    document.getElementById("profileSettings").onsubmit = async (e) => {
      e.preventDefault();
      const button = e.currentTarget.querySelector("button");
      const message = document.getElementById("profileSaveMessage");
      const body = Object.fromEntries(new FormData(e.currentTarget));
      button.disabled = true;
      message.textContent = "Saving…";
      try {
        await api("profile_save", body);
        message.textContent = "Profile updated successfully.";
      } catch (err) {
        message.textContent = err.message;
      } finally {
        button.disabled = false;
      }
    };
    document.getElementById("profilePasswordForm").onsubmit = async (e) => {
      e.preventDefault();
      const form = e.currentTarget;
      const password = form.elements.password.value;
      const confirmation = form.elements.confirmation.value;
      const message = document.getElementById("profilePasswordMessage");
      if (password !== confirmation) {
        message.textContent = "Passwords do not match.";
        return;
      }
      const button = form.querySelector("button");
      button.disabled = true;
      message.textContent = "Updating…";
      try {
        await api("password_change", {
          old_password: form.elements.old_password.value,
          password,
        });
        form.reset();
        message.textContent = "Password changed successfully.";
      } catch (err) {
        message.textContent = err.message;
      } finally {
        button.disabled = false;
      }
    };
    return;
  }
  if (v === "teacher-sections") {
    C.innerHTML = `<div class="title-row"><div><h1>My assigned sections</h1><p>View the students, subjects, rooms, and schedules assigned to you.</p></div></div><article class="table-card"><table><thead><tr><th>Section</th><th>Program</th><th>Term</th><th>Students</th><th>Action</th></tr></thead><tbody>${d.map((x) => `<tr><td><b>${esc(x.section_name)}</b></td><td>${esc(x.program_code)} — ${esc(x.program_name)}</td><td>Year ${esc(x.year_level)} · ${esc(x.school_year)} ${esc(x.semester)}</td><td>${esc(x.student_count)}</td><td><button class="teacher-section-view" data-id="${x.id}">Manage / View</button></td></tr>`).join("")}</tbody></table></article>`;
    bindTeacherSections();
    return;
  }
  if (v === "payments") {
    C.innerHTML = `<div class="title-row"><div><h1>Payment Processing</h1><p>Inspect uploaded receipts before recording an approved payment.</p></div></div><article class="table-card"><div class="table-wrap"><table><thead><tr><th>Student</th><th>Assessment</th><th>Amount</th><th>Reference</th><th>Receipt</th><th>Status</th><th>Action</th></tr></thead><tbody>${d.map((x) => `<tr><td><b>${esc(x.student_name)}</b><small>${esc(x.student_number)}</small></td><td>${esc(x.description)}</td><td>${money(x.amount)}</td><td>${esc(x.payment_method)}<small>${esc(x.payment_reference)}</small></td><td>${x.receipt_original_name ? `<a href="../api.php?action=payment_receipt&id=${encodeURIComponent(x.id)}" target="_blank" rel="noopener"><b>View receipt</b></a><small>${esc(x.receipt_original_name)} · ${Math.ceil(Number(x.receipt_file_size || 0) / 1024)} KB</small>` : "No receipt"}</td><td><span class="badge ${x.status}">${title(x.status)}</span></td><td>${x.status === "pending" ? `<button class="payment-process" data-id="${x.id}" data-status="approved">Approve</button> <button class="danger payment-process" data-id="${x.id}" data-status="rejected">Reject</button>` : `Processed${x.processor_notes ? `<small>${esc(x.processor_notes)}</small>` : ""}`}</td></tr>`).join("")}</tbody></table></div></article>`;
    bindPaymentProcessing();
    return;
  }
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
  // Students see their own tickets. Staff roles see the service queue and controls.
  if (v === "helpdesk") {
    C.innerHTML = `<div class="title-row"><div><h1>Helpdesk tickets</h1><p>Submit, track, respond to, and resolve student concerns.</p></div>${P.role === "Student" ? '<button class="primary" id="newTicket">Submit concern</button>' : ""}</div><div class="record-tools"><label class="table-search"><span>Search tickets</span><input type="search" id="ticketSearch" placeholder="Ticket, student, subject, or category…"></label><div class="record-filters"><label>Status<select id="ticketStatusFilter"><option value="">All statuses</option><option value="open">Open</option><option value="in_progress">In progress</option><option value="resolved">Resolved</option><option value="closed">Closed</option></select></label></div></div><article class="table-card" style="margin-top:12px"><div class="card-head"><small id="ticketResultCount">${d.length} result${d.length === 1 ? "" : "s"}</small></div><div class="table-wrap"><table id="ticketTable"><thead><tr><th>Ticket</th>${P.role !== "Student" ? "<th>Student</th>" : ""}<th>Subject</th><th>Category</th><th>Messages</th><th>Status</th><th>Updated</th></tr></thead><tbody>${d.length ? d.map((x) => `<tr class="ticket" data-id="${x.id}" data-ticket-status="${esc(x.status)}"><td><b>${esc(x.ticket_number)}</b></td>${P.role !== "Student" ? `<td>${esc(x.student_name)}<small>${esc(x.student_email)}</small></td>` : ""}<td>${esc(x.subject)}</td><td>${esc(x.category)}</td><td>${esc(x.message_count)}</td><td><span class="badge ${x.status === "resolved" || x.status === "closed" ? "approved" : "under_review"}">${title(x.status)}</span></td><td>${date(x.updated_at)}</td></tr>`).join("") : `<tr class="empty-row"><td colspan="${P.role !== "Student" ? 7 : 6}">No tickets found.</td></tr>`}</tbody></table></div></article>`;
    if (P.role === "Student") document.getElementById("newTicket").onclick = ticketDialog;
    document
      .querySelectorAll(".ticket")
      .forEach((x) => (x.onclick = () => ticketDetail(x.dataset.id)));
    bindTicketFilters();
    return;
  }
  if (v === "student-dashboard") {
    C.innerHTML = `<div class="title-row"><div><h1>Good day, ${esc(d.student.first_name)}</h1><p>${esc(d.student.student_number)} · ${esc(d.student.program_code)} · ${esc(d.student.section_name || "Section pending")}</p></div></div><section class="metrics"><article><small>Outstanding assessment</small><strong style="font-size:25px">${money(d.balance)}</strong><span>Current semester</span></article><article><small>Today’s classes</small><strong>${d.today.length}</strong><span>Published schedule</span></article><article><small>Open tickets</small><strong>${d.open_tickets}</strong><span>Helpdesk concerns</span></article><article><small>Enrollment</small><strong style="font-size:20px">${title(d.student.enrollment_status)}</strong><span>${esc(d.student.section_name || "Awaiting section")}</span></article></section><section class="workspace"><article class="table-card"><div class="card-head"><h2>Today’s schedule</h2></div>${scheduleTable(d.today)}</article><aside class="program-card"><h2>Latest announcements</h2>${d.announcements.map((x) => `<div class="program-row"><b>${esc(x.title)}</b><small>${esc(x.body)}</small></div>`).join("")}</aside></section>`;
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
    C.innerHTML = `<div class="title-row"><div><h1>Assessment & Billing</h1><p>Submit a payment reference for Registrar verification. No money is transferred by this school-project system.</p></div></div><section class="metrics"><article><small>Total assessment</small><strong style="font-size:25px">${money(d.assessment)}</strong></article><article><small>Verified paid</small><strong style="font-size:25px">${money(d.paid)}</strong></article><article><small>Outstanding</small><strong style="font-size:25px">${money(d.balance)}</strong></article></section><article class="table-card"><table><thead><tr><th>Description</th><th>School term</th><th>Amount</th><th>Paid</th><th>Status</th><th>Payment</th></tr></thead><tbody>${d.items.map((x) => `<tr><td><b>${esc(x.description)}</b></td><td>${esc(x.school_year)} · ${esc(x.semester)}</td><td>${money(x.amount)}</td><td>${money(x.amount_paid)}</td><td><span class="badge ${x.payment_status === "Paid" ? "approved" : "under_review"}">${esc(x.latest_payment_status ? "Payment " + x.latest_payment_status : x.payment_status)}</span></td><td>${Number(x.amount_paid) < Number(x.amount) && x.latest_payment_status !== "pending" ? `<button class="submit-payment" data-id="${x.id}" data-balance="${Number(x.amount) - Number(x.amount_paid)}">Submit payment</button>` : "—"}</td></tr>`).join("")}</tbody></table></article>`;
    bindStudentPayments();
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
// Helpdesk creation validates required fields before the API creates a tracking number.
function ticketDialog() {
  dialogTitle.textContent = "Submit a concern";
  dialogBody.innerHTML =
    '<form id="newTicketForm"><label>Category<select id="ticketCategory"><option>Enrollment</option><option>Academic</option><option>Assessment</option><option>Technical</option></select></label><label>Subject<input id="ticketSubject" maxlength="190" required></label><label>Details<textarea id="ticketMessage" rows="5" maxlength="5000" required></textarea></label><button class="primary" type="submit">Create ticket</button><p id="ticketFormMessage" role="alert"></p></form>';
  D.showModal();
  document.getElementById("newTicketForm").onsubmit = async (event) => {
    event.preventDefault();
    const button = event.currentTarget.querySelector("button");
    try {
      button.disabled = true;
      button.textContent = "Creating…";
      await api("ticket_create", {category: ticketCategory.value,subject: ticketSubject.value,message: ticketMessage.value});
      D.close();
      load("helpdesk");
    } catch (error) {
      ticketFormMessage.textContent = error.message;
      button.disabled = false;
      button.textContent = "Create ticket";
    }
  };
}
// Ticket detail displays the conversation and allows permitted replies/status updates.
async function ticketDetail(id) {
  try {
    const d = await api("ticket&id=" + encodeURIComponent(id));
    const closed = d.ticket.status === "closed";
    dialogTitle.textContent = d.ticket.ticket_number + " · " + d.ticket.subject;
    const controls = d.can_manage ? `<div class="ticket-status-controls"><label>Status<select id="ticketDetailStatus"><option value="open">Open</option><option value="in_progress">In progress</option><option value="resolved">Resolved</option><option value="closed">Closed</option></select></label><button class="secondary" id="saveTicketStatus">Update status</button></div>` : "";
    dialogBody.innerHTML = `<div class="review-grid">${field("Student", d.ticket.student_name)}${field("Email", d.ticket.student_email)}${field("Category", d.ticket.category)}${field("Priority", title(d.ticket.priority))}${field("Status", title(d.ticket.status))}${field("Assigned to", d.ticket.assigned_email || "Unassigned")}</div>${controls}<h3>Conversation</h3><div class="ticket-thread">${d.messages.map((x) => `<article><div><b>${esc(x.sender_name)}</b><small>${esc(x.role_name)} · ${date(x.created_at)}</small></div><p>${esc(x.message)}</p></article>`).join("")}</div>${closed ? '<p class="status-card">This ticket is closed.</p>' : '<form id="ticketReplyForm"><label>Reply<textarea id="replyText" maxlength="5000" required></textarea></label><button class="primary" type="submit">Send reply</button><p id="ticketReplyMessage" role="alert"></p></form>'}`;
    D.showModal();
    if (d.can_manage) {
      const statusSelect = document.getElementById("ticketDetailStatus");
      const statusButton = document.getElementById("saveTicketStatus");
      statusSelect.value = d.ticket.status;
      statusButton.onclick = async () => {try{statusButton.disabled=true;await api("ticket_status", {id:Number(id),status:statusSelect.value});D.close();load("helpdesk");}catch(error){statusButton.disabled=false;alert(error.message);}};
    }
    const replyForm = document.getElementById("ticketReplyForm");
    if (replyForm) replyForm.onsubmit = async (event) => {event.preventDefault();const button=event.currentTarget.querySelector("button");try{button.disabled=true;await api("ticket_reply",{id:Number(id),message:replyText.value});D.close();load("helpdesk");}catch(error){ticketReplyMessage.textContent=error.message;button.disabled=false;}};
  } catch (error) { alert(error.message); }
}

function bindTicketFilters() {
  const search=document.getElementById("ticketSearch"),filter=document.getElementById("ticketStatusFilter"),rows=[...document.querySelectorAll("#ticketTable tbody tr:not(.empty-row)")],count=document.getElementById("ticketResultCount");
  const apply=()=>{const query=search.value.trim().toLowerCase(),status=filter.value;let visible=0;rows.forEach(row=>{const match=(!query||row.textContent.toLowerCase().includes(query))&&(!status||row.dataset.ticketStatus===status);row.hidden=!match;if(match)visible++;});count.textContent=`${visible} result${visible===1?"":"s"}`;};
  search.addEventListener("input",apply);filter.addEventListener("change",apply);
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
function bindStudentPayments() {
  document.querySelectorAll(".submit-payment").forEach(
    (btn) =>
      (btn.onclick = () => {
        dialogTitle.textContent = "Submit payment for verification";
        dialogBody.innerHTML = `<form id="paymentForm" enctype="multipart/form-data"><label>Amount<input type="number" name="amount" min="0.01" max="${btn.dataset.balance}" step="0.01" value="${btn.dataset.balance}" required></label><label>Payment method<select name="payment_method"><option>Over-the-counter</option><option>Bank deposit</option><option>GCash</option><option>Maya</option></select></label><label>Payment reference / receipt number<input name="payment_reference" maxlength="100" required></label><label>Upload receipt<input type="file" name="receipt" accept=".pdf,.jpg,.jpeg,application/pdf,image/jpeg" required><small>PDF or JPEG only, maximum 5 MB.</small></label><p>This submits a record for verification. Your balance changes only after an authorized reviewer approves the receipt.</p><button class="primary" type="submit">Submit for verification</button></form>`;
        D.showModal();
        document.getElementById("paymentForm").onsubmit = async (e) => {
          e.preventDefault();
          const form = e.currentTarget;
          const body = new FormData(form);
          body.append("assessment_id", btn.dataset.id);
          const submit = form.querySelector('button[type="submit"]');
          try {
            submit.disabled = true;
            submit.textContent = "Uploading…";
            await uploadApi("payment_submit", body);
            D.close();
            load("finance");
          } catch (err) {
            alert(err.message);
          } finally {
            submit.disabled = false;
            submit.textContent = "Submit for verification";
          }
        };
      }),
  );
}
function bindPaymentProcessing() {
  document.querySelectorAll(".payment-process").forEach(
    (btn) =>
      (btn.onclick = async () => {
        const notes = prompt(`Optional ${btn.dataset.status} notes:`) || "";
        if (!confirm(`${title(btn.dataset.status)} this payment request?`))
          return;
        try {
          await api("payment_process", {
            id: Number(btn.dataset.id),
            status: btn.dataset.status,
            notes,
          });
          load("payments");
        } catch (err) {
          alert(err.message);
        }
      }),
  );
}
function bindTeacherSections() {
  document.querySelectorAll(".teacher-section-view").forEach(
    (btn) =>
      (btn.onclick = async () => {
        try {
          const d = await api("teacher_section_detail&id=" + btn.dataset.id);
          dialogTitle.textContent = d.section.section_name;
          dialogBody.innerHTML = `<div class="review-grid">${field("Program", d.section.program_code + " — " + d.section.program_name)}${field("Term", "Year " + d.section.year_level + " · " + d.section.school_year + " " + d.section.semester)}${field("Capacity", d.section.capacity)}</div><h3>Students</h3>${d.students.length ? `<ul class="document-list">${d.students.map((s) => `<li><b>${esc(s.student_name)}</b><small>${esc(s.student_number)} · ${esc(s.email)} · ${esc(s.contact_number || "No contact")}</small></li>`).join("")}</ul>` : "<p>No students assigned.</p>"}<h3>Subjects and schedule</h3>${scheduleTable(d.schedule)}`;
          D.showModal();
        } catch (err) {
          alert(err.message);
        }
      }),
  );
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
        '<p>For your security, replace the temporary password before using the portal.</p><form id="passwordChangeForm"><label>Current temporary password<input type="password" id="oldPassword" autocomplete="current-password" required></label><label>New password<input type="password" id="newPassword" minlength="8" maxlength="128" autocomplete="new-password" required><small>Use at least 8 characters.</small></label><label>Confirm password<input type="password" id="confirmPassword" minlength="8" maxlength="128" autocomplete="new-password" required></label><div id="passwordError" class="password-error" role="alert"></div><button type="submit" class="primary" id="changePassword">Change password</button></form>';
      D.showModal();
      const passwordForm = document.getElementById("passwordChangeForm"),
        passwordButton = document.getElementById("changePassword"),
        passwordError = document.getElementById("passwordError");
      passwordForm.addEventListener("submit", async (e) => {
        e.preventDefault();
        passwordError.textContent = "";
        const oldPassword = document.getElementById("oldPassword").value,
          password = document.getElementById("newPassword").value,
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
          await api("password_change", { old_password: oldPassword, password });
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
