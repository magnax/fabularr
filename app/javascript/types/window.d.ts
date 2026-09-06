export { };

declare global {
  interface Window {
    recount: typeof import("../recount.js").recount;
    toggleRecipe: typeof import("../toggle-recipe.js").toggleRecipe;
    initCharacter: any;
  }
}