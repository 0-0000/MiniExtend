-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
event.lua
处理回调
依赖于 core.lua, object.lua
最后更新 : 2.0.0
]=]
--[=[
使用事件名 eventname 来确定回调函数要连接什么事件
既可以使用 MiniExtend 自定义事件名(Event.EventName)，也可以使用 API 事件名

如果 eventname 以 "$" 开头，则认为其为 MiniExtend 自定义事件名，否则为 API 事件名
如果为 MiniExtend 自定义事件名，则将 eventname 作为索引得到 msgStr
否则对于 API 事件， eventname 就是 msgStr
]=]

local ScriptSupportEvent = ScriptSupportEvent
local registerEvent = ScriptSupportEvent.registerEvent
local removeEvent = ScriptSupportEvent.removeEvent
local setObjectId = setObjectId
local pairs, type, sub = pairs, type, string.sub

-- uiSSEObjects 存储 UI 界面的 ScriptSupportEvent 对象，以 UI 界面 id 为索引
-- uiEvents 暂时存储还不能绑定的 UI 事件
local uiSSEObjects, uiConnects = {}, {}
-- UI 作用域中 ui_main 脚本将调用 __CONNECT 来处理属于该 UI 界面的事件
_G2["__CONNECT"] = function(uiid, SSE)
	--如果一个 ScriptSupportEvent 对象在第 0 帧没有绑定一个事件，之后对该事件的绑定会无效
	SSE:registerEvent("UI.Show", function() end)
	SSE:registerEvent("UI.Hide", function() end)
	SSE:registerEvent("UI.Button.TouchBegin", function() end)
	SSE:registerEvent("UI.Button.Click", function() end)
	SSE:registerEvent("UI.LostFocus", function() end)

	uiSSEObjects[uiid] = SSE
	for i, connecter in pairs(uiConnects) do
		if connecter.uiId == uiid then
			connecter.id = SSE:registerEvent(connecter.msgStr, function(param)
				param["connecter"] = connecter
				setObjectId(param["eventobjid"])
				connecter.callback(param)
			end)
			uiConnects[i] = nil
		end
	end
end

-- Event namespace
Event = {
	-- MiniExtend 自定义事件名
	["CustomEvents"] = {
		["$ui.onShow"] = "UI.Show", -- UI 界面显示时调用
		["$ui.onHide"] = "UI.Hide", -- UI 界面显示时调用
		["$ui.onPress"] = "UI.Button.TouchBegin", -- 按钮被按下时调用
		["$ui.onClick"] = "UI.Button.Click", -- 按钮被点击时调用
		["$ui.onLostFocus"] = "UI.LostFocus", -- 玩家焦点离开输入框时调用
	}

	-- @class Connecter 事件连接类
}; local Event = Event
local CustomEvents = Event.CustomEvents

-- Connecter class
Event.Connecter = {
	-- @member {string} eventName 事件名，等于构造是传递的 eventname 参数
	-- @member {string} msgStr 事件的原始名，用于调用 API 时做参数
	-- @member {boolean | nil} isUIEvent
	-- true: 事件是 UI 事件 nil: 事件不是 UI 事件
	-- @member {string | nil} uiId 如果事件为 UI 事件，表示所属 UI 界面 id

	-- 可写成员变量:
	-- @member {function} callBack 事件发生时调用的函数

	-- @constructor Event.Connecter:new(eventname, callback, uiid)
	-- @destructor delete() 取消事件连接
}; local Connecter = Event.Connecter

-- 构造一个 Connecter 对象，监听游戏事件
-- @param {string} eventname 事件名
-- @param {function} callback 回调函数
-- @param {string | nil} uiid UI 事件所属 UI 界面 id ，如果不是 UI 事件则为 nil
-- @return 构造的 Connecter 对象
local setmetatable, loadstring, pcall, error = setmetatable, loadstring, pcall, error
function Connecter:new(eventname, callback, uiid)
	if type(eventname) ~= "string" or type(callback) ~= "function" then
		error("MiniExtend - Event.Connecter:connect() : bad argument #1 or #2")
	end

	-- 解析 eventname 得到 msgStr
	local object, msgStr = setmetatable({}, Connecter)
	local msgStr = sub(eventname, 1, 1) == "$" and CustomEvents[eventname] or eventname
	object.eventName = eventname
	object.msgStr = msgStr
	object.callback = callback

	-- 检查是否是 UI 事件，如果是则设置对象的 isUIEvent 和 uiId 属性
	if sub(object.msgStr, 1, 2) == [[UI]] then
		object.isUIEvent = true
		if type(uiid) == "string" then
			object.uiId = uiid
		else
			error("MiniExtend - Event.Connecter:connect() : bad argument #3")
		end
	end

	-- 正式调用 API 开始绑定事件
	-- 如果是普通事件，直接调用 API 绑定
	if not object.isUIEvent then
		object.id = registerEvent(ScriptSupportEvent, object.msgStr, function(param)
			param["connecter"] = object
			setObjectId(param["eventobjid"])
			object.callback(param)
		end)

	-- 如果是 UI 事件，那么使用使用对应的 UI 界面的 ScriptSupportEvent 对象绑定
	-- 如果对应的 ScriptSupportEvent 不存在，将绑定存储在 uiConnects 中
	else
		if api then
			object.id = api:registerEvent(object.msgStr, function(param)
				param["connecter"] = object
				setObjectId(param["eventobjid"])
				object.callback(param)
			end)
		else
			table.insert(uiConnects, object)
		end
	end

	return object
end

-- 删除 Connecter 对象
function Connecter:delete()
	if self.isUIEvent then
		return uiSSEObjects[self.uiId]:removeEvent(self.msgStr, self.id)
	end
	removeEvent(ScriptSupportEvent, self.msgStr, self.id)
end

Connecter.__index = {
	["delete"] = Connecter.delete,
}
