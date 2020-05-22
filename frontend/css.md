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