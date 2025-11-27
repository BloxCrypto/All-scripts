if getgenv().DaraHubEvadeExecuted then
    return
end
getgenv().DaraHubEvadeExecuted = true

WindUI = nil

do
    ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end
end

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

Window = WindUI:CreateWindow({
    Title = "Dara Hub",
    Icon = "rbxassetid://137330250139083",
    Author = "Made by: Pnsdg And Yomka",
    Folder = "DaraHub",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    HidePanelBackground = false,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200
})

isWindowOpen = false
updateWindowOpenState = function()
    if Window and type(Window.IsOpen) == "function" then
        ok, val = pcall(function() return Window:IsOpen() end)
        if ok and type(val) == "boolean" then
            isWindowOpen = val
            return
        end
    end
    if Window and Window.Opened ~= nil then
        isWindowOpen = Window.Opened
        return
    end
    isWindowOpen = isWindowOpen or false
end

pcall(updateWindowOpenState)
Window:SetIconSize(48)
Window:Tag({
    Title = "V1",
    Color = Color3.fromHex("#30ff6a")
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
end, 990)

Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
VirtualUser = game:GetService("VirtualUser")
Lighting = game:GetService("Lighting")
ReplicatedStorage = game:GetService("ReplicatedStorage")
workspace = game:GetService("Workspace")
originalGameGravity = workspace.Gravity
TeleportService = game:GetService("TeleportService")
HttpService = game:GetService("HttpService")
MarketplaceService = game:GetService("MarketplaceService")
player = Players.LocalPlayer
playerGui = player:WaitForChild("PlayerGui")
placeId = game.PlaceId
jobId = game.JobId

featureStates = {
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 5,
    TPWALK = false,
    TpwalkValue = 1,
    JumpBoost = false,
    JumpPower = 5,
    AntiAFK = false,
    SpeedHack = false,
    SpeedValue = 16,
    Noclip = false,
    InnocentESP = {names = false, boxes = false, tracers = false, distance = false, boxType = "2D"},
    MurderESP = {names = false, boxes = false, tracers = false, distance = false, boxType = "2D"},
    HeroSheriffESP = {names = false, boxes = false, tracers = false, distance = false, boxType = "2D"},
    InnocentHighlights = false,
    MurderHighlights = false,
    SheriffHeroHighlights = false
}

local function IsAlive(Player, currentRoles)
    for i, v in pairs(currentRoles) do
        if Player.Name == i then
            if not v.Killed and not v.Dead then
                return true
            else
                return false
            end
        end
    end
    return false
end

local function getOutlineColor(c)
    local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
    if lum > 0.5 then
        return Color3.new(0,0,0)
    else
        return Color3.new(1,1,1)
    end
end

FeatureSection = Window:Section({ Title = "Features", Opened = true })

Tabs = {
    Main = FeatureSection:Tab({ Title = "Main", Icon = "layout-grid" }),
    Player = FeatureSection:Tab({ Title = "Player", Icon = "user" }),
    Combat = FeatureSection:Tab({ Title = "Combat", Icon = "swords" }),
    Visuals = FeatureSection:Tab({ Title = "Visuals", Icon = "camera" }),
    Esp = FeatureSection:Tab({ Title = "Esp", Icon = "eye" }),
    Teleport = FeatureSection:Tab({ Title = "Teleport", Icon = "navigation" }),
    Misc = FeatureSection:Tab({ Title = "Misc", Icon = "star" }),
    Utility = FeatureSection:Tab({ Title = "Utility", Icon = "wrench" }),
    Settings = FeatureSection:Tab({ Title = "Settings", Icon = "settings" }),
    Info = FeatureSection:Tab({ Title = "Info", Icon = "info" }),
}

Tabs.Main:Section({ Title = "Server Info", TextSize = 20 })
Tabs.Main:Divider()

placeName = "Unknown"
success, productInfo = pcall(function()
    return MarketplaceService:GetProductInfo(placeId)
end)
if success and productInfo then
    placeName = productInfo.Name
end

Tabs.Main:Paragraph({
    Title = "Game Mode",
    Desc = placeName
})

Tabs.Main:Button({
    Title = "Copy Server Link",
    Desc = "Copy the current server's join link",
    Icon = "link",
    Callback = function()
        serverLink = string.format("https://www.roblox.com/games/start?placeId=%d&jobId=%s", placeId, jobId)
        pcall(function()
            setclipboard(serverLink)
        end)
    end
})

numPlayers = #Players:GetPlayers()
maxPlayers = Players.MaxPlayers

playerCountParagraph = Tabs.Main:Paragraph({
    Title = "Current Players",
    Desc = numPlayers .. " / " .. maxPlayers
})

RunService.Heartbeat:Connect(function()
    local modelCount = 0
    
    for _, player in ipairs(Players:GetPlayers()) do
        if workspace:FindFirstChild(player.Name) then
            modelCount = modelCount + 1
        end
    end
    
    playerCountParagraph:SetDesc(numPlayers .. " Online/ " .. maxPlayers .. "Max | Player Models Found: " .. modelCount .. "")
end)
ModelPlayerAntiBrokenServer = Tabs.Main:Paragraph({
    Title = "Player Model Server Status",
    Desc = "Waiting..."
})

playerModelCheckConnection = RunService.Heartbeat:Connect(function()
    local playerCount = #Players:GetPlayers()
    local modelCount = 0
    
    for _, player in ipairs(Players:GetPlayers()) do
        if workspace:FindFirstChild(player.Name) then
            modelCount = modelCount + 1
        end
    end
    
    if playerCount == modelCount then
        ModelPlayerAntiBrokenServer:SetDesc("Player Model Is Correct Definitely Playable")
    else
        ModelPlayerAntiBrokenServer:SetDesc("Unplayable Server Detected! Missing Player Model, Find a new server")
    end
end)
Tabs.Main:Paragraph({
    Title = "Server ID",
    Desc = jobId
})

Tabs.Main:Paragraph({
    Title = "Place ID",
    Desc = tostring(placeId)
})

Tabs.Main:Section({ Title = "Server Tools", TextSize = 20 })
Tabs.Main:Divider()

Tabs.Main:Button({
    Title = "Rejoin",
    Desc = "Rejoin the current server",
    Icon = "refresh-cw",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
    end
})

Tabs.Main:Button({
    Title = "Server Hop",
    Desc = "Hop to a random server",
    Icon = "shuffle",
    Callback = function()
        AllIDs = {}
        foundAnything = ""
        actualHour = os.date("!*t").hour
        Deleted = false
        S_T = game:GetService("TeleportService")
        S_H = game:GetService("HttpService")

        File = pcall(function()
            AllIDs = S_H:JSONDecode(readfile("server-hop-temp.json"))
        end)
        if not File then
            table.insert(AllIDs, actualHour)
            pcall(function()
                writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
            end)
        end

        function TPReturner(placeId)
            local Site;
            if foundAnything == "" then
                Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
            else
                Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
            end
            local ID = ""
            if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                foundAnything = Site.nextPageCursor
            end
            local num = 0;
            for i,v in pairs(Site.data) do
                local Possible = true
                ID = tostring(v.id)
                if tonumber(v.maxPlayers) > tonumber(v.playing) then
                    for _,Existing in pairs(AllIDs) do
                        if num ~= 0 then
                            if ID == tostring(Existing) then
                                Possible = false
                            end
                        else
                            if tonumber(actualHour) ~= tonumber(Existing) then
                                local delFile = pcall(function()
                                    delfile("server-hop-temp.json")
                                    AllIDs = {}
                                    table.insert(AllIDs, actualHour)
                                end)
                            end
                        end
                        num = num + 1
                    end
                    if Possible == true then
                        table.insert(AllIDs, ID)
                        wait()
                        pcall(function()
                            writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
                            wait()
                            S_T:TeleportToPlaceInstance(placeId, ID, game.Players.LocalPlayer)
                        end)
                        wait(4)
                    end
                end
            end
        end

        function Teleport(placeId)
            while wait() do
                pcall(function()
                    TPReturner(placeId)
                    if foundAnything ~= "" then
                        TPReturner(placeId)
                    end
                end)
            end
        end

        Teleport(game.PlaceId)
    end
})

Tabs.Main:Button({
    Title = "Hop to Small Server",
    Desc = "Hop to the smallest available server",
    Icon = "minimize",
    Callback = function()
        request = request or (http and http.request) or (syn and syn.request)
        if not request then
            return
        end

        response = request({
            Url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100",
            Method = "GET",
        })

        if response.StatusCode == 200 then
            serverData = HttpService:JSONDecode(response.Body)
            smallestServer = nil
            smallestPlayerCount = math.huge

            for _, server in pairs(serverData.data) do
                if server.id ~= jobId and server.playing < server.maxPlayers and server.playing < smallestPlayerCount then
                    smallestPlayerCount = server.playing
                    smallestServer = server
                end
            end

            if smallestServer then
                TeleportService:TeleportToPlaceInstance(placeId, smallestServer.id, player)
            end
        end
    end
})

Tabs.Main:Button({
    Title = "Advanced Server Hop",
    Desc = "Finding a Server inside your game",
    Icon = "server",
    Callback = function()
        success, result = pcall(function()
            script = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pnsdgsa/Script-kids/refs/heads/main/Advanced%20Server%20Hop.lua"))()
        end)
    end
})

Tabs.Player:Section({ Title = "Player", TextSize = 40 })
Tabs.Player:Divider()

character = nil
humanoid = nil
rootPart = nil

function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid", 5)
    rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if featureStates.JumpBoost and humanoid then
        humanoid.JumpPower = featureStates.JumpPower
        humanoid.JumpHeight = featureStates.JumpPower
        setupJumpBoost()
    end
    if featureStates.SpeedHack and humanoid then
        humanoid.WalkSpeed = featureStates.SpeedValue
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

UserInputService.JumpRequest:connect(function()
    if featureStates.InfiniteJump then
        player.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)

InfiniteJumpToggle = Tabs.Player:Toggle({
    Title = "Infinite Jump",
    Value = featureStates.InfiniteJump,
    Callback = function(state)
        featureStates.InfiniteJump = state
    end
})

SpeedToggle = Tabs.Player:Toggle({
    Title = "Speed Hack",
    Value = featureStates.SpeedHack,
    Callback = function(state)
        featureStates.SpeedHack = state
        if state and humanoid then
            humanoid.WalkSpeed = featureStates.SpeedValue
        elseif humanoid then
            humanoid.WalkSpeed = 16
        end
    end
})

SpeedSlider = Tabs.Player:Slider({
    Title = "Speed Value",
    Desc = "Adjust walk speed",
    Value = { Min = 16, Max = 200, Default = featureStates.SpeedValue, Step = 1 },
    Callback = function(value)
        featureStates.SpeedValue = value
        if featureStates.SpeedHack and humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

Noclip = nil
Clip = nil

function noclip()
    Clip = false
    local function Nocl()
        if Clip == false and player.Character ~= nil then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        wait(0.21)
    end
    Noclip = RunService.Stepped:Connect(Nocl)
end

function clip()
    if Noclip then 
        Noclip:Disconnect() 
    end
    Clip = true
    if player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA('BasePart') then
                v.CanCollide = true
            end
        end
    end
end

NoclipToggle = Tabs.Player:Toggle({
    Title = "Noclip",
    Value = featureStates.Noclip,
    Callback = function(state)
        featureStates.Noclip = state
        if state then
            noclip()
        else
            clip()
        end
    end
})

flying = false
bodyVelocity = nil
bodyGyro = nil
flyConnection = nil

function startFlying()
    if not character or not humanoid or not rootPart then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    humanoid.PlatformStand = true
end

function stopFlying()
    flying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
end

function updateFly()
    if not flying or not bodyVelocity or not bodyGyro then return end
    camera = workspace.CurrentCamera
    cameraCFrame = camera.CFrame
    direction = Vector3.new(0, 0, 0)
    moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude > 0 then
        forwardVector = cameraCFrame.LookVector
        rightVector = cameraCFrame.RightVector
        forwardComponent = moveDirection:Dot(forwardVector) * forwardVector
        rightComponent = moveDirection:Dot(rightVector) * rightVector
        direction = direction + (forwardComponent + rightComponent).Unit * moveDirection.Magnitude
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    bodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * (featureStates.FlySpeed * 2) or Vector3.new(0, 0, 0)
    bodyGyro.CFrame = cameraCFrame
end

FlyToggle = Tabs.Player:Toggle({
    Title = "Fly",
    Value = featureStates.Fly,
    Callback = function(state)
        featureStates.Fly = state
        if state then
            startFlying()
            flyConnection = RunService.Heartbeat:Connect(updateFly)
        else
            stopFlying()
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
        end
    end
})

FlySpeedSlider = Tabs.Player:Slider({
    Title = "Fly Speed",
    Value = { Min = 1, Max = 200, Default = featureStates.FlySpeed, Step = 1 },
    Desc = "Adjust fly speed",
    Callback = function(value)
        featureStates.FlySpeed = value
    end
})
local godModeEnabled = false
local godModeConnection = nil
local godModeMethod = "Health Math.huge"

local function applyHumanoidReplacement()
    local Char = player.Character
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    
    local nHuman = Human:Clone()
    nHuman.Parent = Char
    player.Character = nil
    nHuman:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    nHuman:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    nHuman:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    nHuman.BreakJointsOnDeath = true
    nHuman.MaxHealth = math.huge
    nHuman.Health = math.huge
    Human:Destroy()
    player.Character = Char
    nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    
    local Script = Char:FindFirstChild("Animate")
    if Script then
        Script.Disabled = true
        wait()
        Script.Disabled = false
    end
end

local function applyHealthMathHuge()
    local Char = player.Character
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    
    Human.MaxHealth = math.huge
    Human.Health = math.huge
    
    Human:GetPropertyChangedSignal("Health"):Connect(function()
        if godModeEnabled and Human.Health < Human.MaxHealth then
            Human.Health = Human.MaxHealth
        end
    end)
end

local function applyGodMode()
    if godModeMethod == "Humanoid Replacement (Very buggy)" then
        applyHumanoidReplacement()
    elseif godModeMethod == "Health Math.huge" then
        applyHealthMathHuge()
    end
end

local function startGodMode()
    if godModeConnection then return end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        if godModeEnabled and player.Character then
            local Human = player.Character:FindFirstChildWhichIsA("Humanoid")
            if Human and Human.Health < math.huge then
                applyGodMode()
            end
        end
    end)
end

local function stopGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
end

GodModeToggle = Tabs.Player:Toggle({
    Title = "God Mode",
    Desc = "Become invincible",
    Value = false,
    Callback = function(state)
        godModeEnabled = state
        if state then
            applyGodMode()
            startGodMode()
        else
            stopGodMode()
        end
    end
})

GodModeMethodDropdown = Tabs.Player:Dropdown({
    Title = "God Mode Method",
    Values = {"Health Math.huge", "Humanoid Replacement (Very buggy)"},
    Value = "Health Math.huge",
    MenuWidth = 400,
    Callback = function(value)
        godModeMethod = value
        if godModeEnabled then
            applyGodMode()
        end
    end
})
ToggleTpwalk = false
TpwalkConnection = nil

function Tpwalking()
    if ToggleTpwalk and character and humanoid and rootPart then
        moveDirection = humanoid.MoveDirection
        moveDistance = featureStates.TpwalkValue
        origin = rootPart.Position
        direction = moveDirection * moveDistance
        targetPosition = origin + direction
        raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastResult = workspace:Raycast(origin, direction, raycastParams)
        if raycastResult then
            hitPosition = raycastResult.Position
            distanceToHit = (hitPosition - origin).Magnitude
            if distanceToHit < math.abs(moveDistance) then
                targetPosition = origin + (direction.Unit * (distanceToHit - 0.1))
            end
        end
        rootPart.CFrame = CFrame.new(targetPosition) * rootPart.CFrame.Rotation
        rootPart.CanCollide = true
    end
end

function startTpwalk()
    ToggleTpwalk = true
    if TpwalkConnection then
        TpwalkConnection:Disconnect()
    end
    TpwalkConnection = RunService.Heartbeat:Connect(Tpwalking)
end

function stopTpwalk()
    ToggleTpwalk = false
    if TpwalkConnection then
        TpwalkConnection:Disconnect()
        TpwalkConnection = nil
    end
    if rootPart then
        rootPart.CanCollide = false
    end
end

TPWALKToggle = Tabs.Player:Toggle({
    Title = "TP WALK",
    Value = featureStates.TPWALK,
    Callback = function(state)
        featureStates.TPWALK = state
        if state then
            startTpwalk()
        else
            stopTpwalk()
        end
    end
})

TPWALKSlider = Tabs.Player:Slider({
    Title = "TPWALK VALUE",
    Desc = "Adjust TPWALK speed",
    Value = { Min = 1, Max = 200, Default = featureStates.TpwalkValue, Step = 1 },
    Callback = function(value)
        featureStates.TpwalkValue = value
    end
})

jumpCount = 0
MAX_JUMPS = math.huge

function setupJumpBoost()
    if not character or not humanoid then return end
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            jumpCount = 0
        end
    end)
    humanoid.Jumping:Connect(function(isJumping)
        if isJumping and featureStates.JumpBoost and jumpCount < MAX_JUMPS then
            jumpCount = jumpCount + 1
            humanoid.JumpHeight = featureStates.JumpPower
            if jumpCount > 1 then
                rootPart:ApplyImpulse(Vector3.new(0, featureStates.JumpPower * rootPart.Mass, 0))
            end
        end
    end)
end

function startJumpBoost()
    if humanoid then
        humanoid.JumpPower = featureStates.JumpPower
        humanoid.JumpHeight = featureStates.JumpPower
    end
    setupJumpBoost()
end

function stopJumpBoost()
    jumpCount = 0
    if humanoid then
        humanoid.JumpPower = 50
        humanoid.JumpHeight = 50
    end
end

JumpBoostToggle = Tabs.Player:Toggle({
    Title = "Jump Height",
    Value = featureStates.JumpBoost,
    Callback = function(state)
        featureStates.JumpBoost = state
        if state then
            startJumpBoost()
        else
            stopJumpBoost()
        end
    end
})

JumpBoostSlider = Tabs.Player:Slider({
    Title = "Jump Power",
    Desc = "Adjust jump height",
    Value = { Min = 1, Max = 200, Default = featureStates.JumpPower, Step = 1 },
    Callback = function(value)
        featureStates.JumpPower = value
        if featureStates.JumpBoost then
            if humanoid then
                humanoid.JumpPower = featureStates.JumpPower
                humanoid.JumpHeight = featureStates.JumpPower
            end
        end
    end
})

Tabs.Player:Button({
    Title = "Walk on Walls (must reset to stop)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty21.lua"))()
    end
})
Tabs.Player:Toggle({
    Title = "Fake dead (lays)",
    Compact = true,
    Value = false,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        if v then
            if hrp and hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    animator:Destroy()
                end

                hum:ChangeState(Enum.HumanoidStateType.Physics)
                hrp.Anchored = true
                hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0)
                hrp.CFrame = hrp.CFrame + Vector3.new(0, -2.5, 0)
            end
        else
            if hrp and hum then
                hrp.Anchored = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)

                if not hum:FindFirstChild("Animator") then
                    local newAnimator = Instance.new("Animator")
                    newAnimator.Parent = hum
                end
            end
        end
    end
})


Tabs.Combat:Section({ Title = "Combat", TextSize = 40 })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local AimbotEnabled = false
local ShowFOV = false
local FOVThickness = 2
local FOVColor = Color3.new(0, 1, 0)
local LocalPlayer = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local targetRoles = {}
local aimPart = "Head"
local smoothnessValue = 10
local wallCheckEnabled = false
local fovRadius = 100
local lockFOVToCenter = true

local AimbotCircle

local function getAimPart(character)
    if aimPart == "Head" then
        return character:FindFirstChild("Head")
    elseif aimPart == "Body" then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    elseif aimPart == "Legs" then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return character:FindFirstChild("Head")
end

local function getPlayerRole(player)
    return "Unknown"
end

local function isVisible(part)
    if not wallCheckEnabled then
        return true
    end
    
    local character = LocalPlayer.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local origin = humanoidRootPart.Position
    local target = part.Position
    local direction = (target - origin).Unit
    local ray = Ray.new(origin, direction * (target - origin).Magnitude)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {character, part.Parent})
    
    return hit == nil or hit:IsDescendantOf(part.Parent)
end

local function lookAt(pos)
    local currentCFrame = Cam.CFrame
    local lookVector = (pos - currentCFrame.Position).Unit
    local targetCFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + lookVector)
    
    Cam.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smoothnessValue)
end

