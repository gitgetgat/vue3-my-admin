
import vue from '@vitejs/plugin-vue'
import tailwindcss from "@tailwindcss/vite"
import type { Plugin } from 'vite'
import setupMock from './mock'

export default function setupVitePlugins(isBuild: boolean, envs: ViteEnv) {
  const plugins = [vue(), tailwindcss()] as Plugin[]
  plugins.push(setupMock(isBuild))
  return plugins
}
