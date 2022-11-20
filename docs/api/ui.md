---
title: UI 管理 CustomUI
---



# miniExtend CustomUI

对应源文件： `ui.lua` 。

原型为 `Event` ，但以面相对象方式描述界面与元件，且支持 [miniExtend Object](/api/object.html) 。

::: tip

大多数 `CustomUI` 下的函数都会包含一个 `playerid` 参数，它表示要响应该改变的<span title="通常为玩家的迷你号，单人模式下可以传递为 0 表示那个唯一玩家">玩家 ID</span>。

该参数不会被检查，如果 `playerid` 非逻辑真，则以 `objid` 代替。

:::

`CustomUI` 下的所有未表明返回值的函数或方法，一律返回 `true` ，表示<span title="调用 API 成功不一定代表函数正确工作">调用成功</span>。如果返回 `false` ，表示<span title="部分失败也视为函数失败">调用失败了</span>。

## 子类介绍

### 子类之间的关系

|子类|简介|继承|具象|
|:---:|:---:|:---:|:---:|
|`UIView`|界面||:heavy_check_mark:|
|`Element`|元件||:x:|
|`Image`|图片元件|`Element`|:heavy_check_mark:|
|`Button`|按钮元件|`Image`|:heavy_check_mark:|
|`Text`|文字元件|`Element`|:heavy_check_mark:|
|`EditBox`|输入框元件|`Text`|:heavy_check_mark:|

::: details 什么是具象类？

> 具象类是可以构造实例的类，其所有方法都已给出实现。<br/>
  非具象类是抽象类，抽象类不能构造实例，仅用于规范继承者的行为。<br/>
  当然，继承抽象类后，如果实现了其未实现的方法，就能成为具象类了。

在 Lua 中，并没有提供像 C++ 那样严谨的机制。

但程序设计需要它，所以就有了这一段。

:::

### `CustomUI.UIView` 类

一个 `CustomUI.UIView` 对象代表了一个 UI 界面。

构造函数：

```lua
-- 函数返回一个 `CustomUI.UIView` 对象
-- 其 `id` 属性为 `uiid` 。
function CustomUI:newUIView(uiid) end
```

参数：

|参数名|类型|简介|检查|
|:---:|:---:|:---:|:---:|
|`uiid`|`string`|UI 界面 ID||

::: tip uiid 用于唯一性判断。

如果 `uiid` 参数相同，构造两次 `CustomUI.UIView` 对象，等价于构造一次。

:::

成员变量：

|名称|类型|简介|可写|
|:---:|:---:|:---:|:---:|
|`id`|`string`|UI 界面 ID||
|`showCallback`|`function` \| `nil`|界面显示时调用的函数||
|`hideCallBack`|`function` \| `nil`|界面关闭时调用的函数||
|`images`|`table<Image>`|属于该界面的图片元件||
|`buttons`|`table<Button>`|属于该界面的按钮元件||
|`texts`|`table<Text>`|属于该界面的文字元件||
|`editBoxes`|`table<EditBox>`|属于该界面的输入框元件||

桌面端玩家可能会按下 `Esc` 键来意外退出 UI 界面，所以 `hideCallBack` 应是常用的的。

成员函数：

```lua
-- 对玩家打开该界面。
function CustomUI.UIView:show([playerid]) end
-- 对玩家关闭该界面。
function CustomUI.UIView:hide([playerid]) end
-- 修改所有子元件的状态。
function CustomUI.UIView:setState(state [, playerid]) end
-- 创建或获取 ID 为 `elementid` 的 `Image` 对象。
function CustomUI.UIView:newImage(elementid) end
-- 创建或获取 ID 为 `elementid` 的 `Button` 对象。
function CustomUI.UIView:newButton(elementid) end
-- 创建或获取 ID 为 `elementid` 的 `Text` 对象。
function CustomUI.UIView:newText(elementid) end
-- 创建或获取 ID 为 `elementid` 的 `EditBox` 对象。
function CustomUI.UIView:newEditBox(elementid) end
```

### `CustomUI.Element` 类

一个 `CustomUI.Element` 对象代表一个 UI 元件。

**这是一个抽象类，无法构造对象示例**，应该构造其子类的实例。

使用 `CustomUI.UIView` 对象的最后四个方法来创建元件对象。

成员变量：

|名称|类型|简介|可写|
|:---:|:---:|:---:|:---:|
|`uiView`|`table<UIView>`|所属的界面||
|`id`|`string`|元件 ID||

成员函数：