local function getClosestEnemyInFOV()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    if lockFOVToCenter then
        local screenCenter = Cam.ViewportSize / 2
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local aimPartInstance = getAimPart(char)
                    if aimPartInstance then
                        local playerRole = getPlayerRole(player)
                        local shouldTarget = false
                        
                        if #targetRoles == 0 then
                            shouldTarget = true
                        else
                            for _, role in ipairs(targetRoles) do
                                if (role == "Murderer" and playerRole == "Murderer") or
                                   (role == "Sheriff" and playerRole == "Sheriff") or
                                   (role == "Hero" and playerRole == "Hero") or
                                   (role == "Innocent" and playerRole == "Innocent") or
                                   (role == "Unknown" and playerRole == "Unknown") then
                                    shouldTarget = true
                                    break
                                end
                            end
                        end
                        
                        if shouldTarget then
                            local screenPos, visible = Cam:WorldToViewportPoint(aimPartInstance.Position)
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                            if visible and distance < fovRadius and distance < closestDistance and isVisible(aimPartInstance) then
                                closestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    else
        local mousePos = UserInputService:GetMouseLocation()
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local aimPartInstance = getAimPart(char)
                    if aimPartInstance then
                        local playerRole = getPlayerRole(player)
                        local shouldTarget = false
                        
                        if #targetRoles == 0 then
                            shouldTarget = true
                        else
                            for _, role in ipairs(targetRoles) do
                                if (role == "Murderer" and playerRole == "Murderer") or
                                   (role == "Sheriff" and playerRole == "Sheriff") or
                                   (role == "Hero" and playerRole == "Hero") or
                                   (role == "Innocent" and playerRole == "Innocent") or
                                   (role == "Unknown" and playerRole == "Unknown") then
                                    shouldTarget = true
                                    break
                                end
                            end
                        end
                        
                        if shouldTarget then
                            local screenPoint, onScreen = Cam:WorldToScreenPoint(aimPartInstance.Position)
                            if onScreen then
                                local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                                if distance < fovRadius and distance < closestDistance and isVisible(aimPartInstance) then
                                    closestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function createFOVCircle()
    if AimbotCircle then AimbotCircle:Remove() end
    
    local circle = Drawing.new("Circle")
    circle.Visible = ShowFOV
    circle.Radius = fovRadius
    circle.Color = FOVColor
    circle.Thickness = FOVThickness
    circle.Filled = false
    
    if lockFOVToCenter then
        local viewportSize = Cam.ViewportSize
        circle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    else
        circle.Position = UserInputService:GetMouseLocation()
    end
    
    AimbotCircle = circle
    
    RunService.RenderStepped:Connect(function()
        if circle then
            circle.Radius = fovRadius
            circle.Visible = ShowFOV
            circle.Color = FOVColor
            circle.Thickness = FOVThickness
            
            if lockFOVToCenter then
                local viewportSize = Cam.ViewportSize
                circle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            else
                circle.Position = UserInputService:GetMouseLocation()
            end
        end
    end)
end

local function updateDrawings()
    if AimbotCircle then
        AimbotCircle.Visible = ShowFOV
        AimbotCircle.Radius = fovRadius
        AimbotCircle.Color = FOVColor
        AimbotCircle.Thickness = FOVThickness
        
        if lockFOVToCenter then
            local viewportSize = Cam.ViewportSize
            AimbotCircle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        else
            AimbotCircle.Position = UserInputService:GetMouseLocation()
        end
    end
end

local function startAimbot()
    createFOVCircle()
    
    LocalPlayer.CharacterAdded:Connect(function()
        if AimbotEnabled then
            wait(1)
            if AimbotCircle then
                AimbotCircle:Remove()
            end
            createFOVCircle()
        end
    end)
    
    spawn(function()
        while AimbotEnabled do
            RunService.RenderStepped:Wait()
            
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character.Humanoid.Health <= 0 then
                continue
            end
            
            local closestPlayer = getClosestEnemyInFOV()
            if closestPlayer then
                local char = closestPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local aimPartInstance = getAimPart(char)
                    if aimPartInstance then
                        lookAt(aimPartInstance.Position)
                    end
                end
            end
        end
    end)
end

local function stopAimbot()
    if AimbotCircle then
        AimbotCircle:Remove()
        AimbotCircle = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if AimbotEnabled then
        if AimbotCircle then
            AimbotCircle:Remove()
        end
        createFOVCircle()
    end
end)

Tabs.Combat:Section({ Title = "Aimbot Settings" })

AimbotToggle = Tabs.Combat:Toggle({
    Title = "Aimbot",
    Value = false,
    Callback = function(state)
        AimbotEnabled = state
        if state then
            startAimbot()
        else
            stopAimbot()
        end
    end
})

AimPartDropdown = Tabs.Combat:Dropdown({
    Title = "Aim Part",
    Desc = "Select which part to aim at",
    Values = { "Head", "Body", "Legs" },
    Value = "Head",
    Callback = function(value)
        aimPart = value
    end
})

TargetRoleDropdown = Tabs.Combat:Dropdown({
    Title = "Target Role",
    Desc = "Select which roles to target",
    Values = { "Murderer", "Sheriff", "Hero", "Innocent", "Unknown" },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        targetRoles = values
    end
})

SmoothnessInput = Tabs.Combat:Input({
    Title = "Smoothness",
    Desc = "Higher = smoother aim, Lower = snappier aim (1-20)",
    Value = "10",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 1 and numValue <= 20 then
            smoothnessValue = numValue
        else
            smoothnessValue = 10
        end
    end
})

WallCheckToggle = Tabs.Combat:Toggle({
    Title = "Wall Check",
    Value = false,
    Callback = function(state)
        wallCheckEnabled = state
    end
})

Tabs.Combat:Section({ Title = "FOV Settings" })

ShowFOVToggle = Tabs.Combat:Toggle({
    Title = "Show FOV Circle",
    Value = false,
    Callback = function(state)
        ShowFOV = state
        updateDrawings()
    end
})

LockFOVToggle = Tabs.Combat:Toggle({
    Title = "Lock FOV On Middle Screen",
    Value = true,
    Callback = function(state)
        lockFOVToCenter = state
        updateDrawings()
    end
})

FOVRadiusInput = Tabs.Combat:Input({
    Title = "FOV Radius",
    Desc = "Size of the targeting area (10-500)",
    Value = "100",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 10 and numValue <= 500 then
            fovRadius = numValue
            updateDrawings()
        else
            fovRadius = 100
            updateDrawings()
        end
    end
})

FOVColorPicker = Tabs.Combat:Colorpicker({
    Title = "FOV Color",
    Desc = "FOV Circle Color",
    Default = Color3.fromRGB(0, 255, 0),
    Locked = false,
    Callback = function(color)
        FOVColor = color
        updateDrawings()
    end
})

FOVThicknessInput = Tabs.Combat:Input({
    Title = "FOV Thickness",
    Desc = "Thickness of the FOV circle (1-10)",
    Value = "2",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue and numValue >= 1 and numValue <= 10 then
            FOVThickness = numValue
            updateDrawings()
        else
            FOVThickness = 2
            updateDrawings()
        end
    end
})
Tabs.Combat:Section({ Title = "Gun Combat", TextSize = 20 })
Tabs.Combat:Divider()
local sheriffButton = nil
local sheriffGui = nil
local sheriffButtonActive = false
local shotType = "Default"
local buttonSize = 60
local autoShootEnabled = false
local shootOffset = 0
local pingMultiplier = 0

local function makeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
    
    local dragDetector = Instance.new("UIDragDetector")
    dragDetector.Parent = frame
    
    local originalBackground = frame.BackgroundColor3
    local originalTransparency = frame.BackgroundTransparency
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            frame.BackgroundTransparency = originalTransparency - 0.1
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            frame.BackgroundTransparency = originalTransparency
        end
    end)
end

local function GetMurderer()
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if not success or not roles then
        return nil
    end
    
    for name, data in pairs(roles) do
        if data.Role == "Murderer" then
            return Players:FindFirstChild(name)
        end
    end
    return nil
end

local function IsMurdererVisible(murderer)
    if not murderer or not murderer.Character then return false end
    
    local localChar = LocalPlayer.Character
    if not localChar then return false end
    
    local localHead = localChar:FindFirstChild("Head")
    local murdererHead = murderer.Character:FindFirstChild("Head")
    
    if not localHead or not murdererHead then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localChar, murderer.Character}
    
    local direction = (murdererHead.Position - localHead.Position)
    local raycastResult = workspace:Raycast(localHead.Position, direction, raycastParams)
    
    return raycastResult == nil
end

local function ShootMurderer()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character.Humanoid.Health <= 0 then
        return false
    end
    
    local murderer = GetMurderer()
    if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Humanoid") or murderer.Character.Humanoid.Health <= 0 then
        return false
    end
    
    if not IsMurdererVisible(murderer) then
        return false
    end
    
    local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
    if not gun then
        return false
    end
    
    if gun and not LocalPlayer.Character:FindFirstChild("Gun") then
        gun.Parent = LocalPlayer.Character
    end
    
    gun = LocalPlayer.Character:FindFirstChild("Gun")
    if gun and gun:FindFirstChild("KnifeLocal") then
        local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            local targetPos = targetPart.Position
            local murdererHumanoid = murderer.Character:FindFirstChildOfClass("Humanoid")
            
            if shootOffset ~= 0 and murdererHumanoid then
                local moveDirection = murdererHumanoid.MoveDirection
                if moveDirection.Magnitude > 0 then
                    local offsetDirection = moveDirection.Unit
                    local finalOffset = shootOffset * pingMultiplier
                    targetPos = targetPos + (offsetDirection * finalOffset)
                end
            end
            
            local args = {[1] = 1, [2] = targetPos, [3] = "AH2"}
            gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
            return true
        end
    end
    return false
end

local function startAutoShoot()
    while autoShootEnabled do
        ShootMurderer()
        task.wait(0.1)
    end
end

local function createSheriffGui()
    if sheriffGui then
        sheriffGui:Destroy()
        sheriffGui = nil
    end
    
    sheriffGui = Instance.new("ScreenGui")
    sheriffGui.Name = "SheriffGui"
    sheriffGui.IgnoreGuiInset = true
    sheriffGui.ResetOnSpawn = false
    sheriffGui.Enabled = true
    sheriffGui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    frame.Position = UDim2.new(0.5, -30, 0.12, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel = 0
    frame.Parent = sheriffGui
    makeDraggable(frame)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 150, 150)
    stroke.Thickness = 2
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = "SHOT"
    label.Size = UDim2.new(0.9, 0, 0.5, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Roboto
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextScaled = true
    label.Parent = frame

    sheriffButton = Instance.new("TextButton")
    sheriffButton.Name = "TriggerButton"
    sheriffButton.Text = "FIRE"
    sheriffButton.Size = UDim2.new(0.9, 0, 0.5, 0)
    sheriffButton.Position = UDim2.new(0.05, 0, 0.5, 0)
    sheriffButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    sheriffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sheriffButton.Font = Enum.Font.Roboto
    sheriffButton.TextSize = 14
    sheriffButton.TextXAlignment = Enum.TextXAlignment.Center
    sheriffButton.TextYAlignment = Enum.TextYAlignment.Center
    sheriffButton.TextScaled = true
    sheriffButton.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = sheriffButton

    sheriffButton.MouseButton1Click:Connect(function()
        ShootMurderer()
    end)
    
    sheriffButtonActive = true
end

local function removeSheriffGui()
    if sheriffGui then
        sheriffGui:Destroy()
        sheriffGui = nil
    end
    sheriffButton = nil
    sheriffButtonActive = false
end

Tabs.Combat:Toggle({
    Title = "Auto Shoot Murderer",
    Value = false,
    Callback = function(state)
        autoShootEnabled = state
        if state then
            task.spawn(startAutoShoot)
        end
    end
})

Tabs.Combat:Input({
    Title = "Shoot Position Offset",
    Placeholder = "0",
    Value = "0",
    Callback = function(text)
        shootOffset = tonumber(text) or 0
    end
})

Tabs.Combat:Input({
    Title = "Offset-to-Ping Multiplier",
    Placeholder = "0",
    Value = "0",
    Callback = function(text)
        pingMultiplier = tonumber(text) or 1
    end
})

Tabs.Combat:Button({
    Title = "Shoot Murderer",
    Callback = function()
        ShootMurderer()
    end
})
Tabs.Combat:Keybind({
    Title = "Shoot Murderer Keybind",
    Value = "E",
    Callback = function(key)
        local keyCode = Enum.KeyCode[key]
        if keyCode then
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == keyCode then
                    ShootMurderer()
                end
            end)
            
            return function()
                if connection then
                    connection:Disconnect()
                end
            end
        end
    end
})

Tabs.Combat:Button({
    Title = "Toggle Shot Button",
    Callback = function()
        if sheriffButtonActive then
            removeSheriffGui()
        else
            createSheriffGui()
        end
    end
})

Tabs.Combat:Slider({
    Title = "Button Size",
    Step = 1,
    Value = {Min = 40, Max = 100, Default = 60},
    Callback = function(size)
        buttonSize = size
        if sheriffButtonActive then
            removeSheriffGui()
            createSheriffGui()
        end
    end
})
local murderTpEnabled = false
local murderTpConnection = nil
local tpOffset = Vector3.new(0, 15, 0)

local function parseOffsetInput(input)
    local x, y, z = 0, 15, 0
    
    if input and input ~= "" then
        local cleaned = input:gsub("%s+", " "):gsub(",", " "):gsub("^%s+", ""):gsub("%s+$", "")
        local parts = {}
        for part in cleaned:gmatch("[%-%d%.]+") do
            table.insert(parts, tonumber(part))
        end
        
        if #parts >= 1 then x = parts[1] or 0 end
        if #parts >= 2 then y = parts[2] or 15 end
        if #parts >= 3 then z = parts[3] or 0 end
    end
    
    return Vector3.new(x, y, z)
end

local function StartMurderTp()
    if murderTpConnection then return end
    
    murderTpConnection = RunService.Heartbeat:Connect(function()
        if not murderTpEnabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local murderer = GetMurderer()
        if not murderer or not murderer.Character then return end
        
        local murderRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
        if not murderRoot then return end
        
        rootPart.CFrame = murderRoot.CFrame + tpOffset
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    end)
end

local function StopMurderTp()
    if murderTpConnection then
        murderTpConnection:Disconnect()
        murderTpConnection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

Tabs.Combat:Input({
    Title = "TP Offset (X Y Z)",
    Placeholder = "0 15 0",
    Value = "0 15 0",
    Callback = function(text)
        tpOffset = parseOffsetInput(text)
    end
})

Tabs.Combat:Toggle({
    Title = "Murder CFrame TP",
    Value = false,
    Callback = function(state)
        murderTpEnabled = state
        if state then
            StartMurderTp()
        else
            StopMurderTp()
        end
    end
})
local GunSystem = {
    AutoGrabEnabled = false,
    NotifyGun = false,
    GunDropCheckInterval = 1,
    ActiveGunDrops = {},
    Mode = "Grab only"
}

local notifiedGunPickups = {}
local notifiedGunSpawns = {}

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local originalPosition = humanoidRootPart.Position

local function ScanForGunDrops()
    GunSystem.ActiveGunDrops = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then
            table.insert(GunSystem.ActiveGunDrops, obj)
        end
    end
end

local function EquipGun()
    if (player.Character and player.Character:FindFirstChild("Gun")) then
        return true
    end
    local gun = player.Backpack:FindFirstChild("Gun")
    if gun then
        gun.Parent = player.Character
        task.wait(0.1)
        return player.Character:FindFirstChild("Gun") ~= nil
    end
    return false
end

local function GetMurderer()
    local roles = ReplicatedStorage:FindFirstChild("GetPlayerData"):InvokeServer()
    for playerName, data in pairs(roles) do
        if (data.Role == "Murderer") then
            return Players:FindFirstChild(playerName)
        end
    end
end

