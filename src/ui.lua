-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
ui.lua
管理自定义 UI 界面
依赖于 core.lua, object.lua, event.lua
最后更新 : 2.0.0
]=]
--[=[
类关系示意图:
类名		类描述	父类		具象 作用
UIView	UI 界面	/		是	管理 UI 界面
Element	元件		/		否	提供 UI 元件基本方法
Texture	图片		Element	是	管理图片元件
Button	按钮		Texture	是	管理按钮元件
Label	文字		Element	是	管理文字元件
EditBox	输入框		Label	是	管理输入框元件
]=]

local Player, Customui = Player, Customui
local setState = Customui.setState
local _G2 = _G2
local setmetatable, ipairs = setmetatable, ipairs

-- UI namespace
-- 注意这和 UI API 名称冲突，使用 GameVM.UI 来访问 UI API
UI = {
	-- 存储所有 UIView 对象
	UIViews = {}

	-- @static_function getRootSize() 返回 UI 界面的大小
	-- @class UIView UI 界面类
	-- @class Element 元件类
	-- @class Texture 图片类
	-- @class Button 按钮类
	-- @class Label 文字类
	-- @class EditBox 输入框类
}; local UI = UI
local UIViews = UI.UIViews

-- 获取 UI 界面大小，该大小可精确到小数位
-- @return {number} UI 界面的宽度(width)
-- @return {number} UI 界面的高度(height)
local getRootSize = genv["UIEditorDef"].getRootSize
function UI:getRootSize()
	local result = getRootSize()
	return result["width"], result["height"]
end

-- UIView class
UI.UIView = {
	-- @member {string} id UI 界面的 id
	-- @member {table} textures UI 界面的子图片元件
	-- @member {table} buttons UI 界面的子按钮元件
	-- @member {table} labels UI 界面的子文字元件
	-- @member {table} editBoxes UI 界面的子输入框元件

	-- 可写成员变量:
	-- @member {function | nil} onShow UI 界面显示时回调的函数
	-- @member {function | nil} onHide UI 界面隐藏是回调的函数
	-- 注意，桌面端玩家可能会按下 esc 键意外地打开的隐藏 UI 界面

	-- @constructor UI.UIView:new()
	-- @method show(playerid) 显示 UI 界面
	-- @method hide(playerid) 隐藏 UI 界面
	-- @method setState(state, playerid) 设置 UI 界面的所有子元件的界面状态
	-- @method newTexture(elementid) 构造 Texture 对象
	-- @method newButton(elementid) 构造 Button 对象
	-- @method newLabel(elementid) 构造 Label 对象
	-- @method newEditBox(elementid) 构造 EditBox 对象
}; local UIView = UI.UIView
-- 构造一个 id 为 uiid 的 UIView 对象，如果已经构造过这样的对象则返回之
-- @param {string} uiid UI 界面的 id
-- @return 构造的 UIView 对象
function UIView:new(uiid)
	local object = UIViews[uiid]
	if object then return object
	else
		object = setmetatable({}, UIView)
		object.id = uiid
		object.textures, object.buttons = {}, {}
		object.labels, object.editBoxes = {}, {}

		Event.Connecter:new([[$ui.show]], function(param)
			if object.onShow then
				param["uiview"] = object
				object.onShow(param)
			end
		end, uiid)
		Event:connect([[$ui.hide]], function(param)
			if object.onHide then
				paprm["uiview"] = object
				object.onHide(param)
			end
		end, uiid)
		Event:connect([[$ui.onPress]], function(param)
			local button = object.buttons[param["btnelenemt"]]
			if button and button.onPress then
				param["element"] = button
				button.onPress(param)
			end
		end, uiid)
		Event:connect([[$ui.onClick]], function(param)
			local button = object.buttons[param["btnelenemt"]]
			if button and button.onClick then
				param["element"] = button
				button.onClick(param)
			end
		end, uiid)
		Event:connect([[$ui.onLostFocus]], function(param)
			local editBox = object.editBoxes[param["btnelenemt"]]
			if editBox and editBox.onLostFocus then
				param["element"] = editBox
				editBox.onLostFocus(param)
			end
		end, uiid)

		return object
	end
