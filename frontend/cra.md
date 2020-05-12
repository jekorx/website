# Create React App

#### 创建项目

> [TypeScript模版增加配置](#typescript模版增加配置)请查看  

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

```bash
# 运行时不自动在浏览器中打开
BROWSER=none
# 修改端口
PORT=8009
```

* 生产环境，项目根目录创建```.env.production```文件  

```bash
# 打包后子路径，/ 为默认根目录，如需修改为 /app/xxx，则 PUBLIC_URL=/app
PUBLIC_URL=/app
# 打包不生成sourcemap 
GENERATE_SOURCEMAP=false
```

#### 常用依赖

* [axios](https://www.npmjs.com/package/axios) 基于Promise的HTTP客户端，用于浏览器和node.js
* [qs](https://www.npmjs.com/package/qs) 查询字符串解析和字符串化库
* [mobx](https://www.npmjs.com/package/mobx) 状态管理
* [mobx-react](https://www.npmjs.com/package/mobx-react) mobx在react使用支持
* [prop-types](https://www.npmjs.com/package/prop-types) 检查 react props，TypeScript模版不需要
* [react-router-dom](https://www.npmjs.com/package/react-router-dom) 路由，会自动添加```react-router```依赖
* [@types/react-router-dom](https://www.npmjs.com/package/@types/react-router-dom) 路由类型定义（TypeScript模版），会自动添加```@types/react-router```依赖

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
yarn add react-app-rewire-hot-loader react-hot-loader @hot-loader/react-dom -D
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
> 注意：需要与[相关开发工具设置](../ide/vscode.md)配合  

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

#### TypeScript模版增加配置

* [eslint-plugin-react](https://www.npmjs.com/package/eslint-plugin-react) eslint react组件
* [eslint](https://www.npmjs.com/package/eslint) 此处eslint有版本要求
* [@typescript-eslint/parser](https://www.npmjs.com/package/@typescript-eslint/parser) typescript eslint解析器
* [@typescript-eslint/eslint-plugin](https://www.npmjs.com/package/@typescript-eslint/eslint-plugin) typescript eslint插件

```bash
# 安装依赖
yarn add @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-react -D
# 此处eslint版本要求^6.6.0，版本不符会提示安装eslint@^6.6.0，后续版本可根据相关提示安装对应版本的eslint
yarn add eslint@^6.6.0 -D
```

```json
/* 当前依赖版本 */
{
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^2.31.0",
    "@typescript-eslint/parser": "^2.31.0",
    "eslint-plugin-react": "^7.19.0"
  }
}
```

> 增加```.eslintignore```，添加以下内容  

```
config-overrides.js
node_modules
```

> ```.eslintrc```修改为以下  
> @typescript-eslint/explicit-function-return-type：强制函数返回类型有声明，关闭 
> @typescript-eslint/no-non-null-assertion：非空断言，关闭  

```json
{
  "extends": [
    "standard",
    "plugin:react/recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "env": {
    "browser": true,
    "commonjs": true,
    "node": true,
    "es6": true
  },
  "parser": "@typescript-eslint/parser",
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
    "@typescript-eslint",
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
    ],
    "@typescript-eslint/explicit-function-return-type": [
      "off"
    ],
    "@typescript-eslint/no-non-null-assertion": [
      "off"
    ]
  }
}
```

> 根目录创建```paths.json```增加别名（paths）  

```json
{
  "compilerOptions": {
    "baseUrl": "./",
    "paths": {
      "@/*": [
        "src/*"
      ]
    }
  }
}
```

> 继承```paths.json```，识别定义别名  
> ```paths```直接写在```tsconfig.json```，项目启动会被重置  
> 装饰器（experimentalDecorators）支持  
> ```tsconfig.json```修改为以下  

```json
{
  "extends": "./paths.json",
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react"
  },
  "include": [
    "src"
  ]
}
```

###### 部分代码示例

```tsx
// test组件

import React, { Component } from 'react'
import { inject, observer } from 'mobx-react'

interface Props {
  // mobx给count赋值，引用组件不用给count传值
  count?: {
    num: number;
    add: Function;
  };
}

@inject('count')
@observer
// 如果包含state，则需定义interface State，Component<Props, State，Component>
export default class Test extends Component<Props> {
  render () {
    // 使用非空断言（mobx一定会给count赋值）
    const { num, add } = this.props.count!
    return (
      <div>
        <p>num -- {num}</p>
        <button onClick={() => add()}>add</button>
      </div>
    )
  }
}

// ----------------------------------------------------------

// App页面，只用test组件

import React, { Component } from 'react'
import Test from '@/test'

interface StateType {
  name: string;
}

export default class App extends Component<{}, StateType> {
  // 如果Props为{}，可不定义interface，直接Component<{}, State>，此时constructor (props: {}) {}
  constructor (props: {}) {
    super(props)
    // 定义state
    this.state = {
      name: 'name'
    }
  }

  render () {
    return (
      <div>
        {/* test组件可不传值 */}
        <Test />
      </div>
    )
  }
}
```

#### 相关问题

```json
// eslint warning
// Warning: React version not specified in eslint-plugin-react settings. 

// 在.eslintrc中添加以下内容，指定react版本即可
"settings": {
  "react": {
    "version": "detect"
  }
}
```

```bash
# 控制台警告
React-Hot-Loader: react-🔥-dom patch is not detected. React 16.6+ features may not work.

# 同时配置了 react-hot-loader、@hot-loader/react-dom 不会出现该警告
```
