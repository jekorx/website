# Css样式

### 文本换行

> ```word-break``` 指定了怎样在单词内断行。  
> ```white-space``` 用于设置如何处理元素内的空白字符。  
> ```overflow-wrap``` 是否应该在一个本来不能断开的字符串中插入换行符，以防止文本溢出其行向盒。与 word-break 相比，overflow-wrap 仅在无法将整个单词放在自己的行而不会溢出的情况下才会产生换行。  

```css
/* 在任意位置断行 */
word-break: break-all;

/* 文本不断行 */
word-break: keep-all;

/* 不允许换行 */
white-space: nowrap;

/* 连续的空白符会被保留。仅在遇到换行符或 <br> 元素时才会换行 */
white-space: pre;

/* 连续的空白符会被保留。在遇到换行符或 <br> 元素时，或者根据填充行框盒子的需要换行 */
white-space: pre-wrap;

/* 连续的空白符会被合并。在遇到换行符或 <br> 元素时，或者根据填充行框盒子的需要换行 */
white-space: pre-line;

/* 行只能在正常的单词断点（例如两个单词之间的空格）处换行 */
overflow-wrap: normal;

/* 如果行中没有其他可接受的断点，则允许在任意点将通常不可断的单词换行 */
overflow-wrap: break-word;
```

### 网站全局黑白色

```css
/**
 * 全局黑白色
 * 须在html上设置
 */
html {
  -webkit-filter: grayscale(100%);
  -moz-filter: grayscale(100%);
  -ms-filter: grayscale(100%);
  -o-filter: grayscale(100%);
  filter: grayscale(100%);
  filter: progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);
}

/**
 * 黑色主题
 */
html {
  -webkit-filter: invert(1) hue-rotate(180deg);
  filter: invert(1) hue-rotate(180deg);
}
```

### 自定义光标

<div style="width: 100px; height: 100px; margin-bottom: 10px; background-color: #EEE; cursor: url(https://www.wdg.pub/gitbook/images/favicon.ico), auto; display: flex; justify-content: center; align-items: center; text-align: center; font-size: 12px;">
光标移动到此处
</div>

```css
/* 除浏览器默认支持的光标，还支持自定义图片，.ico 或 .cur格式 */
/* 建议：1、图片地址为绝对路径，2、图片大小最好是32*32 */
div {
  cursor: url(../gitbook/images/favicon.ico), auto;
}
```

### 水平垂直居中

```html
<div class="center">
  <span>水平垂直居中</span>
</div>
```

```css
/* 默认初始化样式 */
body {
  height: 500px;
}
.center {
  height: 20%;
  border: 1px solid #666;
}

/* 1、flex水平垂直居中，👍推荐使用🔥 */
/* 设为 Flex 布局以后，子元素的float、clear和vertical-align属性将失效 */
.center {
  display: flex;
}
.center >span {
  margin: auto;
}
/* 衍生写法，可直接居中容器中的文本 */
.center {
  justify-content: center;
  align-items: center;
}

/* 2、grid水平垂直居中 */
/* ❗ 注意兼容性要求浏览器版本较高 */
.center {
  display: grid;
}
.center >span {
  margin: auto;
}

/* 3、line-height水平垂直居中 */
/* 
父节点固定px高度
*/
.center {
  text-align: center;
  height: 100px;
  line-height: 100px;
}

/* 4、绝对定位水平垂直居中 */
/* 
子节点固定px高度
.center {
  text-align: center;
  position: relative;
}
.center span {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  margin: auto;
  width: 200px;
  height: 21px;
  text-align: center;
}
*/
/*
衍生写法，❗ 基于Chromium的浏览器中会导致文本的模糊问题 ❗
top、left偏移父容器的50%，通过transform: translate偏移自身-50%实现居中
可不设置子节点宽高
*/
.center >span {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
}

/* 5、伪类水平垂直居中 */
/* 
容器before伪类生成一个行内节点，高100%，宽1px，margin-right: -1px，消除1px的占用
容器所有子节点都需要设置vertical-align: middle
容器通常情况下字体大小不为0，代码的换行符会占用一个字符的位置，此处应将容器字体大小设为0，内容节点中重新设置字体大小
*/
.center {
  text-align: center;
  font-size: 0;
}
.center::before {
  content: "";
  display: inline-block;
  height: 100%;
  width: 1px;
  margin-right: -1px;
  vertical-align: middle;
}
.center span {
  font-size: 16px;
  vertical-align: middle;
}

/* 6、table-cell水平垂直居中 */
/* 
父容器宽度默认内容宽度
当display: table时，padding失效
当display: table-row时，margin、padding失效
当display: table-cell时，margin失效
*/
.center {
  display: table;
  width: 100%;
}
.center span {
  display: table-cell;
  vertical-align: middle;
  text-align: center;
}
```

### 文本超出省略号

```css
/**
 * 单行文本
 * 注意：固定宽度
 */
.text {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
/**
 * 多行文本
 * 注意：固定宽度，容器padding属性会导致文本无法隐藏
 * 只适用于WebKit内核的浏览器
 */
.text {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  text-overflow: ellipsis;
}
```

###### CSS 实现多行文本“展开收起”

