--0.6.1.9

_Actor = Actor

--Actor namespace
Actor = {
	["ActorType"] = {
		["Player"] = 1,
		["Creature"] = 2,
		["DropItem"] = 3,
		["Missile"] = 4
	},
	["DamageType"] = {
		["Melee"] = 0,
		["Remote"] = 1,
		["Bomb"] = 2,
		["Physics"] = 3,
		["Burning"] = 3,
		["Toxin"] = 4,
		["Wither"] = 5,
		["Magic"] = 6,
		["Sun"] = 6,
		["Fall"] = 7,
		["Anvil"] = 8,
		["Cactus"] = 9,
		["Asphyxia"] = 10,
		["Drown"] = 11,
		["Suffocate"] = 12,
		["AntiInjury"] = 13,
		["Laser"] = 14,
	}
}

--此函数返回一个 Actor 对象
--@paprm objid 对象的 id
--@return 得到的 Actor 对象
function Actor:new(objid)
	local actor = setmetatable({}, Actor)
	actor.objid = objid
	return actor
end; setmetatable(Actor, {__call = Actor.new})
--杀死对象
--@return 成功返回 true ，否则返回 false
function Actor:kill()
	return Actor:killSelf(self.objid) == 0
end

--此函数返回对象的类型
--@return 对象的类型，失败返回 false
function Actor:getType()
	local result, objtype = _Actor:getObjType(self.objid)
	if result == 0 then
		return objtype
	else
		return false
	end
end
--判断对象是否是玩家
--@return 如果是，返回 true ，否则返回 false
function Actor:isPlayer()
	return _Actor:isPlayer(self.objid) == 0
end
--判断对象是否是生物
--@return 如果是，返回 true ，否则返回 false
function Actor:isCreature()
	return self:getType() == Actor.Creature
end
--判断对象是否是怪物
--@return 如果是，返回 true ，否则返回 false
function Actor:isMob()
	return _Actor:isMob(self.objid) == 0
end
--判断对象是否是掉落物
--@return 如果是，返回 true ，否则返回 false
function Actor:isDropItem()
	return self:getType() == Actor.DropItem
end
--判断对象是否是投掷物
--@return 如果是，返回 true ，否则返回 false
function Actor:isMissile()
	return self:getType() == Actor.Missile
end

--返回对象位置
--@return 对象的位置 (x, y, z) ，失败返回 false
function Actor:getPosition()
	local result, x, y, z = _Actor:getPosition(self.objid)
	return (result == 0) and x, y, z
end
--设置对象位置
--@paprm x 对象的 x 坐标，也可以是包含 x, y, z 键的表，此时无需 y, z 参数
--@paprm y, z 对象的 y, z 坐标
--@return 成功返回 true ，否则返回 false
function Actor:getPosition(x, y, z)
	if type(x) == "table" then
		y = x["y"]; z = x["z"]; x = x["x"]
	end
	return _Actor:setPosition(self.objid, x, y, z) == 0
end
--判断对象是否在空中
--@return 如果是，返回 true ，否则返回 false
function Actor:isInAir()
	return _Actor:isInAir(self.objid) == 0
end

--返回对象的原地旋转偏移角度
--@return 对象的原地旋转偏移角度，失败返回 false
function Actor:getFaceYaw()
	local result, yaw = _Actor:getFaceYaw(self.objid)
	return (result == 0) and yaw
end
--设置对象的原地旋转偏移角度
--@paprm yaw 原地旋转偏移角度
--@return 成功返回 true ，失败返回 false
function Actor:setFaceYaw(yaw)
	return _Actor:setFaceYaw(self.objid, yaw) == 0
end
--转动对象的原地旋转偏移角度
--@paprm yaw 转动角度
--@return 成功返回 true ，失败返回 false
function Actor:turnFaceYaw(yaw)
	return _Actor:turnFaceYaw(self.objid, yaw) == 0
end

--返回对象的视角仰望偏移角度
--@return 对象的原地旋转偏移角度，失败返回 false
function Actor:getFacePitch()
	local result, pitch = _Actor:getFacePitch(self.objid)
	return (result == 0) and pitch
end
--设置对象的视角仰望偏移角度
--@paprm pitch 视角仰望角度
--@return 成功返回 true ，失败返回 false
function Actor:setFaceYaw(pitch)
	return _Actor:setFacePitch(self.objid, pitch) == 0
end
--转动对象的视角仰望偏移角度
--@paprm pitch 转动角度
--@return 成功返回 true ，失败返回 false
function Actor:turnFaceYaw(pitch)
	return _Actor:turnFacePitch(self.objid, pitch) == 0
end

--设置对象攻击伤害类型（对掉落物无效果）
--@paprm damagetype 伤害类型
--@return 成功返回 true ，失败返回 false
function Actor:setAttackType(damagetype)
	return _Actor:setAttackType(self.objid, damagetype) == 0
end
--设置对象免疫伤害类型（对投掷物，掉落物无效果）
--@paprm damagetype 免疫伤害类型
--@isadd diable 如果为 true ，使对象免疫该类型伤害，否则使对象失去免疫
--@return 成功返回 true ，失败返回 false
function Actor:setImmuneType(damagetype, disable)
	return _Actor:setImmuneType(self.objid, damagetype, disable) == 0
end