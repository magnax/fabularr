function initCharacterList() {
  if (!document.getElementById('current_user')) {
    return;
  }

  console.log("character list page loaded");
  setInterval(checkEvents, 10000);
};

function checkEvents() {
  const currentUserId = document.getElementById('current_user').dataset.id;

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
};

export { initCharacterList };