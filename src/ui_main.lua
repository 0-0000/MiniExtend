--[=[
ui_main.lua
应放置在 UI 作用域中
处理属于该 UI 界面的事件，所以所有的 UI 界面都应该有该脚本
依赖于 core.lua, event.lua
简介依赖于 object.lua

注意手动修改第 12 行代码！
]=]

--将 uiid 替换为所属 UI 界面 id
_G2["__newUI"](uiid, ScriptSupportEvent)
