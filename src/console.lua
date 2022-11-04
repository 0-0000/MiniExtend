--[=[
console.lua
在控制台输出日志
依赖于 core.lua
最后更新 : 0.1.0.1
]=]

local UI = UI

--Console namespace
Console = {}
_LUAG["Console"] = Console

--代替printtag函数，以 tag 为标签格式化输出日志
function Console:logtag(tag, ...)
	local str = {}
	for k, v in ipairs({...}) do
		str[k] = tostring(v)
	end
	printtag(tag, table.concat(str, "\t"))
end

--代替print函数，以 "global" 为默认标签格式化输出日志
function Console:log(...)
	Console:logtag("global", ...)
end

--代替warn函数，输出警告信息 message
function Console:warn(message)
	Console:logtag("warning", table.concat({"#cffd302", message, "#c000000"}))
end

--在控制台输出错误信息，输出错误信息 message ，该函数不会抛出运行错误
function Console:error(message)
	Console:logtag("error", table.concat({"#cfe0302", message, "#c000000"}))
end

--清空控制台输出的日志
function Console:clear()
	return UI:InitPrintData() == 0
end