<div style="padding-bottom: 20px;">
  <style>
    .line-clamp .wrapper {
      display: flex;
      width: 600px;
      overflow: hidden;
      border-radius: 8px;
      padding: 15px;
      box-shadow: 5px 5px 15px #BEBEBE, -5px -5px 15px #FFFFFF;
    }
    .line-clamp .text {
      font-size: 18px;
      overflow: hidden;
      text-overflow: ellipsis;
      text-align: justify;
      position: relative;
      line-height: 1.5;
      max-height: 3em;
      transition: .3s max-height;
    }
    .line-clamp .text::before {
      content: "";
      height: 100%;
      margin-bottom: -26px;
      float: right;
    }
    .line-clamp .text::after {
      content: "";
      width: 100%;
      height: 100%;
      position: absolute;
      background: #FFF;
    }
    .line-clamp .btn {
      position: relative;
      float: right;
      clear: both;
      margin-left: 20px;
      font-size: 14px;
      padding: 0 8px;
      background: #3F51B5;
      line-height: 24px;
      border-radius: 4px;
      color: #FFF;
      cursor: pointer;
    }
    .line-clamp .btn::after {
      content: "展开";
    }
    .line-clamp .exp {
      display: none;
    }
    .line-clamp .exp:checked + .text {
      max-height: 180px;
    }
    .line-clamp .exp:checked + .text::after {
      visibility: hidden;
    }
    .line-clamp .exp:checked + .text .btn::before {
      visibility: hidden;
    }
    .line-clamp .exp:checked + .text .btn::after {
      content: "收起";
    }
    .line-clamp .btn::before {
      content: "...";
      position: absolute;
      left: -5px;
      color: #333;
      transform: translateX(-100%);
    }
  </style>
  <div class="line-clamp">
    <div class="wrapper">
      <input id="exp-check" class="exp" type="checkbox">
      <div class="text">
        <label class="btn" for="exp-check"></label>
        原文链接：https://juejin.cn/post/6963904955262435336， 1、文本环绕效果首先考虑浮动 float； 2、flex 布局子元素可以通过百分比计算高度； 3、多行文本截断还可以结合文本环绕效果用max-height模拟实现； 4、状态切换可以借助 checkbox； 5、CSS 改变文本可以采用伪元素生成。
      </div>
    </div>
  </div>
</div>

```html
<div class="wrapper">
  <input id="exp-check" class="exp" type="checkbox">
  <div class="text">
    <label class="btn" for="exp-check"></label>
    很长的文字内容 ... ...
  </div>
</div>
```

```css
.wrapper {
  display: flex;
  width: 600px;
  overflow: hidden;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 20px 20px 60px #BEBEBE, -20px -20px 60px #FFFFFF;
}
.text {
  font-size: 18px;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: justify;
  position: relative;
  line-height: 1.5;
  /* 最大高度（px） = 字体大小（px） x 行高 x 行数 */
  /* 最大高度（em） = 行高 x 行数 */
  max-height: 3em;
  transition: .3s max-height;
}
/* 控制按钮一直在最右下角 */
.text::before {
  content: "";
  height: 100%;
  /* -(btn高度 + 2)，可通过调试获取 */
  margin-bottom: -26px;
  float: right;
}
/* 在内容未发生截断时，遮盖btn，也可通过 el.scrollHeight > el.clientHeight 时判断文本超出 */
.text::after {
  content: "";
  width: 100%;
  height: 100%;
  position: absolute;
  background: #FFF;
}
.btn {
  position: relative;
  float: right;
  clear: both;
  margin-left: 20px;
  font-size: 14px;
  padding: 0 8px;
  background: #3F51B5;
  line-height: 24px;
  border-radius: 4px;
  color: #FFF;
  cursor: pointer;
}
.btn::after {
  content: "展开";
}
/* 用过checkbox的:checked状态控制按钮、省略号显示以及文本高度 */
.exp {
  display: none;
}
.exp:checked + .text {
  /* 展开后文本区域高度，直接设置最大高度为一个较大的值，或者直接设置为none，设置none后transition动画效果失效 */
  max-height: none;
}
.exp:checked + .text::after {
  visibility: hidden;
}
.exp:checked + .text .btn::before {
  visibility: hidden;
}
.exp:checked + .text .btn::after {
  content: "收起";
}
.btn::before {
  content: "...";
  position: absolute;
  left: -5px;
  color: #333;
  transform: translateX(-100%);
}
```

### 渐变色

<div>
  <div style="display: flex; width: 400px; justify-content: space-around;">
    <div style="width: 100px; height: 100px; background-image: linear-gradient(to right, red, yellow, green);"></div>
    <div style="width: 100px; height: 100px; background-image: radial-gradient(red, green);"></div>
    <div style="width: 100px; height: 100px; background-image: conic-gradient(from 45deg at 50% 50%, red, orange, yellow, green, blue, purple, red);"></div>
  </div>
  <div style="display: flex; width: 400px; justify-content: space-around;">
    <span>线性渐变</span>
    <span>径向渐变</span>
    <span>圆锥渐变</span>
  </div>
</div>

```css
/**
 * 线性就变
 * background-image: linear-gradient(direction, color-stop1, color-stop2, ...);
 *
 * direction（可不写，默认：to bottom（从上到下））：渐变方向、角度
 * 渐变方向：to right（从左到右），to bottom right（从左上角到右下角）
 * 角度：0deg 将创建一个从下到上的渐变，90deg 将创建一个从左到右的渐变
 *
 * repeating-linear-gradient：重复渐变
 */
.box {
  background-color: red; /* 浏览器不支持的时候显示 */
  background-image: linear-gradient(to right, red, yellow, green);
}
.box {
  background-color: red; /* 浏览器不支持的时候显示 */
  background-image: repeating-linear-gradient(red, yellow 10%, green 20%);
}

/**
 * 径向渐变
 * background-image: radial-gradient(shape size at position, start-color, ..., last-color);
 *
 * shape size at position：（可不写，默认：渐变的中心是 center（表示在中心点），渐变的形状是 ellipse（表示椭圆形），渐变的大小是 farthest-corner（表示到最远的角落））
 *   shape：circle 表示圆形，ellipse 表示椭圆形（默认）
 *   size：
 *      closest-side：指定径向渐变的半径长度为从圆心到离圆心最近的边
 *      closest-corner：指定径向渐变的半径长度为从圆心到离圆心最近的角
 *      farthest-side：指定径向渐变的半径长度为从圆心到离圆心最远的边
 *      farthest-corner：指定径向渐变的半径长度为从圆心到离圆心最远的角
 *
 * repeating-radial-gradient：重复渐变
 */
.box {
  background-color: red; /* 浏览器不支持的时候显示 */
  background-image: radial-gradient(red, green);
}
.box {
  background-color: red; /* 浏览器不支持的时候显示 */
  background-image: repeating-radial-gradient(red, yellow 10%, green 15%);
}

/**
 * 圆锥渐变
 * background-image: conic-gradient(from <angle> at <position>, color-stop1, color-stop2, ...);
 * from <angle> at <position>：（可不写，默认：from 0deg at center）
 *
 * repeating-conic-gradient：重复渐变
 */
.box {
  background-color: red; /* 浏览器不支持的时候显示 */
  background-image: conic-gradient(from 45deg at 20% 40%, red, orange, yellow, green, blue, purple, red);
}
.box {
  background-color: red; /* 浏览器不支持的时候显示 */
  background-image: repeating-conic-gradient(#fff 0 9deg, #000 9deg 18deg);
}
```

