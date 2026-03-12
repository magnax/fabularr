window.onload = function () {
  console.log("events page loaded");

  locationId = document.getElementById('events').dataset.locationId;
  currentCharacterId = document.getElementById('current_character').dataset.id;

  App.cable.subscriptions.create({ channel: "LocationChannel", location_id: locationId }, {
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