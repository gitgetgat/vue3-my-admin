<script setup lang="ts">
import { getCurrentInstance } from 'vue'
import { onMounted } from 'vue'
import userApi from '@/api/user'

onMounted(async () => {
  const instance = getCurrentInstance()
  console.log(instance?.appContext.config.globalProperties.$helper)
  console.log(import.meta.env)
  const res = await userApi.getUserInfo()
  console.log(res.data?.id)
})
</script>

<template>
  <router-view></router-view>
</template>

<style scoped></style>