end

-- 显示 UI 界面
-- @param {integer | nil} playerid
-- 表示要响应 UI 操作的玩家的 id ，如果为 nil 则使用 objid 代替
-- 下文不再赘述 playerid 参数的含义
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local openUIView = Player.openUIView
function UIView:show(playerid)
	return openUIView(Player, playerid or _G2["__OBJID"], self.id) == 0
end
-- 隐藏 UI 界面
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local hideUIView = Player.hideUIView
function UIView:hide(playerid)
	return hideUIView(Player, playerid or _G2["__OBJID"], self.id) == 0
end
-- 设置 UI 界面的所有子元件的界面状态为 state
-- @param {string} state 要设置的界面状态
-- @param {integer | nil} playerid
-- @return {boolean}
-- true: API 调用成功(不代表函数正常工作) false: API 调用出错，即使只有一次出错
function UIView:setState(state, playerid)
	local result, playerid = true, playerid or _G2["__OBJID"]
	for id, element in ipairs(self.textures) do
		result = (setState(Customui, playerid, self.id, element.id, state) == 0) and result
	end
	for id, element in ipairs(self.buttons) do
		result = (setState(Customui, playerid, self.id, element.id, state) == 0) and result
	end
	for id, element in ipairs(self.labels) do
		result = (setState(Customui, playerid, self.id, element.id, state) == 0) and result
	end
	for id, element in ipairs(self.editBoxes) do
		result = (setState(Customui, playerid, self.id, element.id, state) == 0) and result
	end
	return result
end

-- Element class
-- 该类非具象类，不支持构造 Element 对象，用于其它类继承
UI.Element = {
	-- @member {table<UIView>} uiView 元件所属 UI 界面
	-- @member {string} id 元件的 id

	-- @constructor /
	-- @method show(playerid) 显示元件
	-- @method hide(playerid) 隐藏元件
	-- @method setDisplay(display, playerid) 显示或隐藏元件
	-- @method setState(state, playerid) 设置元件状态
	-- @method setPosition(x, y, playerid) 设置元件位置
	-- @method setSize(width, height, playerid) 设置元件大小
	-- @method setAngle(angle, playerid) 设置元件角度
	-- @method setColor(color, playerid) 设置元件颜色
	-- @method setAlpha(alpha, playerid) 设置元件透明度
}; local Element = UI.Element

local showElement, hideElement = Customui.showElement, Customui.hideElement
-- 显示元件
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
function Element:show(playerid)
	return showElement(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id) == 0
end
-- 隐藏元件
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
function Element:hide(playerid)
	return hideElement(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id) == 0
end
-- 显示或隐藏元件
-- @param {boolean} display true: 显示元件 false: 隐藏元件
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
function Element:setDisplay(display, playerid)
	if display then
		return showElement(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id) == 0
	else
		return hideElement(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id) == 0
	end
end
-- 设置元件的界面状态为 state
-- @param {string} state 要设置的界面状态
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
function Element:setState(state, playerid)
	return setState(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, state) == 0
end

-- 设置元件位置
-- @param {number} x 元件新位置的 x 坐标
-- @param {number} y 元件新位置的 x 坐标
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setPosition = Customui.setPosition
function Element:setPosition(x, y, playerid)
	return setPosition(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, x, y) == 0
end
-- 设置元件大小
-- @param {number} width 元件的新宽度
-- @param {number} height 元件的新高度
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setSize = Customui.setSize
function Element:setSize(width, height, playerid)
	return setSize(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, width, height) == 0
