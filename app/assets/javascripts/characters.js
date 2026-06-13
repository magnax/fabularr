window.onload = function () {
  console.log("character list page loaded");

  currentUserId = document.getElementById('current_user').dataset.id;

  setTimeout(clearErrors, 4000);
  setInterval(checkEvents, 10000);

  subscribeTime();
}