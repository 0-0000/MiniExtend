-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
event.lua
处理事件与回调
依赖于 core.lua, object.lua
最后更新 : 3.0.0
]=]

--[=[
@table *Register* 描述事件监听的一类表
@function registerEvent(eventname, callback [, uiid]) 监听游戏事件
@function cancelRegisterEvent(register) 取消监听游戏事件
]=]

Env.__init__()

--[=[
Register 是描述事件监听的表，用于删除监听
对 Register 表的修改可能导致出错
Register = {
	@value id {integer} 事件监听的 id
	@value uiId {string | nil} 如果是 UI 事件则为事件监听所属 UI 界面
	@value msgStr {string} API 事件名
	-- 对于需要预绑定的 UI 事件，该值不会在 registerEvent 后立即赋值
	-- 而是在相应的 UI 界面完成预绑定后才会被赋值

	-- 以下值用于内部使用，且描述预绑定信息(在正式绑定后值会被删除)
	-- @value callback {function} 事件监听的回调函数
	-- @value eventName {function} 事件名
}
]=]

local SSE = Env.indexAPI("ScriptSupportEvent")
local registerAPI, removeEvent = SSE.registerEvent, SSE.removeEvent
local getObjectId, setObjectId = getObjectId, setObjectId
local pairs, type, sub = pairs, type, string.sub
local setmetatable, error, pcall = setmetatable, error, pcall

-- uiSSEObjects 存储 UI 界面的 ScriptSupportEvent 对象，以 UI 界面 id 为索引
-- uiRegisters 存储预绑定的 UI 事件
local uiSSEObjects, uiRegisters = {}, {}
--[=[
UI 作用域中 ui_main 脚本将调用该函数
以来发送所属 UI 界面的 ScriptSupportEvent 对象并处理属于该 UI 界面预绑定的事件
]=]
_G2["__MiniExtend__sendSSEObject"] = function(uiid, SSE)
	uiSSEObjects[uiid] = SSE
	-- 用户在获取 register 后可能意外修改之从而导致这里出错
	for id, register in pairs(uiRegisters) do
		if register["uiId"] == uiid then
			local callback = register["callback"]
			local errorHead = table.concat("MiniExtend - Event [[", register["eventName"], "]] : run error!\n\terror message:")
			register["id"] = SSE:registerEvent(register["msgStr"], function(param)
				param["register"] = register
				local old_objid = getObjectId()
				setObjectId(param["eventobjid"])
				local result, errorMsg = pcall(callback, param)
				setObjectId(old_objid)
				if not result then
					error(errorHead..errorMsg)
				end
			end)
			-- 删除描述预绑定的信息
			register["callback"], register["eventName"] = nil, nil
			uiRegisters[id] = nil
		end
	end
end

--[=[
使用事件名 eventname 来确定回调函数要连接什么事件
既可以使用 MiniExtend 自定义事件名(Event.EventName)，也可以使用 API 事件名

如果 eventname 以 "$" 开头，则认为其为 MiniExtend 自定义事件名，否则为 API 事件名
如果为 MiniExtend 自定义事件名，则将 eventname 作为索引得到 msgStr
否则对于 API 事件， eventname 就是 msgStr
]=]
-- MiniExtend 自定义事件名
local CustomEvents = {
	["$ui.onShow"] = "UI.Show", -- UI 界面显示事件
	["$ui.onHide"] = "UI.Hide", -- UI 界面隐藏事件
	["$ui.onPress"] = "UI.Button.TouchBegin", -- 按钮按下事件
	["$ui.onClick"] = "UI.Button.Click", -- 按钮点击事件
	["$ui.onLostFocus"] = "UI.LostFocus", -- 输入框失去焦点事件
}

--[=[
注意，如果在第 0 帧没有通过 ScriptSupportEvent 绑定一类事件
则之后对同一类事件的绑定会无效
]=]
-- 监听游戏事件
-- @param {string} eventname 事件名
-- @param {function} callback 回调函数
-- @param {string | nil} uiid UI 事件所属 UI 界面 id ，如果不是 UI 事件则为 nil
-- @return {table<Register>} 事件监听的 Register 表，可用于删除监听
function registerEvent(eventname, callback, uiid)
	if type(eventname) ~= "string" or type(callback) ~= "function" then
		error("MiniExtend - registerEvent() : bad argument #1 or #2")
	end

	-- 解析 eventname 得到 msgStr
	local msgStr = sub(eventname, 1, 1) == "$" and CustomEvents[eventname] or eventname
	local register = {msgStr = msgStr}
	local isUIEvent = false
	-- 检查是否是 UI 事件，如果是则检验 uiid 参数
	if sub(msgStr, 1, 2) == [[UI]] then
		if type(uiid) == "string" then
			isUIEvent, register["uiId"] = true, uiid
		else
			error("MiniExtend - Event.Connecter:connect() : bad argument #3")
		end
	end

	-- 正式调用 API 开始绑定事件
	-- 如果是普通事件，直接通过 SSE 绑定
	if not isUIEvent then
		local errorHead = table.concat("MiniExtend - Event [[", eventname, "]] : run error!\n\terror message:")
		register["id"] = registerAPI(SSE, msgStr, function(param)
			param["register"] = register
			local old_objid = getObjectId()
			setObjectId(param["eventobjid"])
			local result, errorMsg = pcall(callback, param)
			setObjectId(old_objid)
			if not result then
				error(errorHead..errorMsg)
			end
		end)

	-- 如果是 UI 事件，那么使用使用对应的 UI 界面的 ScriptSupportEvent 对象绑定
	-- 如果对应的 ScriptSupportEvent 不存在，则将预存储在 uiRegisters 中
	else
		local api = uiSSEObjects[uiid]
		if api then
			local errorHead = table.concat("MiniExtend - Event [[", eventname, "]] : run error!\n\terror message:")
			register["id"] = api:registerEvent(msgStr, function(param)
				param["register"] = register
				local old_objid = getObjectId()
				setObjectId(param["eventobjid"])
				local result, errorMsg = pcall(callback, param)
				setObjectId(old_objid)
				if not result then
					error(errorHead..errorMsg)
				end
			end)
		else
			register["callback"]， register["eventName"] = callback, eventname
			table.insert(uiRegisters, register)
		end
	end
	return register
end

-- 取消游戏事件的监听
-- @param register {table<Register>} 事件监听的 Register 表
function cancelRegisterEvent(register)
	local uiId = register["uiId"]
	if uiId then
		return uiSSEObjects[uiId]:removeEvent(register["msgStr"], register["id"])
	end
	removeEvent(SSE, register["msgStr"], register["id"])
end
