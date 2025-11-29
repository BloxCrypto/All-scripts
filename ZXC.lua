local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ZXC frost",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "ZXC frost",
   LoadingSubtitle = "by Frost",
   ShowText = "ZXC", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = Folder, -- Create a custom folder for your hub/game
      FileName = "Configs"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Info", "rewind")

local Players = game:GetService("Players")

local Paragraph = Tab:CreateParagraph({
    Title = "Loading players...",
    Content = "Please wait"
})

local function UpdatePlayerInfo()
    local playerList = Players:GetPlayers()
    local count = #playerList

    -- Gather all player names
    local names = {}
    for _, plr in ipairs(playerList) do
        table.insert(names, plr.Name)
    end

    -- Update the paragraph
    Paragraph:Set({
        Title = "Players Online: " .. count,
        Content = table.concat(names, "\n") -- each player on a new line
    })
end

-- Initial update
UpdatePlayerInfo()

-- Update when someone joins or leaves
Players.PlayerAdded:Connect(UpdatePlayerInfo)
Players.PlayerRemoving:Connect(UpdatePlayerInfo)

local Paragraph = Tab:CreateParagraph({
    Title = "Server Info",
    Content = "Loading..."
})

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Marketplace = game:GetService("MarketplaceService")

local gameId = game.GameId
local gameInfo = Marketplace:GetProductInfo(gameId)

-- Roblox does NOT give exact region, so we use a placeholder
local region = "Roblox does NOT give exact region"

local jobId = game.JobId
local gameName = gameInfo.Name

local function UpdateServerInfo()
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

    Paragraph:Set({
        Title = "Server Information",
        Content =
            "Region: " .. region .. "\n" ..
            "Ping: " .. ping .. " ms\n" ..
            "JobId: " .. jobId .. "\n" ..
            "GameId: " .. gameId .. "\n" ..
            "Game Name: " .. gameName
    })
end

-- Update ping every 1 second
task.spawn(function()
    while true do
        UpdateServerInfo()
        task.wait(1)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Function to build player name list
local function GetPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

-- Create the dropdown
local Dropdown = Tab:CreateDropdown({
    Name = "Spectate Player",
    Options = GetPlayerNames(),
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "SpectateDropdown",
    Callback = function(Option)
        local targetName = Option[1]
        local targetPlayer = Players:FindFirstChild(targetName)

        if targetPlayer and targetPlayer.Character then
            local hum = targetPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                Camera.CameraSubject = hum
            end
        end
    end,
})

-- Function to refresh spectate list
local function RefreshSpectateList()
    Dropdown:Refresh(GetPlayerNames())
end

-- Auto-refresh on player join/leave
Players.PlayerAdded:Connect(RefreshSpectateList)
Players.PlayerRemoving:Connect(RefreshSpectateList)

-- Button to stop spectating
local StopButton = Tab:CreateButton({
    Name = "Stop Spectating",
    Callback = function()
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                Camera.CameraSubject = hum
            end
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRP = character:WaitForChild("HumanoidRootPart")

local function GetPlayerNames()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

local Button = Tab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        if not selectedPlayer then return end

        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            humanoidRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end,
})

local selectedPlayer = nil

local Dropdown = Tab:CreateDropdown({
    Name = "Select Player To TP",
    Options = GetPlayerNames(),
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "TPDropdown",
    Callback = function(option)
        selectedPlayer = option[1]  -- store the selected name
    end,
})

local function RefreshList()
    Dropdown:Refresh(GetPlayerNames())
end

Players.PlayerAdded:Connect(RefreshList)
Players.PlayerRemoving:Connect(RefreshList)

local Tab = Window:CreateTab("Player", "rewind")

local Players = game:GetService("Players")
local user = Players.LocalPlayer
local character = user.Character or user.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local savedWalkspeed = humanoid.WalkSpeed  -- default (usually 16)
local customWalkspeed = savedWalkspeed     -- value from the input

local Toggle = Tab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(enabled)
        if enabled then
            humanoid.WalkSpeed = customWalkspeed
        else
            humanoid.WalkSpeed = savedWalkspeed
        end
    end,
})

