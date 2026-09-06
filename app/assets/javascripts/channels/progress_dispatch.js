function dispatchTimeEvent(data) {
  const dd = document.getElementById('header-date-day');
  const dh = document.getElementById('header-date-hour');
  const dm = document.getElementById('header-date-minute');

  if (dd.textContent !== data.day) {
    dd.textContent = data.day;
  }

  if (dh.textContent !== data.hour) {
    dh.textContent = data.hour;
  }

  if (dm.textContent !== data.minute) {
    dm.textContent = data.minute;
  }
}