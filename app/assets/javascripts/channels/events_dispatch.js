function dispatch_event(event_id, character_id) {
  fetch(`/api/events/${event_id}?character_id=${character_id}`)
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(data => {
      appendLine(data["event"]);
      document.getElementById("submit-body").value = '';
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error);
    }
    );
};

function appendLine(event) {
  const html = createLine(event)
  const element = document.getElementById("event-list")
  element.insertAdjacentHTML("afterBegin", html)
};

function createLine(event) {
  console.log(event);

  const lead = event["lead"] ? `<div>
          ${event["lead"]}
        </div>` : '';

  return `
        <div>
          ${event["created_at"]}
        </div>
        ${lead}
        <div>
          ${event["body"]}
        </div>
      `
};