local Input = Tab:CreateInput({
    Name = "WalkSpeed Value",
    CurrentValue = "",
    PlaceholderText = "Enter speed",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        local number = tonumber(Text)

        if number then
            customWalkspeed = number
        else
            warn("Invalid WalkSpeed input")
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local defaultJumpPower = humanoid.JumpPower  -- usually 50
local customJumpPower = defaultJumpPower     -- changed by input

local Toggle = Tab:CreateToggle({
    Name = "Enable JumpPower",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(enabled)
        if enabled then
            humanoid.JumpPower = customJumpPower
        else
            humanoid.JumpPower = defaultJumpPower
        end
    end,
})

local Input = Tab:CreateInput({
    Name = "JumpPower Value",
    CurrentValue = "",
    PlaceholderText = "Enter jump power",
    RemoveTextAfterFocusLost = false,
    Flag = "JumpPowerInput",
    Callback = function(Text)
        local number = tonumber(Text)

        if number then
            customJumpPower = number
        else
            warn("Invalid JumpPower input!")
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local tpWalkEnabled = false
local tpDistance = 5   -- default

local Toggle = Tab:CreateToggle({
    Name = "Enable TP Walk",
    CurrentValue = false,
    Flag = "TPWalkToggle",
    Callback = function(Value)
        tpWalkEnabled = Value
    end,
})

local Input = Tab:CreateInput({
    Name = "TP Walk Distance",
    CurrentValue = "",
    PlaceholderText = "Enter distance",
    RemoveTextAfterFocusLost = false,
    Flag = "TPWalkInput",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            tpDistance = num
        else
            warn("Invalid TP Walk distance")
        end
    end,
})

UserInputService.InputBegan:Connect(function(input)
    if not tpWalkEnabled then return end
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    if input.KeyCode == Enum.KeyCode.W then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -tpDistance)
    elseif input.KeyCode == Enum.KeyCode.S then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, tpDistance)
    elseif input.KeyCode == Enum.KeyCode.A then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(-tpDistance, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(tpDistance, 0, 0)
    end
end)

local Tab = Window:CreateTab("Visual", 4483362458) -- Title, Image

local Section = Tab:CreateSection("World")

local Lighting = game:GetService("Lighting")

-- Save original lighting settings
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient
}

local Toggle = Tab:CreateToggle({
    Name = "FullBright",
    CurrentValue = false,
    Flag = "FullBrightToggle",
    Callback = function(enabled)
        if enabled then
            -- Enable FullBright
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        else
            -- Restore original lighting
            Lighting.Brightness = originalLighting.Brightness
            Lighting.ClockTime = originalLighting.ClockTime
            Lighting.GlobalShadows = originalLighting.GlobalShadows
            Lighting.Ambient = originalLighting.Ambient
        end
    end,
})

local Camera = workspace.CurrentCamera

-- Save original FOV
local defaultFOV = Camera.FieldOfView
local customFOV = defaultFOV
local FOVEnabled = false

local Toggle = Tab:CreateToggle({
    Name = "Enable Custom FOV",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value)
        FOVEnabled = Value
        if FOVEnabled then
            Camera.FieldOfView = customFOV
        else
            Camera.FieldOfView = defaultFOV
        end
    end,
})

local Input = Tab:CreateInput({
    Name = "Set FOV",
    CurrentValue = "",
    PlaceholderText = "Enter FOV value",
    RemoveTextAfterFocusLost = false,
    Flag = "FOVInput",
    Callback = function(Text)
        local number = tonumber(Text)
        if number then
            customFOV = number
            if FOVEnabled then
                Camera.FieldOfView = customFOV
            end
        else
            warn("Invalid FOV input!")
        end
    end,
})

local Section = Tab:CreateSection("ESP")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Table to hold ESP outlines
local ESPs = {}

-- Default color
local espColor = Color3.fromRGB(255, 255, 255)
local ESPEnabled = false

-- Function to create ESP for a character
local function AddESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end

    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    -- Create box outline
    local box = Drawing.new("Square")
    box.Color = espColor
    box.Thickness = 2
    box.Visible = ESPEnabled
    box.Filled = false
    ESPs[player] = box
end

-- Remove ESP
local function RemoveESP(player)
    if ESPs[player] then
        ESPs[player]:Remove()
        ESPs[player] = nil
    end
end

-- Update ESP positions every frame
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    for player, box in pairs(ESPs) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                box.Position = Vector2.new(pos.X - 25, pos.Y - 25)
                box.Size = Vector2.new(50, 50)
                box.Color = espColor
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)

-- Toggle ESP
local Toggle = Tab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESP_Toggle",
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                AddESP(player)
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                RemoveESP(player)
            end
        end
    end,
})

-- Color Picker
local ColorPicker = Tab:CreateColorPicker({
    Name = "ESP Box color",
    Color = espColor,
    Flag = "ESP_ColorPicker",
    Callback = function(Value)
        espColor = Value
        for _, box in pairs(ESPs) do
            box.Color = espColor
        end
    end
})

