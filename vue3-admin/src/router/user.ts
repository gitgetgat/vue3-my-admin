import type { RouteRecordRaw } from 'vue-router';

export default [
  {
    path: '/user',
    name: 'User',
    component: () => import('@/layouts/userLogin.vue'),
    children: [
      {
        path: '/user/login',
        name: 'UserLogin',
        component: () => import('@/views/login.vue'),
      }
    ]
  }
] as RouteRecordRaw[]