function Query()
    return {
        ["settings"] = {
            {
                ["name"] = "theboys",
                ["value"] = "theboys effect",
                ["type"] = "label",
            }
        },
        ["libraries"] = {
            {
                ["name"] = "theboys",
                ["tooltip"] = "where the necessary video is for theboys",
                ["path"] = "theboys",
                ["type"] = "video"
            }
        },
		["userconsent"] = {
    ["consents"] = {
        {
            ["flag"] = "ExecutePrograms",
            ["params"] = {
                "theboys video Plugin (Which is required to run it)"
            }
        },
        {
            ["flag"] = "DownloadFiles",
            ["params"] = {
                "https://cdn.discordapp.com/attachments/1068727704209342525/1141439089732747375/theboys.mp4",
            }
        },
        {
            ["flag"] = "AddToLibrary",
            ["params"] = {
                "theboys.mp4"
            }
        },
    }
}
    }   
end


-- Variables
local muteOriginalvideo = false
local material = ""
local theboys = ""
local OutputFrame = "output_frame.jpg"
local TempVideo = "tempvid.mp4"
local temp1 = "temp1.mp4"
local temp2 = "temp2.mp4"
local temp3 = "temp3.mp4"
local temp4 = "temp4.mp4"
local temp5 = "temp5.mp4"
local failed = false
local indexoffset = 0

function StartGeneration(options, pluginSettings, functions)
    if not functions.libraryHasFile("video", "theboys", "theboys.mp4") then
        functions.downloadFile("https://cdn.discordapp.com/attachments/1068727704209342525/1141439089732747375/theboys.mp4", "video", "theboys")
        functions.addToLibrary("video", "theboys", "theboys.mp4")
    end
	material = functions.getRandomLibraryFile("video", "materials")
    theboys = functions.getRandomLibraryFile("video", "theboys")
	functions.runFFprobe("-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 \"" .. theboys .. "\"")
    return true
end

function PostCommand(commandindex, outputresult, errorresult, options, pluginSettings, functions)
functions.runFFprobe("-v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 \"" .. material .. "\"")
if commandindex == 1+indexoffset then
    functions.runFFmpeg("-i \"" .. material .. "\" -c:v libx264 -preset ultrafast -crf 18 -vf scale=" .. options.width .. ":" .. options.height .. ",setsar=1:1,fps=fps=30 -y  \"" .. temp1 .. "\"")
elseif commandindex == 2+indexoffset then
    functions.runFFmpeg("-i \"" .. material .. "\" -c:v libx264 -preset ultrafast -crf 18 -vf scale=" .. options.width .. ":" .. options.height .. ",setsar=1:1,fps=fps=30 -y \"" .. TempVideo .. "\"")
elseif commandindex == 3+indexoffset then
    functions.runFFmpeg("-i \"" .. temp1 .. "\" -t 8.6 -c:v copy -c:a -y \"" .. temp2 .. "\"")
elseif commandindex == 4+indexoffset then
    functions.runFFmpeg("-ss 8.6 -i \"" .. TempVideo .. "\" -vframes 1 -y \"" .. OutputFrame .. "\"")
elseif commandindex == 5+indexoffset then
    functions.runFFmpeg("-loop 1 -t 7.4 -i \"" .. OutputFrame .. "\" -c:v libx264 -pix_fmt yuv420p -y \"" .. temp3 .. "\"")
elseif commandindex == 6+indexoffset then
    functions.runFFmpeg("-i \"" .. temp3 .. "\" -i \"" .. temp2 .. "\" -filter_complex '[0:v]pad=iw:ih*2:0:0[intv];[intv][1:v]overlay=0:H/2[vid]' -map [vid] -c:v libx264 -crf 22 -preset veryfast \"" .. temp4 .. "\"")
	elseif commandindex == 7+indexoffset then
    functions.runFFmpeg("-i \"" .. theboys .. "\" -c:v libx264 -preset ultrafast -crf 0 -vf scale=" .. options.width .. ":" .. options.height .. ",setsar=1:1,fps=fps=30 -y \"" .. temp5 .. "\"")
elseif commandindex == 8+indexoffset then
    functions.runFFmpeg("-i \"" .. temp4 .. "\" -i \"" .. temp5 .. "\" -filter_complex \"[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[v][a]\" -map \"[a]\" -map \"[v]\" -c:v libx264 -preset ultrafast -crf 0 \"" .. options.outputVideo .. "\"")
end
end

function StopGeneration(options, pluginSettings, functions)
    return not failed
end
