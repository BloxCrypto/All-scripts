return function(Window, Tabs)
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")
    local HttpService = game:GetService("HttpService")

    local LocalPlayer = Players.LocalPlayer
    local placeId = game.PlaceId
    local jobId = game.JobId
    local privateServerId = game.PrivateServerId

    local InfoSection = Tabs.Info:AddSection("Blueflarev2 Information", true)

    InfoSection:AddParagraph({
        Title = "Blueflare Alert!",
        Content = [[
This script is still under development!
There is a possibility it may get detected if used in public servers!
If you have suggestions or found bugs, please report them to <font color="rgb(0,170,255)">Discord Blueflare</font>!<br/>
<b>Use at your own risk!</b>
]],
        Icon = "water"
    })

    InfoSection:AddParagraph({
        Title = "Blueflare Discord",
        Content = "Official link discord Blueflare!",
        Icon = "discord",
        ButtonText = "COPY LINK DISCORD",
        ButtonCallback = function()
            if setclipboard then
                setclipboard("https://discord.gg/fUNMX29UAJ")
                print("Succesfully copied link!")
            end
        end
    })

    InfoSection:AddButton({
        Title = "Rejoin Server",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
    })

    local MiscBooster = Tabs.Misc:AddSection("Booster FPS")

    MiscBooster:AddToggle({
        Title = "Disable 3D Render",
        Content = "No Render Map",
        Default = false,
        Callback = function(state)
            if typeof(RunService.Set3dRenderingEnabled) == "function" then
                RunService:Set3dRenderingEnabled(not state)
                SaveConfig()
            end
        end
    })

    MiscBooster:AddToggle({
        Title = "Reduce Map",
        Content = "Dont turn on this with Disable 3D Render",
        Default = false,
        Callback = function(state)
            if state then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Material = Enum.Material.Plastic
                        obj.CastShadow = false
                        obj.Reflectance = 0
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = 1
                    elseif obj:IsA("ParticleEmitter")
                        or obj:IsA("Trail")
                        or obj:IsA("Beam")
                        or obj:IsA("Smoke")
                        or obj:IsA("Fire")
                        or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    elseif obj:IsA("Highlight") then
                        obj:Destroy()
                    elseif obj:IsA("MeshPart") then
                        obj.MeshId = ""
                        obj.TextureID = ""
                    elseif obj:IsA("SpecialMesh") then
                        obj.MeshId = ""
                        obj.TextureId = ""
                    end
                end

                local Lighting = game:GetService("Lighting")

                for _, eff in ipairs(Lighting:GetChildren()) do
                    if eff:IsA("BloomEffect")
                        or eff:IsA("DepthOfFieldEffect")
                        or eff:IsA("ColorCorrectionEffect")
                        or eff:IsA("SunRaysEffect") then
                        eff.Enabled = false
                    end
                end

                Lighting.GlobalShadows = false
                Lighting.FogStart = 9e9
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 1

                if workspace:FindFirstChild("Terrain") then
                    local t = workspace.Terrain
                    t.WaterWaveSize = 0
                    t.WaterWaveSpeed = 0
                    t.WaterReflectance = 0
                    t.WaterTransparency = 1
                end
            end
        end
    })

    MiscBooster:AddToggle({
        Title = "Black Screen",
        Content = "Make your screen fully black",
        Default = false,
        Callback = function(value)
            local coreGui = game:GetService("CoreGui")
            local chloeUI = coreGui:FindFirstChild("Chloeex")
            local toggleUI = coreGui:FindFirstChild("ToggleUIButton")

            if value then
                if not coreGui:FindFirstChild("BlackScreen") then
                    local frame = Instance.new("ScreenGui")
                    frame.Name = "BlackScreen"
                    frame.IgnoreGuiInset = true
                    frame.ResetOnSpawn = false
                    frame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    frame.DisplayOrder = 0
                    frame.Parent = coreGui

                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 1, 0)
                    bg.BackgroundColor3 = Color3.new(0, 0, 0)
                    bg.ZIndex = 0
                    bg.Parent = frame
                end
                if chloeUI then chloeUI.DisplayOrder = 10 end
                if toggleUI then toggleUI.DisplayOrder = 11 end
                RunService:Set3dRenderingEnabled(false)
            else
                local bs = coreGui:FindFirstChild("BlackScreen")
                if bs then bs:Destroy() end
                RunService:Set3dRenderingEnabled(true)
            end
        end
    })

    local Misc = Tabs.Misc:AddSection("Utility Player")
    local NoclipEnabled, WalkspeedEnabled, InfJumpEnabled = false, false, false
    local WalkspeedValue = 16

    Misc:AddToggle({
        Title = "Noclip",
        Content = "Walk through objects",
        Default = false,
        Callback = function(v) NoclipEnabled = v end
    })

    RunService.Stepped:Connect(function()
        if NoclipEnabled and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)

    Misc:AddSlider({
        Title = "Walkspeed",
        Min = 16,
        Max = 200,
        Default = 16,
        Callback = function(val)
            WalkspeedValue = val
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if WalkspeedEnabled and hum then hum.WalkSpeed = val end
        end
    })

    Misc:AddToggle({
        Title = "Enable Walkspeed",
        Content = "Speed boost",
        Default = false,
        Callback = function(v)
            WalkspeedEnabled = v
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = v and WalkspeedValue or 16 end
        end
    })

    Misc:AddToggle({
        Title = "Fullbright",
        Default = false,
        Callback = function(state)
            if state then
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.Brightness = 2
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
            else
                Lighting.Ambient = Color3.new(0, 0, 0)
                Lighting.Brightness = 1
                Lighting.FogEnd = 1000
                Lighting.GlobalShadows = true
            end
        end
    })

    Misc:AddToggle({
        Title = "Infinite Jump",
        Default = false,
        Callback = function(v) InfJumpEnabled = v end
    })

    UserInputService.JumpRequest:Connect(function()
        if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    local defaultZoom = 128
    local zoomConn

    Misc:AddToggle({
        Title = "Max Zoom 1000",
        Content = "Increase max camera distance",
        Default = false,
        Callback = function(state)
            local lp = Players.LocalPlayer

            if zoomConn then
                zoomConn:Disconnect()
                zoomConn = nil
            end

            if state then
                lp.CameraMaxZoomDistance = 1000
                lp.CameraMinZoomDistance = 0.5

                zoomConn = lp.CharacterAdded:Connect(function()
                    task.wait(0.3)
                    lp.CameraMaxZoomDistance = 1000
                    lp.CameraMinZoomDistance = 0.5
                end)
            else
                lp.CameraMaxZoomDistance = defaultZoom
                lp.CameraMinZoomDistance = 0.5
            end
        end
    })

    Misc:AddSubSection("Fly Features")

    local FLYING, QEfly, iyflyspeed = false, true, 1
    local flyKeyDown, flyKeyUp

    local function getRoot(char)
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or
            char:FindFirstChild("UpperTorso")
    end

    local function NOFLY()
        FLYING = false
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(root:GetChildren()) do
                    if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
                end
            end
        end
    end

    local function sFLY(vfly)
        local plr = LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
        local T = getRoot(char)
        local CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
        local lCONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
        local SPEED = 0

        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end

        local function FLY()
            FLYING = true
            local BG = Instance.new('BodyGyro')
            local BV = Instance.new('BodyVelocity')
            BG.P, BG.MaxTorque = 9e4, Vector3.new(9e9, 9e9, 9e9)
            BG.CFrame, BG.Parent, BV.Parent = T.CFrame, T, T
            BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            task.spawn(function()
                repeat
                    task.wait()
                    local cam = workspace.CurrentCamera
                    if not vfly then humanoid.PlatformStand = true end
                    SPEED = (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and
                        (iyflyspeed * 50) or 0
                    if SPEED ~= 0 then
                        BV.Velocity = ((cam.CFrame.LookVector * (CONTROL.F + CONTROL.B)) +
                                ((cam.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - cam.CFrame.p)) *
                            SPEED
                        lCONTROL = { F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R }
                    else
                        BV.Velocity = Vector3.zero
                    end
                    BG.CFrame = cam.CFrame
                until not FLYING
                BG:Destroy(); BV:Destroy()
                humanoid.PlatformStand = false
            end)
        end

        flyKeyDown = UserInputService.InputBegan:Connect(function(input)
            local k = input.KeyCode
            if k == Enum.KeyCode.W then
                CONTROL.F = 1
            elseif k == Enum.KeyCode.S then
                CONTROL.B = -1
            elseif k == Enum.KeyCode.A then
                CONTROL.L = -1
            elseif k == Enum.KeyCode.D then
                CONTROL.R = 1
            elseif k == Enum.KeyCode.E and QEfly then
                CONTROL.Q = 1
            elseif k == Enum.KeyCode.Q and QEfly then
                CONTROL.E = -1
            end
        end)

        flyKeyUp = UserInputService.InputEnded:Connect(function(input)
            local k = input.KeyCode
            if k == Enum.KeyCode.W then
                CONTROL.F = 0
            elseif k == Enum.KeyCode.S then
                CONTROL.B = 0
            elseif k == Enum.KeyCode.A then
                CONTROL.L = 0
            elseif k == Enum.KeyCode.D then
                CONTROL.R = 0
            elseif k == Enum.KeyCode.E then
                CONTROL.Q = 0
            elseif k == Enum.KeyCode.Q then
                CONTROL.E = 0
            end
        end)

        FLY()
    end

    local function mobilefly(plr)
        FLYING = true
        local char = plr.Character or plr.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        local control = require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild(
            "ControlModule"))

        local bv, bg = Instance.new("BodyVelocity"), Instance.new("BodyGyro")
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.MaxTorque, bg.P, bg.D = Vector3.new(9e9, 9e9, 9e9), 1000, 50
        bv.Parent, bg.Parent = root, root
        humanoid.PlatformStand = true

        task.spawn(function()
            while FLYING and task.wait() do
                local move = control:GetMoveVector()
                bg.CFrame = cam.CFrame
                local dir = (cam.CFrame.RightVector * move.X + cam.CFrame.LookVector * -move.Z)
                bv.Velocity = dir * (iyflyspeed * 50)
            end
            humanoid.PlatformStand = false
            bv:Destroy(); bg:Destroy()
        end)
    end

    Misc:AddSlider({
        Title = "Fly Speed",
        Min = 1,
        Max = 10,
        Default = 1,
        Callback = function(v) iyflyspeed = v end
    })

    Misc:AddToggle({
        Title = "Enable Fly",
        Content = "Toggle flight mode",
        Default = false,
        Callback = function(state)
            if state then
                if UserInputService.TouchEnabled then
                    mobilefly(LocalPlayer)
                else
                    sFLY()
                end
            else
                NOFLY()
            end
        end
    })

    Misc:AddSubSection("Freecam Features")

    fcRunning = false
    local Camera = workspace.CurrentCamera
    local UserInputService = game:GetService("UserInputService")
    local ContextActionService = game:GetService("ContextActionService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        local newCamera = workspace.CurrentCamera
        if newCamera then
            Camera = newCamera
        end
    end)

    local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
    local lastFreecamCF

    Spring = {}
    Spring.__index = Spring

    function Spring.new(freq, pos)
        local self = setmetatable({}, Spring)
        self.f = freq
        self.p = pos
        self.v = pos * 0
        return self
    end

    function Spring:Update(dt, goal)
        local f = self.f * 2 * math.pi
        local offset, decay = goal - self.p, math.exp(-f * dt)
        local p1 = goal + (self.v * dt - offset * (f * dt + 1)) * decay
        local v1 = (f * dt * (offset * f - self.v) + self.v) * decay
        self.p, self.v = p1, v1
        return p1
    end

    function Spring:Reset(pos)
        self.p, self.v = pos, pos * 0
    end

    cameraPos, cameraRot = Vector3.new(), Vector2.new()
    velSpring = Spring.new(5, Vector3.new())
    panSpring = Spring.new(5, Vector2.new())

    Input = {}
    do
        local keyboard = { W = 0, A = 0, S = 0, D = 0, E = 0, Q = 0, Up = 0, Down = 0 }
        local mouse = { Delta = Vector2.new() }
        local touchPan = Vector2.new()
        local touching = false
        local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
        local PAN_MOUSE_SPEED = Vector2.new(1, 1) * (math.pi / 64)
        local NAV_ADJ_SPEED, NAV_SHIFT_MUL = 0.75, 0.25
        local navSpeed = 1
        local mobileBoost = 1
        local lastTap = 0

        UserInputService.TouchStarted:Connect(function()
            local t = tick()
            if t - lastTap < 0.25 then
                mobileBoost = mobileBoost == 1 and 2 or 1
            end
            lastTap = t
            touching = true
        end)

        UserInputService.TouchEnded:Connect(function()
            touching = false
            touchPan = Vector2.new()
        end)

        UserInputService.TouchMoved:Connect(function(touch)
            if touching then
                touchPan = Vector2.new(-touch.Delta.y, -touch.Delta.x)
            end
        end)

        function Input.Vel(dt)
            if UserInputService.TouchEnabled then
                local mv = LocalPlayer:GetMoveVector()
                return Vector3.new(mv.X, 0, -mv.Z) * mobileBoost
            end
            navSpeed = math.clamp(navSpeed + dt * (keyboard.Up - keyboard.Down) * NAV_ADJ_SPEED, 0.01, 4)
            local move = Vector3.new(keyboard.D - keyboard.A, keyboard.E - keyboard.Q, keyboard.S - keyboard.W)
            local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            return move * NAV_KEYBOARD_SPEED * navSpeed * (shift and NAV_SHIFT_MUL or 1)
        end

        function Input.Pan(dt)
            if UserInputService.TouchEnabled then
                local v = touchPan * (math.pi / 360)
                touchPan = Vector2.new()
                return v
            end
            local v = mouse.Delta * PAN_MOUSE_SPEED
            mouse.Delta = Vector2.new()
            return v
        end

        function Keypress(_, state, input)
            keyboard[input.KeyCode.Name] = (state == Enum.UserInputState.Begin) and 1 or 0
            return Enum.ContextActionResult.Sink
        end

        function MousePan(_, _, input)
            if UserInputService.TouchEnabled then return Enum.ContextActionResult.Sink end
            mouse.Delta = Vector2.new(-input.Delta.y, -input.Delta.x)
            return Enum.ContextActionResult.Sink
        end

        function Zero(t)
            for k in pairs(t) do t[k] = 0 end
        end

        function Input.StartCapture()
            if not UserInputService.TouchEnabled then
                ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
                    Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.Up, Enum.KeyCode.Down)
                ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, INPUT_PRIORITY,
                    Enum.UserInputType.MouseMovement)
            end
        end

        function Input.StopCapture()
            Zero(keyboard)
            Zero(mouse)
            if not UserInputService.TouchEnabled then
                ContextActionService:UnbindAction("FreecamKeyboard")
                ContextActionService:UnbindAction("FreecamMousePan")
            end
        end
    end

    function GetFocusDistance(cf)
        local znear, viewport = 0.1, Camera.ViewportSize
        local projy = 2 * math.tan(math.rad(70 / 2))
        local projx = (viewport.X / viewport.Y) * projy
        local fx, fy, fz = cf.RightVector, cf.UpVector, cf.LookVector
        local minDist, minVect = 512, Vector3.new()
        for x = 0, 1, 0.5 do
            for y = 0, 1, 0.5 do
                local cx = (x - 0.5) * projx
                local cy = (y - 0.5) * projy
                local offset = fx * cx - fy * cy + fz
                local origin = cf.Position + offset * znear
                local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.Unit * minDist))
                if hit then
                    local d = (hit - origin).Magnitude
                    if d < minDist then
                        minDist, minVect = d, offset.Unit
                    end
                end
            end
        end
        return fz:Dot(minVect) * minDist
    end

    function StepFreecam(dt)
        local vel = velSpring:Update(dt, Input.Vel(dt))
        local pan = panSpring:Update(dt, Input.Pan(dt))
        cameraRot = cameraRot + pan * Vector2.new(0.75, 1)
        cameraRot = Vector2.new(math.clamp(cameraRot.X, -math.rad(90), math.rad(90)), cameraRot.Y)
        local cf = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.X, cameraRot.Y, 0) *
            CFrame.new(vel * 64 * dt)
        cameraPos = cf.Position
        Camera.CFrame = cf
        Camera.Focus = cf * CFrame.new(0, 0, -GetFocusDistance(cf))
    end

    PlayerState = {}
    function PlayerState.Push() end

    function PlayerState.Pop() end

    function StartFreecam(pos)
        if fcRunning then StopFreecam() end
        local cf = pos or lastFreecamCF or Camera.CFrame
        cameraRot = Vector2.new()
        cameraPos = cf.Position
        lastFreecamCF = cf
        velSpring:Reset(Vector3.new())
        panSpring:Reset(Vector2.new())
        PlayerState.Push()
        RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
        Input.StartCapture()
        fcRunning = true
    end

    function StopFreecam()
        if not fcRunning then return end
        Input.StopCapture()
        RunService:UnbindFromRenderStep("Freecam")
        PlayerState.Pop()
        fcRunning = false
    end

    function ResetFreecamPosition()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local cf = hrp.CFrame * CFrame.new(0, 2, -8)
        cameraPos = cf.Position
        cameraRot = Vector2.new()
        lastFreecamCF = cf
    end

    Misc:AddToggle({
        Title = "Freecam Mode",
        Default = false,
        Callback = function(state)
            if state then
                StartFreecam()
            else
                StopFreecam()
            end
        end
    })

    Misc:AddButton({
        Title = "Reset Freecam",
        Content = "Reposition camera in front of player",
        Callback = function()
            if fcRunning then
                ResetFreecamPosition()
            end
        end
    })

    local SvX = Tabs.Misc:AddSection("Server Features")
    local reconnecting = false
    local errorConn

    SvX:AddToggle({
        Title = "Auto Reconnect",
        Default = true,
        Callback = function(state)
            reconnecting = state

            if errorConn and errorConn.Connected then
                errorConn:Disconnect()
                errorConn = nil
            end

            if state then
                errorConn = GuiService.ErrorMessageChanged:Connect(function(msg)
                    if not reconnecting or msg == "" then return end
                    task.wait(0.5)
                    local ok = pcall(function()
                        if privateServerId and privateServerId ~= "" then
                            TeleportService:TeleportToPrivateServer(placeId, privateServerId, { LocalPlayer })
                        else
                            TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
                        end
                    end)
                    if not ok then
                        task.wait(2)
                        pcall(function()
                            TeleportService:Teleport(placeId, LocalPlayer)
                        end)
                    end
                end)
            end
        end
    })

    SvX:AddToggle({
        Title = "Auto Execute",
        Default = false,
        Callback = function(state)
            if queue_on_teleport then
                queue_on_teleport(state and [[
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/MajestySkie/Chloe-X/main/Main/ChloeX"))()
                ]] or "")
            end
        end
    })
    --== Anti AFK
    local GC = getconnections or get_signal_cons
    if GC then
        for _, v in pairs(GC(LocalPlayer.Idled)) do
            if v.Disable then
                v:Disable()
            elseif v.Disconnect then
                v:Disconnect()
            end
        end
    end
    local VirtualUser = cloneref and cloneref(game:GetService("VirtualUser")) or game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
