function recount(currentField: HTMLInputElement) {
  if (!currentField.form) {
    return;
  }

  const isNumber = ((currentField.value.trim() !== "") && Number.isInteger(Number(currentField.value)))

  const ratio = Number(currentField.value) / Number(currentField.dataset['amount']);
  const elements = currentField.form.elements;

  for (let element of elements) {
    if (
      element instanceof HTMLInputElement &&
      !(element == currentField) &&
      !(element.type == 'submit')
    ) {
      if (isNumber) {
        let amount = Number(element.dataset['amount']) * ratio;

        if (element.id == 'days') {
          var strAmount = Math.ceil(amount * 4) / 4;
        } else {
          var strAmount = Math.floor(amount);
        }

        element.value = String(strAmount);
      } else {
        element.value = '';
      }
    }
  }
};

export { recount };