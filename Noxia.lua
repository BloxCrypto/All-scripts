local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/orialdev/WindUI-Forked-by-orialdev/refs/heads/main/WindUI%20Forked"))()

WindUI:AddTheme({
    Name = "Neon Glow",

    Accent = Color3.fromHex("#00FFF7"),      -- Neon Cyan
    Background = Color3.fromHex("#0A0A0F"),  -- Very dark background
    Outline = Color3.fromHex("#00FF85"),     -- Neon Green outline
    Text = Color3.fromHex("#FFFFFF"),        -- Pure white text
    Placeholder = Color3.fromHex("#8AFFE1"), -- Soft neon cyan
    Button = Color3.fromHex("#1F2933"),      -- Dark button with contrast
    Icon = Color3.fromHex("#FF00FF"),        -- Neon Magenta icons
})

local Window = WindUI:CreateWindow({
    Title = "Noxia",
    Icon = "zap",
    Author = "by Leviform",
    Folder = "Noxia",
    Size = UDim2.fromOffset(580, 434),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Neon Glow",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Topbar = {
        Height = 44,
        ButtonsType = "Default", -- Default or Mac
    },
    User = {
        Enabled = false,
        Anonymous = false,
        Callback = function(v)
            WindUI:SetTheme("v")
        end,
    },
    KeySystem = {
    Title = "Noxia Alpha",
    SaveKey = true, -- Saves to WindUI/FolderName/Key.key
    API = {
        {
            Type = "platoboost",
            ServiceId = "5690",
            Secret = "983d4af3-20bd-4779-8026-f1324225a347"
        }
    }
}
})

Window:SetBackgroundImage("rbxassetid://121787533858651")

Window:EditOpenButton({
    Title = "Noxia",
    Icon = "monitor",
    CornerRadius = UDim.new(0,1),
    StrokeThickness = 4,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("A60089"), 
        Color3.fromHex("9600FF")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Save configuration
Window.ConfigManager:Config("NoxiaConfig"):Save()

-- Load configuration
Window.ConfigManager:Config("NoxiaConfig"):Load()

local Tab = Window:Tab({
    Title = "Aimbot",
    Icon = "crosshair",
    Visible = true
})

local player = game.Players.LocalPlayer
local aimRadius = 150 -- default FOV radius
local target = nil
local isCamLocked = false -- camlock off by default
local smoothness = 0.1 -- default smoothness
local camlockPart = "Head"
local aliveCheck = false
local teamCheck = false
local wallCheck = false -- line-of-sight check enabled by default

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = Color3.new(1, 0, 0)
fovCircle.Thickness = 2
fovCircle.Radius = aimRadius
fovCircle.Filled = false
fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

-- Update FOV circle position each frame
game:GetService("RunService").RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    fovCircle.Radius = aimRadius
end)

-- Line of Sight Check
local function hasLineOfSight(model)
    local character = player.Character
    if character and character:FindFirstChild("Head") and model:FindFirstChild("Head") then
        local origin = character.Head.Position
        local targetPos = model.Head.Position
        local ray = Ray.new(origin, (targetPos - origin).Unit * (targetPos - origin).Magnitude)
        local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {character, model})
        return hit == nil
    end
    return false
end

-- Find Closest Target with all checks
local function getClosestTarget()
    local closestDistance = aimRadius
    local closestTarget = nil
    local character = player.Character

    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") and v ~= character then

            -- Alive check (robust)
            if aliveCheck then
                local humanoid = v:FindFirstChild("Humanoid")
                if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    continue
                end
            end

            -- Team check
            if teamCheck then
                local targetPlayer = game.Players:GetPlayerFromCharacter(v)
                if targetPlayer and targetPlayer.Team == player.Team then
                    continue
                end
            end

            local targetPosition = v.Head.Position
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetPosition)

            -- Wall check
            if onScreen and (not wallCheck or hasLineOfSight(v)) then
                local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - screenCenter).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = v
                end
            end
        end
    end

    return closestTarget
end

