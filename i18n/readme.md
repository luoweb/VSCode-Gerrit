# VSCode 插件开发：多语言（国际化 i18n）完整教程

VSCode 插件官方原生支持多语言，通过内置的 l10n 模块 + 语言包文件 实现，是官方推荐的标准方案，配置简单、兼容性最好。

我给你整理了一步到位、可直接复制使用的完整流程。

## 一、核心概念

- 语言包文件：i18n/zh-cn.json、i18n/en.json 等，存放翻译键值对
- 官方 API：vscode.l10n 模块，用于读取当前语言的文案
- 自动匹配：插件会根据 VSCode 界面语言自动加载对应翻译

## 二、快速开始（5 步搞定）

### 1. 项目结构

在插件根目录创建 i18n 文件夹，存放语言文件：

```plaintext
你的插件/
├── i18n/
│   ├── en.json       # 英文
│   └── zh-cn.json    # 简体中文
├── package.json
└── src/
    └── extension.js  # 插件入口
```

### 2. 编写语言包文件

**i18n/en.json（英文）**

```json
{
  "helloWorld": "Hello World",
  "greet": "Hello, {0}",
  "welcome": "Welcome to the extension"
}
```

**i18n/zh-cn.json（中文）**

```json
{
  "helloWorld": "你好世界",
  "greet": "你好，{0}",
  "welcome": "欢迎使用插件"
}
```

### 3. 配置 package.json（关键！）

添加 l10n 配置，告诉 VSCode 语言包位置：

```json
{
  "name": "your-extension",
  "displayName": "%helloWorld%",  // 插件名支持多语言
  "description": "%welcome%",    // 描述支持多语言
  "activationEvents": ["onCommand:your-extension.helloWorld"],
  "main": "./src/extension.js",
  "contributes": {
    "commands": [
      {
        "command": "your-extension.helloWorld",
        "title": "%helloWorld%"  // 命令名称也能多语言
      }
    ]
  },
  // 👇 多语言核心配置
  "l10n": "./i18n"
}
```

`%key%` 语法：自动读取对应语言包的 value。

### 4. 在代码中使用多语言

**src/extension.js**

```javascript
const vscode = require('vscode');

function activate(context) {
    // 注册命令
    let disposable = vscode.commands.registerCommand('your-extension.helloWorld', function () {
        // 1. 基础翻译
        const hello = vscode.l10n.t('helloWorld');

        // 2. 带参数翻译 {0} 会被替换
        const greet = vscode.l10n.t('greet', 'VSCode 用户');

        // 3. 弹窗展示
        vscode.window.showInformationMessage(`${hello} | ${greet}`);
    });

    context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = { activate, deactivate };
```

**API 说明：**
- `vscode.l10n.t('key')` → 读取翻译
- `vscode.l10n.t('key', param1, param2)` → 带参数翻译

### 5. 测试多语言

1. 重启 VSCode
2. 切换 VSCode 显示语言：
   - 按 Ctrl + Shift + P
   - 输入 Configure Display Language
   - 选择 English 或 中文(简体)
3. 重新加载窗口，插件文案会自动切换

## 三、支持更多语言（一键扩展）

只需在 i18n/ 下新增对应语言文件即可：

- 繁体中文：zh-tw.json
- 日语：ja.json
- 韩语：ko.json
- 德语：de.json
- 法语：fr.json

语言代码必须符合 VSCode 标准：
[VSCode 支持的语言列表](https://code.visualstudio.com/docs/getstarted/locales#_supported-locales)

## 四、进阶用法

### 1. 给文案加注释（方便翻译）

语言包中可以加注释：

```json
{
  "helloWorld": "你好世界",
  "@helloWorld": "主命令的标题"
}
```

### 2. 动态语言切换

无需代码处理，VSCode 切换语言后重载窗口即生效。

### 3. 打包发布

打包时 i18n 文件夹会自动包含在内，无需额外配置。

## 五、常见问题

### 翻译不生效？

- 检查 package.json 中 "l10n": "./i18n"
- 检查语言文件名：zh-cn.json、en.json（小写）
- 重启 VSCode

### package.json 里 % key% 不生效？

- 必须配置 "l10n" 字段
- key 必须和语言包完全一致

### 代码里拿不到翻译？

- 使用 vscode.l10n.t()，不要手写字符串

## 六、最简总结

1. 创建 i18n/语言代码.json 翻译文件
2. package.json 添加 "l10n": "./i18n"
3. 代码用 vscode.l10n.t(key) 读取翻译
4. 切换 VSCode 语言自动生效