--[=[
ide.lua
用于编辑器自动补全代码
本身全部是注释，无依赖
最后更新 : 3.0.0
]=]

--[=[
@table genv 内部脚本环境
@table _G2 脚本共享表
@function loadstring2(string [, chuckname]) 类似 loadstring()
@function deepcopy(table) 深拷贝表
@namespace Env 脚本环境作用域
	@static_function __init__() 初始化当前脚本环境
	@static_function indexAPI(key) 获取游戏 API 对象
	@static_function index(key) 使用旧索引方法索引全局变量

@namespace Log 日志作用域
	@static_function log(...) 在日志输出内容
	@static_function logtag(tag, ...) 在日志带标签地输出内容
	@static_function warn(message) 在日志输出警告信息 message
	@static_function error(message) 在日志输出错误信息 message
	@static_function clear() 清空日志

@function getTick() 获取当前游戏帧的帧数
@function scheduleCall(waittick, func, ...) 延时调用函数
@function nextTick(func, ...) 在下一帧调用函数
@class Timer 计时器类
    @constructor Timer:new()
	@destructor delete() 删除计时器
    @member delay 下一次调用 callback 的间隔帧数
    @member callback(self, tick) 在 delay 降至 0 时调用该函数
	@method start() 启动计时器(将 running 设为 true)
	@method pause() 暂停计时器(将 running 设为 false)
	@method isRunning() 返回计时器是否在运行

@function getObjectId() 返回当时 objid 的值
@function setObjectId(objectid) 设置 objid 的值

@table *Register* 描述事件监听的一类表
    @value msgStr API 事件名
    @value id 事件监听的 id
    @value uiId 如果是 UI 事件则为事件监听所属 UI 界面
@function registerEvent(eventname, callback [, uiid]) 监听游戏事件
@function cancelRegisterEvent(register) 取消监听游戏事件

@namespace UI 自定义 UI 作用域
	@static_function getRootSize() 获取 UI 界面大小
    @class UIView UI 界面类
        @member id UI 界面 id
        @member showEvent(param{uiview, ...}) UI 界面显示事件
        @member hideEvent(param{uiview, ...}) UI 界面隐藏事件
        @constructor UI.UIView:new(uiid)
    	@method show(playerid) 显示 UI 界面
    	@method hide(playerid) 隐藏 UI 界面
    	@method setState(state, playerid) 设置 UI 界面的所有子元件的界面状态
    	@method newTexture(elementid) 构造 Texture 对象
    	@method newButton(elementid) 构造 Button 对象
    	@method newLabel(elementid) 构造 Label 对象
    	@method newEditBox(elementid) 构造 EditBox 对象
	@class Element 元件类
        @member uiView 元件所属 UI 界面
        @member id 元件的 id
        @constructor /
        @method show(playerid) 显示元件
        @method hide(playerid) 隐藏元件
        @method setDisplay(display, playerid) 显示或隐藏元件
        @method setState(state, playerid) 设置元件状态
        @method setPosition(x, y, playerid) 设置元件位置
        @method setSize(width, height, playerid) 设置元件大小
        @method setAngle(angle, playerid) 设置元件角度
        @method setColor(color, playerid) 设置元件颜色
        @method setAlpha(alpha, playerid) 设置元件透明度
    	@class Texture 图片类
            @constructor UI.Texture:new(uiview, elementid)
            @constructor UI.UIView:newTexture(elementid)
            @method setTexture(url, playerid) 设置图片元件图案纹理
            @class Button 按钮类
                @constructor UI.Button:new(uiview, elementid)
                @constructor UI.UIView:newButton(elementid)
                @member pressEvent(param{element, ...}) 按钮按下事件
                @member clickEvent(param{element, ...}) 按钮点击事件
    	@class Label 文字类
            @constructor UI.Label:new(uiview, elementid)
        	@constructor UI.UIView:newLabel(elementid)
        	@method setFontSize(size, playerid) 设置文本元件字体大小
        	@method setText(text, playerid) 设置文本元件内容
            @class EditBox 输入框类
                @constructor UI.EditBox:new(uiview, elementid)
                @constructor UI.UIView:newEditBox(elementid)
                @member lostFocusEvent(param{element, ...}) 输入框失去焦点事件
]=]
