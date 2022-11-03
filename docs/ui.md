# miniExtend CustomUI #
对应源文件： `ui.lua` 。  
## 自定义 UI 界面管理 <code style="color:green;">CustomUI</code> ##
miniExtend Event 原型为 `Customui` ，但以面相对象方式描述界面与元件，且支持 [miniExtend Object](./object.html) 。  
注意，大多数 `CustomUI` 下的函数都会包含一个 `[, playerid]` 参数，它表示要响应该改变的<a title="通常为玩家的迷你号，单人模式下可以传递为 0 表示那个唯一玩家">玩家 id</a> ，该参数不会被检查，如果 `playerid` 的布尔值为 `false` （包括 `nil` 与 `false`），则以 `objid` 代替。  
`CustomUI` 下的所有未表明返回值的函数或方法，一律返回 `true` 表示<a title="调用 API 成功不一定代表函数正确工作">调用 API 成功</a>，返回 `false` 表示<a title="部分失败也视为函数失败">失败</a>。  

## `CustomUI` 下的类之间的关系 ##
> [`CustomUI.UIView`](#UIView) UI 界面类  
> 该类管理 `CustomUI.Element` （其子类）对象。   
> 
> [`CustomUI.Element`](#Element) UI 元件类  
> 该类在 miniExtend 中并没有提供构造函数，因为在 UI 界面中创建的元件必定是其子类所指元件类型。  
> 之所以定义这个类，是因为不同种元件也有许多相同的方法。  
> 这个类包含了 UI 元件的基本操作，这些操作可应用于所有元件。  
> > [`CustomUI.Image`](#Image) UI 图片元件类  
> > `CustomUI.Image` 对象管理 UI 界面下的图片元件，**继承**自 `CustomUI.Element` 。  
> > 该类只额外提供了一个 `setTexture(url [, playerid])` 方法。  
> > > [`CustomUI.Button`](#Button) UI 按钮元件类  
> > > `CustomUI.Button` 对象管理 UI 界面下的按钮元件，**继承**自 `CustomUI.Image` 。  
> > > 该类相比父类并没有提供额外的方法，但提供了两个参数 `pressCallBack` 和 `clickCallBack` ，它们允许你处理按钮事件。  
> > 
> > [`CustomUI.Text`](#Text) UI 文本元件类  
> > `CustomUI.Text` 对象管理 UI 界面下的文本元件，**继承**自 `CustomUI.Element` 。  
> > 该类额外提供了两个方法： `setFontSize(size [, playerid]` 和 `setText(text [, playerid])` 。  
> > > [`CustomUI.EditBox`](#EditBox) UI 输入框元件类  
> > > `CustomUI.EditBox` 对象管理 UI 界面下的输入框元件，**继承**自 `CustomUI.Text` 。  
> > > 该类额外提供了一个参数 `inputCallBack` ，它允许你处理输入框事件。  

## <code id="UIView">CustomUI.UIView</code> 类 ##
一个 `CustomUI.UIView` 对象代表了一个 UI 界面。  
### 构造 ###
- 使用 `CustomUI:newUIView(uiid);` 来构造一个 `CustomUI.UIView` 对象。  
- `uiid` ： `string` 类型，指定该 UI 界面的 id ，该参数不会被检查。  
- 函数返回一个 `CustomUI.UIView` 对象，其 [`id` 属性](#Element-id)为 `uiid` 。  
- 如果存在，<a id="create-get">该函数会返回已有的</a> `CustomUI.UIView` 对象。在同一作用域下，如果你已经构造一个 `id` 相同的 `CustomUI.UIView` 对象，再使用同样的 `uiid` 参数来构造，会返回之前构造的对象，也就是两次返回的对象的内存地址相同。  
### 属性 ###
- `id` ： `string` 类型， UI 界面的 id ，等于调用 `CustomUI:newUIView()` 时传递的 `uiid` 属性。  
- `showCallBack` ： 默认为 `nil` ，如果有则为 `function` 类型，指定当 UI 界面显示时回调的函数，你可以修改它来改变 UI 界面显示时回调的函数。  
- `hideCallBack` ： 默认为 `nil` ，如果有则为 `function` 类型，指定当 UI 界面隐藏时回调的函数，类似 `showCallBack` 。这比 `showCallBack` 属性有用，因为桌面端玩家可能会按下 `Esc` 键来意外退出 UI 界面。  
- `images` ： `table` 类型，包含属于该界面的 `CustomUI.Image` 对象。  
- `buttons` ： `table` 类型，包含属于该界面的 `CustomUI.Button` 对象。  
- `texts` ： `table` 类型，包含属于该界面的 `CustomUI.Text` 对象。  
- `editBoxes` ： `table` 类型，包含属于该界面的 `CustomUI.EditBox` 对象。  
### 方法 ###
- <code id="UIView-show">show([playerid])</code> ：使玩家打开该 UI 界面。  
- `hide([playerid])` ：使玩家隐藏该 UI 界面。  
- `setState(state [, playerid])` ：设置该 UI 界面创建过的所有**元件对象所指元件**的状态为 `state`:`string` ，参见 [`CustomUI.Element.setState(state [, playerid])`](#Element-setState)。  
- `newImage(elementid)` ：[创建或获取已有的](#create-get) id 为 `elementid`:`string` 的 `CustomUI.Image` 对象。  
- `newButton(elementid)` ：创建或获取已有的 id 为 `elementid`:`string` 的 `CustomUI.Button` 对象。  
- `newText(elementid)` ：创建或获取已有的 id 为 `elementid`:`string` 的 `CustomUI.Text` 对象。  
- `newEditBox(elementid)` ：创建或获取已有的 id 为 `elementid`:`string` 的 `CustomUI.EditBox` 对象。  

## <code id="Element">CustomUI.Element</code> 类 ##
一个 `CustomUI.Element` 对象代表一个 UI 元件。  
并没有直接创建 `CustomUI.Element` 对象的构造函数，应该构造其子类的实例，使用 `CustomUI.UIView` 对象的最后四个方法来创建元件对象。  
### 属性 ###
- `uiView` ： `table` 类型，元件所属 `CustomUI.UIView` 对象。  
- <code id="Element-id">id</code> ： `stirng` 类型，元件的 id ，等于构造该元件对象时传递的 `elementid` 参数。  
### 方法 ###
- `show([playerid])` ：显示该元件。  
- `hide([playerid])` ：隐藏该元件。  
- `setDisplay(display [, playerid])` ：设置元件的显示状态，如果 `display`:`boolean` 为 `true` ,显示元件，否则隐藏元件。  
- <code id="Element-setState">setState(state [, playerid])</code> ：设置元件的状态为 `state`:`string` 。  
- `setPosition(x, y [, playerid])` ：如果 `x` 不为 `table` 类型，调用该重载函数，设置元件的位置为 (`x, y`) 。  
- `setPosition(position [, playerid])` ：否则调用该重载函数，设置元件的位置为 (`positon["x"] or position[1], position["y"] or position[2]`) 。  
- `setSize(width, height [, playerid])` ：如果 `width` 不为 `table` 类型，调用该重载函数，设置元件宽度为 `width` ，高度为 `height` 。  
- `setSize(size [, playerid])` ：否则调用该重载函数，设置元件宽度为 `size["width"] or size[1]` ，高度为 `size["height"] or size[2]` 。  
- `setAngle(angle [, playerid])` ：旋转元件至 `angle`:`number` 角度，将**原始元件（角度为 0 ）**以__元件位置__为旋转点**顺时针**旋转 `angle`:`number` 度得到旋转后的元件。  
- `setColor(color [, playerid])` ：设置元件 RGB 颜色为 `color`:`number` ，取值范围为 `0x000000`~`0xffffff`，对于 `0xRrGgBb` 的 `color` 参数，则红色值为 `0xRr` ，绿色值为 `0xGg` ，蓝色值为 `0xBb` 。  
- `setAlpha(alpha [, playerid]` ：设置元件透明度为 `alpha`:`number` ， 取值范围为 `0`~`100` ，0 为完全透明， 100 为完全不透明。  

## <code id="Image">CustomUI.Image</code> 类 ##
一个 `CustomUI.Image` 对象代表一个 UI 图片元件。  
使用 `CustomUI.UIView:newImage(elementid);` 来创建一个 `CustomUI.Image` 对象。  
### `setTexture(url [, playerid])` 方法 ###
- `url` 的类型为 `string` 。  
- 设置图片的纹理为 `url` 。  
- 可以通过 "ID库" -> "图片" 来获取 `url` 。  

## <code id="Button">CustomUI.Button</code> 类 ##
一个 `CustomUI.Button` 对象代表一个 UI 图片元件。  
使用 `CustomUI.UIView:newButton(elementid);` 来创建一个 `CustomUI.Image` 对象。  
注：你可以对一个按钮元件使用 `CustomUI.UIView:newImage(elementid);` 来获取一个 `CustomUI.Image` 对象并把元件当做图片操作，但是不建议这么做，对于 `CustomUI.Text` 和 `CustomUI.EditBox` 也如此。  
### `pressCallBack` 属性 ###
- 该属性默认为 `nil` ，如果有则为 `function` 类型，指定当所指按钮被按下时回调的函数，你可以修改它来改变回调的函数。  
- 与 `Event:connect([[ui.onPress]], pressCallBack, uiid)` 类似，会传递一个哈希表作为参数，但表会额外包含 `element` 键，表示这个对象。  
### `clickCallBack` 属性 ###
- 该属性与 `pressCallBack` 属性类似，但在按钮被点击时回调。  
注：点击=按下+释放，不要混淆这些事件。  

## <code id="Text">CustomUI.Text</code> 类 ##
一个 `CustomUI.Text` 对象代表一个 UI 文本元件。  
使用 `CustomUI.UIView:newText(elementid);` 来创建一个 `CustomUI.Text` 对象。  
### `setFontSize(size [, playerid])` 方法 ###
- `size` 的类型为 `number` ，取值范围为正整数。  
- 设置文本元件的字体大小为 `size` 。  
- 要想知道多大的 `size` 是合适的，你可以在 UI 编辑器中测试。  
### `setText(text [, playerid])` 方法 ###
- `text` 的类型为 `string` 。  
- 设置文本元件显示的文本为 `text` 。  
- 如果 `text` 太长，这似乎不会起作用。  
- 这不会导致文本被屏蔽。  

## <code id="EditBox">CustomUI.EditBox</code> 类 ##
一个 `CustomUI.EditBox` 对象代表一个 UI 输入框元件。  
使用 `CustomUI.UIView:newText(elementid);` 来创建一个 `CustomUI.Text` 对象。  
### `inputCallBack` 属性 ###
- 该属性默认为 `nil` ，如果有则为 `function` 类型，指定当所指输入框失去焦点（可当做玩家完成输入框的输入）时回调的函数，你可以修改它来改变回调的函数。  
- 和 `CustomUI.Button` 对象的 `clickCallBack` 属性类似，也会传递参数，且额外包含 `element` 键。  
- `content`:`string` 是事件中最有用的参数，表示输入框输入的信息。  
- 如果输入被屏蔽， `content` 也会是屏蔽后的结果。  
## 实例 ##
### 情形 ###
已知一 UI 界面 `u` 下有一个输入框元件 `e` 和一个文本 `t` ，要求如下：  

- 在玩家没有输入 `e` 时， `e` 总是显示 `"输入 16 进制数"` ，开始输入时 `e` 的内容清空
- `e` 完成输入时，尝试将其解释为 16 进制数，并转化为 10 进制数，并将结果反应在 `t`上。  
- 如果输入不合法，无法将其转化，则设置 `t` 的文本为 `"错误的输入"`  

### 分析 ###

- 要在开始输入时清空 `e` 的内容，需要处理一个 `ui.onClick` 事件。实现方法是再创建一个按钮元件，设为 `b` ，将 `e` 设为 `b` 的子集，调整 `b` 的外观并将使其刚好覆盖 `e` ，这样当玩家点击输入框开始输入时，也会触发按钮的点击事件，这时就能修改 `e` 的内容了。  
- 经测试，当按钮被点击时焦点才会进入输入框，所以不要使用按下事件。  
- 使用 `tonumber(e [, base])` 函数来转化数字。  
### 代码 ###
以下代码假设已经配置好 UI 了。  

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
代码短的有点难以置信，这其中最复杂的还是在 UI 界面下创建元件并初始化状态。  
