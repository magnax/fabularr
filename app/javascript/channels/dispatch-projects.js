function dispatchProgress(id, progress) {
  const element = document.getElementById(`percent-${id}`)
  element.innerHTML = progress;
};


function dispatchEndProject(id) {
  document.querySelector(`[data-project-id="${id}"]`).remove();
};

export { dispatchProgress, dispatchEndProject };