# MiniExtend Event
对应源文件： *event.lua*, *ui_main.lua*  

## 自定义事件名
下文将事件名简称 `eventname` ，原始事件名称为 `msgStr` 。  
需要使用 `msgStr` 作为参数调用 API ，但 MiniExtend 提供了更简短，可读性更高的自定义事件，于是就有了 `eventname` ，它作用调用 MiniExtend 时实际传入的参数。  

既可以使用 MiniExtend 自定义事件名，也可以使用 API 事件名。   
MiniExtend 自定义事件名在 `Event.CustomEvents` 中定义。  

如果 `eventname` 以 `"$"` 开头，则认为其为 MiniExtend 自定义事件名，否则为 API 事件名。  
如果为 MiniExtend 自定义事件名，则 `msgStr = Event.CustomEvents[eventname];` 。  
否则对于 API 事件， `msgStr = eventname;` 。  

MiniExtend 自定义事件名(忽略 `"$"` 前缀):  
- `ui.onShow`: 等同于 `[[UI.Show]]` ， UI 界面显示时调用。  
- `ui.onHide`: 等同于 `[[UI.Hide]]` ， UI 界面隐藏时调用。  
- `ui.onPress`: 等同于 `[[UI.Button.TouchBegin]]` ， 按钮被按下时调用。  
- `ui.onClick`: 等同于 `[[UI.Button.Click]]` ， 按钮被点击时调用。  
- `ui.onLostFocus`: 等同于 `[[UI.LostFocus]]` ， 输入框失去焦点时调用。  

你会发现这些自定义事件名描述的都是 UI 事件，实际上通常通过 [MiniExtend UI](./ui.html) 监听这些事件。  
注: 点击 = 按下 + 释放(目前无法监听该事件)，按下事件不是延续性事件，只会在玩家开始按下的那一帧触发。  

## <code style="color:green;">Event</code> 作用域
MiniExtend Event 的前身是 `ScriptSupportEvent` ，但更便于使用，支持 [MiniExtend Object](./object.html) 。  
Event 作用域包含上面提到的 MiniExtend 自定义事件和 `Connecter` 类。  

## `Event.Connecter` 类
`Event.Connecter` 类管理事件监听， 一个 `Event.Connecter` 对象就代表这一个监听，并提供了删除监听的方法。  
以下简称 `Event.Connecter` 为 `Connecter` 。  

### 构造函数
#### 语法
> `Event.Connecter:new(eventname, callback, [, uiid])`  

在 `eventname` 所描述的事件发生时，调用 `callback` ，如果 `eventname` 所描述的事件为 UI 事件，需要指定 `uiid` 需要监听的 UI 界面 id 。  
该函数是 MiniExtend Event 的核心，作用为监听游戏事件，在事件发生时回调函数，并返回构造出的 `Connecter` 对象。  
该函数的原型为 `ScriptSupportEvent:registerEvent(msgStr, func)` 。  

#### 参数
> ##### `eventname` 参数
> 类型: string  
> 描述事件，详见[自定义事件名](#自定义事件名)
> ##### `callback` 参数
> 类型: function  
> 指定回调函数。  
> > 回调函数调用时，还会传递一个哈希表作为参数，以下简称 `param` ，存储着该事件发生时的一些信息。  
> > `param` 原型就是 `ScriptSupportEvent:registerEvent()` 回调函数传递的参数，详见[假 wiki](https://developers.mini1.cn/wiki/event.html) 。  
> > 但除此之外， `param` 还必包含一个 `connecter` ，表示该监听对应的 `Connecter` 对象。  
> > 回调函数时还会提前隐式地设置 `objid` 的值为 `param["eventobjd"]` ，根据 `setObjectId()` 函数的行为，如果不包含那个键，那么 `objid` 的值不会被设置。  
>
> `eventname` 和 `callback` 参数都会被检查，如果它们类型错误则会报错。  
> ##### `uiid` 参数 ###
> 类型: string | nil  
> 如果所指定事件为 UI 事件，那么该参数应为 `string` 类型，表示要监听的 UI 界面 id 。  
> 如果指定事件非 UI 事件，应指定为 `nil` 。  
> 对于 UI 事件，如果该参数类型不为 `string` ，会导致报错。  
> 对于 UI 事件，函数只能监听 `uiid` 所指 UI 界面发生的事件，其它 UI 界面发生的事件不会被监听，解决方法是对每个需要监听的 UI 界面使用不同的 `uiid` 参数调用该函数。  

### 析构函数
#### 语法
> `Event.Connecter:delete()`  

删除监听，但不删除对象本生。  
如果要删除对象本生，将访问对象的链接设为 `nil` ，让 lua 垃圾回收器回收对象。  

### 属性
- `eventName`: `string` 类型，等于调用 `Event.Connecter:new()` 函数时传递的 `eventname` 参数。  
- `msgStr`: `string` 类型，事件在 API 中的名称，除非使用 miniExtend 自定义事件否则等于 `eventName` 属性。  
- `id`: `number` 类型，监听的 id 。  
- `isUIEvent`: `boolean | nil` 类型， `true` 表示事件为 UI 事件，否则为 `nil` 。  
- `uiId`: `string | nil` 类型，监听的 UI 界面的 id ，非 UI 事件为 `nil` 。  
- `callback`: `function` 类型，事件发生时回调的函数，**你可以修改它**，这样在事件发生时回调的函数会改变。  
