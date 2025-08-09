# 移动端vw适配方案

### 基于vite+vue3

```bash
# 将 px 单位转换为视口单位的 (vw, vh, vmin, vmax) 的 PostCSS 插件
yarn add postcss-px-to-viewport-8-plugin -D
```

> `postcss.config.cjs`  

```javascript
module.exports = {
  autoprefixer: {},
  plugins: {
    'postcss-px-to-viewport-8-plugin': {
      viewportWidth: 375, // number | ((filePath: string) => number|undefined)，设计稿的视口宽度,如传入函数，函数的参数为当前处理的文件路径,函数返回 undefind 跳过转换
      unitPrecision: 5, // 单位转换后保留的精度
      propList: ['*'], // 能转化为vw的属性列表
      // viewportUnit: 'vw', // 希望使用的视口单位
      // fontViewportUnit: 'vw', // 字体使用的视口单位
      // selectorBlackList: [], // 需要忽略的CSS选择器，不会转为视口单位，使用原有的px等单位。
      // minPixelValue: 1, // 设置最小的转换数值，如果为1的话，只有大于1的值会被转换
      // mediaQuery: false, // 媒体查询里的单位是否需要转换单位
      // replace: true, //  是否直接更换属性值，而不添加备用属性
      // exclude: undefined, // 忽略某些文件夹下的文件或特定文件，例如 node_modules 下的文件，如果值是一个正则表达式，那么匹配这个正则的文件会被忽略，如果传入的值是一个数组，那么数组里的值必须为正则例如 'node_modules' 下的文件
      // include: [], // 需要转换的文件，例如只转换 'src/mobile' 下的文件 (include: /\/src\/mobile\//)，如果值是一个正则表达式，将包含匹配的文件，否则将排除该文件， 如果传入的值是一个数组，那么数组里的值必须为正则
      // landscape: false, // 是否添加根据 landscapeWidth 生成的媒体查询条件 @media (orientation: landscape)
      // landscapeUnit: 'vw', // 横屏时使用的单位
      // landscapeWidth: 568, // 横屏时使用的视口宽度
    },
  },
}
```

> 关于使用的一些补充说明  

```css
propList (Array) 能转化为 vw 的属性列表
 · 传入特定的 CSS 属性；
 · 可以传入通配符""去匹配所有属性，例如：['']；
 · 在属性的前或后添加"*",可以匹配特定的属性. (例如['*position*'] 会匹配 background-position-y)
 · 在特定属性前加 "!"，将不转换该属性的单位 . 例如: ['*', '!letter-spacing']，将不转换 letter-spacing
 · "!" 和 ""可以组合使用， 例如: ['', '!font*']，将不转换 font-size 以及 font-weight 等属性

selectorBlackList (Array) 需要忽略的 CSS 选择器，不会转为视口单位，使用原有的 px 等单位
 · 如果传入的值为字符串的话，只要选择器中含有传入值就会被匹配
   - 例如 selectorBlackList 为 ['body'] 的话， 那么 .body-class 就会被忽略
 · 如果传入的值为正则表达式的话，那么就会依据 CSS 选择器是否匹配该正则
   - 例如 selectorBlackList 为 [/^body$/] , 那么 body 会被忽略，而 .body 不会

可以使用特殊的注释来忽略单行的转换
  /* px-to-viewport-ignore-next */ — 在单独的行上，防止在下一行上进行转换。
  /* px-to-viewport-ignore */ — 在右边的属性之后，防止在同一行上进行转换。
```

---

#### 以下为老版本解决方案

---

> 如果使用 [create-react-app创建项目](./cra.md) 可参照参照该文最后章节  

> 该文测试所使用postcss版本为**7.0.x**  
> 注意PostCSS插件等依赖与postcss的版本匹配，否则会报错  
> 使用时也可根据报错信息调整各依赖版本  

### 1、安装PostCSS插件

> 相关依赖  