local function ShootMurderer()
    local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    local murderer = nil
    for name, data in pairs(roles) do
        if (data.Role == "Murderer") then
            murderer = Players:FindFirstChild(name)
            break
        end
    end
    if (not murderer or not murderer.Character) then
        WindUI:Notify({Title = "Gun System", Content = "Murderer not found!", Icon = "x-circle", Duration = 3})
        return false
    end
    local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
    local localRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if (targetRoot and localRoot) then
        localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)
        task.wait(0.1)
    end
    local gun = player.Character:FindFirstChild("Gun")
    if not gun then
        WindUI:Notify({Title = "Gun System", Content = "Gun not equipped!", Icon = "x-circle", Duration = 3})
        return false
    end
    local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then
        return false
    end
    local args = {[1] = 1, [2] = targetPart.Position, [3] = "AH2"}
    if (gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")) then
        gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
        WindUI:Notify({Title = "Gun System", Content = "Successfully shot the murderer!", Icon = "check-circle", Duration = 3})
        return true
    end
    return false
end

local function safeTeleport(cframe)
    pcall(function()
        if character and humanoidRootPart then
            humanoidRootPart.CFrame = cframe
        end
    end)
end

local function hasKnife()
    return player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife"))
end

local function collectAllGunDrops()
    if hasKnife() then
        WindUI:Notify({Title = "Gun System", Content = "You already have a knife!", Icon = "x-circle", Duration = 3})
        return
    end
    
    local currentPosition = humanoidRootPart.Position
    ScanForGunDrops()
    
    if #GunSystem.ActiveGunDrops == 0 then
        WindUI:Notify({Title = "Gun System", Content = "No guns available on the map", Icon = "x-circle", Duration = 3})
        return
    end
    
    for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
        if gunDrop and gunDrop.Parent then
            safeTeleport(gunDrop.CFrame + Vector3.new(0, 3, 0))
            task.wait(0.05)
            safeTeleport(CFrame.new(currentPosition))
            task.wait(0.05)
        end
    end
    
    WindUI:Notify({Title = "Gun System", Content = "Successfully collected all guns!", Icon = "check-circle", Duration = 3})
end

local function ManualGrab()
    if hasKnife() then
        WindUI:Notify({Title = "Gun System", Content = "You already have a knife!", Icon = "x-circle", Duration = 3})
        return false
    end
    
    if GunSystem.Mode == "Grab only" then
        collectAllGunDrops()
    elseif GunSystem.Mode == "Grab & shoot murderer" then
        ScanForGunDrops()
        if (#GunSystem.ActiveGunDrops == 0) then
            WindUI:Notify({Title = "Gun System", Content = "No guns available on the map", Icon = "x-circle", Duration = 3})
            return false
        end
        
        local nearestGun = nil
        local minDistance = math.huge
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            for _, drop in ipairs(GunSystem.ActiveGunDrops) do
                local distance = (humanoidRootPart.Position - drop.Position).Magnitude
                if (distance < minDistance) then
                    nearestGun = drop
                    minDistance = distance
                end
            end
        end
        
        if (nearestGun and player.Character) then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = nearestGun.CFrame
                task.wait(0.3)
                local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                    WindUI:Notify({Title = "Gun System", Content = "Successfully grabbed the gun!", Icon = "check-circle", Duration = 3})
                    
                    task.wait(0.5)
                    if EquipGun() then
                        ShootMurderer()
                    end
                    
                    return true
                end
            end
        end
        return false
    end
end

local function ImprovedGrabOnly()
    local isTeleporting = false
    local teleportDelay = 0.5

    local function teleportLoop()
        if isTeleporting then return end
        if hasKnife() then return end
        
        isTeleporting = true
        
        local currentPosition = humanoidRootPart.Position
        ScanForGunDrops()
        
        if #GunSystem.ActiveGunDrops == 0 then
            isTeleporting = false
            return
        end
        
        for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
            if gunDrop and gunDrop.Parent then
                safeTeleport(gunDrop.CFrame + Vector3.new(0, 3, 0))
                task.wait(0.05)
                safeTeleport(CFrame.new(currentPosition))
                task.wait(0.05)
            end
        end
        
        isTeleporting = false
    end

    while GunSystem.AutoGrabEnabled and GunSystem.Mode == "Grab only" do
        if not hasKnife() then
            teleportLoop()
        end
        task.wait(teleportDelay)
    end
end

local function AutoGrabGun()
    while GunSystem.AutoGrabEnabled do
        if hasKnife() then
            task.wait(GunSystem.GunDropCheckInterval)
            continue
        end
        
        if GunSystem.Mode == "Grab only" then
            ImprovedGrabOnly()
        elseif GunSystem.Mode == "Grab & shoot murderer" then
            ScanForGunDrops()
            if ((#GunSystem.ActiveGunDrops > 0) and player.Character) then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local nearestGun = nil
                    local minDistance = math.huge
                    for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
                        local distance = (humanoidRootPart.Position - gunDrop.Position).Magnitude
                        if (distance < minDistance) then
                            nearestGun = gunDrop
                            minDistance = distance
                        end
                    end
                    if nearestGun then
                        humanoidRootPart.CFrame = nearestGun.CFrame
                        task.wait(0.3)
                        local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                            
                            task.wait(0.5)
                            if EquipGun() then
                                ShootMurderer()
                            end
                            
                            task.wait(1)
                        end
                    end
                end
            end
            task.wait(GunSystem.GunDropCheckInterval)
        end
    end
end

local function monitorGunEvents()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            otherPlayer.CharacterAdded:Connect(function(character)
                character.ChildAdded:Connect(function(child)
                    if child.Name == "Gun" and GunSystem.NotifyGun then
                        if not notifiedGunPickups[otherPlayer.Name] then
                            WindUI:Notify({
                                Title = "Gun System", 
                                Content = otherPlayer.Name .. " took the gun!", 
                                Icon = "alert-circle", 
                                Duration = 5
                            })
                            notifiedGunPickups[otherPlayer.Name] = true
                        end
                    end
                end)
            end)
            
            if otherPlayer.Character then
                otherPlayer.Character.ChildAdded:Connect(function(child)
                    if child.Name == "Gun" and GunSystem.NotifyGun then
                        if not notifiedGunPickups[otherPlayer.Name] then
                            WindUI:Notify({
                                Title = "Gun System", 
                                Content = otherPlayer.Name .. " took the gun!", 
                                Icon = "alert-circle", 
                                Duration = 5
                            })
                            notifiedGunPickups[otherPlayer.Name] = true
                        end
                    end
                end)
            end
        end
    end
    
    workspace.DescendantAdded:Connect(function(child)
        if child.Name == "GunDrop" and child:IsA("BasePart") and GunSystem.NotifyGun then
            if not notifiedGunSpawns[child] then
                WindUI:Notify({
                    Title = "Gun System", 
                    Content = "A gun has spawned!", 
                    Icon = "target", 
                    Duration = 5
                })
                notifiedGunSpawns[child] = true
            end
        end
    end)
end

local function resetGunNotifications()
    workspace.DescendantAdded:Connect(function(child)
        if child.Name == "GunDrop" and child:IsA("BasePart") then
            for playerName, _ in pairs(notifiedGunPickups) do
                notifiedGunPickups[playerName] = nil
            end
            notifiedGunSpawns[child] = nil
        end
    end)
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    originalPosition = humanoidRootPart.Position
end)

Tabs.Combat:Toggle({
    Title = "Auto Grab Gun",
    Value = false,
    Callback = function(state)
        GunSystem.AutoGrabEnabled = state
        if state then
            coroutine.wrap(AutoGrabGun)()
        end
    end
})

Tabs.Combat:Button({
    Title = "Manual Grab Gun",
    Callback = function()
        ManualGrab()
    end
})

Tabs.Combat:Dropdown({
    Title = "Auto Grab Mode",
    Values = {"Grab only", "Grab & shoot murderer"},
    Value = "Grab only",
    Callback = function(value)
        GunSystem.Mode = value
    end
})

Tabs.Combat:Toggle({
    Title = "Notify Gun",
    Value = false,
    Callback = function(state)
        GunSystem.NotifyGun = state
    end
})
Tabs.Combat:Section({ Title = "Knife Combat", TextSize = 20 })
Tabs.Combat:Divider()

local killMode = "Kill Aura"
local killAuraRadius = 10
local autoKillEnabled = false
local showAuraCircle = false
local autoEquipKnife = false
local killConnection = nil
local auraConnection = nil
local anchoredPlayers = {}
local auraCircle = nil
local originalEquipState = false

local function findMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
            return plr
        end
    end
    return nil
end

local function equipKnife()
    if not player.Character:FindFirstChild("Knife") then
        if player.Backpack:FindFirstChild("Knife") then
            player.Character:FindFirstChild("Humanoid"):EquipTool(player.Backpack:FindFirstChild("Knife"))
            return true
        end
        return false
    end
    return true
end

local function updateAuraCircle()
    if auraCircle and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            auraCircle.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
        end
    end
end

local function createAuraCircle()
    if auraCircle then
        auraCircle:Destroy()
        auraCircle = nil
    end
    
    if showAuraCircle and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            auraCircle = Instance.new("Part")
            auraCircle.Name = "AuraRange"
            auraCircle.Shape = Enum.PartType.Cylinder
            auraCircle.Material = Enum.Material.Neon
            auraCircle.BrickColor = BrickColor.new("Bright red")
            auraCircle.Transparency = 0.7
            auraCircle.Anchored = true
            auraCircle.CanCollide = false
            auraCircle.Size = Vector3.new(1, killAuraRadius * 2, killAuraRadius * 2)
            auraCircle.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
            auraCircle.Parent = workspace
            
            if auraConnection then
                auraConnection:Disconnect()
            end
            
            auraConnection = RunService.Heartbeat:Connect(function()
                updateAuraCircle()
            end)
        end
    else
        if auraConnection then
            auraConnection:Disconnect()
            auraConnection = nil
        end
        if auraCircle then
            auraCircle:Destroy()
            auraCircle = nil
        end
    end
end

local function unanchorPlayers()
    for _, targetPlayer in pairs(anchoredPlayers) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.Anchored = false
            targetPlayer.Character.HumanoidRootPart.CanCollide = true
        end
    end
    anchoredPlayers = {}
end

local function disablePlayerCollision(character)
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function killAura()
    local localRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    local hasTargetInRange = false
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer ~= player then
            local targetRoot = targetPlayer.Character.HumanoidRootPart
            local distance = (targetRoot.Position - localRoot.Position).Magnitude
            
            if distance <= tonumber(killAuraRadius) then
                hasTargetInRange = true
                targetRoot.Anchored = true
                targetRoot.CanCollide = false
                anchoredPlayers[targetPlayer] = targetPlayer
                targetRoot.CFrame = localRoot.CFrame + localRoot.CFrame.LookVector * 2
                disablePlayerCollision(targetPlayer.Character)
            end
        end    
    end
    
    if autoEquipKnife and hasTargetInRange then
        equipKnife()
    end
    
    local knife = player.Character:FindFirstChild("Knife")
    if (knife and knife:FindFirstChild("Stab")) then
        for i = 1, 3 do
            knife.Stab:FireServer("Down")
        end
    end
end

local function killNearby()
    local localRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    local hasTargetClose = false
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer ~= player then
            local targetRoot = targetPlayer.Character.HumanoidRootPart
            local distance = (targetRoot.Position - localRoot.Position).Magnitude
            
            if distance <= 5 then
                hasTargetClose = true
                break
            end
        end    
    end
    
    if autoEquipKnife and hasTargetClose then
        equipKnife()
    end
    
    local knife = player.Character:FindFirstChild("Knife")
    if (knife and knife:FindFirstChild("Stab")) then
        for i = 1, 5 do
            for j = 1, 3 do
                knife.Stab:FireServer("Down")
            end
            task.wait(0.1)
        end
    end
end

local function killAll()
    if autoEquipKnife then
        equipKnife()
    end
    
    local localRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer ~= player then
            local targetRoot = targetPlayer.Character.HumanoidRootPart
            targetRoot.Anchored = true
            targetRoot.CanCollide = false
            anchoredPlayers[targetPlayer] = targetPlayer
            targetRoot.CFrame = localRoot.CFrame + localRoot.CFrame.LookVector * 2
            disablePlayerCollision(targetPlayer.Character)
        end    
    end
    
    local knife = player.Character:FindFirstChild("Knife")
    if (knife and knife:FindFirstChild("Stab")) then
        for i = 1, 3 do
            knife.Stab:FireServer("Down")
        end
    end
end

local function startAutoKill()
    if killConnection then return end
    
    killConnection = RunService.Heartbeat:Connect(function()
        if autoKillEnabled and findMurderer() == player then
            if killMode == "Kill Aura" then
                killAura()
            elseif killMode == "Kill Nearby" then
                killNearby()
            elseif killMode == "Kill All" then
            local backpack = player:WaitForChild("Backpack")
local knife = backpack:FindFirstChild("Knife")

if knife then
    knife.Parent = player.Character
end
                killAll()
            end
        end
    end)
end

local function stopAutoKill()
    if killConnection then
        killConnection:Disconnect()
        killConnection = nil
    end
    unanchorPlayers()
end

AutoEquipKnifeToggle = Tabs.Combat:Toggle({
    Title = "Auto Equip Knife",
    Value = false,
    Callback = function(state)
        autoEquipKnife = state
        originalEquipState = state
    end
})

KillModeDropdown = Tabs.Combat:Dropdown({
    Title = "Kill Mode",
    Values = {"Kill Aura", "Kill Nearby", "Kill All"},
    Value = "Kill Aura",
    Callback = function(value)
        killMode = value
        unanchorPlayers()
    end
})

KillAuraSlider = Tabs.Combat:Slider({
    Title = "Knife Kill Aura Rage",
    Desc = "Adjust kill aura radius",
    Value = { Min = 1, Max = 200, Default = 10, Step = 1 },
    Callback = function(value)
        killAuraRadius = tonumber(value)
        if auraCircle then
            auraCircle.Size = Vector3.new(1, killAuraRadius * 2, killAuraRadius * 2)
        end
    end
})

ShowAuraToggle = Tabs.Combat:Toggle({
    Title = "Show Aura Circle",
    Value = false,
    Callback = function(state)
        showAuraCircle = state
        createAuraCircle()
    end
})

AutoKillToggle = Tabs.Combat:Toggle({
    Title = "Auto Kill",
    Value = false,
    Callback = function(state)
        autoKillEnabled = state
        if state then
            startAutoKill()
        else
            stopAutoKill()
        end
    end
})
Tabs.Combat:Button({
    Title = "Kill All",
    Desc = "Teleport and kill all players",
    Icon = "target",
    Callback = function()
        if findMurderer() ~= player then return end
        
local backpack = player:WaitForChild("Backpack")
local knife = backpack:FindFirstChild("Knife")

if knife then
    knife.Parent = player.Character
end
        local localRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer ~= player then
                local targetRoot = targetPlayer.Character.HumanoidRootPart
                targetRoot.Anchored = true
                targetRoot.CanCollide = false
                targetRoot.CFrame = localRoot.CFrame + localRoot.CFrame.LookVector * 2
                disablePlayerCollision(targetPlayer.Character)
            end    
        end
        
        local knife = player.Character:FindFirstChild("Knife")
        if (knife and knife:FindFirstChild("Stab")) then
            for i = 1, 3 do
                knife.Stab:FireServer("Down")
            end
        end
    end
})
task.spawn(function()
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    ScanForGunDrops()
    if GunSystem.AutoGrabEnabled then
        coroutine.wrap(AutoGrabGun)()
    end
    monitorGunEvents()
    resetGunNotifications()
end)
Tabs.Visuals:Section({ Title = "Visual", TextSize = 20 })
    Tabs.Visuals:Divider()
    local cameraStretchConnection
local function setupCameraStretch()
    cameraStretchConnection = nil
    local stretchHorizontal = 0.80
    local stretchVertical = 0.80
    CameraStretchToggle = Tabs.Visuals:Toggle({
        Title = "Camera Stretch",
        Value = false,
        Callback = function(state)
            if state then
                if cameraStretchConnection then cameraStretchConnection:Disconnect() end
                cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    local Camera = workspace.CurrentCamera
                    Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
                end)
            else
                if cameraStretchConnection then
                    cameraStretchConnection:Disconnect()
                    cameraStretchConnection = nil
                end
            end
        end
    })

    CameraStretchHorizontalInput = Tabs.Visuals:Input({
        Title = "Camera Stretch Horizontal",
        Placeholder = "0.80",
        Numeric = true,
        Value = tostring(stretchHorizontal),
        Callback = function(value)
            local num = tonumber(value)
            if num then
                stretchHorizontal = num
                if cameraStretchConnection then
                    cameraStretchConnection:Disconnect()
                    cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
                        local Camera = workspace.CurrentCamera
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
                    end)
                end
            end
        end
    })

    CameraStretchVerticalInput = Tabs.Visuals:Input({
        Title = "Camera Stretch Vertical",
        Placeholder = "0.80",
        Numeric = true,
        Value = tostring(stretchVertical),
        Callback = function(value)
            local num = tonumber(value)
            if num then
                stretchVertical = num
                if cameraStretchConnection then
                    cameraStretchConnection:Disconnect()
                    cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
                        local Camera = workspace.CurrentCamera
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
                    end)
                end
            end
        end
    })
end
	    FullBrightToggle = Tabs.Visuals:Toggle({
    Title = "Full Bright",
    Desc = "Ya Like drinking Night Vision while mining in da cave and sceard of creeper blow you up dawg?",
    Value = false,
    Callback = function(state)
        featureStates.FullBright = state
        if state then
            local Lighting = game:GetService("Lighting")
            
            featureStates.originalBrightness = Lighting.Brightness
            featureStates.originalAmbient = Lighting.Ambient
            featureStates.originalOutdoorAmbient = Lighting.OutdoorAmbient
            featureStates.originalColorShiftBottom = Lighting.ColorShift_Bottom
            featureStates.originalColorShiftTop = Lighting.ColorShift_Top
            
            local function applyFullBright()
                if Lighting.Brightness ~= 1 then
                    Lighting.Brightness = 1
                end
                if Lighting.Ambient ~= Color3.new(1, 1, 1) then
                    Lighting.Ambient = Color3.new(1, 1, 1)
                end
                if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then
                    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                end
                if Lighting.ColorShift_Bottom ~= Color3.new(1, 1, 1) then
                    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
                end
                if Lighting.ColorShift_Top ~= Color3.new(1, 1, 1) then
                    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
                end
            end
            
            applyFullBright()
            
            if featureStates.fullBrightConnection then
                featureStates.fullBrightConnection:Disconnect()
            end
            
            featureStates.fullBrightConnection = RunService.Heartbeat:Connect(function()
                if featureStates.FullBright then
                    applyFullBright()
                end
            end)
            
            featureStates.fullBrightCharConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if featureStates.FullBright then
                    applyFullBright()
                end
            end)
            
        else
            if featureStates.fullBrightConnection then
                featureStates.fullBrightConnection:Disconnect()
                featureStates.fullBrightConnection = nil
            end
            
            if featureStates.fullBrightCharConnection then
                featureStates.fullBrightCharConnection:Disconnect()
                featureStates.fullBrightCharConnection = nil
            end
            
            if featureStates.originalBrightness then
                local Lighting = game:GetService("Lighting")
                Lighting.Brightness = featureStates.originalBrightness
                Lighting.Ambient = featureStates.originalAmbient
                Lighting.OutdoorAmbient = featureStates.originalOutdoorAmbient
                Lighting.ColorShift_Bottom = featureStates.originalColorShiftBottom
                Lighting.ColorShift_Top = featureStates.originalColorShiftTop
            end
        end
    end
})
local FOVSlider = Tabs.Visuals:Slider({
    Title = "Field of View",
    Value = { Min = 1, Max = 120, Default = originalFOV, Step = 1 },
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = tonumber(value)
    end
})
local roundTimerEnabled = false
local roundTimerGui = nil
local roundTimerLabel = nil
local roundTimerConnection = nil
local clearTweensConnection = nil
local loadingMapConnection = nil
local roleSelectConnection = nil
local victoryConnection = nil
local lastTimerText = ""
local freezeCheckTime = 0
local freezeThreshold = 3
local isWaitingForMapVote = false
local isLoadingMap = false
local roleDisplayTime = 0
local roleDisplayDuration = 5
local countdownStartTime = 0
local isInCountdown = false
local timeUpDisplayTime = 0
local timeUpDisplayDuration = 3
local victoryDisplayTime = 0
local victoryDisplayDuration = 5

