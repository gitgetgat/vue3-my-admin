import _ from 'lodash'

export function parseEnv(env: Record<string, any>): ViteEnv | ImportMetaEnv {
  const _env: any = _.cloneDeep(env)
  for (const key in _env) {
    _env[key] = parseEnvValue(_env[key])
  }
  return _env
}

export function parseEnvValue(value: string) {
  // 如果是布尔字符串则转换为布尔类型
  if (value === 'true') return true
  if (value === 'false') return false
  if (value === 'null') return null
  if (value === 'undefined') return undefined
  // 如果是数值字符串则转换为数值类型
  if (!isNaN(Number(value))) return Number(value)
  return value
}

const helper = new (class {
  public env = {} as ViteEnv | ImportMetaEnv
  constructor() {
    this.env = parseEnv(import.meta.env)
  }
})()

export default helper