-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
core.lua
MiniExtend 的核心
最后更新 : 3.0.0
]=]

--[=[
@table genv 内部脚本环境
@table _G2 脚本共享表
@function loadstring2(string [, chuckname]) 类似 loadstring()
@function deepcopy(table) 深拷贝表
@namespace Env 脚本环境作用域
]=]

local debug = debug
local getinfo, getfenv, setfenv, getupvalue, setupvalue = debug.getinfo, debug.getfenv, debug.setfenv, debug.getupvalue, debug.setupvalue
local getmetatable, setmetatable, type, pairs = getmetatable, setmetatable, type, pairs

-- this 表示当前脚本函数
local this = getinfo(1, "f")["func"]
-- functionEnv 为当前脚本函数环境
local functionEnv = getfenv(this)
local functionEnv__index = getmetatable(functionEnv)["__index"]
-- 设置第 7 个上值 script_Fenv 的值以避免其访问 _GScriptFenv_
-- 注: 这会影响内部 API 运行的环境，导致 API 无法正常运行
-- setupvalue(functionEnv__index, 7, {})

-- genv 为游戏内部脚本环境，例如本函数的上一级函数的环境为 genv
local genv = getfenv(getinfo(2, "f")["func"])

-- _GScriptFenv_ 为脚本环境
local _GScriptFenv_ = functionEnv["_G"]
-- 修改 _GScriptFenv_ 元表，从而改变 _GScriptFenv_ 行为
local mt = getmetatable(_GScriptFenv_)
mt["__newindex"] = nil
local __index = mt["__index"]
setmetatable(_GScriptFenv_, nil)

-- 将 genv 作为全局变量方便其它脚本直接引用
_GScriptFenv_["genv"] = genv
-- 脚本环境作用域
_GScriptFenv_["Env"] = {
	-- @static_function __init__() 初始化脚本环境
	-- @static_function indexAPI(key) 获取游戏 API 对象
	-- @static_function index(key) 使用旧索引方法索引全局变量
}; local Env = _GScriptFenv_["Env"]

-- 初始化当前脚本环境，在每一脚本开头调用
-- 函数保证多次调用不会出错(不要这样做)
function Env.__init__()
	-- this 表示调用 initEnv 的函数
	-- 2 级为调用 initEnv 的函数
	local this = getinfo(2, "f")["func"]
	-- 将 _GScriptFenv_ 设为脚本环境
	setfenv(this, _GScriptFenv_)
end
-- 当前脚本初始化环境
debug.setfenv(this, _GScriptFenv_)
-- 由于把 initEnv 将环境设为 _GScriptFenv_ ，需使用该函数获取游戏 API 对象
-- 注意，函数会试图访问 _GScriptFenv_
-- @param key {string} API 名称
-- @return {table | nil} 获取成果返回获取到的 API 对象，否则返回 nil
function Env.indexAPI(key)
	if type(key) ~= "string" then return nil end
	return functionEnv__index(nil, key)
end

local _, _ScriptFenv_base_ = debug.getupvalue(__index, 1)
local _, _ScriptFenv_buffer_ = debug.getupvalue(__index, 2)
local _, _ScriptFenv_G_ = debug.getupvalue(__index, 3)
--local _, genv = debug.getupvalue(__index, 4)
-- _ScriptFenv_base_ 和 _ScriptFenv_buffer_ 的合集
local fenvBasic = {}
for k, v in pairs(_ScriptFenv_base_) do fenvBasic[k] = v end
for k, v in pairs(_ScriptFenv_buffer_) do fenvBasic[k] = v end

-- 使用旧索引方法索引全局变量，但不会索引 _GScriptFenv_
-- 如果你发现你以前能索引的函数现在无法索引，使用该函数
-- 除非你建议寻找其它函数替代你想找的函数
-- @param key {string} 全局变量名，相当于索引
-- @return {table | nil} 获取成果返回获取到的 API 对象，否则返回 nil
function Env.index(key)
	-- 如果 fenvBasic 包含那个值则返回
	-- 否则如果 _ScriptFenv_G_[key] 为 true ，返回 genv[key]
	-- 否则返回 _ScriptFenv_G_[key] ，即 nil
	return fenvBasic[key] or _ScriptFenv_G_[key] and genv[key]
end

-- 设置 _G2 表
_ScriptFenv_G_["_G2"], _GScriptFenv_["_G2"] = true, {}
genv["_G2"] = _GScriptFenv_["_G2"]

local basic, libs = {
	-- genv["_G"] == genv
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
	-- 需手动重定向，在 Log 中定义
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
_GScriptFenv_["_G"] = _GScriptFenv_

-- 自定义函数部分
local loadstring = loadstring
-- 同 loadstring() 函数，但函数环境为 _GScriptFenv_
-- 用于代替 LoadLuaScript 函数
-- 更多内容详见 loadstring() 函数
function loadstring2(string, chuckname)
	local func, errorMsg = loadstring(string, chuckname)
	if type(func) == "function" then setfenv(func, _GScriptFenv_) end
	return func, errorMsg
end
-- 深拷贝表，用于代替 copy_table 函数
-- @param table {table} 原始表
-- @return {table} 深拷贝后的表
function deepcopy(table)
	if type(table) ~= "table" then return nil end
	local new_table = {}
	for key, val in pairs(table) do
		local val_type = type(val)
		if type(val) ~= "table" then
			new_table[key] = val
		else
			new_table[key] = deepcopy(val)
		end
	end
	return new_table
end
