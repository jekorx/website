# JS 常用工具方法

#### 日期格式化

```javascript
/**
 * 日期格式化
 * dateFormat(new Date(), 'yyyy-MM-dd HH:mm:ss') // 2020-01-02 12:12:12
 * 
 * @param {Date} date 日期
 * @param {String} fmt 格式
 * @returns {String} 如：2020-01-02 12:12:12
 */
export const dateFormat = (date, fmt = 'yyyy-MM-dd HH:mm:ss') => {
  const o = {
    'M+': date.getMonth() + 1, // 月份
    'd+': date.getDate(), // 日
    'h+': date.getHours() % 12 === 0 ? 12 : date.getHours() % 12, // 小时
    'H+': date.getHours(), // 小时
    'm+': date.getMinutes(), // 分
    's+': date.getSeconds(), // 秒
    'q+': Math.floor((date.getMonth() + 3) / 3), // 季度
    'S': date.getMilliseconds() // 毫秒
  }
  const week = {
    '0': '/u65e5',
    '1': '/u4e00',
    '2': '/u4e8c',
    '3': '/u4e09',
    '4': '/u56db',
    '5': '/u4e94',
    '6': '/u516d'
  }
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
  }
  if (/(E+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? '/u661f/u671f' : '/u5468') : '') + week[date.getDay() + ''])
  }
  for (let k in o) {
    if (new RegExp('(' + k + ')').test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)))
    }
  }
  return fmt
}
```

#### 时间字符串转换为xx时间前

```javascript
/**
 * 时间字符串转换为xx时间前
 * getTimeInfo('2020-01-02 12:12:12') // 2月前
 * 
 * @param {String} dateStr 日期字符串
 * @returns {String} 如：5天前
 */
export const getTimeInfo = dateStr => {
  if (!dateStr) return ''
  if (dateStr.includes('-')) {
    // ios无法使用yyyy-MM-dd HH:mm:ss转换为Date，需将 - 替换为 /
    dateStr = dateStr.replace(/-/g, '/')
  }
  const date = new Date(dateStr)
  const now = new Date()
  const time = now.getTime() - date.getTime() // 现在的时间-传入的时间 = 相差的时间（单位 = 毫秒）
  if (time < 0) return ''
  if (time / 1000 < 60) return '刚刚'
  if (time / 60000 < 60) return Math.floor(time / 60000) + '分钟前'
  if (time / 3600000 < 24) return Math.floor(time / 3600000) + '小时前'
  if (time / 86400000 < 31) return Math.floor(time / 86400000) + '天前'
  if (time / 2592000000 < 12) return Math.floor(time / 2592000000) + '月前'
  return Math.floor(time / 31536000000) + '年前'
}
```

#### 手机号中间四位隐藏为 *

```javascript
/**
 * 手机号中间四位 *
 * @param {String}  phone 手机号
 * @returns {String} 如：188****8888
 */
export const hidePhone= phone => {
  const arr = phone.split('')
  arr.splice(3, 4, '****')
  return arr.join('')
}
```

#### 七牛上传

```javascript
import * as qiniu from 'qiniu-js'
import vueCookies from 'vue-cookies'
import uuid from 'uuid'
import axios from '@/libs/api.request'

/**
 * 七牛上传
 * dependencies: {
 *   qiniu-js,
 *   uuid,
 *   vue-cookies
 * }
 * 图片处理（裁剪大小、缩略图等）https://developer.qiniu.com/dora/manual/3683/img-directions-for-use
 *
 * @param {File} file 上传的文件
 * @param {Function} complete 上传完成处理
 * @param {Function} next 上传中处理（进度条等）
 * @param {Function} error 上传错误处理
 *
 * @return { String } 文件名称
 */
// 相关参数
const UPTOKEN = 'uptoken' // uptoken 存储cookie的key
const REQUEST_URL = '/upload/v1/uptoken' // 系统后端获取uptoken请求url
const REGION = qiniu.region.z0 // 七牛云存储区域，默认z0：华东
// 上传处理
const uploadHandler = (token, file, complete, next, error) => {
  // 文件名为uuid生成，无后缀
  const fileName = uuid()
  const observable = qiniu.upload(file, fileName, token, {}, { region: REGION })
  observable.subscribe({
    next (res) { next && next(res) },
    error (err) { error && error(err) },
    complete (res) { complete && complete(res) }
  })
}
// 获取token，上传
export default (file, complete, next, error) => {
  let token = vueCookies.get(UPTOKEN)
  if (token === null || token === undefined) {
    axios.request({
      url: REQUEST_URL,
      method: 'post'
    }).then(({ code, data }) => {
      if (code === 1) {
        vueCookies.set(UPTOKEN, data, '3500s')
        token = data
        uploadHandler(token, file, complete, next, error)
      }
    })
  } else {
    uploadHandler(token, file, complete, next, error)
  }
}

```

#### 滚动条滚动动画

```javascript
/**
 * 滚动条滚动动画
 * scrollTo(window, 0, 1000)
 * 
 * @param {HTMLDOM | window} el 滚动对象
 * @param {Number} from 滚动开始位置
 * @param {Number} to 滚动结束位置
 * @param {Number} duration 间隔时间
 * @param {Function} endCallback 动画结束回调
 */
export const scrollTo = (el, from, to = 0, duration = 500, endCallback) => {
  if (!window.requestAnimationFrame) {
    window.requestAnimationFrame = (
      window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      function (callback) {
        return window.setTimeout(callback, 1000 / 60)
      }
    )
  }
  const difference = Math.abs(from - to)
  const step = Math.ceil(difference / duration * 50)

  const scroll = (start, end, step) => {
    if (start === end) {
      endCallback && endCallback()
      return
    }

    let d = (start + step > end) ? end : start + step
    if (start > end) {
      d = (start - step < end) ? end : start - step
    }

    if (el === window) {
      window.scrollTo(d, d)
    } else {
      el.scrollTop = d
    }
    window.requestAnimationFrame(() => scroll(d, end, step))
  }
  scroll(from, to, step)
}
```

#### base64转file

```javascript
/**
 * base64转file
 *
 * @param {String} dataURL base64
 * @param {String} filename 文件名，如：image.png
 * @returns {File} 返回File对象
 */
export const dataURLtoFile = (dataURL, filename) => {
  const arr = dataURL.split(',')
  const mime = arr[0].match(/:(.*?);/)[1]
  const bstr = atob(arr[1])
  let n = bstr.length
  const u8arr = new Uint8Array(n)
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n)
  }
  return new File([u8arr], filename, { type: mime })
}
```

#### base64转blob

```javascript
/**
 * base64转blob
 *
 * @param {String} dataURL base64
 * @returns {Blob} 返回Blob对象
 */
export const dataURLToBlob = dataURL => {
  const arr = dataURL.split(',')
  const mime = arr[0].match(/:(.*?);/)[1]
  const bstr = atob(arr[1])
  let n = bstr.length
  const u8arr = new Uint8Array(n)
  while (n--) {
    u8arr[n] = bstr.charCodeAt(n)
  }
  return new Blob([u8arr], { type: mime })
}
```

#### blob转file

```javascript
/**
 * blob转file
 *
 * @param {Blob} blob Blob对象
 * @param {String} filename 文件名，如：image.png
 * @returns {File} 返回File对象
 */
export const blobToFile = (blob, filename) => {
  blob.lastModifiedDate = new Date()
  blob.name = filename
  return blob
}
```