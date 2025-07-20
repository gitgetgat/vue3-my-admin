/// <reference types="vite/client" />
interface ViteEnv {
  VITE_SOME_KEY: Number
  VITE_AUTO_LOAD_ROUTE: boolean
  VITE_API_URL: string
}
interface ViteTypeOptions {
  // 添加这行代码，你就可以将 ImportMetaEnv 的类型设为严格模式，
  // 这样就不允许有未知的键值了。
  // strictImportMetaEnv: unknown
}

interface ImportMetaEnv extends ViteEnv { }

interface ImportMeta {
  readonly env: ImportMetaEnv
}