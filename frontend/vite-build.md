# Vite打包非web服务器运行

> vite打包后直接打开index.html运行  
> 应用场景，如：H5打包到app中  

### 依赖

```bash
# @vitejs/plugin-legacy、jsdom、terser
# vite 建议使用6.x，node.js 18.x，否则安装依赖会有警告，不过不影响打包

pnpm i @vitejs/plugin-legacy jsdom terser -D
```

### vite.config.ts

```javascript
import legacy from '@vitejs/plugin-legacy'

export default defineConfig({
  base: './', // 本地运行需相对路径
  plugins: [
    // ··· ···

    legacy({
      targets:['defaults', 'not IE 11'],
    }),

    // ··· ···
  ]
})
```

### 脚本

> 项目根目录创建 ```post-build.mjs```修改index.html  

```javascript
import fs from 'fs'
import { JSDOM } from 'jsdom'

const dom = new JSDOM(fs.readFileSync('./dist/index.html'))

// 删除包含type="module"的标签
let tags = dom.window.document.querySelectorAll('*[type="module"]')
for (let i = 0; i < tags.length; i++) {
  const tag = tags[i]
  tag.parentElement.removeChild(tag)
}

// 需要把 script link 标签里面的 nomodule，crossorigin 属性删掉
tags = dom.window.document.querySelectorAll('script[nomodule]')
for (let i = 0; i < tags.length; i++) {
  tags[i].removeAttribute('nomodule')
}

tags = dom.window.document.querySelectorAll('script[crossorigin]')
for (let i = 0; i < tags.length; i++) {
  tags[i].removeAttribute('crossorigin')
}

tags = dom.window.document.querySelectorAll('link[crossorigin]')
for (let i = 0; i < tags.length; i++) {
  tags[i].removeAttribute('crossorigin')
}

// data-src换成src
tags = dom.window.document.querySelectorAll('script[data-src]')
for (let i = 0; i < tags.length; i++) {
  const tag = tags[i]
  const src = tag.getAttribute('data-src')
  tag.removeAttribute('data-src')
  tag.setAttribute('src', src)
}

const html = '<!DOCTYPE html>\r\n' + dom.window.document.documentElement.outerHTML
fs.writeFileSync('./dist/index.html', html)

console.log('成功修改 dist/index.html')
```

### 修改package.json

```json
{
  "scripts": {
    "build:local": "vue-tsc -b && vite build && node ./post-build.mjs"
  },
}
```

### 访问

```
D:/dist/index.html#/route?q=1

注意：
1、路由建议使用hash模式
2、访问路径 index.html后面没有/，路由为#/route
```