-- Add/Remove ESP when players join/leave
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        AddESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Table to hold ESP highlights
local ESPs = {}
local espColor = Color3.fromRGB(255, 255, 255)
local ESPEnabled = false

-- Function to add ESP highlight
local function AddESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    if ESPs[player] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPOutline"
    highlight.Adornee = player.Character
    highlight.FillTransparency = 1           -- invisible inside
    highlight.OutlineTransparency = 0       -- fully visible outline
    highlight.OutlineColor = espColor
    highlight.Enabled = ESPEnabled
    highlight.Parent = game:GetService("CoreGui")  -- safe parent
    ESPs[player] = highlight
end

-- Function to remove ESP highlight
local function RemoveESP(player)
    if ESPs[player] then
        ESPs[player]:Destroy()
        ESPs[player] = nil
    end
end

-- Toggle ESP
local Toggle = Tab:CreateToggle({
    Name = "ESP Outline",
    CurrentValue = false,
    Flag = "ESP_Toggle",
    Callback = function(Value)
        ESPEnabled = Value
        for player, highlight in pairs(ESPs) do
            highlight.Enabled = ESPEnabled
        end
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                AddESP(player)
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                RemoveESP(player)
            end
        end
    end,
})

-- Color Picker
local ColorPicker = Tab:CreateColorPicker({
    Name = "ESP Color",
    Color = espColor,
    Flag = "ESP_ColorPicker",
    Callback = function(Value)
        espColor = Value
        for _, highlight in pairs(ESPs) do
            highlight.OutlineColor = espColor
        end
    end
})

-- Add/remove ESP when players join/leave
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        AddESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

local Tab = Window:CreateTab("Server", 4483362458) -- Title, Image

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local ChatDisabled = false

local Toggle = Tab:CreateToggle({
    Name = "Disable Chat",
    CurrentValue = false,
    Flag = "DisableChatToggle",
    Callback = function(Value)
        ChatDisabled = Value

        if ChatDisabled then
            -- Disable the Roblox chat
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
            -- Optionally also disable the backpack GUI
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)  -- keep backpack, remove if needed
        else
            -- Re-enable the Roblox chat
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        end
    end,
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local ChatBubblesDisabled = false

local Toggle = Tab:CreateToggle({
    Name = "Disable Chat Bubbles",
    CurrentValue = false,
    Flag = "DisableChatBubbles",
    Callback = function(Value)
        ChatBubblesDisabled = Value

        if ChatBubblesDisabled then
            -- Disable chat bubbles
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.ChatBubbles, false)
        else
            -- Re-enable chat bubbles
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.ChatBubbles, true)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) -- optional: restore main chat
        end
    end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Make sure only one player can use this
local autoKillOwner = nil

-- Flag for loop
local autoKillEnabled = false

-- Function to attack other players
local function AutoKillLoop()
    while autoKillEnabled do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                -- Example: reduce Humanoid health
                local hum = player.Character.Humanoid
                if hum.Health > 0 then
                    hum.Health = 0  -- kills the player
                end
            end
        end
        task.wait(0.5)  -- loop interval
    end
end

-- Toggle
local Toggle = Tab:CreateToggle({
    Name = "Auto Kill Loop",
    CurrentValue = false,
    Flag = "AutoKillToggle",
    Callback = function(Value)
        if Value then
            if autoKillOwner and autoKillOwner ~= LocalPlayer then
                warn("Another player is already using the Auto Kill Loop!")
                Toggle:Set(false)  -- reset toggle
                return
            end
            autoKillOwner = LocalPlayer
            autoKillEnabled = true
            task.spawn(AutoKillLoop)  -- start loop
        else
            autoKillEnabled = false
            autoKillOwner = nil
        end
    end,
})

local Tab = Window:CreateTab("Settings", "rewind")

local Themes = {
    ["Default"] = "Default",
    ["Amber Glow"] = "AmberGlow",
    ["Amethyst"] = "Amethyst",
    ["Bloom"] = "Bloom",
    ["Dark Blue"] = "DarkBlue",
    ["Green"] = "Green",
    ["Light"] = "Light",
    ["Ocean"] = "Ocean",
    ["Serenity"] = "Serenity"
}

-- Create dropdown
local ThemeDropdown = Tab:CreateDropdown({
    Name = "Theme",
    Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Flag = "ThemeDropdown",
    Callback = function(option)
        local selected = option[1]
        local themeId = Themes[selected]

        if themeId then
            Window.ModifyTheme(themeId)
        end
    end,
})

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local selectedAction = "Rejoin"
local jobIdInput = ""

