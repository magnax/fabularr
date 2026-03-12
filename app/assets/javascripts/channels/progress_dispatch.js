function dispatch_project(id, progress) {
  const element = document.getElementById(`percent-${id}`)
  element.innerHTML = progress;
}

function dispatch_end_project(id) {
  document.querySelector(`[data-project-id="${id}"]`).remove();
}