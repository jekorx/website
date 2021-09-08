# ESLint

> ESLint是一个语法规则和代码风格的检查工具。  
> 项目中使用ESLint可以避免一些低级错误、格式错误，统一项目代码风格，更有利于团队协作等。  
> 开发工具中需添加ESLint扩展，如：VSCode中ESLint插件。  
> 个人更倾向于使用standard规范，以standard规范为例。  

#### vite中使用ESLint

> vite版本为2.x，编辑器需要安装ESLint插件  
> 更多配置可参照 [[掘金] 从 0 开始手把手带你搭建一套规范的 Vue3.x 项目工程环境](https://juejin.cn/post/6951649464637636622)   

```javascript
// 1、安装 ESLint
yarn add eslint -D

// 2、配置 ESLint，建议使用系统命令行执行该命令
yarn eslint --init
// or
npx eslint --init

// 3、根据提示进行配置
//
// (1) How would you like to use ESLint? （你想如何使用 ESLint?）
//    选择 To check syntax, find problems, and enforce code style（检查语法、发现问题并强制执行代码风格）
// (2) What type of modules does your project use?（你的项目使用哪种类型的模块?）
//    选择 JavaScript modules (import/export)
// (3) Which framework does your project use? （你的项目使用哪种框架?）
//    选择 Vue.js
// (4) Does your project use TypeScript?（你的项目是否使用 TypeScript?）
//    选择 Yes
// (5) Where does your code run?（你的代码在哪里运行?）
//    选择 Browser 和 Node（按空格键进行选择，选完按回车键确定
// (6) How would you like to define a style for your project?（你想怎样为你的项目定义风格？）
//    选择 Use a popular style guide（使用一种流行的风格指南）
// (7) Which style guide do you want to follow?（你想遵循哪一种风格指南?）
//    选择 Standard: https://github.com/standard/standard（根据个人喜好）
// (8) What format do you want your config file to be in?（你希望你的配置文件是什么格式?）
//    选择 JavaScript
// (9) Would you like to install them now with npm?（你想现在就用 NPM 安装它们吗?）
//    选择 No（稍后使用yarn自行安装）
//
// 会自动生成.eslintrc.js文件

// 4、安装其它依赖
yarn add eslint-plugin-vue @typescript-eslint/eslint-plugin eslint-config-standard eslint-plugin-import eslint-plugin-node eslint-plugin-promise @typescript-eslint/parser -D

// 5、修改.eslintrc.js
// <script setup>中编译器宏如defineProps和defineEmits被no-undef规则警告，需要配置globals
// https://eslint.vuejs.org/user-guide/#compiler-macros-such-as-defineprops-and-defineemits-are-warned-by-no-undef-rule
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true
  },
  globals: {
    defineProps: 'readonly',
    defineEmits: 'readonly',
    defineExpose: 'readonly',
    withDefaults: 'readonly'
  },
  extends: [
    'plugin:vue/essential',
    'standard'
  ],
  parserOptions: {
    ecmaVersion: 2021,
    parser: '@typescript-eslint/parser',
    sourceType: 'module'
  },
  plugins: [
    'vue',
    '@typescript-eslint'
  ],
  rules: {
    'vue/no-multiple-template-root': 'off',
    'vue/comment-directive': 'off'
  },
  settings: {}
}
```

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