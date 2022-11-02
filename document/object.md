# miniExtend Object #
对应源文件： `time.lua` 。  

在阅读 [miniExtend Event](./event.html) 和 [miniExtend CustomUI](./ui.html) 前， 可能很难理解这部分的强大功能，这是很正常的。  

目前 miniExtend Object 内容较少，且主要以理解为主。  
Object 的核心是 `_G2["__OBJID"]` ，以下简称 `objid` 。  
在调用 miniExtend 的一些函数时， `objid` 会作为游戏对象默认参数（参数名形如 `...id` ，如 `playerid`）。  
注意， miniExtend 没有 `Object` 这个作用域，以下函数都是全局函数，**没有约定作用域时默认为全局函数**。
### `getObjectId()` 函数 ###
> 返回 `objid` 的值。  
> 你应该使用 `getObjidId()` 函数获取 `objid` 的值，而不是使用 `_G2["__OBJID"]` 。  
### `setObjectId(objid)` 函数 ###
> 由于名称冲突，这里 `objid` 表示 `objid` 参数。  
> 设置 `_G2["__OBJID"]` 的值。  
> 如果 `objid` 是一个数字，直接设置 `_G2["__OBJID"]` 为 `objid` ，不会检查 `objid` 是否合法。  
> 如果 `objid` 是一个表且 `eventobjid` 键对应的值为 `number` 类型，设置 `_G2["__OBJID"]` 为 `objid["eventobjid"]` 。这在事件的回调中非常有用，只需传递回调函数的表参数，这样会自动索引 `eventobjid` 键。  
> 如果 `objid` 类型为其它，函数不做有意义的事。  

## 实例 ##
对于[`CustomUI.UIView.show([playerid])`](./ui.html#UIView-show) 这个函数，你可以不传递 `playerid` 参数调用该函数，这时 `objid` 将代替 `playerid` 参数。  
以下代码假设你已经配置好 miniExtend UI 环境了。  

	-- 需替换为 UI 界面 id
	local uiid = [[]]
	
	uiview = CustomUI:newUIView(uiid)
	-- 任意玩家进入游戏事件
	Event:connect([[Game.AnyPlayer.EnterGame]], function(paprm)
		-- objid 已被隐式地设置为 paprm.eventobjid
		-- 等价于调用 uiview:show(getObjectId())
		uiview:show()
	end, uiid)
当任意玩家进入游戏时，玩家会打开 `uiview` 界面。
