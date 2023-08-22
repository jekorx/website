# 函数防抖(debounce)、函数节流(throttle)

### 函数防抖(debounce)

> 介绍：当调用动作n毫秒后，才会执行该动作，若在这n毫秒内又调用此动作则将重新计算执行时间  
> 场景：实时搜索（keyup）、拖拽（mousemove）  

```javascript
/**
 * 未防抖
 * -------------------------
 * ^^^^^^^^^^^^^^^^^^^^^^^^^
 * 防抖
 * -------------------------
 *                         ^
 */
// ES6常用实现
const debounce = (fn, delay = 1000) => {
  let timer
  return () => {
    timer && clearTimeout(timer)
    timer = setTimeout(() => {
      fn && fn()
    }, delay)
  }
}

// 使用
window.onscroll = debounce(() => {
  console.log(document.documentElement.scrollTop)
}, 500)
```

### 特殊使用

> 原理：[JavaScript异步执行顺序](../index/frontend.md#javascript异步执行顺序)  
> 场景：同步数据收集后统一处理  
> 其它：除了使用```setTimeout```宏任务达到异步效果，也可以使用```Promise.resolve().then```微任务  

```javascript
/**
 * @param {Function} completeFn 完成执行方法
 * @returns {Function}
 *   @param {Function} processFn 中间处理过程
 */
const debounceCurrying = completeFn => {
  let processing = false
  return processFn => {
    if (!processing) {
      processing = true
      setTimeout(() => {
        processing = false
        completeFn && completeFn()
      })
    }
    processFn && processFn()
  }
}

// 使用
const ids = []
const processHandle = debounceCurrying(() => {
  // 最终数据处理
  console.log(ids)
})
for (let i = 0; i < 10; i++) {
  processHandle(() => {
    // 中间收集数据
    ids.push(i)
  })
}
```

### 函数节流(throttle)

> 介绍：预先设定一个执行周期，当调用动作的时刻大于等于执行周期则执行该动作，然后进入下一个新周期  
> 窗口调整（resize）、页面滚动（scroll）、抢购疯狂点击（mousedown）  

```javascript
/**
 * 未节流
 * -------------------------
 * ^^^^^^^^^^^^^^^^^^^^^^^^^
 * 节流
 * -------------------------
 * ^   ^   ^   ^   ^   ^   ^
 */
/**
 * ES6常用实现（1） -- 基于时间间隔
 * 触发第一次，如需触发结束后时间间隔需加else setTimeout
 */
// 基础版
const throttle = (fn, delay = 100) => {
  let last = 0
  return () => {
    const now = Date.now()
    if (now - last >= delay) {
      fn && fn()
      last = now
    }
  }
}
// 触发结束后时间间隔
const throttle = (fn, delay = 100) => {
  let last = 0
  let timer
  return () => {
    const now = Date.now()
    timer && clearTimeout(timer)
    if (now - last >= delay) {
      fn && fn()
      last = now
    } else {
      timer = setTimeout(() => {
        fn && fn()
      }, delay)
    }
  }
}
/**
 * ES6常用实现（2） -- 基于setTimeout
 * 不会触发第一次
 */
const throttle = (fn, delay = 100) => {
  let timer
  return () => {
    if (!!timer) {
      return false
    } else {
      timer = setTimeout(() => {
        fn && fn()
        timer && clearTimeout(timer)
        timer = null
      }, delay)
    }
  }
}

// 使用
window.onscroll = throttle(() => {
  console.log(document.documentElement.scrollTop)
}, 1000)
```