### div+css绘制六边形

<div>
  <style>
  .corner {
    width: 0;
    height: 0;
    border-right: 20px solid #EEE;
    border-top: 20px solid red;
    border-bottom: 20px solid #CCC;
    border-left: 20px solid #EEE;
  }
  .hexagon {
    width: 40px;
    height: 64px;
    background-color: purple;
    position: relative;
    font-size: 14px;
    color: #FFF;
    border-radius: 0;
    border: 0;
  }
  .hexagon:before {
    content: '';
    width: 0;
    height: 0;
    position: absolute;
    top: 0;
    left: -20px;
    border-right: 20px solid purple;
    border-top: 32px solid transparent;
    border-bottom: 32px solid transparent;
  }
  .hexagon:after {
    content: '';
    width: 0;
    height: 0;
    position: absolute;
    top: 0;
    right: -20px;
    border-left: 20px solid purple;
    border-top: 32px solid transparent;
    border-bottom: 32px solid transparent;
  }
  </style>
  <div style="display: flex; width: 400px; align-items: center; justify-content: space-around; padding: 20px">
    <div class="corner"></div>
    <div class="hexagon"></div>
  </div>
</div>

```css
/**
 * 关键点：使用border绘制三角形
 * 箭头向上的三角形：border-bottom：颜色，border-left：透明色，border-right：透明色
 * 箭头向右的三角形：border-left：颜色，border-top：透明色，border-bottom：透明色
 * 箭头向下的三角形：border-top：颜色，border-left：透明色，border-right：透明色
 * 箭头向左的三角形：border-right：颜色，border-top：透明色，border-bottom：透明色
 */
.hexagon {
  width: 40px;
  height: 64px;
  background-color: purple;
  position: relative;
  font-size: 14px;
  color: #FFF;
  border-radius: 0;
  border: 0;
}
.hexagon:before {
  content: '';
  width: 0;
  height: 0;
  position: absolute;
  top: 0;
  left: -20px;
  border-right: 20px solid purple;
  border-top: 32px solid transparent;
  border-bottom: 32px solid transparent;
}
.hexagon:after {
  content: '';
  width: 0;
  height: 0;
  position: absolute;
  top: 0;
  right: -20px;
  border-left: 20px solid purple;
  border-top: 32px solid transparent;
  border-bottom: 32px solid transparent;
}
```

### div+css实现四角边框

