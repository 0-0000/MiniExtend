---
title: 对象管理 Object
---



# miniExtend Object

对应源文件： `object.lua` 。

在阅读 [miniExtend Event](/api/event.html) 和 [miniExtend CustomUI](/api/ui.html) 前， 可能很难理解这部分的强大功能。这是很正常的。

目前 miniExtend Object 内容较少，且主要以理解为主。

Object 的核心是 `_G2["__OBJID"]` ，以下简称 `objid` 。

在调用 miniExtend 的一些函数时， `objid` 会作为游戏对象默认参数（参数名以 `id` 结尾，如 `playerid`）。

## 函数介绍

::: warning 没有 Object 作用域

以下函数都是全局函数。

:::

### `getObjectId`

返回 `objid` 的值。

函数原型：

```lua
function getObjectId() end
```

::: tip 为了更好的兼容性

你应该使用 `getObjidId()` 函数获取 `objid` 的值，而不是直接从 `_G2` 中取。

:::

### `setObjectId`

设置 `_G2["__OBJID"]` 的值。

```lua
function setObjectId(objid) end
```

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`objid`|`any`|需要设置的新值||

::: tip

由于命名冲突，这里 `objid` 表示 `objid` 参数。

:::

如果 `objid` 是一个数字，直接设置 `_G2["__OBJID"]` 为 `objid` ，不会检查 `objid` 是否合法。

如果 `objid` 是一个表，且 `eventobjid` 键对应的值为 `number` 类型，设置 `_G2["__OBJID"]` 为 `objid["eventobjid"]` 。这在事件的回调中非常有用，只需传递回调函数的表参数，就能自动索引 `eventobjid` 键。

## 示例

对于[`CustomUI.UIView.show([playerid])`](/api/ui.html#UIView-show) ，你可以不传递 `playerid` 参数调用该函数，这时 `objid` 将代替 `playerid` 参数。

以下代码假设你已经搭建好 miniExtend UI 环境了。

示例功能：当任意玩家进入游戏时，玩家会打开 `uiview` 界面。

```lua {7-9}
-- 需替换为 UI 界面 id
local uiid = [[]]

uiview = CustomUI:newUIView(uiid)
-- 任意玩家进入游戏事件
Event:connect([[Game.AnyPlayer.EnterGame]], function(param)
	-- 注意：objid 已被隐式地设置为 param.eventobjid
	-- 等价于调用 uiview:show(getObjectId())
	uiview:show()
end, uiid)
```