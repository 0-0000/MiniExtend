--[=[
ui.lua
管理自定义 UI 界面
依赖于 core.lua, object.lua, event.lua

元件继承关系：
element	元件，但在 miniExtend 不被直接使用，因为 UI 界面中创建的元件必定是以下四种之一
	image	图像
		button	按钮
	text	文本
		editBox	输入框，早期 miniExtend 称之为 inputBox ，后来发现 API 中称之为 editBox 才改名
]=]

local Player = Player
local Customui = Customui
local UIEditorDef = genv["UIEditorDef"]

--CustomUI namespace
CustomUI = {
	UIViews = {} --存储所有UI界面
}

--获取 UI 界面大小，该大小是精准到小数位的，也就是足够精准
--@return UI 界面的宽度 (width) 和高度 (height)
function CustomUI:getRootSize()
	local result = UIEditorDef.getRootSize()
	return result["width"], result["height"]
end

--UIView class
CustomUI.UIView = {
	id, --string	UI 界面的 id
	images, --table	UI 界面注册的所有图像元件
	buttons, --table	UI 界面注册的所有按钮元件
	texts, --table	UI 界面注册的所有文本元件
	editBoxes, --table	UI 界面注册的所有输入框元件
	showCallBack, --function	UI 界面显示时调用，没有什么用
	hideCallBack, --function	UI 界面隐藏时调用，有一定用处，玩家可能按 esc 键来隐藏 UI 界面
}

--创建或获取一个 UIView 对象
--@paprm uiid:string	UI 界面的 id
--@return 创建或获取到的 UIView 对象
function CustomUI:newUIView(uiid)
	local object = CustomUI.UIViews[uiid]
	if object then return object
	else
		object = setmetatable({}, CustomUI.UIView)
		object.id = uiid
		object.images, object.buttons, object.texts, object.editBoxes = {}, {}, {}, {}

		Event:connect("ui.show", function(paprm)
			if object.showCallBack then
				paprm["uiview"] = object
				object.showCallBack(paprm)
			end
		end, uiid)
		Event:connect("ui.hide", function(paprm)
			if object.hideCallBack then
				paprm["uiview"] = object
				object.hideCallBack(paprm)
			end
		end, uiid)
		Event:connect("ui.onPress", function(paprm)
			local button = object.buttons[paprm["btnelenemt"]]
			if button and button.pressCallBack then
				paprm["element"] = button
				button.pressCallBack(paprm)
			end
		end, uiid)
		Event:connect("ui.onClick", function(paprm)
			local button = object.buttons[paprm["btnelenemt"]]
			if button and button.clickCallBack then
				paprm["element"] = button
				button.clickCallBack(paprm)
			end
		end, uiid)
		Event:connect("ui.onInput", function(paprm)
			local editBox = object.editBoxes[paprm["btnelenemt"]]
			if editBox and editBox.inputCallBack then
				paprm["element"] = editBox
				editBox.inputCallBack(paprm)
			end
		end, uiid)
		return object
	end
end

--显示 UI 界面
function CustomUI.UIView:show(playerid)
	return Player:openUIView(playerid or _G2["__objid"], self.id) == 0
end

--隐藏 UI 界面
function CustomUI.UIView:hide(playerid)
	return Player:hideUIView(playerid or _G2["__objid"], self.id) == 0
end

--设置 UI 界面所有注册过的元件的状态
--@paprm state:string	要设置的界面状态
function CustomUI.UIView:setState(state, playerid)
	local result, playerid = true, playerid or _G2["__objid"]
	for id, element in pairs(self.images) do
		result = (Customui:setState(playerid, self.id, element.id, state) == 0) and result
	end
	for id, element in pairs(self.buttons) do
		result = (Customui:setState(playerid, self.id, element.id, state) == 0) and result
	end
	for id, element in pairs(self.texts) do
		result = (Customui:setState(playerid, self.id, element.id, state) == 0) and result
	end
	for id, element in pairs(self.editBoxes) do
		result = (Customui:setState(playerid, self.id, element.id, state) == 0) and result
	end
	return result
end

--Element class
CustomUI.Element = {}

--显示元件
function CustomUI.Element:show(playerid)
	return Customui:showElement(playerid or _G2["__objid"], self.uiView.id, self.id) == 0
