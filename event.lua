--[=[
event.lua
处理回调
依赖于 core.lua, object.lua
]=]

local ScriptSupportEvent = ScriptSupportEvent

--uiSSEObjects 存储 UI 界面的 ScriptSupportEvent 对象，以 UI 界面 id 为索引
--uiEvents 暂时存储还不能绑定的 UI 事件
local uiSSEObjects, uiEvents = {}, {}
--UI 作用域中 ui_main 脚本将调用 __newUI 来处理属于该 UI 界面的事件
_G2["__newUI"] = function(uiid, SSE)
	--如果一个 ScriptSupportEvent 对象在第 0 帧没有绑定一个事件，之后对该事件的绑定会无效
	SSE:registerEvent("UI.Show", function() end)
	SSE:registerEvent("UI.Hide", function() end)
	SSE:registerEvent("UI.Button.TouchBegin", function() end)
	SSE:registerEvent("UI.Button.Click", function() end)
	SSE:registerEvent("UI.LostFocus", function() end)
	
	uiSSEObjects[uiid] = SSE
	for i, listener in pairs(uiEvents) do
		if listener.uiId == uiid then
			listener.id = SSE:registerEvent(listener.msgStr, function(paprm)
				paprm["listener"] = listener
				useObjectId(paprm["eventobjid"])
				listener.callBack(paprm)
			end)
			uiEvents[i] = nil
		end
	end
end

--Event namespace
Event = {
	--自定义事件名，具体意义详见文档
	["EventName"] = {
		["ui"] = {
			["show"] = "UI.Show", --UI 界面显示时调用
			["hide"] = "UI.Hide", --UI 界面显示时调用
			["onPress"] = "UI.Button.TouchBegin", --按钮被按下时调用
			["onClick"] = "UI.Button.Click", --按钮被点击时调用
			["onInput"] = "UI.LostFocus", --玩家焦点离开输入框时（可以理解为玩家输入完毕）调用
		},
		["time"] = {
			["newTick"] = "Game.Run", --从 1 帧开始，每帧调用 1 次
		}
	}
}

--Listener class
Event.Listener = {
	msgStr, --string	事件的原始名，用于调用 API 时做参数
	callBack, --function	回调函数
	isUIEvent, --boolean	事件是否是 UI 事件， nil 表示不是
	uiId, --string	UI 事件所属 UI 界面 id
}

--处理回调并返回一个 Lister 对象
--@paprm eventname:string	事件名
--@paprm callback:function	回调函数
--@paprm uiid:string	UI 事件所属 UI 界面 id ，如果不是 UI 事件则为 nil
--@return 保存回调信息的 Lister 对象
function Event:connect(eventname, callback, uiid)
	--设置 object 的 msgStr, callBack 和 uiId 属性
	local object = setmetatable({}, Event.Listener)
	local func = loadstring('return Event["EventName"].'..eventname)
	if func then
		local pcallResult, msgStr = pcall(func)
		object.msgStr = pcallResult and msgStr or eventname
	else
		error("miniExtend - Event:connect() : bad argument #1 'eventname'")
	end
	object.callBack = callback
	--检查是否是 UI 事件，如果是，设置对象的 uiId 属性
	if string.sub(object.msgStr, 1, 2) == [[UI]] then
		object.isUIEvent = true
		object.uiId = uiid
	end

	--正式调用 API 开始绑定事件
	--如果是普通事件，直接调用 API 绑定
	if not object.isUIEvent then
		object.id = ScriptSupportEvent:registerEvent(object.msgStr, function(paprm)
			paprm["listener"] = object
			useObjectId(paprm["eventobjid"])
			object.callBack(paprm)
		end)
	else --如果是 UI 事件，那么使用使用对应的 UI 界面的 ScriptSupportEvent 对象，可能还要暂时储存
		local api = uiSSEObjects[uiid]
		if api then
			object.id = api:registerEvent(object.msgStr, function(paprm)
				paprm["listener"] = object
				useObjectId(paprm["eventobjid"])
				object.callBack(paprm)
			end)
		else
			table.insert(uiEvents, object)
		end
	end
	return object
end

--删除 Lister 对象
--@return nil
function Event.Listener:delete()
	if not self.isUIEvent then
		return ScriptSupportEvent:removeEvent(self.msgStr, self.id)
	else
		return uiSSEObjects[self.uiId]:removeEvent(self.msgStr, self.id)
	end
end

Event.Listener.__index = {
	["delete"] = Event.Listener.delete,
}
