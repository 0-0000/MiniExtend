-- 作者: 0-0000 <github.com/0-0000/> <a259098@foxmail.com>
--[=[
convert_html.lua
转化 markdown 保存为 html 后的格式
最后更新 : 2.1.0
]=]

local documents = {
    ["index.html"] = "MiniExtend 文档",
    ["document.html"] = "MiniExtend 文档",
    ["environment.html"] = "MiniExtend 搭建环境",
    ["core.html"] = "MiniExtend Core",
    ["console.html"] = "MiniExtend Console",
    ["time.html"] = "MiniExtend Time",
    ["object.html"] = "MiniExtend Object",
    ["event.html"] = "MiniExtend Event",
    ["ui.html"] = "MiniExtend UI",
    ["script.html"] = "迷你世界脚本",
}
local CONVERT_SIGN = "<!-- converted -->"
local STYLE_PATTERN = "<style>.*</style>"
local CONVERT_STYLE = '<link rel="stylesheet" type="text/css" href="./css/markdown.css" />'
local TITLE_PATTERN = "<title>.*</title>"
local HEAD_PATTERN = "%s%s%s%s%s%s<!DOCTYPE html>"
local CONVERT_HEAD = "<!-- converted -->\n<!DOCTYPE html>"
local TAB_PATTERN = "\n%s+<"
local CODE_PATTERN = "<textarea>.*</textarea>"
-- 仓库绝对路径
local ABSOLUTE_PATTERN = "D:\\GitRepositories\\MiniExtend\\docs"

-- 循环文档表转化 html 文档
for fileName, titleName in pairs(documents) do
local file = io.open(fileName, "r")

-- 判断是否已转化
local sign = file:read(18)
if sign ~= CONVERT_SIGN then
    -- 转化字符串
    file:seek("set", 0)
    local fileStr = file:read("*a")
    fileStr = string.gsub(fileStr,  STYLE_PATTERN, CONVERT_STYLE)
    fileStr = string.gsub(fileStr,  TITLE_PATTERN, "<title>"..titleName.."</title>")
    fileStr = string.gsub(fileStr,  HEAD_PATTERN, CONVERT_HEAD)
    fileStr = string.gsub(fileStr, ABSOLUTE_PATTERN, ".")
    fileStr = string.gsub(fileStr, CODE_PATTERN, function(s)
        return table.concat({"<pre><code>", string.sub(s, 11, -12),
            "</code></pre>"})
    end)
    -- 移除缩进
    fileStr = string.gsub(fileStr, TAB_PATTERN, "\n<")


    -- 输出到文件中
    file:close()
    file = io.open(fileName, "w")
    file:write(fileStr)
end
file:close()
end