end

--隐藏元件
function CustomUI.Element:hide(playerid)
	return Customui:hideElement(playerid or _G2["__objid"], self.uiView.id, self.id) == 0
end

--显示或隐藏元件
--@paprm display:boolean	true显示，否则隐藏
function CustomUI.Element:setDisplay(display, playerid)
	if display then return Customui:showElement(playerid or _G2["__objid"], self.uiView.id, self.id) == 0
	else return Customui:hideElement(playerid or _G2["__objid"], self.uiView.id, self.id) == 0 end
end

--设置元件状态
--@paprm state:string	要设置的界面状态
function CustomUI.Element:setState(state, playerid)
	return Customui:setState(playerid or _G2["__objid"], self.uiView.id, self.id, state) == 0
end

--设置元件位置
--@paprm x:number	新位置的横坐标 position 包含键x和y的表
--@paprm y:number	新位置的纵坐标
local function setPosition1(x, y, playerid)
	return Customui:setPosition(playerid or _G2["__objid"], self.uiView.id, self.id, x, y) == 0
end
--@paprm position:table	包含键 x 和 y 的表或有序数对
local function setPosition2(position, playerid)
	return Customui:setPosition(playerid or _G2["__objid"], self.uiView.id, self.id, position["x"] or position[1], position["y"] or position[2]) == 0
end
function CustomUI.Element:setPosition(parameter1, parameter2, parameter3)
	if type(parameter1) ~= "table" then
		return setPosition1(parameter1, parameter2, parameter3)
	else
		return setPosition2(parameter1, parameter2)
	end
end

--设置元件大小
--@paprm width:number	元件的新宽度
--@paprm height:number	元件的新高度
local function setSize1(width, height, playerid)
	return Customui:setSize(playerid or _G2["__objid"], self.uiView.id, self.id, width, height) == 0
end
--@paprm size:table	包含键 width 和 height 的表
local function setSize2(position, playerid)
	return Customui:setSize(playerid or _G2["__objid"], self.uiView.id, self.id, size["x"], size["y"]) == 0
end
function CustomUI.Element:setSize(parameter1, parameter2, parameter3)
	if type(parameter1) ~= "table" then
		return setSize1(parameter1, parameter2, parameter3)
	else
		return setSize2(parameter1, parameter2)
	end
end

--设置元件颜色
--@paprm color:number	新颜色 RGB 值
function CustomUI.Element:setColor(color, playerid)
	--实际需要左移 8 位才能得到正确的效果
	--这很可能是因为 API 将值转为 32 位整型变量，从数字高位向低位读出 RGB 值，低 8 位是无意义的
	--通常的识别方法是从高位到低位依次读取 alpha, red, green, blue 值，但 API 忽略了 alpha 值
	--由于 lua51 不支持位运算，使用 * 256 替代 << 8
	return Customui:setColor(playerid or _G2["__objid"], self.uiView.id, self.id, color * 256) == 0
end

--设置元件透明度
--@paprm alpha:number	透明度，0为完全透明，100为不透明
function CustomUI.Element:setAlpha(alpha, playerid)
	return Customui:setAlpha(playerid or _G2["__objid"], self.uiView.id, self.id, alpha) == 0
end

--设置元件角度
--@paprm angle:number 旋转角度，该角度是顺时针的
function CustomUI.Element:setAngle(angle, playerid)
	return Customui:rotateElement(playerid or _G2["__objid"], self.uiView.id, self.id, angle) == 0
end

--[[
Image class
继承自 CustomUI.Element
]]
CustomUI.Image = {}

--设置图像元件图案纹理
--@paprm url:string	图片id
function CustomUI.Image:setTexture(url, playerid)
	return Customui:setTexture(playerid or _G2["__objid"], self.uiView.id, self.id, url) == 0
end

--[[
Button class
继承自 CustomUI.Image
]]
CustomUI.Button = {
	pressCallBack, --function	按钮被按下时调用，需手动赋值
	clickCallBack, --function	按钮被点击时调用，需手动赋值
	-- 注：点击 = 按下 + 释放，然而很难判断按钮是否处于按下状态（按下但未释放）或者玩家释放了按钮，因为玩家可能将焦点移出按钮而我们没有办法判断这件事的发生
}

