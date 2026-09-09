import { dispatchEvent } from './dispatch-event.js';
import { dispatchProgress, dispatchEndProject } from './dispatch-projects.js';
import { createConsumer } from "@rails/actioncable";
import { type EventData } from "../types/event-data.js";

function initCharacterChannel() {
  const currentCharacterId = document.getElementById('current_character')?.dataset.id;

  if (!currentCharacterId) {
    return;
  }

  console.log("initializing character channel...");
  const consumer = createConsumer();

  consumer.subscriptions.create({ channel: "CharacterChannel", character_id: currentCharacterId }, {
    connected() {
      console.log("Connected!!!");
    },
    received(data: EventData) {
      switch (data.type) {
        case 'event':
          console.log("Event received...");
          dispatchEvent(data.event_id, currentCharacterId);
          break;
        case 'project':
          if (!data.id || !data.progress) break;

          dispatchProgress(data.id, String(data.progress));
          break;
        case 'project.end':
          if (!data.project_id) break;

          dispatchEndProject(data.project_id);
          break;
        default:
          console.log(data);
      }
    }
  })
};

export { initCharacterChannel };