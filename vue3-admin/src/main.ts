import { createApp } from 'vue'
import '@/style.css'
import App from '@/App.vue'
import router, { setupRouter } from '@/router'

// 引导
async function bootStrap() {
  const app = createApp(App)
  setupRouter(app)
  await router.isReady()
  app.mount('#app')
}

bootStrap()