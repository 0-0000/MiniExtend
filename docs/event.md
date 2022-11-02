# miniExtend Event #
对应源文件： `event.lua` 。  
## 事件管理 <code style="color:green;">Event</code> ##
miniExtend Event 原型为 `ScriptSupportEvent` ，但功能更多，支持 [miniExtend Object](./object.html) 。  
## `Event:connect()` 函数 ##
该函数是 miniExtend Event 的核心，作用为监听游戏事件，在事件发生时回调函数。  
该函数原型为 `ScriptSupportEvent:registerEvent(msgStr, func)` 。  
### 语法 ###
> `Event:connect(eventname, callback, [, uiid])`  
> 在 `eventname` 所描述的事件发生时，调用 `callback` ，如果 `eventname` 所描述的事件为 <a title="判定依据为事件名以 UI 或 ui 开头，前提是存在该事件">UI 事件</a>，需要指定 `uiid` 为事件所处 UI 界面 id 。  
> #### `eventname` 参数 ####
> > 该参数是 `string` 类型，描述事件，形如 `[[namespace.event]]` 。  
> > 该参数不合法会导致报错： <span style="color:red;">`miniExtend - Event:connect() : bad argument #1 'eventname'`</span> 。  
> > 该参数可以是 miniExtend 自定义的事件名，也可以是 `ScriptSupportEvent:registerEvent()` 函数支持的事件名， miniExtend 自定义的事件名如下：  
> > `[[ui.show]]` ：等价于 `[[UI.Show]]` ， UI 界面显示。  
> > `[[ui.hide]]` ：等价于 `[[UI.Hide]]` ， UI 界面隐藏。  
> > `[[ui.onPress]]` ：等价于 `[[UI.Button.TouchBegin]]` ，按钮被按下，注意该事件不是持续性事件。  
> > `[[ui.onClick]]` ：等价于 `[[UI.Button.Click]]` ，按钮被点击。  
> > `[[ui.onInput]]` ：等级于 `[[UI.LostFocus]]` ，输入框失去焦点，可以理解为玩家完成了在输入框的输入。  
> > 这些自定义的事件名都描述的是 UI 事件，但通常通过 [CustomUI](./ui.html) 来监听这些事件。  
> > 注：点击=按下+释放，玩家可能按下按钮，然后把焦点移出按钮再释放，此时不会触发该按钮的释放事件，也就不会触发按钮的点击事件。  
> #### `callback` 参数 ####
> > 该参数是 `function` 类型，指定要回调的函数，该参数不会被检查，且只会在事件发生时才会报错。  
> > 
> > 回调函数调用时，还会传递一个哈希表作为参数，以下简称 `paprm` ，存储着该事件发生时的一些信息。  
> > `paprm` 一定包含 `ScriptSupportEvent:registerEvent(eventname, callback);` 会传递的参数，详见[假 wiki](https://developers.mini1.cn/wiki/event.html) 。  
> > 除此之外，还必包含一个 `listener` ，表示监听该事件的 `Event.Listener` 对象， `Event.Listener` 对象详见下文。  
> > 回调函数时还会提前隐式地设置 `objid` 的值为 `paprm["eventobjd"]` ，根据 `setObjectId()` 函数的行为，如果不包含那个键，那么 `objid` 的值不会被设置。  
> ### `uiid` 参数 ###
> > 如果所指定事件为 UI 事件，那么该参数应为 `string` 类型，表示要监听的 UI 界面 id ，非 UI 事件应指定为 `nil` 。  
> > 对于 UI 事件，如果该参数类型不为 `string` ，会导致报错： <span style="color:red;">`miniExtend - Event:connect() : bad argument #3 'uiid'`</span> 。  
> > 对于 UI 事件，函数只能监听 `uiid` 所指 UI 界面发生的事件，其它 UI 界面发生的事件（如按钮被点击）不会被监听，解决方法是对每个需要监听的 UI 界面使用不同的 `uiid` 参数执行该函数。  
## `Event.Listener` 类 ##
`Event.Listener` 类管理事件监听，每次调用 `Event:connect()` 都会返回一个 `Event.Listener` 对象，该对象包含了该监听的一些信息，并提供了删除监听的方法。  
### 属性 ###
- `callBack` ： `function` 类型，事件发生时要回调的函数，你可以修改它，这样在事件发生时回调的函数会改变。  
- `id` : `number` 类型，事件 id 。
- `eventName` : `string` 类型，等于调用 `Event:connect()` 函数时传递的 `eventname` 参数。  
- `msgStr` ： `string` 类型，事件在 API 中的名称，除非使用 miniExtend 自定义事件否则等于 `eventName` 属性，正常等于 `paprm["msgStr"]` 。  
### 方法 ###
#### `delete()` 方法 ####
删除对象所指的监听，在事件发生时不再调用 `callBack` 。  
该函数只取消监听，不会删除对象本生，让 lua 垃圾收集器做这件事。  
