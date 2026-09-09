function dispatchProgress(id: number, progress: string) {
  const element = document.getElementById(`percent-${id}`)

  if (!element) {
    return;
  }

  element.innerHTML = progress;
};


function dispatchEndProject(id: number) {
  document.querySelector(`[data-project-id="${id}"]`)?.remove();
};

export { dispatchProgress, dispatchEndProject };