end
-- 设置元件角度
-- @param {number} angle 旋转角度，0~360之间
-- 注意该函数是 "设置" 不是 "旋转" ，旋转角度是相对于水平向右顺时针旋转的角度而言的
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local rotateElement = Customui.rotateElement
function Element:setAngle(angle, playerid)
	return rotateElement(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, angle) == 0
end

-- 设置元件颜色
-- @param {number} color 颜色新 RGB 值，一般使用形如 0xrrggbb 的格式表示
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setColor = Customui.setColor
function Element:setColor(color, playerid)
	-- 实际需要左移 8 位才能得到正确的效果
	-- 应该是因为 API 将颜色值解析为 0xrrggbbaa
	-- 这其中 alpha 被忽略，最后 8 位无效，应左移 8 位使 0xrrggb 变成 0xrrggbb00
	-- 由于 lua51 不支持位运算，使用 * 256 替代 << 8
	return setColor(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, color * 256) == 0
end
-- 设置元件透明度
-- @param {number} alpha 颜色新透明度值，0~100之间，0为完全透明，100为不透明
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setAlpha = Customui.setAlpha
function Element:setAlpha(alpha, playerid)
	return setAlpha(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, alpha) == 0
end

-- Texture class
-- 继承自 UI.Element
UI.Texture = {
	-- @constructor UI.Texture:new(uiview, elementid)
	-- @constructor UI.UIView:newTexture(elementid)
	-- @method setTexture(url, playerid) 设置图片元件图案纹理
}; Texture = UI.Texture
-- 构造一个父 UI 界面为 uiview, id 为 elementid 的 Texture 对象
-- 如果已经构造过这样的对象则返回之
-- @param {table<UIView>} uiview 元件所属父 UI 界面
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 Texture 对象
function Texture:new(uiview, elementid)
	local object = uiview.textures[elementid]
	if object then return object
	else
		object = setmetatable({}, Texture)
		object.uiView = uiview
		object.id = elementid
		uiview.images[elementid] = object
		return object
	end
end

-- 设置图片元件图案纹理
-- @param {string} url 图片 id
-- @param {integer | nil} playerid
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setTexture = Customui.setTexture
function Texture:setTexture(url, playerid)
	return setTexture(Customui.playerid or _G2["__OBJID"], self.uiView.id, self.id, url) == 0
end

-- Button class
-- 继承自 UI.Texture
UI.Button = {
	-- 可写成员变量:
	-- @member {function | nil} onPress 按钮被按下时回调的函数
	-- @member {function | nil} onClick 按钮被点击时回调的函数
	-- 注: 点击 = 按下 + 释放(该事件目前不支持)

	-- @constructor UI.Button:new(uiview, elementid)
	-- @constructor UI.UIView:newButton(elementid)
}; local Button = UI.Button
-- 构造一个父 UI 界面为 uiview, id 为 elementid 的 Button 对象
-- 如果已经构造过这样的对象则返回之
-- @param {table<UIView>} uiview 元件所属父 UI 界面
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 Button 对象
function Button:new(uiview, elementid)
	local object = uiview.buttons[elementid]
	if object then return object
	else
		object = setmetatable({}, Texture)
		object.uiView = uiview
		object.id = elementid
		uiview.buttons[elementid] = object
		return object
	end
end

-- Label class
-- 继承自 UI.Element
UI.Label = {
	-- @constructor UI.Label:new(uiview, elementid)
	-- @constructor UI.UIView:newLabel(elementid)
	-- @method setFontSize(size, playerid) 设置文本元件字体大小
	-- @method setText(text, playerid) 设置文本元件内容
}; local Label = UI.Label
-- 构造一个父 UI 界面为 uiview, id 为 elementid 的 Label 对象
-- 如果已经构造过这样的对象则返回之
-- @param {table<UIView>} uiview 元件所属父 UI 界面
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 Label 对象
function Label:new(uiview, elementid)
	local object = uiview.labels[elementid]
	if object then return object
	else
		object = setmetatable({}, Texture)
		object.uiView = uiview
		object.id = elementid
		uiview.labels[elementid] = object
		return object
	end