-- Lock Camera to target smoothly
local function lockCameraToTarget()
    if target and target:FindFirstChild(camlockPart) then
        local currentCFrame = workspace.CurrentCamera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, target[camlockPart].Position)
        workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, smoothness)
    end
end

-- Main Loop
game:GetService("RunService").RenderStepped:Connect(function()
    target = getClosestTarget()
    if isCamLocked and target then
        lockCameraToTarget()
    end
end)

local Section = Tab:Section({
    Title = "Aimbot",
    Opened = true
})

Section:Toggle({
    Title = "Aimbot",
    Value = false,
    Flag = "Camlocktoggle",
    Callback = function(state)
        isCamLocked = state
    end
})

local Multi = Section:MultiSection({
    Title = "Aimbot Configuration",
    Sections = {"Settings", "Checks"}
})

Multi.Settings:Slider({
    Title = "Aimbot Radius",
    Value = { Min = 16, Max = 300, Default = 150 },
    Step = 1,
    IsTooltip = true,
    Flag = "Camlockradiustoggle",
    Callback = function(value)
        aimRadius = value
    end
})

Multi.Settings:Toggle({
    Title = "FOV Circle",
    Value = false,
    Flag = "fovcircletoggle",
    Callback = function(state)
        fovCircle.Visible = state
    end
})

Multi.Settings:Colorpicker({
    Title = "FOV Circle Color",
    Desc = "Change FOV circle color",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Callback = function(color)
        fovCircle.Color = color
    end
})

Multi.Settings:Slider({
    Title = "Smoothness",
    Value = { Min = 0.01, Max = 1, Default = 0.1 },
    Step = 0.01,
    IsTooltip = true,
    Flag = "smoothnesslider",
    Callback = function(value)
        smoothness = value
    end
})

Multi.Settings:Dropdown({
    Title = "Aimbot Target",
    Values = {"Head", "Torso", "Random"},
    Multi = false,
    Value = "Head",
    Callback = function(selected)
        if selected == "Random" then
            camlockPart = math.random(1,2) == 1 and "Head" or "Torso"
        else
            camlockPart = selected
        end
    end
})

Multi.Checks:Toggle({
    Title = "Alive Check",
    Value = false,
    Flag = "camlockalivechecktoggle",
    Callback = function(state)
        aliveCheck = state
    end
})

Multi.Checks:Toggle({
    Title = "Team Check",
    Value = false,
    Flag = "camlockteamchecktoggle",
    Callback = function(state)
        teamCheck = state
    end
})

Multi.Checks:Toggle({
    Title = "Wall Check",
    Value = false,
    Flag = "camlockwallchecktoggle",
    Callback = function(state)
        wallCheck = state
    end
})

Tab:Select()

local Tab = Window:Tab({
    Title = "Hitboxes",
    Icon = "swords",
    Visible = true
})

_G.HeadSize = 50
_G.Disabled = false
_G.HitboxColor = Color3.fromRGB(0, 255, 0)
_G.HitboxTransparency = 0.7
_G.AliveCheck = false
_G.TeamCheck = false
_G.HitboxPart = "HumanoidRootPart"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local originalProperties = {}

local function resetPart(player, partName)
    local key = player.UserId .. "_" .. partName
    if partName == "Head" then
        if originalProperties[key] then
            originalProperties[key]:Destroy()
            originalProperties[key] = nil
        end
    else
        local part = player.Character and player.Character:FindFirstChild(partName)
        if part and originalProperties[key] then
            local orig = originalProperties[key]
            part.Size = orig.Size
            part.Transparency = orig.Transparency
            part.BrickColor = orig.BrickColor
            part.Material = orig.Material
            part.CanCollide = orig.CanCollide
            originalProperties[key] = nil
        end
    end
end

local function resetHitbox(player)
    for _, partName in ipairs({"HumanoidRootPart", "Head"}) do
        resetPart(player, partName)
    end
end

