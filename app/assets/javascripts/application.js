//= require channels
function clearErrors() {
  try {
    document.querySelector('.alert').remove();
  } catch (_error) {

  }
}

function checkEvents() {
  console.log(currentUserId);
  fetch(`/api/events/unread?user_id=${currentUserId}`)
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(data => {
      console.log(data);
      // appendLine(data["event"]);
      // document.getElementById("submit-body").value = '';
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error);
    }
    );
}