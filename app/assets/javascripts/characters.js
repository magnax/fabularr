//= require common.js

window.onload = function () {
  console.log("character list page loaded");

  currentUserId = document.getElementById('current_user').dataset.id;

  setInterval(checkEvents, 10000);
}