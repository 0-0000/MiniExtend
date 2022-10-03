该文件显示了各个文件对应脚本所属作用域和依赖关系  
以下是所属作用域的表达方式：  
+ none 表示该文件对应脚本属于全局作用域
+ (ui) 表示该文件对应脚本属于 UI 作用域
+ (local) 表示内嵌作用域  该文件的内容通常被复制到脚本中的某个位置，因此它们没有真正对应的脚本  
***
以下列表表示了所属作用域和依赖关系：
+ core.lua
  + console.lua
  + debug.lua
  + object.lua
    + event.lua
      + ui.lua
      + ui_main.lua(ui)
  + time.lua
+ ide.lua(local)
