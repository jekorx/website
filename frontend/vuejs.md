# Vue.js

### 自定义插件

> 解决无需```.vue```文件中定义，在```template```中使用公共方法的问题  

> ```src/plugins/index.ts```下开发  
> ```src/types/global.d.ts```下定义ts，解决```template```中直接使用ts报错的问题  

```javascript
/**
 * 方法名以 $ 开头，并需要导出该方法供定义全局ts使用
 */
// px转vw全局方法，结果带vw单位
export const $px2vw = (px: number) => `${px2vw(px)}vw`
// 四舍五入后保留指定位小数
export const $toFixed = toFixed
// 全局注册插件
export default {
  install: (app: App) => {
    app.config.globalProperties.$px2vw = $px2vw
    app.config.globalProperties.$toFixed = $toFixed
  }
}

/**
 * 定义全局ts
 */
export type {
  $px2vw,
  $toFixed,
} from '@/plugins'
declare module 'vue' {
  interface ComponentCustomProperties {
    $px2vw
    $toFixed
  }
}
```

> 使用  

```html
<template>
  <div :style="`width: ${$px2vw(100)}`">
    {{ $toFixed(100.123) }}
    <p v-text="$toFixed(100.123)"></p>
  </div>
</template>
```

### Vue水印指令

> 支持vue 2 / 3  

```javascript
const watermark = ({
  container = document.body,
  content = '水印',
  color = 'rgba(0, 0, 0, .1)',
  fontSize = 16,
  fontFamily = '',
  zIndex = 1000,
  rotate = 30,
  width = 100,
  height = 100,
  repeat = true
}) => {
  if (!content) return
  const canvas = document.createElement('canvas')
  canvas.setAttribute('width', `${width}px`)
  canvas.setAttribute('height', `${height}px`)
  const ctx = canvas.getContext('2d')
  ctx.textAlign = 'center'
  ctx.textBaseline = 'top'
  ctx.font = `${fontSize}px ${fontFamily}`
  ctx.fillStyle = color
  ctx.rotate(Math.PI / 180 * rotate)
  const strs = content.split('\n') // 解析 \n 换行
  strs.forEach((str, index) => ctx.fillText(str, (strs.length + 3) * fontSize, index * fontSize))
  const base64Url = canvas.toDataURL()
  const prevWatermarkDiv = container.firstChild
  let watermarkDiv
  if (prevWatermarkDiv && prevWatermarkDiv.className && prevWatermarkDiv.className.includes('watermark-container')) {
    watermarkDiv = prevWatermarkDiv
  } else {
    watermarkDiv = document.createElement('div')
    watermarkDiv.className = 'watermark-container'
  }
  watermarkDiv.setAttribute(
    'style',
    `
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: ${zIndex};
      pointer-events: none;
      background-repeat: ${repeat ? 'repeat' : 'no-repeat'};
      background-image: url('${base64Url}');
    `
  )
  container.style.position = 'relative'
  if (!prevWatermarkDiv || !(prevWatermarkDiv.className && prevWatermarkDiv.className.includes('watermark-container'))) {
    container.insertBefore(watermarkDiv, container.firstChild)
  }
}

export default {
  install (Vue, config = {}) {
    Vue.directive('watermark', (el, binding) => {
      let options
      if (typeof binding.value === 'string') {
        options = { content: binding.value }
      } else {
        options = binding.value
      }
      watermark(Object.assign({ container: el }, config, options))
    })
  }
}
```

> 使用  

```html
<div v-watermark="'水印文字\n2022-4-3 12:34'">
  <!-- ... -->
</div>
```

```javascript
/* vue@2.x */
import Watermark from '@/directives/watermark'

Vue.use(Watermark, {
  content: '支持换行的\n水印文字',
  color: 'rgba(0, 0, 0, .06)',
  width: 150,
  height: 130
})

/* vue@3.x */
import Watermark from '@/directives/watermark'

const app = createApp(/* ... */)
app.use(Watermark)
```

### Vue@2.x 父子组件生命周期顺序

```js
/* 加载渲染过程 */

parent beforeCreate
        ↓
parent created
        ↓
parent beforeMount
        ↓
child beforeCreate
        ↓
child created
        ↓
child beforeMount
        ↓
child mounted
        ↓
parent mounted
```

```js
/* 更新过程 */

// 子组件更新
child beforeUpdate
        ↓
child updated

// 子组件影响父组件（$emit）、父组件影响子组件（props）
parent beforeUpdate
        ↓
child beforeUpdate
        ↓
child updated
        ↓
parent updated

// 父组件更新
parent beforeUpdate
        ↓
parent updated

```

```js
/* 销毁过程 */

parent beforeDestroy
        ↓
child beforeDestroy
        ↓
child destroyed
        ↓
parent destroyed
```
