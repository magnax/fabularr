function initCharacterList() {
  if (!document.getElementById('current_user')) {
    return;
  }

  console.log("character list page loaded");
  setInterval(checkEvents, 10000);
};

async function checkEvents() {
  const currentUserId = document?.getElementById('current_user')?.dataset.id;

  if (!currentUserId) return;

  try {
    const response = await fetch(`/api/events/unread?user_id=${currentUserId}`)

    if (!response.ok) throw new Error("Network response not ok!");

    const data = await response.json();
    for (let r in data) {
      let td = document.querySelector<HTMLElement>(`tr[id="char_${r}"] td.name`);
      if (td && data[r] > 0) {
        td.classList.add('bold');
        let ec = td.querySelector<HTMLElement>('.events-count')
        if (ec) {
          ec.style.visibility = 'visible';
          ec.innerText = data[r];
        }
      }
    }
  } catch (error) {
    console.error("There was a problem with the fetch operation:", error);
  }
};

export { initCharacterList };