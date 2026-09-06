(function () {
  const modules = [
    "students",
    "assessments",
    "programs",
    "sections",
    "subjects",
    "schedules",
    "announcements",
    "users",
  ];
  const configs = {
    students: {
      title: "Student Profiling",
      description:
        "Secure personal, contact, program, and section records for accepted students.",
      add: "Add accepted student",
      columns: [
        ["Student", (r) => `${r.last_name}, ${r.first_name}`],
        ["Student no.", (r) => r.student_number],
        ["Email", (r) => r.email],
        ["Program", (r) => r.program_code],
        ["Section", (r) => r.section_name || "Unassigned"],
        ["Status", (r) => (Number(r.is_active) ? "Active" : "Inactive")],
      ],
      fields: [
        ["student_number", "Student number", "text"],
        ["first_name", "First name", "text", 1],
        ["middle_name", "Middle name", "text"],
        ["last_name", "Last name", "text", 1],
        ["email", "Email", "email", 1],
        ["birth_date", "Birth date", "date"],
        ["contact_number", "Contact number", "text"],
        ["present_address", "Address", "textarea"],
        ["program_id", "Program", "select", 1, "programs"],
        ["section_id", "Section", "select", 0, "sections"],
        ["password", "Temporary password (new record only)", "password"],
        ["is_active", "Active record", "checkbox"],
      ],
    },
    users: {
      title: "Account Management",
      description:
        "Create and maintain Admin, Registrar, Staff, and Teacher accounts.",
      add: "Create staff account",
      columns: [
        ["Name", (r) => r.username],
        ["Email", (r) => r.email],
        ["Role", (r) => r.role_name],
        ["Status", (r) => r.status],
        [
          "Password change",
          (r) => (Number(r.must_change_password) ? "Required" : "No"),
        ],
      ],
      fields: [
        ["username", "Username", "text", 1],
        ["email", "Email", "email", 1],
        ["role_id", "Role", "select", 1, "roles"],
        ["password", "Temporary password (new account only)", "password"],
        [
          "status",
          "Account status",
          "choice",
          1,
          ["active", "inactive", "locked"],
        ],
        [
          "must_change_password",
          "Require password change on next login",
          "checkbox",
        ],
      ],
    },
    assessments: {
      title: "Assessment & Billing",
      description:
        "Calculate tuition and fees and record balances. No online payment processing is included.",
      add: "Add assessment",
      columns: [
        ["Student", (r) => r.student_name],
        ["Student no.", (r) => r.student_number],
        ["Description", (r) => r.description],
        ["Assessment", (r) => peso(r.amount)],
        ["Recorded paid", (r) => peso(r.amount_paid)],
        ["Status", (r) => r.payment_status],
      ],
      fields: [
        ["student_profile_id", "Student", "select", 1, "students"],
        ["description", "Fee description", "text", 1],
        ["amount", "Assessment amount", "number", 1],
        ["amount_paid", "Amount recorded as paid", "number", 1],
        ["due_date", "Due date", "date"],
        ["school_year", "School year", "text", 1],
        ["semester", "Semester", "text", 1],
      ],
    },
    programs: {
      title: "Program Management",
      description:
        "Create, view, edit, deactivate, or delete academic programs.",
      add: "Add program",
      columns: [
        ["Code", (r) => r.program_code],
        ["Program", (r) => r.program_name],
        ["Department", (r) => r.department || "—"],
        ["Status", (r) => (Number(r.is_active) ? "Active" : "Inactive")],
      ],
      fields: [
        ["program_code", "Program code", "text", 1],
        ["program_name", "Program name", "text", 1],
        ["department", "Department", "text"],
        ["description", "Description", "textarea"],
        ["is_active", "Active program", "checkbox"],
      ],
    },
    sections: {
      title: "Section Management",
      description: "Assign programs, year levels, school terms, and capacity.",
      add: "Add section",
      columns: [
        ["Section", (r) => r.section_name],
        ["Program", (r) => r.program_code],
        ["Year", (r) => r.year_level],
        ["Term", (r) => `${r.school_year} · ${r.semester}`],
        ["Students", (r) => `${r.student_count}/${r.capacity}`],
      ],
      fields: [
        ["section_name", "Section name", "text", 1],
        ["program_id", "Program", "select", 1, "programs"],
        ["year_level", "Year level", "number", 1],
        ["school_year", "School year", "text", 1],
        ["semester", "Semester", "text", 1],
        ["capacity", "Capacity", "number", 1],
      ],
    },
    subjects: {
      title: "Subject Management",
      description:
        "Maintain subjects, units, programs, year levels, and semesters.",
      add: "Add subject",
      columns: [
        ["Code", (r) => r.subject_code],
        ["Subject", (r) => r.subject_name],
        ["Program", (r) => r.program_code || "General"],
        ["Units", (r) => r.units],
        ["Term", (r) => `Year ${r.year_level} · ${r.semester}`],
      ],
      fields: [
        ["subject_code", "Subject code", "text", 1],
        ["subject_name", "Subject name", "text", 1],
        ["units", "Units", "number", 1],
        ["program_id", "Program", "select", 0, "programs"],
        ["year_level", "Year level", "number", 1],
        ["semester", "Semester", "text", 1],
      ],
    },
    schedules: {
      title: "Class Scheduling & Sectioning",
      description:
        "Connect sections with subjects, teachers, rooms, days, and class times.",
      add: "Add schedule",
      columns: [
        ["Section", (r) => r.section_name],
        ["Subject", (r) => `${r.subject_code} — ${r.subject_name}`],
        ["Day", (r) => r.day_of_week],
        ["Time", (r) => `${r.start_time}–${r.end_time}`],
        ["Room", (r) => r.room],
        ["Teacher", (r) => r.instructor],
      ],
      fields: [
        ["section_id", "Section", "select", 1, "sections"],
        ["subject_id", "Subject", "select", 1, "subjects"],
        [
          "day_of_week",
          "Day",
          "choice",
          1,
          ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        ],
        ["start_time", "Start time", "time", 1],
        ["end_time", "End time", "time", 1],
        ["room", "Room", "text", 1],
        ["instructor", "Teacher", "text", 1],
      ],
    },
    announcements: {
      title: "Announcement Management",
      description:
        "Create, publish, edit, and delete enrollment announcements.",
      add: "Add announcement",
      columns: [
        ["Title", (r) => r.title],
        ["Audience", (r) => r.audience],
        ["Published", (r) => (Number(r.is_published) ? "Yes" : "No")],
        ["Date", (r) => r.published_at || "—"],
      ],
      fields: [
        ["title", "Title", "text", 1],
        ["body", "Message", "textarea", 1],
        ["audience", "Audience", "choice", 1, ["all", "students", "staff"]],
        ["is_published", "Publish now", "checkbox"],
      ],
    },
  };
  const peso = (value) =>
    new Intl.NumberFormat("en-PH", {
      style: "currency",
      currency: "PHP",
    }).format(Number(value) || 0);
  const escape = (value) => {
    const element = document.createElement("div");
    element.textContent = value ?? "";
    return element.innerHTML;
  };
  async function request(action, module, body) {
    const options = body
      ? {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": window.PORTAL.csrf,
          },
          body: JSON.stringify({ ...body, module }),
        }
      : {};
    const response = await fetch(
      `../api.php?action=${action}&module=${encodeURIComponent(module)}`,
      options,
    );
    const text = await response.text();
    let result;
    try {
      result = JSON.parse(text);
    } catch (_) {
      throw new Error(
        "The server returned an invalid response. Check PHP and MySQL in XAMPP.",
      );
    }
    if (!response.ok || !result.success)
      throw new Error(result.error || "Request failed.");
    return result.data;
  }
  function optionLabel(key, item) {
    if (key === "programs")
      return `${item.program_code} — ${item.program_name}`;
    if (key === "sections") return item.section_name;
    if (key === "students") return `${item.student_number} — ${item.name}`;
    if (key === "subjects")
      return `${item.subject_code} — ${item.subject_name}`;
    if (key === "roles") return item.role_name;
    return item.name || item.id;
  }
  function input(field, row, options, isNew) {
    const [key, label, type, required, source] = field;
    let control = "";
    const value = row[key] ?? "";
    if (type === "textarea")
      control = `<textarea name="${key}" rows="3" ${required ? "required" : ""}>${escape(value)}</textarea>`;
    else if (type === "checkbox")
      return `<label class="checkbox-field"><input type="checkbox" name="${key}" value="1" ${isNew || Number(value) ? "checked" : ""}><span>${escape(label)}</span></label>`;
    else if (type === "select") {
      const items = options[source] || [];
      control = `<select name="${key}" ${required ? "required" : ""}><option value="">${required ? "Select " + label : "None / unassigned"}</option>${items.map((item) => `<option value="${item.id}" ${String(item.id) === String(value) ? "selected" : ""}>${escape(optionLabel(source, item))}</option>`).join("")}</select>`;
    } else if (type === "choice") {
      control = `<select name="${key}" ${required ? "required" : ""}>${source.map((item) => `<option ${String(item) === String(value) ? "selected" : ""}>${escape(item)}</option>`).join("")}</select>`;
    } else {
      const attrs = type === "number" ? 'step="0.01" min="0"' : "";
      control = `<input type="${type}" name="${key}" value="${escape(value)}" ${attrs} ${required ? "required" : ""}>`;
    }
    return `<label>${escape(label)}${control}</label>`;
  }
  function formDialog(module, row, data) {
    const config = configs[module],
      isNew = !row.id,
      dialog = document.getElementById("actionDialog");
    document.getElementById("dialogTitle").textContent =
      (isNew ? "Create " : "Edit ") + config.title;
    document.getElementById("dialogBody").innerHTML =
      `<form id="crudForm"><input type="hidden" name="id" value="${row.id || ""}"><div class="grid2">${config.fields.map((field) => input(field, row, data.options, isNew)).join("")}</div><div class="dialog-actions"><button type="button" class="secondary" id="cancelCrud">Cancel</button><button class="primary" type="submit">${isNew ? "Create" : "Save changes"}</button></div><div id="crudMessage" role="alert"></div></form>`;
    dialog.showModal();
    document.getElementById("cancelCrud").onclick = () => dialog.close();
    document.getElementById("crudForm").onsubmit = async (event) => {
      event.preventDefault();
      const form = event.currentTarget,
        button = form.querySelector("[type=submit]"),
        payload = Object.fromEntries(new FormData(form));
      config.fields
        .filter((x) => x[2] === "checkbox")
        .forEach((x) => (payload[x[0]] = form.elements[x[0]].checked));
      try {
        button.disabled = true;
        button.textContent = "Saving…";
        const result = await request("manage_save", module, payload);
        dialog.close();
        if (result.temporary_password)
          alert(
            "Student account created. Temporary password: " +
              result.temporary_password,
          );
        await load(module);
      } catch (error) {
        document.getElementById("crudMessage").className = "error";
        document.getElementById("crudMessage").textContent = error.message;
        button.disabled = false;
        button.textContent = isNew ? "Create" : "Save changes";
      }
    };
  }
  async function remove(module, row) {
    if (
      !confirm(
        `Delete this ${configs[module].title.toLowerCase()} record? This cannot be undone.`,
      )
    )
      return;
    try {
      await request("manage_delete", module, { id: row.id });
      await load(module);
    } catch (error) {
      alert(error.message);
    }
  }
  function detailField(label, value) {
    return `<div class="review-field"><small>${escape(label)}</small><b>${escape(value || "—")}</b></div>`;
  }
  function detailSchedule(rows) {
    return rows?.length
      ? `<div class="table-wrap"><table><thead><tr><th>Subject</th><th>Day</th><th>Time</th><th>Room</th><th>Teacher</th></tr></thead><tbody>${rows.map((row) => `<tr><td><b>${escape(row.subject_code || "")}</b><small>${escape(row.subject_name || "")}</small></td><td>${escape(row.day_of_week)}</td><td>${escape(row.start_time)}–${escape(row.end_time)}</td><td>${escape(row.room)}</td><td>${escape(row.instructor)}</td></tr>`).join("")}</tbody></table></div>`
      : "<p>No class schedule is assigned yet.</p>";
  }
  async function showDetails(module, row) {
    const dialog = document.getElementById("actionDialog");
    document.getElementById("dialogTitle").textContent = "View details";
    document.getElementById("dialogBody").innerHTML = "<p>Loading details…</p>";
    dialog.showModal();
    try {
      const response = await fetch(
          `../api.php?action=manage_detail&module=${encodeURIComponent(module)}&id=${encodeURIComponent(row.id)}`,
        ),
        text = await response.text();
      let payload;
      try {
        payload = JSON.parse(text);
      } catch (_) {
        throw new Error(
          "The server returned an invalid response. Check the Apache error log and PHP 8.1+ configuration.",
        );
      }
      if (!response.ok || !payload.success)
        throw new Error(payload.error || "Unable to load details.");
      const d = payload.data,
        r = d.record;
      if (module === "students")
        (document.getElementById("dialogTitle").textContent =
          "Student profile · " + r.student_number),
          (document.getElementById("dialogBody").innerHTML =
            `<div class="review-grid">${detailField("Full name", [r.first_name, r.middle_name, r.last_name].filter(Boolean).join(" "))}${detailField("Student number", r.student_number)}${detailField("Email", r.email)}${detailField("Birth date", r.birth_date)}${detailField("Contact number", r.contact_number)}${detailField("Address", r.present_address)}${detailField("Program", `${r.program_code} — ${r.program_name}`)}${detailField("Section", r.section_name ? `${r.section_name} · Year ${r.year_level} · ${r.school_year} ${r.semester}` : "Unassigned")}${detailField("Record status", Number(r.is_active) ? "Active" : "Inactive")}</div><h3>Subjects, schedule, and teachers</h3>${detailSchedule(d.schedule)}`);
      else if (module === "sections")
        (document.getElementById("dialogTitle").textContent =
          "Section · " + r.section_name),
          (document.getElementById("dialogBody").innerHTML =
            `<div class="review-grid">${detailField("Program", `${r.program_code} — ${r.program_name}`)}${detailField("Year level", r.year_level)}${detailField("School year", r.school_year)}${detailField("Semester", r.semester)}${detailField("Capacity", r.capacity)}${detailField("Enrolled students", d.students.length)}</div><h3>Students</h3>${d.students.length ? `<ul class="document-list">${d.students.map((x) => `<li><b>${escape(x.student_name)}</b><small>${escape(x.student_number)} · ${escape(x.email)}</small></li>`).join("")}</ul>` : "<p>No active students are assigned yet.</p>"}<h3>Subjects, schedule, and teachers</h3>${detailSchedule(d.schedule)}`);
      else if (module === "subjects")
        (document.getElementById("dialogTitle").textContent =
          "Subject · " + r.subject_code),
          (document.getElementById("dialogBody").innerHTML =
            `<div class="review-grid">${detailField("Subject", r.subject_name)}${detailField("Units", r.units)}${detailField("Program", r.program_code ? `${r.program_code} — ${r.program_name}` : "General subject")}${detailField("Year level", r.year_level)}${detailField("Semester", r.semester)}</div><h3>Assigned sections, schedules, and teachers</h3>${d.schedules?.length ? `<div class="table-wrap"><table><thead><tr><th>Section</th><th>Term</th><th>Day</th><th>Time</th><th>Room</th><th>Teacher</th></tr></thead><tbody>${d.schedules.map((x) => `<tr><td>${escape(x.section_name)}</td><td>${escape(x.school_year)} · ${escape(x.semester)}</td><td>${escape(x.day_of_week)}</td><td>${escape(x.start_time)}–${escape(x.end_time)}</td><td>${escape(x.room)}</td><td>${escape(x.instructor)}</td></tr>`).join("")}</tbody></table></div>` : "<p>This subject has not been scheduled yet.</p>"}`);
    } catch (error) {
      document.getElementById("dialogBody").innerHTML =
        `<p class="error">${escape(error.message)}</p>`;
    }
  }
  function selectFilter(id, label, items, value, labeler) {
    return `<label>${escape(label)}<select class="record-filter" id="${id}"><option value="">All</option>${items.map((item) => `<option value="${escape(value(item))}">${escape(labeler(item))}</option>`).join("")}</select></label>`;
  }
  function recordTools(module, data) {
    if (module === "students")
      return `<div class="record-tools"><label class="table-search"><span>Search students</span><input type="search" id="recordSearch" placeholder="Name, student no., email…" autocomplete="off"></label><div class="record-filters">${selectFilter(
        "filterProgram",
        "Program",
        data.options.programs,
        (x) => x.id,
        (x) => x.program_code,
      )}${selectFilter(
        "filterSection",
        "Section",
        data.options.sections,
        (x) => x.id,
        (x) => x.section_name,
      )}${selectFilter(
        "filterStatus",
        "Status",
        [
          { id: "active", name: "Active" },
          { id: "inactive", name: "Inactive" },
        ],
        (x) => x.id,
        (x) => x.name,
      )}</div></div>`;
    if (module === "assessments")
      return `<div class="record-tools"><label class="table-search"><span>Search assessments</span><input type="search" id="recordSearch" placeholder="Student, student no., fee, or status…" autocomplete="off"></label></div>`;
    if (module === "sections") {
      const unique = (key) =>
        [
          ...new Set(
            data.rows.map((row) => String(row[key] ?? "")).filter(Boolean),
          ),
        ]
          .sort()
          .map((value) => ({ value }));
      return `<div class="record-tools"><label class="table-search"><span>Search sections</span><input type="search" id="recordSearch" placeholder="Section name or program…" autocomplete="off"></label><div class="record-filters">${selectFilter(
        "filterProgram",
        "Program",
        data.options.programs,
        (x) => x.id,
        (x) => x.program_code,
      )}${selectFilter(
        "filterYear",
        "Year level",
        unique("year_level"),
        (x) => x.value,
        (x) => x.value,
      )}${selectFilter(
        "filterSchoolYear",
        "School year",
        unique("school_year"),
        (x) => x.value,
        (x) => x.value,
      )}${selectFilter(
        "filterSemester",
        "Semester",
        unique("semester"),
        (x) => x.value,
        (x) => x.value,
      )}</div></div>`;
    }
    return "";
  }
  function bindRecordTools(module, data, content) {
    if (!["students", "assessments", "sections"].includes(module)) return;
    const search = document.getElementById("recordSearch"),
      filters = [...content.querySelectorAll(".record-filter")],
      rows = [...content.querySelectorAll("tbody tr")],
      count = document.getElementById("managementResultCount");
    const apply = () => {
      const query = search.value.trim().toLowerCase();
      let visible = 0;
      rows.forEach((element, index) => {
        const row = data.rows[index];
        if (!row) return;
        let match = !query || element.textContent.toLowerCase().includes(query);
        if (module === "students") {
          match =
            match &&
            (!document.getElementById("filterProgram").value ||
              String(row.program_id) ===
                document.getElementById("filterProgram").value) &&
            (!document.getElementById("filterSection").value ||
              String(row.section_id ?? "") ===
                document.getElementById("filterSection").value) &&
            (!document.getElementById("filterStatus").value ||
              (document.getElementById("filterStatus").value === "active"
                ? Number(row.is_active) === 1
                : Number(row.is_active) !== 1));
        } else if (module === "sections") {
          match =
            match &&
            (!document.getElementById("filterProgram").value ||
              String(row.program_id) ===
                document.getElementById("filterProgram").value) &&
            (!document.getElementById("filterYear").value ||
              String(row.year_level) ===
                document.getElementById("filterYear").value) &&
            (!document.getElementById("filterSchoolYear").value ||
              String(row.school_year) ===
                document.getElementById("filterSchoolYear").value) &&
            (!document.getElementById("filterSemester").value ||
              String(row.semester) ===
                document.getElementById("filterSemester").value);
        }
        element.hidden = !match;
        if (match) visible++;
      });
      count.textContent = visible + " result" + (visible === 1 ? "" : "s");
    };
    search.addEventListener("input", apply);
    filters.forEach((filter) => filter.addEventListener("change", apply));
    apply();
  }
  async function load(module) {
    const content = document.getElementById("portalContent"),
      config = configs[module];
    content.innerHTML = '<div class="status-card">Loading records…</div>';
    try {
      const data = await request("manage_list", module),
        tools = recordTools(module, data),
        details = ["students", "sections", "subjects"].includes(module);
      content.innerHTML = `<div class="title-row"><div><h1>${escape(config.title)}</h1><p>${escape(config.description)}</p></div><button class="primary" id="addRecord">${escape(config.add)}</button></div>${tools}<article class="table-card" style="margin-top:${tools ? "12" : "24"}px"><div class="card-head"><div><h2>Records</h2><p id="managementResultCount">${data.rows.length} result${data.rows.length === 1 ? "" : "s"}</p></div></div><div class="table-wrap"><table><thead><tr>${config.columns.map((column) => `<th>${escape(column[0])}</th>`).join("")}<th>Actions</th></tr></thead><tbody>${data.rows.length ? data.rows.map((row) => `<tr>${config.columns.map((column) => `<td>${escape(column[1](row))}</td>`).join("")}<td>${details ? `<button class="review view-record" data-id="${row.id}">View</button> ` : ""}<button class="review edit-record" data-id="${row.id}">Edit</button> <button class="danger delete-record" data-id="${row.id}">Delete</button></td></tr>`).join("") : `<tr><td colspan="${config.columns.length + 1}">No records found.</td></tr>`}</tbody></table></div></article>`;
      document.getElementById("addRecord").onclick = () =>
        formDialog(module, {}, data);
      document.querySelectorAll(".view-record").forEach(
        (button) =>
          (button.onclick = () =>
            showDetails(
              module,
              data.rows.find((row) => String(row.id) === button.dataset.id),
            )),
      );
      document.querySelectorAll(".edit-record").forEach(
        (button) =>
          (button.onclick = () =>
            formDialog(
              module,
              data.rows.find((row) => String(row.id) === button.dataset.id),
              data,
            )),
      );
      document.querySelectorAll(".delete-record").forEach(
        (button) =>
          (button.onclick = () =>
            remove(
              module,
              data.rows.find((row) => String(row.id) === button.dataset.id),
            )),
      );
      bindRecordTools(module, data, content);
    } catch (error) {
      content.innerHTML = `<div class="status-card error">${escape(error.message)}</div>`;
    }
  }
  window.EMS_MANAGEMENT = {
    canHandle: (module, role) => {
      if (!modules.includes(module) || role === "Student") return false;
      if (role === "Staff" || role === "Teacher") return false;
      if (module === "users" && !["Admin", "Super Admin"].includes(role))
        return false;
      if (module === "assessments" && !["Admin", "Super Admin"].includes(role))
        return false;
      return true;
    },
    load,
  };
})();
