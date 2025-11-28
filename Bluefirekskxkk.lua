local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

GUI:CreateMain({
    Name = "By AutoCracked",
    title = "Buleflare",
    ToggleUI = "K",
    WindowIcon = "atom", -- lucide icon
    WindowHeight = nil, -- if you didnt want to use auto responsive system you can custom it by your own
    WindowWidth = nil, -- remove WindowHeight and WindowWidth to using auto responsive system
    Theme = {
        Background = Color3.fromRGB(66, 123, 214),
        Secondary = Color3.fromRGB(36, 12, 194),
        Accent = Color3.fromRGB(75, 62, 156),
        Text = Color3.fromRGB(18, 17, 18),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(50, 50, 60),
        NavBackground = Color3.fromRGB(45, 45, 48)
    },
    Config = {
        Enabled = true, -- not implemented yet
    }
})

local tab1 = GUI:CreateTab("Player") -- without icon

local section = GUI:CreateSection({
    parent = tab1, 
    title = "Player"
})

-- Toggle to enable/disable custom WalkSpeed
local toggle = GUI:CreateToggle({
    parent = tab1, 
    text = "Toggle Walkspeed", 
    default = false, 
    callback = function(state)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if state then
                -- Enable custom WalkSpeed (example: 50)
                humanoid.WalkSpeed = 10000
            else
                -- Reset to default WalkSpeed (16 is Roblox default)
                humanoid.WalkSpeed = 16
            end
        end
    end
})

