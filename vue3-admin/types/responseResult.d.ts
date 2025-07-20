interface ResponseResult<T> {
  code: number; // 状态码 (200表示成功)
  message: string; // 状态消息
  data?: T; // 数据 (可选)
  timestamp?: number; // 时间戳（可选）
}