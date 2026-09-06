function toggleRecipe(el: HTMLElement) {
  const details: HTMLElement | null =
    el?.parentNode?.querySelector('.recipe-details') || null;

  if (details !== null) {
    details.style['display'] = details.style['display'] === 'none' ? 'block' : 'none';
  }
}

export { toggleRecipe };