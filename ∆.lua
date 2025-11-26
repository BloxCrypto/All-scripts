local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "|||||||||||||||||||||||||||||||",
    Icon = "door-open", -- lucide icon. optional
    Author = "|||||||||||||||||||||||||||||||", -- optional
})

Window:EditOpenButton({
    Title = "|||||||||||||||||||||||||||||||",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "Beta 1.6",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 0, -- from 0 to 13
})

local Tab = Window:Tab({
    Title = "Player",
    Icon = "layers", -- optional
    Locked = false,
})

local Section = Tab:Section({ 
    Title = "Player",
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Prevent automatic notifications on first initialization
local toggleInitialized = false
local inputInitialized = false

-- Toggle to enable/disable custom walkspeed
local Toggle = Tab:Toggle({
    Title = "Toggle Walkspeed",
    Desc = "Enable custom walkspeed",
    Icon = "arrow-big-right-dash",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return
        end

        if state then
            WindUI:Notify({
                Title = "Walkspeed Enabled",
                Content = "Custom walkspeed is now active!",
                Duration = 3,
                Icon = "slash",
            })
        else
            humanoid.WalkSpeed = 16 -- reset to default
            WindUI:Notify({
                Title = "Walkspeed Disabled",
                Content = "Walkspeed has been reset to default (16).",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

-- Input to set custom walkspeed
local Input = Tab:Input({
    Title = "Walkspeed",
    Desc = "Set your walkspeed",
    Value = "16", -- default value
    InputIcon = "slash",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input)
        if not inputInitialized then
            inputInitialized = true
            return
        end

        local speed = tonumber(input)
        if speed then
            if Toggle.Value then
                humanoid.WalkSpeed = speed
                WindUI:Notify({
                    Title = "Walkspeed Updated",
                    Content = "Your walkspeed is now "..speed,
                    Duration = 3,
                    Icon = "slash",
                })
            else
                WindUI:Notify({
                    Title = "Toggle Off",
                    Content = "Enable the toggle first to apply walkspeed.",
                    Duration = 3,
                    Icon = "slash",
                })
            end
        else
            WindUI:Notify({
                Title = "Invalid Input",
                Content = "Please enter a valid number.",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Prevent automatic notifications on first initialization
local toggleInitialized = false
local inputInitialized = false

-- Toggle to enable/disable custom jumppower
local Toggle = Tab:Toggle({
    Title = "JumpPower Toggle",
    Desc = "Enable custom jumppower",
    Icon = "arrow-up-from-line",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return
        end

        if state then
            WindUI:Notify({
                Title = "JumpPower Enabled",
                Content = "Custom jumppower is now active!",
                Duration = 3,
                Icon = "slash",
            })
        else
            humanoid.JumpPower = 50 -- reset to default
            WindUI:Notify({
                Title = "JumpPower Disabled",
                Content = "JumpPower has been reset to default (50).",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

-- Input to set custom jumppower
local Input = Tab:Input({
    Title = "JumpPower",
    Desc = "Set your jumppower",
    Value = "50", -- default value
    InputIcon = "slash",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input)
        if not inputInitialized then
            inputInitialized = true
            return
        end

        local power = tonumber(input)
        if power then
            if Toggle.Value then
                humanoid.JumpPower = power
                WindUI:Notify({
                    Title = "JumpPower Updated",
                    Content = "Your jumppower is now "..power,
                    Duration = 3,
                    Icon = "slash",
                })
            else
                WindUI:Notify({
                    Title = "Toggle Off",
                    Content = "Enable the toggle first to apply jumppower.",
                    Duration = 3,
                    Icon = "slash",
                })
            end
        else
            WindUI:Notify({
                Title = "Invalid Input",
                Content = "Please enter a valid number.",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local infJumpEnabled = false

local Toggle = Tab:Toggle({
    Title = "Infinite Jump",
    Desc = "Enable or disable infinite jump",
    Icon = "move-up",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        infJumpEnabled = state

        if state then
            WindUI:Notify({
                Title = "Infinite Jump Enabled",
                Content = "You can now jump infinitely!",
                Duration = 3,
                Icon = "slash",
            })
        else
            WindUI:Notify({
                Title = "Infinite Jump Disabled",
                Content = "Infinite jump has been turned off.",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

-- Detect jump input and apply infinite jump
UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local player = game.Players.LocalPlayer

-- Prevent automatic notification on initialization
local toggleInitialized = false

local Toggle = Tab:Toggle({
    Title = "Disable Jump",
    Desc = "Enable or disable jumping",
    Icon = "circle-off",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return -- ignore first call
        end

        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if state then
            humanoid.JumpPower = 0
            WindUI:Notify({
                Title = "Jump Disabled",
                Content = "You can no longer jump!",
                Duration = 3,
                Icon = "slash",
            })
        else
            humanoid.JumpPower = 50 -- reset to default
            WindUI:Notify({
                Title = "Jump Enabled",
                Content = "Jumping has been restored!",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

local Tab = Window:Tab({
    Title = "Visual",
    Icon = "wallpaper", -- optional
    Locked = false,
})

local Section = Tab:Section({ 
    Title = "World",
})

local Lighting = game:GetService("Lighting")
local originalSettings = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    Ambient = Lighting.Ambient,
}

local toggleInitialized = false

local Toggle = Tab:Toggle({
    Title = "FullBright",
    Desc = "Enable or disable FullBright",
    Icon = "aperture",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return
        end

        if state then
            -- Enable FullBright
            Lighting.Brightness = 2 -- or higher if you like
            Lighting.ClockTime = 14 -- daytime
            Lighting.FogEnd = 100000 -- remove fog
            Lighting.Ambient = Color3.new(1, 1, 1) -- bright ambient

            WindUI:Notify({
                Title = "FullBright Enabled",
                Content = "The game is now fully bright!",
                Duration = 3,
                Icon = "slash",
            })
        else
            -- Restore original settings
            Lighting.Brightness = originalSettings.Brightness
            Lighting.ClockTime = originalSettings.ClockTime
            Lighting.FogEnd = originalSettings.FogEnd
            Lighting.Ambient = originalSettings.Ambient

            WindUI:Notify({
                Title = "FullBright Disabled",
                Content = "Lighting has been restored.",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Flags to prevent automatic notification on initialization
local toggleInitialized = false
local inputInitialized = false

-- Default FOV
local defaultFOV = camera.FieldOfView

-- Toggle to enable/disable custom FOV
local Toggle = Tab:Toggle({
    Title = "Custom FOV",
    Desc = "Enable or disable custom FOV",
    Icon = "eye",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return
        end

        if state then
            WindUI:Notify({
                Title = "Custom FOV Enabled",
                Content = "You can now set a custom FOV!",
                Duration = 3,
                Icon = "slash",
            })
            -- Apply current input value
            local fovValue = tonumber(Input.Value) or defaultFOV
            camera.FieldOfView = fovValue
        else
            camera.FieldOfView = defaultFOV
            WindUI:Notify({
                Title = "Custom FOV Disabled",
                Content = "FOV has been reset to default ("..defaultFOV..")",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

-- Input to set FOV value
local Input = Tab:Input({
    Title = "FOV Value",
    Desc = "Enter a number to set camera FOV",
    Value = tostring(defaultFOV), -- default value
    InputIcon = "chevrons-left-right-ellipsis",
    Type = "Input",
    Placeholder = "Enter FOV...",
    Callback = function(input)
        if not inputInitialized then
            inputInitialized = true
            return
        end

        local fov = tonumber(input)
        if fov then
            if Toggle.Value then
                camera.FieldOfView = fov
                WindUI:Notify({
                    Title = "FOV Updated",
                    Content = "Camera FOV is now "..fov,
                    Duration = 3,
                    Icon = "slash",
                })
            else
                WindUI:Notify({
                    Title = "Toggle Off",
                    Content = "Enable the custom FOV toggle first!",
                    Duration = 3,
                    Icon = "slash",
                })
            end
        else
            WindUI:Notify({
                Title = "Invalid Input",
                Content = "Please enter a valid number for FOV.",
                Duration = 3,
                Icon = "slash",
            })
        end
    end
})

local Section = Tab:Section({ 
    Title = "ESP",
})

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local espEnabled = false
local espColor = Color3.fromRGB(0, 255, 0)
local outlines = {}
local toggleInitialized = false

-- Function to create an ESP outline
local function createESP(character)
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    local adorn = Instance.new("BoxHandleAdornment")
    adorn.Name = "ESPOutline"
    adorn.Adornee = hrp
    adorn.AlwaysOnTop = true
    adorn.ZIndex = 10
    adorn.Size = Vector3.new(2, 5, 1)
    adorn.Transparency = 0
    adorn.Color = espColor
    adorn.Parent = workspace -- Must be parented to Workspace
    table.insert(outlines, adorn)
end

-- Remove all ESP outlines
local function clearESP()
    for _, adorn in pairs(outlines) do
        if adorn and adorn.Parent then
            adorn:Destroy()
        end
    end
    outlines = {}
end

-- Update ESP for all players
local function updateESP()
    clearESP()
    if espEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                createESP(plr.Character)
                plr.CharacterAdded:Connect(function(char)
                    if espEnabled then
                        createESP(char)
                    end
                end)
            end
        end
    end
end

-- Toggle for ESP
local Toggle = Tab:Toggle({
    Title = "ESP Outline",
    Desc = "Enable/Disable ESP Outline",
    Icon = "power",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return -- Ignore first automatic call
        end

        espEnabled = state
        updateESP()

        WindUI:Notify({
            Title = espEnabled and "ESP Enabled" or "ESP Disabled",
            Content = espEnabled and "ESP outlines are now active!" or "ESP has been turned off.",
            Duration = 3,
            Icon = "slash",
        })
    end
})

-- Colorpicker for ESP
local Colorpicker = Tab:Colorpicker({
    Title = "ESP Color",
    Desc = "Choose outline color",
    Default = espColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        espColor = color
        if espEnabled then
            updateESP()
        end
    end
})

-- Keep ESP updated for new players joining
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if espEnabled then
            createESP(char)
        end
    end)
end)

local Tab = Window:Tab({
    Title = "Server info",
    Icon = "server", -- optional
    Locked = false,
})

-- Create Paragraph
local Paragraph = Tab:Paragraph({
    Title = "Players Info", -- initial title
    Desc = "Loading...",    -- initial description
    Color = "Red",
    Image = "",             -- optional image URL
    ImageSize = 30,
    Thumbnail = "",         -- optional thumbnail URL
    ThumbnailSize = 80,
    Locked = false,
})

-- Function to update the Paragraph dynamically
local function updateParagraph()
    -- Example: player count
    local playerCount = #game.Players:GetPlayers()

    -- Example: player usernames
    local usernames = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        table.insert(usernames, plr.Name)
    end
    local usernameText = table.concat(usernames, ", ")

    -- Update the Paragraph
    Paragraph:SetTitle("Players: " .. playerCount)
    Paragraph:SetDesc("Usernames: " .. usernameText)
end

-- Initial update
updateParagraph()

-- Optional: Update when players join or leave
game.Players.PlayerAdded:Connect(updateParagraph)
game.Players.PlayerRemoving:Connect(updateParagraph)

local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

-- Create Paragraph
local Paragraph = Tab:Paragraph({
    Title = "Server Info",
    Desc = "Loading server details...",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

-- Function to update the Paragraph with server info and ping
local function updateServerParagraph()
    local success, region = pcall(function()
        return MarketplaceService:GetPlayerRegionAsync(player.UserId)
    end)
    if not success then region = "Unknown" end

    local gameId = game.GameId
    local jobId = game.JobId
    local ping = math.floor(player:GetNetworkPing() * 1000) -- convert to ms

    -- Update Paragraph
    Paragraph:SetTitle("Server Information")
    Paragraph:SetDesc(
        "Region: " .. region .. "\n" ..
        "Game ID: " .. gameId .. "\n" ..
        "Job ID: " .. jobId .. "\n" ..
        "Ping: " .. ping .. " ms"
    )
end

-- Initial update
updateServerParagraph()

-- Auto-update every 5 seconds
spawn(function()
    while true do
        updateServerParagraph()
        wait(0) -- update every 5 seconds
    end
end)

local function copyToClipboard(text, title)
    if setclipboard then
        setclipboard(text)
        WindUI:Notify({
            Title = "Copied!",
            Content = title .. " has been copied: " .. text,
            Duration = 3,
            Icon = "slash",
        })
    else
        WindUI:Notify({
            Title = "Error",
            Content = "Clipboard function not supported.",
            Duration = 3,
            Icon = "slash",
        })
    end
end

-- Copy Job ID
Tab:Button({
    Title = "Copy Job ID",
    Color = Color3.fromHex("#a2ff30"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        copyToClipboard(game.JobId, "Job ID")
    end
})

-- Copy Game ID
Tab:Button({
    Title = "Copy Game ID",
    Color = Color3.fromHex("#30d1ff"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        copyToClipboard(game.GameId, "Game ID")
    end
})

-- Copy Place ID
Tab:Button({
    Title = "Copy Place ID",
    Color = Color3.fromHex("#ff6a30"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        copyToClipboard(game.PlaceId, "Place ID")
    end
})

-- Copy Full Server Info
Tab:Button({
    Title = "Copy Server Info",
    Color = Color3.fromHex("#ff30d5"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local info = string.format(
            "Region: %s | Job ID: %s | Game ID: %s | Place ID: %s",
            (pcall(function() return game:GetService("MarketplaceService"):GetPlayerRegionAsync(game.Players.LocalPlayer.UserId) end) and 
                game:GetService("MarketplaceService"):GetPlayerRegionAsync(game.Players.LocalPlayer.UserId)) or "Unknown",
            game.JobId,
            game.GameId,
            game.PlaceId
        )
        copyToClipboard(info, "Server Info")
    end
})

local player = game.Players.LocalPlayer

-- Function to copy text safely with notification
local function copyToClipboard(text, title)
    if setclipboard then
        setclipboard(text)
        WindUI:Notify({
            Title = "Copied!",
            Content = title .. " has been copied: " .. text,
            Duration = 3,
            Icon = "slash",
        })
    else
        WindUI:Notify({
            Title = "Error",
            Content = "Clipboard function not supported.",
            Duration = 3,
            Icon = "slash",
        })
    end
end

-- Button: Copy all player names
local Button = Tab:Button({
    Title = "Copy All Player Names",
    Color = Color3.fromHex("#FF748D"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        local playerNames = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            table.insert(playerNames, plr.Name)
        end
        local text = table.concat(playerNames, ", ")
        copyToClipboard(text, "All Player Names")
    end
})

-- Dropdown: List of players
local Dropdown = Tab:Dropdown({
    Title = "Select Player",
    Desc = "Choose a player to copy their name",
    Values = {}, -- empty initially
    Value = "",  -- empty default
    Callback = function(selectedPlayer)
        copyToClipboard(selectedPlayer, "Player Name")
    end
})

-- Function to refresh dropdown manually
local function refreshPlayerDropdown()
    local names = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        table.insert(names, plr.Name)
    end
    Dropdown:Refresh(names) -- manually refresh dropdown with new player list
end

-- Initial refresh
refreshPlayerDropdown()

-- Refresh whenever a player joins or leaves
game.Players.PlayerAdded:Connect(refreshPlayerDropdown)
game.Players.PlayerRemoving:Connect(refreshPlayerDropdown)

local Tab = Window:Tab({
    Title = "Settings",
    Icon = "cog", -- optional
    Locked = false,
})

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local antiFlingEnabled = false
local toggleInitialized = false

local Toggle = Tab:Toggle({
    Title = "Anti-Fling",
    Desc = "Prevents other players from forcibly moving you",
    Icon = "shield",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if not toggleInitialized then
            toggleInitialized = true
            return -- ignore first automatic callback
        end

        antiFlingEnabled = state

        WindUI:Notify({
            Title = antiFlingEnabled and "Anti-Fling Enabled" or "Anti-Fling Disabled",
            Content = antiFlingEnabled and "You are now protected from flings!" or "Anti-Fling turned off.",
            Duration = 3,
            Icon = "slash",
        })
    end
})

-- Keep character protected if anti-fling is enabled
RunService.Stepped:Connect(function()
    if antiFlingEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables for dropdown and VIP Job ID
local selectedAction = "None"
local vipJobId = ""

-- Function to copy text safely with notification
local function sendNotification(title, content)
    WindUI:Notify({
        Title = title,
        Content = content,
        Duration = 3,
        Icon = "slash",
    })
end

-- Automatic notification on join
sendNotification("Welcome!", "You have joined the game! Current Action: "..selectedAction..(vipJobId ~= "" and "\nVIP Job ID: "..vipJobId or ""))

-- Function: Rejoin current server
local function rejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end

-- Function: Server hop
local function serverHop()
    local success, servers = pcall(function()
        local response = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        return HttpService:JSONDecode(response)
    end)

    if success and servers and servers.data then
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                return
            end
        end
    end

    sendNotification("Server Hop", "No available servers found!")
end

-- Function: Join VIP server
local function joinVIPServer()
    if vipJobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, vipJobId, LocalPlayer)
    else
        sendNotification("VIP Server", "Please enter a VIP Job ID first!")
    end
end

-- Input: VIP Job ID
local Input = Tab:Input({
    Title = "VIP Job ID",
    Desc = "Enter the Job ID of the VIP server",
    Value = "",
    InputIcon = "chevrons-left-right-ellipsis",
    Type = "Input",
    Placeholder = "Enter Job ID here...",
    Callback = function(input)
        vipJobId = input
        sendNotification("VIP Job ID Set", "VIP server Job ID updated to: "..input)
    end
})

-- Dropdown: Select action
local Dropdown = Tab:Dropdown({
    Title = "Select Action",
    Desc = "Choose what the button will do",
    Values = { "Rejoin", "Server Hop", "Join VIP" },
    Value = selectedAction,
    Callback = function(option)
        selectedAction = option
        sendNotification("Action Selected", "Button will now perform: "..option)
    end
})

-- Button: Execute selected action
local Button = Tab:Button({
    Title = "Execute Action",
    Color = Color3.fromHex("#a2ff30"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "",
    Callback = function()
        if selectedAction == "Rejoin" then
            rejoinServer()
        elseif selectedAction == "Server Hop" then
            serverHop()
        elseif selectedAction == "Join VIP" then
            joinVIPServer()
        end
    end
})