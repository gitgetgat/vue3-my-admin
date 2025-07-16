import path from "path";
import type { AliasOptions } from "vite";

const alias = {
  "@": path.resolve(__dirname, "../src"),
  "@layouts": path.resolve(__dirname, "../src/layouts"), // 布局
  "@views": path.resolve(__dirname, "../src/views"), // 页面
  "@components": path.resolve(__dirname, "../src/components"), // 组件
} as AliasOptions

export default alias
