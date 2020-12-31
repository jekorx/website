# Css样式

* **1、文本域内容解析换行，解析换行符**

```css
white-space: pre-wrap;
```

* **2、网站全局黑白色**

```css
/* 须在html上设置 */
html {
  -webkit-filter: grayscale(100%);
  -moz-filter: grayscale(100%);
  -ms-filter: grayscale(100%);
  -o-filter: grayscale(100%);
  filter: grayscale(100%);
  filter: progid:DXImageTransform.Microsoft.BasicImage(grayscale=1);
}
```

* **3、水平垂直居中**

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

* **4、文本超出省略号**

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

* **5、渐变色**

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

* **6、div + css 绘制六边形**

<div style="display: flex; width: 400px; align-items: center; justify-content: space-around; padding: 20px">
  <div class="corner"></div>
  <div class="hexagon"></div>
</div>
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

* **7、div + css 实现四角边框**

> **方式一**：通过```:before``` ```:after```伪类实现（也可使用4个div实现）  
> 原包裹div实现顶部两个角，增加一个div实现底部两个角，确保新增加div与原包裹div重合  
> **优点**：可以根据图片大小自适应，易于理解；**缺点**：实现复杂，dom多、代码多  

<div class="qrcode-box">
  <div class="qrcode-box-background"></div>
  <img style="filter:blur(5px)" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAACWAQAAAAAUekxPAAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAIKSURBVHjatZZNkqMwDIXl8sJLjsBFUuZaWdDQ3AyqL+IjeHYsaDRPsslkgJlKA3FlET7/SJbkZxNv2kRXs5GITHDMjiPP+KD6HKuYOx4NjxasYI5gLfOgzFzMbGwX1pAb2PUFHLBzQWaXfbw4LrMge7I8+jUzmbUvsvrfTO2auPXlIpZiRUhWQf6v+B1jKb9E98zCUgfYlRvi6J9r4zQLC0v1CovjTX34U88H2VwiPljdwoblqYqZiUXxxQirzzEObkZPQVW0ffEe9il1hTSRJ90YPbPbf1izwz6Ie3Ldei4HrI7IoQ7wQ2nxDvs+wSRHMJrOB2qX2pS311m3Zl+/+EuZtnYmsI51OvphV1h9js2lQ7igf1MB/Wv7dzBmBAoCi5M9ebHbPlgAG3325RjjtA9JO84bdAP5yPV8iqFNVEKfJ/mTbFClclJFlo1t2dFxAeyuuuFV/2ZCFHmISUua40yEzpcSrkm1bpYzs2Hti2x/7ogoUTk1RL6EUTggd1QJCUE3hsoFtM+aHVbvMpW/IJniqFfcFSwmdgebFs1mpznC3mz/Dib3EQpXnhyLL6eY3slOZULseZRWZvxg0Lqfsvhgeb34PC4zuUPFF8NW32FnGU5BgbeK5WiHx3tDmLmGpbcAZPsmgWLR7BVrf8q6NdOcI0ROTQPXlzCoaonQfEp+t29gPsG+99hvI1wxCxAb1yIAAAAASUVORK5CYII=">
</div>
<style>
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
</style>

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

<div class="qrcode-box1">
  <img style="filter:blur(5px); width: 100%; height: 100%" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJYAAACWAQAAAAAUekxPAAAAAmJLR0QAAKqNIzIAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAIKSURBVHjatZZNkqMwDIXl8sJLjsBFUuZaWdDQ3AyqL+IjeHYsaDRPsslkgJlKA3FlET7/SJbkZxNv2kRXs5GITHDMjiPP+KD6HKuYOx4NjxasYI5gLfOgzFzMbGwX1pAb2PUFHLBzQWaXfbw4LrMge7I8+jUzmbUvsvrfTO2auPXlIpZiRUhWQf6v+B1jKb9E98zCUgfYlRvi6J9r4zQLC0v1CovjTX34U88H2VwiPljdwoblqYqZiUXxxQirzzEObkZPQVW0ffEe9il1hTSRJ90YPbPbf1izwz6Ie3Ldei4HrI7IoQ7wQ2nxDvs+wSRHMJrOB2qX2pS311m3Zl+/+EuZtnYmsI51OvphV1h9js2lQ7igf1MB/Wv7dzBmBAoCi5M9ebHbPlgAG3325RjjtA9JO84bdAP5yPV8iqFNVEKfJ/mTbFClclJFlo1t2dFxAeyuuuFV/2ZCFHmISUua40yEzpcSrkm1bpYzs2Hti2x/7ogoUTk1RL6EUTggd1QJCUE3hsoFtM+aHVbvMpW/IJniqFfcFSwmdgebFs1mpznC3mz/Dib3EQpXnhyLL6eY3slOZULseZRWZvxg0Lqfsvhgeb34PC4zuUPFF8NW32FnGU5BgbeK5WiHx3tDmLmGpbcAZPsmgWLR7BVrf8q6NdOcI0ROTQPXlzCoaonQfEp+t29gPsG+99hvI1wxCxAb1yIAAAAASUVORK5CYII=">
</div>
<style>
.qrcode-box1 {
    display: inline-block;
    border: 1px solid #3295D1;
    box-sizing: border-box;
    padding: 10px;
    width: 160px;
    height: 160px;
    /* 
      * 边角宽3px，高30px，计算方式
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
</style>

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