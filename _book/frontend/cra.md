# Create React App

#### 创建项目

```bash
# 默认创建项目
yarn create react-app <项目名>

# 使用typescript创建项目
yarn create react-app <项目名> --template typescript
```

#### 优化package.json

> 将原来的```dependencies```、```scripts```改为以下  

```json
{
  "scripts": {
    "dev": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "dependencies": {
    "react": "^16.13.1",
    "react-dom": "^16.13.1"
  },
  "devDependencies": {
    "@testing-library/jest-dom": "^4.2.4",
    "@testing-library/react": "^9.3.2",
    "@testing-library/user-event": "^7.1.2",
    "react-scripts": "3.4.1"
  }
}
```

#### 跨域代理

> 在```package.json```中添加  

```json
{
  "proxy": "http://192.168.0.11"
}
```

#### 环境变量配置

* 开发环境，项目根目录创建```.env.development```文件  

> 运行时不自动在浏览器中打开  
> 修改端口  

```
BROWSER=none
PORT=8009
```

* 生产环境，项目根目录创建```.env.production```文件  

> 打包后子路径，``/``为默认根目录，如需修改为```/app/xxx```，则```PUBLIC_URL=/app```  
> 不生成sourcemap  

```
PUBLIC_URL=/app
GENERATE_SOURCEMAP=false
```

#### 常用依赖

