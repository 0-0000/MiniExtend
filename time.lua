--[=[
time.lua
支持延时调用和获取一些时间信息
依赖于 core.lua, object.lua, event.lua
--]=]

--[=[
tick 表示游戏帧，帧是游戏的基本单位
当一个事件发生时，通常（目前可以认为是总是）要等到下一帧才能回调
延续性事件，如玩家挖掘方块这个事件，每一帧回调一次
游戏开始是第 0 帧，第 0 帧主要初始化游戏
之后帧数每隔约 0.05s 递增，但不一定是 0.05s ，只能说平均每帧 0.05s
--]=]
local tick = 0
function getTick()
	return tick
end

--scheduleCalls 表示延时调用列表，以延时的帧数 t(t>1) 为索引存储在 t 帧后调用的所有函数及参数
--nextTickCalls 同 scheduleCalls ，但存储下1帧的 (t=0)
local scheduleCalls, nextTickCalls = {}, {}

--延时调用函数
--@paprm ticks:number	要在几帧后调用
--@paprm func:function	要调用的函数
--@paprm ...	调用函数时传递的参数
function scheduleCall(ticks, func, ...)
	if type(func) == "function" then
		ticks = math.max(math.floor(ticks), 1)
		if ticks ~= 1 then
			scheduleCalls[ticks] = scheduleCalls[ticks] or {}
			table.insert(scheduleCalls[ticks], {
				func,
				{...}
			})
		else
			table.insert(nextTickCalls, {
				func,
				{...}
			})
		end
	else
		
	end
end

--在1帧后调用函数，等价于 scheduleCall(1, func, ...)
function nextTick(func, ...)
	if type(func) == "function" then
		table.insert(nextTickCalls, {
			func,
			{...}
		})
	end
end

return function()
	tick = tick + 1
	local thisTickCalls = nextTickCalls
	nextTickCalls = {}
	local scheduleCalls2 = scheduleCalls
	scheduleCalls = {}
	for ticks, calls in pairs(scheduleCalls2) do
		if ticks ~= 1 then
			scheduleCalls[ticks-1] = calls
		else
			nextTickCalls = calls
		end
	end
	for _, call in ipairs(thisTickCalls) do
		call[1](unpack(call[2]))
	end
end
