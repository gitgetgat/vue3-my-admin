<script setup lang="ts">
import { getCurrentInstance } from 'vue'
import { onMounted } from 'vue'

onMounted(() => {
  const instance = getCurrentInstance()
  console.log(instance?.appContext.config.globalProperties.$helper)
  console.log(import.meta.env)
})
</script>

<template>
  <router-view></router-view>
</template>

<style scoped></style>