--[[
Text class
继承自 CustomUI.Element
]]
CustomUI.Text = {}

--设置文本元件字体大小
--@paprm size:number	字体大小
function CustomUI.Text:setFontSize(size, playerid)
	return Customui:setFontSize(playerid or _G2["__objid"], self.uiView.id, self.id, size) == 0
end

--设置文本元件内容
--@paprm text:string	显示的内容，如果字符串太长（极限可能取决于设备）则效果不明
function CustomUI.Text:setText(text, playerid)
	return Customui:setText(playerid or _G2["__objid"], self.uiView.id, self.id, text) == 0
end

--[[
EditBox class
继承自 CustomUI.Text
]]
CustomUI.EditBox = {
	inputCallBack, --function	玩家焦点离开输入框时（可以理解为玩家输入完毕）调用，需手动赋值
}

--创建或获取一个 Image 对象
--@paprm elementid:string	元件的id，形如[[uiname_elementid]]
--@return 创建或获取到的元件对象
function CustomUI.UIView:newImage(elementid)
	local object = self.images[elementid]
	if object then return object
	else
		object = setmetatable({}, CustomUI.Image)
		object.uiView = self
		object.id = elementid
		self.images[elementid] = object
		return object
	end
end

--此函数创建或获取一个 Button 对象
--@paprm elementid:string	元件的id，形如[[uiname_elementid]]
--@return 创建或获取到的元件对象
function CustomUI.UIView:newButton(elementid)
	local object = self.buttons[elementid]
	if object then return object
	else
		object = setmetatable({}, CustomUI.Button)
		object.uiView = self
		object.id = elementid
		self.buttons[elementid] = object
		return object
	end
end

--此函数创建或获取一个 Text 对象
--@paprm elementid:string	元件的id，形如[[uiname_elementid]]
--@return 创建或获取到的元件对象
function CustomUI.UIView:newText(elementid)
	local object = self.texts[elementid]
	if object then return object
	else
		object = setmetatable({}, CustomUI.Text)
		object.uiView = self
		object.id = elementid
		self.texts[elementid] = object
		return object
	end
end

--此函数创建或获取一个 EditBox 对象
--@paprm elementid:string	元件的id，形如[[uiname_elementid]]
--@return 创建或获取到的元件对象
function CustomUI.UIView:newEditBox(elementid)
	local object = self.editBoxes[elementid]
	if object then return object
	else
		object = setmetatable({}, CustomUI.EditBox)
		object.uiView = self
		object.id = elementid
		self.inputBoxes[elementid] = object
		return object
	end
end

CustomUI.UIView.__index = {
	["show"] = CustomUI.UIView.show,
	["hide"] = CustomUI.UIView.hide,
	["setState"] = CustomUI.UIView.setState,
	["newImage"] = CustomUI.UIView.newImage,
	["newButton"] = CustomUI.UIView.newButton,
	["newText"] = CustomUI.UIView.newText,
	["newEditBox"] = CustomUI.UIView.newEditBox,
}
CustomUI.Element.__index = {
	["show"] = CustomUI.Element.show,
	["hide"] = CustomUI.Element.hide,
	["setDisplay"] = CustomUI.Element.setDisplay,
	["setState"] = CustomUI.Element.setState,
	["setPosition"] = CustomUI.Element.setPosition,
	["setSize"] = CustomUI.Element.setSize,
	["setColor"] = CustomUI.Element.setColor,
	["setAlpha"] = CustomUI.Element.setAlpha,
	["setAngle"] = CustomUI.Element.setAngle,
}
	CustomUI.Image.__index = copy_table(CustomUI.Element.__index)
	CustomUI.Image.__index["setTexture"] = CustomUI.Image.setTexture
		CustomUI.Button.__index = copy_table(CustomUI.Image.__index)
	CustomUI.Text.__index = copy_table(CustomUI.Element.__index)
	CustomUI.Text.__index["setFontSize"] = CustomUI.Text.setFontSize
	CustomUI.Text.__index["setText"] = CustomUI.Text.setText
		CustomUI.EditBox.__index = copy_table(CustomUI.Text.__index)
