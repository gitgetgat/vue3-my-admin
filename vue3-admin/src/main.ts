import { createApp } from 'vue'
import App from '@/App.vue'
import router, { setupRouter } from '@/router'
import setupPlugins from '@/plugins'

// 引导
async function bootStrap() {
  const app = createApp(App)
  // 配置插件
  setupPlugins(app)
  // 配置路由
  setupRouter(app)
  await router.isReady()
  app.mount('#app')
}

bootStrap()