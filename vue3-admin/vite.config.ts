import path from "path"
import tailwindcss from "@tailwindcss/vite"
import { loadEnv, defineConfig, ConfigEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import alias from './vite/alias'

// https://vite.dev/config/
// export default defineConfig({
//   plugins: [vue(), tailwindcss()],
//   resolve: {
//     alias: {
//       "@": path.resolve(__dirname, "./src"),
//       "@layoputs": path.resolve(__dirname, "./src/layouts"), // 布局
//       "@views": path.resolve(__dirname, "./src/views"), // 页面
//     },
//   },
// })


export default ({ mode, command }: ConfigEnv) => {
  const env = loadEnv(mode, process.cwd())
  console.log(mode, command, env)
  return {
    plugins: [vue(), tailwindcss()],
    resolve: {
      alias,
    },
  }
}