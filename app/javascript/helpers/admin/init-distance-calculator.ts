function initDistanceCalculator() {
  const inputs = document.querySelectorAll<HTMLInputElement>(".distance-input");
  const value = (id: string) =>
    Number(document.querySelector<HTMLInputElement>(`#${id}`)?.value) || 0;

  const result = document.querySelector("#distance-result");

  inputs.forEach((input) => {
    input.addEventListener("input", () => {
      const distance = Math.hypot(
        value("to_x") - value("from_x"),
        value("to_y") - value("from_y")
      );

      if (result) result.textContent = distance.toFixed(2);
    });
  });
}

export { initDistanceCalculator };
