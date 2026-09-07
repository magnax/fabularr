function toggleRecipe(el: HTMLElement) {
  const details = el.parentNode?.querySelector<HTMLElement>('.recipe-details');

  if (details == null) {
    return;
  }

  details.style.display = details.style.display === 'none' ? '' : 'none';
}

export { toggleRecipe };