<div style="padding-bottom: 10px;">
  <style>
    .qrcode-box1 {
      display: inline-block;
      border: 1px solid #3295D1;
      box-sizing: border-box;
      padding: 10px;
      width: 160px;
      height: 160px;
      background: linear-gradient(#3295D1, #3295D1) -155px -128px no-repeat,
                  linear-gradient(#3295D1, #3295D1) -128px -155px no-repeat,
                  linear-gradient(#3295D1, #3295D1) 128px -155px no-repeat,
                  linear-gradient(#3295D1, #3295D1) 155px -128px no-repeat,
                  linear-gradient(#3295D1, #3295D1) -155px 128px no-repeat,
                  linear-gradient(#3295D1, #3295D1) -128px 155px no-repeat,
                  linear-gradient(#3295D1, #3295D1) 128px 155px no-repeat,
                  linear-gradient(#3295D1, #3295D1) 155px 128px no-repeat;
    }
  </style>
  <div class="qrcode-box1">
    <img style="filter:blur(5px); width: 100%; height: 100%" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAACWAQAAAAAUekxPAAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAIKSURBVHjatZZNkqMwDIXl8sJLjsBFUuZaWdDQ3AyqL+IjeHYsaDRPsslkgJlKA3FlET7/SJbkZxNv2kRXs5GITHDMjiPP+KD6HKuYOx4NjxasYI5gLfOgzFzMbGwX1pAb2PUFHLBzQWaXfbw4LrMge7I8+jUzmbUvsvrfTO2auPXlIpZiRUhWQf6v+B1jKb9E98zCUgfYlRvi6J9r4zQLC0v1CovjTX34U88H2VwiPljdwoblqYqZiUXxxQirzzEObkZPQVW0ffEe9il1hTSRJ90YPbPbf1izwz6Ie3Ldei4HrI7IoQ7wQ2nxDvs+wSRHMJrOB2qX2pS311m3Zl+/+EuZtnYmsI51OvphV1h9js2lQ7igf1MB/Wv7dzBmBAoCi5M9ebHbPlgAG3325RjjtA9JO84bdAP5yPV8iqFNVEKfJ/mTbFClclJFlo1t2dFxAeyuuuFV/2ZCFHmISUua40yEzpcSrkm1bpYzs2Hti2x/7ogoUTk1RL6EUTggd1QJCUE3hsoFtM+aHVbvMpW/IJniqFfcFSwmdgebFs1mpznC3mz/Dib3EQpXnhyLL6eY3slOZULseZRWZvxg0Lqfsvhgeb34PC4zuUPFF8NW32FnGU5BgbeK5WiHx3tDmLmGpbcAZPsmgWLR7BVrf8q6NdOcI0ROTQPXlzCoaonQfEp+t29gPsG+99hvI1wxCxAb1yIAAAAASUVORK5CYII=">
  </div>
</div>

> **方式一**：通过```:before``` ```:after```伪类实现（也可使用4个div实现）  
> 原包裹div实现顶部两个角，增加一个div实现底部两个角，确保新增加div与原包裹div重合  
> **优点**：可以根据图片大小自适应，易于理解；**缺点**：实现复杂，dom多、代码多  

```html
<div class="qrcode-box">
  <!-- <img src="..." /> -->
  <div class="qrcode-box-background"></div>
</div>
```

```css
.qrcode-box {
  display: inline-block;
  border: 1px solid #3295D1;
  box-sizing: border-box;
  padding: 10px;
  position: relative;
}
.qrcode-box .qrcode-box-background {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}
.qrcode-box::before,
.qrcode-box::after,
.qrcode-box .qrcode-box-background::before,
.qrcode-box .qrcode-box-background::after {
  content: "";
  display: block;
  position: absolute;
  width: 30px;
  height: 30px;
}
.qrcode-box::before {
  top: 0;
  left: 0;
  border-top: 3px solid #3295D1;
  border-left: 3px solid #3295D1;
}
.qrcode-box::after {
  top: 0;
  right: 0;
  border-top: 3px solid #3295D1;
  border-right: 3px solid #3295D1;
}
.qrcode-box .qrcode-box-background::before {
  bottom: 0;
  left: 0;
  border-bottom: 3px solid #3295D1;
  border-left: 3px solid #3295D1;
}
.qrcode-box .qrcode-box-background::after {
  bottom: 0;
  right: 0;
  border-bottom: 3px solid #3295D1;
  border-right: 3px solid #3295D1;
}
```

> **方式二**：通过在```background```中使用8个```linear-gradient```渐变色，并将每个背景色偏移出div范围实现  
> **优点**：dom少，代码少；**缺点**：固定宽高，计算位置复杂，不易理解  
> **注意：偏移量计算方式，内部img需限制宽高**  

```html
<div class="qrcode-box">
  <!-- <img src="..." /> -->
</div>
```

```css
.qrcode-box {
  display: inline-block;
  border: 1px solid #3295D1;
  box-sizing: border-box;
  padding: 10px;
  width: 160px;
  height: 160px;
  /* 
   * 边角宽3px，高30px，偏移量计算方式
   * box宽（160px）- border（1px）- 1px - 边角宽3px = 155px
   * box宽（160px）- border（1px）- 1px - 边角高30px = 128px
   */
  background: linear-gradient(#3295D1, #3295D1) -155px -128px no-repeat,
              linear-gradient(#3295D1, #3295D1) -128px -155px no-repeat,
              linear-gradient(#3295D1, #3295D1) 128px -155px no-repeat,
              linear-gradient(#3295D1, #3295D1) 155px -128px no-repeat,
              linear-gradient(#3295D1, #3295D1) -155px 128px no-repeat,
              linear-gradient(#3295D1, #3295D1) -128px 155px no-repeat,
              linear-gradient(#3295D1, #3295D1) 128px 155px no-repeat,
              linear-gradient(#3295D1, #3295D1) 155px 128px no-repeat;
}
```

### 固定宽高比的自适应矩形

<div>
  <style>
    .rect-item {
      overflow: hidden;
      position: relative;
      background-color: #CCC;
      width: 40%;
      display: inline-block;
      vertical-align: middle;
    }
    .rect-item:after {
      content: "";
      display: block;
      padding-top: 100%;
    }
    .react:after {
      padding-top: 50%;
    }
    .rect-wrap {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      display: flex;
      align-items: center;
      text-align: center;
      justify-content: center;
      font-size: 12px;
    }
    .auto-resize-rect-wrap {
      resize: horizontal;
      overflow: auto;
      width: 540px;
      min-width: 300px;
      max-width: 700px;
      margin-bottom: 10px;
      background-color: #EEE;
    }
  </style>
  <div class="auto-resize-rect-wrap">
    <div class="rect-item" style="margin: 10px">
      <div class="rect-wrap">
        <p style="margin: 0">正方形</p>
      </div>
    </div>
    <div class="rect-item react">
      <div class="rect-wrap">
        <p style="margin: 0">宽高比 2:1的矩形</p>
      </div>
    </div>
  </div>
</div>

> 核心：```padding-top``` ```padding-bottom``` ```margin-top``` ```margin-bottom``` 为**百分比**是相对**父元素** **宽度**  
> 使用伪元素的```padding-top```或```padding-bottom```或```margin-top```或```margin-bottom```为**百分比**撑起父元素高度实现  
> 使用```margin-top``` ```margin-bottom```时，父元素需触发[**BFC**](https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Block_formatting_context)，常用触发方式：```display: inline-block``` 或 ```overflow: hidden```  

```html
<div class="rect-item">
  <div class="rect-wrap">
    <p>正方形</p>
  </div>
</div>
```

```css
/**
 * 1、通过padding-top
 * padding-top使用百分比，可以控制宽高比
 */
.rect-item {
  position: relative;

  background-color: #EEE;
  width: 50%;
}
.rect-item:after {
  content: "";
  display: block;
  padding-top: 100%;
}
.rect-wrap {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}

/**
 * 2、通过margin-bottom
 * margin-bottom使用百分比，可以控制宽高比
 */
.rect-item {
  position: relative;
  display: inline-block;

  background-color: #EEE;
  width: 50%;
}
.rect-item:after {
  content: "";
  display: block;
  margin-bottom: 50%;
}
.rect-wrap {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}
```

### 根据兄弟元素的数量来设置样式

<div style="padding-bottom: 10px;">
  <style>
  #count-selector ul {
    padding: 0 0 10px;
    margin: 0;
    list-style: none;
    font-size: 0;
    user-select: none;
  }
  #count-selector ul >li {
    display: inline-block;
    width: 36px;
    height: 36px;
    background-color: #CCC;
    border-radius: 6px;
    color: #FFF;
    text-align: center;
    line-height: 36px;
    font-size: 12px;
    margin-left: 10px;
  }
  #count-selector ul >li:only-child {
    color: #b30096;
    font-weight: 700;
    font-size: 16px;
    border-radius: 50%;
  }
  #count-selector ul >li:first-child:nth-last-child(2),
  #count-selector ul >li:first-child:nth-last-child(2) ~ li {
    color: #d89a00;
    font-weight: 700;
    font-size: 16px;
    border-radius: 50%;
  }
  #count-selector ul >li:nth-child(1):nth-last-child(3),
  #count-selector ul >li:nth-child(1):nth-last-child(3) ~ li {
    color: #4441f1;
    font-weight: 700;
    font-size: 16px;
    border-radius: 50%;
  }
  #count-selector ul >li:first-child:nth-last-child(n+8),
  #count-selector ul >li:first-child:nth-last-child(n+8) ~ li {
    background-color: brown;
  }
  #count-selector ul >li:first-child:nth-last-child(-n+2),
  #count-selector ul >li:first-child:nth-last-child(-n+2) ~ li {
    background-color: forestgreen;
  }
  #count-selector ul >li:first-child:nth-last-child(n+5):nth-last-child(-n+6),
  #count-selector ul >li:first-child:nth-last-child(n+5):nth-last-child(-n+6) ~ li {
    background-color: #008eff;
  }
  #count-selector {
    margin-top: -10px;
    padding-top: 10px;
    position: relative;
    min-width: 700px;
    overflow-x: auto;
  }
  #count-selector >div {
    position: absolute;
    font-size: 12px;
  }
  #count-selector pre {
    padding: 3px;
    border-radius: 3px;
    margin: 0;
    display: inline-block;
    font-size: 12px;
    background-color: #CCC;
    color: #FFF;
    font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace;
    direction: ltr;
    font-weight: 600;
    user-select: all;
    vertical-align: middle;
  }
  </style>
  <div id="count-selector">
    <div style="top: 17px; left: 52px">
      <pre style="border-radius: 20px; color: #b30096">ul >li:only-child</pre> 等价
    </div>
    <div style="top: 17px; left: 203px">
      <pre style="border-radius: 20px; color: #b30096">ul >li:first-child:last-child</pre> 等价
    </div>
    <div style="top: 17px; left: 437px">
      <pre style="border-radius: 20px; color: #b30096">ul >li:nth-child(1):nth-last-child(1)</pre>
    </div>
    <div style="top: 65px; left: 99px">
      <pre style="border-radius: 20px; color: #d89a00">ul >li:first-child:nth-last-child(2), ul >li:first-child:nth-last-child(2) ~ li</pre>
    </div>
    <div style="top: 110px; left: 144px">
      <pre style="border-radius: 20px; color: #4441f1">ul >li:nth-child(1):nth-last-child(3), ul >li:nth-child(1):nth-last-child(3) ~ li</pre>
    </div>
    <div style="top: 41px; left: 30px">
      <pre style="background-color: forestgreen">ul >li:first-child:nth-last-child(-n+2), ul >li:first-child:nth-last-child(-n+2) ~ li</pre>
    </div>
    <div style="top: 215px; left: 225px">
      <pre style="background-color: #008eff">ul >li:first-child:nth-last-child(n+5):nth-last-child(-n+6),
