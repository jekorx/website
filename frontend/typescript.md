# TypeScript

#### 部分错误解决方式

> TS2683: 'this' implicitly has type 'any' because it does not have a type annotation using `apply`  
> 原文件中存在this的值是any的时候报错  

```javascript
// 报错代码
function rafThrottle<T extends AnyFunction<any>> (fn: T): AnyFunction<void> {
  let locked = false
  return function (...args: any[]) {
    if (locked) return
    locked = true
    window.requestAnimationFrame(() => {
      fn.apply(this, args) // TS2683: 'this' implicitly has type 'any' because it does not have a type annotation.
      locked = false
    })
  }
}

// 将this指定为 any 或 unknown
function rafThrottle<T extends AnyFunction<any>> (fn: T): AnyFunction<void> {
  let locked = false
  return function (this: any, ...args: any[]) { // 指定this类型为 any 或者 unknown
    if (locked) return
    locked = true
    window.requestAnimationFrame(() => {
      fn.apply(this, args)
      locked = false
    })
  }
}
```