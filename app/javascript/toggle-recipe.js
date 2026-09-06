function toggleRecipe(el) {
  const details = el.parentNode.querySelector('.recipe-details');
  details.style['display'] = details.style['display'] === 'none' ? 'block' : 'none';
}

export { toggleRecipe };