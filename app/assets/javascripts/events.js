window.onload = function () {
  console.log("events page loaded");

  currentCharacterId = document.getElementById('current_character').dataset.id;

  setTimeout(clearErrors, 4000);

  App.cable.subscriptions.create({ channel: "CharacterChannel", character_id: currentCharacterId }, {
    received(data) {
      switch (data.type) {
        case 'event':
          dispatch_event(data.event_id, currentCharacterId);
          break;
        case 'project':
          dispatch_project(data.id, data.progress);
          break;
        case 'project.end':
          dispatch_end_project(data.project_id);
          break;
        default:
          console.log(data);
      }
    }
  })

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
}