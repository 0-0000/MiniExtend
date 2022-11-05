--[=[
object.lua
处理游戏对象
依赖于 core.lua
最后更新 : 0.1.0.1
]=]
-- objid 作为调用 miniExtend 函数时 objectId 参数的默认值
_G2["__OBJID"] = 0

-- 使用对象 id 作为默认对象参数
function setObjectId(objid)
	local t = type(objid)
	if t == "number" then
		_G2["__OBJID"] = objid
	elseif t == "table" and type(objid["eventobjid"]) == "number" then
		_G2["__OBJID"] = objid["eventobjid"]
	end
end
_LUAG["setObjectId"] = setObjectId

-- 返回默认对象参数
function getObjectId()
	return _G2["__OBJID"]
end
_LUAG["getObjectId"] = getObjectId
