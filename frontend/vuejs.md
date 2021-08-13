# Vue.js

## Vue@2.x

#### 父子组件生命周期顺序

```js
/* 加载渲染过程 */

parent beforeCreate
        ↓
parent created
        ↓
parent beforeMount
        ↓
child beforeCreate
        ↓
child created
        ↓
child beforeMount
        ↓
child mounted
        ↓
parent mounted
```

```js
/* 更新过程 */

// 子组件更新
child beforeUpdate
        ↓
child updated

// 子组件影响父组件（$emit）、父组件影响子组件（props）
parent beforeUpdate
        ↓
child beforeUpdate
        ↓
child updated
        ↓
parent updated

// 父组件更新
parent beforeUpdate
        ↓
parent updated

```

```js
/* 销毁过程 */

parent beforeDestroy
        ↓
child beforeDestroy
        ↓
child destroyed
        ↓
parent destroyed
```