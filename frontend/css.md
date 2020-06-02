# Css样式

* 1、文本域内容解析换行，解析换行符

```css
white-space: pre-wrap;
```

* 2、网站全局黑白色

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

* 3、水平垂直居中

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
*/
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
  height: 21px;
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

* 4、文本超出省略号

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

* 5、渐变色

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
  background-image: linear-gradient(to right, red, yellow, green);
}
.box {
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
  background-image: radial-gradient(red, green);
}
.box {
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
  background-image: conic-gradient(from 45deg at 20% 40%, red, orange, yellow, green, blue, purple, red);
}
.box {
  background-image: repeating-conic-gradient(#fff 0 9deg, #000 9deg 18deg);
}
```