function recount(currentField: HTMLInputElement) {
  if (!currentField.form) {
    return;
  }

  const ratio = Number(currentField.value) / Number(currentField.dataset['amount']);
  const elements = currentField.form.elements;

  for (let element of elements) {
    if (element instanceof HTMLInputElement && !(element == currentField)) {
      let amount = Number(element.dataset['amount']) * ratio;

      if (element.id == 'days') {
        var strAmount = Math.round(amount * 100) / 100;
      } else {
        var strAmount = Math.floor(amount);
      }

      element.value = String(strAmount);
    }
  }
};

export { recount };