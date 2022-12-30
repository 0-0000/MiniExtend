# MiniExtend Event
对应源文件： *event.lua*, *ui_main.lua*  

---

MiniExtend Event 的前身是 `ScriptSupportEvent` ，但更便于使用，支持 [MiniExtend Object](./object.html) 。  

---

## `registerEvent(eventname, callback, [, uiid])` 函数
监听游戏事件，在 `eventname` 所描述的事件发生时，回调 `callback` 。  
返回描述事件监听的 [`Register` 表](#Register-表)，用于取消事件监听。  

如果 `eventname` 所描述的事件为 [UI 事件](./document.html#UI-事件)，需要指定 `uiid` 需要监听的 UI 界面 id 。  
监听 UI 事件会发生预绑定，常规流程(在第 0 帧和 `ui_main` 脚本前)不会真的监听事件，而是将信息存储在返回的 `Register` 表中(不含 `id` 值，暂存了临时值)。  
在对应的 `ui_main` 脚本执行后会完成绑定并完成 `Register` 表(移除临时值，赋值 `id`)，在中途修改返回的 `Register` 可能导致错误。  

该函数是 MiniExtend Event 的核心。  
该函数的原型为 `ScriptSupportEvent:registerEvent(msgStr, func)` 。  

### 参数
- `eventname`:`{string}`  
描述事件，详见[自定义事件名](#自定义事件名)  
- `callback`:`{function}`  
指定回调函数，这部分内容详见[回调](#回调)。  
- `uiid`:`{string | nil}`  
如果所指定事件为 UI 事件，那么该参数应为 `string` 类型，表示要监听的 UI 界面 id 。  
否则如果指定事件非 UI 事件，应指定为 `nil` 。  
对于 UI 事件，函数只能监听 `uiid` 所指 UI 界面发生的事件，其它 UI 界面发生的事件不会被监听，解决方法是对每个需要监听的 UI 界面使用不同的 `uiid` 参数调用该函数。  

> 以上参数都会被检查，如果参数不正确则会报错。  

### 回调
- 回调是以**保护模式**运行的，如果发生错误， MiniExtend 会输出错误信息，在错误信息前还会带上自定义的错误头。  
- 回调函数调用时，还会传递一个哈希表作为参数，以下简称 `param` ，存储着该事件发生时的一些信息。  
- `param` 就是 `ScriptSupportEvent:registerEvent()` 回调函数传递的参数，详见[假 wiki](https://developers.mini1.cn/wiki/event.html) 。  
但除此之外， `param` 还必包含一个 `register` ，表示事件监听对应的 [`Register` 表](#Register-表)。  
- 回调函数前会提前隐式地设置 `objid` 的值为 `param["eventobjd"]` ，在回调结束后会恢复 `objid` 的值。  

---

## `cancelRegisterEvent(register)` 函数
- 取消 `register` 描述的事件监听。  
- `register`:`{table<Register>}` 描述事件监听的 [`Register` 表](#Register-表)。  

---

## 自定义事件名
下文将事件名简称 `eventname` ，原始事件名称为 `msgStr` 。  
需要使用 `msgStr` 作为参数调用 API ，但 MiniExtend 提供了更简短，可读性更高的自定义事件，于是就有了 `eventname` ，它作为调用 `registerEvent()` 时实际传入的参数。  

既可以使用 MiniExtend 自定义事件名，也可以使用 API 事件名。   
MiniExtend 自定义事件名在 *event.lua* 中的 `CustomEvents`(局部变量) 中定义。  

如果 `eventname` 以 `"$"` 开头，则认为其为 MiniExtend 自定义事件名，否则为 API 事件名。  
如果为 MiniExtend 自定义事件名，则 `msgStr = CustomEvents[eventname];` 。  
否则对于 API 事件， `msgStr = eventname;` 。  

### 自定义事件名列表
以下忽略了 `"$"` 前缀:  
- `ui.onShow`: UI 界面显示事件，对应 `[[UI.Show]]` 。  
- `ui.onHide`: UI 界面隐藏事件，对应 `[[UI.Show]]` 。  
- `ui.onPress`: 按钮按下事件，对应 `[[UI.Show]]` 。  
- `ui.onClick`: 按钮点击事件，对应 `[[UI.Show]]` 。  
- `ui.onLostFocus`: 输入框失去焦点事件，对应 `[[UI.Show]]` 。  

你会发现这些自定义事件名描述的都是 UI 事件，实际上通常通过 [MiniExtend UI](./ui.html) 监听这些事件。  
注: 点击 = 按下 + 释放(目前无法监听该事件)，按下事件不是延续性事件，只会在玩家开始按下的那一帧触发。  

---

## `Register` 表
`Register` 表是 `registerEvent()` 的返回值，用于作为 `cancelRegisterEvent()` 的参数来取消事件监听。  
注意 `Register` 表是 MiniExtend 理论中的一个表，`_GScriptFenv_["Register"]` 为 `nil` 。  

不要修改 `Register` 表的值，仅将整个表作为参数调用 `cancelRegisterEvent()`，以下内容只是为了方便开发者

### 值
- `id`:`{integer}` 表示事件监听的 id。  
- `uiId`:`{string | nil}` 如果是 UI 事件则为事件监听所属 UI 界面，否则为 `nil` 。  
- `msgStr`:`{string}` API 事件名。  

以下值是内部使用的临时值，在预绑定期间才会存在。  
- `callback`:`{function}` 回调的函数。  
- `eventName`:`{string}` 事件名，即调用 `registerEvent()` 时传递的 `eventname` 参数。  

---