ul >li:first-child:nth-last-child(n+5):nth-last-child(-n+6) ~ li</pre>
    </div>
    <div style="top: 353px; left: 363px">
      <pre style="background-color: brown">ul >li:first-child:nth-last-child(n+8),
ul >li:first-child:nth-last-child(n+8) ~ li</pre>
    </div>
    <ul>
      <li>1</li>
    </ul>
    <ul>
      <li>1</li><li>2</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li><li>4</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li><li>4</li><li>5</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li><li>7</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li><li>7</li><li>8</li>
    </ul>
    <ul>
      <li>1</li><li>2</li><li>3</li><li>4</li><li>5</li><li>6</li><li>7</li><li>8</li><li>9</li>
    </ul>
  </div>
</div>

> **核心**：  
> **1**、CSS选择器 ```~```，表示某元素后所有同级的指定元素  
> **2**、```:nth-child```（正数）```:nth-last-child```（倒数）：选择属于其父元素的指定第几个子元素的每个指定元素，常用使用如下：  
> ```:nth-child(2)```：正数第2个元素  
> ```:nth-child(n)```：正数 >= 1 的元素，即：全部指定元素  
> ```:nth-child(n+2)```：正数 >= 2 的元素，即：正数第2个以及后面全部指定元素  
> ```:nth-child(-n+2)```：正数 <= 2 的元素，即：正数第1、2个指定元素  
> ```:nth-child(2n-1)```：正数 奇数 的元素，等价于```:nth-child(odd)```，即：正数数第1、3、5、...个指定元素  
> ```:nth-last-child(2)```：倒数第2个元素  
> ```:nth-last-child(n)```：倒数 >= 1 的元素，即：全部指定元素  
> ```:nth-last-child(n+2)```：倒数 >= 2 的元素，即：倒数第2个以及前面全部指定元素  
> ```:nth-last-child(-n+2)```：倒数 <= 2 的元素，即：倒数第1、2个指定元素  
> ```:nth-last-child(2n)```：倒数 偶数 的元素，等价于```:nth-last-child(even)```，即：倒数第2、4、6、...个指定元素  
> **注意**：2 中涉及的选择器会选择其父级元素下所有指定子元素，具体可参照下图：  

![css-selector](../assets/front-end-css-1.jpg)

```css
/**
 * 只包含一个元素
 * :only-child 等价于 :first-child:last-child 等价于 :nth-child(1):nth-last-child(1)
 * 只包含一个元素
 */
ul >li:only-child {
/* ul >li:first-child:last-child { */
/* ul >li:nth-child(1):nth-last-child(1) { */
}
/**
 * 元素数 = 2 的全部元素
 */
ul >li:first-child:nth-last-child(2),
ul >li:first-child:nth-last-child(2) ~ li {
}
/**
 * 元素数 = 3 的全部元素
 */
ul >li:nth-child(1):nth-last-child(3),
ul >li:nth-child(1):nth-last-child(3) ~ li {
}
/**
 * 元素数 >= 8 的全部元素
 */
ul >li:first-child:nth-last-child(n+8),
ul >li:first-child:nth-last-child(n+8) ~ li {
}
/**
 * 元素数 <= 2 的全部元素
 */
ul >li:first-child:nth-last-child(-n+2),
ul >li:first-child:nth-last-child(-n+2) ~ li {
}
/**
 * 元素数 >= 5 && <= 6 的全部元素
 */
ul >li:first-child:nth-last-child(n+5):nth-last-child(-n+6),
ul >li:first-child:nth-last-child(n+5):nth-last-child(-n+6) ~ li {
}
```

