--[=[
ide.lua
用于编辑器自动补充
不依赖其它 miniExtend 脚本
应该放在用户自定义脚本中
最后更新 : 0.1.0.1
]=]
--[=[
getTick() scheduleCall(ticks, func, ...) nextTick(func, ...)
getObjectId() setObjectId(objid)
Console
	log(..) loatag(tag, ...) warn(message) error(message) clear()
ui
	show hide onPress onClick onInput
Event
	connect(eventname, callback [, uiid])
	Lister
		delete()
CustomUI
	getRootSize()
	newUIView(uiid)
	UIView
		show([playerid]) hide([playerid]) setState(state [, playerid])
		newImage(elementid)
		newButton(elementid)
		newText(elementid)
		newEditBox(elementid)
	Element
		show([playerid]) hide([playerid]) setDisplay(display [, playerid]) setState(state [, playerid])
		setPosition(x, y [, playerid]) setPosition(position [, playerid])
		setSize(width, height [, playerid]) setSize(size [, playerid])
		setColor(color [, playerid]) setAlpha(alpha [, playerid])
		setAngle(angle [, playerid])
		Image
			setTexture(url [, playerid])
			Button
				pressCallBack clickCallBack
		Text
			setFontSize(size [, playerid]) setText(text [, playerid])
			EditBox
				inputCallBack
]=]