-- Dropdown
local Dropdown = Tab:CreateDropdown({
    Name = "Select Action",
    Options = {"Rejoin", "ServerHop", "JoinSmallServer", "JoinByJobId"},
    CurrentOption = {"Rejoin"},
    MultipleOptions = false,
    Flag = "ActionDropdown",
    Callback = function(option)
        selectedAction = option[1]
    end,
})

-- Input for JobId
local Input = Tab:CreateInput({
    Name = "JobId Input",
    CurrentValue = "",
    PlaceholderText = "Enter JobId if needed",
    RemoveTextAfterFocusLost = false,
    Flag = "JobIdInput",
    Callback = function(Text)
        jobIdInput = Text
    end,
})

-- Button to execute selected action
local Button = Tab:CreateButton({
    Name = "Execute Action",
    Callback = function()
        if selectedAction == "Rejoin" then
            -- Rejoin current server
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        
        elseif selectedAction == "ServerHop" then
            -- Join random server
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            if servers and servers.data then
                for _, server in ipairs(servers.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        break
                    end
                end
            end

        elseif selectedAction == "JoinSmallServer" then
            -- Join smallest server
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            if servers and servers.data then
                table.sort(servers.data, function(a,b) return a.playing < b.playing end)
                for _, server in ipairs(servers.data) do
                    if server.id ~= game.JobId then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        break
                    end
                end
            end

        elseif selectedAction == "JoinByJobId" then
            -- Join specific JobId entered in Input
            if jobIdInput ~= "" then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jobIdInput, LocalPlayer)
            else
                warn("Please enter a JobId to join!")
            end
        end
    end,
})

local Configs = {}          -- table to store configs in memory
local selectedConfig = nil  -- currently selected config
local autoLoad = false

-- Input: name the config
local Input = Tab:CreateInput({
    Name = "Config Name",
    CurrentValue = "",
    PlaceholderText = "Enter config name",
    RemoveTextAfterFocusLost = false,
    Flag = "ConfigNameInput",
    Callback = function(Text)
        -- Player types a name, used when creating a new config
    end,
})

-- Dropdown: select existing config
local ConfigDropdown = Tab:CreateDropdown({
    Name = "Select Config",
    Options = {}, -- will be updated dynamically
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "ConfigDropdown",
    Callback = function(option)
        selectedConfig = option[1]
    end,
})

-- Helper: refresh dropdown options
local function RefreshDropdown()
    local options = {}
    for name,_ in pairs(Configs) do
        table.insert(options, name)
    end
    ConfigDropdown:Refresh(options)
end

-- Button: create new config
local CreateButton = Tab:CreateButton({
    Name = "Create Config",
    Callback = function()
        local name = Input.CurrentValue
        if name ~= "" then
            -- Save current UI state (example: flags) in memory
            Configs[name] = {
                -- Example: save all UI flags here
                Toggle1 = Toggle1 and Toggle1.CurrentValue,
                FOV = FOVInput and FOVInput.CurrentValue,
                -- add other flags here...
            }
            RefreshDropdown()
            print("Config '"..name.."' created!")
        else
            warn("Please enter a name for the config!")
        end
    end,
})

-- Button: overwrite selected config
local OverwriteButton = Tab:CreateButton({
    Name = "Overwrite Config",
    Callback = function()
        if selectedConfig then
            Configs[selectedConfig] = {
                Toggle1 = Toggle1 and Toggle1.CurrentValue,
                FOV = FOVInput and FOVInput.CurrentValue,
                -- add other flags here...
            }
            print("Config '"..selectedConfig.."' overwritten!")
        else
            warn("Select a config to overwrite!")
        end
    end,
})

-- Button: load selected config
local LoadButton = Tab:CreateButton({
    Name = "Load Config",
    Callback = function()
        if selectedConfig and Configs[selectedConfig] then
            local data = Configs[selectedConfig]
            -- Apply saved settings
            if Toggle1 then Toggle1:Set(data.Toggle1) end
            if FOVInput then FOVInput:Set(data.FOV) end
            -- apply other flags here...
            print("Config '"..selectedConfig.."' loaded!")
        else
            warn("Select a config to load!")
        end
    end,
})

-- Button: auto-load last selected config on UI load
local AutoLoadButton = Tab:CreateButton({
    Name = "Auto Load Last Config",
    Callback = function()
        autoLoad = true
        if selectedConfig and Configs[selectedConfig] then
            local data = Configs[selectedConfig]
            if Toggle1 then Toggle1:Set(data.Toggle1) end
            if FOVInput then FOVInput:Set(data.FOV) end
            -- apply other flags here...
            print("Auto-loaded config '"..selectedConfig.."'!")
        end
    end,
})