* [postcss-import](https://www.npmjs.com/package/postcss-import) 解决```@import```引入路径问题
* [postcss-url](https://www.npmjs.com/package/postcss-url) 用来处理文件，比如图片文件、字体文件等引用路径的处理
* [autoprefixer](https://www.npmjs.com/package/autoprefixer) 自动处理浏览器前缀，一般脚手架会自带

```bash
# 安装依赖
yarn add postcss-import postcss-url autoprefixer -D
```

```json
/* 当前依赖版本 */
{
  "devDependencies": {
    "autoprefixer": "^9.7.6",
    "postcss-import": "^12.0.1",
    "postcss-url": "^8.0.0"
  }
}
```

> 配置PostCSS，项目根目录```.postcssrc.js```文件  

```javascript
module.exports = {
  plugins: {
    autoprefixer: {},
    'postcss-import': {},
    'postcss-url': {}
  }
}
```

### 2、其他插件

> 相关依赖  

* [postcss-aspect-ratio-mini](https://www.npmjs.com/package/postcss-aspect-ratio-mini) 处理元素容器宽高比
* [postcss-px-to-viewport](https://www.npmjs.com/package/postcss-px-to-viewport) 把```px```单位转换为```vw```、```vh```、```vmin```或者```vmax```这样的视窗单位，也是```vw```适配方案的核心插件之一
* [postcss-write-svg](https://www.npmjs.com/package/postcss-write-svg) 处理移动端```1px```的解决方案
* [postcss-preset-env](https://www.npmjs.com/package/postcss-preset-env) cssnext，使用CSS未来的特性
* [cssnano](https://www.npmjs.com/package/cssnano) 压缩和清理CSS代码
* [cssnano-preset-advanced](https://www.npmjs.com/package/cssnano-preset-advanced) cssnano依赖，```preset: 'advanced'```
* [postcss-viewport-units](https://www.npmjs.com/package/postcss-viewport-units) 给CSS的属性添加```content```的属性，配合```viewport-units-buggyfill```库给```vw```、```vh```、```vmin```和```vmax```做适配的操作

```bash
# 安装依赖
yarn add postcss-aspect-ratio-mini postcss-px-to-viewport postcss-write-svg postcss-preset-env cssnano cssnano-preset-advanced postcss-viewport-units -D
```

```json
/* 当前依赖版本 */
{
  "devDependencies": {
    "cssnano": "^4.1.10",
    "cssnano-preset-advanced": "^4.0.7",
    "postcss-aspect-ratio-mini": "^1.0.1",
    "postcss-preset-env": "^6.7.0",
    "postcss-px-to-viewport": "^1.1.1",
    "postcss-viewport-units": "^0.1.6",
    "postcss-write-svg": "^3.0.1"
  }
}
```

> 增加PostCSS配置，项目根目录```.postcssrc.js```文件，**以下为完整配置**  

```javascript
module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-url': {},
    'postcss-aspect-ratio-mini': {}, 
    'postcss-write-svg': {
      utf8: false // 使用base64编码
    },
    'postcss-preset-env': {
      stage: 4 // 稳定阶段
    },
    'postcss-px-to-viewport': {
      viewportWidth: 750,   // (Number) 视窗的宽度，对应的是我们设计稿的宽度，一般是750
      viewportHeight: 1334, // (Number) 视窗的高度，根据750设备的宽度来指定，一般指定1334，也可以不配置
      unitPrecision: 3,     // (Number) 指定`px`转换为视窗单位值的小数位数（很多时候无法整除）
      viewportUnit: 'vw',   // (String) 指定需要转换成的视窗单位，建议使用vw
      selectorBlackList: ['.ignore', '.hairlines', '.markdown'], // (Array) 指定不转换为视窗单位的类，可以自定义，可以无限添加，建议定义一至两个通用的类名，注意：第三方UI库也要在此添加
      minPixelValue: 1,     // (Number) 小于或等于`1px`不转换为视窗单位，你也可以设置为你想要的值
      mediaQuery: false     // (Boolean) 允许在媒体查询中转换`px`
    }, 
    'postcss-viewport-units': {
      filterRule: rule => rule.nodes.findIndex(i => i.prop === 'content') === -1 // 过滤伪类content使用
    },
    'cssnano': {
      'cssnano-preset-advanced': {
        zindex: false, // 防止z-index的值重置为1
        autoprefixer: false // 有重复调用，关闭
      }
    }
  }
}
```

> 关于兼容第三方UI库

```javascript
const path = require('path')

module.exports = ({ file }) => {
  // 解决UI框架与设计稿尺寸不一致的问题，如：vant有赞移动端web UI框架
  //const designWidth = file.dirname.includes(path.join('node_modules', 'vant')) ? 375 : 750
  // 默认设计稿宽度750
  const designWidth = 750
  return {
    plugins: {

      // ··· ··· 其他配置

      'postcss-px-to-viewport': {
        viewportWidth: designWidth, // (Number) 视窗的宽度，对应的是我们设计稿的宽度，一般是750
        viewportHeight: 1334,       // (Number) 视窗的高度，根据750设备的宽度来指定，一般指定1334，也可以不配置
        unitPrecision: 3,           // (Number) 指定`px`转换为视窗单位值的小数位数（很多时候无法整除）
        viewportUnit: 'vw',         // (String) 指定需要转换成的视窗单位，建议使用vw
        selectorBlackList: ['.ignore', '.hairlines', '.markdown'], // (Array) 指定不转换为视窗单位的类，可以自定义，可以无限添加，建议定义一至两个通用的类名，注意：第三方UI库也要在此添加
        minPixelValue: 1,           // (Number) 小于或等于`1px`不转换为视窗单位，你也可以设置为你想要的值
        mediaQuery: false           // (Boolean) 允许在媒体查询中转换`px`
      },
      
      // ··· ··· 其他配置

    }
  }
}
```

> 注意：由于```cssnext```和```cssnano```都具有```autoprefixer```，事实上只需要一个，所以把默认的```autoprefixer```删除掉，然后把```cssnano```中的```autoprefixer```设置为```false```  

### 3、index.html配置

> 修改```meta viewport```  

```html
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no" />
```

> 增加viewport-units-buggyfill、fastclick配置  
> 在```index.html```中加入  
> 注意：**fastclick可能引起一些点击问题**，参照 [FastClick 填坑及源码解析](https://www.cnblogs.com/vajoy/p/5522114.html)  

```html
<script src="//g.alicdn.com/fdilab/lib3rd/viewport-units-buggyfill/0.6.2/??viewport-units-buggyfill.hacks.min.js,viewport-units-buggyfill.min.js"></script>
<!-- fastclick -->
<script src="https://as.alipayobjects.com/g/component/fastclick/1.0.6/fastclick.js"></script>
<script>
  if ('addEventListener' in document) {
    document.addEventListener('DOMContentLoaded', function () {
      FastClick.attach(document.body)
    }, false)
  }
  if (!window.Promise) {
    document.writeln('<script src="https://as.alipayobjects.com/g/component/es6-promise/3.2.2/es6-promise.min.js"' + '>' + '<' + '/' + 'script>')
  }
  window.onload = function () {
    window.viewportUnitsBuggyfill.init({
      hacks: window.viewportUnitsBuggyfillHacks
    })
  }
</script>
```

### 4、部分功能使用介绍

###### （1）postcss-aspect-ratio-mini 宽高比容器  

> 使用  

```html
<div aspectratio w-188-246>
  <div aspectratio-content></div>
</div>
```

```css
[aspectratio] {
  position: relative;
}
[aspectratio]:before {
  content: '';
  display: block;
  width: 1px;
  margin-left: -1px;
  height: 0;
}
[aspectratio-content] {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
}
[w-188-246] {
  width: 188px;
  background-color: red;
}
[w-188-246] {
  aspect-ratio: '188:246';
}
```

> 编译后代码css  

```css
[aspectratio] {
  position: relative;
}
[w-188-246] {
  width: 188px;
  background-color: red;
}
[w-188-246]:before {
  padding-top: 130.85106382978725%;
}
[aspectratio]:before {
  content: "";
  display: block;
  width: 1px;
  margin-left: -1px;
  height: 0;
}
[aspectratio-content] {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
}
```

###### （2）postcss-write-svg 在retina屏绘制1px细线  

> 使用  

```html
<div class="hairlines"></div>
```

```css
/* 注意：stylus 里面这样搞无效，less、scss可能会有warning，可以使用 <style lang="postcss" scoped></style> */
@svg 1px-border {
  width: 4px;
  height: 4px;
  @rect {
    fill: transparent;
    width: 100%;
    height: 100%;
    stroke-width: 25%;
    stroke: var(--color, black);
  }
}
.hairlines {
  border: 0;
  border-top: 1px solid;
  border-image: svg(1px-border param(--color red)) 1 stretch;
}
```

> 编译后代码css  

```css
.hairlines {
  margin-bottom: 20px;
  border: 0;
  border-top: 1px solid;
  -o-border-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zd…IgaGVpZ2h0PSIxMDAlIiBzdHJva2Utd2lkdGg9IjI1JSIgc3Ryb2tlPSJyZWQiLz48L3N2Zz4=) 1 stretch;
  border-image: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zd…IgaGVpZ2h0PSIxMDAlIiBzdHJva2Utd2lkdGg9IjI1JSIgc3Ryb2tlPSJyZWQiLz48L3N2Zz4=) 1 stretch;
}
```

> retina屏下放大效果对比展示，蓝色线```class="line"```为未使用```postcss-write-svg```  

```css
.line {
  border-top: 1px solid #00b1ff;
}
```

![对比效果](../assets/vw-1px-line.jpg)

## 在 create-react-app 中使用

> ```create-react-app```使用 [可参照](./cra.md)  

### 1、依赖

> 参数文章开头 1、2 安装相关依赖  

### 2、配置

> 在```config-overrides.js```文件中添加以下配置  

```javascript
const {
  // ··· ··· 其他方法引入
  addPostcssPlugins
  // ··· ··· 其他方法引入
} = require('customize-cra')

// postcss vw plugins
const postCssPlugins = [
  require('postcss-import'),
  require('postcss-url'),
  require('postcss-aspect-ratio-mini'),
  require('postcss-write-svg')({
    utf8: false
  }),
  require('postcss-preset-env')({
    stage: 4 // 稳定阶段
  }),
  require('postcss-px-to-viewport')({
    viewportWidth: 750,   // (Number) 视窗的宽度，对应的是我们设计稿的宽度，一般是750
    viewportHeight: 1334, // (Number) 视窗的高度，根据750设备的宽度来指定，一般指定1334，也可以不配置
    unitPrecision: 3,     // (Number) 指定`px`转换为视窗单位值的小数位数（很多时候无法整除）
    viewportUnit: 'vw',   // (String) 指定需要转换成的视窗单位，建议使用vw
    selectorBlackList: ['.ignore', '.hairlines', '.markdown'], // (Array) 指定不转换为视窗单位的类，可以自定义，可以无限添加，建议定义一至两个通用的类名，注意：第三方UI库也要在此添加
    minPixelValue: 1,     // (Number) 小于或等于`1px`不转换为视窗单位，你也可以设置为你想要的值
    mediaQuery: false     // (Boolean) 允许在媒体查询中转换`px`
  }),
  require('postcss-viewport-units')({
    filterRule: rule => rule.nodes.findIndex(i => i.prop === 'content') === -1 // 过滤伪类content使用
  }),
  require('cssnano')({
    'cssnano-preset-advanced': {
      zindex: false, // 防止z-index的值重置为1
      autoprefixer: false // 有重复调用，关闭
    }
  })
]

/**
 * 修改默认配置
 */
module.exports = function (config, env) {
  
  // ··· ··· 其他配置

  // 添加postcss插件
  addPostcssPlugins(postCssPlugins)(config)

  // ··· ··· 其他配置

  // 返回config
  return config
}
```

### 3、注意

> react中不能使用空的自定义属性（如：```<div aspectratio></div>```），如需自定义属性样式，正确的使用方法如下  

```html
<div aspectratio="" w-188-246="">
  <div aspectratio-content=""></div>
</div>
```
