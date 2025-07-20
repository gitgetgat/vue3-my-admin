import path from "path"
import { loadEnv } from 'vite'
import type { ConfigEnv } from 'vite'
import alias from './vite/alias'
import { parseEnv } from './vite/utils'
import setupVitePlugins from './vite/plugins'

// https://vite.dev/config/
export default ({ mode, command }: ConfigEnv) => {
  const isBuild = command === 'build' // 是否为构建命令
  const env = loadEnv(mode, process.cwd())
  console.log(mode, command, env)
  console.log(parseEnv(env));
  // 使用parseEnv处理环境变量并覆盖原有的env
  const parsedEnv = parseEnv(env);

  return {
    plugins: setupVitePlugins(isBuild, parsedEnv),
    resolve: {
      alias,
    },
  }
}