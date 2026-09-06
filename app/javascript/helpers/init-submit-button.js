function initSubmitButton() {
  if (!document.querySelector('.submit-button')) {
    return;
  }

  document.querySelector('.submit-button').addEventListener("click", (event) => {
    event.preventDefault();
    const message = document.getElementById('submit-body').value;
    const authenticity_token = document.querySelector('input[name="authenticity_token"]').value;

    fetch('/events.json', {
      method: 'POST', headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        event: { body: message },
        authenticity_token: authenticity_token
      })
    })
      .then(response => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`);

        return response.json();
      })
      .then(data => { })
      .catch(err => console.error('Error:'));
  })
};

export { initSubmitButton };