--[=[
ide.lua
用于编辑器自动补全代码
本身全部是注释，无依赖
最后更新 : 2.1.0
]=]

--[=[
@table genv _G2 GameVM
@function loadstring2() deepcopy()

@function getObjectId() setObjectId()

@namespace Console
    @function log(...) logtag(tag, ...) warn(message) error(message) clear()

@namespace Time
    @function getTick() scheduleCall(ticks, func, ...) nextTick(func, ...)
    @class Timer
        @r createTime tick
        @rw callback(self, tick) delay
        @method new() start() pause() isRunning()

@namespace Event
    @constant [[$ui.onShow]] [[$ui.onHide]] [[$ui.onPress]] [[$ui.onClick]] [[$ui.onLostFocus]]
    @class Connecter
        @r eventName
        @rw callback(param)
        @method new() delete()

@namespace UI
    @function getRootSize()
    @class UIView
        @r id
        @rw onShow(param{uiview, ...}) onHide(param(uiview, ...))
        @method new() show(playerid) hide(playerid) setState(state, playerid)
        @methd newTexture(elementid) newButton(elementid) newLabel(elementid) newEditBox(elementid)
    @class Element
        @r uiView id
        @method show(playerid) hide(playerid) setDisplay(display, playerid) setState(state, playerid)
        @method setPosition(x, y, playerid) setSize(width, height, playerid) setAngle(angle, playerid)
        @method setColor(color, playerid) setAlpha(alpha, playerid)
    @class Texture:Element
        @method setTexture(url, playerid)
    @class Button:Texture
        @rw onPress(param{element, ...}) onClick(param{element, ...})
    @class Label:Element
        @method setFontSize(size, playerid) setText(text, playerid)
    @class EditBox:Label
        @rw onLostFocus(param{element, ...})
]=]
