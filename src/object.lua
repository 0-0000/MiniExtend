-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
object.lua
处理游戏对象
依赖于 core.lua
最后更新 : 2.0.0
]=]

local type, _G2 = type, _G2

-- 以下简称其为 objid ， objid 作为调用 MiniExtend 函数时 objectid 参数的默认值
_G2["__OBJID"] = 0
-- 返回默认对象参数
-- @return {integer} objid 的值
function getObjectId()
	return _G2["__OBJID"]
end
-- 使用 objid 作为默认对象参数
-- @param {integer| table} objectid
-- 如果 objectid 类型为 number ，直接设置 objid 为 objectid
-- 如果 obectid 类型为 table 且 objectid["eventobjid"] 类型为 number ，\
-- 直接设置 objid 为 objectid["eventobjid"]
function setObjectId(objectid)
	local t = type(objectid)
	if t == "number" then
		_G2["__OBJID"] = objectid
	elseif t == "table" and type(objectid["eventobjid"]) == "number" then
		_G2["__OBJID"] = objectid["eventobjid"]
	end
end
