import { recount } from './recount.js';
import clearErrors from './helpers/clear-errors.ts';
import { initCharacterChannel } from './channels/init-character-channel.js';

window.recount = recount;

setTimeout(clearErrors, 4000);

document.addEventListener("DOMContentLoaded", () => {
  initCharacterChannel();
});