local function createRoundTimerGui()
    if roundTimerGui then
        roundTimerGui:Destroy()
        roundTimerGui = nil
    end
    
    roundTimerGui = Instance.new("ScreenGui")
    roundTimerGui.Name = "RoundTimerGui"
    roundTimerGui.IgnoreGuiInset = true
    roundTimerGui.ResetOnSpawn = false
    roundTimerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    roundTimerGui.Parent = playerGui

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = roundTimerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = UDim2.new(0.5, -100, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = roundTimerGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    roundTimerLabel = Instance.new("TextLabel")
    roundTimerLabel.Size = UDim2.new(1, 0, 1, 0)
    roundTimerLabel.BackgroundTransparency = 1
    roundTimerLabel.Text = "Round Timer: --:--"
    roundTimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    roundTimerLabel.Font = Enum.Font.RobotoMono
    roundTimerLabel.TextSize = 18
    roundTimerLabel.TextScaled = false
    roundTimerLabel.TextXAlignment = Enum.TextXAlignment.Center
    roundTimerLabel.TextYAlignment = Enum.TextYAlignment.Center
    roundTimerLabel.Parent = frame
end

local function checkRoleSelectorCountdown()
    local mainGUI = player.PlayerGui:FindFirstChild("MainGUI")
    if not mainGUI then return false end
    
    local gameFrame = mainGUI:FindFirstChild("Game")
    if not gameFrame then return false end
    
    local roleSelector = gameFrame:FindFirstChild("RoleSelector")
    if not roleSelector or not roleSelector.Visible then return false end
    
    local roleText = roleSelector:FindFirstChild("Role")
    if not roleText then return false end
    
    local text = roleText.Text
    local number = tonumber(text)
    
    if number then
        roundTimerLabel.Text = "Round start in " .. number
        countdownStartTime = tick()
        isInCountdown = true
        return true
    end
    
    return false
end

local function updateRoundTimer()
    if not roundTimerEnabled or not roundTimerLabel then return end
    
    if tick() - victoryDisplayTime < victoryDisplayDuration then
        return
    end
    
    if tick() - timeUpDisplayTime < timeUpDisplayDuration then
        return
    end
    
    if isInCountdown then
        if tick() - countdownStartTime >= 1 then
            isInCountdown = false
        else
            return
        end
    end
    
    if checkRoleSelectorCountdown() then
        return
    end
    
    if tick() - roleDisplayTime < roleDisplayDuration then
        return
    end
    
    if isLoadingMap then
        roundTimerLabel.Text = "Loading map..."
        return
    end
    
    if isWaitingForMapVote then
        roundTimerLabel.Text = "Waiting for map vote"
        return
    end
    
    local timerPart = workspace:FindFirstChild("RoundTimerPart")
    if not timerPart then
        roundTimerLabel.Text = "Round Timer: --:--"
        lastTimerText = ""
        freezeCheckTime = tick()
        return
    end
    
    local surfaceGui = timerPart:FindFirstChildOfClass("SurfaceGui")
    if not surfaceGui then
        roundTimerLabel.Text = "Round Timer: --:--"
        lastTimerText = ""
        freezeCheckTime = tick()
        return
    end
    
    local timerLabel = surfaceGui:FindFirstChild("Timer")
    if not timerLabel then
        roundTimerLabel.Text = "Round Timer: --:--"
        lastTimerText = ""
        freezeCheckTime = tick()
        return
    end
    
    local currentText = timerLabel.Text
    local displayText = "Round Timer: " .. currentText
    
    if currentText == "1s" or currentText == "0s" then
        roundTimerLabel.Text = "Time's up"
        timeUpDisplayTime = tick()
        return
    end
    
    if currentText == lastTimerText then
        if tick() - freezeCheckTime >= freezeThreshold then
            roundTimerLabel.Text = displayText
            return
        end
    else
        lastTimerText = currentText
        freezeCheckTime = tick()
    end
    
    roundTimerLabel.Text = displayText
end

local function setupClearTweensListener()
    if clearTweensConnection then
        clearTweensConnection:Disconnect()
        clearTweensConnection = nil
    end
    
    local ClientTweenEvents = ReplicatedStorage:WaitForChild("ClientTweenEvents")
    local ClearTweens = ClientTweenEvents:WaitForChild("ClearTweens")
    
    clearTweensConnection = ClearTweens.OnClientEvent:Connect(function(...)
        if roundTimerEnabled and roundTimerLabel then
            isWaitingForMapVote = true
            isLoadingMap = false
            lastTimerText = ""
            freezeCheckTime = tick()
            timeUpDisplayTime = 0
            victoryDisplayTime = 0
        end
    end)
end

local function setupLoadingMapListener()
    if loadingMapConnection then
        loadingMapConnection:Disconnect()
        loadingMapConnection = nil
    end
    
    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
    local Gameplay = Remotes:WaitForChild("Gameplay")
    local LoadingMap = Gameplay:WaitForChild("LoadingMap")
    
    loadingMapConnection = LoadingMap.OnClientEvent:Connect(function(mapName)
        if roundTimerEnabled and roundTimerLabel then
            isLoadingMap = true
            isWaitingForMapVote = false
            lastTimerText = ""
            freezeCheckTime = tick()
            timeUpDisplayTime = 0
            victoryDisplayTime = 0
        end
    end)
end

local function setupRoleSelectListener()
    if roleSelectConnection then
        roleSelectConnection:Disconnect()
        roleSelectConnection = nil
    end
    
    local RoleSelect = ReplicatedStorage.Remotes.Gameplay.RoleSelect
    roleSelectConnection = RoleSelect.OnClientEvent:Connect(function(role, ...)
        if roundTimerEnabled and roundTimerLabel then
            local roleName = role or "Unknown"
            roundTimerLabel.Text = "Your role is " .. roleName
            roleDisplayTime = tick()
            isLoadingMap = false
            isWaitingForMapVote = false
            timeUpDisplayTime = 0
            victoryDisplayTime = 0
        end
    end)
end

local function setupVictoryListener()
    if victoryConnection then
        victoryConnection:Disconnect()
        victoryConnection = nil
    end
    
    local VictoryRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("VictoryScreen")
    
    victoryConnection = VictoryRemote.OnClientEvent:Connect(function(arg1, arg2, arg3, arg4, arg5)
        if roundTimerEnabled and roundTimerLabel then
            if arg2 == "MurdererLeft" then
                roundTimerLabel.Text = "Murder left"
            elseif arg2 == "MurdererWin" then
                roundTimerLabel.Text = "Murder Win"
            else
                roundTimerLabel.Text = arg2 .. " win"
            end
            victoryDisplayTime = tick()
            timeUpDisplayTime = 0
        end
    end)
end

local function startRoundTimer()
    if roundTimerConnection then return end
    
    createRoundTimerGui()
    setupClearTweensListener()
    setupLoadingMapListener()
    setupRoleSelectListener()
    setupVictoryListener()
    
    lastTimerText = ""
    freezeCheckTime = tick()
    isWaitingForMapVote = false
    isLoadingMap = false
    roleDisplayTime = 0
    countdownStartTime = 0
    isInCountdown = false
    timeUpDisplayTime = 0
    victoryDisplayTime = 0
    
    roundTimerConnection = RunService.Heartbeat:Connect(function()
        updateRoundTimer()
    end)
end

local function stopRoundTimer()
    if roundTimerConnection then
        roundTimerConnection:Disconnect()
        roundTimerConnection = nil
    end
    
    if clearTweensConnection then
        clearTweensConnection:Disconnect()
        clearTweensConnection = nil
    end
    
    if loadingMapConnection then
        loadingMapConnection:Disconnect()
        loadingMapConnection = nil
    end
    
    if roleSelectConnection then
        roleSelectConnection:Disconnect()
        roleSelectConnection = nil
    end
    
    if victoryConnection then
        victoryConnection:Disconnect()
        victoryConnection = nil
    end
    
    if roundTimerGui then
        roundTimerGui:Destroy()
        roundTimerGui = nil
        roundTimerLabel = nil
    end
    
    lastTimerText = ""
    freezeCheckTime = 0
    isWaitingForMapVote = false
    isLoadingMap = false
    roleDisplayTime = 0
    countdownStartTime = 0
    isInCountdown = false
    timeUpDisplayTime = 0
    victoryDisplayTime = 0
end

RoundTimerToggle = Tabs.Visuals:Toggle({
    Title = "Round Timer Display",
    Desc = "Show round timer in top middle of screen",
    Value = false,
    Callback = function(state)
        roundTimerEnabled = state
        if state then
            startRoundTimer()
        else
            stopRoundTimer()
        end
    end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        stopRoundTimer()
    end
end)
setupCameraStretch()
innocentEspElements = {}
murderEspElements = {}
sheriffEspElements = {}
coinEspElements = {}
gunEspElements = {}

playerEspConnection = nil
roleUpdateConnection = nil
roleData = {}
lastRoleUpdate = 0
roleUpdating = false
HighlightsConnection = nil
coinEspConnection = nil
gunEspConnection = nil

local getPlayerDataRemote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)

featureStates.CoinESP = featureStates.CoinESP or {
    names = false,
    boxes = false,
    tracers = false,
    distance = false,
    boxType = "3D"
}

featureStates.GunESP = featureStates.GunESP or {
    names = false,
    boxes = false,
    tracers = false,
    distance = false,
    boxType = "3D"
}

featureStates.CoinHighlights = featureStates.CoinHighlights or false
featureStates.GunHighlights = featureStates.GunHighlights or false

local lastCoinSearch = 0
local lastGunSearch = 0
local coinCache = {}
local gunCache = {}
local cachedPlayers = {}
local lastPlayerCacheUpdate = 0

function isAnyRoleESPActive()
    local roles = {"InnocentESP", "MurderESP", "HeroSheriffESP", "CoinESP", "GunESP"}
    for _, role in ipairs(roles) do
        local states = featureStates[role]
        if states and (states.names or states.boxes or states.tracers or states.distance) then
            return true
        end
    end
    return false
end

local function checkAnyHighlights()
    return featureStates.InnocentHighlights or featureStates.MurderHighlights or featureStates.SheriffHeroHighlights or featureStates.CoinHighlights or featureStates.GunHighlights
end

function isAnyRoleNeeded()
    return isAnyRoleESPActive() or checkAnyHighlights()
end

function startRoleUpdating()
    if roleUpdating then return end
    roleUpdating = true
    updateRoles()
    roleUpdateConnection = RunService.Heartbeat:Connect(function()
        updateRoles()
    end)
end

function stopRoleUpdating()
    if roleUpdateConnection then
        roleUpdateConnection:Disconnect()
        roleUpdateConnection = nil
    end
    roleUpdating = false
    roleData = {}
end

function manageRoleUpdating()
    if isAnyRoleNeeded() then
        startRoleUpdating()
    else
        stopRoleUpdating()
    end
end

function updateRoles()
    if not getPlayerDataRemote then return end
    if tick() - lastRoleUpdate < 2 then return end
    lastRoleUpdate = tick()
    local success, roles = pcall(function()
        return getPlayerDataRemote:InvokeServer()
    end)
    if success and roles then
        roleData = {}
        for key, v in pairs(roles) do
            if v then
                roleData[key] = v
            end
        end
        refreshHighlights()
    end
end

function managePlayerESPConnection()
    local active = isAnyRoleESPActive()
    if active then
        if not playerEspConnection then
            playerEspConnection = RunService.RenderStepped:Connect(updateRoleESP)
        end
    else
        if playerEspConnection then
            playerEspConnection:Disconnect()
            playerEspConnection = nil
        end
    end
    manageRoleUpdating()
end

function manageHighlightsConnection()
    if checkAnyHighlights() then
        startHighlights()
    else
        stopHighlights()
    end
end

function manageCoinESPConnection()
    local coinActive = featureStates.CoinESP.names or featureStates.CoinESP.boxes or featureStates.CoinESP.tracers or featureStates.CoinESP.distance
    if coinActive then
        if not coinEspConnection then
            coinEspConnection = RunService.RenderStepped:Connect(updateCoinESP)
        end
    else
        if coinEspConnection then
            coinEspConnection:Disconnect()
            coinEspConnection = nil
            cleanupCoinElements()
        end
    end
end

function manageGunESPConnection()
    local gunActive = featureStates.GunESP.names or featureStates.GunESP.boxes or featureStates.GunESP.tracers or featureStates.GunESP.distance
    if gunActive then
        if not gunEspConnection then
            gunEspConnection = RunService.RenderStepped:Connect(updateGunESP)
        end
    else
        if gunEspConnection then
            gunEspConnection:Disconnect()
            gunEspConnection = nil
            cleanupGunElements()
        end
    end
end

function cleanupAllRoleElements()
    local elementTables = {innocentEspElements, murderEspElements, sheriffEspElements, coinEspElements, gunEspElements}
    for _, elemTable in ipairs(elementTables) do
        for target, esp in pairs(elemTable) do
            cleanupDrawingTable(esp)
            elemTable[target] = nil
        end
    end
end

function cleanupCoinElements()
    for target, esp in pairs(coinEspElements) do
        cleanupDrawingTable(esp)
        coinEspElements[target] = nil
    end
end

function cleanupGunElements()
    for target, esp in pairs(gunEspElements) do
        cleanupDrawingTable(esp)
        gunEspElements[target] = nil
    end
end

function getDistanceFromPlayer(targetPosition)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return 0 end
    return (targetPosition - player.Character.HumanoidRootPart.Position).Magnitude
end

function cleanupDrawingTable(drawingTable)
    for _, drawing in pairs(drawingTable) do
        if type(drawing) == "table" then
            for _, line in ipairs(drawing) do
                pcall(line.Remove, line)
            end
        else
            pcall(drawing.Remove, drawing)
        end
    end
end

function createESPObject()
    return {
        box = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        boxLines = {}
    }
end

function setupESPObject(esp)
    esp.box.Thickness = 2
    esp.box.Filled = false
    esp.tracer.Thickness = 1
    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true
    esp.distance.Size = 14
    esp.distance.Center = true
    esp.distance.Outline = true
end

function draw3DBox(esp, cf, pos, camera, boxColor, boxSize)
    if not cf or not camera then return end
    
    boxSize = boxSize or Vector3.new(4, 5, 3)
    local size = boxSize
    local offsets = {
        Vector3.new( size.X/2,  size.Y/2,  size.Z/2), Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
        Vector3.new( size.X/2, -size.Y/2,  size.Z/2), Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
        Vector3.new(-size.X/2,  size.Y/2,  size.Z/2), Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
        Vector3.new(-size.X/2, -size.Y/2,  size.Z/2), Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
    }
    
    local screenPoints = {}
    local anyPointOnScreen = false

    for i, offset in ipairs(offsets) do
        local success, vec, onScreen = pcall(function()
            local worldPos = cf * CFrame.Angles(0, math.rad(90), 0) * offset
            return camera:WorldToViewportPoint(worldPos)
        end)
        if success then
            screenPoints[i] = {pos = Vector2.new(vec.X, vec.Y), depth = vec.Z, onScreen = onScreen}
            if onScreen and vec.Z > 0 then anyPointOnScreen = true end
        end
    end

    if not esp.boxLines or #esp.boxLines == 0 then
        esp.boxLines = {}
        for i = 1, 12 do
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.ZIndex = 2
            table.insert(esp.boxLines, line)
        end
    end

    local edges = {
        {1, 2}, {1, 3}, {1, 5}, {2, 4}, {2, 6},
        {3, 4}, {3, 7}, {5, 6}, {5, 7}, {4, 8}, {6, 8}, {7, 8}
    }

    local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
        (player.Character.HumanoidRootPart.Position - pos).Magnitude) or 10
    local thickness = math.clamp(3 / (distance / 50), 1, 3)

    for i, edge in ipairs(edges) do
        local line = esp.boxLines[i]
        if line then
            local p1, p2 = screenPoints[edge[1]], screenPoints[edge[2]]
            line.Color = boxColor or Color3.fromRGB(255, 255, 255)
            line.Thickness = thickness
            line.Transparency = 1
            if anyPointOnScreen and p1 and p2 and p1.depth > 0 and p2.depth > 0 then
                line.From = p1.pos
                line.To = p2.pos
                line.Visible = true
            else
                line.Visible = false
            end
        end
    end
end

function getPlayerRole(plr)
    local playerKey = plr.Name
    return roleData[playerKey] and roleData[playerKey].Role
end

function findCoinServerParts()
    if tick() - lastCoinSearch < 3 then
        return coinCache
    end
    
    lastCoinSearch = tick()
    coinCache = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "Coin_Server" then
            table.insert(coinCache, obj)
        end
    end
    
    return coinCache
end

function findDropGunParts()
    if tick() - lastGunSearch < 3 then
        return gunCache
    end
    
    lastGunSearch = tick()
    gunCache = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name == "DropGun" then
            table.insert(gunCache, obj)
        end
    end
    
    return gunCache
end

function getCachedPlayers()
    if tick() - lastPlayerCacheUpdate < 1 then
        return cachedPlayers
    end
    
    lastPlayerCacheUpdate = tick()
    cachedPlayers = Players:GetPlayers()
    return cachedPlayers
end

function updateCoinESP()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    local currentCoinTargets = {}
    
    local coins = findCoinServerParts()
    
    for _, coinPart in ipairs(coins) do
        if coinPart and coinPart.Parent then
            currentCoinTargets[coinPart] = true
            
            if not coinEspElements[coinPart] then
                coinEspElements[coinPart] = createESPObject()
                setupESPObject(coinEspElements[coinPart])
            end
            
            local esp = coinEspElements[coinPart]
            local vector, onScreen = camera:WorldToViewportPoint(coinPart.Position)
            
            if onScreen then
                local coinColor = Color3.fromRGB(255, 215, 0)
                local states = featureStates.CoinESP
                
                local topY = camera:WorldToViewportPoint(coinPart.Position + Vector3.new(0, 2, 0)).Y
                local bottomY = camera:WorldToViewportPoint(coinPart.Position - Vector3.new(0, 2, 0)).Y
                local size = math.max(10, (bottomY - topY) / 2)
                
                if states.boxes then
                    if states.boxType == "2D" then
                        esp.box.Visible = true
                        esp.box.Size = Vector2.new(size * 2, size * 2)
                        esp.box.Position = Vector2.new(vector.X - size, vector.Y - size)
                        esp.box.Color = coinColor
                        for _, line in ipairs(esp.boxLines) do line.Visible = false end
                    else
                        esp.box.Visible = false
                        pcall(draw3DBox, esp, coinPart.CFrame, coinPart.Position, camera, coinColor, Vector3.new(3, 3, 3))
                    end
                else
                    esp.box.Visible = false
                    for _, line in ipairs(esp.boxLines) do line.Visible = false end
                end
                
                esp.tracer.Visible = states.tracers
                if states.tracers then
                    esp.tracer.From = screenBottomCenter
                    esp.tracer.To = Vector2.new(vector.X, vector.Y)
                    esp.tracer.Color = coinColor
                end
                
                esp.name.Visible = states.names
                if states.names then
                    esp.name.Text = "Coin"
                    esp.name.Position = Vector2.new(vector.X, vector.Y - size - 15)
                    esp.name.Color = coinColor
                end
                
                esp.distance.Visible = states.distance
                if states.distance then
                    local distance = getDistanceFromPlayer(coinPart.Position)
                    esp.distance.Text = string.format("%.1f", distance)
                    esp.distance.Position = Vector2.new(vector.X, vector.Y + size + 5)
                    esp.distance.Color = coinColor
                end
            else
                esp.box.Visible = false
                esp.tracer.Visible = false
                esp.name.Visible = false
                esp.distance.Visible = false
                for _, line in ipairs(esp.boxLines) do line.Visible = false end
            end
        end
    end
    
    for target, esp in pairs(coinEspElements) do
        if not currentCoinTargets[target] then
            cleanupDrawingTable(esp)
            coinEspElements[target] = nil
        end
    end
end

function updateGunESP()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    local currentGunTargets = {}
    
    local guns = findDropGunParts()
    
    for _, gunPart in ipairs(guns) do
        if gunPart and gunPart.Parent then
            currentGunTargets[gunPart] = true
            
            if not gunEspElements[gunPart] then
                gunEspElements[gunPart] = createESPObject()
                setupESPObject(gunEspElements[gunPart])
            end
            
            local esp = gunEspElements[gunPart]
            local vector, onScreen = camera:WorldToViewportPoint(gunPart.Position)
            
            if onScreen then
                local gunColor = Color3.fromRGB(255, 0, 255)
                local states = featureStates.GunESP
                
                local topY = camera:WorldToViewportPoint(gunPart.Position + Vector3.new(0, 2, 0)).Y
                local bottomY = camera:WorldToViewportPoint(gunPart.Position - Vector3.new(0, 2, 0)).Y
                local size = math.max(10, (bottomY - topY) / 2)
                
                if states.boxes then
                    if states.boxType == "2D" then
                        esp.box.Visible = true
                        esp.box.Size = Vector2.new(size * 2, size * 2)
                        esp.box.Position = Vector2.new(vector.X - size, vector.Y - size)
                        esp.box.Color = gunColor
                        for _, line in ipairs(esp.boxLines) do line.Visible = false end
                    else
                        esp.box.Visible = false
                        pcall(draw3DBox, esp, gunPart.CFrame, gunPart.Position, camera, gunColor, Vector3.new(3, 3, 3))
                    end
                else
                    esp.box.Visible = false
                    for _, line in ipairs(esp.boxLines) do line.Visible = false end
                end
                
                esp.tracer.Visible = states.tracers
                if states.tracers then
                    esp.tracer.From = screenBottomCenter
                    esp.tracer.To = Vector2.new(vector.X, vector.Y)
                    esp.tracer.Color = gunColor
                end
                
                esp.name.Visible = states.names
                if states.names then
                    esp.name.Text = "Gun"
                    esp.name.Position = Vector2.new(vector.X, vector.Y - size - 15)
                    esp.name.Color = gunColor
                end
                
                esp.distance.Visible = states.distance
                if states.distance then
                    local distance = getDistanceFromPlayer(gunPart.Position)
                    esp.distance.Text = string.format("%.1f", distance)
                    esp.distance.Position = Vector2.new(vector.X, vector.Y + size + 5)
                    esp.distance.Color = gunColor
                end
            else
                esp.box.Visible = false
                esp.tracer.Visible = false
                esp.name.Visible = false
                esp.distance.Visible = false
                for _, line in ipairs(esp.boxLines) do line.Visible = false end
            end
        end
    end
    
    for target, esp in pairs(gunEspElements) do
        if not currentGunTargets[target] then
            cleanupDrawingTable(esp)
            gunEspElements[target] = nil
        end
    end
end

function updateRoleESP()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
    local currentInnocentTargets = {}
    local currentMurderTargets = {}
    local currentSheriffTargets = {}

    local players = getCachedPlayers()

    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= player then
            local model = otherPlayer.Character
            if model then
                local hrp = model:FindFirstChild("HumanoidRootPart")
                local humanoid = model:FindFirstChild("Humanoid")
                if hrp and humanoid then
                    local playerRole = getPlayerRole(otherPlayer)
                    local isDead = humanoid.Health <= 0
                    local espColor, states, elements, currentTargets
                    if isDead then
                        espColor = Color3.fromRGB(255, 255, 255)
                        states = featureStates.InnocentESP
                        elements = innocentEspElements
                        currentTargets = currentInnocentTargets
                    elseif playerRole == "Murderer" then
                        espColor = Color3.fromRGB(255, 0, 0)
                        states = featureStates.MurderESP
                        elements = murderEspElements
                        currentTargets = currentMurderTargets
                    elseif playerRole == "Sheriff" then
                        espColor = Color3.fromRGB(0, 0, 255)
                        states = featureStates.HeroSheriffESP
                        elements = sheriffEspElements
                        currentTargets = currentSheriffTargets
                    elseif playerRole == "Hero" then
                        espColor = Color3.fromRGB(255, 255, 0)
                        states = featureStates.HeroSheriffESP
                        elements = sheriffEspElements
                        currentTargets = currentSheriffTargets
                    else
                        if playerRole == "Innocent" then
                            espColor = Color3.fromRGB(0, 255, 0)
                        else
                            espColor = Color3.fromRGB(255, 255, 255)
                        end
                        states = featureStates.InnocentESP
                        elements = innocentEspElements
                        currentTargets = currentInnocentTargets
                    end
                    local anyActive = states.names or states.boxes or states.tracers or states.distance
                    if anyActive then
                        currentTargets[model] = true
                        if not elements[model] then
                            elements[model] = createESPObject()
                            setupESPObject(elements[model])
                        end
                        local esp = elements[model]
                        local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local topY = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y
                            local bottomY = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y
                            local size = (bottomY - topY) / 2
                            local boxSize = humanoid and Vector3.new(2, humanoid.HipHeight + 5, 2) or Vector3.new(4, 5, 3)
                            if states.boxes then
                                if states.boxType == "2D" then
                                    esp.box.Visible = true
                                    esp.box.Size = Vector2.new(size * 2, size * 3)
                                    esp.box.Position = Vector2.new(vector.X - size, vector.Y - size * 1.5)
                                    esp.box.Color = espColor
                                    for _, line in ipairs(esp.boxLines) do line.Visible = false end
                                else
                                    esp.box.Visible = false
                                    pcall(draw3DBox, esp, hrp.CFrame, hrp.Position, camera, espColor, boxSize)
                                end
                            else
                                esp.box.Visible = false
                                for _, line in ipairs(esp.boxLines) do line.Visible = false end
                            end
                            esp.tracer.Visible = states.tracers
                            if states.tracers then
                                esp.tracer.From = screenBottomCenter
                                esp.tracer.To = Vector2.new(vector.X, vector.Y)
                                esp.tracer.Color = espColor
                            end
                            esp.name.Visible = states.names
                            if states.names then
                                esp.name.Text = otherPlayer.Name
                                esp.name.Position = Vector2.new(vector.X, vector.Y - size * 1.5 - 20)
                                esp.name.Color = espColor
                            end
                            esp.distance.Visible = states.distance
                            if states.distance then
                                local distance = getDistanceFromPlayer(hrp.Position)
                                esp.distance.Text = string.format("%.1f", distance)
                                esp.distance.Position = Vector2.new(vector.X, vector.Y + size * 1.5 + 5)
                                esp.distance.Color = espColor
                            end
                        else
                            esp.box.Visible = false
                            esp.tracer.Visible = false
                            esp.name.Visible = false
                            esp.distance.Visible = false
                            for _, line in ipairs(esp.boxLines) do line.Visible = false end
                        end
                    end
                end
            end
        end
    end

    for target, esp in pairs(innocentEspElements) do
        if not currentInnocentTargets[target] then
            cleanupDrawingTable(esp)
            innocentEspElements[target] = nil
        end
    end
    for target, esp in pairs(murderEspElements) do
        if not currentMurderTargets[target] then
            cleanupDrawingTable(esp)
            murderEspElements[target] = nil
        end
    end
    for target, esp in pairs(sheriffEspElements) do
        if not currentSheriffTargets[target] then
            cleanupDrawingTable(esp)
            sheriffEspElements[target] = nil
        end
    end
