function initNameLinks() {
  try {
    document.querySelectorAll<HTMLAnchorElement>('.character-name').forEach((el) => {
      el.addEventListener("click", async (event) => {
        event.preventDefault();

        const parent = el.parentElement
        const charId = el.dataset.charId;

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

export { initNameLinks };