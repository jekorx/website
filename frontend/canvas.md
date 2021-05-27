# Canvas

### Canvas签名

> 提供原生js版本和vue版本  

<!-- ![Canvas签名效果](../assets/canvas-sign.jpg) -->

<div>
  <style>
    #canvasBox, #signImage {
      border: 1px solid #EEE;
      width: 300px;
      height: 200px;
    }
  </style>
  <div style="display: inline-block;">
    <canvas id="canvasBox"></canvas>
    <img id="signImage" width="300" height="200" src="data:image/png;base64,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" alt="生成的图片">
    <div style="display: flex; justify-content: space-around; padding: 0 20%">
      <button id="saveBtn">生成图片</button>
      <button id="clearBtn">清空画布</button>
    </div>
  </div>
  <script>
    function drawCanvas(args) {
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
      this.imageType = 'image/png'
      this.imageQual = 0.92
      this.saveCallback = function (imgBase64, clearCanvas) { }
      this.clearCallback = function () { }
      for (var k in args) {
        this[k] = args[k]
      }
      var canvas = document.getElementById(this.el)
      if (this.borderWidth > 0 && this.width > this.borderWidth * 2) {
        this.width = this.width - this.borderWidth * 2
        canvas.style.border = this.borderWidth + 'px solid' + this.borderColor
      }
      canvas.width = this.width
      canvas.height = this.height
      var cxt = canvas.getContext('2d')
      cxt.fillStyle = this.background
      cxt.fillRect(0, 0, this.width, this.height)
      cxt.strokeStyle = this.color
      cxt.lineWidth = this.lineWidth
      cxt.lineCap = 'round'
      cxt.lineJoin = 'round'
      cxt.shadowBlur = 1
      cxt.shadowColor = this.color
      cxt.font = 'bold 20px Arial'
      cxt.fillStyle = '#000'
      cxt.fillText('Canvas签名，在此处绘制', 30, 100)
      cxt.closePath()
      var offsetTop = canvas.offsetTop
      var offsetLeft = canvas.offsetLeft
      var isDraw = false
      canvas.addEventListener('touchstart', function (e) {
        cxt.beginPath()
        cxt.moveTo(e.changedTouches[0].pageX - offsetLeft, e.changedTouches[0].pageY - offsetTop)
      }, false)
      canvas.addEventListener('mousedown', function (e) {
        isDraw = true
        cxt.beginPath()
        cxt.moveTo(e.pageX - offsetLeft, e.pageY - offsetTop)
      }, false)
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
      canvas.addEventListener('touchend', function () {
        cxt.closePath()
      }, false)
      canvas.addEventListener('mouseup', function () {
        isDraw = false
        cxt.closePath()
      }, false)
      document.getElementById(this.clearEl) && document.getElementById(this.clearEl).addEventListener('click', function () {
        cxt.clearRect(0, 0, canvas.width, canvas.height)
        this.clearCallback()
      }.bind(this), false)
      document.getElementById(this.saveEl) && document.getElementById(this.saveEl).addEventListener('click', function () {
        var imgBase64
        if (this.imageType === 'image/jpeg') {
          imgBase64 = canvas.toDataURL('image/jpeg', this.imageQual)
        } else {
          imgBase64 = canvas.toDataURL()
        }
        this.saveCallback(imgBase64, function () {
          cxt.clearRect(0, 0, canvas.width, canvas.height)
        })
      }.bind(this), false)
    }
    setTimeout(() => {
      new drawCanvas({
        el: 'canvasBox',
        width: 300,
        height: 200,
        borderColor: '#EEE',
        saveCallback: function (imgBase64, clearCanvas) {
          document.getElementById('signImage').src = imgBase64
          // 清空canvas
          // clearCanvas()
        },
        clearCallback: function () {
          document.getElementById('signImage').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQYV2NgAAIAAAUAAarVyFEAAAAASUVORK5CYII='
        }
      })
    }, 1)
  </script>
</div>

##### 1、原生JavaScript版本

> 利用canvas画布实现签名效果  

```javascript
/**
 * Canvas 签名
 * 
 * 使用：
 * new drawCanvas({
 *   saveCallback: function (imgBase64, clearCallback) {
 *     document.getElementById('signImage').src = imgBase64
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
 * <String> imageType：图片类型，默认：image/png（推荐），可选：image/jpeg（注意修改background；不推荐：清空画布再次绘制可能无法正常生成base64），image/webp（Chrome支持），其他类型均为image/png
 * <Number> imageQual：图片质量，当imageType为image/jpeg时生效，默认值：0.92，可选0~1之间，超出范围使用默认0.92
 * <Function> saveCallback(imgBase64, clearCanvas)：保存回调(base64图片，清空画布)
 * <Function> clearCallback()：清空画布回调
 */
function drawCanvas(args) {
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
  this.imageType = 'image/png'
  this.imageQual = 0.92
  this.saveCallback = function (imgBase64, clearCanvas) { }
  this.clearCallback = function () { }
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
    this.clearCallback()
  }.bind(this), false)

  // 保存图片
  document.getElementById(this.saveEl) && document.getElementById(this.saveEl).addEventListener('click', function () {
    var imgBase64
    if (this.imageType === 'image/jpeg') {
      imgBase64 = canvas.toDataURL('image/jpeg', this.imageQual)
    } else {
      imgBase64 = canvas.toDataURL()
    }
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
      el: 'canvasBox',
      width: 300,
      height: 200,
      saveCallback: function (imgBase64, clearCanvas) {
        document.getElementById('signImage').src = imgBase64
        // 清空canvas
        // clearCanvas()
      },
      clearCallback: function () {
        document.getElementById('signImage').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQYV2NgAAIAAAUAAarVyFEAAAAASUVORK5CYII='
      }
    })
  }
</script>
```

##### 2、Vue.js版本

> vue组件  
> 直接使用[npm组件](https://www.npmjs.com/package/vue-canvas-sign)  
> ```yarn add vue-canvas-sign``` or ```npm i vue-canvas-sign```  
> 输出base64图片，如需转为file文件，[可参照](./js-utils.md#base64转file)  
