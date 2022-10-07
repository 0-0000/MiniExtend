--[=[
object.lua
处理游戏对象
依赖于 core.lua
]=]
--objid 作为调用 miniExtend 函数时 objectId 参数的默认值
_G2["__objid"] = 0

--使用对象 id 作为默认对象参数
function useObjectId(objid)
	local t = type(objid)
	if t == "number" then
		_G2["__objid"] = objid
	elseif t == "table" and objid["eventobjid"] then
		_G2["__objid"] = objid["eventobjid"]
	end
end

--返回默认对象参数
function getObjectId()
	return _G2["__objid"]
end
