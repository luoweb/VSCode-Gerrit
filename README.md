# VSCode Gerrit

将 [Gerrit 代码审查工具](https://www.gerritcodereview.com/) 集成到 VSCode 中的扩展。允许查看 Gerrit 变更、它们包含的文件变更及其差异，以及对这些变更进行评论。还允许您创建和提交新的变更，当然也可以修改现有的变更。


## 设置

要设置扩展，您需要设置认证。这可以通过运行 `Gerrit: Enter credentials` 命令来完成。这将引导您完成整个过程。其中一些设置也可以通过设置进行配置，而其他设置则存储为加密的秘密。

-   `gerrit.auth.username` - 这是您在 Gerrit 上的用户名。您可以在 "HTTP Credentials" 下的 `Username` 字段旁边找到它。
-   `gerrit.auth.url` - 这会自动从您的 `.gitreview` 文件（如果有的话）中推断。如果您没有或它不起作用，请将此 URL 设置为您的 Gerrit 实例的 HTTP URL。这将是您在浏览器中访问的 URL。
-   `gerrit.auth.password` - 您的 HTTP 密码（通过命令输入时存储为加密的秘密）。您可以通过在 Gerrit 上点击 "Generate new password" 并复制它来生成一个。
-   认证 cookie - 如果您的管理员禁用了 HTTP 凭证，请使用此选项。通过命令输入（安全存储）或在设置中设置 `gerrit.auth.cookie`。您可以通过在浏览器中访问 Gerrit，打开开发工具，并复制名为 `GerritAccount` 的 cookie 的值来找到它。
-   `gerrit.auth.extraCookies` - 除认证 cookie 外，在每次请求时发送的其他 cookie。

您也可以在设置中设置 `gerrit.auth.password` 和 `gerrit.auth.cookie`；这些不推荐，因为它们以明文形式存储。首选 "Gerrit: Enter credentials" 进行安全存储。在 devcontainers 等情况下仍然支持使用设置。

## 功能

### 变更面板

变更面板（展开 Gerrit 侧边栏项目时的顶部面板）包含一个变更列表，本质上等同于您的 Gerrit 仪表板。此列表会定期自动更新，但也可以手动刷新。您可以检出变更、执行 [快速检出](#快速检出)，或展开它以查看更改的各个文件。

就像在 Gerrit 上一样，您可以通过点击齿轮图标（配置过滤器）和菜单图标（选择活动视图）来调整此列表中显示的变更。

此外，还有一个搜索功能，允许您搜索任何您想要的变更。它为 Gerrit 支持的所有过滤器及其值提供自动完成。

### 评论

检出补丁后，您可以在更改的文件中放置和回复评论。您可以通过点击编辑器左侧装订线中的加号图标来完成此操作。就像在 Gerrit 上一样，您可以创建已解决和未解决的评论。

### 审查面板

审查面板允许您发布草稿评论并回复或对变更进行投票。它始终适用于当前检出的变更，并会列出该补丁的变更 ID。

### 快速检出

快速检出允许您在处理某件事时快速检出补丁。它本质上等同于 `git stash && git review -d changeId`。然后，它会在 Gerrit 面板和状态栏中添加一个快速检出条目。点击此条目会检出您在进行快速检出之前所在的原始分支，并重新应用您创建的存储。这允许您快速检出变更进行审查，而不会丢失您的工作。

### 变更选择器

变更选择器可以在状态栏中找到。它将始终列出当前检出的变更。点击它会打开一个选择器，显示您最相关的变更（和 `master` 分支）。选择一个变更会为您检出它。此选择器也可以通过 `gerrit.openChangeSelector` 键绑定绑定到键盘快捷键。

### 推送审查

Gerrit 扩展还在您的 git 面板中添加了一个 "Push for review" 按钮。它是中间有一个圆圈的垂直线。当您点击它时，扩展会为您运行 `git review`。如果一切顺利，它会允许您在线打开链接，以及其他一些操作。

### 在 [gitiles](https://gerrit.googlesource.com/gitiles/) 上打开

添加了 `Open on gitiles` 装订线操作，以及命令面板中的操作。这些允许您在 gitiles 上打开指向您当前查看的文件的链接，允许您与他人共享您的代码，即使它尚未合并。

### URI 处理程序

此扩展为 `vscode://roweb.vscode-gerrit` URI 注册了一个 URI 处理程序。这些允许您在编辑器中打开文件和变更。您可以检出变更或简单地预览它们。一个示例用例是向您的同事发送 "在编辑器中查看" 链接，以便他们可以在编辑器中而不是在 web 视图中检查您的变更。

支持以下（均为可选）字段：

-   `change` - 相关变更。如果未提供，默认为当前检出的变更。可以是变更 ID 或补丁集编号。
-   `patchSet` - 相关补丁集。如果未提供，默认为最新补丁集。必须是数字。
-   `checkout` - 如果提供，将检出变更。如果不提供，将预览变更。
-   `file` - 要打开的文件。
-   `line` - 要滚动到的行。

一些示例：

-   `vscode://roweb.vscode-gerrit?change=12345&checkout` - 检出变更
-   `vscode://roweb.vscode-gerrit?change=12345&file=index.ts&line=10` - 在不检出的情况下预览变更中的文件
-   `vscode://roweb.vscode-gerrit?change=12345&checkout&patchset=2` - 检出变更的旧补丁集

### 流事件

虽然 UI 中的变更和数据会频繁刷新，但变更不是即时的。您可以通过使用流事件功能，在变更发生时立即在 UI 中反映任何变更。这利用了 Gerrit 的一项功能，允许您通过 SSH 监听 Gerrit 事件。要启用此功能，请启用 `gerrit.streamEvents` 设置。请注意，您需要是 Administrators 组的成员，或者需要被授予 `Stream Events` 权限。