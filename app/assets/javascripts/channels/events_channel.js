window.onload = function () {
  locationId = document.getElementById('events').dataset.locationId;
  currentCharacterId = document.getElementById('current_character').dataset.id;

  console.log(`consumer started for location: ${locationId}`);
  console.log(`consumer started for characterId: ${currentCharacterId}`);

  App.cable.subscriptions.create({ channel: "EventsChannel", location_id: locationId }, {
    received(data) {
      console.log("data received");
      console.log(data);

      fetch(`/api/events/${data.id}?character_id=${currentCharacterId}`)
        .then(response => {
          if (!response.ok) {
            throw new Error("Network response was not ok");
          }
          return response.json();
        })
        .then(data => {
          this.appendLine(data["event"])
        })
        .catch(error => {
          console.error("There was a problem with the fetch operation:", error);
        });

    },

    appendLine(event) {
      const html = this.createLine(event)
      const element = document.getElementById("event-list")
      element.insertAdjacentHTML("afterBegin", html)
    },

    createLine(event) {
      console.log(event);
      return `
        <div>
          ${event["created_at"]}
        </div>
        <div>
          ${event["lead"]}
        </div>
        <div>
          ${event["body"]}
        </div>
      `
    }
  })
}