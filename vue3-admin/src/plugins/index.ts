import type { App } from "vue";
import setupTailwindcss from "./tailwindcss";
import helper from "../../vite/utils";

export default function setupPlugins(app: App) {
  app.config.globalProperties.$helper = helper
  setupTailwindcss(app);
}