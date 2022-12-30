# MiniExtend Time
对应源文件： *time.lua*  

---

## `getTick()` 函数
- 函数返回当前是第几游戏帧(详见 wiki)。  
- 只要你立即游戏帧的含义，该函数很容易理解。  

---

## `scheduleCall(ticks, func, ...)` 函数
- 在 `ticks` 游戏帧后以 `...` 为参数调用函数 `func` 。  
- 函数不使用多线程，在当前线程执行 `func` 可能导致程序阻塞。  
- `ticks`:`{integer}` 会被设置为 `math.max(math.floor(ticks), 1)` 来修正不合法的数值  
- `func`:`{function}` 延时调用的函数  
- `...`:`{all}` 调用 `func` 时传递的实参  
- return:`{integer | boolean}` 成功时返回延时调用的 id (用于取消监听)，否则返回 false  

---

## `nextTick(func, ...)` 函数
- 在下一帧以 `...` 为参数调用函数 `func` 。  
- 等价于 `scheduleCall(1, func, ...);` 。  

注: 如果在延时回调函数中再调用 `scheduleCall()` 或 `nextTick()` 来延时执行函数，则从下一帧开始倒计时。  

---

## `cancelScheduleCall(id)` 函数
- 取消延时调用。  
- `id`:`{integer}` 延时调用的 id ，由 `scheduleCall()` 或 `nextTick()` 返回  
- return:`{boolean}` 如果正确地取消了一个函数调用，返回 `true` ，否则返回 `false`  


---

## `Timer` 类
`Timer` 类即计时器类，以下简称 `Timer` 。  

注意，计时器运行时期晚于延时调用的函数(`scheduleCall()`)。  
在延时回调函数中启动计时器会使计时器在那一帧运行。  
同样， `delay` 值仍会递减，然后判断 `delay` 并调用 `callback` 。  
 ，仍然正常调用 `callback` 并重置 `delay` 。  

### 构造函数
使用 `Timer:new()` 来构造一个计时器和相应的 `Timer` 对象，计时器默认是**暂停**的。  

### 析构函数
使用 `Timer:delete()` 来删除计时器，这不会删除对象本身，仅仅使计时器失去计时功能。  

### 属性
- `createTime`:`{float}` 表示对象创建时的 **CPU 时间**。  
- `tick`:`{integer}` 表示对象创建以来计时器**运行**的游戏帧数。  
- `delay`:`{integer}` 下一次调用 `callback` 的间隔帧数，计时器运行期间每帧减 1 ，降为 0 时恢复为 1 。  
即使你将 `delay` 设为 0 然后 `delay` 变为 -1 ，仍然正常的恢复 `delay` 为 1 然后调用 `callback` 。  
- `callback`:`{function | nil}` 当 `delay` 降为 0 时，调用该函数。  
> 回调时传递两个参数: `self` 和 `tick` 。  
> `self` 表示计时器对象。  
> `tick` 表示当前游戏帧。  

### 方法
- `start()`: 启动计时器，如果计时器之前是暂停的返回 `true` ，否则返回 `false` 。  
- `pause()`: 暂停计时器，如果计时器之前是启动的返回 `true` ，否则返回 `false` 。  
- `isRunning()`: 返回计时器是否启动。  

---

## 综合实例

### 情形
首先定义 `tick` 表示当前游戏帧， `i` 的值为 2 。  
从第一帧开始，每隔两帧执行以下操作:  
- 在日志输出当前帧，以及 `Fibonacci[i]` 的值。  
- 将 `i` 的值加 1 。  

`i`=50 以后，停止输出。  
`Fibonacci` 表示斐波那契数列，以下简称 `fib` ，它的定义如下:  

- `fib[0] = 0`  
- `fib[1] = 1`  
- `fib[i] = fib[i-1] + fib[i-2] (i≥2, i∈N*)`  

### 分析
首先需要知道快速计算 `fib[1~n]` 的方法:  
> 定义 `fibs[0~n]` ，满足 `fibs[i]` = `fib[i]`  
> 令 `fibs[0]` = `fib[0]` = `0`, `fib[1]` = `fib[1]` = `1` ，该步骤符合 `fibs` 的性质。  
> 令 `k` 从 `2` 到 `n` 进行如下运算:
> - 令 `fibs[k]` = `fibs[k-1]` + `fibs[k-2]`
> - 该步骤也符合 `fibs` 的性质
>
> `fibs` 即为所求
>
> 实际上并不是真的需要 `fibs` 数组，因为计算 `fibs[k]` 只需要 `fibs[k-1]` 和 `fibs[k-2]` 的值，所以只需要存储这三个变量即可计算。  

使用 MiniExtend Time 来完成异步输出，使用 `nextTick()` 函数实现"从第一帧开始" 。  
使用 `Timer` 计时器对象，通过设置其 `delay` 值为 2 实现"每隔两帧" 。  
`i >= 50` 时调用 `Timer:pause()` 来实现"停止循环"。  

### 代码
<textarea>
Env.__init__()
timer = Timer:new()
-- fib1 表示 fib[i-2] , fib2 表示 fib[i-1]
-- fib[0] = 0, fib[1] = 1
local i, fib1, fib2 = 2, 0, 1
-- 另一种方法:
-- timer.calback = function(self, tick)
function timer:callback(tick)
	-- 回调时 delay 已被默认地设为 1 ，因此需要重新设置 delay
	self.delay = 2
	-- fib3 表示 Fibonacci[i]
	local fib3 = fib1 + fib2
	local tickInfo, fibInfo = "tick "..tostring(tick)
	local fibInfo = "fib["..tostring(i).."] = "..tostring(fib3)
	Log.logtag("fib", tickInfo, fibInfo)
	if i >= 50 then
		timer:pause()
	else
		-- 为新的 fib 计算准备
		i, fib1, fib2 = i+1, fib2, fib3
	end
end
-- 另一种方法:
-- scheduleCall(1, function()
nextTick(function()
	-- 计时器运行晚于 nextTick
	-- 在这个 nextTick 回调后的那一帧 timer 就会开始运行
	timer:start()
end)
</textarea>

部分输出如下:  
![上部输出](./img/output1.png)
![下部输出](./img/output2.png)
