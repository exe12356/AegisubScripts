local tr = aegisub.gettext

script_name = tr "add fad for song"
script_description = tr "add fad for song"
script_author = tr "Onion39"
script_version = tr "1.0"

dialog_config = {
    {x = 0, y = 0, width = 1, height = 1, class = "label", label = "\\blur"},
    {x = 1, y = 0, width = 1, height = 1, class = "floatedit", name = "blur", value = 0.6}
}
function addfad(subtitles, selected_lines)
    for z, i in pairs(selected_lines) do
        local l = subtitles[i]
        if l.class == "dialogue" then
            if (z == 1) then
                if (l.end_time == subtitles[i + 1].start_time) then
                    l.text = "{\\fad(200,0)}" .. l.text
                else
                    l.text = "{\\fad(200,200)}" .. l.text
                end
            elseif (z == #selected_lines) then
                if (l.start_time == subtitles[i - 1].end_time) then
                    l.text = "{\\fad(0,200)}" .. l.text
                else
                    l.text = "{\\fad(200,200)}" .. l.text
                end
            else
                if ((l.end_time ~= subtitles[i + 1].start_time) and (l.start_time == subtitles[i - 1].end_time)) then
                    l.text = "{\\fad(0,200)}" .. l.text
                elseif ((l.end_time == subtitles[i + 1].start_time) and (l.start_time ~= subtitles[i - 1].end_time)) then
                    l.text = "{\\fad(200,0)}" .. l.text
                elseif ((l.end_time ~= subtitles[i + 1].start_time) and (l.start_time ~= subtitles[i - 1].end_time)) then
                    l.text = "{\\fad(200,200)}" .. l.text
                end
            end
        end
        -- local
        subtitles[i] = l
    end
    aegisub.set_undo_point(script_name)
end

function addfad2(subtitles, selected_lines)
    for z, i in pairs(selected_lines) do
        local pIndex = i - 1
        local nIndex = i + 1
        local l = subtitles[i]
        if l.class == "dialogue" then
            if (z == 1 or z == 2) then
                if (l.style ~= subtitles[i + 1].style) then
                    nIndex = nIndex + 1
                end
                if (l.end_time == subtitles[nIndex].start_time) then
                    l.text = "{\\fad(200,0)}" .. l.text
                else
                    l.text = "{\\fad(200,200)}" .. l.text
                end
            elseif (z == #selected_lines or z == #selected_lines - 1) then
                if (l.style ~= subtitles[i - 1].style) then
                    pIndex = pIndex - 1
                end
                if (l.start_time == subtitles[pIndex].end_time) then
                    l.text = "{\\fad(0,200)}" .. l.text
                else
                    l.text = "{\\fad(200,200)}" .. l.text
                end
            else
                if (l.style ~= subtitles[i + 1].style) then
                    nIndex = nIndex + 1
                end
                if (l.style ~= subtitles[i - 1].style) then
                    pIndex = pIndex - 1
                end
                if ((l.end_time ~= subtitles[nIndex].start_time) and (l.start_time == subtitles[pIndex].end_time)) then
                    l.text = "{\\fad(0,200)}" .. l.text
                elseif ((l.end_time == subtitles[nIndex].start_time) and (l.start_time ~= subtitles[pIndex].end_time)) then
                    l.text = "{\\fad(200,0)}" .. l.text
                elseif ((l.end_time ~= subtitles[nIndex].start_time) and (l.start_time ~= subtitles[pIndex].end_time)) then
                    l.text = "{\\fad(200,200)}" .. l.text
                end
            end
        end
        subtitles[i] = l
    end
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, addfad2)
