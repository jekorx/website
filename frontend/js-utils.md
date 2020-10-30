# JS 常用工具方法

#### 类型判断

```javascript
// 以下为更精确的判断方式，某些场景下比使用 typeof & instanceof 更高效、准确
// 判断变量是注意非undefined，toString.call(person) // person is not defined
toString.call(() => {})     // [object Function]
toString.call({})           // [object Object]
toString.call([])           // [object Array]
toString.call('str')           // [object String]
toString.call(123)          // [object Number]
toString.call(undefined)    // [object undefined]
toString.call(null)         // [object null]
toString.call(new Date())     // [object Date]
toString.call(Math)         // [object Math]
toString.call(window)       // [object Window]
toString.call(document)     // [object HTMLDocument]
toString.call(Symbol())     // [object Symbol]
```

#### 日期格式化

```javascript
/**
 * @description 日期格式化
 * @description dateFormat(new Date(), 'yyyy-MM-dd EEE HH:mm:ss') // 2020-01-02 星期四 12:12:12
 * @description dateFormat(new Date(), 'yyyy-MM-dd EE HH:mm:ss') // 2020-01-02 周四 12:12:12
 *
 * @param {Date|String|Number} date 日期
 * @param {String} fmt 格式
 * @returns {String} 如：2020-01-02 12:12:12
 */
export const dateFormat = (date, fmt = 'yyyy-MM-dd HH:mm:ss') => {
  if (!date) return ''
  // 不为Date类型进行处理
  if (toString.call(date) !== '[object Date]') {
    // 判断数字时间戳
    if (!isNaN(date)) {
      // 10位时间戳转13位
      date = date + ''
      if (date.length === 10) {
        date = +date * 1000
      } else if (date.length === 13) {
        // 字符串时间戳转数字时间戳
        date = +date
      } else {
        // 时间戳格式错误返回''
        return ''
      }
    } else if (toString.call(date) === '[object String]') {
      // ios无法使用yyyy-MM-dd HH:mm:ss转换为Date，需将 - 替换为 /
      date = date.replace(/-/g, '/')
    }
    date = new Date(date)
    if (isNaN(date)) return ''
  }
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
  // 星期
  const week = ['日', '一', '二', '三', '四', '五', '六']
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
  }
  if (/(E+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? '星期' : '周') : '') + week[+date.getDay()])
  }
  for (const k in o) {
    if (new RegExp('(' + k + ')').test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)))
    }
  }
  return fmt
}
```

#### 时间转换为xx时间前

```javascript
/**
 * @description 时间转换为xx时间前
 * @description getTimeInfo('2020-01-02 12:12:12') // 2月前
 *
 * @param {Date|String|Number} date 时间
 * @returns {String} 如：5天前
 */
export const getTimeInfo = date => {
  if (!date) return ''
  // 不为Date类型进行处理
  if (toString.call(date) !== '[object Date]') {
    // 判断数字时间戳
    if (!isNaN(date)) {
      // 10位时间戳转13位
      date = date + ''
      if (date.length === 10) {
        date = +date * 1000
      } else if (date.length === 13) {
        // 字符串时间戳转数字时间戳
        date = +date
      } else {
        // 时间戳格式错误返回''
        return ''
      }
    } else if (toString.call(date) === '[object String]') {
      // ios无法使用yyyy-MM-dd HH:mm:ss转换为Date，需将 - 替换为 /
      date = date.replace(/-/g, '/')
    }
    date = new Date(date)
    if (isNaN(date)) return ''
  }
  const now = new Date()
  const diff = now.getTime() - date.getTime() // 现在的时间-传入的时间 = 相差的时间（单位 = 毫秒）
  if (diff < 0) return ''
  if (diff / 1000 < 60) return '刚刚'
  if (diff / 60000 < 60) return Math.floor(diff / 60000) + '分钟前'
  if (diff / 3600000 < 24) return Math.floor(diff / 3600000) + '小时前'
  if (diff / 86400000 < 31) return Math.floor(diff / 86400000) + '天前'
  // if (diff / 2592000000 < 12) return Math.floor(diff / 2592000000) + '月前'
  // return Math.floor(diff / 31536000000) + '年前'
  return dateFormat(date)
}
```

#### 手机号中间四位隐藏为 *

```javascript
/**
 * @description 手机号中间四位 *
 *
 * @param {String}  phone 手机号
 * @returns {String} 如：188****8888
 */
export const hidePhone = phone => {
  if (!phone) return ''
  const arr = phone.split('')
  arr.splice(3, 4, '****')
  return arr.join('')
}
```

#### 七牛上传

```javascript
import * as qiniu from 'qiniu-js'
import Cookies from 'js-cookie'
import { v1 as uuidv1 } from 'uuid'
import axios from '@/libs/request'

/**
 * @description 七牛上传
 * dependencies: {
 *   qiniu-js,
 *   uuid,
 *   js-cookie
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
  const fileName = uuidv1()
  const observable = qiniu.upload(file, fileName, token, {}, { region: REGION })
  observable.subscribe({
    next (res) { next && next(res) },
    error (err) { error && error(err) },
    complete (res) { complete && complete(res) }
  })
}
// 获取token，上传
export default (file, complete, next, error) => {
  let token = Cookies.get(UPTOKEN)
  if (token === null || token === undefined) {
    axios.request({
      url: REQUEST_URL,
      method: 'post'
    }).then(({ code, data }) => {
      if (code === 1) {
        const date = new Date()
        date.setSeconds(date.getSeconds() + 3500)
        Cookies.set(UPTOKEN, data, { expires: date })
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
 * @description 滚动条滚动动画
 * @description scrollTo(window, 0, 1000)
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
 * @description base64转file
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
 * @description base64转blob
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
 * @description blob转file
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

#### 绑定事件

```javascript
/**
 * @description 绑定事件 eventOn(element, event, handler)
 * @description eventOn(window, 'scroll', this.scroll)
 *
 * @param {HTMLDOM | window} element 绑定对象
 * @param {String} event 事件名称，如：scroll
 * @param {Function} handler 事件方法
 */
