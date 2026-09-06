import { recount } from './recount.js';
import { toggleRecipe } from './toggle-recipe.js';
import clearErrors from './helpers/clear-errors.ts';
import { initSubmitButton } from './helpers/init-submit-button.js';
import { initCharacterList } from './helpers/init-character-list.js';
import { initCharacterChannel } from './channels/init-character-channel.js';
import { subscribeTime } from './channels/subscribe-time.js';
import Rails from '@rails/ujs';

window.recount = recount;
window.toggleRecipe = toggleRecipe;

Rails.start();

setTimeout(clearErrors, 4000);

document.addEventListener("DOMContentLoaded", () => {
  initSubmitButton();
  subscribeTime();
  initCharacterChannel();
  initCharacterList();
});