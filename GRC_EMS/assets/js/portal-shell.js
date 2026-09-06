// Shared sidebar/navigation. The HTML page defines the role and selected module.
const portalKey = document.body.dataset.portalRole;
const moduleKey = document.body.dataset.module;
const portalConfig = {
  admin: {
    allowed: ["Admin", "Super Admin"],
    label: "Admin",
    menus: [
      ["dashboard", "Overview", "index.html", "▦"],
      ["applications", "Applications", "applications.html", "✓"],
      ["students", "Student Profiles", "students.html", "♙"],
      ["assessments", "Assessment & Billing", "assessments.html", "₱"],
      ["programs", "Programs", "programs.html", "P"],
      ["sections", "Sections", "sections.html", "S"],
      ["subjects", "Subjects", "subjects.html", "B"],
      ["schedules", "Schedules", "schedules.html", "▤"],
      ["accounts", "Account Management", "accounts.html", "⚙"],
      ["announcements", "Announcements", "announcements.html", "◉"],
      ["helpdesk", "Helpdesk", "helpdesk.html", "?"],
    ],
  },
  registrar: {
    allowed: ["Registrar"],
    label: "Registrar",
    menus: [
      ["dashboard", "Overview", "index.html", "▦"],
      ["applications", "Applications", "applications.html", "✓"],
      ["students", "Student Profiles", "students.html", "♙"],
      ["programs", "Programs", "programs.html", "P"],
      ["sections", "Sections", "sections.html", "S"],
      ["subjects", "Subjects", "subjects.html", "B"],
      ["schedules", "Schedules", "schedules.html", "▤"],
      ["announcements", "Announcements", "announcements.html", "◉"],
      ["helpdesk", "Helpdesk", "helpdesk.html", "?"],
    ],
  },
  staff: {
    allowed: ["Staff"],
    label: "Staff",
    menus: [
      ["dashboard", "Overview", "index.html", "▦"],
      ["applications", "Applications", "applications.html", "✓"],
      ["students", "Students", "students.html", "♙"],
      ["helpdesk", "Helpdesk", "helpdesk.html", "?"],
    ],
  },
  teacher: {
    allowed: ["Teacher"],
    label: "Teacher",
    menus: [
      ["dashboard", "Teaching Dashboard", "index.html", "▦"],
      ["helpdesk", "Helpdesk", "helpdesk.html", "?"],
    ],
  },
  student: {
    allowed: ["Student"],
    label: "Student",
    menus: [
      ["dashboard", "Dashboard", "index.html", "▦"],
      ["profile", "My Profile", "profile.html", "♙"],
      ["schedule", "Schedule & subjects", "schedule.html", "▤"],
      ["finance", "Assessment & Billing", "finance.html", "₱"],
      ["announcements", "Announcements", "announcements.html", "◉"],
      ["helpdesk", "Helpdesk", "helpdesk.html", "?"],
    ],
  },
};
const cfg = portalConfig[portalKey] || portalConfig.student;
const current = cfg.menus.find((item) => item[0] === moduleKey) || cfg.menus[0];
const iconPaths = {
  dashboard: "M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z",
  applications: "M6 3h9l3 3v15H6zM9 11h6M9 15h6M9 7h3",
  students: "M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 21c0-4 3-6 8-6s8 2 8 6",
  assessments: "M6 2h12v20l-3-2-3 2-3-2-3 2zM9 7h6M9 11h6M9 15h4",
  programs: "M4 5h16v14H4zM8 9h8M8 13h5",
  sections: "M3 6h18M3 12h18M3 18h18M7 3v18",
  subjects: "M4 4h12a4 4 0 0 1 4 4v12H8a4 4 0 0 0-4 1zM8 4v16",
  schedules: "M5 4h14v17H5zM8 2v4M16 2v4M5 9h14M9 13h2M14 13h2M9 17h2",
  accounts:
    "M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM5 21a7 7 0 0 1 14 0M19 8v6M16 11h6",
  announcements: "M4 11v2h3l5 4V7l-5 4zM12 8l7-3v14l-7-3",
  helpdesk:
    "M12 18h.01M9.1 9a3 3 0 1 1 4.8 2.4c-1.2.8-1.9 1.5-1.9 3.1M12 22a10 10 0 1 0 0-20 10 10 0 0 0 0 20",
  profile: "M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM4 21c0-4 3-6 8-6s8 2 8 6",
  schedule: "M5 4h14v17H5zM8 2v4M16 2v4M5 9h14M9 13h6M9 17h4",
  finance: "M6 2h12v20l-3-2-3 2-3-2-3 2zM9 8h6M9 12h6M9 16h4",
};
function sidebarIcon(key) {
  return `<svg class="nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="${iconPaths[key] || iconPaths.dashboard}"></path></svg>`;
}
document.getElementById("portalSidebar").innerHTML =
  `<div class="brand"><img class="grc-portal-logo" src="../assets/logo_grc_1.png" alt="Global Reciprocal Colleges"><div><b>GRC ${portalKey === "student" ? "SMS" : "EMS"}</b><small>${cfg.label} Portal</small></div></div><nav>${cfg.menus.map((item) => `<a class="${item[0] === moduleKey ? "active" : ""}" href="${item[2]}">${sidebarIcon(item[0])}<span>${item[1]}</span></a>`).join("")}</nav><div class="profile"><span id="profileInitials">--</span><div><b id="profileEmail">Loading…</b><small id="profileRole">${cfg.label}</small></div></div>`;
document.getElementById("pageTitle").textContent = current[1];
window.PORTAL = {
  allowed: cfg.allowed,
  module:
    moduleKey === "dashboard"
      ? portalKey === "student"
        ? "student-dashboard"
        : portalKey === "teacher"
          ? "teacher-dashboard"
          : "admin-dashboard"
      : moduleKey,
  role: "",
  mustChange: false,
  csrf: "",
};
