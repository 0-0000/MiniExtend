# MiniExtend Core
对应源文件： *core.lua*  

MiniExtend 已尽可能恢复标准 lua 环境，这意味着你能正常调用那些本来被"删除"的基本函数。  
以下是相对标准 lua 环境有所不同的部分：  

### `genv` 表
- 该表表示迷你世界脚本内部环境，想知道它包含什么可以遍历它，但要注意该表包含上万个键。  
- 开发者编辑的脚本的环境 `_G`(以下称作 `_GScriptFenv_`) 不同于 `genv` ，但 `genv["_GScriptFenv_"]` 就等于这个 `_GScriptFenv_` ，也就是可以以此来通过 `genv` 访问脚本环境。  

### `_G2` 表
- 在任何可能的环境下(包括 `_GScriptFenv_` 和 `genv`)，只要脚本在 `core` 脚本后运行都可以访问该表，因此可以通过 `_G2` 来在各个脚本之间交换数据。  
- 不要使用 `"__" + 大写字母组合` 来作为自己的索引，因为 MiniExtend 使用这种标识符作为索引存储一些变量，你可以遍历 `_G2` 来确定 MiniExtend 使用了哪些标识符。  

### `GameVM` 表
- 该表存储游戏 API 对象，如 `ScriptSupportEvent`, `Game`, `UI`(自行类推)。  
- 该表主要用于解决命名冲突，例如 MiniExtend 使用了 `UI` 作用域，顶替掉了 UI API ，于是使用 `GameVM.UI` 来访问 UI API 。  

---
### `loadstring(string, [, chuckname])` 函数
- 与传统的 `loadstring()` 函数不同的是，该函数返回的函数的环境为 `genv` ，因此无法直接使用 MiniExtend 。  
- 上面说过了，可以使用 `_GScriptFenv_` 访问脚本环境，从而进一步访问 MiniExtend 。  

### `loadstring2(string, [, chuckname])` 函数
- 该函数等价于 `LoadLuaScript(string, [, chuckname])` 函数，使用它代替 `LoadLuaScript()` 函数。  
- 该函数效果类似于 `loadstring(string, [, chuckname]` ，但是返回的函数的环境运行时的环境为 `_GScriptFenv_` 。  
- 注意，如果返回的函数调用时出错，即使以保护模式调用函数本生，仍会调用 `error()` 输出错误，解决方法是在函数内部使用 `pcall()` 。  

### `deepcopy(table)` 函数
- 该函数等价于 `copy_table(table)` 函数，使用它代替 `copy_table()` 函数。  
- 返回 `table` 的深拷贝

---
## 效率
通常情况迷你世界占用的内存空间不到 1GB ，这对于现在几乎任何设备都是能够承受的，但对 CPU 算力要求(指上限)高，所以 MiniExtend 采取以空间换时间的原则，使用了大量局部变量来提高效率，然而即使这样 MiniExtend 所占用的内存也很难超过 1MB 。  
MiniExtend 对脚本在效率方面的优化主要如下:
- 移除了 `_GScriptFenv_` 元表的 `__newindex` 函数，使得创建新全局变量只需索引赋值 `_GScriptFenv_` 而无需调用 `__newindex` 。  
- 将大多数 lua 基本函数和库直接移动到 `_GScriptFenv_` ，使得访问这些只需索引一次 `_GScriptFenv_` 。  
- 修改了 `_GScriptFenv_` 元表的 `__index` 函数。  

为了表示它们对效率的提升，我们对第三项做实验进行效率分析，显然第一二项带来的效率提升远大于第三项。  
实验方法:  
- 关闭大多数耗能较大的程序，使得游戏在实验过程中分配到的 CPU 时间基本不变。  
- 在运算前先进行次数很多的循环，使游戏进入 "无响应" 状态，避免 "无响应" 带来的不同影响。  
- 先使用旧方法(未更改 `__index` 函数)访问，然后使用新方法(紧随前一种方法运行)访问相同数量的变量多次。在一次循环中多次访问变量以减少循环带来的误差。  
- 两种方法使用 `os.clock()` 在前后计时，运算得出两种方法的运行时间。  
- 重复实验或更换访问的全局变量的特征，数量继续实验。  

实验数据如下:  
- 在一次实验中，访问 10 个不存在的变量(`nil`) 一百万次，前者花了 10.531s ，后者花了 8.668s ，快了约 **17%** 。  
- 在一次实验中，访问 5 个在 `genv` 中(这些变量可通过 `_GScriptFenv_` 索引)的变量，前者花了 5.934s ，后者花了 4.812s ，快了约 **20%** 。  
- 在一次实验中，访问 2 个 API 对象，前者花了 9.506s ，后者花了 9.872s ；另一次同样的实验，前者花了 9.652s ，后者花了 9.845s ，慢了约 **3%~4%** 。  

尽管新方法访问 API 对象较慢，但 MiniExtend 提供了 `GameVM` 来快速访问 API 对象，如果在意这 **3%~4%** ，请使用 `GameVM` 和局部变量。  
注: 这些实验数据是多次实验中有代表性的(接近平均数)。  

## 注意事项
迷你世界不是简单的 lua 解释器，有时 lua 还会在服务器上运行，因此一些 lua 基本函数可能有歧义。  
对于任何访问系统的函数，例如 `io`, `package`, `os.execute` ，它们大多本是被删除的函数和库，其行为取决于游戏的服务器。

- 在单人模式下，服务器就是玩家的设备。  
- 由房主开启的多人游戏，服务器是房主的设备。  
- 开发者申请的云服，服务器是迷你世界管理该云服的服务器（这可能不准确因为没有明确的证据证明这一点）。  

这些函数只会在服务器上运行，访问的操作系统方法也取决于服务器。  
而且，其中的某些函数可能很危险，以下是一些例子：  

- 如果你使用 `io.close();` ，这将关闭默认输出文件，在 lua 上因为不能关闭标准文件而失败，但在迷你世界中，这将导致<a title="这似乎会使游戏保存，再次打开地图仍是玩法模式，然后继续关闭……所以请使用编辑模式打开">程序突然关闭</a>。  
- 在 Windows 下执行 `os.execute("cmd")` ，会弹出一个 cmd 窗口，而且该窗口会阻塞程序运行，除非手动关闭，这也非常难看。  