# Axios

> Axios 是一个基于 promise 的 HTTP 库，可以用在浏览器和 node.js 中。

#### 常用配置

```js
import axios from 'axios'
import qs from 'qs'

/**
 * axios config
 */
// url 前缀
axios.defaults.baseURL = process.env.NODE_ENV === 'production' ? '/web/' : '/api/'
/**
 * axios 默认 Content-Type: application/json;charset=UTF-8
 * 请求正文为Request Payload，格式是json格式的字符串
 * 台用@RequestParam是接收不到参数的，只能用@RequestBody
 * 配置transformRequest，参数使用qs转换
 * 请求头Content-Type会被设置为: application/x-www-form-urlencoded
 * 请求正文为Form Data，格式是key=value&key1=value2
 * 对于 Form Data 请求，后台无需任何注解，即可解析参数
 */
axios.defaults.withCredentials = true
// 请求数据转json字符串（JSON.stringify()不行）
axios.defaults.transformRequest = [params => qs.stringify(params)]
// 请求统一额外参数
axios.defaults.params = { apiuser: 'debug' }
// 请求拦截器
axios.interceptors.request.use(config => {
  // 请求发出前，可以开始加载动画之类的操作
  return config
}, error => {
  // 请求发出错误处理
  return Promise.reject(error)
})
// 响应拦截器
axios.interceptors.response.use(response => {
  // 接收到响应处理，停止加载动画之类操作
  return response
}, error => {
  // 响应错误处理，统一异常处理
  console.log(error.stack)
  return Promise.reject(error)
})
```



