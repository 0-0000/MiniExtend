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
function Event:connect(eventname, callback, [, uiid]) end
```

参数：

- `eventname` ：监听的事件名。
  该参数应是[支持的事件](#事件列表)， miniExtend 自定义的事件名如下：
- `callback` ：事件触发后调用的函数。
  该参数是 `function` 类型，指定要回调的函数。
  该参数不会被检查，且只会在事件发生时才会使用。
- `uiid` ：要监听的 UI 界面 id ，非 UI 事件则不传。
  对于 UI 事件，会检查参数类型是否为 `string`。
  对于 UI 事件，只能监听 `uiid` 所指 UI 界面发生的事件，其它 UI 界面发生的事件会被丢弃。如果要监听多个 UI 界面事件，请对**每个** UI 界面执行该函数。

回调函数调用时，还传递一个 `table` 作为参数（以下简称 `param` ），包含事件相关信息。

`param` 包含 `ScriptSupportEvent:registerEvent` 传递的参数。除此之外，还包含一个 `listener` ，表示监听该事件的 `Event.Listener` 对象。

调用回调函数前，miniExtend 会隐式设置 `objid` 的值为 `paprm["eventobjd"]` 。根据 `setObjectId()` 函数的行为，如果不包含那个键，那么 `objid` 的值不会被设置。

## 类介绍

### `Event.Listener`

又名“事件监听器”。

本类用于管理事件监听，每次调用 `Event:connect` 会创建并返回一个监听器。监听器包含了该监听的一些信息，并提供了取消监听的方法。

成员变量：

- `callBack` ： `function` 类型，事件发生时要回调的函数。本属性可修改，并会实时应用。
- `id` : `number` 类型，事件 ID 。
- `eventName` : `string` 类型，调用 `Event:connect` 函数时传递的 `eventname` 参数。
- `msgStr` ： `string` 类型，事件在迷你世界 API 中的名称。除非使用 miniExtend 自定义事件，否则本属性为 `eventName` 。

成员函数：

- `delete` ：取消对应的监听。
  该函数只取消监听，不会删除对象本身。如果需要，请让 [Lua 垃圾回收器](https://www.runoob.com/lua/lua-garbage-collection.html)处理。

## 事件列表

- [官方开放的事件](https://dev-wiki.mini1.cn/cyclopdeia?wikiMenuId=3&wikiId=1353)。
- `ui.show` ：等价于 `UI.Show` ， UI 界面显示。
- `ui.hide` ：等价于 `UI.Hide` ， UI 界面隐藏。
- `ui.onPress` ：等价于 `UI.Button.TouchBegin` ，按钮被按下，注意该事件不是持续性事件。
- `ui.onClick` ：等价于 `UI.Button.Click` ，按钮被点击。
- `ui.onInput` ：等价于 `UI.LostFocus` ，输入框输入完成。