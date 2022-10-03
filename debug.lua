--[=[
debug.lua
用于调试
依赖于 core.lua
该脚本不是必须的，在正式发布游戏前应取消其执行
]=]

--获取 func 的参数
--@paprm func:function	要获取参数的函数
--@return func 参数名称表
function getFunctionParameter(func)
	if type(func) ~= "function" then error() end
	local _hook, _mask, _count = debug.gethook() --获取之前的钩子，用于恢复原有的钩子
	local parameters = {} --存储 func 参数
	debug.sethook(function()
		--level0:debug.getinfo 或者 debug.getlocal
		--level1:钩子函数
		--level2:触发钩子的函数，期望为 func ，应在这一级获取参数
		--level3:期望为 pcall
		--level4:期望为 getFunctionParameter ，应在这一级判断 func 是否在 level2
		if debug.getinfo(4, "n")["name"] == "getFunctionParameter" then
			local i = 1
			while true do
				local name = debug.getlocal(2, i) --获取第 i 个局部变量名
				if string.sub(name, 1, 1) == "(" then --该变量是内部变量，说明之后没有形参了
					break
				end
				table.insert(parameters, name)
				i = i + 1
			end
		end
	end, "c") --调用函数时触发钩子
	pcall(func) --安全调用 func 其中 pcall 和 func 都会触发钩子
	debug.sethook(_hook, _mask, _count) --恢复钩子
	return parameters
end
