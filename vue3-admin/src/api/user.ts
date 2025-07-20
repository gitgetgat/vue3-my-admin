import { http } from '@/plugins/axios'

class UserApi {
  static getUserInfo() {
    return http.request({
      url: '/user/info',
      method: 'get'
    })
  }
}

export default new UserApi()