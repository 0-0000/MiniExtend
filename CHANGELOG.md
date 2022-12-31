# 更新日志 #

---

## v1.0.0
**第一个正式的 MiniExtend 版本**

---

## v1.0.1
- 修改了自述文件 *README.md* ，更新了 MarkdownPad 风格文档。  
- 删除了 *order.md* 文件。  
- 修复了 `scheduleCall(ticks, func, ...)` 函数在 `ticks` 大于 1 时会多等待 1 帧的问题。  
- `_G2["__newUI"]` 替换为 `_G2["__SENDSSE"]` ，并同步修改。  
- `_G2["__objid"]` 替换为 `_G2["__OBJID"]` ，并同步修改。  
- `useObjectId()` 函数的名称替换为 `setObjectId()` ，并同步修改。  
- 修复了其它小 bug 。  

---

## v2.0.0
- 修改了自述文件 *README.md* 。  
- 使用 ~Apache Licence 2.0~ 作为许可证，并在代码开头添加作者信息。  
- MiniExtend 代码不再使用 MarkdownPad 风格文档。  
- 分离文档让开发者自己维护自己风格的 MiniExtend 文档。  
- 整体优化代码，原则为**以空间换时间**。  
- 代码使用更详细的注释。  
- 删除了 `_LUAG` 。  
- 新增了 `GameVM` 全局变量，存储游戏 API 对象，例如通过 `GameVM.UI` 来访问 UI API 。  
- 修改了 `_G` 元表的 `__index` 函数，使其能更快索引不在 `_G` 中的键。  
- 新增 `Time` 作用域，将全局函数 `getTick()`, `scheduleCall()` 和 `nextTick()` 转移到 `Time` 作用域中。  
- 新增了计时器类 `Time.Timer` ，详见 *time.lua* 。  
- 优化了 `Console` 作用域下的函数。  
- `_G2["__SENDSSE"]` 修改为 `_G2["__CONNECT"]` 。  
- 修改了 MiniExtend 自定义事件名的名称，并且使用 `"$"` 开头来标记事件是 MiniExtend 自定义事件。  
- 将 `Event.Listener` 更改为 `Event.Connecter` 。  
- 将 `Event:connect()` 函数更改为 `Event.Connecter:new()` 。  
- 将 `CustomUI` 作用域更改为 `UI` 作用域，使用 `GameVM.UI` 来访问因此被顶替的 UI API 。  
- 在 *ui.lua* 中将 `Image` 和 `Text` 分别更改为 `Texture` 和 `Label` ，即修改了相应的类名和函数名。  
- 现在允许通过 `UI.$CLASSNAME:new(uiview, elementid)` 来构造 `$CLASSNAME` 对象，显然 `$CLASSNAME` 包含 `Texture`, `Button`, `Label`, `EditBox` 。   

---

## v2.0.1
- 改动了 *ide.lua* 。  
- 使用 MIT Licence 作为许可证。  
- 在 *README.md* 中增加了引用文档的仓库链接。   

---

## v2.0.2
- 修复了上个版本发布时一些文件中没有及时更新版本的问题。  
- 修复了 `UI.Texture` 类被设置为全局变量的问题。  
- 在文档中增加以前未提出的 `UI:getRootSize()` 函数。   

---

## v2.1.0
- 修复了部分文件合并时 git 增加的合并标识没有去掉的问题。  
- 修复了 *object.lua* 中仍使用 `_LUAG` 的问题。  
- 修复了文档使用绝对路径索引图片的问题。  
- `Time.Timer` 类增加 `delay` 成员变量，表示下一次调用 `callback` 的间隔帧数。  
- <span style="color:red;">将 `UI` 作用域改为 `MUI` 作用域</b>。  
- 优化文档。  

---

## v3.0.0

### 整体更改
- <span style="color:red;">访问静态函数的操作符由 `:` 变为 `.` 。</span>
- `_G2` 表中 MiniExtend 占用的键值名称由 `"__*"` 变为 `"__MiniExtend__*"` 。  
- 重置了部分函数使之更高效。  
- 优化了代码的注释。  
- 文档同步代码更改，同时对旧内容有所更改。  

### *core.lua*
- 新建了 `Env` 作用域，其作用如下:  
- 1. `__init__()` 初始化脚本环境，使脚本环境从内部定义的一个表转移到 `_GScriptFenv_` 上，该函数在每个脚本开头都应该调用。  
- 2. `indexAPI(key)` 调用 `Env.__init__()` 后，无法直接访问游戏 API ，通过该函数访问游戏 API 对象。  
- 3. `index(key)` `_GScriptFenv_` 不再包含元表，使用该函数访问以前需要通过元表访问的"全局变量"，例如 `printtag`, `warn`。  
- 删除了 `GameVM` 表。  
- 定义了新的 `loadstring2()` 函数，比 `LoadLuaScript()` 更高效，效果基本相同(但是不会在安全调用返回的函数仍然报错)。  
- 定义了新的 `deepcopy()` 函数，比 `copy_table()` 更高效。  

### *console.lua* -> *log.lua*
- MiniExtend Console 改为 MiniExtend Log ，对应代码文件由 *console.lua* 改为 `log.lua` ， `Console` 作用域改为 `Log` 作用域。以下关于 `Log` 作用域的更改是相对之前的 `Console` 作用域对应的函数而言的。  
- `Log` 作用域中的函数都会返回一个 `boolean` 类型的值表示 API 调用是否成功。  

### *time.lua*
- 移除了 `Time` 作用域，使其成员成为全局变量。  
- 延时调用函数(`scheduleCall()` 和 `nextTick()`) 会返回一个 id 表示延时调用的 id ，用于取消延时调用。  
- 新增了 `cancelScheduleCall(id)` 来取消 id 所对应的延时调用。  
- 现在延时调用在传递参数时不再因参数中间的 `nil` 而丢失后面的参数。  

### *object.lua*
- 优化了 `objid` 的实现，不再使用 `_G2["__OBJID"]` 存储 `objid` 。  
- `setObjectId()` 只支持 `number` 类型的参数。  

### *event.lua*
- 移除了 `Event` 作用域，使其成员成为全局变量(不包括 `CustomEvents` ，其成为局部变量)。  
- 移除了 `Connecter` 类，使用 `Register` 表代替它的职能描述事件监听。  
- `Connecter` 类的构造函数(监听游戏事件)改为 `registerEvent()` 。  
- `Connecter` 类的析构函数(取消事件监听)改为 `cancelRegisterEvent()` 。  
- 事件监听回调前会设置 `objid` 的值，在回调结束后恢复 `objid` 的值。  
- 以保护模式回调，发生错误时会在错误信息追加信息头。  

### *ui.lua*
- <span style="color:red;">`MUI` 作用域改回 `UI` 作用域。</span>
- 修正了 `UI.Texture:setTexture()` 函数。  

---

## v3.0.1

- 修复了 *event.lua* 中在 `_G2["__MiniExtend__sendSSEObject"]` 函数中使用了中文逗号的问题。  
- 优化了 *log.lua* 的注释。  
- 修正了 *environment* 文档中的代码。  

---

## v3.0.2

- 修复了 *event.lua* 错误地使用 `table.concat()` 函数的问题。  
- 将未转化为 html 的文档重新转化。  

---