local function createHeadHitbox(player)
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end
    local key = player.UserId .. "_Head"
    if originalProperties[key] then return end

    local hitbox = Instance.new("Part")
    hitbox.Name = "HitboxOverlay"
    hitbox.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
    hitbox.Transparency = _G.HitboxTransparency
    hitbox.BrickColor = BrickColor.new(_G.HitboxColor)
    hitbox.Material = Enum.Material.Neon
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.CanQuery = false
    hitbox.CanTouch = false
    hitbox.Parent = player.Character

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = hitbox
    weld.Parent = hitbox

    originalProperties[key] = hitbox
end

local function applyHitbox(player)
    if not player.Character then return end
    if player == LocalPlayer then return end
    if _G.TeamCheck and player.Team == LocalPlayer.Team then
        resetHitbox(player)
        return
    end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if _G.AliveCheck and humanoid and humanoid.Health <= 0 then
        resetHitbox(player)
        return
    end

    resetHitbox(player)

    if _G.HitboxPart == "HumanoidRootPart" then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local key = player.UserId .. "_HumanoidRootPart"
        if not originalProperties[key] then
            originalProperties[key] = {
                Size = hrp.Size,
                Transparency = hrp.Transparency,
                BrickColor = hrp.BrickColor,
                Material = hrp.Material,
                CanCollide = hrp.CanCollide
            }
        end
        hrp.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
        hrp.Transparency = _G.HitboxTransparency
        hrp.BrickColor = BrickColor.new(_G.HitboxColor)
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
    elseif _G.HitboxPart == "Head" then
        createHeadHitbox(player)
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if _G.Disabled then
            applyHitbox(player)
        else
            resetHitbox(player)
        end
    end
end)

local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        if _G.Disabled then
            applyHitbox(player)
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)

local Section = Tab:Section({
    Title = "Hitboxes",
    Opened = true
})

Section:Toggle({
    Title = "Hitbox",
    Value = false,
    Flag = "HitboxToggle",
    Callback = function(state)
        _G.Disabled = state
    end
})

local Multi = Section:MultiSection({
    Title = "Hitbox Configuration",
    Sections = {"Settings", "Checks"}
})

Multi.Settings:Slider({
    Title = "Hitbox Size",
    Value = { Min = 16, Max = 150, Default = 50 },
    Step = 1,
    IsTooltip = true,
    Flag = "HitboxSizeslider",
    Callback = function(value)
        _G.HeadSize = value
        for _, player in ipairs(Players:GetPlayers()) do
            if _G.Disabled then applyHitbox(player) end
        end
    end
})

Multi.Settings:Colorpicker({
    Title = "Hitbox Color",
    Desc = "Select hitbox color",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        _G.HitboxColor = color
        for _, player in ipairs(Players:GetPlayers()) do
            if _G.Disabled then applyHitbox(player) end
        end
    end
})

Multi.Settings:Slider({
    Title = "Hitbox Transparency",
    Value = { Min = 0, Max = 1, Default = 0.7 },
    Step = 0.05,
    IsTooltip = true,
    Flag = "TransparencySlider",
    Callback = function(value)
        _G.HitboxTransparency = value
        for _, player in ipairs(Players:GetPlayers()) do
            if _G.Disabled then applyHitbox(player) end
        end
    end
})

Multi.Checks:Toggle({
    Title = "Alive Check",
    Value = false,
    Flag = "AliveCheckToggle",
    Callback = function(state)
        _G.AliveCheck = state
    end
})

Multi.Checks:Toggle({
    Title = "Team Check",
    Value = false,
    Flag = "TeamCheckToggle",
    Callback = function(state)
        _G.TeamCheck = state
    end
})

Multi.Settings:Dropdown({
    Title = "Hitbox Part",
    Values = {"Head", "HumanoidRootPart"},
    Multi = false,
    Value = "HumanoidRootPart",
    Callback = function(selected)
        _G.HitboxPart = selected
        for _, player in ipairs(Players:GetPlayers()) do
            if _G.Disabled then applyHitbox(player) else resetHitbox(player) end
        end
    end
})

