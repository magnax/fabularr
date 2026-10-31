function initDistanceCalculator() {
  const text_inputs = document.querySelectorAll<HTMLInputElement>('.distance-input');

  if (!text_inputs) return;

  try {
    for (let text_input of text_inputs) {

      text_input.addEventListener("keyup", async (event) => {
        event.preventDefault();

        const fromX = document.getElementById('from_x') as HTMLInputElement;
        const fromXValue: number = Number(fromX?.value) || 0;

        const fromY = document.getElementById('from_y') as HTMLInputElement;
        const fromYValue: number = Number(fromY?.value) || 0;

        const toX = document.getElementById('to_x') as HTMLInputElement;
        const toXValue: number = Number(toX?.value) || 0;

        const toY = document.getElementById('to_y') as HTMLInputElement;
        const toYValue: number = Number(toY?.value) || 0;

        const distance = Math.sqrt(
          Math.pow(toXValue - fromXValue, 2) +
          Math.pow(toYValue - fromYValue, 2)
        )

        const resultSpan = document.getElementById('distance-result');
        if (resultSpan) {
          resultSpan.textContent = String(Math.round(distance * 100) / 100);
        }
      })
    }
  } catch (error) {
    console.log("error!");
  }
}

export { initDistanceCalculator }