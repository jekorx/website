# Vue Cli

> 根据提示完成初始化项目后可以使用```vue ui```命令使用GUI界面管理项目  
> 默认配置可以满足绝大多数项目，非常方便  
> 如需进一步了解可参考[vue-cli官方文档](https://cli.vuejs.org/zh/guide/)  

### 配置

> 在项目根目录下添加```vue.config.js ```文件，内容如下  
> [webpack-chain配置](https://github.com/Yatoo2018/webpack-chain/tree/zh-cmn-Hans)文档说明

```javascript
const path = require('path')

const resolve = dir => path.join(__dirname, dir)

// 项目部署基础
// 默认情况下，我们假设你的应用将被部署在域的根目录下,
// 例如：https://www.my-app.com/
// 默认：'/'
// 如果您的应用程序部署在子路径中，则需要在这指定子路径
// 例如：https://www.foobar.com/my-app/
// 需要将它改为'/my-app/'
const BASE_URL = process.env.NODE_ENV === 'production'
  ? '/'
  : '/'

module.exports = {
  // Project deployment base
  // By default we assume your app will be deployed at the root of a domain,
  // e.g. https://www.my-app.com/
  // If your app is deployed at a sub-path, you will need to specify that
  // sub-path here. For example, if your app is deployed at
  // https://www.foobar.com/my-app/
  // then change this to '/my-app/'
  publicPath: BASE_URL,
  // tweak internal webpack configuration.
  // see https://github.com/vuejs/vue-cli/blob/dev/docs/webpack.md
  // 如果你不需要使用eslint，把lintOnSave设为false即可
  lintOnSave: true,
  // 修改webpack配置
  chainWebpack: config => {
    // 移除 prefetch 插件
    config.plugins.delete('prefetch')
    // 别名
    config.resolve.alias
      .set('@', resolve('src')) // key, value自行定义，比如.set('@@', resolve('src/components'))
      .set('_c', resolve('src/components'))
  },
  // 设为false打包时不生成.map文件
  productionSourceMap: false,
  // 这里写你调用接口的基础路径，来解决跨域，如果设置了代理，那你本地开发环境的axios的baseUrl要写为 '' ，即空字符串
  devServer: {
    // 进度显示，关闭后可增加启动速度
    progress: false,
    // 启动后打开浏览器
    open: false,
    // 端口
    port: 8009,
    // 跨域
    proxy: {
      '/api/': {
        target: 'http://127.0.0.1:8008/',
        changeOrigin: true
      }
    }
  }
}
```

### Eslint

> 在项目根目录下修改```.eslintrc.js```文件，内容如下  

```javascript
module.exports = {
  root: true,
  parserOptions: {
    parser: 'babel-eslint'
  },
  env: {
    node: true
  },
  extends: [
    'plugin:vue/essential',
    '@vue/standard'
  ],
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    // 允许obj['key']的使用
    'dot-notation': 'off',
    // 允许object key一个字符事使用引号
    'quote-props': 'off'
  }
}
```
