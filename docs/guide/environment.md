---
title: 环境搭建
---



# miniExtend 环境搭建

## 全局作用域

关于作用域，参见[定义](./document.html#namespace)。

在全局作用域下，按<span title="源代码开头显示了它们依赖的脚本">一定顺序</span>加入这些脚本。

脚本对应源文件 = `<脚本名>` + `.lua` ，例如 `core` 脚本对应 `core.lua`。

以下是一个合法的顺序，你可以按照该顺序来创建脚本：

1. `core`
2. `time`
3. `console`
4. `object`
5. `event`
6. `ui`

直接将源代码复制到脚本中即可，也可以使用加载文件按钮<img style='/static/load-script-button.png' src='' />来加载源代码。

完成后界面应如图所示（main 脚本组管理自己的脚本）：

![](/static/global-scripts.png)

::: tip

脚本、脚本组的命名不影响 miniExtend 正常运行，但良好的命名习惯有利于错误排查。

如果没有做好命名，错误发生时会看到满屏的`[脚本]`。

:::

## UI 环境

对于**所有**UI 作用域，创建 `ui_main` 脚本（对应源文件为 `ui_main.lua`）。

然后**将 `uiid` 替换为所属 UI 界面 ID**。

::: tip

UI 界面创建时，对应作用域下会自动创建一个<span title="该触发器会使得玩家自动打开该 UI 界面">触发器</span>，你应该**将其删除**。

:::

UI 作用域下的脚本初始化后结果：![](/static/ui-scripts.png)

UI_main 脚本示例：![](/static/ui-env-script.png)

## 创建自己的脚本

做完以上操作，你已经成功搭建了 miniExtend 环境，现在可以新建脚本使用 miniExtend 功能了。

::: tip

使用 miniExtend 的脚本**必须位于全局作用域下**，且**位置必须在 miniExtend 脚本之后**，否则无法正常使用 miniExtend 。

:::

创建自己的脚本：

![](/static/my-script.png)

## 更高效的开发

该步骤是可选的。

你可以在代码中插入 `ide.lua` 中的内容，里面包含了 miniExtend 关键字，这允许你的编辑器自动补全它们。

![在脚本中插入 ide.lua](/static/ide.png)

## Hello, World!

接下来我们使用 miniExtend 监听“玩家动作改变”事件，事件发生时在日志以 `tag` 为标签输出 `Hello World!` 。

```lua
Event:connect([[Player.PlayAction]], function(paprm)
  Console:logtag("tag", "Hello, world!");
end)
```