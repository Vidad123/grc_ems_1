fetch("api.php?action=programs")
  .then((r) => r.json())
  .then(({ data }) => {
    document.getElementById("programCards").innerHTML = data
      .map(
        (p) =>
          "<article><span>" +
          p.program_code +
          "</span><h3>" +
          p.program_name +
          "</h3><p>" +
          p.description +
          "</p></article>",
      )
      .join("");
  })
  .catch(() => {
    document.getElementById("programCards").innerHTML =
      "<p>Programs are temporarily unavailable. Please contact Admissions.</p>";
  });
