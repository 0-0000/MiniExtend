-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
time.lua
允许安排脚本异步运行
依赖于 core.lua
最后更新 : 3.0.0
]=]

--[=[
@function getTick() 获取当前游戏帧的帧数
@function scheduleCall(waittick, func, ...) 延时调用函数
@function nextTick(func, ...) 在下一帧调用函数
@function cancelScheduleCall(id) 取消延时调用
@class Timer 计时器类
]=]

Env.__init__()

local type, insert, max, floor = type, table.insert, math.max, math.floor
local setmetatable, clock = setmetatable, os.clock
local pairs, ipairs, pcall, unpack = pairs, ipairs, pcall, unpack

-- tick 表示当前游戏帧的帧数，参见 wiki 定义
local tick = 0
-- 获取当前游戏帧的帧数
-- @return {integer} 当前游戏帧的帧数
function getTick()
	return tick
end

local scheduleCalls = {
	--[=[
	call = {
		[1] = tick,
		[2] = func,
		[3] = param
	}
	--]=]
}
local scheduleCallId = 0
-- 延时调用函数
-- @paprm {integer} waittick 等待调用的帧数
-- @param {function} func 要调用的函数
-- @param {all} ... 调用函数时传递的参数
-- @return {integer | boolean} 成功返回延时调用的 id ，否则返回 false
function scheduleCall(waittick, func, ...)
	if type(func) == "function" and type(waittick) == "number" then
		waittick = max(floor(waittick), 1)
		scheduleCallId = scheduleCallId + 1
		scheduleCalls[scheduleCallId] = {
			waittick, func, {...}
		}
		return scheduleCallId
	end
	return false
end
-- 在1帧后调用函数，等价于 scheduleCall(1, func, ...)
-- @param {function} func 要调用的函数
-- @param {all} ... 调用函数时传递的参数
-- @return {integer | boolean} 成功返回延时调用的 id ，否则返回 false
function nextTick(func, ...)
	if type(func) == "function" then
		scheduleCallId = scheduleCallId + 1
		scheduleCalls[scheduleCallId] = {
			1, func, {...}
		}
		return scheduleCallId
	end
	return false
end
-- 取消延时调用
-- @param id {integer} 延时调用的 id
-- @return {boolean} 成功返回 true ，否则返回 false
function cancelScheduleCall(id)
	if type(id) == "number" and 0 < id and id <= scheduleCallId then
		id = floor(id)
		if scheduleCalls[id] then
			scheduleCalls[id] = nil
			return true
		end
	end
	return false
end

-- Timer class
--[=[
Timer 对象包含两种状态: 运行和暂停，默认为暂停
运行时对象的 tick 成员会随着新的游戏帧而增加，且每帧都将 delay 减 1 。
当 delay 为 0 时就会先重置 delay 为 1 ，然后调用 callback 。
反之，如果暂停， tick 就不会增加， callback 也不会被调用
--]=]
Timer = {
	-- @member {number} createTime 对象创建时的 CPU 时间
	-- @member {integer} id 等同于对象在 Time.Timers 中的索引
	-- @member {boolean} running true: 计时器运行 false: 计时器暂停
	-- @member {integer} tick 对象创建以来计时器运行的游戏帧数

	-- 可写成员变量:
	--[=[
	@member {integer} delay 下一次调用 callback 的间隔帧数，默认为 1
		不影响 tick 的递增，在计时器暂停时 delay 不会减少
	@member {function | nil} callback 在 delay 降至 0 时调用该函数
	传递两个参数: self 和 tick
		@param {table<Timer>} self 表示所属 Timer 对象
		@param {integer} tick 表示当前游戏帧数，等同于 Time:getTick()
	--]=]

	-- @constructor Timer:new()
	-- @destructor delete() 删除计时器
	-- @method start() 启动计时器(将 running 设为 true)
	-- @method pause() 暂停计时器(将 running 设为 false)
	-- @method isRunning() 返回计时器是否在运行
}; local Timer = Timer
-- 存储 Timer 对象
local Timers = {}
local lastTimerId = 0
-- 构造 Timer 对象
-- @return {table<Timer>} 一个暂停的 Timer 对象
function Timer:new()
	local object = setmetatable({}, Timer)
	object.createTime = clock()
	object.tick, object.delay, object.running = 0, 1, false
	lastTimerId = lastTimerId + 1
	object.id = lastTimerId
	Timers[lastTimerId] = object
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

return function()
	tick = tick + 1
	-- 刷新延时调用状态
	local thisTickCalls = {}
	for id, call in pairs(scheduleCalls) do
		local waitTick = call[1]
		if waitTick == 1 then
			insert(thisTickCalls, call)
			scheduleCalls[id] = nil
		else
			calls[1] = waitTick - 1
		end
	end

	-- 延时调用
	for _, call in ipairs(thisTickCalls) do
		local param, lastIndex = call[3], 1
		for thisIndex, v in pairs(param) do
			for i = lastIndex, thisIndex - 1 do
				-- 填充 nil 以避免 unpack 在遇到表中间的 nil 时意外终止
				param[i] = nil
			end
			lastIndex = thisIndex + 1
		end
		pcall(call[2], unpack(param))
	end

	-- 运行计时器
	for id, timer in pairs(Timers) do
		if timer.running then
			timer.tick = timer.tick + 1
			timer.delay = timer.delay - 1
			if timer.delay <= 0 then
				timer.delay = 1
				pcall(timer.callback, timer, tick)
			end
		end
	end
end