### 九宫格图片展示

<div style="padding-bottom: 10px;">
  <style>
    .album-wrap {
      width: 540px;
      min-width: 200px;
      max-width: 700px;
      box-sizing: border-box;
      padding: 5px;
      background-color: #EEE;
      font-size: 0;
      margin-bottom: 10px;
      resize: horizontal;
      overflow: auto;
    }
    .album-wrap img {
      width: 100%;
      height: 100%;
      background-color: #CCC;
      -o-object-fit: cover;
      object-fit: cover;
    }
    .album-wrap .rect-item {
      width: calc(100% / 3);
      position: relative;
      display: inline-block;
      width: calc(100% / 3);
      min-width: initial;
      max-width: initial;
      background-color: #EEE;
    }
    .album-wrap .rect-wrap {
      padding: 5px;
    }
    .album-wrap .rect-item:first-child:last-child {
      width: 100%;
    }
    .album-wrap .rect-item:first-child:last-child:after {
      padding-top: 50%;
    }
    .album-wrap .rect-item:first-child:nth-last-child(2),
    .album-wrap .rect-item:first-child:nth-last-child(2) ~ .rect-item {
      width: 50%;
    }
    .album-wrap .rect-item:first-child:nth-last-child(4),
    .album-wrap .rect-item:first-child:nth-last-child(4) ~ .rect-item {
      width: 50%;
    }
    .album-wrap .rect-item:first-child:nth-last-child(4):after,
    .album-wrap .rect-item:first-child:nth-last-child(4) ~ .rect-item:after {
      padding-top: 70%;
    }
  </style>
  <div style="display: flex; justify-content: space-around; padding-bottom: 10px; max-width: 540px; min-width: 200px; font-size: 12px">
    <button id="add-img">Add a image</button>
    <button id="remove-img">Remove last image</button>
  </div>
  <div id="album-wrap" class="album-wrap"></div>
  <script>
    function addImageItem () {
      var div = document.createElement('div')
      div.className = 'rect-item'
      var wrap = document.createElement('div')
      wrap.className = 'rect-wrap'
      div.appendChild(wrap)
      var img = document.createElement('img')
      img.src = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/wgALCABIAEgBAREA/8QAGgABAAIDAQAAAAAAAAAAAAAAAAMEAQIFBv/aAAgBAQAAAAH0AAEdLN7YOdx9PTTMQz8Wv2rBjz6pb7sgpcJ3rg1hoy220jXG4AB//8QAIhAAAgEDBAIDAAAAAAAAAAAAAQIDAAQQERITIDEzFDBA/9oACAEBAAEFAvtdgi/LjoXcZPnte+pmLYi9WUffi5mVxAm+RFcHpvMdxNOZcW6CRlG1ek8PICNCBqYIuNepXbUwD3M6qlaB64xSgaY80FC/g//EACoQAAECBAMGBwAAAAAAAAAAAAEAIQIRIFEQEkEDIjEycYEwQEKCkZKx/9oACAEBAAY/AvFmVwiUnrHVCejYQdKIm4GWAhhfWaYyk63tpm7UxEXVhbAg2QFqZjmUjopBPzVTGc+5Q5mZbOKxA7IF/ler7FN+0MAPIf/EACcQAQABAgYBAgcAAAAAAAAAAAERACEQIDFBUWGhcfAwQLHB0eHx/9oACAEBAAE/IfiqHgPNfyz80AgZdWLeaEEjI75va9NXBmEPTDxv0ycQn164W0Q/op4pYgxO9S6JGkTK8189k1EkQ+q+HK/jp5q+8wDKe0S3fVI1hUNIdxWCtvSusXOsqSJQwBZ0l92hlxTaJm+lWpi+cUhyxS0Irt97ugXVG8qcUBCSO1FQRwHyH//aAAgBAQAAABAAAwOMReAgWAAAf//EACQQAQACAgIBAwUBAAAAAAAAAAERIQAxQVEQIGFxMECBkfCh/9oACAEBAAE/EPqjvAtoKiYJ2+IFTvEIJcrwwyYEgsfV/h4cOXToaPH8fp5cf96ikX7b8UNIrEMJRPzOfPj1gcfLjGRwKl7k/r9DrFu4zB2Sx6zsnLHITMTzrwd3M72AQOpzu02ImCPS3qtNwB7Bt3hXSgSMM9lbMOaGCQlmiWt4YxWkSQNiZBPSbiwiUo/syCEUDe9giVrGn2HIl7jUzuc93viwSxHMR84msSUejZQnfjkT0ukPvKteXJgQqxxi8Mogn8fYf//Z'
      wrap.appendChild(img)
      document.getElementById('album-wrap').appendChild(div)
    }
    addImageItem()
    addImageItem()
    document.getElementById('add-img').onclick = function () {
      var imgs = document.getElementById('album-wrap').children
      if (imgs && imgs.length < 9) {
        addImageItem()
      }
    }
    document.getElementById('remove-img').onclick = function () {
      var imgs = document.getElementById('album-wrap').children
      if (imgs && imgs.length > 1) {
        document.getElementById('album-wrap').removeChild(imgs[imgs.length - 1])
      }
    }
  </script>
</div>

