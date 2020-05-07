# Canvas

### Canvas签名

##### 1、原生JavaScript版本

> 利用canvas画布实现签名效果  

```javascript
/**
 * Canvas 签名
 * 
 * 使用：
 * new drawCanvas({
 *   saveCallback: function (imgBase64, clearCallback) {
 *     document.getElementById('#signImage').src = imgBase64
 *     // 清空canvas
 *     // clearCallback()
 *   }
 * })
 * <String> el：canvas容器id，默认：'canvas'
 * <String> saveEl：保存按钮id，默认：'saveBtn'
 * <String> clearEl：清除按钮id，默认：'clearBtn'
 * <Number> width：容器宽度，默认：浏览器宽度
 * <Number> height：容器高度，默认：200
 * <String> color：画线颜色，默认：'#000'
 * <String> background：容器背景颜色颜色，默认：'rgba(255, 255, 255, 0)'
 * <Number> borderWidth：容器边框宽度，默认：1
 * <String> borderColor：容器边框颜色颜色，默认：'#333'
 * <Function> saveCallback(imgBase64, clearCallback)：保存回调(base64图片，清空画布回调)
 */
function drawCanvas (args) {
  this.el = 'canvas'
  this.saveEl = 'saveBtn'
  this.clearEl = 'clearBtn'
  this.width = document.documentElement.clientWidth || document.body.clientWidth
  this.height = 200
  this.lineWidth = 2
  this.color = '#000'
  this.background = 'rgba(255, 255, 255, 0)'
  this.borderWidth = 1
  this.borderColor = '#333'
  this.saveCallback = function (imgBase64, clearCallback) { }
  for (var k in args) {
    this[k] = args[k]
  }
  // 获取canvas
  var canvas = document.getElementById(this.el)
  // 设置边框
  if (this.borderWidth > 0 && this.width > this.borderWidth * 2) {
    this.width = this.width - this.borderWidth * 2
    canvas.style.border = this.borderWidth + 'px solid' + this.borderColor
  }
  // 设置宽高
  canvas.width = this.width
  canvas.height = this.height
  // 获取canvas context
  var cxt = canvas.getContext('2d')
  // canvas context相关设置
  cxt.fillStyle = this.background
  cxt.fillRect(0, 0, this.width, this.height)
  cxt.strokeStyle = this.color
  cxt.lineWidth = this.lineWidth
  cxt.lineCap = 'round' // 线条末端添加圆形线帽，减少线条的生硬感
  cxt.lineJoin = 'round' // 线条交汇时为原型边角
  // 利用阴影，消除锯齿
  cxt.shadowBlur = 1
  cxt.shadowColor = this.color

  var offsetTop = canvas.offsetTop // canvas上边距
  var offsetLeft = canvas.offsetLeft // canvas左边距
  var isDraw = false // 是否绘制中，用于mousemove
  // 开始绘制
  canvas.addEventListener('touchstart', function (e) {
    cxt.beginPath()
    cxt.moveTo(e.changedTouches[0].pageX - offsetLeft, e.changedTouches[0].pageY - offsetTop)
  }, false)
  canvas.addEventListener('mousedown', function (e) {
    isDraw = true
    cxt.beginPath()
    cxt.moveTo(e.pageX - offsetLeft, e.pageY - offsetTop)
  }, false)

  // 绘制中
  canvas.addEventListener('touchmove', function (e) {
    e.stopPropagation()
    e.preventDefault()
    cxt.lineTo(e.changedTouches[0].pageX - offsetLeft, e.changedTouches[0].pageY - offsetTop)
    cxt.stroke()
  }, false)
  canvas.addEventListener('mousemove', function (e) {
    if (isDraw) {
      e.stopPropagation()
      e.preventDefault()
      cxt.lineTo(e.pageX - offsetLeft, e.pageY - offsetTop)
      cxt.stroke()
      if (e.pageX - offsetLeft <= this.borderWidth
       || e.pageX - offsetLeft >= canvas.width - this.borderWidth * 2
       || e.pageY - offsetTop <= this.borderWidth
       || e.pageY - offsetTop >= canvas.height - this.borderWidth * 2) {
        isDraw = false
      }
    }
  }.bind(this), false)

  // 结束绘制
  canvas.addEventListener('touchend', function () {
    cxt.closePath()
  }, false)
  canvas.addEventListener('mouseup', function () {
    isDraw = false
    cxt.closePath()
  }, false)

  // 清除画布
  document.getElementById(this.clearEl) && document.getElementById(this.clearEl).addEventListener('click', function () {
    cxt.clearRect(0, 0, canvas.width, canvas.height)
  }, false)

  // 保存图片
  document.getElementById(this.saveEl) && document.getElementById(this.saveEl).addEventListener('click', function () {
    var imgBase64 = canvas.toDataURL()
    this.saveCallback(imgBase64, function () {
      cxt.clearRect(0, 0, canvas.width, canvas.height)
    })
  }.bind(this), false)
}
```

> 使用  

```html
<canvas id="canvas"></canvas>
<button id="saveBtn">生成图片</button>
<img id="signImage" width="300" height="200" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQYV2NgAAIAAAUAAarVyFEAAAAASUVORK5CYII=" alt="生成的图片">

<script>
  window.onload = function () {
    new drawCanvas({
      width: 300,
      height: 200,
      saveCallback: function (imgBase64, clearCallback) {
        document.getElementById('signImage').src = imgBase64
        // 清空canvas
        // clearCallback()
      }
    })
  }
</script>
```

##### 2、Vue.js版本

> vue组件  

