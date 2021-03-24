# ESLint

> ESLint是一个语法规则和代码风格的检查工具。  
> 项目中使用ESLint可以避免一些低级错误、格式错误，统一项目代码风格，更有利于团队协作等。  
> 开发工具中需添加ESLint扩展，如：VSCode中ESLint插件。  
> 个人更倾向于使用standard规范，以standard规范为例。  

#### create-react-app中使用ESLint

> create-react-app中使用ESLint，[可参照](./cra.md)  

#### 在Vuejs脚手架vue-cli@2.x.x 3.x.x 4.x.x中使用ESLint

```javascript
/**
 * 只需在构建项目时根据提示操作即可
 */

// 1、构建项目时，Use ESLint to lint your code? Y

// 2、Pick an ESLint preset，选择上下箭头选择Standard (https://github.com/standard/standard)
```

#### 在Nuxtjs脚手架create-nuxt-app@2.x.x中使用ESLint

```javascript
// 1、构建项目时，Choose features to install，上下箭头+空格勾选Linter / Formatter这一项

// 2、去除不必要的依赖
yarn remove @nuxtjs/eslint-config -D

// 3、安装依赖
yarn add eslint eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise eslint-plugin-standard -D

// 4、修改.eslintrc.js，添加、注释以下内容
module.exports = {
  ···
  extends: [
    // '@nuxtjs',
    ···
    'standard'
  ],
  ···
  rules: {
    ···
    // allow async-await
    'generator-star-spacing': 'off',
    // allow debugger during development
    'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off'
  }
}
```

#### Taro@1.3.0中使用报错

> taro+typescript+mobx  
> **新版本会有解决**  

```bash
# 报错信息

54:22 error Parsing error: Unexpected token, expected ";"
52 | }
53 |
54 | export default Index as ComponentType
   |                      ^
```

> 解决方法  

```bash
# 安装依赖
yarn add @typescript-eslint/eslint-plugin -D
```

```json
// .eslintrc中添加overrides
{
  ···
  "overrides": [
    {
      "files": ["**/*.ts?(x)"],
      "parser": "@typescript-eslint/parser",
      "parserOptions": {
        "ecmaVersion": 2018,
        "sourceType": "module",
        "ecmaFeatures": {
          "jsx": true
        },
        // typescript-eslint specific options
        "warnOnUnsupportedTypeScriptVersion": true
      },
      "plugins": ["@typescript-eslint"],
      // If adding a typescript-eslint version of an existing ESLint rule,
      // make sure to disable the ESLint rule here.
      "rules": {
        // TypeScript"s `noFallthroughCasesInSwitch` option is more robust (#6906)
        "default-case": "off",
        // "tsc" already handles this (https://github.com/typescript-eslint/typescript-eslint/issues/291)
        "no-dupe-class-members": "off",
        // "tsc" already handles this (https://github.com/typescript-eslint/typescript-eslint/issues/477)
        "no-undef": "off",

        // Add TypeScript specific rules (and turn off ESLint equivalents)
        "@typescript-eslint/no-angle-bracket-type-assertion": "warn",
        "no-array-constructor": "off",
        "@typescript-eslint/no-array-constructor": "warn",
        "@typescript-eslint/no-namespace": "error",
        "no-use-before-define": "off",
        "@typescript-eslint/no-use-before-define": [
          "warn",
          {
            "functions": false,
            "classes": false,
            "variables": false,
            "typedefs": false
          }
        ],
        "no-unused-vars": "off",
        "@typescript-eslint/no-unused-vars": [
          "warn",
          {
            "args": "none",
            "ignoreRestSiblings": true
          }
        ],
        "no-useless-constructor": "off",
        "@typescript-eslint/no-useless-constructor": "warn"
      }
    }
  ]
}
```