-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
time.lua
允许安排脚本运行时机
最后更新 : 2.1.0
]=]

local type, insert = type, table.insert

-- Time namespace
Time = {
	--[=[
	tick 表示游戏帧，帧是游戏的基本单位
	当一个事件发生时，通常（目前可以认为是总是）要等到下一帧才能回调
	延续性事件，如玩家挖掘方块这个事件，每一帧回调一次
	游戏开始是第 0 帧，第 0 帧主要初始化游戏
	之后帧数每隔约 0.05s 递增，但不一定是 0.05s ，只能说平均每帧 0.05s
	--]=]
	tick = 0,
	-- 延时调用列表，以延时的帧数 t(t>1) 为索引存储在 t 帧后调用的所有函数及参数
	scheduleCalls = {},
	-- 存储下1帧的调用列表(t=0)
	nextTickCalls = {},
	-- 最后一个 Timer 对象的 id
	id = 0,
	-- 维护 Timer 对象
	Timers = {}

	-- @static_function getTick() 返回游戏帧(Time.tick)
	-- @static_function scheduleCall(ticks, func, ...) 延时调用函数
	-- @static_function getTick(func, ...) 等价于 scheduleCall(1, func, ...)
	-- @class Timer 计时器类
}; local Time = Time
local Timers = Time.Timers
-- 获取游戏帧
-- @return {integer} 游戏帧，即 Time.tick
function Time:getTick()
	return Time.tick
end

--延时调用函数
-- @paprm {integer} ticks 等待调用的帧数
-- @param {function} func 要调用的函数
-- @param {all} ... 调用函数时传递的参数
-- @return {boolean} 成功(ticks 和 func 类型正确)返回 true ，否则返回 false
local max, floor = math.max, math.floor
function Time:scheduleCall(ticks, func, ...)
	if type(func) == "function" and type(ticks) == "number" then
		ticks = max(floor(ticks), 1)
		if ticks ~= 1 then
			Time.scheduleCalls[ticks] = Time.scheduleCalls[ticks] or {}
			insert(Time.scheduleCalls[ticks], {
				func,
				{...}
			})
		else
			insert(Time.nextTickCalls, {
				func,
				{...}
			})
		end
	end
	return false
end

-- 在1帧后调用函数，等价于 scheduleCall(1, func, ...)
-- @param {function} func 要调用的函数
-- @param {all} ... 调用函数时传递的参数
-- @return {boolean} 成功(ticks 和 func 类型正确)返回 true ，否则返回 false
function Time:nextTick(func, ...)
	if type(func) == "function" then
		insert(Time.nextTickCalls, {
			func,
			{...}
		})
	end
end

-- Timer class
--[=[
Timer 对象包含两种状态: 运行和暂停，默认为暂停
运行时对象的 tick 成员会随着新的游戏帧而增加，且每帧都将 delay 减 1 。
当 delay 为 0 时就会先重置 delay 为 1 ，然后调用 callback 。
反之，如果暂停， tick 就不会增加， callback 也不会被调用
--]=]
Time.Timer = {
	-- @member {number} createTime 对象创建时的 CPU 时间
	-- @member {integer} id 等同于对象在 Time.Timers 中的索引
	-- @member {boolean} running true: 计时器运行 false: 计时器暂停
	-- @member {integer} tick 对象创建以来计时器运行的游戏帧数

	-- 可写成员变量:
	--[=[
	@member {integer} delay 下一次调用 callback 的间隔帧数，默认为 1
		不影响 tick 的递增，在计时器暂停时 delay 不会减少
	@member {function | nil} callback 如果计时器未暂停，每帧都调用该函数
	传递两个参数: self 和 tick
		@param {table<Timer>} self 表示所属 Timer 对象
		@param {integer} tick 表示当前游戏帧数，等同于 Time:getTick()
	--]=]

	-- @constructor Time.Timer:new()
	-- @destructor delete() 删除计时器
	-- @method start() 启动计时器(将 running 设为 true)
	-- @method pause() 暂停计时器(将 running 设为 false)
	-- @method isRunning() 返回计时器是否在运行
}; local Timer = Time.Timer
-- 构造 Timer 对象
-- @return {table<Timer>} 一个暂停的 Timer 对象
local setmetatable, clock = setmetatable, os.clock
function Timer:new()
	local object = setmetatable({}, Timer)
	object.createTime = clock()
	object.tick, object.delay, object.running = 0, 1, false
	local id = Time.id + 1
	object.id, Time.id = id, id
	Timers[id] = object
	return object
end
-- 删除 Timer 对象
function Timer:delete()
	Timers[self.id] = nil
end

-- 启动计时器
-- @return {boolean} 如果有效调用(调用前计时器暂停)，返回 true ，否则返回 false
function Timer:start()
	if self.running then return false end
	self.running = true
	return true
end
-- 暂停计时器
-- @return {boolean} 如果有效调用(调用前计时器运行)，返回 true ，否则返回 false
function Timer:pause()
	if self.running then
		self.running = false
		return true
	end
	return false
end
-- 返回计时器是否在运行
-- @return {boolean} true: 计时器运行 false: 计时器暂停
function Timer:isRunning()
	return self.running
end
Timer.__index = {
	["delete"] = Timer.delete,
	["start"] = Timer.start,
	["pause"] = Timer.pause,
}

local pairs, ipairs, pcall, unpack = pairs, ipairs, pcall, unpack
return function()
	local tick = Time.tick + 1
	Time.tick = tick
	local thisTickCalls, tempScheduleCalls = Time.nextTickCalls, Time.scheduleCalls
	Time.nextTickCalls, Time.scheduleCalls = {}, {}
	for tick, calls in pairs(tempScheduleCalls) do
		if tick ~= 2 then
			Time.scheduleCalls[tick-1] = calls
		else
			Time.nextTickCalls = calls
		end
	end

	for _, call in ipairs(thisTickCalls) do
		pcall(call[1], unpack(call[2]))
	end

	for id, timer in pairs(Timers) do
		if timer.running then
			timer.tick = timer.tick + 1
			timer.delay = timer.delay - 1
			if timer.delay <= 0 then
				timer.delay = 1
				if type(timer.callback) == "function" then
					pcall(timer.callback, timer, tick)
				end
			end
		end
	end
end
