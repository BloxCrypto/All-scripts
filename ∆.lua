local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "door-open", -- lucide icon
    Author = "by .ftgs and .ftgs",
    Folder = "MySuperHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(678, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 160,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
   
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Open Example UI",
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

local Tab = Window:Tab({
    Title = "info",
    Icon = "bird", -- optional
    Locked = false,
})

local Players = game:GetService("Players")

local playerCount = #Players:GetPlayers()

local names = {}
for _, plr in ipairs(Players:GetPlayers()) do
    table.insert(names, plr.Name)
end

local Paragraph = Tab:Paragraph({
    Title = "Players: " .. playerCount,
    Desc = "Online Players:\n" .. table.concat(names, ", "),
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

local function UpdateParagraph()
    local playerCount = #Players:GetPlayers()

    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(names, plr.Name)
    end

    Paragraph:SetTitle("Players: " .. playerCount)
    Paragraph:SetDesc("Online Players:\n" .. table.concat(names, ", "))
end

Players.PlayerAdded:Connect(UpdateParagraph)
Players.PlayerRemoving:Connect(UpdateParagraph)

UpdateParagraph()

local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

-- Get basic server info
local gameId = game.PlaceId
local gameName = game:GetService("MarketplaceService"):GetProductInfo(gameId).Name
local jobId = game.JobId

-- Roblox doesn't provide server region directly
-- but we can use the game’s LocalizationService to guess the server country
local success, result = pcall(function()
    return LocalizationService:GetCountryRegionForPlayerAsync(Players.LocalPlayer)
end)

local region = success and result or "Unknown"

-- Create Paragraph
local Paragraph = Tab:Paragraph({
    Title = "Server Info",
    Desc = "Loading...",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

-- Update function
local function UpdateServerInfo()
    Paragraph:SetTitle("Server Information")
    Paragraph:SetDesc("Region: " .. tostring(region)
        .. "\nGame ID: " .. gameId
        .. "\nGame Name: " .. gameName
        .. "\nJob ID: " .. jobId
    )
end

UpdateServerInfo()

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// === TOGGLE ===

local spectating = false
local spectateTarget = nil

local Toggle = Tab:Toggle({
    Title = "Spectate Player",
    Desc = "Toggle to view another player",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        spectating = state

        if not state then
            spectateTarget = nil
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})


--// === DROPDOWN ===

-- Function to get player list
local function GetPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(list, plr.Name)
    end
    return list
end

local Dropdown = Tab:Dropdown({
    Title = "Choose Player",
    Desc = "Choose someone to spectate",
    Values = GetPlayerList(),
    Value = LocalPlayer.Name,
    Callback = function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character then
            spectateTarget = target
        else
            spectateTarget = nil
        end
    end
})

-- Auto refresh dropdown when players join or leave
local function RefreshDropdown()
    Dropdown:Refresh(GetPlayerList())
end

Players.PlayerAdded:Connect(RefreshDropdown)
Players.PlayerRemoving:Connect(RefreshDropdown)

--// === CAMERA LOOP ===

RunService.RenderStepped:Connect(function()
    if spectating and spectateTarget and spectateTarget.Character then
        local humanoid = spectateTarget.Character:FindFirstChild("Humanoid")
        if humanoid then
            Camera.CameraSubject = humanoid
        end
    end
end)

Window:Divider()

local Tab = Window:Tab({
    Title = "Player",
    Icon = "bird", -- optional
    Locked = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- default walkspeed value
local SpeedValue = 16
local SpeedEnabled = false


-- // TOGGLE
local Toggle = Tab:Toggle({
    Title = "Toggle WalkSpeed",
    Desc = "Enable or disable custom speed",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state

        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = state and SpeedValue or 16
            end
        end
    end
})


-- // INPUT
local Input = Tab:Input({
    Title = "Set WalkSpeed",
    Desc = "Type the speed you want",
    Value = "16",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter WalkSpeed...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            SpeedValue = num

            if SpeedEnabled then
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = SpeedValue
                    end
                end
            end
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Default jump power value
local JumpValue = 50
local JumpEnabled = false


-- // TOGGLE
local Toggle = Tab:Toggle({
    Title = "Toggle JumpPower",
    Desc = "Enable or disable custom JumpPower",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        JumpEnabled = state

        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = state and JumpValue or 50 -- Roblox default = 50
            end
        end
    end
})


-- // INPUT
local Input = Tab:Input({
    Title = "Set JumpPower",
    Desc = "Type the jump height you want",
    Value = "50",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter JumpPower...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            JumpValue = num

            if JumpEnabled then
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = JumpValue
                    end
                end
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local infJumpEnabled = false

local Toggle = Tab:Toggle({
    Title = "Infinite Jump",
    Desc = "Toggle Infinite Jump On/Off",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        infJumpEnabled = state
    end
})

-- Infinite jump handler
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local noclipEnabled = false

-- // TOGGLE
local Toggle = Tab:Toggle({
    Title = "NoClip",
    Desc = "Walk through walls (your game only)",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        noclipEnabled = state
    end
})

-- // Noclip loop
RunService.Stepped:Connect(function()
    if noclipEnabled then
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

local bhopRunning = false

local Toggle = Tab:Toggle({
    Title = "Bunny hop",
    Desc = "Automatically jump",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        bhopRunning = state

        -- Start or stop bunny hop loop
        task.spawn(function()
            while bhopRunning do
                local player = game.Players.LocalPlayer
                local char = player.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                    humanoid.Jump = true
                end

                task.wait(0.1) -- adjust speed of hopping
            end
        end)
    end
})

local Tab = Window:Tab({
    Title = "Visual",
    Icon = "bird", -- optional
    Locked = false,
})

local Section = Tab:Section({ 
    Title = "World",
})

local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        local lighting = game:GetService("Lighting")

        if state then
            -- ENABLE FULL BRIGHT
            lighting.Ambient = Color3.new(1, 1, 1)
            lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            lighting.Brightness = 5
            lighting.ClockTime = 12 -- makes it daytime

        else
            -- DISABLE / RESET TO DEFAULTS
            lighting.Ambient = Color3.new(0, 0, 0)
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            lighting.Brightness = 2
            lighting.ClockTime = 14
        end
    end
})

local camera = workspace.CurrentCamera
local customFOV = camera.FieldOfView  -- default

local Toggle = Tab:Toggle({
    Title = "FOV Toggle",
    Desc = "Enable / Disable Custom FOV",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            -- ENABLE custom FOV
            camera.FieldOfView = customFOV
        else
            -- DISABLE = reset FOV to Roblox default (70)
            camera.FieldOfView = 70
        end
    end
})

local Input = Tab:Input({
    Title = "FOV Input",
    Desc = "Set your FOV number",
    Value = "",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter FOV...",
    Callback = function(input)
        local number = tonumber(input)

        if not number then
            warn("Invalid FOV: must be a number")
            return
        end

        -- clamp so it doesn’t break camera
        number = math.clamp(number, 30, 120)

        customFOV = number
        print("Updated FOV to:", customFOV)

        -- If toggle is ON, apply instantly
        if Toggle.Value then
            camera.FieldOfView = customFOV
        end
    end
})

local Section = Tab:Section({ 
    Title = "ESP",
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local espColor = Color3.fromRGB(0, 255, 0)
local espObjects = {} -- store highlights

local function applyESP(player)
    if not player.Character then return end
    if player == LocalPlayer then return end -- don't outline yourself

    local char = player.Character
    if not char:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = espColor
        highlight.Parent = char

        espObjects[player] = highlight
    end
end

local function removeESP(player)
    local highlight = espObjects[player]
    if highlight then
        highlight:Destroy()
        espObjects[player] = nil
    end
end

local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        espEnabled = state

        if state then
            -- APPLY ESP to all players
            for _, player in pairs(Players:GetPlayers()) do
                applyESP(player)
            end

            -- APPLY ESP to players who respawn later
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    if espEnabled then
                        applyESP(player)
                    end
                end)
            end)

        else
            -- REMOVE all ESP
            for _, player in pairs(Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end
})

local Colorpicker = Tab:Colorpicker({
    Title = "Colorpicker",
    Desc = "Colorpicker Description",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        espColor = color

        -- update existing ESP highlights
        for _, highlight in pairs(espObjects) do
            highlight.OutlineColor = espColor
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local boxESPEnabled = false
local boxColor = Color3.fromRGB(0, 255, 0)

local espBoxes = {} -- store all player boxes

local function createBoxESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end

    local char = player.Character
    if not char:FindFirstChild("HumanoidRootPart") then return end

    -- prevent duplicates
    if espBoxes[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BoxESP"
    billboard.Adornee = char:WaitForChild("HumanoidRootPart")
    billboard.Size = UDim2.new(4, 0, 6, 0) -- width / height of box
    billboard.AlwaysOnTop = true
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = boxColor
    frame.Parent = billboard

    billboard.Parent = char
    espBoxes[player] = billboard
end

local function removeBoxESP(player)
    if espBoxes[player] then
        espBoxes[player]:Destroy()
        espBoxes[player] = nil
    end
end

local Toggle = Tab:Toggle({
    Title = "Box ESP",
    Desc = "Shows 2D boxes on players",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        boxESPEnabled = state

        if state then
            -- apply ESP to all players
            for _, player in pairs(Players:GetPlayers()) do
                createBoxESP(player)
            end

            -- apply ESP to new players
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    if boxESPEnabled then
                        createBoxESP(player)
                    end
                end)
            end)
        else
            -- remove all
            for _, player in pairs(Players:GetPlayers()) do
                removeBoxESP(player)
            end
        end
    end
})

local Colorpicker = Tab:Colorpicker({
    Title = "Box Color",
    Desc = "Pick ESP outline color",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Callback = function(color)
        boxColor = color

        -- update all active boxes
        for _, billboard in pairs(espBoxes) do
            local frame = billboard:FindFirstChildOfClass("Frame")
            if frame then
                frame.BorderColor3 = color
            end
        end
    end
})