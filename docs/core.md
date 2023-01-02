# MiniExtend Core
对应源文件： *core.lua*  

---

MiniExtend 已尽可能恢复标准 lua 环境，这意味着你能正常调用那些本来被"删除"的基本函数。  
以下是相对标准 lua 环境有所不同的部分(前提是执行了 `Env.__init__();`):  
### `print(...)` 函数
- 虽然该函数进行了重写，但效果和之前的 `print()` 函数效果相同，仍采用相同的格式化方式。  

### `loadstring(string, [, chuckname])` 函数
- 与理想的 `loadstring()` 函数不同的是，该函数返回的函数的环境为 `&genv` ，因此无法直接使用 MiniExtend 。  
- 如果希望环境为 `&_GScriptFenv_` ，使用 `loadstring2()` 函数
- 注: 由于 `genv["_GScriptFenv_"]` 即 `&_GScriptFenv_` ，因此函数中可以访问 `&_GScriptFenv_` ，从而进一步访问 MiniExtend 。  

---

以下内容为 MiniExtend Core 增加的内容:  

## `Env` 作用域
`Env` 作用域是为脚本环境设定的作用域。  

### `__init__()` 函数
- 该函数初始化脚本的环境，<b style="color:red;">在每个自定义脚本开头都要最先执行</b>，不包括 UI 作用域中的 *ui_main.lua* ，否则可能导致脚本效率降低，出现错误。  
- 实际上就是把脚本对应的函数的环境设为 `&_GScriptFenv_` 。  

事实上，脚本环境不是真正的 `&_GScriptFenv_` ，而是内部定义的一个表，这个表首先索引游戏 API (例如 Game, Customui)，然后才去索引 `&_GScriptFenv_` 。  
并且每个脚本都会有不同的这样的环境，因为每个脚本都对应一个函数，而调用脚本即调用该函数，在此之前会设置环境。  

### `indexAPI(key)` 函数
- 获取游戏 API 对象，最好使用一个局部变量存储结果。  
- 函数会访问 `&_GScriptFenv_` ，但只应用于获取游戏 API 对象。  
- 由于 `Env.__init__()` 把脚本对应的函数的环境设为 `&_GScriptFenv_` ，因此无法直接访问游戏 API ，使用该函数访问游戏 API 。  
- `key`:`{string}` API 对象的名称，例如 `"Customui"`
- return:`{all}` 访问的结果  

### `index(key)` 函数
- 使用旧的 `&_GScriptFenv_`(实际上已经不存在) 索引全局变量，例如脚本常量, `printtag()`, `warn()` 等函数。  
- 这等同于以常规方式访问不为游戏 API 的全局变量。  
- `key`:`{string}` 索引的键值，例如 `printtag`, `warn`
- return:`{all}` 索引的结果

### 访问范围表
| 方式 | `&_GScriptFenv_` 中的值 | 旧的 `&_GScriptFenv_` 可访问的值 | 游戏 API
| :-: | :-: | :-: | :-: |
| 直接访问(`&_GScriptFenv_`) | √ | | |
| `Env.indexAPI(key)` | √ | | √ |
| `Env.index(key)` | | √ | |

---


## `genv` 表
- 该表即 `&genv` ，在 MiniExtend 中直接提供了这一个表。  
- 注意，在使用 `Env.__init__()` 之前，脚本函数本身的环境是一个特殊的表，它首先控制对游戏 API 的访问，然后才去索引 `&_GScriptFenv_` 。  

---

## `_G2` 表
- 在任何可能的环境下(包括 `&_GScriptFenv_` 和 `&genv`)，只要脚本在 `core` 脚本后运行都可以访问该表，因此可以通过 `_G2` 来在各个脚本之间交换数据。  
- 不要使用 `"__MiniExtend__"` 开头的变量来作为自己的索引，因为 MiniExtend 使用这种标识符作为索引存储一些变量，你可以遍历 `_G2` 来确定 MiniExtend 使用了哪些标识符。  

---
## 函数

### `loadstring2(string, [, chuckname])` 函数
- 类似于 `loadstring(string, [, chuckname]);` ，但是注意 `losdstring()` 返回的函数的环境为 `genv` ，而 `loadstring2()` 返回的函数的环境为 `&_GScriptFenv_` 。  
- 基本等价于 `LoadLuaScript(string, [, chuckname]);` ，使用它替代 `LoadLuaScript()` 。  

### `deepcopy(table)` 函数
- 返回 `table` 的深拷贝。  
- 基本等价于 `copy_table(table);` ，使用它替代 `copy_table()` 。  
- `table`:`{table}` 要深拷贝的表。  
- `return`:`{table}` `table` 的深拷贝。  

---

## 注意事项
迷你世界不是简单的 lua 解释器，有时脚本还会在服务器上运行，因此一些 lua 基本函数可能有歧义。  
可以近似的认为开发者脚本在服务器上运行，因此 `io`, `package`, `os.execute` 等访问操作系统的函数的行为取决于服务器。  
对于任何访问系统的函数，例如 `io`, `package`, `os.execute` ，它们大多本是被删除的函数和库，其行为取决于游戏的服务器。

- 在单人模式下，服务器就是玩家的设备。  
- 由房主开启的多人游戏，服务器是房主的设备。  
- 开发者申请的云服，服务器是迷你世界管理该云服的服务器（这可能不准确因为没有明确的证据证明这一点）。  

<h3 style="color:red;">危险</h3>
某些 lua 基本函数可能很危险，必须注意这些危险行为，以下是一些例子：  

- 如果你使用 `io.close();` ，这将关闭默认输出文件，在 lua 上因为不能关闭标准文件而失败，但在迷你世界中，这将导致<u title="这似乎会使游戏保存，再次打开地图仍是玩法模式，然后继续关闭……所以请使用编辑模式打开">程序突然关闭</u>。  
- 在 Windows 下执行 `os.execute("cmd")` ，会弹出一个 cmd 窗口，而且该窗口会<span style="color:red;">阻塞</span>程序运行，除非手动关闭，这也非常难看。  
