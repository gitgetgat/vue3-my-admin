import { http } from '@/plugins/axios'

interface UserInfo {
  id: number
  username: string
  nickname: string
}
class UserApi {
  static async getUserInfo() {
    return http.request<UserInfo>({
      url: '/user/info',
      method: 'get'
    })
  }
}

export default UserApi