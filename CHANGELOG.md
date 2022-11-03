# 更新日志 #

## v0.1.0 ##
**第一个正式的 miniExtend 版本**

## v0.1.0.1 ##
- 修改了自述文件 `README.md` ，更新了 MarkdownPad 风格文档。  
- 删除了 `order.md` 文件。  
- 修复了 `time.lua` 中 `scheduleCall(ticks, func, ...)` 在 `ticks` 大于 1 时会多等待 1 帧的问题。  
- 将 `event.lua` 中 `_G2["__newUI"]` 替换为 `_G2["__SENDSSE"]` ，并对 `ui_main.lua` 做了相应修改。  
- 将 `object.lua` 中 `_G2["__objid"]` 替换为 `_G2["__OBJID"]` ，并对 `ui.lua` 做了相应修改。  
- 将 `object.lua` 中 `useObjectId()` 函数的名称替换为 `setObjectId()` ，并对 `ide.lua` 做了相应修改。  
- 修复了其它小 bug 。  
