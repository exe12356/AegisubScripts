local tr = aegisub.gettext
script_name = tr "ANY Tool"
script_description = tr "Tools For PerfumeANY"
script_author = tr "Onion"
script_version = tr "1.0"
require "karaskel"
require "re"
function_tb = {"Add Staff"}

dialog_config = {
    {class = "label", label = "function:", x = 0, y = 0},
    {
        class = "checkbox",
        name = "replaceMark",
        x = 0,
        y = 1,
        width = 1,
        height = 1,
        label = "replaceMark",
        value = true
    },
    {class = "dropdown", name = "addition", items = function_tb, value = "", x = 0, y = 2}
}
staff_time_config = {
    {sTime = "570", eTime = "2610"},
    {sTime = "2610", eTime = ""},
    {sTime = "", eTime = ""},
    {sTime = "", eTime = ""},
    {sTime = "", eTime = ""},
    {sTime = "", eTime = ""},
    {sTime = "", eTime = ""}
}
staff_dialog_config = {
    [1] = {class = "label", label = "片源:", x = 0, y = 0},
    [2] = {class = "edit", name = "Source", x = 1, y = 0, width = 1, height = 1},
    [3] = {class = "label", label = "翻译:", x = 0, y = 1},
    [4] = {class = "edit", name = "Translator", x = 1, y = 1, width = 1, height = 1},
    [5] = {class = "label", label = "校对:", x = 0, y = 2},
    [6] = {class = "edit", name = "Proofreader", x = 1, y = 2, width = 1, height = 1},
    [7] = {class = "label", label = "时间轴:", x = 0, y = 3},
    [8] = {class = "edit", name = "Timeline", x = 1, y = 3, width = 1, height = 1},
    [9] = {class = "label", label = "美工:", x = 0, y = 4},
    [10] = {class = "edit", name = "Designer", x = 1, y = 4, width = 1, height = 1},
    [11] = {class = "label", label = "压制:", x = 0, y = 5},
    [12] = {class = "edit", name = "Encoder", x = 1, y = 5, width = 1, height = 1},
    [13] = {class = "label", label = "总监:", x = 0, y = 6},
    [14] = {class = "edit", name = "Director", x = 1, y = 6, width = 1, height = 1}
}
function PrintTime(subtitles, selected_lines)
    for z, i in pairs(selected_lines) do
        local l = subtitles[i]
        local sTime = l.start_time
        local eTime = l.end_time
        aegisub.debug.out(tostring(sTime .. "->" .. eTime .. "\n"))
    end
end

function addStaff(subs)
    buttons2, results = aegisub.dialog.display(staff_dialog_config, {"OK", "Cancel"})
    if buttons2 == "OK" then
        local postList = {}
        for i = 1, #staff_dialog_config do
            if (i % 2 == 0) then
                local index = tostring(staff_dialog_config[i].name)
                local post = results[index]
                if (post ~= "") then
                    local tempTbl = {}
                    local CName = tostring(staff_dialog_config[i - 1].label)
                    table.insert(tempTbl, CName)
                    table.insert(tempTbl, post)
                    table.insert(postList, tempTbl)
                end
            end
        end
        local tempLine = {}
        for i = 1, #subs, 1 do
            if (subs[i].class == "dialogue") then
                tempLine = subs[i]
                break
            end
        end
        for i = 1, #postList, 1 do
            if (i == 1) then
                local subLine1 = table.copy(tempLine)
                subLine1.layer = 0
                subLine1.start_time = 350
                subLine1.end_time = 3780
                subLine1.style = "字幕组"
                subLine1.margin_t = 35
                subLine1.text =
                    "{\\fad(800,800)\\fn微软雅黑\\b1\\2c&HFFFFFF&\\3c&H414254&\\4c&H000000&\\3a&HFF&\\4a&H00&\\i0\\shad1\\fscx93\\fscy95}PerfumeANY字幕组出品{\\4c&H000000&\\3c&H020A91&\\3a&H00&}"
                local subLine2 = table.copy(tempLine)
                subLine2.layer = 1
                subLine2.start_time = 350
                subLine2.end_time = 3780
                subLine2.style = "字幕组"
                subLine2.margin_t = 0
                subLine2.text =
                    "{\\fad(800,800)\\fn微软雅黑\\b1\\2c&HFFFFFF&\\3c&H414254&\\4c&H000000&\\3a&HFF&\\4a&H00&\\i0\\shad1\\fscx93\\fscy95}http://www%.perfumeany%.com \\N长期招人中 欢迎加入(翻译、校对、轴和压制等)\\N本作品仅供学习交流之用{\\4c&H000000&\\3c&H020A91&\\3a&H00&}"
                subs.append(subLine1)
                subs.append(subLine2)
            end

            local newLine = table.copy(tempLine)
            -- tempLine.class = "dialogue"
            newLine.layer = 0
            newLine.start_time = i == 1 and 570 or 570 + (i - 1) * 2040
            newLine.end_time = 570 + i * 2040
            newLine.style = "STAFF"
            newLine.text =
                "{\\fad(400,500)\\frz0\\t(1400,1900,2,\\frz1080)\\t(1401,1900,1,\\fscx0\\fscy0)}" ..
                tostring(postList[i][1]) .. tostring(postList[i][2])
            subs.append(newLine)
        end
    end
end
function replaceMark(subs)
    -- buttons, results = aegisub.dialog.display(dialog_config, {"OK", "Cancel"})
    -- if buttons == "OK" then
    local replaceMark = results["replaceMark"]
    if replaceMark == true then
        for i = 1, #subs, 1 do
            local l = subs[i]
            if l.class == "dialogue" then
                l.text = replaceText(l.text)
                subs[i] = l
            end
        end
    end
    -- end
    -- aegisub.set_undo_point(script_name)
end

function replaceText(text)
    local newText = ""
    newText =
        text:gsub("%[", "「"):gsub("]", "」"):gsub("<", "『"):gsub(">", "』"):gsub("A~chan", "a-chan"):gsub(
        "Nocchi",
        "NOCCHi"
    ):gsub("Kashiyuka", "KASHIYUKA")
    return newText
    -- statements
end
function script_main(subs, sel)
    buttons, results = aegisub.dialog.display(dialog_config, {"OK", "Cancel"})

    if buttons == "OK" then
        local dropItem = results["addition"]
        local cbReplaceMark = results["replaceMark"]
        if (cbReplaceMark == true) then
            replaceMark(subs)
        end
        if (dropItem == "Add Staff") then
            addStaff(subs)
        end
    end
    aegisub.set_undo_point(script_name)
    -- PrintTime(subs, sel)
end
aegisub.register_macro(script_name, script_description, script_main)
