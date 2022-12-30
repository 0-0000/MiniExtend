# MiniExtend Object #
对应源文件： *object.lua*  

---

MiniExtend Object 主要是为 [MiniExtend Event](./event.html) 和 [MiniExtend UI](./ui.html) 设定的。  

目前 MiniExtend Object 内容较少，且主要以理解为主。  
Object 的核心是一个叫 `objid` 的虚有值(在内部是局部变量)， `objid` 默认为 0 。  
在调用 MiniExtend 的一些函数时， `objid` 会作为游戏对象 id 参数(参数名形如 `...id` ，如 `playerid`) 的默认值。  

---

## 注意事项
在延时调用中是不会有正确的 `objid` 值的，特别是在 `registerEvent()` 的回调函数中要注意。  
因为在发动延时调用后，回调函数会正常结束，然后会恢复 `objid` 的值，这时已经失去了理想的 `objid` 的值。  

---

## 函数
以下函数都是在 `_GScriptFenv_` 中的全局函数。  

### `getObjectId()` 函数
> 返回 `objid` 的值。  
### `setObjectId(objectid)` 函数
> 设置 `objid` 的值。  
> `objectid`:`{integer}` 要设置的 `objid` 的值  

---

## 实例
对于[`UI.UIView:show([playerid])`](./ui.html#UIView-show) 这个函数，你可以不传递 `playerid` 参数调用该函数，这时 `objid` 将代替 `playerid` 参数。  
在 `registerEvent()` 的回调中， `objid` 会被临时地设置为 `param["eventobjid"]` 。  

以下代码使得当任意玩家进入游戏时，玩家会打开 `uiview` 界面。  

### 代码
<textarea>
Env.__init__()
-- 需替换为 UI 界面 id
local uiid = [[]]
uiview = UI.UIView:new(uiid)
-- 任意玩家进入游戏事件
registerEvent([[Game.AnyPlayer.EnterGame]], function(param)
	-- objid 已被隐式地设置为 param.eventobjid
	-- 等价于调用 uiview:show(getObjectId())
	uiview:show()
end, uiid)
</textarea>
