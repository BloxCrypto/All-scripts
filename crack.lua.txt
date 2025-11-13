local getgenv = getgenv or getfenv
local reqIdx = 0
local old = getgenv().request
getgenv().request = function(data)
    if type(data) ~= "table" then return old(data) end

    if data.Url:find("v1/proxy/roblox_emotes") then
        coroutine.yield()
        return {
            StatusCode = 200,
            Success = true,
            StatusMessage = "HTTP/1.1 200 OK",
            Headers = {},
            Body = '{"status":200,"content":[]}'
        }
    end

    if data.Url:find("v1/proxy/mm2_values") then
        data.Url = "https://raw.githubusercontent.com/luizcrackz/overdrive-h/refs/heads/main/backup/mm2_values.json"
        return old(data)
    end

    if data.Url:find("v1/script/server/request/") then
        reqIdx += 1
        if reqIdx == 1 then
            return {
                StatusCode = 200,
                Success = true,
                StatusMessage = "HTTP/1.1 200 OK",
                Headers = {},
                Body = '{"status":200,"message":"Disconnected."}'
            }
        elseif reqIdx == 2 then
            return {
                StatusCode = 400,
                Success = false,
                StatusMessage = "HTTP/1.1 400 Bad Request",
                Headers = {},
                Body = '{"status":400,"message":"Invalid request."}'
            }
        elseif reqIdx == 3 then
            return {
                StatusCode = 200,
                Success = true,
                StatusMessage = "HTTP/1.1 200 OK",
                Headers = {},
                Body = '{"status":200,"content":["login {\\"Premium\\":\\"6cc66c706cc6c66c6cc66e606cc6c6646cc66c686cc66cc66cc66e606cc66e606cc6c66c6cc6c6c2c4ca6c60c4ca6c60\\",\\"Exclusive\\":\\"6cc66c706cc6c66c6cc66e606cc6c6646cc66c686cc66cc66cc66e606cc66e606cc6c66c6cc6c6c2c4ca6c64c4ca6c60\\",\\"PremiumPrice\\":285,\\"ExclusivePrice\\":55,\\"Username\\":\\"xlp1c2\\",\\"UserId\\":2645134467,\\"Discord_Id\\":\\"1183776221302104097\\",\\"Discord_Name\\":\\"elfandtears_ndk\\"}"]}'
            }
        elseif reqIdx == 4 then
            return {
                StatusCode = 200,
                Success = true,
                StatusMessage = "HTTP/1.1 200 OK",
                Headers = {},
                Body = '{"status":200,"content":[]}'
            }
        else
            coroutine.yield()
            return {
                StatusCode = 200,
                Success = true,
                StatusMessage = "HTTP/1.1 200 OK",
                Headers = {},
                Body = '{"status":200,"message":"OK!"}'
            }
        end
    end
end

local lp = game:GetService("Players").LocalPlayer
local isa = game.IsA
local oldidx
oldidx = hookmetamethod(game, "__index", function(a,b,...)
    if not checkcaller() then return oldidx(a,b,...) end

    if ((b == "UserId" and a == lp) or b == "CharacterAppearanceId") then
        return 2645134467
    end

    if b == "Name" and (a == lp or a == lp.Character) then
        return "xlp1c2"
    end

    if b == "DisplayName" and a == lp then
        return "Erina (CRACKED BY LUIZ)"
    end
    
    return oldidx(a,b,...) 
end)

do
    local old
    old = hookfunction(game.HttpGet, function(a,b,...)
        b = b:gsub("https://raw.githubusercontent.com/ItsJiDy/Overdrive%-H/main/Modules/", "https://raw.githubusercontent.com/luizcrackz/overdrive-h/refs/heads/main/backup/modules/")
        b = b:gsub("https://raw.githubusercontent.com/ItsJiDy/Overdrive%-H/refs/heads/main/lang/", "https://raw.githubusercontent.com/luizcrackz/overdrive-h/refs/heads/main/backup/lang/")
        
        return old(a,b,...)
    end)
end

do 
    local old
    old = hookfunction(game.HttpGetAsync, function(a,b,...)
        b = b:gsub("https://raw.githubusercontent.com/ItsJiDy/Overdrive%-H/main/Modules/", "https://raw.githubusercontent.com/luizcrackz/overdrive-h/refs/heads/main/backup/modules/")
        b = b:gsub("https://raw.githubusercontent.com/ItsJiDy/Overdrive%-H/refs/heads/main/lang/", "https://raw.githubusercontent.com/luizcrackz/overdrive-h/refs/heads/main/backup/lang/")

        return old(a,b,...)
    end)
end

getgenv().identifyexecutor = function() return "Delta", "1.0.0" end

function encode(h)
    local result = {}
    for i = 1, #h do
        local char = h:sub(i, i)
        local code = string.byte(char) * 2
        table.insert(result, string.format("%02x", code))
    end
    return table.concat(result)
end

local key = encode(encode(tostring(os.time())))
local payload = game:HttpGet("https://raw.githubusercontent.com/luizcrackz/overdrive-h/refs/heads/main/backup/main.lua")

loadstring(`ODH_ACCESS_KEY = "{key}";{payload}`)()