export const eventOn = (function () {
  // ssr中使用注意服务端无效
  if (typeof window === 'undefined') return
  if (document.addEventListener) {
    return function (element, event, handler) {
      if (element && event && handler) {
        element.addEventListener(event, handler, false)
      }
    }
  } else {
    return function (element, event, handler) {
      if (element && event && handler) {
        element.attachEvent('on' + event, handler)
      }
    }
  }
})()
```

#### 解绑事件

```javascript
/**
 * @description 解绑事件 eventOff(element, event, handler)
 * @description eventOff(window, 'scroll', this.scroll)
 *
 * @param {HTMLDOM | window} element 解绑对象
 * @param {String} event 事件名称，如：scroll
 * @param {Function} handler 事件方法
 */
export const eventOff = (function () {
  // ssr中使用注意服务端无效
  if (typeof window === 'undefined') return
  if (document.removeEventListener) {
    return function (element, event, handler) {
      if (element && event) {
        element.removeEventListener(event, handler, false)
      }
    }
  } else {
    return function (element, event, handler) {
      if (element && event) {
        element.detachEvent('on' + event, handler)
      }
    }
  }
})()
```

#### 连字符转驼峰

```javascript
/**
 * @description 连字符转驼峰
 * @description toCamelCase('hello_world', '_') // helloWorld
 *
 * @param {String} str 连字符字符串
 * @param {String} separator 分隔符，默认为'-'，可不传
 * @returns {String} 如：helloWorld
 */
export const toCamelCase = (str = '', separator = '-') => {
  if (toString.call(str) !== '[object String]') {
    throw new Error('Argument must be a string')
  }
  if (str === '') {
    return str
  }
  const regExp = new RegExp(`\\${separator}(\\w)`, 'g')
  return str.replace(regExp, (matched, $1) => $1.toUpperCase())
}
```

#### 驼峰转连字符

```javascript
/**
 * @description 驼峰转连字符
 * @description fromCamelCase('helloWorld', '_') // hello_world
 *
 * @param {String} str 驼峰字符串
 * @param {String} separator 分隔符，默认为'-'，可不传
 * @returns {String} 如：hello_world
 */
export const fromCamelCase = (str = '', separator = '-') => {
  if (toString.call(str) !== '[object String]') {
    throw new Error('Argument must be a string')
  }
  if (str === '') {
    return str
  }
  return str.replace(/([A-Z])/g, `${separator}$1`).toLowerCase()
}
```

#### 文件尺寸格式化

```javascript
/**
 * @description 文件尺寸格式化
 * @description formatSize(10240000) // 9.77MB
 *
 * @param {String | Number} size 字节数
 * @returns {String} 如：9.77MB
 */
export const formatSize = size => {
  if (toString.call(size) !== '[object Number]') {
    throw new Error('Argument(s) is illegal !')
  }
  const unitsHash = 'B,KB,MB,GB,TB,PB,EB,ZB,YB'.split(',')
  let index = 0
  while (size > 1024 && index < unitsHash.length) {
    size /= 1024
    index++
  }
  return Math.round(size * 100) / 100 + unitsHash[index]
}
```

#### 获取指定范围内的随机数

```javascript
/**
 * @description 获取指定范围内的随机数
 * @description getRandom(0, 10) // 9
 *
 * @param {Number} min 最小范围，包含
 * @param {Number} max 最大范围，包含
 * @returns {Number} 如：9
 */
export const getRandom = (min = 0, max = 100) => {
  if (toString.call(min) !== '[object Number]' || toString.call(max) !== '[object Number]') {
    throw new Error('Argument(s) is illegal !')
  }
  if (min > max) {
    [min, max] = [max, min]
  }
  return Math.floor(Math.random() * (max - min + 1) + min)
}
```

#### 打乱数组

```javascript
/**
 * @description 打乱数组
 * @description arrayShuffle([1, 2, 3]) // [2, 1, 3]
 *
 * @param {Array} array 待乱序数组
 * @returns {Array} 如：[2, 1, 3]
 */
export const arrayShuffle = array => {
  if (!Array.isArray(array)) {
    throw new Error('Argument must be an array')
  }
  let end = array.length
  if (!end) {
    return array
  }
  while (end) {
    const start = Math.floor(Math.random() * end--);
    [array[start], array[end]] = [array[end], array[start]]
  }
  return array
}
```

#### 获取Url参数

```javascript
/**
 * @description 获取Url参数，注意：获取的参数值均为String类型
 * @description getUrlParam('f', 'https://www.baidu.com/s?ie=utf-8&f=8') // '8'
 *
 * @param {String} variable 需要获取的参数名，传空值或者null会获取参数Object
 * @param {String} url url，默认为当前url
 * @returns {Object | String | Null} 如：variable为空值或null：{ ie: 'utf-8', f: '8' }，未查找到的参数或url无参数返：null，variable有值查询具体参数返回String类型值
 */
export const getUrlParam = (variable = '', url = window.location.href) => {
  if (url === '' || !url.includes('=')) return null
  const query = url.substr(url.lastIndexOf('?') + 1)
  const vars = query.split('&')
  if (!variable) {
    return vars.reduce((params, v) => {
      const pair = v.split('=')
      params[pair[0]] = pair[1]
      return params
    }, {})
  }
  for (const v of vars) {
    const pair = v.split('=')
    if (pair[0] === variable) return pair[1]
  }
  return null
}
```