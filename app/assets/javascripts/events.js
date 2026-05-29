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
}