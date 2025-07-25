import axios, { type AxiosRequestConfig } from "axios"

class Axios {
  private instance
  constructor(config: AxiosRequestConfig) {
    this.instance = axios.create(config)
    this.interceptors()
  }

  public request<T, R = ResponseResult<T>>(config: AxiosRequestConfig): Promise<R> {
    return new Promise<R>((resolve, reject) => {
      this.instance.request<R>(config).then(res => {
        resolve(res.data)
      }).catch(err => {
        reject(err)
      })
    })
  }

  private interceptors() {
    this.requestInterceptor()
    this.responseInterceptor()
  }

  private requestInterceptor() {
    this.instance.interceptors.request.use(
      (config) => {
        return config;
      }, (error) => {
        return Promise.reject(error);
      }
    );
  }

  private responseInterceptor() {
    this.instance.interceptors.response.use(
      (response) => {
        return response;
      }, (error) => {
        return Promise.reject(error);
      }
    );
  }
}

export const http = new Axios({
  baseURL: import.meta.env.VITE_BASE_URL,
  timeout: 10000,
})
