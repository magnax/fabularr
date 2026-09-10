function initSubmitButton() {
  const button = document.querySelector('.submit-button');

  if (!button) return;

  try {
    button.addEventListener("click", async (event) => {
      event.preventDefault();

      const bodyElement = document
        .querySelector<HTMLTextAreaElement>('#submit-body');
      const tokenElement = document
        .querySelector<HTMLInputElement>('input[name="authenticity_token"]');

      if (!bodyElement || !tokenElement) return;

      let response = await fetch('/events.json', {
        method: 'POST', headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          event: { body: bodyElement.value },
          authenticity_token: tokenElement.value
        })
      });

      if (!response.ok) throw new Error(`HTTP ${response.status}`);
    })
  } catch (error) {
    console.error('Error sending event');
  }
};

export { initSubmitButton };