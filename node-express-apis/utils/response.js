/**
 * @description 自定义 404 错误类
 */
class NotFoundError extends Error {
  constructor(message) {
    super(message);
    this.name = 'NotFoundError';
  }
}

/**
 * @description 请求成功的返回值
 */
function resSuccess(res, message, data = {}, code = 200) {
  res.status(code).json({
    status: true,
    message,
    data
  });
}

/**
 * @description 请求失败的返回值
 */
function resError(res, error) {
  if (error.name === 'SequelizeValidationError') {
    return res.status(400).json({
      status: false,
      message: '创建文章失败',
      errors: error.errors.map(err => err.message)
    });
  }
  if (error.name === 'NotFoundError') {
    return res.status(404).json({
      status: false,
      message: '资源不存在',
      errors: [error.message]
    });
  }
  res.status(500).json({
    status: false,
    message: '服务器错误',
    errors: [error.message]
  });
}

module.exports = { NotFoundError, resSuccess, resError };
