-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
log.lua
用于日志的输出
依赖于 core.lua
最后更新 : 3.0.0
]=]

--[=[
@namespace Log
]=]

Env.__init__()

local UI = Env.indexAPI("UI")
local Print2Wnd, Print2WndWithTag, clear = UI.Print2Wnd, UI.Print2WndWithTag, UI.InitPrintData
local pairs, tostring, concat = pairs, tostring, table.concat
function print(...)
	Print2Wnd(UI, ...)
end

-- Log namespace
Log = {
	-- @static_function log(...) 在日志输出内容
	-- @static_function logtag(tag, ...) 在日志带标签地输出内容
	-- @static_function warn(message) 在日志输出警告信息 message
	-- @static_function error(message) 在日志输出错误信息 message
	-- @static_function clear() 清空日志
}; local Log = Log

-- 在日志输出内容，以 "global" 为标签格式化 ... 后输出到日志
-- 尝试遍历 ... 的所有参数，补足 nil ，但无法识别 ... 末尾的 nil 参数
-- 等价于 Log.logtag("global", ...) ，用于代替 print 函数
-- @param {all} ... 输出信息
-- @return {boolean} true: API 调用成功成功 false: API 调用出错
function Log.log(...)
	local str, ed = {}, 0
	for k, v in pairs({...}) do
		str[k], ed = tostring(v), k-1
	end
	for i = 1, ed do
		if not str[i] then str[i] = "nil" end
	end
	return Print2Wnd(UI, concat(str, "\t")) == 0
end
-- 在日志带标签地输出内容，以 "global" 为标签
-- 用于代替 printtag 函数
-- @param {string} tag 标签
-- @param {all} ... 输出信息
-- @return {boolean} true: API 调用成功成功 false: API 调用出错
function Log.logtag(tag, ...)
	local str, ed = {}, 0
	for k, v in pairs({...}) do
		str[k], ed = tostring(v), k-1
	end
	for i = 1, ed do
		if not str[i] then str[i] = "nil" end
	end
	return Print2WndWithTag(UI, tag, concat(str, "\t")) == 0
end
-- 在日志输出警告信息 message ，用于代替 warn 函数
-- @param {string} message 输出的警告信息
-- @return {boolean} true: API 调用成功成功 false: API 调用出错
function Log.warn(message)
	return Print2WndWithTag(UI, "warning", concat({"#cffd302", message, "#c000000"})) == 0
end
-- 在日志输出错误信息 message ，用于代替旧的 error 函数
-- 该函数不会抛出运行错误
-- @param {string} message 输出的错误信息
-- @return {boolean} true: API 调用成功成功 false: API 调用出错
function Log.error(message)
	return Print2WndWithTag(UI, "error", concat({"#cfe0302", message, "#c000000"})) == 0
end
-- 清空日志
-- 注意，该函数调用的 API 是不稳定的
-- 如果在清空后没有通过一些方式刷新日志，则信息似乎仍然会存在
-- @return {boolean} true: API 调用成功成功 false: API 调用出错
function Log.clear()
	return clear(UI) == 0
end