local Tab = Window:Tab({
    Title = "Visual",
    Icon = "wallpaper",
    Visible = true
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer and LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalHumanoidRootPart = LocalCharacter:WaitForChild("HumanoidRootPart")

local ESPSettings = {
    Boxes = false,
    Names = false,
    Tracers = false,
    Health = false,
    Distance = false,
    Skeleton = false,
    ItemESP = false,
    AliveCheck = false,
    TeamCheck = false,
    ESPColor = Color3.fromRGB(0, 255, 0),
    ESPPart = "Head"
}

local bodyConnections = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
}

local ESP = {}
ESP.__index = ESP

function ESP.new()
    local self = setmetatable({}, ESP)
    self.espCache = {}
    return self
end

function ESP:createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, val in pairs(properties) do
        drawing[prop] = val
    end
    return drawing
end

function ESP:createComponents()
    return {
        Box = self:createDrawing("Square", {Thickness = 1, Transparency = 1, Color = ESPSettings.ESPColor, Filled = false}),
        Tracer = self:createDrawing("Line", {Thickness = 1, Transparency = 1, Color = ESPSettings.ESPColor}),
        DistanceLabel = self:createDrawing("Text", {Size = 18, Center = true, Outline = true, Color = ESPSettings.ESPColor, OutlineColor = Color3.fromRGB(0,0,0)}),
        NameLabel = self:createDrawing("Text", {Size = 18, Center = true, Outline = true, Color = ESPSettings.ESPColor, OutlineColor = Color3.fromRGB(0,0,0)}),
        HealthBar = {
            Outline = self:createDrawing("Square", {Thickness = 1, Transparency = 1, Color = Color3.fromRGB(0,0,0), Filled = false}),
            Health = self:createDrawing("Square", {Thickness = 1, Transparency = 1, Color = ESPSettings.ESPColor, Filled = true})
        },
        ItemLabel = self:createDrawing("Text", {Size = 18, Center = true, Outline = true, Color = ESPSettings.ESPColor, OutlineColor = Color3.fromRGB(0,0,0)}),
        SkeletonLines = {},
        ChamsParts = {}
    }
end

function ESP:hideComponents(components)
    components.Box.Visible = false
    components.Tracer.Visible = false
    components.DistanceLabel.Visible = false
    components.NameLabel.Visible = false
    components.HealthBar.Outline.Visible = false
    components.HealthBar.Health.Visible = false
    components.ItemLabel.Visible = false
    for _, line in pairs(components.SkeletonLines) do line.Visible = false end
    for _, chamsPart in pairs(components.ChamsParts) do chamsPart:Destroy() end
    components.ChamsParts = {}
end

function ESP:removeEsp(player)
    local components = self.espCache[player]
    if components then
        components.Box:Remove()
        components.Tracer:Remove()
        components.DistanceLabel:Remove()
        components.NameLabel:Remove()
        components.HealthBar.Outline:Remove()
        components.HealthBar.Health:Remove()
        components.ItemLabel:Remove()
        for _, line in pairs(components.SkeletonLines) do line:Remove() end
        for _, chamsPart in pairs(components.ChamsParts) do chamsPart:Destroy() end
        self.espCache[player] = nil
    end
end

function ESP:updateComponents(components, character, player)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then self:hideComponents(components) return end

    -- Alive & Team Checks
    if (ESPSettings.AliveCheck and humanoid.Health <= 0) or (ESPSettings.TeamCheck and player.Team == LocalPlayer.Team) then
        self:hideComponents(components)
        return
    end

    -- Target part
    local targetPart = ESPSettings.ESPPart == "Random" and character:GetChildren()[math.random(#character:GetChildren())] 
                       or character:FindFirstChild(ESPSettings.ESPPart) 
                       or hrp

    local targetPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    local mousePos = Camera:WorldToViewportPoint(LocalPlayer:GetMouse().Hit.p)
    if not onScreen then self:hideComponents(components) return end

    local screenW, screenH = Camera.ViewportSize.X, Camera.ViewportSize.Y
    local factor = 1 / (targetPos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
    local width, height = math.floor(screenH/25*factor), math.floor(screenW/27*factor)
    local distance = math.floor((LocalHumanoidRootPart.Position - hrp.Position).magnitude)

    -- Box
    if ESPSettings.Boxes then
        components.Box.Size = Vector2.new(width, height)
        components.Box.Position = Vector2.new(targetPos.X - width/2, targetPos.Y - height/2)
        components.Box.Color = ESPSettings.ESPColor
        components.Box.Visible = true
    else components.Box.Visible = false end

    -- Tracer
    if ESPSettings.Tracers then
        components.Tracer.From = Vector2.new(mousePos.X, mousePos.Y)
        components.Tracer.To = Vector2.new(targetPos.X, targetPos.Y + height/2)
        components.Tracer.Color = ESPSettings.ESPColor
        components.Tracer.Visible = true
    else components.Tracer.Visible = false end

    -- Name
    if ESPSettings.Names then
        components.NameLabel.Text = "["..player.Name.."]"
        components.NameLabel.Position = Vector2.new(targetPos.X, targetPos.Y - height/2 - 15)
        components.NameLabel.Color = ESPSettings.ESPColor
        components.NameLabel.Visible = true
    else components.NameLabel.Visible = false end

    -- Distance
    if ESPSettings.Distance then
        components.DistanceLabel.Text = "["..distance.."M]"
        components.DistanceLabel.Position = Vector2.new(targetPos.X, targetPos.Y + height/2 + 15)
        components.DistanceLabel.Color = ESPSettings.ESPColor
        components.DistanceLabel.Visible = true
    else components.DistanceLabel.Visible = false end

    -- Health
    if ESPSettings.Health then
        local hbH, hbW = height, 5
        local healthFrac = humanoid.Health / humanoid.MaxHealth
        components.HealthBar.Outline.Size = Vector2.new(hbW, hbH)
        components.HealthBar.Outline.Position = Vector2.new(components.Box.Position.X - hbW - 2, components.Box.Position.Y)
        components.HealthBar.Outline.Visible = true

        components.HealthBar.Health.Size = Vector2.new(hbW-2, hbH*healthFrac)
        components.HealthBar.Health.Position = Vector2.new(components.HealthBar.Outline.Position.X+1, components.HealthBar.Outline.Position.Y + hbH*(1-healthFrac))
        components.HealthBar.Health.Color = ESPSettings.ESPColor
        components.HealthBar.Health.Visible = true
    else
        components.HealthBar.Outline.Visible = false
        components.HealthBar.Health.Visible = false
    end

    -- Tool/Item
    if ESPSettings.ItemESP then
        local backpack = player:FindFirstChild("Backpack")
        local tool = (backpack and backpack:FindFirstChildOfClass("Tool")) or character:FindFirstChildOfClass("Tool")
        components.ItemLabel.Text = tool and "[Holding: "..tool.Name.."]" or "[Holding: No tool]"
        components.ItemLabel.Position = Vector2.new(targetPos.X, targetPos.Y + height/2 + 35)
        components.ItemLabel.Color = ESPSettings.ESPColor
        components.ItemLabel.Visible = true
    else
        components.ItemLabel.Visible = false
    end

    -- Skeleton
    if ESPSettings.Skeleton then
        local connections = bodyConnections[humanoid.RigType.Name] or {}
        for _, conn in ipairs(connections) do
            local partA = character:FindFirstChild(conn[1])
            local partB = character:FindFirstChild(conn[2])
            if partA and partB then
                local line = components.SkeletonLines[conn[1].."-"..conn[2]] or self:createDrawing("Line",{Thickness=1, Color=ESPSettings.ESPColor})
                local posA, onA = Camera:WorldToViewportPoint(partA.Position)
                local posB, onB = Camera:WorldToViewportPoint(partB.Position)
                if onA and onB then
                    line.From = Vector2.new(posA.X,posA.Y)
                    line.To = Vector2.new(posB.X,posB.Y)
                    line.Color = ESPSettings.ESPColor
                    line.Visible = true
                    components.SkeletonLines[conn[1].."-"..conn[2]] = line
                else line.Visible = false end
            end
        end
    else
        for _, line in pairs(components.SkeletonLines) do line.Visible = false end
    end
end

local espInstance = ESP.new()

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                if not espInstance.espCache[player] then
                    espInstance.espCache[player] = espInstance:createComponents()
                end
                espInstance:updateComponents(espInstance.espCache[player], character, player)
            else
                if espInstance.espCache[player] then
                    espInstance:hideComponents(espInstance.espCache[player])
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    espInstance:removeEsp(player)
end)

local Multi = Tab:MultiSection({
    Title = "Visuals",
    Sections = {"ESP", "Configure", "Checks"}
})

Multi.ESP:Toggle({
       Title="ESP Boxes", 
       Value=false, 
       Callback=function(state) 
         ESPSettings.Boxes = state 
   end
})

Multi.ESP:Toggle({
        Title="Name ESP", 
         Value=false, 
         Callback=function(state) 
          ESPSettings.Names = state 
    end
})

Multi.ESP:Toggle({
      Title="ESP Tracer", 
      Value=false, 
      Callback=function(state) 
      ESPSettings.Tracers = state 
   end
})

Multi.ESP:Toggle({
       Title="ESP Health", 
       Value=false, 
       Callback=function(state) 
       ESPSettings.Health = state 
  end
})

Multi.ESP:Toggle({
       Title="ESP Distance", 
       Value=false, 
       Callback=function(state) 
       ESPSettings.Distance = state 
  end
})

Multi.ESP:Toggle({
     Title="Skeleton ESP", 
     Value=false, 
     Callback=function(state) 
     ESPSettings.Skeleton = state 
  end
})

Multi.ESP:Toggle({
       Title="Item/Tool ESP", 
       Value=false, Callback=function(state) 
       ESPSettings.ItemESP = state 
  end
})

Multi.Checks:Toggle({
      Title="Alive Check", 
      Value=false, 
      Callback=function(state) 
      ESPSettings.AliveCheck = state 
  end
})

Multi.Checks:Toggle({
      Title="Team Check", 
      Value=false, Callback=function(state) 
      ESPSettings.TeamCheck = state 
  end
})

Multi.Configure:Colorpicker({
      Title="ESP Color", 
      Default=Color3.fromRGB(0,255,0), 
      Callback=function(c) 
      ESPSettings.ESPColor = c 
  end
})

Multi.Configure:Dropdown({
      Title="ESP Part", 
      Values={"Head","Torso","Random"}, 
      Value="Head", 
      Callback=function(s) 
       ESPSettings.ESPPart = s 
  end
})

local Tab = Window:Tab({
    Title = "Misc",
    Icon = "bolt",
    Visible = true
})

local Section = Tab:Section({
    Title = "Teleport to player",
    Opened = true
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil -- currently selected player

-- Create dropdown
local Dropdown = Section:Dropdown({
    Title = "Player Dropdown",
    Desc = "Select a player to teleport to",
    Values = {}, -- start empty, will refresh
    Value = nil,
    Callback = function(option)
        selectedPlayer = option
        print("Selected player: " .. option)
    end
})

-- Function to refresh dropdown with current players
local function refreshDropdown()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then -- optional: exclude yourself
            table.insert(playerNames, player.Name)
        end
    end

    -- Only refresh if dropdown exists
    if Dropdown and Dropdown.Refresh then
        Dropdown:Refresh(playerNames)
    end
end

-- Button to teleport
local Button = Section:Button({
    Title = "Teleport",
    Desc = "Teleport to selected player",
    Locked = false,
    Callback = function()
        if not selectedPlayer then
            warn("No player selected!")
            return
        end

        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                print("Teleported to " .. selectedPlayer)
            else
                warn("Your character is not loaded!")
            end
        else
            warn(selectedPlayer .. " is not available!")
        end
    end
})

-- Update dropdown whenever players join or leave
Players.PlayerAdded:Connect(refreshDropdown)
Players.PlayerRemoving:Connect(refreshDropdown)

-- Initial population
refreshDropdown()

--// Fly variables
local nowe = false
local tpwalking = false
local speeds = 1

--// Fly toggle function
local function toggleFly()
    local speaker = game:GetService("Players").LocalPlayer
    local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Stop existing fly loop
    if tpwalking then
        tpwalking = false
        task.wait()
    end

    if nowe then
        -- TURN FLY OFF
        nowe = false
        tpwalking = false

        -- Re-enable humanoid states
        for _,state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
            humanoid:SetStateEnabled(state, true)
        end

        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        humanoid.PlatformStand = false

        if speaker.Character:FindFirstChild("Animate") then
            speaker.Character.Animate.Disabled = false
        end
        return
    end

    -- TURN FLY ON
    nowe = true

    -- TP-walk movement
    for i = 1, speeds do
        task.spawn(function()
            local hb = game:GetService("RunService").Heartbeat
            tpwalking = true
            local chr = speaker.Character
            local hum = chr and chr:FindFirstChildOfClass("Humanoid")

            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end

    -- Disable animations
    if speaker.Character:FindFirstChild("Animate") then
        speaker.Character.Animate.Disabled = true
    end

    for _,track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(0)
    end

    -- Disable humanoid states
    for _,state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
        humanoid:SetStateEnabled(state, false)
    end

    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    humanoid.PlatformStand = true
end

local Section = Tab:Section({
    Title = "Fly",
    Opened = true
})

--// UI TOGGLE
Section:Toggle({
    Title = "Fly",
    Value = false,
    Flag = "flytoggle",
    Callback = function(state)
        toggleFly()
    end
})

--// SPEED SLIDER
Section:Slider({
    Title = "Fly Speed",
    Value = { Min = 1, Max = 150, Default = 1 },
    Step = 1,
    IsTooltip = true,
    Flag = "flyspeedslider",
    Callback = function(value)
        speeds = value
    end
})

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Vars
local humanoid
local defaultWalkSpeed = 16
local defaultJumpPower = 50

local currentWalkSpeed = 16
local currentJumpPower = 50

-- Get humanoid safely (handles respawn)
local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
end

getHumanoid()
player.CharacterAdded:Connect(getHumanoid)

local SectionS = Tab:Section({
    Title = "Movement",
    Opened = true
})

local Section = SectionS:Section({
    Title = "Walkspeed",
    Opened = true
})

-- Walkspeed Toggle
Section:Toggle({
    Title = "Walkspeed",
    Value = false,
    Flag = "walkspeedtoggle",
    Callback = function(state)
        if not humanoid then return end

        if state then
            humanoid.WalkSpeed = currentWalkSpeed
        else
            humanoid.WalkSpeed = defaultWalkSpeed
        end
    end
})

-- Walkspeed Slider
Section:Slider({
    Title = "Adjust Walkspeed",
    Value = { Min = 16, Max = 150, Default = 16 },
    Step = 1,
    IsTooltip = true,
    Flag = "WalkspeedSlider",
    Callback = function(value)
        currentWalkSpeed = value

        if humanoid and _G.walkspeedtoggle then
            humanoid.WalkSpeed = value
        end
    end
})

local Section = SectionS:Section({
    Title = "JumpPower",
    Opened = true
})

-- Jumppower Toggle
Section:Toggle({
    Title = "Jumppower",
    Value = false,
    Flag = "jumppowertoggle",
    Callback = function(state)
        if not humanoid then return end

        if state then
            humanoid.JumpPower = currentJumpPower
        else
            humanoid.JumpPower = defaultJumpPower
        end
    end
})

-- Jumppower Slider
Section:Slider({
    Title = "Adjust Jumppower",
    Value = { Min = 50, Max = 150, Default = 50 },
    Step = 1,
    IsTooltip = true,
    Flag = "adjustjumppowerslider",
    Callback = function(value)
        currentJumpPower = value

        if humanoid and _G.jumppowertoggle then
            humanoid.JumpPower = value
        end
    end
})

local Tab = Window:Tab({
    Title = "Settings",
    Icon = "cog",
    Visible = true
})

Tab:Toggle({
    Title = "transparent",
    Value = true,
    Flag = "transparencytoggle",
    Callback = function(state)
        Window:ToggleTransparency(state)
    end
})