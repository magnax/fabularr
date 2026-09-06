import { recount } from './recount.js';
import clearErrors from './helpers/clear-errors.ts';
import { initCharacterChannel } from './channels/init-character-channel.js';
import { subscribeTime } from './channels/subscribe-time.js';

window.recount = recount;

setTimeout(clearErrors, 4000);

document.addEventListener("DOMContentLoaded", () => {
  subscribeTime();
  initCharacterChannel();
});