```html
<template>
  <canvas
    ref="canvas"
    :width="width > borderWidth * 2 ? width - borderWidth * 2 : width"
    :height="height"
    :style="borderStyle"
    @touchstart="touchstart"
    @mousedown="mousedown"
    @touchmove="touchmove"
    @mousemove="mousemove"
    @touchend="touchend"
    @mouseup="mouseup"
  ></canvas>
</template>
<script>
/* <div>
  <CanvasSign ref="canvasSign" :width="300" />
  <div>
    <button @click="save">save</button>
  </div>
  <img :src="imgSrc" alt="生成的图片" />
</div> */

/* import CanvasSign from '_c/canvas-sign'

export default {
  name: 'Sign',
  components: { CanvasSign },
  data () {
    return {
      imgSrc: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQYV2NgAAIAAAUAAarVyFEAAAAASUVORK5CYII='
    }
  },
  methods: {
    save () {
      this.$refs.canvasSign.save(img => {
        this.imgSrc = img
      })
      // this.$refs.canvasSign.clear()
    }
  }
} */
export default {
  name: 'CanvasSign',
  props: {
    // 画布宽
    width: {
      type: Number,
      default: document.documentElement.clientWidth || document.body.clientWidth
    },
    // 画布高
    height: {
      type: Number,
      default: 200
    },
    // 画线粗细
    lineWidth: {
      type: Number,
      default: 2
    },
    // 画线颜色
    color: {
      type: String,
      default: '#000'
    },
    // 画布背景色
    background: {
      type: String,
      default: 'rgba(255, 255, 255, 0)'
    },
    // 边框宽度
    borderWidth: {
      type: Number,
      default: 1
    },
    // 边框颜色
    borderColor: {
      type: String,
      default: '#333'
    }
  },
  computed: {
    borderStyle () {
      if (this.borderWidth > 0 && this.width > this.borderWidth * 2) {
        return `border: ${this.borderWidth}px solid ${this.borderColor}`
      }
      return ''
    }
  },
  data () {
    return {
      canvas: null,
      cxt: null,
      offsetTop: 0,
      offsetLeft: 0,
      isDraw: false
    }
  },
  mounted () {
    this.$nextTick(this.init)
  },
  methods: {
    // 生成图片
    save (callback) {
      const imgBase64 = this.canvas.toDataURL()
      callback(imgBase64)
    },
    // 清空画布
    clear () {
      this.cxt.clearRect(0, 0, this.canvas.width, this.canvas.height)
    },
    // 初始化
    init () {
      const canvas = this.$refs.canvas
      this.canvas = canvas

      this.offsetTop = canvas.offsetTop // canvas上边距
      this.offsetLeft = canvas.offsetLeft // canvas左边距

      // 获取canvas context
      const cxt = canvas.getContext('2d')

      // canvas context相关设置
      cxt.fillStyle = this.background
      cxt.fillRect(0, 0, this.width, this.height)
      cxt.strokeStyle = this.color
      cxt.lineWidth = this.lineWidth
      cxt.lineCap = 'round' // 线条末端添加圆形线帽，减少线条的生硬感
      cxt.lineJoin = 'round' // 线条交汇时为原型边角
      // 利用阴影，消除锯齿
      cxt.shadowBlur = 1
      cxt.shadowColor = this.color

      this.cxt = cxt
    },
    // 移动端触摸摁下
    touchstart (e) {
      this.cxt.beginPath()
      this.cxt.moveTo(e.changedTouches[0].pageX - this.offsetLeft, e.changedTouches[0].pageY - this.offsetTop)
    },
    // pc端鼠标点下
    mousedown (e) {
      this.isDraw = true
      this.cxt.beginPath()
      this.cxt.moveTo(e.pageX - this.offsetLeft, e.pageY - this.offsetTop)
    },
    // 移动端触摸滑动
    touchmove (e) {
      e.stopPropagation()
      e.preventDefault()
      this.cxt.lineTo(e.changedTouches[0].pageX - this.offsetLeft, e.changedTouches[0].pageY - this.offsetTop)
      this.cxt.stroke()
    },
    // pc端鼠标移动
    mousemove (e) {
      e.stopPropagation()
      e.preventDefault()
      if (this.isDraw) {
        this.cxt.lineTo(e.pageX - this.offsetLeft, e.pageY - this.offsetTop)
        this.cxt.stroke()
        if (e.pageX - this.offsetLeft <= this.borderWidth ||
            e.pageX - this.offsetLeft >= this.canvas.width - this.borderWidth * 2 ||
            e.pageY - this.offsetTop <= this.borderWidth ||
            e.pageY - this.offsetTop >= this.canvas.height - this.borderWidth * 2) {
          this.isDraw = false
        }
      }
    },
    // 移动端触摸抬起
    touchend () {
      this.cxt.closePath()
    },
    // pc端鼠标松开
    mouseup () {
      this.isDraw = false
      this.cxt.closePath()
    }
  }
}
</script>
```

> 使用  

```html
<template>
  <div>
    <CanvasSign ref="canvasSign" :width="300" />
    <div>
      <button @click="save">save</button>
    </div>
    <img :src="imgSrc" alt="生成的图片" />
  </div>
</template>
<script>
import CanvasSign from '_c/canvas-sign'

export default {
  name: 'Sign',
  components: { CanvasSign },
  data () {
    return {
      imgSrc: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQYV2NgAAIAAAUAAarVyFEAAAAASUVORK5CYII='
    }
  },
  methods: {
    save () {
      this.$refs.canvasSign.save(img => {
        this.imgSrc = img
      })
    },
    clear () {
      this.$refs.canvasSign.clear()
    }
  }
}
</script>
```