# MiniExtend Console
对应源文件： *console.lua*  
## <code style="color:green;">Console</code> 作用域
这里的 Console 并不指真实的程序控制台，而是指日志，如图所示：  
![日志](./img/console.png)  
真正在控制台输出的信息几乎是不可见的，但是日志中的信息是可见的。  
注：在开发者工具中调整![测试](./img/test.png)至图示状态来启用日志，新地图创建时该按钮可能出于启用状态但日志并未开启，为了保证日志启用可以点击该按钮两次来刷新状态。  
在玩法模式下按![日志按钮](./img/console-button.png)来打开日志窗口。  

## 函数
`Console` 作用域包含以下函数：  

- `log(...)`  
> 在日志以 `"global"` 为标签输出 `...` 。  
> `...`:`{all}`输出内容，格式化方式与 lua **基本**函数 `print(...)` 相同。  
> 等价于调用 `Console:logtag("global", ...);` 。  

- `logtag(tag, ...)`  
> 在日志以 `tag` 为标签格式化输出 `...` 。  
> `tag`:`{string}` 输出标签，如果不是 `string` 类型那么函数行为会令人困惑。  
> `...`:`{all}` 输出内容，格式化方式与 `log()` 相同。  

- `warn(message)`  
> 在日志以 `"warning"` 为标签输出输出警告信息 `message` 。  
> `message`:`{string}` 输出的警告信息。  
> 与脚本内置的 `warn(message)` 函数不同的是，该函数会以黄色高亮显示警告。  

- `error(message)`  
> 在日志以 `"error"` 为标签输出输出错误信息 `message` 。  
> `message`:`{string}` 输出的错误信息。  
> 与 lua **基本**函数 `error()` 不同的是，该函数不会抛出错误。  
> 该函数会以红色高亮显示警告。  

- `clear()`  
> 清空日志，效果和在控制台点击![清空日志](./img/clear-console.png)按钮一样。  
> `return`:`{boolean}` API 调用成功返回 `true` ，否则返回 `false` 。

这些函数都比较简单，就不举实例了，有疑惑可以自行测试效果。
