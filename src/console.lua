-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
console.lua
在控制台输出日志
依赖于 core.lua
最后更新 : 2.1.0
]=]

local UI, clear, printtag = UI, UI.InitPrintData, printtag
local pairs, tostring, concat = pairs, tostring, table.concat

--Console namespace
Console = {
	-- @static_function log(...) 在日志以 "global" 为标签格式化输出日志信息 ...
	-- @static_function logtag(tag, ...) 在日志以 tag 为标签格式化输出日志信息 ...
	-- @static_function warn(message) 在日志输出警告信息 message
	-- @static_function error(message) 在日志输出错误信息 message
	-- @static_function clear() 清空日志
}; local Console = Console

--代替 print 函数，以 "global" 标签格式化输出日志，等价于 Console:logtag("global", ...)
-- @param {all} ... 输出信息
function Console:log(...)
	local str, ed = {}, 0
	for k, v in pairs({...}) do
		str[k], ed = tostring(v), k-1
	end
	for i = 1, ed do
		if not str[i] then str[i] = "nil" end
	end
	printtag("global", concat(str, "\t"))
end
-- 代替 printtag 函数，以 tag 为标签格式化输出日志
-- @param {string} tag 标签
-- @param {all} ... 输出信息
function Console:logtag(tag, ...)
	local str, ed = {}, 0
	for k, v in pairs({...}) do
		str[k], ed = tostring(v), k-1
	end
	for i = 1, ed do
		if not str[i] then str[i] = "nil" end
	end
	printtag(tag, concat(str, "\t"))
end
-- 代替 warn 函数，输出警告信息 message
-- @param {string} message 输出的警告信息
function Console:warn(message)
	printtag("warning", concat({"#cffd302", message, "#c000000"}))
end
-- 在控制台输出错误信息 message ，该函数不会抛出运行错误
-- @param {string} message 输出的错误信息
function Console:error(message)
	printtag("error", concat({"#cfe0302", message, "#c000000"}))
end
-- 清空控制台输出的日志
-- @return {boolean} true: API 调用成功成功 false: API 调用出错
function Console:clear()
	return clear(UI) == 0
end
