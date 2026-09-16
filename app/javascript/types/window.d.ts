export { };

declare global {
  interface Window {
    recount: typeof import("../recount.ts").recount;
    toggleRecipe: typeof import("../toggle-recipe.ts").toggleRecipe;
    enableTab: typeof import("../helpers/init-name-links.ts").enableTab;
    initCharacter: any;
  }
}
