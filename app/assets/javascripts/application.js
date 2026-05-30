//= require channels
//= require rails-ujs

function clearErrors() {
  try {
    document.querySelector('.alert').remove();
  } catch (_error) { }
}

function checkEvents() {
  fetch(`/api/events/unread?user_id=${currentUserId}`)
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(data => {
      for (r in data) {
        td = document.querySelector(`tr[id="char_${r}"] td.name`);
        if (data[r] > 0) {
          td.classList.add('bold');
          ec = td.querySelector('.events-count')
          ec.style['visibility'] = 'visible';
          ec.innerText = data[r];
        }
      }
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error);
    });
}