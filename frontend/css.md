# Css样式

> 1、[文本域内容解析换行，解析换行符](#文本域内容解析换行解析换行符)  
> 2、[网站全局黑白色](#网站全局黑白色)  
> 3、[水平垂直居中](#水平垂直居中)  
> 4、[文本超出省略号](#文本超出省略号)  
> 5、[渐变色](#渐变色)  
> 6、[div+css绘制六边形](#divcss绘制六边形)  
> 7、[div+css实现四角边框](#divcss实现四角边框)  
> 8、[固定宽高比的自适应矩形](#固定宽高比的自适应矩形)  
> 9、[根据兄弟元素的数量来设置样式](#根据兄弟元素的数量来设置样式)  
> 10、[九宫格图片展示](#九宫格图片展示)  

#### 文本域内容解析换行，解析换行符

```css
white-space: pre-wrap;
```

#### 网站全局黑白色

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

#### 水平垂直居中

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

/* 1、line-height水平垂直居中 */
/* 
父节点固定px高度
*/
.center {
  text-align: center;
  height: 100px;
  line-height: 100px;
}

/* 2、绝对定位水平垂直居中 */
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
衍生写法，🔥推荐使用
top、left偏移父容器的50%，通过transform: translate偏移自身-50%实现居中
可不设置子节点宽高
*/
.center span {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
}


/* 3、伪类水平垂直居中 */
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

/* 4、flex水平垂直居中，🔥推荐使用 */
/* 设为 Flex 布局以后，子元素的float、clear和vertical-align属性将失效 */
.center {
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 5、grid水平垂直居中 */
/* 注意兼容性要求浏览器版本较高 */
.center {
  display: grid;
  justify-content: center;
  align-items: center;
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

#### 文本超出省略号

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
 */
.text {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}
```

#### 渐变色

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

#### div+css绘制六边形

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

#### div+css实现四角边框

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

#### 固定宽高比的自适应矩形

<style>
  .rect-item {
    overflow: hidden;
    position: relative;
    background-color: #EEE;
    width: 20%;
    min-width: 100px;
    max-width: 300px;
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
</style>

<div class="rect-item" style="margin-bottom: 14px">
  <div class="rect-wrap">
    <p style="margin: 0">正方形</p>
  </div>
</div>
<div class="rect-item react">
  <div class="rect-wrap">
    <p style="margin: 0">宽高比 2:1的矩形</p>
  </div>
</div>

> 核心：```padding-top``` ```padding-bottom``` ```margin-top``` ```margin-bottom``` 为**百分比**是相对**父元素** **宽度**  
> 使用伪元素的```padding-top```或```padding-bottom```或```margin-top```或```margin-bottom```为**百分比**撑起父元素高度实现  
> 使用```margin-top``` ```margin-bottom```时，父元素需触发[BFC](https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Block_formatting_context)，常用触发方式：```display: inline-block``` 或 ```overflow: hidden```  

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

#### 根据兄弟元素的数量来设置样式

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
  <div style="top: 17px; left: 201px">
    <pre style="border-radius: 20px; color: #b30096">ul >li:first-child:last-child</pre> 等价
  </div>
  <div style="top: 17px; left: 429px">
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

![css-selector](../images/front-end-css-1.jpg)

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

#### 九宫格图片展示

<div>
  <style>
    .album-wrap {
      width: 100%;
      max-width: 540px;
      min-width: 200px;
      box-sizing: border-box;
      padding: 5px;
      background-color: #EEE;
      font-size: 0;
      margin-bottom: 10px;
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
      if (imgs && imgs.length) {
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