import axios, { type AxiosRequestConfig } from "axios"

class Axios {
  private instance
  constructor(config: AxiosRequestConfig) {
    this.instance = axios.create(config)
    this.interceptors()
  }
  public request<T>(config: AxiosRequestConfig) {
    return this.instance.request<ResponseResult<T>>()
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
