-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
core.lua
MiniExtend 的核心脚本
最后更新 : 2.0.0
]=]

-- _GScriptFenv_ 为脚本环境
-- loadstring2() （或 LoadLuaScript()）返回的函数运行时的环境也为 _GScriptFenv_
-- 注：经检验， _GScriptFenv_ 不含 _G 键，为什么能访问 _G 的原因未知
local _GScriptFenv_ = _G
local mt = getmetatable(_GScriptFenv_)
mt["__newindex"] = nil
local __index = mt["__index"]

local _, _ScriptFenv_base_ = debug.getupvalue(__index, 1)
local _, _ScriptFenv_buffer_ = debug.getupvalue(__index, 2)
local _, _ScriptFenv_G_ = debug.getupvalue(__index, 3)
-- genv 为游戏内部脚本环境，例如 loadstring() 返回的函数运行时的环境为 genv
-- 将 genv 作为全局变量方便其它脚本直接引用
_, genv = debug.getupvalue(__index, 4)
local genv = genv

local basic, libs = {
	-- 这个 _G 并非脚本环境 _GScriptFenv_ ，实际等同于 genv
	-- "_G",
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
	-- 使用 genv 作为环境
	"loadstring",
	"module",
	"next",
	"pairs",
	"pcall",
	-- 游戏内部脚本会使用该函数在日志输出错误，修改会导致无法在日志输出错误
	-- "print",
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
	_GScriptFenv_[v] = genv[v]
end
for k, v in pairs(libs) do
	_GScriptFenv_[v] = genv[v]
end

-- 设置 _G2 表，该表在被创建后所有脚本都可直接引用
_ScriptFenv_G_["_G2"], _G2 = true, {}
genv["_G2"]= _G2

-- 等价于 loadstring() ，但该函数使用 _GScriptFenv_ 作为环境
loadstring2 = genv["LoadLuaScript"]
-- 返回源表的深拷贝
-- @param {table} table 源表
-- @return {table} 深拷贝后得到的表
deepcopy = genv["copy_table"]
-- 存储游戏 API 对象，用于解决 API 与 MiniExtend 的命名冲突
-- 例如可以使用 GameVM.UI 来访问 UI API 而不是 MiniExtend UI 作用域
GameVM = genv["GameVM"]

-- 修改 _GScriptFenv_ 元表的 __index 函数
isTypeError = _ScriptFenv_base_["isTypeError"]
print = _ScriptFenv_buffer_["print"]
printtag = _ScriptFenv_buffer_["printtag"]
print_console = _ScriptFenv_buffer_["print_console"]
warn = _ScriptFenv_buffer_["warn"]
-- error = _ScriptFenv_buffer_["error"]
mt["__index"] = function(_, k)
	return _ScriptFenv_G_[k] and genv[k]
end
