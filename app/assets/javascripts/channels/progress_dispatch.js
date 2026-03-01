function dispatch_project(id, progress) {
  const element = document.getElementById(`percent-${id}`)
  element.innerHTML = progress;
}