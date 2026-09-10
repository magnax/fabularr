import { type DisplayEvent } from "../types/event-data";

async function dispatchEvent(event_id: number, character_id: number) {
  try {
    const response = await fetch(`/api/events/${event_id}?character_id=${character_id}`)
    if (!response.ok) throw new Error("Network response was not ok");

    const data: { event: DisplayEvent } = await response.json();
    appendLine(data.event);

    const element = document.querySelector<HTMLTextAreaElement>("#submit-body");
    if (!element) return;

    element.value = '';
  } catch (error) {
    console.error("There was a problem with the fetch operation:", error);
  }
};

function appendLine(event: DisplayEvent) {
  const html = createLine(event)
  const element = document.getElementById("event-list")

  if (!element) return;

  element.insertAdjacentHTML("afterbegin", html)
};

function createLine(event: DisplayEvent) {
  console.log(event);

  return `
        <div class="event">      
        <span class="event-date">
          ${event.created_at}
        </span>
        <span>
          ${event.body}
        </span>
        </div>
      `
};

export { dispatchEvent };