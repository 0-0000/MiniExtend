# 迷你世界脚本

## 与标准 lua 脚本的差异
首先，要知道迷你世界的 lua 脚本解释器为 [lua51](http://www.lua.org/manual/5.1/) 。
但是，脚本运行环境与标准的 lua51 环境有很大差异，举个简单的事实， `_G` 表实际不包含任何值，对 `_G` 的修改和读取都是由它的元表完成的，对环境的修复也要以这个元表为突破口，详见 `core.lua` 。  
以下内容假设你还未使用 MiniExtend ，使用 MiniExtend 会改变这些现象，详见 [MiniExtend Core](./core.html) 。  

## 删除的基本函数
- `io`, `package` 中的所有值 。
- `os.clock()`, `os.difftime()`, `os.execute()`, `os.exit()`, `os.getenv()`, `os.remove()`, `os.rename()`, `os.setlocale()`, `os.tmpname()` 。即 `os` 中除了 `os.date()`, `os.time()` 以外的所有函数。  

实际上，它们并没有真正的从内存上删除，只是无法通过 `_G` 索引而已。  

## 更改的基本函数
- `dofile()` 和 `loadfile()` 函数不会获得它们应有的效果，应该是什么都不做的空函数。
- `error()` 函数虽然仍会在日志中输出错误信息，但不会抛出错误来终止函数运行，在没有 miniExtend 时，开发者可能不得不使用 `return error(message);` 。
- 调用 `loadstring()` 函数会弹出漂浮文字，提示开发者使用 `LoadLuaScript()` ，而不会做其它事。  
- <code id="print">print(...)</code> 函数在<u title="玩法模式下开发者可按右上角的“！”按钮打开日志">日志</u>中输出而不是在<u title="迷你世界是 GUI 软件，正常情况不会显示控制台">控制台</u>输出，且格式化方式与标准 `print(...)` 差异很大，具体格式化方式可自行测试。  

同样，它们也没有被真正替换，只是通过 `_G` 来索引的结果是更改后的函数。

## 添加的函数
- `copy_table(table)`: 返回 `table` 的深拷贝  
- `isTypeError(type, ...)`: 如果所有可变参数的类型都等于 `type` ，返回 `false` ，否则返回 `true` 。
- `print_console(...)`: 等价于调用标准 lua 的 `print(...)` 函数，要注意该函数会输出到控制，而非日志。
- `printtag(tag, ...)`: 在日志以 `tag` 为标签格式化输出，参见 [print()](#print) 函数，调用 `print(...);` 等价于调用 `printtag("global", ...)` ，也就是说 `print()` 函数使用标签 `"global"` 。
- `warn(message)`: 在日志中输出警告信息（有黄色高亮标记） `message` ，使用 `"warning"` 作为标签。  

MiniExtend 没有修改这些添加的函数，但是不建议使用这些函数，它们应该只被内部调用。  
以上内容只是对现象的简单概括，要想真正理解迷你世界脚本，建议阅读 *core.lua* 并手动测试。  
