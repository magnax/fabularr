import { recount } from './recount.ts';
import { toggleRecipe } from './toggle-recipe.ts';
import clearErrors from './helpers/clear-errors.ts';
import { initNameLinks } from './helpers/init-name-links.ts';
import { initSubmitButton } from './helpers/init-submit-button.ts';
import { initCharacterList } from './helpers/init-character-list.ts';
import { initCharacterChannel } from './channels/init-character-channel.ts';
import { subscribeTime } from './channels/subscribe-time.ts';
import Rails from '@rails/ujs';
import { enableTab } from './helpers/init-name-links.ts';

window.recount = recount;
window.toggleRecipe = toggleRecipe;
window.enableTab = enableTab;

Rails.start();

setTimeout(clearErrors, 4000);

document.addEventListener("DOMContentLoaded", () => {
  initSubmitButton();
  initNameLinks();
  subscribeTime();
  initCharacterChannel();
  initCharacterList();
});