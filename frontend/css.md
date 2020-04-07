# Css样式

> 1、文本域内容解析换行，解析换行符

```css
white-space: pre-wrap;
```

> 2、网站全局黑白色  

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