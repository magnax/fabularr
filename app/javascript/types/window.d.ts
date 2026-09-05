export { };

declare global {
  interface Window {
    recount: typeof import("../recount.js").recount;
  }
}