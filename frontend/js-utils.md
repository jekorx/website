# JS 常用工具方法

> [日期格式化](#日期格式化)  
> [时间转换为xx时间前](#时间转换为xx时间前)  
> [顺序执行Promise](#顺序执行promise)  
> [隐藏手机号中间四位](#隐藏手机号中间四位)  
> [限制数据框内容仅为数字](#限制数据框内容仅为数字)  
> [七牛上传](#七牛上传)  
> [滚动条滚动动画](#滚动条滚动动画)  
> [base64转file](#base64转file)  
> [base64转blob](#base64转blob)  
> [blob转file](#blob转file)  
> [绑定事件](#绑定事件)  
> [解绑事件](#解绑事件)  
> [连字符转驼峰](#连字符转驼峰)  
> [驼峰转连字符](#驼峰转连字符)  
> [文件尺寸格式化](#文件尺寸格式化)  
> [获取指定范围内的随机数](#获取指定范围内的随机数)  
> [打乱数组](#打乱数组)  
> [获取Url参数](#获取Url参数)  
> [切分数组](#切分数组)  
> [两数组差集](#两数组差集)  

#### 类型判断

```javascript
// 以下为更精确的判断方式，某些场景下比使用 typeof & instanceof 更高效、准确
// 判断变量是注意非undefined，toString.call(person) // person is not defined
toString.call(() => {})     // [object Function]
toString.call({})           // [object Object]
toString.call([])           // [object Array]
toString.call('str')        // [object String]
toString.call(123)          // [object Number]
toString.call(undefined)    // [object undefined]
toString.call(null)         // [object null]
toString.call(new Date())   // [object Date]
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

#### 顺序执行Promise

```javascript
/**
 * @description 顺序执行 Promise
 * 
 * function p1(){return new Promise((n,o)=>{setTimeout(()=>{console.warn("测试错误 1"),o({msg:"测试错误 1"})},500)})} // 测试错误 1
 * function p2(){return new Promise((n,o)=>{setTimeout(()=>{console.log("成功 2"),n({msg:"成功 2"})},600)})}          // 成功 2
 * function p3(){return new Promise((n,o)=>{setTimeout(()=>{console.warn("测试错误 3"),o({msg:"测试错误 3"})},300)})} // 测试错误 3
 * function p4(){return new Promise((n,o)=>{setTimeout(()=>{console.log("成功 4"),n({msg:"成功 4"})},400)})}          // 成功 4
 * function p5(){return new Promise((n,o)=>{setTimeout(()=>{console.warn("测试错误 5"),o({msg:"测试错误 5"})},200)})} // 测试错误 5
 *
 * const promises = [p1, p2, p3, p4, p5]
 *
 * promiseQueue(promises).then(console.log)
 * // 一次性返回结构数组
 * // 0: {msg: "测试错误 1"}
 * // 1: {msg: "成功 2"}
 * // 2: {msg: "测试错误 3"}
 * // 3: {msg: "成功 4"}
 * // 4: {msg: "测试错误 5"}
 *
 * @param {Array<Function: Promise>} 返回Promise对象的待执行方法数组
 * @returns {Array<Object>} 返回Promise对象，通过resolve获取顺序执行的结果（包含reject）
 */
export const promiseQueue = async promises => {
  const result = []
  for (const promise of promises) {
    try {
      result.push(await promise())
    } catch (error) {
      result.push(error)
    }
  }
  return Promise.resolve(result)
}
```

#### 隐藏手机号中间四位

```javascript
/**
 * @description 手机号中间四位 *
 *
 * @param {String} phone 手机号
 * @returns {String} 如：188****8888
 */
export const hidePhone = phone => {
  if (!phone) return ''
  const arr = phone.split('')
  arr.splice(3, 4, '****')
  return arr.join('')
}
```

#### 限制数据框内容仅为数字

```javascript
/**
 * @description 限制数据框内容仅为数字
 * @description 校验、匹配规则可根据需求自定义，当前为保留正整数字符串
 * 
 * 某些情况下input[type=number]、InputNumber不能完全限制输入非数字字符使用
 * 
 * 以Element-ui Input为例，num可能为数组表单中的值，所以使用传值修改
 * 
 * <Input v-model="formData.num" @input="val => inputCheck(val, formData)" />
 * 
 * inputCheck (val, formData) {
 *   formData.num = inputFilter(val)
 * }
 * 
 * @param {String} val 输入字符
 * @returns {String|Number} 过滤后数字字符串（正整数）
 */
export const inputFilter = val => {
  if (val) {
    const valArr = val.match(/[1-9]\d*/g)
    if (valArr && valArr.length > 0) {
      val = valArr[0]
    } else {
      val = ''
    }
  }
  return val
}

/**
 * 整数，保留2位小数，最大100，最小0.01
 * <input type="text" :value="value" :readonly="i === 0" @input="arrangeValue" />
 * arrangeValue (e) {
 *   let { value } = e.target
 *   // 此处对0 和 未输入完的小数不作处理
 *   if (+value === 0 || value.endsWith('.')) {
 *     return
 *   }
 *   value = +inputFilter(value)
 *   e.target.value = value
 * }
 */
const inputFilter = val => {
  if (+val >= 100) return 100
  if (+val < 0.01) return 0.01
  if (val) {
    const valArr = val.match(/[+]?\d{0,2}(\.\d{1,2})?/g)
    if (valArr && valArr.length > 0) {
      val = +valArr[0]
    } else {
      val = 1
    }
  }
  return val
}
```

#### 七牛上传

```javascript
import * as qiniu from 'qiniu-js'
import Cookies from 'js-cookie'
import uuid from 'uuid'
import $http from '@/libs/request'

/**
 * 七牛上传
 * dependencies: {
 *   qiniu-js,
 *   uuid,
 *   js-cookie
 * }
 * 图片处理（裁剪大小、缩略图等）https://developer.qiniu.com/dora/manual/3683/img-directions-for-use
 *
 * @param file 上传的文件
 * @param next 上传中处理（进度条等）
 *
 * @param then 上传完成处理
 * @param catch 上传错误处理
 *
 * @return Promise
 */
// 相关参数
const UPTOKEN = '_UPTOKEN_'
const REQUEST_URL = '/upload/v1/uptoken'
const REGION = qiniu.region.z0
// 上传处理
const uploadHandler = (token, file, next, complete, error) => {
  // 文件类型
  const typeArr = file.type.split('/')
  // uuid + .文件类型
  const fileName = `${uuid()}.${typeArr[1]}`
  const observable = qiniu.upload(file, fileName, token, {}, { region: REGION })
  observable.subscribe({
    next ({ total }) { next && next(total) },
    error (err) { error && error(err) },
    complete (res) { complete && complete(res) }
  })
}
// 获取token，上传
export default (file, next) => {
  let token = Cookies.get(UPTOKEN)
  return new Promise((resolve, reject) => {
    if (!token) {
      $http.request({
        url: REQUEST_URL,
        method: 'post'
      }).then(({ code, data }) => {
        if (code === 1) {
          const date = new Date()
          date.setSeconds(date.getSeconds() + 3500) // uptoken失效前缓存
          Cookies.set(UPTOKEN, data, { expires: date })
          token = data
          uploadHandler(token, file, next, res => resolve(res), err => reject(err))
        } else {
          reject(new Error('获取uptoken失败'))
        }
      })
    } else {
      uploadHandler(token, file, next, res => resolve(res), err => reject(err))
    }
  })
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
 * @param {String} filename 文件名（不带后缀），默认：当前时间戳
 * @returns {File} 返回File对象
 */
export const dataURLtoFile = (dataURL, filename = Date.now()) => {
  const arr = dataURL.split(',')
  const mime = arr[0].match(/:(.*?);/)[1]
  const typeArr = mime.split('/')
  if (typeArr && typeArr.length > 1) {
    filename = `${filename}.${typeArr[1]}`
  }
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
 * @param {String} filename 文件名（不带后缀），默认：当前时间戳
 * @returns {File} 返回File对象
 */
export const blobToFile = (blob, filename = Date.now()) => {
  const typeArr = blob.type.split('/')
  if (typeArr && typeArr.length > 1) {
    filename = `${filename}.${typeArr[1]}`
  }
  return new File([blob], filename, { type: blob.type })
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

#### 切分数组

```javascript
/**
 * @description 切分数组
 *
 * const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
 * splitArray(arr, 4) // [[1, 2, 3, 4], [5, 6, 7, 8], [9]]
 *
 * @param {Array} arr 带切分数组
 * @param {Number} size 切分大小
 * @returns {Array<Array>} 切分后数组
 */
export const splitArray = (arr, size = 10) => Array.from({
  length: Math.ceil(arr.length / size)
}, (v, i) =>
  arr.slice(i * size, i * size + size)
)
```

#### 两数组差集

```javascript
/**
 * @description 切分数组
 *
 * arrayDiffSet([1, 2, 3], [1, 2, 4]) // [3, 4]
 *
 * @param {Array} arr1
 * @param {Array} arr2
 * @returns {Array} 两数组差集数组
 */
export const arrayDiffSet = (a, b) => [...a, ...b].filter(x => !a.includes(x) || !b.includes(x))
```