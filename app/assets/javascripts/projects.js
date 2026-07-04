function recount(currentField) {
  ratio = Number(currentField.value) / Number(currentField.dataset['amount'])

  for (let i = 0; i < currentField.form.elements.length; i++) {
    el = currentField.form.elements[i];

    if (el !== currentField && el.dataset['amount'] !== undefined) {
      el.value = el.dataset['amount'] * ratio;
    }

  }
}