> 图片展示根据数量不同而自动适配不同布局效果，主要针对仅有1个、2个、4个的情况  
> 布局根据 [根据兄弟元素的数量来设置样式](#根据兄弟元素的数量来设置样式) 实现  
> 自适应根据 [固定宽高比的自适应矩形](#固定宽高比的自适应矩形) 实现  

```css
/* 仅有1个元素 */
.album-wrap .rect-item:first-child:last-child {
  width: 100%;
}
.album-wrap .rect-item:first-child:last-child:after {
  padding-top: 50%;
}
/* 仅有2个元素 */
.album-wrap .rect-item:first-child:nth-last-child(2),
.album-wrap .rect-item:first-child:nth-last-child(2) ~ .rect-item {
  width: 50%;
}
/* 仅有4个元素 */
.album-wrap .rect-item:first-child:nth-last-child(4),
.album-wrap .rect-item:first-child:nth-last-child(4) ~ .rect-item {
  width: 50%;
}
.album-wrap .rect-item:first-child:nth-last-child(4):after,
.album-wrap .rect-item:first-child:nth-last-child(4) ~ .rect-item:after {
  padding-top: 70%;
}
```

### 输入框占位符交互

<div style="padding-bottom: 10px;">
  <style>
    .input-control {
      appearance: none;
      -webkit-appearance: none;
      background-color: #FFF;
      background-image: none;
      font-size: 14px;
      padding: 0 12px;
      height: 34px;
      line-height: 34px;
      box-sizing: border-box;
      border: 1px solid #DCDFE6;
      border-radius: 4px;
      outline: none;
      transition: border-color .2s cubic-bezier(.645, .045, .355, 1);
    }
    .input-control::placeholder {
      color: #C0C4CC
    }
    .input-control:hover {
      border-color: #C0C4CC
    }
    .input-control:focus {
      outline: none;
      border-color: #409EFF
    }
    .input-box {
      display: inline-block;
      position: relative;
    }
    .input-control:placeholder-shown::placeholder {
      color: transparent;
    }
    .input-label {
      color: #C0C4CC;
      font-size: 14px;
      position: absolute;
      left: 13px;
      top: 16px;
      pointer-events: none;
      line-height: 0;
      height: 2px;
      background-color: #FFF;
      transition: transform .2s cubic-bezier(.645, .045, .355, 1), color .2s cubic-bezier(.645, .045, .355, 1);
    }
    .input-control:not(:placeholder-shown) ~ .input-label,
    .input-control:focus ~ .input-label {
      color: #409EFF;
      transform: scale(0.84) translate(-1px, -20px);
    }
  </style>
  <div class="input-box">
    <input class="input-control" type="text" placeholder="姓名" />
    <label class="input-label">姓名</label>
  </div>
</div>

> 输入框聚焦时，输入框的占位符内容以动画形式移动到左上角作为标题  
> 借助```:placeholder-shown```伪类实现  

```html
<div class="input-box">
  <input class="input-control" type="text" placeholder="姓名" />
  <label class="input-label">姓名</label>
</div>
```

```css
/* 输入框美化 start */
.input-control {
  appearance: none;
  -webkit-appearance: none;
  background-color: #FFF;
  background-image: none;
  font-size: 14px;
  padding: 0 12px;
  height: 34px;
  line-height: 34px;
  box-sizing: border-box;
  border: 1px solid #DCDFE6;
  border-radius: 4px;
  outline: none;
  transition: border-color .2s cubic-bezier(.645, .045, .355, 1);
}
.input-control::placeholder {
  color: #C0C4CC;
}
.input-control:hover {
  border-color: #C0C4CC;
}
.input-control:focus {
  outline: none;
  border-color: #409EFF;
}
/* 输入框美化 end */

.input-box {
  display: inline-block;
  position: relative;
}
/* 使默认placeholder效果不可见 */
.input-control:placeholder-shown::placeholder {
  color: transparent;
}
/* 使用.input-label代替原来占位符 */
.input-label {
  color: #C0C4CC;
  font-size: 14px;
  position: absolute;
  left: 13px;
  top: 16px;
  pointer-events: none;
  line-height: 0;
  height: 2px;
  background-color: #FFF;
  transition: transform .2s cubic-bezier(.645, .045, .355, 1), color .2s cubic-bezier(.645, .045, .355, 1);
}
/* 输入框获取焦点 */
.input-control:not(:placeholder-shown) ~ .input-label,
.input-control:focus ~ .input-label {
  color: #409EFF;
  transform: scale(0.84) translate(-1px, -20px);
}
```

### hover效果

<div style="padding-bottom: 10px;">
  <style>
    span.link1 {
      display: inline-block;
      color: #409EFF;
      cursor: pointer;
      padding-bottom: 4px;
      text-decoration: none;
      position: relative;
    }
    span.link1:after {
      content: "";
      position: absolute;
      width: 100%;
      height: 2px;
      bottom: 0;
      left: 0;
      transform: scaleX(0);
      background-color: #409EFF;
      transform-origin: bottom right;
      transition: transform .3s ease-in-out;
    }
    span.link1:hover:after {
      transform: scaleX(1);
      transform-origin: bottom left;
    }
  </style>
  <div><span class="link1">hover效果 - 1，underline划过效果</span></div>
</div>

```css
/* hover效果 - 1，underline划过效果，核心：transform-origin 更改一个元素变形的原点 */
.link1 {
  display: inline-block;
  color: #409EFF;
  cursor: pointer;
  padding-bottom: 4px;
  text-decoration: none;
  position: relative;
}
.link1:after {
  content: "";
  position: absolute;
  width: 100%;
  height: 2px;
  bottom: 0;
  left: 0;
  transform: scaleX(0);
  background-color: #409EFF;
  transform-origin: bottom right;
  transition: transform .3s ease-in-out;
}
.link1:hover:after {
  transform: scaleX(1);
  transform-origin: bottom left;
}
```

### background绘制虚线

<div style="padding-bottom: 10px;">
  <style>
    #background-line {
      height: 1px;
      width: 200px;
      background: repeating-linear-gradient(to right, #000, #000 4px, transparent 4px, transparent 8px);
    }
  </style>
  <div id="background-line"></div>
</div>

```css
.line {
  height: 1px;
  background: repeating-linear-gradient(to right, #F6F6F6, #F6F6F6 4px, transparent 4px, transparent 8px);
}
```

### background-image网格背景

<div style="padding-bottom: 10px;">
  <style>
    #grid-bg {
      height: 101px;
      width: 101px;
      background-image: linear-gradient(0deg, #EEE 1px, transparent 0%),
                        linear-gradient(90deg, #EEE 1px, transparent 0%);
      background-size: 20px 20px;
      background-position: 0 1px;
      display: flex;
      justify-content: center;
      align-items: center;
    }
  </style>
  <div id="grid-bg">网格背景</div>
</div>

```css
/* 通过background-image: linear-gradient绘制网格背景 */
.box {
  background-image: linear-gradient(0deg, #EEE 1px, transparent 0%),
                    linear-gradient(90deg, #EEE 1px, transparent 0%);
  background-size: 20px 20px;
  background-position: 0 1px;
}
```

### steps步骤条

<div style="padding-bottom: 10px;">
  <style>
    .steps-wrap {
      display: flex;
    }
    .steps-item {
      flex: 1;
      height: 40px;
      border-top: 1px solid transparent;
      border-bottom: 1px solid transparent;
      box-sizing: border-box;
      margin: 0 2px;
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #EEE;
      color: #777;
    }
    .steps-item,
    .steps-item:before,
    .steps-item:after {
      transition: border-color .25s cubic-bezier(.71,-.46,.29,1.46),
                  color .25s cubic-bezier(.71,-.46,.29,1.46),
                  background-color .25s cubic-bezier(.71,-.46,.29,1.46);
    }
    .steps-item:first-child {
      border-left: 1px solid transparent;
    }
    .steps-item:last-child {
      border-right: 1px solid transparent;
    }
    .steps-item:last-child:before,
    .steps-item:not(:first-child):not(:last-child):before,
    .steps-item:first-child:after,
    .steps-item:not(:first-child):not(:last-child):after {
      content: "";
      display: block;
      position: absolute;
      top: 0;
      width: 40px;
      height: 40px;
      box-sizing: border-box;
      border-top: 1px solid transparent;
    }
    .steps-item:last-child:before,
    .steps-item:not(:first-child):not(:last-child):before {
      left: 0;
      z-index: 0;
      background-color: #FFF;
      border-right: 1px solid transparent;
      transform: rotateZ(45deg) scale(0.707) translateX(-21px) translateY(19px);
    }
    .steps-item:first-child:after,
    .steps-item:not(:first-child):not(:last-child):after {
      right: 0;
      z-index: 1;
      background-color: #EEE;
      border-right: 1px solid transparent;
      transform: rotateZ(45deg) scale(0.707) translateX(19px) translateY(-21px);
    }
    .steps-item.actived.actived,
    .steps-item.actived.actived:before,
    .steps-item.actived.actived:after {
      border-color: #5898F7;
      color: #5898F7
    }
    .steps-item.actived.actived,
    .steps-item.actived.actived:after {
      background-color: #E1EDFD;
    }
    .steps-item.finished.finished,
    .steps-item.finished.finished:before,
    .steps-item.finished.finished:after {
      border-color: #DDD;
      color: #999;
      background-color: #FFF;
    }
  </style>
  <div class="steps-wrap">
    <div class="steps-item finished">1</div>
    <div class="steps-item actived">2</div>
    <div class="steps-item">3</div>
    <div class="steps-item">4</div>
  </div>
  <div style="display: flex; justify-content: center; margin-top: 10px">
    <button id="steps-init-btn" style="margin-right: 20px">init steps</button>
    <button id="steps-next-btn">next step</button>
  </div>
  <script>
    document.getElementById('steps-init-btn').onclick = function () {
      const stepsDoms = document.querySelectorAll('.steps-wrap .steps-item')
      let activedStep = Array.from(stepsDoms).findIndex(({ classList }) => Array.from(classList).includes('actived'))
      document.getElementById('steps-next-btn').onclick = function () {
        if (++activedStep > 3) activedStep = 0
        stepsDoms.forEach(function (dom, index) {
          const clazz = dom.classList
          if (clazz.contains('finished')) {
            clazz.remove('finished')
          }
          if (clazz.contains('actived')) {
            clazz.remove('actived')
          }
          if (index < activedStep) {
            clazz.add('finished')
          } else if (index === activedStep) {
            clazz.add('actived')
          }
        })
      }
    }
    setTimeout(function () {
      document.getElementById('steps-init-btn').click()
    }, 300)
  </script>
</div>

```html
<div class="steps-wrap">
  <div class="steps-item finished">1</div>
  <div class="steps-item actived">2</div>
  <div class="steps-item">3</div>
  <div class="steps-item">4</div>
</div>
```

```css
.steps-wrap {
  display: flex;
}
.steps-item {
  flex: 1;
  height: 40px;
  border-top: 1px solid transparent;
  border-bottom: 1px solid transparent;
  box-sizing: border-box;
  margin: 0 2px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #EEE;
  color: #777;
}
.steps-item,
.steps-item:before,
.steps-item:after {
  transition: border-color .25s cubic-bezier(.71,-.46,.29,1.46),
              color .25s cubic-bezier(.71,-.46,.29,1.46),
              background-color .25s cubic-bezier(.71,-.46,.29,1.46);
}
.steps-item:first-child {
  border-left: 1px solid transparent;
}
.steps-item:last-child {
  border-right: 1px solid transparent;
}
.steps-item:last-child:before,
.steps-item:not(:first-child):not(:last-child):before,
.steps-item:first-child:after,
.steps-item:not(:first-child):not(:last-child):after {
  content: "";
  display: block;
  position: absolute;
  top: 0;
  width: 40px;
  height: 40px;
  box-sizing: border-box;
  border-top: 1px solid transparent;
}
.steps-item:last-child:before,
.steps-item:not(:first-child):not(:last-child):before {
  left: 0;
  z-index: 0;
  background-color: #FFF;
  border-right: 1px solid transparent;
  transform: rotateZ(45deg) scale(0.707) translateX(-21px) translateY(19px);
}
.steps-item:first-child:after,
.steps-item:not(:first-child):not(:last-child):after {
  right: 0;
  z-index: 1;
  background-color: #EEE;
  border-right: 1px solid transparent;
  transform: rotateZ(45deg) scale(0.707) translateX(19px) translateY(-21px);
}
.steps-item.actived.actived,
.steps-item.actived.actived:before,
.steps-item.actived.actived:after {
  border-color: #5898F7;
  color: #5898F7
}
.steps-item.actived.actived,
.steps-item.actived.actived:after {
  background-color: #E1EDFD;
}
.steps-item.finished.finished,
.steps-item.finished.finished:before,
.steps-item.finished.finished:after {
  border-color: #DDD;
  color: #999;
  background-color: #FFF;
}
```