* [axios](https://www.npmjs.com/package/axios) 基于Promise的HTTP客户端，用于浏览器和node.js
* [qs](https://www.npmjs.com/package/qs) 查询字符串解析和字符串化库
* [mobx](https://www.npmjs.com/package/mobx) 状态管理
* [mobx-react](https://www.npmjs.com/package/mobx-react) mobx在react使用支持
* [prop-types](https://www.npmjs.com/package/prop-types) 检查 react props
* [react-router-dom](https://www.npmjs.com/package/react-router-dom) 路由，会自动添加```react-router```依赖

#### react-app-rewired

> 在不```eject```也不创建额外```react-scripts```的情况下修改```create-react-app```内置的```webpack```配置  

###### （1）安装依赖

> 相关依赖  

* [react-app-rewired](https://www.npmjs.com/package/react-app-rewired) 修改```create-react-app```内置的```webpack```配置
* [customize-cra](https://www.npmjs.com/package/customize-cra) 提供了一些实用程序，通过```react-app-rewired```来自定义配置```create-react-app```核心功能
* [eslint](https://www.npmjs.com/package/eslint) js校验
* [eslint-config-standard](https://www.npmjs.com/package/eslint-config-standard) eslint的standard校验规则
* [eslint-plugin-import](https://www.npmjs.com/package/eslint-plugin-import) eslint插件
* [eslint-plugin-node](https://www.npmjs.com/package/eslint-plugin-node) eslint插件
* [eslint-plugin-promise](https://www.npmjs.com/package/eslint-plugin-promise) eslint插件
* [eslint-plugin-standard](https://www.npmjs.com/package/eslint-plugin-standard) eslint插件
* [node-sass](https://www.npmjs.com/package/node-sass) scss支持，自带scss配置，默认支持scss module
* [react-hot-loader](https://www.npmjs.com/package/react-hot-loader) 热加载
* [@hot-loader/react-dom](https://www.npmjs.com/package/@hot-loader/react-dom) hot loader支持hooks，安装时需与react版本一致
* [react-app-rewire-hot-loader](https://www.npmjs.com/package/react-app-rewire-hot-loader) 使用react-app-rewired配置热加载

```bash
# 安装依赖
yarn add react-app-rewired customize-cra -D
# eslint
yarn add eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard -D
# scss
yarn add node-sass -D
# 热加载依赖
yarn add react-app-rewire-hot-loader react-hot-loader -D
```

```json
/* 当前依赖版本 */
{
  "devDependencies": {
    "@hot-loader/react-dom": "^16.13.0",
    "customize-cra": "^0.9.1",
    "eslint": "^6.8.0",
    "eslint-config-standard": "^14.1.1",
    "eslint-plugin-import": "^2.20.2",
    "eslint-plugin-node": "^11.1.0",
    "eslint-plugin-promise": "^4.2.1",
    "eslint-plugin-standard": "^4.0.1",
    "node-sass": "^4.13.1",
    "react-app-rewire-hot-loader": "^2.0.1",
    "react-app-rewired": "^2.1.5",
    "react-hot-loader": "^4.12.20"
  }
}
```

###### （2）配置

* 项目根目录创建```config-overrides.js```文件，配置为以下  

```javascript
const path = require('path')
const {
  addBabelPlugin,
  addDecoratorsLegacy,
  addWebpackAlias,
  useEslintRc
} = require('customize-cra')

const resolve = dir => path.resolve(__dirname, 'src', dir)

// hot-loader配置
const rewireHotLoader = (config, env) => {
  if (env === 'production') {
    return config
  }
  // Find a rule which contains eslint-loader
  const condition = u => typeof u === 'object' && u.loader && u.loader.includes('eslint-loader')
  const rule = config.module.rules.find(rule => rule.use && rule.use.some(condition))
  if (rule) {
    const use = rule.use.find(condition)
    if (use) {
      // Inject the option for eslint-loader
      use.options.emitWarning = true
    }
  }
  // If in development, add 'react-hot-loader/babel' to babel plugins.
  return addBabelPlugin('react-hot-loader/babel')(config)
}

// 别名
const alias = env => Object.assign(env === 'production' ? {} : {
  'react-dom': '@hot-loader/react-dom'
}, {
  '@src': resolve(''),
  '@api': resolve('api'),
  '@store': resolve('store'),
  '@routes': resolve('routes'),
  '@pages': resolve('pages'),
  '@layouts': resolve('layouts'),
  '@components': resolve('components'),
  '@styles': resolve('assets/styles'),
  '@images': resolve('assets/images')
})

/**
 * 修改默认配置
 */
module.exports = function (config, env) {
  // 开发模式使用react-hot-loader
  rewireHotLoader(config, env)

  // 使用自定义.eslintrc
  useEslintRc('./.eslintrc')(config)

  // 装饰器，主要用于mobx
  addDecoratorsLegacy()(config)

  // 别名
  addWebpackAlias(alias(env))(config)

  // 返回config
  return config
}

```

* 修改```package.json```文件中```scripts```为以下  

```json
{
  "scripts": {
    "dev": "react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test",
    "eject": "react-scripts eject"
  }
}
```

* ESLint配置  

> 删除```package.json```文件中```eslintConfig```  
> 根目录创建```.eslintrc```文件，配置eslint，当前使用```standard```校验规则  

```json
{
  "extends": [
    "standard",
    "plugin:react/recommended"
  ],
  "env": {
    "browser": true,
    "commonjs": true,
    "node": true,
    "es6": true
  },
  "parser": "babel-eslint",
  "parserOptions": {
    "ecmaVersion": 7,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true,
      "legacyDecorators": true
    }
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  },
  "plugins": [
    "react"
  ],
  "rules": {
    "arrow-parens": [
      "error",
      "as-needed"
    ],
    "object-curly-spacing": [
      1,
      "always"
    ]
  }
}
```

##### 部分组件使用

* ```scss```、```scss module```使用

> 创建```style.scss```文件，直接在需要的页面或者组件中引入即可  

```javascript
import './style.scss'
```

> 创建```style.module.scss```文件，直接在需要的组件中引入，然后```className```引用里面的样式即可  

```javascript
import styles from './style.module.scss'

<div className={styles.box}></div>
```

> 输出样式  

```css
.<filename>_<class name>__<hash code> {
}
```

* ```react-hot-loader```使用

> 相关配置参照上方的配置说明，配置主要针对开发模式  
> （1）```react-hot-loader/babel```  
> （2）webpack配置别名```'react-dom': '@hot-loader/react-dom'```支持hooks  

```javascript
import { hot } from 'react-hot-loader/root'

// 处理入口文件引入的 App 组件，开发模式需要使用 react-hot-loader 处理
const AppComponent = process.env.NODE_ENV === 'development' ? hot(App) : App

ReactDOM.render(
  <React.StrictMode>
    <AppComponent />
  </React.StrictMode>,
  document.getElementById('root')
)
```
