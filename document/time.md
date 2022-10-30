# miniExtend Time #
对应源文件： `time.lua` 。  
## `getTick()` 函数 ##
- 函数返回当前是第几[游戏帧](./document.html#tick)。
- 只要你立即游戏帧的含义，该函数很容易理解。
## `scheduleCall(ticks, func, ...)` 函数 ##
- 在 `ticks` 游戏帧后以 `...` 为参数调用函数 `func` 。  
- `ticks` 类型为 `number` 的正整数，会被设置为 `math.max(math.floor(ticks), 1)` 来修正不合法的数值。
- `func` 类型为 `function` ， miniExtend 会检查它的类型。
- `...` 类型不限，作为调用 `func` 时传递的实参。  
- 函数不使用多线程，在当前线程执行 `func` ，这可能导致程序阻塞。  
## `nextTick(func, ...)` 函数 ##
- 在下一帧以 `...` 为参数调用函数 `func` 。  
- 等价于 `scheduleCall(1, func, ...);` ，会检查 `func` 类型。  

综合实例：
从第 2 帧开始，每一帧都在日志输出 `"tick"` 、当前帧和 `Fibonacci[tick]`。  
其中 `tick` 表示当前是第几帧。  
`Fibonacci`	表示斐波那契数列，它的定义如下：  

- `Fibonacci[0] = 0`  
- `Fibonacci[1] = 1`  
- `Fibonacci[i] = Fibonacci[i-1] + Fibonacci[i-2] (i≥2, i∈N*)`  
<p></p>
	-- fib_2 表示 Fibonacci[tick-2] , fib_1 表示 Fibonacci[tick-1]
	function f(fib_2, fib_1)
		-- fib 表示 Fibonacci[tick]
		local fib = fib_1 + fib_2
		--Console:log() 函数参见 miniExtend Console
		Console:log("tick", getTick(), fib)
		nextTick(f, fib_1, fib)
	end
	-- Fibonacci[0] = 0, Fibonacci[1] = 1
	scheduleCall(2, f, 0, 1)
部分输出如下，忽略时间，标签前缀：  
tick	2	1  
tick	3	2  
tick	4	3  
tick	5	5  
tick	6	8  
tick	7	13  
