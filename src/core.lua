--[=[
core.lua
miniExtend 的核心脚本
]=]

local mt = getmetatable(_G)
mt["__newindex"] = nil
local __index = mt["__index"]

local _, _ScriptFenv_base_ = debug.getupvalue(__index, 1)
local _, _ScriptFenv_buffer_ = debug.getupvalue(__index, 2)
local _, _ScriptFenv_G_ = debug.getupvalue(__index, 3)
--将 genv 作为全局变量方便其它脚本直接引用
_, genv = debug.getupvalue(__index, 4) 

local basic, libs = {
	--这个 _G 并非 lua 环境，实际等同于 genv
	--"_G",
	"_VERSION",
	"assert",
	"collectgarbage",
	"dofile",
	"error",
	"getfenv",
	"getmetatable",
	"ipairs",
	"load",
	"loadfile",
	"loadstring",
	"module",
	"next",
	"pairs",
	"pcall",
	--该函数被用于在控制台输出错误
	--"print",
	"rawequal",
	"rawget",
	"rawset",
	"require",
	"select",
	"setfenv",
	"setmetatable",
	"tonumber",
	"tostring",
	"type",
	"unpack",
	"xpcall"
}, {
	"coroutine",
	"debug",
	"io",
	"math",
	"os",
	"package",
	"string",
	"table"
}
for k, v in pairs(basic) do
	_G[v] = genv[v]
end
for k, v in pairs(libs) do
	_G[v] = genv[v]
end

--设置 _G2 表，该表在被创建后所有脚本都可直接引用
_ScriptFenv_G_["_G2"] = true
genv["_G2"] = {}
_G2 = genv["_G2"]

isTypeError = _ScriptFenv_base_["isTypeError"]
print = _ScriptFenv_buffer_["print"]
loadstring2 = genv["LoadLuaScript"]
--因为脚本支持直接调用这些函数，所以保留它们，不建议使用这些函数
printtag = _ScriptFenv_buffer_["printtag"]
warn = _ScriptFenv_buffer_["warn"]
print_console = _ScriptFenv_buffer_["print_console"]
