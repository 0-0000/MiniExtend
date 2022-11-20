---
title: 事件管理 Event
---



# miniExtend Event

对应源文件： `event.lua` 。

本文件更好地实现了 `ScriptSupportEvent` ，且支持 [miniExtend Object](/api/object) 。

## 函数介绍

### `connect`

该函数是 miniExtend Event 的核心，用于监听游戏事件，在事件发生时回调函数。

该函数调用了 `ScriptSupportEvent:registerEvent(msgStr, func)` 。

函数原型：

```lua
function Event:connect(eventname, callback [, uiid])
  -- 处理一些特殊逻辑
  ScriptSupportEvent:registerEvent(eventname, callback)
end
```

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`eventname`|[支持的事件](#事件列表)|监听的事件名||
|`callback`|`function([param])`|事件发生后调用的函数||
|`uiid`|`string`|要监听的 UI 界面 ID|:heavy_check_mark:|


回调函数调用时，还传递一个 `table` 作为参数（以下简称 `param` ），包含事件相关信息。

`param` 包含 `ScriptSupportEvent:registerEvent` 传递的参数。除此之外，还包含一个 `listener` ，表示监听该事件的 `Event.Listener` 对象。

调用回调函数前，miniExtend 会隐式设置 `objid` 的值为 `param["eventobjd"]` 。根据 `setObjectId()` 函数的行为，如果不包含那个键，那么 `objid` 的值不会被设置。

## 类介绍

### `Event.Listener`

又名“事件监听器”。

本类用于管理事件监听，每次调用 `Event:connect` 会创建并返回一个监听器。监听器包含了该监听的一些信息，并提供了取消监听的方法。

成员变量：

|名称|类型|简介|可写|
|:---:|:---:|:---:|:---:|
|`callBack`|`function`|事件发生时要回调的函数|:heavy_check_mark:|
|`id`|`number`|事件ID||
|`eventname`|`string`|创建时传的`eventname`参数||
|`msgStr`|`string`|事件在迷你世界 API 中的名称||

成员函数：

```lua
-- 该函数只取消监听，不会删除对象本身。
-- 如果需要删除对象，请让Lua 垃圾回收器处理。
function Event.Listener:delete() end
```

## 事件列表

- [官方开放的事件](https://dev-wiki.mini1.cn/cyclopdeia?wikiMenuId=3&wikiId=1353)。
- `ui.show` ：等价于 `UI.Show` ， UI 界面显示。
- `ui.hide` ：等价于 `UI.Hide` ， UI 界面隐藏。
- `ui.onPress` ：等价于 `UI.Button.TouchBegin` ，按钮被按下，注意该事件不是持续性事件。
- `ui.onClick` ：等价于 `UI.Button.Click` ，按钮被点击。
- `ui.onInput` ：等价于 `UI.LostFocus` ，输入框失去焦点。

::: tip 对于等价的事件

应该优先选择 miniExtend 拓展的事件名，这会有更好的可读性。

:::