end

function startHighlights()
    if not HighlightsConnection then
        HighlightsConnection = RunService.Heartbeat:Connect(updateRoleHighlights)
    end
end

function stopHighlights()
    if HighlightsConnection then
        HighlightsConnection:Disconnect()
        HighlightsConnection = nil
        clearAllHighlights()
    end
end

function clearAllHighlights()
    for _, plr in pairs(getCachedPlayers()) do
        if plr.Character then
            local highlight = plr.Character:FindFirstChild("PlayerHighlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
    
    if featureStates.CoinHighlights or featureStates.GunHighlights then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and (obj.Name == "Coin_Server" or obj.Name == "DropGun") then
                local highlight = obj:FindFirstChild("ItemHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

function refreshHighlights()
    if not HighlightsConnection then return end
    clearAllHighlights()
end

function updateRoleHighlights()
    if not roleData then return end

    local sheriffName = nil
    for name, data in pairs(roleData) do
        if data.Role == "Sheriff" then
            sheriffName = name
            break
        end
    end
    local sheriffPlayer = sheriffName and Players:FindFirstChild(sheriffName)
    local isSheriffAlive = sheriffPlayer and IsAlive(sheriffPlayer, roleData)

    local players = getCachedPlayers()

    for _, plr in ipairs(players) do
        if plr ~= player and plr.Character then
            local model = plr.Character
            local highlight = model:FindFirstChild("PlayerHighlight")
            local data = roleData[plr.Name]
            local role = data and data.Role
            local isAlivePlayer = data and IsAlive(plr, roleData)
            local highlightEnabled = false
            if not role then
                highlightEnabled = featureStates.InnocentHighlights
            elseif role == "Murderer" then
                highlightEnabled = featureStates.MurderHighlights
            elseif role == "Sheriff" or role == "Hero" then
                highlightEnabled = featureStates.SheriffHeroHighlights
            else
                highlightEnabled = featureStates.InnocentHighlights
            end
            if highlightEnabled then
                local color
                if not data or not isAlivePlayer then
                    color = Color3.new(1,1,1)
                else
                    if role == "Murderer" then
                        color = Color3.fromRGB(225, 0, 0)
                    elseif role == "Sheriff" then
                        color = Color3.fromRGB(0, 0, 225)
                    elseif role == "Hero" and not isSheriffAlive then
                        color = Color3.fromRGB(255, 250, 0)
                    else
                        color = Color3.fromRGB(0, 225, 0)
                    end
                end
                local outlineColor = getOutlineColor(color)
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerHighlight"
                    highlight.Adornee = model
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = model
                end
                highlight.FillColor = color
                highlight.OutlineColor = outlineColor
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end

    if featureStates.CoinHighlights then
        local coins = findCoinServerParts()
        for _, coinPart in ipairs(coins) do
            if coinPart and coinPart.Parent then
                local highlight = coinPart:FindFirstChild("ItemHighlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ItemHighlight"
                    highlight.Adornee = coinPart
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = coinPart
                end
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = getOutlineColor(Color3.fromRGB(255, 215, 0))
            end
        end
    end

    if featureStates.GunHighlights then
        local guns = findDropGunParts()
        for _, gunPart in ipairs(guns) do
            if gunPart and gunPart.Parent then
                local highlight = gunPart:FindFirstChild("ItemHighlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ItemHighlight"
                    highlight.Adornee = gunPart
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = gunPart
                end
                highlight.FillColor = Color3.fromRGB(255, 0, 255)
                highlight.OutlineColor = getOutlineColor(Color3.fromRGB(255, 0, 255))
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then
        local highlight = plr.Character:FindFirstChild("PlayerHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end)

coinEspConnection = RunService.RenderStepped:Connect(updateCoinESP)
gunEspConnection = RunService.RenderStepped:Connect(updateGunESP)
local xRay = false
Tabs.Visuals:Toggle({
    Title = "X-ray Vision",
    Compact = true,
    Callback = function(state)
        xRay = state
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                part.LocalTransparencyModifier = state and 0.7 or 0
            end
        end
    end
})
Tabs.Visuals:Button({
    Title = "Shit Render", 
    Callback = function()
        Lighting = game:GetService("Lighting")
        Terrain = workspace:FindFirstChildOfClass("Terrain")
        Players = game:GetService("Players")
        LocalPlayer = Players.LocalPlayer

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1

        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("Accessory") or part:IsA("Clothing") then
                        part:Destroy()
                    end
                end
            end
        end
    end
})
local function spawnWeapon(name)
    local DataBase, PlayerData = require(game:GetService("ReplicatedStorage").Database.Sync.Item),
                                  require(game:GetService("ReplicatedStorage").Modules.ProfileData)
    local newOwned = {}
    newOwned[name] = 1
    local PlayerWeapons = PlayerData.Weapons
    game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
        PlayerWeapons.Owned = newOwned
    end)
    game.Players.LocalPlayer.Character:BreakJoints()
end
Tabs.Visuals:Paragraph({
    Title = "VISUAL WARNING",
    Desc = "ALL items are in fact visual and not real you do not get to keep any of the items after rejoining the game they are only for show and do not actually exist ",
    Image = "eye"
})


local WeaponOwnedRange = { min = 1, max = 100000 }


Tabs.Visuals:Section({ Title = "Weapon Visuals", Desc = "" })



Tabs.Visuals:Slider({
    Title = "Min",
    Value = {Min = 1, Max = 100000, Default = 1},
    Compact = true,
    Callback = function(value) WeaponOwnedRange.min = value end
})


Tabs.Visuals:Slider({
    Title = "Max",
    Value = {Min = 1, Max = 100000, Default = 150},
    Compact = true,
    Callback = function(value) WeaponOwnedRange.max = value end
})


Tabs.Visuals:Button({
    Title = "spawn random Godlys (if they don’t spawn reset ",
    Compact = true,
    Callback = function()
        local DataBase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
        local PlayerData = require(game:GetService("ReplicatedStorage").Modules.ProfileData)
        local newOwned = {}
        for i, v in pairs(DataBase) do
            newOwned[i] = math.random(WeaponOwnedRange.min, WeaponOwnedRange.max)
        end
        game:GetService("RunService"):BindToRenderStep("InventoryUpdate", 0, function()
            PlayerData.Weapons.Owned = newOwned
        end)
        WindUI:Notify({ Title = "Visuals Enabled", Content = "Fake counts activated!", Duration = 2 })
    end
})


Tabs.Visuals:Section({ Title = "Item Spawner", Desc = "" })


Tabs.Visuals:Input({
    Title = "Weapon Name",
    Placeholder = "Enter weapon name..",
    Compact = true,
    Callback = function(inputText)
        if inputText and inputText ~= "" then
            spawnWeapon(inputText)
            WindUI:Notify({ Title = "Weapon Spawned", Content = inputText.." added!", Duration = 2 })
        end
    end
})
Tabs.Visuals:Section({ Title = "weapon dupe ", Desc = "" })



Tabs.Visuals:Section({ Title = "Duplication Options", Desc = "Select amount to duplicate by and choose a specific item to duplicate." })

Tabs.Visuals:Input({
    Title = "Duplication Multiplier",
    Placeholder = "Enter multiplier (e.g., 2, 3)",
    Compact = true,
    Callback = function(inputText)
        local multiplier = tonumber(inputText)
        if multiplier and multiplier > 0 then
            _G.DupeMultiplier = multiplier
            WindUI:Notify({ Title = "Multiplier Set", Content = "Duplication multiplier set to x" .. multiplier, Duration = 2 })
        else
            WindUI:Notify({ Title = "Invalid Multiplier", Content = "Please enter a valid multiplier (greater than 0).", Duration = 2 })
        end
    end
})

Tabs.Visuals:Input({
    Title = "Specific Item to Duplicate",
    Placeholder = "Enter item name to dupe (e.g., Christmas Knife)",
    Compact = true,
    Callback = function(inputText)
        _G.DupeSpecificItem = inputText
        WindUI:Notify({ Title = "Item Set", Content = "Specific item set to duplicate: " .. inputText, Duration = 2 })
    end
})

Tabs.Visuals:Button({
    Title = "Duplicate Inventory",
    Compact = true,
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local UIPath

        if LocalPlayer.PlayerGui.MainGUI.Game:FindFirstChild("Inventory") ~= nil then
            UIPath = LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main
        else
            UIPath = LocalPlayer.PlayerGui.MainGUI.Lobby.Screens.Inventory.Main
        end

        local function VisualDupe()
            local multiplier = _G.DupeMultiplier or 2
            local specificItem = _G.DupeSpecificItem

            for _, item in pairs(UIPath.Weapons.Items.Container:GetChildren()) do
                for _, weapon in pairs(item.Container:GetChildren()) do
                    if weapon:IsA("Frame") then
                        local itemName = weapon.ItemName.Label.Text
                        if (not specificItem or itemName == specificItem) and itemName ~= "Default Knife" and itemName ~= "Default Gun" then
                            local amount = weapon.Container.Amount.Text
                            if amount == "" or amount == "None" then
                                weapon.Container.Amount.Text = "x" .. tostring(multiplier)
                            else
                                local num = tonumber(amount:match("x(%d+)"))
                                if num then
                                    weapon.Container.Amount.Text = "x" .. tostring(num * multiplier)
                                end
                            end
                        end
                    end
                end
            end

            for _, pet in pairs(UIPath.Pets.Items.Container.Current.Container:GetChildren()) do
                if pet:IsA("Frame") then
                    local amount = pet.Container.Amount.Text
                    if amount == "" or amount == "None" then
                        pet.Container.Amount.Text = "x" .. tostring(multiplier)
                    else
                        local num = tonumber(amount:match("x(%d+)"))
                        if num then
                            pet.Container.Amount.Text = "x" .. tostring(num * multiplier)
                        end
                    end
                end
            end
        end

        VisualDupe()

        WindUI:Notify({ Title = "Inventory Visual Duplication", Content = "Your inventory has been visually duplicated!", Duration = 2 })
    end
})
Tabs.Esp:Section({ Title = "Innocent ESP" })

InnocentNameESPToggle = Tabs.Esp:Toggle({
    Title = "Innocent Name ESP",
    Value = false,
    Callback = function(state)
        featureStates.InnocentESP.names = state
        managePlayerESPConnection()
    end
})

InnocentBoxESPToggle = Tabs.Esp:Toggle({
    Title = "Innocent Box ESP",
    Value = false,
    Callback = function(state)
        featureStates.InnocentESP.boxes = state
        managePlayerESPConnection()
    end
})

InnocentBoxTypeDropdown = Tabs.Esp:Dropdown({
    Title = "Innocent Box Type",
    Values = {"2D", "3D"},
    Value = "2D",
    Callback = function(value)
        featureStates.InnocentESP.boxType = value
    end
})

InnocentTracerToggle = Tabs.Esp:Toggle({
    Title = "Innocent Tracer",
    Value = false,
    Callback = function(state)
        featureStates.InnocentESP.tracers = state
        managePlayerESPConnection()
    end
})

InnocentDistanceESPToggle = Tabs.Esp:Toggle({
    Title = "Innocent Distance ESP",
    Value = false,
    Callback = function(state)
        featureStates.InnocentESP.distance = state
        managePlayerESPConnection()
    end
})

InnocentHighlightsToggle = Tabs.Esp:Toggle({
    Title = "Innocent Highlights",
    Value = false,
    Callback = function(state)
        featureStates.InnocentHighlights = state
        manageHighlightsConnection()
        refreshHighlights()
    end
})

Tabs.Esp:Section({ Title = "Murder ESP" })

MurderNameESPToggle = Tabs.Esp:Toggle({
    Title = "Murder Name ESP",
    Value = false,
    Callback = function(state)
        featureStates.MurderESP.names = state
        managePlayerESPConnection()
    end
})

MurderBoxESPToggle = Tabs.Esp:Toggle({
    Title = "Murder Box ESP",
    Value = false,
    Callback = function(state)
        featureStates.MurderESP.boxes = state
        managePlayerESPConnection()
    end
})

MurderBoxTypeDropdown = Tabs.Esp:Dropdown({
    Title = "Murder Box Type",
    Values = {"2D", "3D"},
    Value = "2D",
    Callback = function(value)
        featureStates.MurderESP.boxType = value
    end
})

MurderTracerToggle = Tabs.Esp:Toggle({
    Title = "Murder Tracer",
    Value = false,
    Callback = function(state)
        featureStates.MurderESP.tracers = state
        managePlayerESPConnection()
    end
})

MurderDistanceESPToggle = Tabs.Esp:Toggle({
    Title = "Murder Distance ESP",
    Value = false,
    Callback = function(state)
        featureStates.MurderESP.distance = state
        managePlayerESPConnection()
    end
})

MurderHighlightsToggle = Tabs.Esp:Toggle({
    Title = "Murder Highlights",
    Value = false,
    Callback = function(state)
        featureStates.MurderHighlights = state
        manageHighlightsConnection()
        refreshHighlights()
    end
})

Tabs.Esp:Section({ Title = "Hero/Sheriff ESP" })

HeroSheriffNameESPToggle = Tabs.Esp:Toggle({
    Title = "Hero/Sheriff Name ESP",
    Value = false,
    Callback = function(state)
        featureStates.HeroSheriffESP.names = state
        managePlayerESPConnection()
    end
})

HeroSheriffBoxESPToggle = Tabs.Esp:Toggle({
    Title = "Hero/Sheriff Box ESP",
    Value = false,
    Callback = function(state)
        featureStates.HeroSheriffESP.boxes = state
        managePlayerESPConnection()
    end
})

HeroSheriffBoxTypeDropdown = Tabs.Esp:Dropdown({
    Title = "Hero/Sheriff Box Type",
    Values = {"2D", "3D"},
    Value = "2D",
    Callback = function(value)
        featureStates.HeroSheriffESP.boxType = value
    end
})

HeroSheriffTracerToggle = Tabs.Esp:Toggle({
    Title = "Hero/Sheriff Tracer",
    Value = false,
    Callback = function(state)
        featureStates.HeroSheriffESP.tracers = state
        managePlayerESPConnection()
    end
})

HeroSheriffDistanceESPToggle = Tabs.Esp:Toggle({
    Title = "Hero/Sheriff Distance ESP",
    Value = false,
    Callback = function(state)
        featureStates.HeroSheriffESP.distance = state
        managePlayerESPConnection()
    end
})

SheriffHeroHighlightsToggle = Tabs.Esp:Toggle({
    Title = "Sheriff/Hero Highlights",
    Value = false,
    Callback = function(state)
        featureStates.SheriffHeroHighlights = state
        manageHighlightsConnection()
        refreshHighlights()
    end
})
Tabs.Esp:Section({ Title = "Gun ESP" })

GunNameESPToggle = Tabs.Esp:Toggle({
    Title = "Gun ESP",
    Value = false,
    Callback = function(state)
        featureStates.GunESP.names = state
        manageGunESPConnection()
    end
})

GunBoxESPToggle = Tabs.Esp:Toggle({
    Title = "Gun Box ESP",
    Value = false,
    Callback = function(state)
        featureStates.GunESP.boxes = state
        manageGunESPConnection()
    end
})

GunBoxTypeDropdown = Tabs.Esp:Dropdown({
    Title = "Gun Box Type",
    Values = {"2D", "3D"},
    Value = "3D",
    Callback = function(value)
        featureStates.GunESP.boxType = value
    end
})

GunTracerToggle = Tabs.Esp:Toggle({
    Title = "Gun Tracer",
    Value = false,
    Callback = function(state)
        featureStates.GunESP.tracers = state
        manageGunESPConnection()
    end
})

GunDistanceESPToggle = Tabs.Esp:Toggle({
    Title = "Gun Distance ESP",
    Value = false,
    Callback = function(state)
        featureStates.GunESP.distance = state
        manageGunESPConnection()
    end
})

GunHighlightsToggle = Tabs.Esp:Toggle({
    Title = "Gun Highlights",
    Value = false,
    Callback = function(state)
        featureStates.GunHighlights = state
        manageHighlightsConnection()
        refreshHighlights()
    end
})
Tabs.Esp:Section({ Title = "Coin ESP" })

CoinNameESPToggle = Tabs.Esp:Toggle({
    Title = "Coin ESP",
    Value = false,
    Callback = function(state)
        featureStates.CoinESP.names = state
        manageCoinESPConnection()
    end
})

CoinBoxESPToggle = Tabs.Esp:Toggle({
    Title = "Coin Box ESP",
    Value = false,
    Callback = function(state)
        featureStates.CoinESP.boxes = state
        manageCoinESPConnection()
    end
})

CoinBoxTypeDropdown = Tabs.Esp:Dropdown({
    Title = "Coin Box Type",
    Values = {"2D", "3D"},
    Value = "3D",
    Callback = function(value)
        featureStates.CoinESP.boxType = value
    end
})

CoinTracerToggle = Tabs.Esp:Toggle({
    Title = "Coin Tracer",
    Value = false,
    Callback = function(state)
        featureStates.CoinESP.tracers = state
        manageCoinESPConnection()
    end
})

CoinDistanceESPToggle = Tabs.Esp:Toggle({
    Title = "Coin Distance ESP",
    Value = false,
    Callback = function(state)
        featureStates.CoinESP.distance = state
        manageCoinESPConnection()
    end
})

CoinHighlightsToggle = Tabs.Esp:Toggle({
    Title = "Coin Highlights",
    Value = false,
    Callback = function(state)
        featureStates.CoinHighlights = state
        manageHighlightsConnection()
        refreshHighlights()
    end
})



Tabs.Teleport:Section({ Title = "Teleport", TextSize = 20 })
Tabs.Teleport:Divider()

function GetPlayerList()
    local playerList = {"Select a player"}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(playerList, plr.Name)
        end
    end
    return playerList
end

TeleportPlayerDropdown = Tabs.Teleport:Dropdown({
    Title = "Select Player",
    Values = GetPlayerList(),
    Value = "Select a player",
    Callback = function(value)
        selectedPlayerName = value
    end
})

function UpdatePlayerList()
    TeleportPlayerDropdown:Refresh(GetPlayerList(), "Select a player")
end

Tabs.Teleport:Button({
    Title = "Teleport to Player",
    Desc = "Teleport to the selected player",
    Icon = "user",
    Callback = function()
        if selectedPlayerName and selectedPlayerName ~= "Select a player" then
            targetPlayer = Players:FindFirstChild(selectedPlayerName)
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Random Player",
    Desc = "Teleport to a random player in the server",
    Icon = "users",
    Callback = function()
        otherPlayers = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(otherPlayers, plr)
            end
        end
        
        if #otherPlayers > 0 then
            randomPlayer = otherPlayers[math.random(1, #otherPlayers)]
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

function FindMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
            return plr
        end
    end
    return nil
end

function FindSheriff()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun")) then
            return plr
        end
    end
    return nil
end

function FindDroppedGun()
    return workspace:FindFirstChild("DropGun")
end

function TeleportToCoin()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local coinServer = workspace:FindFirstChild("Coin_Server")
    if not coinServer then
        return
    end

    local coins = {}
    for _, coin in ipairs(coinServer:GetChildren()) do
        if coin:IsA("BasePart") then
            table.insert(coins, coin)
        end
    end

    if #coins == 0 then
        return
    end

    local targetCoin = coins[math.random(1, #coins)]
    local targetPos = targetCoin.Position + Vector3.new(0, 5, 0)

    humanoidRootPart.CFrame = CFrame.new(targetPos)
end

function TeleportToMap()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local spawnParts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Spawn" then
            local isInLobby = false
            local parent = obj.Parent
            while parent ~= nil do
                if parent.Name == "Lobby" and parent.Parent == workspace then
                    isInLobby = true
                    break
                end
                parent = parent.Parent
            end
            
            if not isInLobby then
                table.insert(spawnParts, obj)
            end
        end
    end
    
    if #spawnParts == 0 then
        return
    end
    
    local randomIndex = math.random(1, #spawnParts)
    local randomSpawn = spawnParts[randomIndex]
    
    humanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 5, 0)
end

function TeleportToLobby()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local lobby = workspace:FindFirstChild("Lobby")
    if not lobby then
        return
    end
    
    local spawns = lobby:FindFirstChild("Spawns")
    if not spawns then
        return
    end
    
    local spawnLocations = {}
    for _, obj in pairs(spawns:GetChildren()) do
        if obj:IsA("SpawnLocation") then
            table.insert(spawnLocations, obj)
        end
    end
    
    if #spawnLocations == 0 then
        return
    end
    
    local randomIndex = math.random(1, #spawnLocations)
    local randomSpawn = spawnLocations[randomIndex]
    
    humanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
end
Tabs.Teleport:Button({
    Title = "Teleport to Innocent",
    Desc = "Teleport to a random innocent player",
    Icon = "user",
    Callback = function()
        murderer = FindMurderer()
        sheriff = FindSheriff()
        
        innocents = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr ~= murderer and plr ~= sheriff and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                hasKnife = plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife"))
                hasGun = plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun"))
                if not hasKnife and not hasGun then
                    table.insert(innocents, plr)
                end
            end
        end
        
        if #innocents > 0 then
            randomInnocent = innocents[math.random(1, #innocents)]
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = randomInnocent.Character.HumanoidRootPart.CFrame
            end
        end
    end
})
Tabs.Teleport:Button({
    Title = "Teleport to Murderer",
    Icon = "user-x",
    Callback = function()
        murderer = FindMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Sheriff",
    Icon = "user-check",
    Callback = function()
        sheriff = FindSheriff()
        if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = sheriff.Character.HumanoidRootPart.CFrame
            end
        end
    end
})


Tabs.Teleport:Button({
    Title = "Teleport to Dropped Gun",
    Icon = "target",
    Callback = function()
        gun = FindDroppedGun()
        if gun then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(gun.Position)
            end
        end
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Coin",
    Icon = "dollar-sign",
    Callback = function()
        TeleportToCoin()
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Map",
    Icon = "map",
    Callback = function()
        TeleportToMap()
    end
})

Tabs.Teleport:Button({
    Title = "Teleport to Lobby",
    Icon = "home",
    Callback = function()
        TeleportToLobby()
    end
})

Players.PlayerAdded:Connect(function()
    UpdatePlayerList()
end)

Players.PlayerRemoving:Connect(function()
    UpdatePlayerList()
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid", 5)
    rootPart = character:WaitForChild("HumanoidRootPart", 5)
end)

Tabs.Misc:Section({ Title = "Misc", TextSize = 40 })
Tabs.Misc:Divider()

AntiAFKConnection = nil

startAntiAFK = function()
    AntiAFKConnection = player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

stopAntiAFK = function()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

AntiAFKToggle = Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Value = featureStates.AntiAFK,
    Callback = function(state)
        featureStates.AntiAFK = state
        if state then
            startAntiAFK()
        else
            stopAntiAFK()
        end
    end
})
Tabs.Misc:Section({ Title = "Auto Farm", TextSize = 20 })
Tabs.Misc:Divider()

local AutoFarm = {
    Enabled = false,
    Mode = "Teleport",
    TeleportDelay = 0,
    MoveSpeed = 50,
    Connection = nil,
    CoinCheckInterval = 0.5,
    CoinContainers = {
        "Factory",
        "Hospital3",
        "MilBase",
        "House2",
        "Workplace",
        "Mansion2",
        "BioLab",
        "Hotel",
        "Bank2",
        "PoliceStation",
        "ResearchFacility",
        "Lobby"
    }
}

local function findNearestCoin()
    local closestCoin = nil
    local shortestDistance = math.huge
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return nil
    end
    for _, containerName in ipairs(AutoFarm.CoinContainers) do
        local container = workspace:FindFirstChild(containerName)
        if container then
            local coinContainer =
                ((containerName == "Lobby") and container) or container:FindFirstChild("CoinContainer")
            if coinContainer then
                for _, coin in ipairs(coinContainer:GetChildren()) do
                    if coin:IsA("BasePart") then
                        local distance = (humanoidRootPart.Position - coin.Position).Magnitude
                        if (distance < shortestDistance) then
                            shortestDistance = distance
                            closestCoin = coin
                        end
                    end
                end
            end
        end
    end
    return closestCoin
end

local function teleportToCoin(coin)
    if (not coin or not player.Character) then
        return
    end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end
    humanoidRootPart.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0))
    task.wait(AutoFarm.TeleportDelay)
end

local function smoothMoveToCoin(coin)
    if (not coin or not player.Character) then
        return
    end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end
    local startTime = tick()
    local startPos = humanoidRootPart.Position
    local endPos = coin.Position + Vector3.new(0, 3, 0)
    local distance = (startPos - endPos).Magnitude
    local duration = distance / AutoFarm.MoveSpeed
    while ((tick() - startTime) < duration) and AutoFarm.Enabled do
        if (not coin or not coin.Parent) then
            break
        end
        local progress = math.min((tick() - startTime) / duration, 1)
        humanoidRootPart.CFrame = CFrame.new(startPos:Lerp(endPos, progress))
        task.wait()
    end
end

local function walkToCoin(coin)
    if (not coin or not player.Character) then
        return
    end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end
    humanoid.WalkSpeed = 16
    humanoid:MoveTo(coin.Position + Vector3.new(0, 0, 3))
    local startTime = tick()
    while AutoFarm.Enabled and (humanoid.MoveDirection.Magnitude > 0) and ((tick() - startTime) < 10) do
        task.wait(0.5)
    end
end

local function collectCoin(coin)
    if (not coin or not player.Character) then
        return
    end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end
    firetouchinterest(humanoidRootPart, coin, 0)
    firetouchinterest(humanoidRootPart, coin, 1)
end

local function farmLoop()
    while AutoFarm.Enabled do
        local coin = findNearestCoin()
        if coin then
            if (AutoFarm.Mode == "Teleport") then
                teleportToCoin(coin)
            elseif (AutoFarm.Mode == "Smooth") then
                smoothMoveToCoin(coin)
            else
                walkToCoin(coin)
            end
            collectCoin(coin)
            task.wait(2)
        end
        task.wait(AutoFarm.CoinCheckInterval)
    end
end

Tabs.Misc:Toggle({
    Title = "Enable AutoFarm",
    Value = false,
    Callback = function(state)
        AutoFarm.Enabled = state
        if state then
            AutoFarm.Connection = task.spawn(farmLoop)
        else
            if AutoFarm.Connection then
                task.cancel(AutoFarm.Connection)
            end
        end
    end
})
Tabs.Misc:Dropdown({
    Title = "Movement Mode",
    Values = {"Teleport", "Smooth", "Walk"},
    Value = "Teleport",
    Callback = function(mode)
        AutoFarm.Mode = mode
    end
})

Tabs.Misc:Slider({
    Title = "Teleport Delay (sec)",
    Value = {Min = 0, Max = 1, Default = 0, Step = 0.1},
    Callback = function(value)
        AutoFarm.TeleportDelay = value
    end
})

Tabs.Misc:Slider({
    Title = "Smooth Move Speed",
    Value = {Min = 20, Max = 200, Default = 50},
    Callback = function(value)
        AutoFarm.MoveSpeed = value
    end
})

Tabs.Misc:Slider({
    Title = "Check Interval (sec)",
    Step = 0.1,
    Value = {Min = 0.1, Max = 2, Default = 0.5},
    Callback = function(value)
        AutoFarm.CoinCheckInterval = value
    end
})
ExpFarm = false
ExpFarmConnection = nil

if not workspace:FindFirstChild("SecurityPart") then
    local SecurityPart = Instance.new("Part")
    SecurityPart.Name = "SecurityPart"
    SecurityPart.Size = Vector3.new(10, 1, 10)
    SecurityPart.Position = Vector3.new(50000, 50000, 50000)
    SecurityPart.Anchored = true
    SecurityPart.CanCollide = true
    SecurityPart.Parent = workspace
end

function startExpFarm()
    local securityPart = workspace:FindFirstChild("SecurityPart")
    if not securityPart then
        print("SecurityPart not found")
        return
    end
    
    ExpFarmConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if character and rootPart then
            rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
        end
    end)
end

function stopExpFarm()
    if ExpFarmConnection then
        ExpFarmConnection:Disconnect()
        ExpFarmConnection = nil
    end
end

ExpFarmToggle = Tabs.Misc:Toggle({
    Title = "Exp Farm",
    Value = false,
    Callback = function(state)
        ExpFarm = state
        if state then
            startExpFarm()
        else
            stopExpFarm()
        end
    end
})
local function getPlayerRole(playerName)
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if success and roles then
        local playerData = roles[playerName]
        if playerData then
            return playerData.Role
        end
    end
    return nil
end

local function findMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
            return plr
        end
    end
    return nil
end

local function findSheriffOrHero()
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if success and roles then
        for playerName, data in pairs(roles) do
            if data.Role == "Sheriff" or data.Role == "Hero" then
                return Players:FindFirstChild(playerName), data.Role
            end
        end
    end
    return nil, nil
end

Tabs.Misc:Section({ Title = "Role Revealer", TextSize = 20 })
Tabs.Misc:Divider()

local function findMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
            return plr
        end
    end
    return nil
end

local function findSheriff()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun")) then
            return plr
        end
    end
    return nil
end

local function findHero()
    local success, roles = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if success and roles then
        for playerName, data in pairs(roles) do
            if data.Role == "Hero" then
                return Players:FindFirstChild(playerName)
            end
        end
    end
    return nil
end

Tabs.Misc:Button({
    Title = "Reveal Murderer",
    Desc = "Reveal murderer in chat",
    Icon = "user-x",
    Callback = function()
        local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
        for _, textchannel in ipairs(textchannels) do
            if textchannel.Name == "RBXSystem" then continue end
            local murd = findMurderer()
            if murd then
                local message = string.format("%s Is Murderer | Script Used: Dara Hub", murd.Name)
                textchannel:SendAsync(message)
            else
                local message = "No Murderer Found | Script Used: Dara Hub"
                textchannel:SendAsync(message)
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "Reveal Sheriff/Hero",
    Desc = "Reveal sheriff or hero in chat",
    Icon = "user-check",
    Callback = function()
        local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
        for _, textchannel in ipairs(textchannels) do
            if textchannel.Name == "RBXSystem" then continue end
            local sher = findSheriff()
            local hero = findHero()
            if sher then 
                local message = string.format("%s Is Sheriff | Script Used: Dara Hub", sher.Name)
                textchannel:SendAsync(message)
            elseif hero then
                local message = string.format("%s Is Hero | Script Used: Dara Hub", hero.Name)
                textchannel:SendAsync(message)
            else
                local message = "No Sheriff/Hero Found | Script Used: Dara Hub"
                textchannel:SendAsync(message)
            end
        end
    end
})
Tabs.Misc:Button({
    Title = "Trade Helper",
    Compact = true,
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/8LDyigix"))()
        WindUI:Notify({ Title = "Trade Helper", Content = "Script loaded!", Duration = 3 })
    end
})

Tabs.Utility:Button({
    Title = "Unlock all emote and toy",
    Desc = "The toy is useless so don't mind it if it's not working",
    Callback = function()
    -- MM2 All Emotes Unlocker (2025) Script
--[[ ((Don't use this if you hate overlapping bug
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayEmote = ReplicatedStorage.Remotes.Misc.PlayEmote
local ItemService = require(ReplicatedStorage.ClientServices.ItemService)
local function getAllEmotes()
    local emotes = {}
    local success, syncModule = pcall(require, ReplicatedStorage.Database.Sync)
    if success and syncModule then
         if syncModule.Emotes then
            for emoteName, _ in pairs(syncModule.Emotes) do
                table.insert(emotes, emoteName)
            end
        end
        if syncModule.Toys then
            for toyName, _ in pairs(syncModule.Toys) do
                table.insert(emotes, toyName)
            end
        end
    end
    local defaultEmotes = {"wave", "cheer", "laugh", "dance1", "dance2", "dance3"}
    for _, emote in ipairs(defaultEmotes) do
        table.insert(emotes, emote)
    end
    return emotes
end
local AllEmotes = getAllEmotes()
local function UnlockEmotes()
    local Cross = PlayerGui:FindFirstChild("CrossPlatform")
    if not Cross then return end
    local Emotes = Cross:FindFirstChild("Emotes")
    if not Emotes then return end
    local Controller = Emotes:FindFirstChild("EmoteController")
    local Window = Emotes:FindFirstChild("EmoteWindow")
    if not Controller or not Window then return end
    local GameEmotes = Window.EmoteContainer.EmotePages["Game Emotes"]
    local FrameTemplate = Controller.EmoteFrame
    local RowTemplate = Controller.RowFrame
    for _, v in pairs(GameEmotes:GetChildren()) do
        if v.Name:match("^Row") then
            v:Destroy()
        end
    end
    local row, slot = 1, 1
    for _, emote in ipairs(AllEmotes) do
        local info = ItemService:GetItemInfo(emote, "Emotes")
        if not info then
            -- Try getting as toy if not found as emote
            info = ItemService:GetItemInfo(emote, "Toys")
        end
        if info then
            if slot == 1 then
                local newRow = RowTemplate:Clone()
                newRow.Name = "Row"..row
                newRow.Parent = GameEmotes
                newRow.LayoutOrder = row
            end
            local frame = FrameTemplate:Clone()
            frame.Name = "Emote"..slot
            frame:SetAttribute("EmoteName", emote)
            frame.EmoteName.Text = info.Name or emote
            frame.EmoteIcon.Image = ItemService:GetItemImage(info)
            frame.Hotkey.KeyLabel.Text = slot
            frame.Hotkey.Visible = UserInputService.KeyboardEnabled
            frame.Parent = GameEmotes["Row"..row]
            frame.PlayButton.Activated:Connect(function()
                PlayEmote:Fire(emote)
            end)
            slot += 1
            if slot > 8 then
                slot = 1
                row += 1
            end
        end
    end
end
local function initialize()
    PlayerGui:WaitForChild("CrossPlatform", 10)
    task.wait(1)
    UnlockEmotes()
end
if PlayerGui:FindFirstChild("CrossPlatform") then
    UnlockEmotes()
else
    initialize()
end
ReplicatedStorage.Remotes.Inventory.InventoryDataChanged.Event:Connect(function(cat)
    if cat == "Emotes" or cat == "Toys" then
        task.wait(0.3)
        UnlockEmotes()
    end
end)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    UnlockEmotes()
end)
]]
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local UserInputService = game:GetService("UserInputService")
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local PlayEmote = ReplicatedStorage.Remotes.Misc.PlayEmote
        local ItemService = require(ReplicatedStorage.ClientServices.ItemService)
        
        local function getAllEmotes()
            local emotes = {}
            local added = {}
            
            local success, syncModule = pcall(require, ReplicatedStorage.Database.Sync)
            if success and syncModule then
                if syncModule.Emotes then
                    for emoteName, _ in pairs(syncModule.Emotes) do
                        if not added[emoteName] then
                            table.insert(emotes, emoteName)
                            added[emoteName] = true
                        end
                    end
                end
                
                if syncModule.Toys then
                    for toyName, _ in pairs(syncModule.Toys) do
                        if not added[toyName] then
                            table.insert(emotes, toyName)
                            added[toyName] = true
                        end
                    end
                end
            end
            
            local defaultEmotes = {"wave", "cheer", "laugh", "dance1", "dance2", "dance3"}
            for _, emote in ipairs(defaultEmotes) do
                if not added[emote] then
                    table.insert(emotes, emote)
                    added[emote] = true
                end
            end
            
            return emotes
        end
        
        local AllEmotes = getAllEmotes()
        
        local function UnlockEmotes()
            local Cross = PlayerGui:FindFirstChild("CrossPlatform")
            if not Cross then return end
            
            local Emotes = Cross:FindFirstChild("Emotes")
            if not Emotes then return end
            
            local Controller = Emotes:FindFirstChild("EmoteController")
            local Window = Emotes:FindFirstChild("EmoteWindow")
            if not Controller or not Window then return end
            
            local GameEmotes = Window.EmoteContainer.EmotePages["Game Emotes"]
            local FrameTemplate = Controller.EmoteFrame
            local RowTemplate = Controller.RowFrame
            
            for _, v in pairs(GameEmotes:GetChildren()) do
                if v.Name:match("^Row") then
                    v:Destroy()
                end
            end
            
            GameEmotes.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#AllEmotes / 4) * 120)
            
            local row, slot = 1, 1
            local maxSlotsPerRow = 6
            
            for _, emote in ipairs(AllEmotes) do
                local info = ItemService:GetItemInfo(emote, "Emotes")
                if not info then
                    info = ItemService:GetItemInfo(emote, "Toys")
                end
                
                if info then
                    if slot == 1 then
                        local newRow = RowTemplate:Clone()
                        newRow.Name = "Row"..row
                        newRow.Parent = GameEmotes
                        newRow.LayoutOrder = row
                        newRow.Size = UDim2.new(1, 0, 0, 100)
                    end
                    
                    local frame = FrameTemplate:Clone()
                    frame.Name = "Emote"..slot
                    frame:SetAttribute("EmoteName", emote)
                    frame.EmoteName.Text = info.Name or emote
                    frame.EmoteIcon.Image = ItemService:GetItemImage(info)
                    frame.Hotkey.KeyLabel.Text = slot
                    frame.Hotkey.Visible = UserInputService.KeyboardEnabled
                    frame.Size = UDim2.new(1/maxSlotsPerRow, -5, 1, -5)
                    frame.Position = UDim2.new((slot-1)/maxSlotsPerRow, 0, 0, 0)
                    frame.Parent = GameEmotes["Row"..row]
                    frame.PlayButton.Activated:Connect(function()
                        PlayEmote:Fire(emote)
                    end)
                    
                    slot += 1
                    if slot > maxSlotsPerRow then
                        slot = 1
                        row += 1
                    end
                end
            end
            
            if slot > 1 and slot <= maxSlotsPerRow then
                local newRow = RowTemplate:Clone()
                newRow.Name = "Row"..row
                newRow.Parent = GameEmotes
                newRow.LayoutOrder = row
                newRow.Size = UDim2.new(1, 0, 0, 100)
            end
        end
        
        local function UnlockEmotesAdvanced()
            local Cross = PlayerGui:FindFirstChild("CrossPlatform")
            if not Cross then return end
            
            local Emotes = Cross:FindFirstChild("Emotes")
            if not Emotes then return end
            
            local Controller = Emotes:FindFirstChild("EmoteController")
            local Window = Emotes:FindFirstChild("EmoteWindow")
            if not Controller or not Window then return end
            
            local GameEmotes = Window.EmoteContainer.EmotePages["Game Emotes"]
            local FrameTemplate = Controller.EmoteFrame
            
            for _, v in pairs(GameEmotes:GetChildren()) do
                if v.Name:match("^Row") or v.Name:match("^Emote") then
                    v:Destroy()
                end
            end
            
            if not GameEmotes:IsA("ScrollingFrame") then
                local scrollingFrame = Instance.new("ScrollingFrame")
                scrollingFrame.Name = "EmoteScroller"
                scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
                scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
                scrollingFrame.BackgroundTransparency = 1
                scrollingFrame.BorderSizePixel = 0
                scrollingFrame.ScrollBarThickness = 8
                scrollingFrame.Parent = GameEmotes
                
                local uiGridLayout = Instance.new("UIGridLayout")
                uiGridLayout.CellSize = UDim2.new(0, 80, 0, 80)
                uiGridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
                uiGridLayout.FillDirection = Enum.FillDirection.Horizontal
                uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiGridLayout.Parent = scrollingFrame
                GameEmotes = scrollingFrame
            end
            
            for index, emote in ipairs(AllEmotes) do
                local info = ItemService:GetItemInfo(emote, "Emotes")
                if not info then
                    info = ItemService:GetItemInfo(emote, "Toys")
                end
                
                if info then
                    local frame = FrameTemplate:Clone()
                    frame.Name = "Emote"..index
                    frame:SetAttribute("EmoteName", emote)
                    frame.EmoteName.Text = info.Name or emote
                    frame.EmoteIcon.Image = ItemService:GetItemImage(info)
                    frame.Hotkey.KeyLabel.Text = index
                    frame.Hotkey.Visible = UserInputService.KeyboardEnabled
                    frame.Size = UDim2.new(0, 70, 0, 70)
                    frame.LayoutOrder = index
                    frame.Parent = GameEmotes
                    frame.PlayButton.Activated:Connect(function()
                        PlayEmote:Fire(emote)
                    end)
                end
            end
            
            local emotesCount = #AllEmotes
            local rows = math.ceil(emotesCount / 6)
            GameEmotes.CanvasSize = UDim2.new(0, 0, 0, rows * 85)
        end
        
        local function initialize()
            PlayerGui:WaitForChild("CrossPlatform", 10)
            task.wait(1)
            local success = pcall(UnlockEmotesAdvanced)
            if not success then
                UnlockEmotes()
            end
        end
        
        if PlayerGui:FindFirstChild("CrossPlatform") then
            local success = pcall(UnlockEmotesAdvanced)
            if not success then
                UnlockEmotes()
            end
        else
            initialize()
        end
        
        ReplicatedStorage.Remotes.Inventory.InventoryDataChanged.Event:Connect(function(cat)
            if cat == "Emotes" or cat == "Toys" then
                task.wait(0.3)
                local success = pcall(UnlockEmotesAdvanced)
                if not success then
                    UnlockEmotes()
                end
            end
        end)
        
        LocalPlayer.CharacterAdded:Connect(function()
            task.wait(2)
            local success = pcall(UnlockEmotesAdvanced)
            if not success then
                UnlockEmotes()
            end
        end)
    end
})
local emoteInputValue = ""

Tabs.Utility:Input({
    Title = "Emote Name",
    Placeholder = "Enter emote name",
    Callback = function(emoteName)
        emoteInputValue = emoteName
    end
})

Tabs.Utility:Button({
    Title = "Play Emote By Name",
    Callback = function()
        if emoteInputValue and emoteInputValue ~= "" then
            game:GetService("ReplicatedStorage").Remotes.Misc.PlayEmote:Fire(emoteInputValue)
        end
    end
})
local hiddenfling = false
local movel = 0.1
local flingPower = 1e35
local flingCoroutine = nil

local function fling()
    local chr = player.Character
    if not chr then return end
    local hrp = chr:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    while hiddenfling and chr and hrp and hrp.Parent do
        local vel = hrp.Velocity
        hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
        RunService.RenderStepped:Wait()
        hrp.Velocity = vel
        RunService.Stepped:Wait()
        hrp.Velocity = vel + Vector3.new(0, movel, 0)
        movel = -movel
        RunService.Heartbeat:Wait()
    end
end

local function startFling()
    if flingCoroutine then
        coroutine.close(flingCoroutine)
        flingCoroutine = nil
    end
    flingCoroutine = coroutine.create(fling)
    coroutine.resume(flingCoroutine)
end

local function stopFling()
    if flingCoroutine then
        coroutine.close(flingCoroutine)
        flingCoroutine = nil
    end
    
    local chr = player.Character
    if chr then
        local hrp = chr:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end

TouchFlingToggle = Tabs.Utility:Toggle({
    Title = "Touch Fling",
    Value = false,
    Callback = function(state)
        hiddenfling = state
        if state then
            startFling()
        else
            stopFling()
        end
    end
})

player.CharacterAdded:Connect(function(character)
    if hiddenfling then
        task.wait(1)
        startFling()
    else
        task.wait(0.5)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

Tabs.Utility:Input({
    Title = "Fling Power",
    Placeholder = "Enter fling power (default: 1e35)",
    Callback = function(value)
        if value and value ~= "" then
            flingPower = tonumber(value) or 1e35
        end
    end
})
Tabs.Utility:Button({
    Title = "Fling Tool",
    Icon = "rbxassetid://3836615692",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE/main/punch"))()
    end
})

local flingActive = false
local flingMode = 1
local currentInput = ""
local processedPlayers = {}
local localPlayer = game.Players.LocalPlayer
local roles = {}
local Murder = nil
local Sheriff = nil
local Hero = nil

local function IsAlive(Player)
    for i, v in pairs(roles) do
        if Player.Name == i then
            if not v.Killed and not v.Dead then
                return true
            else
                return false
            end
        end
    end
    return false
end

local function updateRoles()
    local success, result = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if success and result then
        roles = result
        Murder = nil
        Sheriff = nil
        Hero = nil
        
        for i, v in pairs(roles) do
            if v.Role == "Murderer" then
                Murder = i
            elseif v.Role == 'Sheriff' then
                Sheriff = i
            elseif v.Role == 'Hero' then
                Hero = i
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateRoles()
end)

local function sortPlayersAlphabetically(players)
    table.sort(players, function(a, b)
        return string.lower(a.Name) < string.lower(b.Name)
    end)
    return players
end

local function getPlayers(input)
    local players = {}
    input = string.lower(input or "")
    
    if input == "all" then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                table.insert(players, player)
            end
        end
        players = sortPlayersAlphabetically(players)
    elseif input == "nonfriends" then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                local success, isFriend = pcall(function()
                    return player:IsFriendsWith(localPlayer.UserId)
                end)
                if not (success and isFriend) then
                    table.insert(players, player)
                end
            end
        end
        players = sortPlayersAlphabetically(players)
    elseif input == "murder" then
        if Murder then
            local murdererPlayer = game.Players:FindFirstChild(Murder)
            if murdererPlayer and murdererPlayer ~= localPlayer and murdererPlayer.Character and IsAlive(murdererPlayer) then
                table.insert(players, murdererPlayer)
            end
        end
    elseif input == "sheriff" or input == "hero" then
        if Sheriff then
            local sheriffPlayer = game.Players:FindFirstChild(Sheriff)
            if sheriffPlayer and sheriffPlayer ~= localPlayer and sheriffPlayer.Character and IsAlive(sheriffPlayer) then
                table.insert(players, sheriffPlayer)
            end
        end
        if Hero then
            local heroPlayer = game.Players:FindFirstChild(Hero)
            if heroPlayer and heroPlayer ~= localPlayer and heroPlayer.Character and IsAlive(heroPlayer) then
                table.insert(players, heroPlayer)
            end
        end
    else
        local searchTerms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = string.match(term, "^%s*(.-)%s*$")
            if term ~= "" then
                table.insert(searchTerms, term)
            end
        end
        
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                local playerName = string.lower(player.Name)
                local displayName = player.DisplayName and string.lower(player.DisplayName) or ""
                
                for _, term in ipairs(searchTerms) do
                    if string.find(playerName, term) or string.find(displayName, term) then
                        table.insert(players, player)
                        break
                    end
                end
            end
        end
    end
    
    return players
end

local function SkidFling(TargetPlayer, duration)
    local startTime = tick()
    local Character = localPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = duration or 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until not flingActive or BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= game.Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or tick() > Time + TimeToWait
        end
        
        local previousDestroyHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        repeat
            if Character and Humanoid and RootPart and getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, x in pairs(Character:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            task.wait()
        until not flingActive or (RootPart and getgenv().OldPos and (RootPart.Position - getgenv().OldPos.p).Magnitude < 25)
        workspace.FallenPartsDestroyHeight = previousDestroyHeight
    end
end

local function shhhlol(TargetPlayer)
    local Character = localPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        local function mmmm(comkid, Pos, Ang)
            RootPart.CFrame = CFrame.new(comkid.Position) * Pos * Ang
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function wtf(comkid)
            local TimeToWait = 0.134
            local Time = tick()
            
            local Att1 = Instance.new("Attachment", RootPart)
            local Att2 = Instance.new("Attachment", comkid)

            repeat
                if RootPart and THumanoid then
                    if comkid.Velocity.Magnitude < 30 then
                        mmmm(
                            comkid,
                            CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 5,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        task.wait()

                        mmmm(
                            comkid,
                            CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 1.25,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        task.wait()

                        mmmm(
                            comkid,
                            CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * comkid.Velocity.Magnitude / 1.25,
                            CFrame.Angles(
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180),
                                math.random(1, 2) == 1 and math.rad(0) or math.rad(180)
                            )
                        )
                        task.wait()
                    else
                        mmmm(comkid, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(0), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until comkid.Velocity.Magnitude > 1000 or 
                  comkid.Parent ~= TargetPlayer.Character or
                  TargetPlayer.Parent ~= game.Players or
                  not TargetPlayer.Character == TCharacter or
                  Humanoid.Health <= 0 or
                  tick() > Time + TimeToWait or
                  not flingActive

            Att1:Destroy()
            Att2:Destroy()
        end

        local previousDestroyHeight = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(-9e99, 9e99, -9e99)
        BV.MaxForce = Vector3.new(-9e9, 9e9, -9e9)

        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.CFrame = CFrame.new(RootPart.Position)
        BodyGyro.D = 9e8
        BodyGyro.MaxTorque = Vector3.new(-9e9, 9e9, -9e9)
        BodyGyro.P = -9e9

        local BodyPosition = Instance.new("BodyPosition")
        BodyPosition.Position = RootPart.Position
        BodyPosition.D = 9e8
        BodyPosition.MaxForce = Vector3.new(-9e9, 9e9, -9e9)
        BodyPosition.P = -9e9

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                wtf(THead)
            else
                wtf(TRootPart)
            end
        elseif TRootPart and not THead then
            wtf(TRootPart)
        elseif not TRootPart and THead then
            wtf(THead)
        end

        BV:Destroy()
        BodyGyro:Destroy()
        BodyPosition:Destroy()
        
        repeat
            if Character and Humanoid and RootPart and getgenv().OldPos then
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                for _, x in pairs(Character:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            task.wait()
        until not flingActive or (RootPart and getgenv().OldPos and (RootPart.Position - getgenv().OldPos.p).Magnitude < 25)
        
        workspace.FallenPartsDestroyHeight = previousDestroyHeight
    end
end

local function yeet(targetPlayer)
    local character = localPlayer.Character
    local targetCharacter = targetPlayer.Character

    if not character or not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
        return false
    end

    if character.HumanoidRootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = character.HumanoidRootPart.CFrame
    end

    local existingForce = character.HumanoidRootPart:FindFirstChild("YeetForce")
    if existingForce then
        existingForce:Destroy()
    end

    local Thrust = Instance.new('BodyThrust', character.HumanoidRootPart)
    Thrust.Force = Vector3.new(9999, 9999, 9999)
    Thrust.Name = "YeetForce"

    local previousDestroyHeight = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0

    local startTime = tick()
    local duration = (currentInput == "all" or currentInput == "nonfriends") and 5 or math.huge

    local yeetConnection
    yeetConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") or not flingActive or tick() > startTime + duration then
            yeetConnection:Disconnect()
            Thrust:Destroy()
            workspace.FallenPartsDestroyHeight = previousDestroyHeight

            if character and character.HumanoidRootPart and getgenv().OldPos then
                character.HumanoidRootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                character.Humanoid:ChangeState("GettingUp")
                for _, x in pairs(character:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
            end
            return
        end

        local targetHRP = targetCharacter.HumanoidRootPart
        local targetVelocity = targetHRP.Velocity
        local speed = targetVelocity.Magnitude
        local direction = targetVelocity.Unit

        local offsetPosition
        if speed > 0.1 then
            offsetPosition = targetHRP.Position + (direction * speed)
        else
            offsetPosition = targetHRP.Position + Vector3.new(0, 0, 0)
        end

        character.HumanoidRootPart.CFrame = CFrame.new(offsetPosition)

        Thrust.Location = targetHRP.Position
    end)

    return true
end

local function flingPlayers()
    local players = {}
    for player, _ in pairs(processedPlayers) do
        if player and player.Character and player.Character.Parent ~= nil then
            table.insert(players, player)
        end
    end
    
    if currentInput == "all" or currentInput == "nonfriends" then
        players = sortPlayersAlphabetically(players)
    end
    
    for _, player in ipairs(players) do
        if not flingActive then break end
        
        if player and player.Character and player.Character.Parent ~= nil then
            local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil
            
            if flingMode == 1 then
                SkidFling(player, duration)
            elseif flingMode == 2 then
                shhhlol(player)
            elseif flingMode == 3 then
                yeet(player)
                if currentInput == "all" or currentInput == "nonfriends" then
                    task.wait(1.5)
                end
            end
        end
    end
    
    if flingActive then
        task.wait()
        flingPlayers()
    end
end

local function addPlayerToProcessed(player)
    if not player or player == localPlayer then return end
    
    local matchesFilter = false
    local input = string.lower(currentInput)
    
    if input == "all" then
        matchesFilter = true
    elseif input == "nonfriends" then
        local success, isFriend = pcall(function()
            return player:IsFriendsWith(localPlayer.UserId)
        end)
        matchesFilter = not (success and isFriend)
    elseif input == "murder" then
        if Murder and player.Name == Murder then
            matchesFilter = IsAlive(player)
        end
    elseif input == "sheriff" or input == "hero" then
        if (Sheriff and player.Name == Sheriff) or (Hero and player.Name == Hero) then
            matchesFilter = IsAlive(player)
        end
    else
        local searchTerms = {}
        for term in string.gmatch(input, "([^,]+)") do
            term = string.match(term, "^%s*(.-)%s*$")
            if term ~= "" then
                table.insert(searchTerms, term)
            end
        end
        
        local playerName = string.lower(player.Name)
        local displayName = player.DisplayName and string.lower(player.DisplayName) or ""
        
        for _, term in ipairs(searchTerms) do
            if string.find(playerName, term) or string.find(displayName, term) then
                matchesFilter = true
                break
            end
        end
    end
    
    if matchesFilter then
        processedPlayers[player] = true
    end
end

local flingInputValue = ""
FlingInput = Tabs.Utility:Input({
    Title = "Fling Target",
    Placeholder = "nickname, all, nonfriends, murder, sheriff",
    Callback = function(value)
        flingInputValue = value
        currentInput = string.lower(value)
    end
})

FlingModeDropdown = Tabs.Utility:Dropdown({
    Title = "Fling Mode",
    Values = {"SkidFling", "Shhhlol", "Yeet"},
    Value = "SkidFling",
    Callback = function(value)
        if value == "SkidFling" then
            flingMode = 1
        elseif value == "Shhhlol" then
            flingMode = 2
        elseif value == "Yeet" then
            flingMode = 3
        end
    end
})

FlingToggle = Tabs.Utility:Toggle({
    Title = "Fling Players",
    Value = false,
    Callback = function(state)
        flingActive = state
        
        if flingActive then
            currentInput = string.lower(flingInputValue or "")
            local players = getPlayers(currentInput)
            
            if #players == 0 then
                WindUI:Notify({
                    Title = "Fling Target",
                    Content = "Invalid Input: " .. currentInput,
                    Duration = 3
                })
                flingActive = false
                FlingToggle:Set(false)
                return
            end
            
            processedPlayers = {}
            for _, player in ipairs(players) do
                addPlayerToProcessed(player)
            end
            
            WindUI:Notify({
                Title = "Fling Target",
                Content = "Flinging " .. #players .. " players",
                Duration = 3
            })
            
            coroutine.wrap(flingPlayers)()
        else
            processedPlayers = {}
        end
    end
})

Tabs.Utility:Button({
    Title = "Fling Murderer",
    Callback = function()
        if flingActive then
            WindUI:Notify({
                Title = "Fling Target",
                Content = "Stop current fling first",
                Duration = 2
            })
            return
        end
        
        currentInput = "murder"
        local players = getPlayers(currentInput)
        
        if #players == 0 then
            WindUI:Notify({
                Title = "Fling Target",
                Content = "No alive murderer found",
                Duration = 3
            })
            return
        end
        
        flingActive = true
        processedPlayers = {}
        for _, player in ipairs(players) do
            addPlayerToProcessed(player)
        end
        
        WindUI:Notify({
            Title = "Fling Target",
            Content = "Flinging murderer: " .. players[1].Name .. " for 10 seconds",
            Duration = 3
        })
        
        local stopTimer = 10
        local startTime = tick()
        
        coroutine.wrap(function()
            while flingActive and tick() - startTime < stopTimer do
                task.wait(1)
            end
            if flingActive then
                flingActive = false
                processedPlayers = {}
                FlingToggle:Set(false)
            end
        end)()
        
        coroutine.wrap(flingPlayers)()
    end
})

Tabs.Utility:Button({
    Title = "Fling Sheriff/Hero",
    Callback = function()
        if flingActive then
            WindUI:Notify({
                Title = "Fling Target",
                Content = "Stop current fling first",
                Duration = 2
            })
            return
        end
        
        currentInput = "sheriff"
        local players = getPlayers(currentInput)
        
        if #players == 0 then
            WindUI:Notify({
                Title = "Fling Target",
                Content = "No alive sheriff or hero found",
                Duration = 3
            })
            return
        end
        
        flingActive = true
        processedPlayers = {}
        for _, player in ipairs(players) do
            addPlayerToProcessed(player)
        end
        
        local targetNames = ""
        for i, player in ipairs(players) do
            targetNames = targetNames .. player.Name
            if i < #players then
                targetNames = targetNames .. ", "
            end
        end
        
        WindUI:Notify({
            Title = "Fling Target",
            Content = "Flinging: " .. targetNames .. " for 10 seconds",
            Duration = 3
        })
        
        local stopTimer = 10
        local startTime = tick()
        
        coroutine.wrap(function()
            while flingActive and tick() - startTime < stopTimer do
                task.wait(1)
            end
            if flingActive then
                flingActive = false
                processedPlayers = {}
                FlingToggle:Set(false)
            end
        end)()
        
        coroutine.wrap(flingPlayers)()
    end
})
game.Players.PlayerAdded:Connect(function(player)
    if flingActive then
        addPlayerToProcessed(player)
        if player.Character then
            if flingMode == 1 then
                local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil
                SkidFling(player, duration)
            elseif flingMode == 2 then
                shhhlol(player)
            elseif flingMode == 3 then
                yeet(player)
            end
        else
            player.CharacterAdded:Connect(function()
                if flingActive then
                    addPlayerToProcessed(player)
                    if flingMode == 1 then
                        local duration = (currentInput == "all" or currentInput == "nonfriends") and 1.5 or nil
                        SkidFling(player, duration)
                    elseif flingMode == 2 then
                        shhhlol(player)
                    elseif flingMode == 3 then
                        yeet(player)
                    end
                end
            end)
        end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    if flingActive then
        task.wait(1)
        coroutine.wrap(flingPlayers)()
    end
end)
local antiVoidActive = false
local originalDestroyHeight = workspace.FallenPartsDestroyHeight

local function enableAntiVoid()
    if antiVoidActive then return end
    antiVoidActive = true
    originalDestroyHeight = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = -math.huge
end

local function disableAntiVoid()
    if not antiVoidActive then return end
    workspace.FallenPartsDestroyHeight = originalDestroyHeight
    antiVoidActive = false
end

Tabs.Utility:Toggle({
    Title = "Anti Void Damage",
    Value = false,
    Callback = function(state)
        if state then
            enableAntiVoid()
        else
            disableAntiVoid()
        end
    end
})
local infinitePositionEnabled = false
local savedPosition = nil
local positionConnection = nil
local positionTolerance = 0.1

local function lockPosition()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end

    if not savedPosition then
        savedPosition = hrp.CFrame
    end

    positionConnection = RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent and savedPosition then
            if (hrp.Position - savedPosition.Position).Magnitude > positionTolerance then
                hrp.CFrame = savedPosition
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function unlockPosition()
    if positionConnection then
        positionConnection:Disconnect()
        positionConnection = nil
    end
    savedPosition = nil
end

InfinitePositionToggle = Tabs.Utility:Toggle({
    Title = "Infinite Position Lock",
    Desc = "Lock your position in place",
    Value = false,
    Callback = function(state)
        infinitePositionEnabled = state
        if state then
            lockPosition()
            player.CharacterAdded:Connect(function()
                if infinitePositionEnabled then
                    task.wait(0.1)
                    lockPosition()
                end
            end)
        else
            unlockPosition()
        end
    end
})
TimeChangerInput = Tabs.Utility:Input({
    Title = "Set Time (HH:MM)",
    Placeholder = "12:00",
    Callback = function(value)
        value = value:gsub("^%s*(.-)%s*$", "%1")
        
        local h_str, m_str = value:match("(%d+):(%d+)")
        if h_str and m_str then
            local h = tonumber(h_str)
            local m = tonumber(m_str)
            
            if h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59 and #h_str <= 2 and #m_str <= 2 then
                local totalHours = h + (m / 60)
                game:GetService("Lighting").ClockTime = totalHours
             end
        end
    end
})
getgenv().lagSwitchEnabled = false
getgenv().lagDuration = 0.5
local lagGui = nil
local lagGuiButton = nil
local lagInputConnection = nil
local isLagActive = false
local lagSystemLoaded = false

local function makeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
    
    local dragDetector = Instance.new("UIDragDetector")
    dragDetector.Parent = frame
    
    local originalBackground = frame.BackgroundColor3
    local originalTransparency = frame.BackgroundTransparency
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            frame.BackgroundTransparency = originalTransparency - 0.1
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            frame.BackgroundTransparency = originalTransparency
        end
    end)
end

local function loadLagSystem()
    if lagSystemLoaded then return end
    lagSystemLoaded = true
    
    if not lagInputConnection then
        lagInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.L and getgenv().lagSwitchEnabled and not isLagActive then
                isLagActive = true
                task.spawn(function()
                    local duration = getgenv().lagDuration or 0.5
                    local start = tick()
                    while tick() - start < duration do
                        local a = math.random(1, 1000000) * math.random(1, 1000000)
                        a = a / math.random(1, 10000)
                    end
                    isLagActive = false
                end)
            end
        end)
    end
end

local function unloadLagSystem()
    if not lagSystemLoaded then return end
    lagSystemLoaded = false
    
    if lagInputConnection then
        lagInputConnection:Disconnect()
        lagInputConnection = nil
    end
    isLagActive = false
end

local function checkLagState()
    local shouldLoad = getgenv().lagSwitchEnabled
    
    if shouldLoad and not lagSystemLoaded then
        loadLagSystem()
    elseif not shouldLoad and lagSystemLoaded then
        unloadLagSystem()
    end
end

local function createLagGui(yOffset)
    local lagGuiOld = playerGui:FindFirstChild("LagSwitchGui")
    if lagGuiOld then lagGuiOld:Destroy() end
    
    lagGui = Instance.new("ScreenGui")
    lagGui.Name = "LagSwitchGui"
    lagGui.IgnoreGuiInset = true
    lagGui.ResetOnSpawn = false
    lagGui.Enabled = getgenv().lagSwitchEnabled
    lagGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 60, 0, 60)
    frame.Position = UDim2.new(0.5, -30, 0.12 + (yOffset or 0), 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel = 0
    frame.Parent = lagGui
    makeDraggable(frame)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 150, 150)
    stroke.Thickness = 2
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = "Lag"
    label.Size = UDim2.new(0.9, 0, 0.5, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Roboto
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextScaled = true
    label.Parent = frame

    lagGuiButton = Instance.new("TextButton")
    lagGuiButton.Name = "TriggerButton"
    lagGuiButton.Text = "Trigger"
    lagGuiButton.Size = UDim2.new(0.9, 0, 0.5, 0)
    lagGuiButton.Position = UDim2.new(0.05, 0, 0.5, 0)
    lagGuiButton.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
    lagGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    lagGuiButton.Font = Enum.Font.Roboto
    lagGuiButton.TextSize = 14
    lagGuiButton.TextXAlignment = Enum.TextXAlignment.Center
    lagGuiButton.TextYAlignment = Enum.TextYAlignment.Center
    lagGuiButton.TextScaled = true
    lagGuiButton.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = lagGuiButton

    lagGuiButton.MouseButton1Click:Connect(function()
        if not isLagActive then
            isLagActive = true
            task.spawn(function()
                local start = tick()
                while tick() - start < (getgenv().lagDuration or 0.5) do
                    local a = math.random(1, 1000000) * math.random(1, 1000000)
                    a = a / math.random(1, 10000)
                end
                isLagActive = false
            end)
        end
    end)
end

LagSwitchToggle = Tabs.Utility:Toggle({
    Title = "Lag Switch",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        getgenv().lagSwitchEnabled = state
        if state then
            if not lagGui then
                createLagGui(0)
            else
                lagGui.Enabled = true
            end
        else
            if lagGui then
                lagGui.Enabled = false
            end
        end
        checkLagState()
    end
})

LagDurationInput = Tabs.Utility:Input({
    Title = "Lag Duration (seconds)",
    Placeholder = "0.5",
    Value = tostring(getgenv().lagDuration),
    NumbersOnly = true,
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then
            getgenv().lagDuration = n
        end
    end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        unloadLagSystem()
        if lagGui then
            lagGui:Destroy()
        end
    end
end)

checkLagState()
GravityToggle = Tabs.Utility:Toggle({
    Title = "Custom Gravity",
    Value = false,
    Callback = function(state)
        featureStates.CustomGravity = state
        if state then
            workspace.Gravity = featureStates.GravityValue
        else
            workspace.Gravity = originalGameGravity
        end
    end
})

GravityInput = Tabs.Utility:Input({
    Title = "Gravity Value",
    Placeholder = tostring(originalGameGravity),
    Value = tostring(featureStates.GravityValue),
    Callback = function(text)
        local num = tonumber(text)
        if num then
            featureStates.GravityValue = num
            if featureStates.CustomGravity then
                workspace.Gravity = num
            end
        end
    end
})
getgenv().gravityGuiVisible = false

GravityGUIToggle = Tabs.Utility:Toggle({
    Title = "Gravity toggle shortcuts",
    Desc = "Toggle gui or keybind for quick enable gravity",
    Icon = "toggle-right",
    Value = false,
    Callback = function(state)
        getgenv().gravityGuiVisible = state
        local gravityGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("GravityGui")
        if gravityGui then
            gravityGui.Enabled = state
        end
        if not state then
            WindUI:Notify({
                Title = "Gravity GUI",
                Content = "GUI And keybind disabled.",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Gravity toggle shortcuts",
                Content = "GUI is enabled or Press J to toggle gravity.",
                Duration = 3
            })
        end
    end
})
featureStates.NoRender = false
featureStates.NoRenderColor = Color3.fromRGB(0, 0, 0)

NoRenderToggle = Tabs.Utility:Toggle({
    Title = "No Render",
    Desc = "Disable 3D rendering for performance",
    Value = false,
    Callback = function(state)
        featureStates.NoRender = state
        game:GetService("RunService"):Set3dRenderingEnabled(not state)
        
        if state then
            local gui = Instance.new("ScreenGui")
            gui.Name = "NoRenderBackground"
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.ResetOnSpawn = false
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = featureStates.NoRenderColor
            frame.BorderSizePixel = 0
            frame.Parent = gui
            
            gui.Parent = player.PlayerGui
        else
            local gui = player.PlayerGui:FindFirstChild("NoRenderBackground")
            if gui then
                gui:Destroy()
            end
        end
    end
})

NoRenderColorPicker = Tabs.Utility:Colorpicker({
    Title = "No Render Color",
    Desc = "Choose background color when No Render is enabled",
    Default = Color3.fromRGB(0, 0, 0),
    Transparency = 0,
    Callback = function(color)
        featureStates.NoRenderColor = color
        
        if featureStates.NoRender then
            local gui = player.PlayerGui:FindFirstChild("NoRenderBackground")
            if gui then
                local frame = gui:FindFirstChildOfClass("Frame")
                if frame then
                    frame.BackgroundColor3 = color
                end
            end
        end
    end
})
featureStates.RemoveTextures = false

RemoveTexturesButton = Tabs.Utility:Button({
    Title = "Remove Textures",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") or part:IsA("WedgePart") or part:IsA("CornerWedgePart") then
                if part:IsA("Part") then
                    part.Material = Enum.Material.SmoothPlastic
                end
                if part:FindFirstChildWhichIsA("Texture") then
                    local texture = part:FindFirstChildWhichIsA("Texture")
                    texture.Texture = "rbxassetid://0"
                end
                if part:FindFirstChildWhichIsA("Decal") then
                    local decal = part:FindFirstChildWhichIsA("Decal")
                    decal.Texture = "rbxassetid://0"
                end
            end
        end
    end
})
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)
LowQualityButton = Tabs.Utility:Button({
    Title = "Low Quality",
    Desc = "Disable textures, effects, and optimize graphics",
    Callback = function()
        local ToDisable = {
            Textures = true,
            VisualEffects = true,
            Parts = true,
            Particles = true,
            Sky = true
        }

        local ToEnable = {
            FullBright = false
        }

        local Stuff = {}

        for _, v in next, game:GetDescendants() do
            if ToDisable.Parts then
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Particles then
                if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.VisualEffects then
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Textures then
                if v:IsA("Decal") or v:IsA("Texture") then
                    v.Texture = ""
                    table.insert(Stuff, 1, v)
                end
            end
            
            if ToDisable.Sky then
                if v:IsA("Sky") then
                    v.Parent = nil
                    table.insert(Stuff, 1, v)
                end
            end
        end

        if ToEnable.FullBright then
            local Lighting = game:GetService("Lighting")
            
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            Lighting.FogEnd = math.huge
            Lighting.FogStart = math.huge
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 5
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Outlines = true
        end
    end
})

local antiFlingEnabled = false
local antiFlingConnection = nil

local function setCanCollideOfModelDescendants(model, bval)
    if not model then return end
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = bval
        end
    end
end

local function startAntiFling()
    if antiFlingConnection then return end
    
    antiFlingConnection = RunService.Stepped:Connect(function()
        if antiFlingEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    setCanCollideOfModelDescendants(player.Character, false)
                end
            end
        end
    end)
end

local function stopAntiFling()
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            setCanCollideOfModelDescendants(player.Character, true)
        end
    end
end

AntiFlingToggle = Tabs.Utility:Toggle({
    Title = "Disable Player Collisions",
    Value = false,
    Callback = function(state)
        antiFlingEnabled = state
        if state then
            startAntiFling()
        else
            stopAntiFling()
        end
    end
})
HitboxSettings = {
    Enabled = false,
    Size = 5,
    Color = Color3.new(1, 0, 0),
    Adornments = {}
}

function UpdateHitboxes()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            local box = HitboxSettings.Adornments[plr]
            if chr and HitboxSettings.Enabled then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root then
                    if not box then
                        box = Instance.new("BoxHandleAdornment")
                        box.Adornee = root
                        box.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                        box.Color3 = HitboxSettings.Color
                        box.Transparency = 0.4
                        box.ZIndex = 10
                        box.Parent = root
                        HitboxSettings.Adornments[plr] = box
                    else
                        box.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                        box.Color3 = HitboxSettings.Color
                    end
                end
            elseif box then
                box:Destroy()
                HitboxSettings.Adornments[plr] = nil
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if HitboxSettings.Enabled then
        task.wait(1)
        UpdateHitboxes()
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if HitboxSettings.Adornments[plr] then
        HitboxSettings.Adornments[plr]:Destroy()
        HitboxSettings.Adornments[plr] = nil
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if HitboxSettings.Enabled then
            task.wait(0.5)
            UpdateHitboxes()
        end
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            if HitboxSettings.Enabled then
                task.wait(0.5)
                UpdateHitboxes()
            end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if HitboxSettings.Enabled then
        UpdateHitboxes()
    end
end)


Tabs.Utility:Toggle(
    {
        Title = "Show Hitboxes",
        Callback = function(state)
            HitboxSettings.Enabled = state
            if state then
                UpdateHitboxes()
            else
                for _, box in pairs(HitboxSettings.Adornments) do
                    if box then
                        box:Destroy()
                    end
                end
                HitboxSettings.Adornments = {}
            end
        end
    }
)

Tabs.Utility:Slider(
    {
        Title = "Hitbox Size",
        Value = {Min = 1, Max = 30, Default = 5},
        Callback = function(val)
            HitboxSettings.Size = val
            UpdateHitboxes()
        end
    }
)

Tabs.Utility:Colorpicker(
    {
        Title = "Hitbox Color",
        Default = Color3.new(1, 0, 0),
        Callback = function(col)
            HitboxSettings.Color = col
            UpdateHitboxes()
        end
    }
)
Tabs.Settings:Section({ Title = "Configuration", TextSize = 20 })
Tabs.Settings:Divider()

ConfigNameInput = Tabs.Settings:Input({
    Title = "Config Name",
    Placeholder = "Enter config name",
    Callback = function(value)
        configFileName = value
    end
})

Tabs.Settings:Button({
    Title = "Save Configuration",
    Desc = "Save current settings to file",
    Icon = "save",
    Callback = function()
        success, error = pcall(function()
            if not isfolder("mm2") then
                makefolder("mm2")
            end
            
            fileName = configFileName and configFileName ~= "" and configFileName or "MM2"
            
            configData = {
                Theme = WindUI:GetCurrentTheme(),
                Transparency = WindUI.TransparencyValue,
                FeatureStates = featureStates
            }
            
            writefile("mm2/" .. fileName .. ".json", HttpService:JSONEncode(configData))
        end)
        
        if success then
            UpdateConfigList()
        end
    end
})

ConfigDropdown = Tabs.Settings:Dropdown({
    Title = "Load Configuration",
    Values = {"Select a config"},
    Value = "Select a config",
    Callback = function(value)
        if value ~= "Select a config" then
            success, error = pcall(function()
                if isfile("mm2/" .. value .. ".json") then
                    configData = HttpService:JSONDecode(readfile("mm2/" .. value .. ".json"))
                    
                    if configData.Theme then
                        WindUI:SetTheme(configData.Theme)
                    end
                    if configData.Transparency then
                        WindUI.TransparencyValue = configData.Transparency
                    end
                    if configData.FeatureStates then
                        for key, val in pairs(configData.FeatureStates) do
                            featureStates[key] = val
                        end
                        if InfiniteJumpToggle then
                            InfiniteJumpToggle:Set(featureStates.InfiniteJump)
                        end
                        if SpeedToggle then
                            SpeedToggle:Set(featureStates.SpeedHack)
                            if featureStates.SpeedHack and humanoid then
                                humanoid.WalkSpeed = featureStates.SpeedValue
                            elseif humanoid then
                                humanoid.WalkSpeed = 16
                            end
                        end
                        if SpeedSlider then
                            SpeedSlider:Set(featureStates.SpeedValue)
                        end
                        if NoclipToggle then
                            NoclipToggle:Set(featureStates.Noclip)
                            if featureStates.Noclip then
                                noclip()
                            else
                                clip()
                            end
                        end
                        if FlyToggle then
                            FlyToggle:Set(featureStates.Fly)
                            if featureStates.Fly then
                                startFlying()
                                flyConnection = RunService.Heartbeat:Connect(updateFly)
                            else
                                stopFlying()
                                if flyConnection then
                                    flyConnection:Disconnect()
                                    flyConnection = nil
                                end
                            end
                        end
                        if FlySpeedSlider then
                            FlySpeedSlider:Set(featureStates.FlySpeed)
                        end
                        if TPWALKToggle then
                            TPWALKToggle:Set(featureStates.TPWALK)
                            if featureStates.TPWALK then
                                startTpwalk()
                            else
                                stopTpwalk()
                            end
                        end
                        if TPWALKSlider then
                            TPWALKSlider:Set(featureStates.TpwalkValue)
                        end
                        if JumpBoostToggle then
                            JumpBoostToggle:Set(featureStates.JumpBoost)
                            if featureStates.JumpBoost then
                                startJumpBoost()
                            else
                                stopJumpBoost()
                            end
                        end
                        if JumpBoostSlider then
                            JumpBoostSlider:Set(featureStates.JumpPower)
                        end
                        if AntiAFKToggle then
                            AntiAFKToggle:Set(featureStates.AntiAFK)
                            if featureStates.AntiAFK then
                                startAntiAFK()
                            else
                                stopAntiAFK()
                            end
                        end
                        if InnocentNameESPToggle then
                            InnocentNameESPToggle:Set(featureStates.InnocentESP.names)
                        end
                        if InnocentBoxESPToggle then
                            InnocentBoxESPToggle:Set(featureStates.InnocentESP.boxes)
                        end
                        if InnocentTracerToggle then
                            InnocentTracerToggle:Set(featureStates.InnocentESP.tracers)
                        end
                        if InnocentDistanceESPToggle then
                            InnocentDistanceESPToggle:Set(featureStates.InnocentESP.distance)
                        end
                        if InnocentBoxTypeDropdown then
                            InnocentBoxTypeDropdown:Set(featureStates.InnocentESP.boxType)
                        end
                        if MurderNameESPToggle then
                            MurderNameESPToggle:Set(featureStates.MurderESP.names)
                        end
                        if MurderBoxESPToggle then
                            MurderBoxESPToggle:Set(featureStates.MurderESP.boxes)
                        end
                        if MurderTracerToggle then
                            MurderTracerToggle:Set(featureStates.MurderESP.tracers)
                        end
                        if MurderDistanceESPToggle then
                            MurderDistanceESPToggle:Set(featureStates.MurderESP.distance)
                        end
                        if MurderBoxTypeDropdown then
                            MurderBoxTypeDropdown:Set(featureStates.MurderESP.boxType)
                        end
                        if HeroSheriffNameESPToggle then
                            HeroSheriffNameESPToggle:Set(featureStates.HeroSheriffESP.names)
                        end
                        if HeroSheriffBoxESPToggle then
                            HeroSheriffBoxESPToggle:Set(featureStates.HeroSheriffESP.boxes)
                        end
                        if HeroSheriffTracerToggle then
                            HeroSheriffTracerToggle:Set(featureStates.HeroSheriffESP.tracers)
                        end
                        if HeroSheriffDistanceESPToggle then
                            HeroSheriffDistanceESPToggle:Set(featureStates.HeroSheriffESP.distance)
                        end
                        if HeroSheriffBoxTypeDropdown then
                            HeroSheriffBoxTypeDropdown:Set(featureStates.HeroSheriffESP.boxType)
                        end
                        if InnocentHighlightsToggle then
                            InnocentHighlightsToggle:Set(featureStates.InnocentHighlights)
                        end
                        if MurderHighlightsToggle then
                            MurderHighlightsToggle:Set(featureStates.MurderHighlights)
                        end
                        if SheriffHeroHighlightsToggle then
                            SheriffHeroHighlightsToggle:Set(featureStates.SheriffHeroHighlights)
                        end
                        managePlayerESPConnection()
                        manageHighlightsConnection()
                        if featureStates.Fly then
                            startFlying()
                            flyConnection = RunService.Heartbeat:Connect(updateFly)
                        else
                            stopFlying()
                            if flyConnection then
                                flyConnection:Disconnect()
                                flyConnection = nil
                            end
                        end
                        if featureStates.TPWALK then
                            startTpwalk()
                        else
                            stopTpwalk()
                        end
                        if featureStates.JumpBoost then
                            startJumpBoost()
                        else
                            stopJumpBoost()
                        end
                        if featureStates.AntiAFK then
                            startAntiAFK()
                        else
                            stopAntiAFK()
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Settings:Button({
    Title = "Delete Config",
    Desc = "Delete selected configuration",
    Icon = "trash-2",
    Callback = function()
        selectedConfig = ConfigDropdown.Value
        if selectedConfig ~= "Select a config" then
            success, error = pcall(function()
                if isfile("mm2/" .. selectedConfig .. ".json") then
                    delfile("mm2/" .. selectedConfig .. ".json")
                    UpdateConfigList()
                end
            end)
        end
    end
})

function UpdateConfigList()
    configList = {"Select a config"}
    if isfolder("mm2") then
        files = listfiles("mm2")
        for i, file in ipairs(files) do
            if file:sub(-5) == ".json" then
                fileName = file:match(".*/(.*)%.json")
                if fileName then
                    table.insert(configList, fileName)
                end
            end
        end
    end
    ConfigDropdown:Refresh(configList, "Select a config")
end

Tabs.Settings:Dropdown({
    Title = "Select Theme",
    Values = {"Dark", "Light", "Blue", "Red", "Green", "Purple"},
    Value = "Dark",
    Callback = function(value)
        WindUI:SetTheme(value)
    end
})

Tabs.Settings:Slider({
    Title = "Window Transparency",
    Value = { Min = 0, Max = 1, Default = 0.2, Step = 0.1 },
    Callback = function(value)
        WindUI.TransparencyValue = value
    end
})
        Tabs.Settings:Keybind({
        Flag = "Keybind",
        Title = "Keybind",
        Desc = "Keybind to open ui",
        Value = "RightControl",
        Callback = function(RightControl)
            Window:SetToggleKey(Enum.KeyCode[RightControl])
        end
    })
UpdateConfigList()

lastConfigUpdate = 0
configUpdateCooldown = 5

RunService.Heartbeat:Connect(function()
    currentTime = tick()
    if currentTime - lastConfigUpdate >= configUpdateCooldown then
        UpdateConfigList()
        lastConfigUpdate = currentTime
    end
end)

ConfigNameInput.Callback = function(value)
    configFileName = value
    UpdateConfigList()
end
do
     InviteCode = "ny6pJgnR6c"
     DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

     success = pcall(function()
        Response = game:GetService("HttpService"):JSONDecode(request({
            Url = DiscordAPI,
            Method = "GET"
        }).Body)
        return Response
    end)
    
    if success and Response and Response.guild then
        Tabs.Info:Section({
            Title = "Join My Discord Server",
            TextSize = 20,
        })
         DiscordServerParagraph = Tabs.Info:Paragraph({
            Title = tostring(Response.guild.name),
            Desc = tostring(Response.guild.description),
            Image = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024",
            -- Thumbnail = "https://cdn.discordapp.com/banners/1300692552005189632/35981388401406a4b7dffd6f447a64c4.png?size=512",
            ImageSize = 48,
            Buttons = {
                {
                    Title = "Copy link",
                    Icon = "link",
                    Callback = function()
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end
                }
            }
        })
    end
end