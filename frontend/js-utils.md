# JS 常用工具方法 

| **[类型判断](#类型判断)** | **[日期格式化](#日期格式化)** | **[秒格式化](#秒格式化)** | **[时间转换为xx时间前](#时间转换为xx时间前)** |
| :-------------------: | :------------: | :------------: | :------------: |
| **[顺序执行Promise](#顺序执行promise)** | **[隐藏手机号中间四位](#隐藏手机号中间四位)** | **[限制数据框内容仅为数字](#限制数据框内容仅为数字)** | **[七牛云上传](#七牛云上传)** |
| **[滚动条滚动动画](#滚动条滚动动画)** | **[base64转file](#base64转file)** | **[base64转blob](#base64转blob)** | **[blob转file](#blob转file)** |
| **[blob转json](#blob转json)** | **[绑定事件](#绑定事件)** | **[解绑事件](#解绑事件)** | **[连字符转驼峰](#连字符转驼峰)** |
| **[驼峰转连字符](#驼峰转连字符)** | **[文件尺寸格式化](#文件尺寸格式化)** | **[获取指定范围内的随机数](#获取指定范围内的随机数)** | **[随机字符串](#随机字符串)** |
| **[根据概率随机](#根据概率随机)** | **[打乱数组](#打乱数组)** | **[获取Url参数](#获取url参数)** | **[切分数组](#切分数组)** |
| **[两数组差集](#两数组差集)** | **[四舍五入到指定小数位](#四舍五入到指定小数位)** | **[防抖](#防抖)** | **[生成uuid](#生成uuid)** |
| **[Object合并](#object合并)** | **[深拷贝](#深拷贝)** | **[大文件切片上传](#大文件切片上传)** |  |

### 类型判断

```javascript
// 以下为更精确的判断方式，某些场景下比使用 typeof & instanceof 更高效、准确
// 判断变量是注意非undefined，Object.prototype.toString.call(person) // person is not defined
Object.prototype.toString.call(123)         // '[object Number]'
Object.prototype.toString.call('str')       // '[object String]'
Object.prototype.toString.call(true)        // '[object Boolean]'
Object.prototype.toString.call(null)        // '[object Null]'
Object.prototype.toString.call(undefined)   // '[object Undefined]'
Object.prototype.toString.call({})          // '[object Object]'
Object.prototype.toString.call([])          // '[object Array]'
Object.prototype.toString.call(() => {})    // '[object Function]'
Object.prototype.toString.call(/reg/g)      // '[object RegExp]'
Object.prototype.toString.call(new Date())  // '[object Date]'
Object.prototype.toString.call(Math)        // '[object Math]'
Object.prototype.toString.call(window)      // '[object Window]'
Object.prototype.toString.call(document)    // '[object HTMLDocument]'
Object.prototype.toString.call(10n)         // '[object BigInt]'
Object.prototype.toString.call(Symbol())    // '[object Symbol]'
```

### 日期格式化

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
  if (Object.prototype.toString.call(date) !== '[object Date]') {
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
    } else if (Object.prototype.toString.call(date) === '[object String]') {
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

### 秒格式化

```javascript
/**
 * @description 秒格式化
 * @description secondFormat(100000) // 1天3小时46分钟40秒
 *
 * @param {Number} second 秒
 * @param {String} format 格式化类型，'dhms'中一个或多个，不分先后顺序，如：ms: 分钟 秒，dms: 天 分钟 秒
 * @returns {String} 如：1天3小时46分钟40秒
 */
export const secondFormat = (second, format = 'dhms') => {
  if (!/d|h|m|s/.test(format)) {
    throw new Error('\'format\' argument must a string contains one or more of \'dhms\'.')
  }
  return [
    { f: 'd', u: '天', p: 86400 },
    { f: 'h', u: '小时', p: 3600 },
    { f: 'm', u: '分钟', p: 60 },
    { f: 's', u: '秒', p: 1 }
  ].reduce((strs, { f, u, p }) => {
    if (format.includes(f)) {
      const cur = Math.floor(second / p)
      if (cur > 0) {
        second = second % p
        strs.push(`${cur}${u}`)
      }
    }
    return strs
  }, []).join('')
}
```

### 时间转换为xx时间前

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
  if (Object.prototype.toString.call(date) !== '[object Date]') {
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
    } else if (Object.prototype.toString.call(date) === '[object String]') {
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

### 顺序执行Promise

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

### 隐藏手机号中间四位

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

### 限制数据框内容仅为数字

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

### 七牛云上传

```javascript
import * as qiniu from 'qiniu-js'
import Cookies from 'js-cookie'
import uuid from 'uuid'
import $http from '@/libs/request'

/**
 * 七牛云上传
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

### 滚动条滚动动画

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

### base64转file

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

### base64转blob

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

### blob转file

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

### blob转json

```javascript
/**
 * @description blob转json
 *
 * @param {Blob} blob Blob对象，type为 text/xml 或 application/json
 * @returns {Promise} 返回Promise对象，then(json => {})
 */
export const blobToJson = blob => {
  return new Promise((resolve, reject) => {
    if (blob.size <= 0) {
      reject(new Error('blob is empty'))
    }
    if (['text/xml', 'application/json'].includes(blob.type)) {
      const reader = new FileReader()
      reader.onload = () => {
        try {
          resolve(JSON.parse(reader.result))
        } catch (e) {
          reject(e)
        }
      }
      reader.readAsText(blob)
    } else {
      reject(new Error('blob type is not text/xml or application/json'))
    }
  })
}
```

### 绑定事件

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

### 解绑事件

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

### 连字符转驼峰

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
  if (Object.prototype.toString.call(str) !== '[object String]') {
    throw new Error('Argument must be a string')
  }
  if (str === '') {
    return str
  }
  const regExp = new RegExp(`\\${separator}(\\w)`, 'g')
  return str.replace(regExp, (matched, $1) => $1.toUpperCase())
}
```

### 驼峰转连字符

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
  if (Object.prototype.toString.call(str) !== '[object String]') {
    throw new Error('Argument must be a string')
  }
  if (str === '') {
    return str
  }
  return str.replace(/([A-Z])/g, `${separator}$1`).toLowerCase()
}
```

### 文件尺寸格式化

```javascript
/**
 * @description 文件尺寸格式化
 * @description formatSize(10240000) // 9.77MB
 *
 * @param {String | Number} size 字节数
 * @returns {String} 如：9.77MB
 */
export const formatSize = size => {
  if (Object.prototype.toString.call(size) !== '[object Number]') {
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

### 获取指定范围内的随机数

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
  if (Object.prototype.toString.call(min) !== '[object Number]' || Object.prototype.toString.call(max) !== '[object Number]') {
    throw new Error('Argument(s) is illegal !')
  }
  if (min > max) {
    [min, max] = [max, min]
  }
  return Math.floor(Math.random() * (max - min + 1) + min)
}
```

### 随机字符串

<div style="padding-bottom: 10px;">
  <div>
    <button id="random-1-btn" style="margin-right: 10px;">随机字符1</button>
    <span id="random-1-result">-</span>
  </div>
  <div>
    <button id="random-2-btn">随机字符2</button>
    <input id="random-2-len" value="20" min="1" max="9999" type="number" placeholder="字符长度" style="width: 50px; margin: 0 10px" />
    <span id="random-2-result">-</span>
  </div>
  <script>
    document.getElementById('random-1-btn').onclick = function () {
      document.getElementById('random-1-result').innerText = Math.random().toString(36).substring(2)
    }
    document.getElementById('random-2-btn').onclick = function () {
      const randomString = (length, template = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') => length > 0
      ? Array.from({ length }, () => template[Math.floor(Math.random() * template.length)]).join('')
      : ''
      let length = +(document.getElementById('random-2-len').value || 0)
      if (length < 1) length = 1
      if (length > 9999) length = 9999
      document.getElementById('random-2-len').value = length
      document.getElementById('random-2-result').innerText = randomString(length)
    }
  </script>
</div>

```javascript
/**
 * 原理：Number.prototype.toString(radix)
 *      radix: 范围在 2 到 36 之间，用于指定表示数字值的基数
 */
Math.random().toString(36).substring(2)

/**
 * 生成指定长度随机字符串
 * @param {number} length 随机字符串长度
 * @param {string} template 随机字符串取值模板，默认：0-9a-zA-Z
 * @returns {string}
 */
const randomString = (length, template = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') => length > 0
  ? Array.from({ length }, () => template[Math.floor(Math.random() * template.length)]).join('')
  : ''
```

### 根据概率随机

<div style="padding-bottom: 10px;">
  <table>
    <tbody style="text-align: center;">
      <tr>
        <td>奖项</td>
        <td>一等奖</td>
        <td>二等奖</td>
        <td>三等奖</td>
        <td>四等奖</td>
        <td>五等奖</td>
        <td>谢谢参与</td>
      </tr>
      <tr>
        <td>概率</td>
        <td>0.01%</td>
        <td>0.09%</td>
        <td>0.9%</td>
        <td>9%</td>
        <td>30%</td>
        <td>60%</td>
      </tr>
    </tbody>
  </table>
  <div>
    <button id="prize-btn" style="margin-right: 10px;">测试抽奖</button>
    <span id="prize-result">-</span>
  </div>
  <script>
    const prizes = [
      { name: '一等奖', odds: 0.01 },
      { name: '二等奖', odds: 0.09 },
      { name: '三等奖', odds: 0.9 },
      { name: '四等奖', odds: 9 },
      { name: '五等奖', odds: 30 },
      { name: '谢谢参与', odds: 60 }
    ]
    const getWinPrize = (prizes, rate = 100, precision = 2) => {
      const r = Math.ceil(Math.random() * (rate ** precision))
      const getOddsSum = i => prizes.slice(0, i).reduce((sum, { odds }) => sum + odds * rate, 0)
      return prizes.find((_, i) => r > getOddsSum(i) && r <= getOddsSum(i + 1))
    }
    document.getElementById('prize-btn').onclick = function () {
      const { name } = getWinPrize(prizes) || {}
      document.getElementById('prize-result').innerText = name
    }
  </script>
</div>

```javascript
/**
 * 根据概率随机
 * 
 * @description
 * 获取随机数 r
 * 一等奖 0.01%     0 < r && r <= 1 其实只有=1时
 * 二等奖 0.09%     1 < r && r <= 10
 * 三等奖  0.9%    10 < r && r <= 100
 * 四等奖    9%   100 < r && r <= 1000
 * 五等奖   30%  1000 < r && r <= 4000
 * 谢谢参与 60%  4000 < r && r <= 10000
 * 
 * 0.01%  0  1  ->                                  0  <  x  <=  (0.01) * 100
 * 0.09%  1  2  ->                       (0.01) * 100  <  x  <=  (0.01 + 0.09) * 100
 *  0.9%  2  3  ->                (0.01 + 0.09) * 100  <  x  <=  (0.01 + 0.09 + 0.9) * 100
 *    9%  3  4  ->          (0.01 + 0.09 + 0.9) * 100  <  x  <=  (0.01 + 0.09 + 0.9 + 9) * 100
 *   30%  4  5  ->      (0.01 + 0.09 + 0.9 + 9) * 100  <  x  <=  (0.01 + 0.09 + 0.9 + 9 + 30) * 100
 *   60%  5 max -> (0.01 + 0.09 + 0.9 + 9 + 30) * 100  <  x  <=  10000
 * 
 * @param {Array} prizes: [{ odds: number, ...others }] // odds 概率，百分之多少，所有概率总和为1（100%）
 * @param {number} rate 分率，百分之多少 -> 100，千分之多少 -> 1000，默认：100
 * @param {number} precision 概率精度，0.01 -> 2，0.001 -> 3，默认：2
 * @returns {Object} prize: { odds: number, ...others }
 */
const getWinPrize = (prizes, rate = 100, precision = 2) => {
  const r = Math.ceil(Math.random() * (rate ** precision))
  const getOddsSum = i => prizes.slice(0, i).reduce((sum, { odds }) => sum + odds * rate, 0)
  return prizes.find((_, i) => r > getOddsSum(i) && r <= getOddsSum(i + 1))
}
```

### 打乱数组

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

### 获取Url参数

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

### 切分数组

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

### 两数组差集

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

### 四舍五入到指定小数位

```javascript
/**
 * @description 四舍五入到指定小数位
 *
 * @param {Number} number 待转换数字
 * @param {Number} decimals 小数位数
 */
export const round = (number, decimals = 0) => Number(`${Math.round(`${number}e${decimals}`)}e-${decimals}`)
```

### 防抖

> 更多防抖、节流介绍[可参照](./debounce-throttle.md)  

```javascript
/**
 * @description 防抖
 * @param {Function} fn 具体执行方法
 * @param {Number} delay 间隔时间，默认500毫秒
 */
export const debounce = (fn, delay = 500) => {
  let timer
  return () => {
    timer && clearTimeout(timer)
    timer = setTimeout(() => fn && fn(), delay)
  }
}
```

### 生成uuid

```javascript
/**
 * @description 生成uuid
 * @returns {String} uuid
 */
export const uuid = () => {
  const tmpUrl = URL.createObjectURL(new Blob())
  const tmpUrlStr = tmpUrl.toString()
  URL.revokeObjectURL(tmpUrl)
  return tmpUrlStr.substring(tmpUrlStr.lastIndexOf('/') + 1)
}
```

### Object合并

```javascript
/**
 * @description Object合并
 * @description 后面的Object覆盖合并到前面的Object
 *
 * @param {Object} target 合并目标对象
 * @param {...Object} args 任意个待合并对象
 */
export const merge = (target, ...args) => {
  return args.reduce((acc, cur) => Object.keys(cur).reduce((subAcc, key) => {
    const srcVal = cur[key]
    if (Object.prototype.toString.call(srcVal) === '[object Object]') {
      subAcc[key] = merge(subAcc[key] ? subAcc[key] : {}, srcVal)
    } else if (Array.isArray(srcVal)) {
      subAcc[key] = srcVal.map((item, idx) => {
        if (Object.prototype.toString.call(item) === '[object Object]') {
          const curAccVal = subAcc[key] ? subAcc[key] : []
          return merge(curAccVal[idx] ? curAccVal[idx] : {}, item)
        } else {
          return item
        }
      })
    } else {
      subAcc[key] = srcVal
    }
    return subAcc
  }, acc), target)
}
```

### 深拷贝

```javascript
/**
 * @description 深拷贝
 *
 * @param {any} target 需要拷贝目标，任何值
 * @param cache 使用WeakSet处理循环引用，默认即可，无需传值
 * @returns {any} 新拷贝结果
 */
export const deepClone = (target, cache = new WeakSet()) => {
  const type = typeof target
  // 拷贝基本类型值
  if (!(target !== null && (type === 'object' || type === 'function'))) return target
  // 如果之前已经拷贝过该对象，直接返回该对象
  if (cache.has(target)) return target
  // 将对象添加缓存
  cache.add(target)
  const arrayTag = '[object Array]'
  const objectTag = '[object Object]'
  const mapTag = '[object Map]'
  const setTag = '[object Set]'
  const functionTag = '[object Function]'
  const boolTag = '[object Boolean]'
  const dateTag = '[object Date]'
  const numberTag = '[object Number]'
  const stringTag = '[object String]'
  const errorTag = '[object Error]'
  const symbolTag = '[object Symbol]'
  const regexpTag = '[object RegExp]'
  const tag = Object.prototype.toString.call(target)
  const Ctor = target.constructor
  let cloneTarget
  switch (tag) {
    case boolTag:
    case dateTag:
      cloneTarget = new Ctor(+target)
      break
    case numberTag:
    case stringTag:
    case errorTag:
      cloneTarget = new Ctor(target)
      break
    case objectTag:
    case mapTag:
    case setTag:
      cloneTarget = new Ctor()
      break
    case arrayTag: {
      const { length } = target
      const result = new target.constructor(length)
      if (length && typeof target[0] === 'string' && Object.hasOwnProperty.call(target, 'index')) {
        result.index = target.index
        result.input = target.input
      }
      cloneTarget = result
    } break
    case symbolTag:
      cloneTarget = Object(Symbol.prototype.valueOf.call(target))
      break
    case regexpTag: {
      const result = new target.constructor(target.source, /\w*$/.exec(target))
      result.lastIndex = target.lastIndex
      cloneTarget = result
    } break
  }
  if (tag === mapTag) {
    target.forEach((value, key) => {
      cloneTarget.set(key, deepClone(value, cache))
    })
    return cloneTarget
  }
  if (tag === setTag) {
    target.forEach(value => {
      cloneTarget.add(deepClone(value, cache))
    })
    return cloneTarget
  }
  if (tag === functionTag) return target
  Reflect.ownKeys(target).forEach(key => {
    // 递归拷贝属性
    cloneTarget[key] = deepClone(target[key], cache)
  })
  return cloneTarget
}
```

### 大文件切片上传

> 过程：  
> 1、实例化```ChunkUpload```对象  
> 2、使用```load()```方法加载文件并切片  
> 3、切片完成后自动开始上传切片文件  
> 4、切片文件上传完成后自动合并切片文件，合并后后端最好对新文件进行md5校验，后端对完整的文件进行后续处理  
> 5、完成上传  

> 依赖```spark-md5```计算文件md5  
> 使用```axios```封装$http，[可参照](./axios.md#常用配置)  
> 后端切片文件合并，[可参照](../java/utils.md#切片文件合并)  
> 以下提供ts版本和js版本  

```javascript
////////////////////
///TypeScript版本///
////////////////////

import SparkMD5 from 'spark-md5'
import $http from './http'

/**
 * 大文件切片上传
 *
 * 注意：复合后缀，如：.tar.gz，需对fileSuffix变量初始化时进行判断
 *
 * ------------------------------------------------------------------
 *
 * // 实例化ChunkUpload对象
 * const chunkUpload = new ChunkUpload(file, {
 *   // uploadIndex: 0,
 *   // chunkSize: 4 * 1024 * 1024,
 *   next: (state: { loading: number, uploading: number, merging: number, uploadIndex: number, status: string }) => {
 *     const { loading, uploading, merging, uploadIndex, status } = state
 *     console.log(loading, uploading, merging, uploadIndex, status)
 *   },
 *   success: (data: string, md5: string) => {
 *     console.log(md5)
 *   },
 *   error: (code: number, msg: string) => {
 *     console.log(msg)
 *   }
 * })
 * // 调用load方法开始切片并上传
 * chunkUpload.load()
 *
 * ------------------------------------------------------------------
 *
 * @param file 上传的文件
 * @param options.chunkSize 切片大小，默认：4 * 1024 * 1024
 * @param options.uploadIndex 上传索引，用于初始化时的断点续传，默认：0
 * @param options.next ({ loading, uploading, merging, uploadIndex, status }) => {} 上传进度，
 *                      loading：加载切片进度
 *                      uploading：上传进度
 *                      merging：合并进度
 *                      uploadIndex：已上传索引，只有uploading状态才会改变
 *                      status：状态'pending' | 'loading' | 'uploading' | 'merging' | 'finished'
 * @param options.success: (data, md5) => {} 上传成功回调，data：文件上传文件名，md5：文件md5
 * @param options.error: (code, msg) => {} 上传错误回调，code：状态码，msg：错误信息
 *
 * @function load 初始化之后，调用load开始上传
 * @function stop 暂停上传，返回当前上传的切片索引
 * @function proceed 继续上传
 *
 * ------------------------------------------------------------------
 *
 * @backend 后端上传切片参数
 *           @PathVariable("part") String part,
 *           @RequestParam("file") MultipartFile file,
 *           @RequestParam("md5") String md5
 * @backend 后端检查文件数量参数
 *           @PathVariable("md5") String md5
 * @backend 后端文件合并参数
 *           @PathVariable("md5") String md5,
 *           @RequestParam("chunks") int chunks,
 *           @RequestParam("suffix") String suffix
 */

type StatusEnum = 'pending' | 'loading' | 'uploading' | 'merging' | 'finished'
type NextFunction = (state: {
  loading: number,
  uploading: number,
  merging: number,
  uploadIndex: number,
  status: StatusEnum
}) => void

const CHECK_URL = (md5: string): string => `upload/v1/file/check/${md5}`
const UPLOAD_URL = (i: number): string => `upload/v1/upload/chunk/${i}`
const MERGE_URL = (md5: string): string => `upload/v1/file/merge/${md5}`

export default class ChunkUpload {
  // 待处理文件
  private file: File
  // 文件尺寸
  private fileSize: number
  // 文件后缀
  private fileSuffix: string
  // 切片大小
  chunkSize: number
  // 切片数量
  chunkCount: number
  // 取消上传标记
  private isStop: boolean
  // 切片文件数组
  private chunkList: Blob[]
  // MD5
  md5: string
  // 实例化spark用于计算文件md5
  private spark: SparkMD5.ArrayBuffer
  // 通过FileReader读取文件进行切分、计算文件md5
  private fileReader: FileReader
  // 加载切片索引
  private loadIndex: number
  // 上传切片索引
  private uploadIndex: number
  // 上传状态
  private status: StatusEnum
  // 上传进度
  private next: NextFunction

  // 成功
  private success: (data: string, md5: string) => void

  // 错误
  private error: (code: number, msg: string) => void

  constructor (file: File, options?: {
    chunkSize?: number,
    uploadIndex?: number,
    next?: NextFunction,
    success?: (data: string, md: string) => void,
    error?: (code: number, msg: string) => void
  }) {
    const { name, size } = file
    this.file = file
    this.fileSize = size
    this.fileSuffix = name.substring(name.lastIndexOf('.'))
    this.chunkSize = +(options?.chunkSize || 4 * 1024 * 1024)
    this.chunkCount = Math.ceil(size / this.chunkSize)
    this.isStop = false
    this.chunkList = []
    this.md5 = ''
    this.uploadIndex = +(options?.uploadIndex || 0)
    this.loadIndex = 0
    this.spark = new SparkMD5.ArrayBuffer()
    this.fileReader = new FileReader()
    this.status = 'pending'
    this.next = options?.next || (() => null)
    this.success = options?.success || (() => null)
    this.error = options?.error || (() => null)
    // 初始化
    this.init()
  }

  // 读取文件并进行切片
  private init (): void {
    const { chunkCount, spark, fileReader, uploadIndex, status, next } = this
    // 设置进度
    next({
      loading: 0,
      uploading: 0,
      merging: 0,
      uploadIndex,
      status
    })
    fileReader.onload = ({ target }) => {
      const { loadIndex, uploadIndex, status } = this
      let i: number = loadIndex
      // spark-md5读取当前片
      spark.append(target?.result as ArrayBuffer)
      // 读取完之后，切片索引+1
      i++
      // 设置进度
      next({
        loading: +(i / chunkCount * 100).toFixed(1),
        uploading: 0,
        merging: 0,
        uploadIndex,
        status
      })
      // 递归切片
      if (i < chunkCount) {
        this.loadIndex = i
        this.load()
      } else {
        // 切片完成，计算md5
        this.md5 = spark.end()
        // 设置上传状态
        this.status = 'uploading'
        // 如果初始化时断点续传
        if (uploadIndex > 0) {
          // 检查服务器临时目录已上传切片
          this.check()
        } else {
          // 开始上传
          this.upload()
        }
      }
    }
  }

  // 检查切片
  private check (): void {
    const { md5, uploadIndex, error } = this
    axios.post(CHECK_URL(md5)).then(({ data, code, msg }) => {
      if (code === 1) {
        // 当前索引不大于存在数量
        if (data >= uploadIndex) {
          this.upload()
        } else {
          this.uploadIndex = 0
          this.upload()
        }
      } else {
        error(code, msg)
      }
    }).catch(err => error(-1, err.message))
  }

  // 文件切片
  load (): void {
    const { chunkSize, fileSize, file, loadIndex, fileReader, isStop } = this
    // 设置上传状态
    this.status = 'loading'
    if (isStop) return
    const start: number = loadIndex * chunkSize
    const end: number = ((start + chunkSize) >= fileSize) ? fileSize : start + chunkSize
    const blob: Blob = file.slice(start, end)
    this.chunkList.push(blob)
    fileReader.readAsArrayBuffer(blob)
  }

  // 上传切片
  private upload (): void {
    const { md5, chunkList, chunkCount, uploadIndex, isStop, status, next, error } = this
    // 取消上传
    if (isStop) return
    // 当前上传切片索引
    let i: number = uploadIndex
    // 拼装FormData对象，上传文件
    const formData = new FormData()
    formData.append('file', chunkList[i])
    formData.append('md5', md5)
    // 上传切片
    axios.post(UPLOAD_URL(i), formData, {
      transformRequest: [(params: FormData, headers: { [key: string]: string }) => {
        headers = { // eslint-disable-line
          'Content-Type': 'multipart/form-data'
        }
        return params
      }],
      onUploadProgress (e: { loaded: number, total: number }) {
        const { loaded, total } = e
        // 设置进度
        next({
          loading: 100,
          uploading: +((loaded / total + i) * 100 / chunkCount).toFixed(1),
          merging: 0,
          uploadIndex: i,
          status
        })
      }
    }).then(({ code, msg }) => {
      if (code === 1) {
        i++
        if (i < chunkCount) {
          this.uploadIndex = i
          this.upload()
        } else {
          // 设置上传状态
          this.status = 'merging'
          this.merge()
        }
      } else {
        error(code, msg)
      }
    }).catch(err => error(-1, err.message))
  }

  // 合并文件
  private merge (): void {
    const { md5, chunkCount, uploadIndex, fileSuffix, isStop, status, next, success, error } = this
    // 取消上传
    if (isStop) return
    next({
      loading: 100,
      uploading: 100,
      merging: 0,
      uploadIndex,
      status
    })
    axios.post(MERGE_URL(md5), {
      chunks: chunkCount,
      suffix: fileSuffix
    }).then(({ data, code, msg }) => {
      if (code === 1) {
        // 设置状态
        this.status = 'finished'
        // 设置进度
        next({
          loading: 100,
          uploading: 100,
          merging: 100,
          uploadIndex,
          status: this.status
        })
        // 上传完成回调，返回md5值
        success(data, md5)
      } else {
        error(code, msg)
      }
    }).catch(err => error(-1, err.message))
  }

  // 取消操作，返回当前已上传索引
  stop (): number {
    this.isStop = true
    return this.uploadIndex
  }

  // 继续操作
  proceed (): void {
    this.isStop = false
    const { chunkCount, status, loadIndex, uploadIndex } = this
    // 继续切片
    if (status === 'loading' && loadIndex < chunkCount) {
      this.load()
    } else if (status === 'uploading' && uploadIndex < chunkCount) {
      // 检查并继续上传
      this.check()
    } else if (status === 'merging') {
      // 继续合并
      this.merge()
    }
  }
}
```

```javascript
////////////////////
///JavaScript版本///
////////////////////

import SparkMD5 from 'spark-md5'
import $http from './http'

/**
 * 大文件切片上传
 *
 * 注意：复合后缀，如：.tar.gz，需对fileSuffix变量初始化时进行判断
 *
 * ------------------------------------------------------------------
 *
 * // 实例化ChunkUpload对象
 * const chunkUpload = new ChunkUpload(file, {
 *   // uploadIndex: 0,
 *   // chunkSize: 4 * 1024 * 1024,
 *   next: ({ loading, uploading, merging, uploadIndex, status }) => {
 *     console.log(loading, uploading, merging, uploadIndex, status)
 *   },
 *   success: (data, md5) => {
 *     console.log(md5)
 *   },
 *   error: (code, msg) => {
 *     console.log(msg)
 *   }
 * })
 * // 调用load方法开始切片并上传
 * chunkUpload.load()
 *
 * ------------------------------------------------------------------
 *
 * @param file 上传的文件
 * @param options.chunkSize 切片大小，默认：4 * 1024 * 1024
 * @param options.uploadIndex 上传索引，用于初始化时的断点续传，默认：0
 * @param options.next ({ loading, uploading, merging, uploadIndex, status }) => {} 上传进度，
 *                      loading：加载切片进度
 *                      uploading：上传进度
 *                      merging：合并进度
 *                      uploadIndex：已上传索引，只有uploading状态才会改变
 *                      status：状态'pending' | 'loading' | 'uploading' | 'merging' | 'finished'
 * @param options.success: (data, md5) => {} 上传成功回调，data：文件上传文件名，md5：文件md5
 * @param options.error: (code, msg) => {} 上传错误回调，code：状态码，msg：错误信息
 *
 * @function load 初始化之后，调用load开始上传
 * @function stop 暂停上传，返回当前上传的切片索引
 * @function proceed 继续上传
 *
 * ------------------------------------------------------------------
 *
 * @backend 后端上传切片参数
 *           @PathVariable("part") String part,
 *           @RequestParam("file") MultipartFile file,
 *           @RequestParam("md5") String md5
 * @backend 后端检查文件数量参数
 *           @PathVariable("md5") String md5
 * @backend 后端文件合并参数
 *           @PathVariable("md5") String md5,
 *           @RequestParam("chunks") int chunks,
 *           @RequestParam("suffix") String suffix
 */

const CHECK_URL = md5 => `upload/v1/file/check/${md5}`
const UPLOAD_URL = i => `upload/v1/upload/chunk/${i}`
const MERGE_URL = md5 => `upload/v1/file/merge/${md5}`

export default class ChunkUpload {
  constructor (file, options) {
    const { name, size } = file
    // 待处理文件
    this.file = file
    // 文件尺寸
    this.fileSize = size
    // 文件后缀
    this.fileSuffix = name.substring(name.lastIndexOf('.'))
    // 切片大小
    this.chunkSize = +(options && options.chunkSize ? options.chunkSize : 4 * 1024 * 1024)
    // 切片数量
    this.chunkCount = Math.ceil(size / this.chunkSize)
    // 取消上传标记
    this.isStop = false
    // 切片文件数组
    this.chunkList = []
    // MD5
    this.md5 = ''
    // 加载切片索引
    this.uploadIndex = +(options && options.uploadIndex ? options.uploadIndex : 0)
    // 上传切片索引
    this.loadIndex = 0
    // 实例化spark用于计算文件md5
    this.spark = new SparkMD5.ArrayBuffer()
    // 通过FileReader读取文件进行切分、计算文件md5
    this.fileReader = new FileReader()
    // 上传状态 'pending' | 'loading' | 'uploading' | 'merging' | 'finished'
    this.status = 'pending'
    // 上传进度
    this.next = options && options.next ? options.next : () => null
    // (data, md5) => {} 上传成功回调，data：文件上传文件名，md5：文件md5
    this.success = options && options.success ? options.success : () => null
    // (msg) => {} 上传错误回调，msg：错误信息
    this.error = options && options.error ? options.error : () => null
    // 初始化
    this.init()
  }

  // 读取文件并进行切片
  init () {
    const { chunkCount, spark, fileReader, uploadIndex, status, next } = this
    // 设置进度
    next({
      loading: 0,
      uploading: 0,
      merging: 0,
      uploadIndex,
      status
    })
    fileReader.onload = ({ target }) => {
      const { loadIndex, status } = this
      let i = loadIndex
      // spark-md5读取当前片
      spark.append(target.result)
      // 读取完之后，切片索引+1
      i++
      // 设置进度
      next({
        loading: +(i / chunkCount * 100).toFixed(1),
        uploading: 0,
        merging: 0,
        uploadIndex,
        status
      })
      // 递归切片
      if (i < chunkCount) {
        this.loadIndex = i
        this.load()
      } else {
        // 切片完成，计算md5
        this.md5 = spark.end()
        // 设置上传状态
        this.status = 'uploading'
        // 如果初始化时断点续传
        if (uploadIndex > 0) {
          // 检查服务器临时目录已上传切片
          this.check()
        } else {
          // 开始上传
          this.upload()
        }
      }
    }
  }

  // 检查切片
  check () {
    const { md5, uploadIndex, error } = this
    $http.post(CHECK_URL(md5)).then(({ data, code, msg }) => {
      if (code === 1) {
        // 当前索引不大于存在数量
        if (data >= uploadIndex) {
          this.upload()
        } else {
          this.uploadIndex = 0
          this.upload()
        }
      } else {
        error(code, msg)
      }
    }).catch(err => error(-1, err.message))
  }

  // 文件切片
  load () {
    const { chunkSize, fileSize, file, loadIndex, fileReader, isStop } = this
    // 设置上传状态
    this.status = 'loading'
    if (isStop) return
    const start = loadIndex * chunkSize
    const end = ((start + chunkSize) >= fileSize) ? fileSize : start + chunkSize
    const blob = file.slice(start, end)
    this.chunkList.push(blob)
    fileReader.readAsArrayBuffer(blob)
  }

  // 上传切片
  upload () {
    const { md5, chunkList, chunkCount, uploadIndex, isStop, status, next, error } = this
    // 取消上传
    if (isStop) return
    // 当前上传切片索引
    let i = uploadIndex
    // 拼装FormData对象，上传文件
    const formData = new FormData()
    formData.append('file', chunkList[i])
    formData.append('md5', md5)
    // 上传切片
    $http.post(UPLOAD_URL(i), formData, {
      transformRequest: [(params, headers) => {
        headers = { // eslint-disable-line
          'Content-Type': 'multipart/form-data'
        }
        return params
      }],
      onUploadProgress ({ loaded, total }) {
        // 设置进度
        next({
          loading: 100,
          uploading: +((loaded / total + i) * 100 / chunkCount).toFixed(1),
          merging: 0,
          uploadIndex: i,
          status
        })
      }
    }).then(({ code, msg }) => {
      if (code === 1) {
        i++
        if (i < chunkCount) {
          this.uploadIndex = i
          this.upload()
        } else {
          // 设置上传状态
          this.status = 'merging'
          this.merge()
        }
      } else {
        error(code, msg)
      }
    }).catch(err => error(-1, err.message))
  }

  // 合并文件
  merge () {
    const { md5, chunkCount, uploadIndex, fileSuffix, isStop, status, next, success, error } = this
    // 取消上传
    if (isStop) return
    next({
      loading: 100,
      uploading: 100,
      merging: 0,
      uploadIndex,
      status
    })
    $http.post(MERGE_URL(md5), {
      chunks: chunkCount,
      suffix: fileSuffix
    }).then(({ data, code, msg }) => {
      if (code === 1) {
        // 设置状态
        this.status = 'finished'
        // 设置进度
        next({
          loading: 100,
          uploading: 100,
          merging: 100,
          uploadIndex,
          status: this.status
        })
        // 上传完成回调，返回md5值
        success(data, md5)
      } else {
        error(msg)
      }
    }).catch(err => error(err.message))
  }

  // 取消操作，返回当前已上传索引
  stop () {
    this.isStop = true
    return this.uploadIndex
  }

  // 继续操作
  proceed () {
    this.isStop = false
    const { chunkCount, status, loadIndex, uploadIndex } = this
    // 继续切片
    if (status === 'loading' && loadIndex < chunkCount) {
      this.load()
    } else if (status === 'uploading' && uploadIndex < chunkCount) {
      // 检查并继续上传
      this.check()
    } else if (status === 'merging') {
      // 继续合并
      this.merge()
    }
  }
}
```
