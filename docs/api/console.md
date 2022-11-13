---
title: 日志管理 Console
---



# miniExtend Console

这里的 Console 并不指真实的程序控制台，而是指日志，如图所示：
![日志](/static/console.png)
真正在控制台输出的信息几乎是不可见的，但是日志中的信息是可见的。

## 前置事项

在开发者工具中配置“测试”按钮（<img style='width: 52px; height: 17px;' src='/static/test-button.png' />）以启用日志。

::: tip

该按钮偶发显示异常，为保证日志功能正常启用，可多点几次以刷新状态。

:::

在玩法模式下按“日志”按钮（<img style='width: 20px; height: 20px;' src='/static/console-button.png' />）以打开日志窗口。

## 函数介绍

### `logtag`

函数原型：

```lua
function Console:logtag(tag, ...) end
```

参数：

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`tag`|`string`|输出的标签||
|`...`|`...any`|输出的内容||

在日志以 `tag` 为标签格式化输出 `...`，格式化方式与 Lua 基本函数 `print(...)` 相同。

如果 `tag` 不是字符串，结果会令人疑惑。

### `log`

在日志输出日志，标签为 `global` 。

函数原型：

```lua
function Console:log(...)
  Console:logtag("global", ...)
end
```

参数：

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`...`|`...any`|输出的内容||

等价于 `Console:logtag("global", ...)` 。

### `warn`

函数原型：

```lua
function Console:warn(message) end
```

参数：

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`message`|`string`|输出的警告信息||

在日志输出警告信息 `message` ，标签为 `warning` 。

这和<span title="这个 warn 函数指全局函数 warn，参见 difference.html"> Lua 标准函数 `warn` </span>很像，但 `Console:warn(message)` 会以黄色高亮显示警告。

### `error`

函数原型：

```lua
function Console:error(message) end
```

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`message`|`string`|输出的错误信息||

在日志输出错误信息，标签为 `error` 。

该函数不会真正抛出错误，只是输出了错误信息 `message` ，代码会正常运行。

该函数会以红色高亮显示警告。

### `clear`

函数原型：

```lua
function Console:clear() end
```

清空日志，效果同在控制台点击“清空日志”按钮。