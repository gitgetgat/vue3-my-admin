import { createRouter, createWebHistory } from 'vue-router'
import type { App } from 'vue'
import base from './base' // 基础路由
import tools from './tools' // 工具路由
import autoload from './autoload' // 自动加载路由

const router = createRouter({
  history: createWebHistory(),
  routes: [
    ...base,
    ...tools,
    ...autoload
  ]
})

// 配置路由
export function setupRouter(app: App) {
  app.use(router)
}

export default router