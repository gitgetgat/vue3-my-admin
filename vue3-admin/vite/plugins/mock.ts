import type { Plugin } from 'vite'
import { viteMockServe } from 'vite-plugin-mock'

export default function setupMock(isBuild: boolean) {
  return viteMockServe({
    // default
    mockPath: 'mock',
    enable: !isBuild,
  }) as Plugin
}