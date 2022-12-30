-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
object.lua
处理游戏对象
依赖于 core.lua
最后更新 : 3.0.0
]=]

--[=[
@function getObjectId() 返回当时 objid 的值
@function setObjectId(objectid) 设置 objid 的值
]=]

Env.__init__()

--[=[
objectIdNow 作为调用 MiniExtend 函数时默认的 objectid 参数
以下简称 objid
]=]
local objectIdNow = 0

-- 返回当时 objid 的值
-- 如果在延时调用中调用该函数是无法保证得到正确结果的
-- @return {interger} objid 的值
function getObjectId()
	return objectIdNow
end
-- 设置 objid 的值
-- @param objectid {interger} 设置的值
-- @return {boolean} true 表示成功，否则表示失败
function setObjectId(objectid)
	if type(objectid) == "number" then
		objectIdNow = objectid
		return true
	end
	return false
end
