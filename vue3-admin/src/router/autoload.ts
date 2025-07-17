import type { RouteRecordRaw } from 'vue-router'
import type { DefineComponent } from 'vue'


const AUTO_LOAD_ROUTE = true
const layoutModules = import.meta.glob('../layouts/*.vue')
const views = import.meta.glob('../views/**/*.vue')

/**
 * 异步获取所有路由
 * 
 * 该函数通过遍历布局模块并获取每个模块对应的路由信息，最终汇总成完整的路由列表
 * 使用 Promise.all 确保所有路由信息的获取是并发执行的，提高效率
 */
async function getRoutes() {
  // 初始化布局路由数组
  const layoutRoutes = [] as RouteRecordRaw[]
  // 使用 Promise.all 并行处理布局模块的遍历和路由信息的获取
  await Promise.all(Object.entries(layoutModules).map(async ([key, value]) => {
    // 调用 getRoute 函数获取当前模块的路由信息，并等待结果
    const route = await getRoute(key, value)

    if (route) {
      // 将获取到的路由信息添加到布局路由数组中
      route.children = await getChildRoutes(route) as RouteRecordRaw[]

      layoutRoutes.push(route)
    }
  }))


  return layoutRoutes
}

/**
 * 异步获取路由配置
 * @param key - 路由组件的路径字符串，用于提取路由名称
 * @param value - 一个返回Promise的函数，用于动态导入路由组件
 * @returns 返回一个异步路由配置对象
 *
 * 该函数根据给定的路由组件路径和动态导入函数，构建并返回一个路由配置对象
 * 主要用于动态加载路由组件，提高应用的性能和用户体验
 */
async function getRoute(key: string, value: any) {
  console.log(key);
  // 提取路由名称，例如从'path/to/Component.vue'中提取出'Component'
  const name = key.replace(/.*\/([^/]+)\.vue/, '$1')

  const path = key.replace(/.+layouts\/|.+views\/|\.vue/gi, '')

  // 动态导入路由组件，提高应用的加载性能
  const component = await (value() as Promise<{ default: DefineComponent }>)

  // 检查组件是否配置了 autoLoadRoute 为 false
  if (component.default.autoLoadRoute !== undefined && component.default.autoLoadRoute === false) return null

  // 构建并返回路由配置对象
  const route = {
    path: `/${path}`, // 路由路径
    name, // 路由名称
    component: component.default, // 路由组件
  } as RouteRecordRaw

  return route
}

async function getChildRoutes(layoutRoute: RouteRecordRaw) {
  const childRoutes = [] as RouteRecordRaw[]

  await Promise.all(Object.entries(views).map(async ([filePath, module]) => {
    if (filePath.includes(`../views/${layoutRoute.name as string}/`)) {
      const route = await getRoute(filePath, module) as RouteRecordRaw
      if (route) childRoutes.push(route)
    }
  }))

  return childRoutes
}

export default AUTO_LOAD_ROUTE ? await getRoutes() : []