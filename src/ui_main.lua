-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
ui_main.lua
处理属于该 UI 界面的事件，即完成预绑定
依赖于 core.lua, event.lua 间接依赖于 object.lua
最后更新 : 3.1.0
]=]

--[=[
该脚本应处于 UI 作用域中
所以的 UI 界面都应该有该脚本(否则无法使用 MiniExtend Event 绑定该 UI 界面的事件)
注意手动将 uiid 替换！
]=]

-- 需将 uiid 替换为所属 UI 界面 id
_G2["__MiniExtend__sendSSEObject"](uiid, ScriptSupportEvent)
