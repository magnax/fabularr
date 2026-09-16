function initNameLinks() {
  try {
    document.querySelectorAll<HTMLAnchorElement>('.character-name').forEach((el) => {
      el.addEventListener("click", async (event) => {
        event.preventDefault();

        const parent = el.parentElement
        const charId = el.dataset.charId;
        const nameClass = `name-char-${charId}`

        if (parent?.querySelector(`.${nameClass}`)) {
          parent?.querySelector(`.${nameClass}`)?.remove();
          return;
        }

        if (!charId) {
          console.log("NO Character ID!!");
          return;
        }

        try {
          const response = await fetch(`/api/characters/${charId}/name`);
          if (!response.ok) throw new Error("Network response was not ok");

          const data = await response.json();

          document.querySelectorAll('.name-info').forEach((el) => {
            el.remove();
          });

          const div = document.createElement('div');
          div.classList.add('name-info');
          div.classList.add(nameClass);
          div.innerHTML = data.content;

          parent?.append(div);

        } catch (error) {
          throw new Error('cannot fetch!');
        }
      })
    })
  } catch (error) {
    console.error("Cannot init links");
  }
}

function enableTab(el: HTMLElement) {
  const parent = el.parentElement;
  const tabName = el.dataset.tab;

  if (!tabName || !parent) return;

  const tab = parent.querySelector<HTMLDivElement>(`.${tabName}`);

  if (!tab) return;

  parent?.querySelectorAll<HTMLDivElement>('.tab').forEach((e) => {
    e.style.display = 'none';
  });

  tab.style.display = '';
  console.log('enabled');
}

export { initNameLinks, enableTab };