-- Slider to adjust WalkSpeed dynamically
local slider = GUI:CreateSlider({
    parent = tab1, 
    text = "Adjust Walkspeed", 
    min = 16, 
    max = 10000, 
    default = 16, -- Roblox default
    callback = function(value)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

-- Toggle to enable/disable custom JumpPower
local toggle = GUI:CreateToggle({
    parent = tab1, 
    text = "JumpPower", 
    default = false, 
    callback = function(state)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if state then
                -- Enable custom JumpPower (example: 100)
                humanoid.JumpPower = 1000
            else
                -- Reset to default JumpPower (50 is Roblox default)
                humanoid.JumpPower = 50
            end
        end
    end
})

-- Slider to adjust JumpPower dynamically
local slider = GUI:CreateSlider({
    parent = tab1, 
    text = "JumpPower Slider", 
    min = 50, 
    max = 1000, 
    default = 50, -- Roblox default
    callback = function(value)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

local infiniteJumpEnabled = false

-- Toggle to enable/disable infinite jump
local toggle = GUI:CreateToggle({
    parent = tab1, 
    text = "Infinite Jump", 
    default = false, 
    callback = function(state)
        infiniteJumpEnabled = state
    end
})

-- Listen for jump requests
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local tab2 = GUI:CreateTab("Visual")

local section = GUI:CreateSection({
    parent = tab2, 
    title = "World"
})

local Lighting = game:GetService("Lighting")

-- Save defaults so you can restore them later
local defaultBrightness = Lighting.Brightness
local defaultClockTime = Lighting.ClockTime
local defaultFogEnd = Lighting.FogEnd
local defaultAmbient = Lighting.Ambient

local toggle = GUI:CreateToggle({
    parent = tab2, 
    text = "Fullbright", 
    default = false, 
    callback = function(state)
        if state then
            -- Enable FullBright
            Lighting.Brightness = 2
            Lighting.ClockTime = 12 -- midday
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.new(1, 1, 1) -- pure white
        else
            -- Restore defaults
            Lighting.Brightness = defaultBrightness
            Lighting.ClockTime = defaultClockTime
            Lighting.FogEnd = defaultFogEnd
            Lighting.Ambient = defaultAmbient
        end
    end
})

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Toggle to enable/disable custom FOV
local toggle = GUI:CreateToggle({
    parent = tab2, 
    text = "Toggle FOV", 
    default = false, 
    callback = function(state)
        if state then
            -- Enable custom FOV (example: 100)
            camera.FieldOfView = 1000
        else
            -- Reset to default FOV (70 is Roblox default)
            camera.FieldOfView = 70
        end
    end
})

-- Slider to adjust FOV dynamically
local slider = GUI:CreateSlider({
    parent = tab2, 
    text = "Adjust FOV", 
    min = 70,   -- minimum FOV (avoid 0, too extreme)
    max = 1000,  -- maximum FOV
    default = 70, -- Roblox default
    callback = function(value)
        camera.FieldOfView = value
    end
})

local section = GUI:CreateSection({
    parent = tab2, 
    title = "ESP"
})

local player = game.Players.LocalPlayer
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)

-- Function to apply ESP highlights to all other players
local function applyESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = plr.Character:FindFirstChildOfClass("Highlight")
            if espEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Parent = plr.Character
                end
                highlight.FillTransparency = 1 -- only outline
                highlight.OutlineColor = espColor
                highlight.OutlineTransparency = 0
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- Toggle to enable/disable ESP
local toggle = GUI:CreateToggle({
    parent = tab2, 
    text = "ESP outline", 
    default = false, 
    callback = function(state)
        espEnabled = state
        applyESP()
    end
})

-- Color picker to change ESP outline color
local colorpicker = GUI:CreateColorPicker({
    parent = tab2, 
    text = "Outline color", 
    default = Color3.fromRGB(255, 0, 0), 
    callback = function(color)
        espColor = color
        applyESP()
    end
})

-- Keep ESP updated when new players spawn
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        applyESP()
    end)
end)

local tab3 = GUI:CreateTab("Server") -- without icon



local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local spectateEnabled = false
local spectateTarget = nil

-- Function to update spectating
local function updateSpectate()
    if spectateEnabled and spectateTarget and spectateTarget.Character then
        local humanoid = spectateTarget.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            camera.CameraSubject = humanoid
        end
    else
        -- Reset back to local player
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                camera.CameraSubject = humanoid
            end
        end
    end
end

-- Toggle to enable/disable spectating
local toggle = GUI:CreateToggle({
    parent = tab3, 
    text = "Spectate player", 
    default = false, 
    callback = function(state)
        spectateEnabled = state
        updateSpectate()
    end
})

-- Dropdown to select player to spectate
local dropdown = GUI:CreateDropdown({
    parent = tab3, 
    text = "Select player", 
    options = {}, -- we’ll populate dynamically
    callback = function(value)
        -- Find player by name
        local target = game.Players:FindFirstChild(value)
        if target then
            spectateTarget = target
            updateSpectate()
        end
    end
})

-- Populate dropdown with current players
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= player then
        dropdown:Add(plr.Name)
    end
end

-- Update dropdown when new players join
game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        dropdown:Add(plr.Name)
    end
end)

-- Remove from dropdown when players leave
game.Players.PlayerRemoving:Connect(function(plr)
    dropdown:Remove(plr.Name)
    if spectateTarget == plr then
        spectateTarget = nil
        updateSpectate()
    end
end)

local player = game.Players.LocalPlayer
local antiFlingEnabled = false

-- Function to apply Anti-Fling
local function applyAntiFling()
    if not antiFlingEnabled then return end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Clamp extreme velocities
                if root.Velocity.Magnitude > 100 then
                    root.Velocity = Vector3.new(0,0,0)
                end
                if root.RotVelocity.Magnitude > 100 then
                    root.RotVelocity = Vector3.new(0,0,0)
                end
            end
        end
    end
end

-- Toggle to enable/disable Anti-Fling
local toggle = GUI:CreateToggle({
    parent = tab3, 
    text = "Antifling", 
    default = false, 
    callback = function(state)
        antiFlingEnabled = state
    end
})

-- Run Anti-Fling continuously
game:GetService("RunService").Heartbeat:Connect(function()
    applyAntiFling()
end)

GUI:Load() -- Load config from previous save
GUI:Save() -- Save config into file