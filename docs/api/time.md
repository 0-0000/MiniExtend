---
title: 游戏时间 Time
---



# miniExtend Time

对应源文件： `time.lua` 。

## 函数介绍

### `getTick`

函数原型：

```lua
function getTick() end
```

返回当前是第几游戏帧。

只要你理解游戏帧的含义，该函数很容易理解。

### `scheduleCall`

在 `ticks` 游戏帧后以 `...` 为参数调用函数 `func` 。

函数原型：

```lua
function scheduleCall(ticks, func, ...) end
```

参数：

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`ticks`|`number`|等待帧数|通过 `math.max(math.floor(ticks), 1)` 修正|
|`func`|`function`|调用的函数|:heavy_check_mark:|
|`...`|`...any`|调用 `func` 时传递的实参||

::: warning

本函数同步执行。如果在当前线程执行 `func` ，这可能导致程序阻塞。

:::

### `nextTick(func, ...)`

在下一帧以 `...` 为参数调用函数 `func` 。

函数原型：

```lua
function nextTick(func, ...)
  scheduleCall(1, func, ...)
end
```

参数：

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`func`|`function`|调用的函数|:heavy_check_mark:|
|`...`|`...any`|调用 `func` 时传递的实参||

等价于 `scheduleCall(1, func, ...);` 。

## 示例

从第 2 帧开始，每一帧都在日志输出 `"tick"` 、当前帧和 `fibonacci[tick]`。

其中 `tick` 表示当前的帧数。

`fibonacci`	表示斐波那契数列，详见[百度百科词条](https://baike.baidu.com/item/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0%E5%88%97)。

```lua
-- fib_2 表示 fibonacci[tick-2] , fib_1 表示 fibonacci[tick-1]
function f(fib_2, fib_1)
	-- fib 表示 fibonacci[tick]
	local fib = fib_1 + fib_2
	--Console:log() 函数参见 miniExtend Console
	Console:log("tick", getTick(), fib)
	nextTick(f, fib_1, fib)
end
-- fibonacci[0] = 0, fibonacci[1] = 1
scheduleCall(2, f, 0, 1)
```

部分输出如下（忽略时间，标签前缀）：

```
tick	2	1
tick	3	2
tick	4	3
tick	5	5
tick	6	8
tick	7	13
```