```lua
-- 对玩家打开该界面。
function CustomUI.Element:show([playerid]) end
-- 对玩家关闭该界面。
function CustomUI.Element:hide([playerid]) end
-- 修改元件显示状态。
-- 显示为`true`，否则隐藏。
function CustomUI.Element:setDisplay(state [, playerid]) end
-- 修改元件的状态。
function CustomUI.Element:setState(state [, playerid]) end
-- 如果 `x` 不为 `table` 类型，调用该重载函数。
-- 设置元件位置。
function CustomUI.Element:setPosition(x, y [, playerid]) end
-- 否则调用该重载函数。
-- 设置元件位置为 `positon["x"] or position[1], position["y"] or position[2]`。
-- 如果 `width` 不为 `table` 类型，调用该重载函数。
-- 设置元件宽度、高度。
function CustomUI.Element:setSize(width, height [, playerid]) end
-- 否则调用该重载函数。
-- 设置元件宽度为 `size["width"] or size[1]` ，高度为 `size["height"] or size[2]` 。
function CustomUI.Element:setSize(size [, playerid]) end
-- 旋转元件至 `angle`:`number` 角度。
-- 以元件位置为旋转点顺时针旋转 `angle` 度得到旋转后的元件。
function CustomUI.Element:setAngle(angle [, playerid]) end
-- 设置元件 RGB 颜色为 `color` ，取值范围为 `0x000000` ~ `0xffffff`。
-- 对于 `0xRrGgBb` 的 `color` 参数，则红色值为 `0xRr` ，绿色值为 `0xGg` ，蓝色值为 `0xBb` 。
function CustomUI.Element:setColor(color [, playerid]) end
-- 设置元件透明度为 `alpha`:`number` ， 取值范围为 `0`~`100` 。
-- 0 为完全透明， 100 为完全不透明。
function CustomUI.Element:setAlpha(alpha [, playerid] end
```

### `CustomUI.Image` 类

一个 `CustomUI.Image` 对象代表一个 UI 图片元件。

构造函数：
```lua
function CustomUI.CustomUI:newImage(elementid) end
```

成员函数：

```lua
-- 设置图片的纹理为 `url` 。
-- 可通过 "ID库" -"图片" 来获取 `url` 。
function CustomUI.Image.setTexture(url [, playerid]) end
```

### `CustomUI.Button` 类

一个 `CustomUI.Button` 对象代表一个 UI 图片元件。

构造函数：

```lua
function CustomUI.CustomUI:newButton(uiid) end
```

::: tip

你可以对一个按钮元件使用 `CustomUI.UIView:newImage(elementid);` 来获取一个 `CustomUI.Image` 对象并把元件当做图片操作，但是不建议这么做，对于 `CustomUI.Text` 和 `CustomUI.EditBox` 也如此。

:::

成员变量：

|名称|类型|简介|可写|
|:---:|:---:|:---:|:---:|
|`clickCallBack`|`function` \| `nil`|按钮点击后的回调|:heavy_check_mark:|
|`pressCallBack`|`function` \| `nil`|按钮按下后的回调|:heavy_check_mark:|

::: tip 不要混淆这些事件

点击 = 按下 + 松开。

:::

### `CustomUI.Text` 类

一个 `CustomUI.Text` 对象代表一个 UI 文本元件。

构造函数：

```lua
function CustomUI.UIview:newText(uiid) end
```

成员函数：

```lua
-- 设置文本元件的字体大小。
function CustomUI.Text:setFontSize(size [, playerid]) end
-- 设置文本元件显示的文本。
-- 如果太长，似乎不会起作用。
-- 本 API 不会导致文本被屏蔽。
function CustomUI.Text:setText(text [, playerid]) end
```

### `CustomUI.EditBox` 类

一个 `CustomUI.EditBox` 对象代表一个 UI 输入框元件。

构造函数：

```lua
function CustomUI.UIView:newText(elementid) end
```

成员变量：

|名称|类型|简介|可写|
|:---:|:---:|:---:|:---:|
|`inputCallBack`|`function` \| `nil`|输入框失去焦点后的回调|:heavy_check_mark:|

::: tip

在电脑上，输入框失去焦点即为输入完成。

:::

## 示例

### 需求

一 UI 界面 `u` 下有一个输入框元件 `e` 和一个文本 `t` ，要求如下：

- 在玩家没有输入 `e` 时， `e` 总是显示 `"输入 16 进制数"` ，开始输入时 `e` 的内容清空。
- `e` 完成输入时，尝试将其解释为 16 进制数，并转化为 10 进制数，并将结果反应在 `t`上。
- 如果输入不合法，无法将其转化，则设置 `t` 的文本为 `"错误的输入"`。

### 分析

- 要在开始输入时清空 `e` 的内容，需要处理一个 `ui.onClick` 事件。实现方法是再创建一个按钮元件，设为 `b` ，将 `e` 设为 `b` 的子集，调整 `b` 的外观并将使其刚好覆盖 `e` ，这样当玩家点击输入框开始输入时，也会触发按钮的点击事件，这时就能修改 `e` 的内容了。
- 经测试，当按钮被点击时焦点才会进入输入框，所以不要使用按下事件。
- 使用 `tonumber(e [, base])` 函数来转化数字。

### 代码

以下代码假设已经配置好 UI 相关环境了。

```lua
-- 需替换以下 id
local uiview_id, editBox_id, text_id, button_id = [[]], [[]], [[]], [[]]
uiview = CustomUI:newUIView(uiview_id)
editBox = uiview:newEditBox(editBox_id)
text = uiview:newText(text_id)
button = uiview:newButton(button_id)

-- 初始化
Event:connect([[Game.AnyPlayer.EnterGame]], function(paprm)
	uiview:show()
	text:setText("")
	editBox:setText("输入 16 进制数")
end, uiid)

button.clickCallBack = function(paprm)
	-- 清空输入框
	editBox:setText("")
end
editBox.inputCallBack = function(paprm)
	local num = tonumber(paprm["content"], 16)
	if num then
		text:setText(tostring(num))
	else
		text:setText("错误的输入")
	end
	editBox:setText("输入 16 进制数")
end
```

代码短的有点难以置信，这其中最复杂的还是在 UI 界面下创建元件并初始化状态。