end

-- 设置文本元件字体大小
-- @param {number} size 新字体大小
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setFontSize = Customui.setFontSize
function Label:setFontSize(size, playerid)
	return setFontSize(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, size) == 0
end
-- 设置文本元件内容
-- @param {string} text 要显示的内容，如果字符串太长，可能不会生效
-- @return {boolean} true: API 调用成功(不代表函数正常工作) false: API 调用出错
local setText = Customui.setText
function Label:setText(text, playerid)
	return setText(Customui, playerid or _G2["__OBJID"], self.uiView.id, self.id, text) == 0
end

-- EditBox class
-- 继承自 UI.Label
UI.EditBox = {
	-- 可写成员变量:
	-- @member {function | nil} onLostFocus 输入框失去焦点时回调的函数

	-- @constructor UI.EditBox:new(uiview, elementid)
	-- @constructor UI.UIView:newEditBox(elementid)
}; local EditBox = UI.EditBox
-- 构造一个父 UI 界面为 uiview, id 为 elementid 的 EditBox 对象
-- 如果已经构造过这样的对象则返回之
-- @param {table<UIView>} uiview 元件所属父 UI 界面
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 EditBox 对象
function EditBox:new(uiview, elementid)
	local object = uiview.editBoxes[elementid]
	if object then return object
	else
		object = setmetatable({}, Texture)
		object.uiView = uiview
		object.id = elementid
		uiview.editBoxes[elementid] = object
		return object
	end
end

-- 构造一个 id 为 elementid 的子 Texture 对象(属于该 UI 界面)
-- 如果已经构造过这样的对象则返回之
-- 等价于 UI.Texture:new(self, elementid)
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 Texture 对象
function UIView:newTexture(elementid)
	return Texture:new(self, elementid)
end
-- 构造一个 id 为 elementid 的子 Button 对象(属于该 UI 界面)
-- 如果已经构造过这样的对象则返回之
-- 等价于 UI.Button:new(self, elementid)
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 Texture 对象
function UIView:newButton(elementid)
	return Button:new(self, elementid)
end
-- 构造一个 id 为 elementid 的子 Label 对象(属于该 UI 界面)
-- 如果已经构造过这样的对象则返回之
-- 等价于 UI.Label:new(self, elementid)
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 Texture 对象
function UIView:newLabel(elementid)
	return Label:new(self, elementid)
end
-- 构造一个 id 为 elementid 的子 EditBox 对象(属于该 UI 界面)
-- 如果已经构造过这样的对象则返回之
-- 等价于 UI.EditBox:new(self, elementid)
-- @param {string} element 元件的 id ，形如 [[uiid_elementid]]
-- @return 构造的 EditBox 对象
function UIView:newEditBox(elementid)
	return EditBox:new(self, elementid)
end

UIView.__index = {
	["show"] = UIView.show,
	["hide"] = UIView.hide,
	["setState"] = UIView.setState,
	["newTexture"] = UIView.newTexture,
	["newButton"] = UIView.newButton,
	["newLabel"] = UIView.newLabel,
	["newEditBox"] = UIView.newEditBox,
}
Element.__index = {
	["show"] = Element.show,
	["hide"] = Element.hide,
	["setDisplay"] = Element.setDisplay,
	["setState"] = Element.setState,
	["setPosition"] = Element.setPosition,
	["setSize"] = Element.setSize,
	["setAngle"] = Element.setAngle,
	["setColor"] = Element.setColor,
	["setAlpha"] = Element.setAlpha,
}
	Texture.__index = deepcopy(Element.__index)
	Texture.__index["setTexture"] = Texture.setTexture
		Button.__index = deepcopy(Texture.__index)
	Label.__index = deepcopy(Element.__index)
	Label.__index["setFontSize"] = Label.setFontSize
	Label.__index["setText"] = Label.setText
		EditBox.__index = deepcopy(Label.__index)
