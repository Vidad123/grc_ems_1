const loginForm = document.getElementById("portalLogin");
const loginMessage = document.getElementById("loginMessage");
let loginCsrf = "";

async function loginRequest(url, options = {}) {
  const response = await fetch(url, { credentials: "same-origin", ...options });
  const text = await response.text();
  let result;
  try {
    result = JSON.parse(text);
  } catch (_) {
    throw new Error(
      "The server returned an invalid response. Check the Apache error log and confirm PHP 8.1+ is enabled.",
    );
  }
  if (!response.ok || !result.success)
    throw new Error(result.error || "The login request failed.");
  return result.data;
}

loginRequest("api.php?action=csrf")
  .then((data) => {
    loginCsrf = data.token;
    loginMessage.textContent = "";
  })
  .catch((error) => {
    loginMessage.textContent = error.message;
  });

loginForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const button = loginForm.querySelector("button");
  loginMessage.textContent = "Signing in…";
  button.disabled = true;
  try {
    if (!loginCsrf)
      loginCsrf = (await loginRequest("api.php?action=csrf")).token;
    const data = await loginRequest("api.php?action=login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": loginCsrf,
      },
      body: JSON.stringify(Object.fromEntries(new FormData(loginForm))),
    });
    const routes = {
      Student: "student/index.html",
      Staff: "staff/index.html",
      Teacher: "teacher/index.html",
      Registrar: "registrar/index.html",
      Admin: "admin/index.html",
      "Super Admin": "admin/index.html",
    };
    location.href = routes[data.role_name] || "login.html";
  } catch (error) {
    loginMessage.textContent = error.message;
    button.disabled = false;
  }
});
