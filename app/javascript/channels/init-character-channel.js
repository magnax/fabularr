import { dispatchEvent } from './dispatch-event.js';
import { dispatchProgress, dispatchEndProject } from './dispatch-projects.js';

function initCharacterChannel() {
  if (!document.getElementById('current_character')) {
    return;
  }

  console.log("initializing character channel...");

  currentCharacterId = document.getElementById('current_character').dataset.id;

  App.cable.subscriptions.create({ channel: "CharacterChannel", character_id: currentCharacterId }, {
    connected() {
      console.log("Connected!!!");
    },
    received(data) {
      switch (data.type) {
        case 'event':
          console.log("Event received...");
          dispatchEvent(data.event_id, currentCharacterId);
          break;
        case 'project':
          dispatchProgress(data.id, data.progress);
          break;
        case 'project.end':
          dispatchEndProject(data.project_id);
          break;
        default:
          console.log(data);
      }
    }
  })
};

export { initCharacterChannel };