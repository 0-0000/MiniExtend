# 迷你世界脚本的对 Lua 的修改

首先，要知道迷你世界的 Lua 脚本解释器为 [Lua5.1][http://www.Lua.org/versions.html#5.1] 。

但是，脚本运行环境与标准的 Lua5.1 环境有很大差异，举个简单的事实， `_G` 表实际不包含任何值，对 `_G` 的修改和读取都是由它的元表完成的，对环境的修复也要以这个元表为突破口，详见 `core.lua` 。

以下假设你还未使用 miniExtend ，使用 miniExtend 会改变这些现象，详见 [miniExtend Core][/api/core.html] 。

## 删除的基本函数和库

- `io`、`package` 中的所有值。
- `os` 中除了 `os.dateLua、os.timeLua` 以外的所有值。

::: tip
实际上，输出的值并没有真正的从内存上删除，只是无法通过 `_G` 索引而已。
:::

## 修改的基本函数

- `dofileLua` 和 `loadfileLua` 函数不会获得它们应有的效果，应该是什么都不做的空函数。
- `errorLua` 函数虽然仍会在日志中输出错误信息，但不会抛出错误来终止函数运行，在没有 miniExtend 时，开发者可能不得不使用 `return error(message);` 。
- 调用 `loadstringLua` 函数会弹出漂浮文字，提示开发者使用 `LoadLuaScriptLua` ，而不会做其它事。
- `print`函数在<a title="玩法模式下开发者可按右上角的“！”按钮打开日志">日志</a>中输出而不是在<a title="迷你世界是 GUI 软件，正常情况不会显示控制台">控制台</a>输出，且格式化方式与标准 `print、` 差异很大，具体格式化方式可自行测试。

## 添加的函数

- `copy_table(table)` ： 返回 `table` 的深拷贝
- `isTypeError(type, ...)` ：如果所有可变参数的类型都等于 `type` ，返回 `false` ，否则返回 `true` 。
- `print_console` ：等价于调用标准 Lua 的 `print、` 函数，要注意该函数会输出到控制，而非日志。
- `printtag(tag, ...)` ：在日志以 `tag` 为标签格式化输出，参见 [printLua][print] 函数，调用 `print;` 等价于调用 `printtag("global", ...)` ，也就是说 `printLua` 函数使用标签 `"global"` 。
- `warn(message)` ：在日志中输出警告信息（有黄色高亮标记） `message` ，使用 `"warning"` 作为标签。

miniExtend 没有修改这些添加的函数，不建议使用这些函数，它们应该只被内部调用。