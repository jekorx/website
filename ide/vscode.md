# VSCode

#### 配置

```json
{
    "breadcrumbs.enabled": false,
    "dart.debugExternalLibraries": true,
    "dart.debugSdkLibraries": false,
    "diffEditor.ignoreTrimWhitespace": false,
    "editor.minimap.enabled": true,
    "editor.fontSize": 17,
    "editor.formatOnPaste": true,
    "editor.multiCursorModifier": "ctrlCmd",
    "editor.snippetSuggestions": "top",
    "editor.tabSize": 2,
    "emmet.includeLanguages": {
        "wxml": "html"
    },
    "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "html"],
    "explorer.autoReveal": false,
    "files.associations": {
        "*.cjson": "jsonc",
        "*.wxss": "css",
        "*.wxs": "javascript"
    },
    "http.proxyAuthorization": "false",
    "minapp-vscode.disableAutoConfig": true,
    "terminal.integrated.fontSize": 17,
    "terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe",
    "update.enableWindowsBackgroundUpdates": false,
    "vsicons.dontShowNewVersionMessage": true,
    "vetur.validation.template": false,
    "volar.codeLens.pugTools": false,
    "workbench.colorTheme": "Monokai",
    "workbench.iconTheme": "vscode-icons",
    "workbench.startupEditor": "newUntitledFile",
    "workbench.sideBar.location": "left",
    "window.zoomLevel": 0,
    "extensions.autoUpdate": true,
    "update.mode": "manual"
}
```

#### 常用插件

```bash
# 中文
Chinese (Simplified) Language Pack for Visual Studio Code
# 编辑器代码格式化
EditorConfig for VS Code
# js格式校验
ESLint
# git忽略
gitignore
# 路径自动补全
Path Intellisense
# sublime键位
Sublime Text Keymap
# 资源管理器图标
vscode-icons
# () [] {} 匹配高亮区分
Bracket Pair Colorizer 2
# markdown文件预览
Markdown Preview Enhanced
# svn
SVN
# vue
Vetur
# react
Simple React Snippets
# css预编译stylus
language-stylus
# flutter开发插件，自动安装dart插件
Flutter
# flutter 模版
Flutter Widget Snippets

# px2rem.rootFontSize 默认设计稿宽750px，默认使用iphone7 设备宽375px 开发，按照index.js[x]中的rem自适应计算方法为 50
# 详细配置查看该插件说明
px2rem
```

#### 部分快捷键配置

```bash
# 1、代码提示
# 原快捷键 Ctrl + space，与系统冲突，修改即可
# 文件 -> 首选项 -> 键盘快捷方式，搜索“触发建议”，修改为 Alt + / ，按enter键保存即可
```

#### 自定义模版

![自定义模版](../assets/ide-vscode-1.jpg)
![自定义模版](../assets/ide-vscode-2.jpg)
![自定义模版](../assets/ide-vscode-3.jpg)

> 在生成的```template.code-snippets```中加入以下  

```json
{
  "vue2": {
    "prefix": "vue2 init template",
    "scope": "vue",
    "body": [
      "<template>",
      "  <div>",
      "  </div>",
      "</template>",
      "<script>",
      "export default {",
      "  name: '$1'",
      "}",
      "</script>",
      "<style scoped>",
      "",
      "</style>",
      ""
    ],
    "description": "vue2初始化模版"
  },
  "vue3": {
    "prefix": "vue3 init template",
    "scope": "vue",
    "body": [
      "<template>",
      "  <div>",
      "  </div>",
      "</template>",
      "<script lang=\"ts\">",
      "import { defineComponent } from 'vue'",
      "",
      "export default defineComponent({",
      "  name: '$1',",
      "  setup () {",
      "    return {",
      "",
      "    }",
      "  }",
      "})",
      "</script>",
      "<style scoped>",
      "",
      "</style>",
      ""
    ],
    "description": "vue3初始化模版"
  }
}
```

> 使用  

![自定义模版](../assets/ide-vscode-4.jpg)