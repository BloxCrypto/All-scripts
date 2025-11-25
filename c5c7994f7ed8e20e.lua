-- ts file was generated at discord.gg/25ms


local vu1 = cloneref(game:GetService("Players"))
local vu2 = vu1.LocalPlayer
local vu3 = cloneref(game:GetService("ReplicatedStorage"))
local vu4 = cloneref(game:GetService("RunService"))
loadstring(game:HttpGet("https://raw.githubusercontent.com/noob-scripts/some-scripts/refs/heads/master/Wild%20Hub/Module.lua"))()
local vu5 = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local v6 = vu5:CreateWindow({
    Title = "Wild Hub Cracked",
    Icon = "door-open",
    Author = "Made by Wild Wide",
    Folder = "Wild-Hub",
    Theme = "Midnight",
    Transparent = true
})
local v7 = {}
local v8 = {}
function UpdatePlayerList()
    local v9 = vu1
    local v10, v11, v12 = pairs(v9:GetPlayers())
    local v13 = {}
    while true do
        local v14
        v12, v14 = v10(v11, v12)
        if v12 == nil then
            break
        end
        if v14 ~= vu2 then
            table.insert(v13, v14.Name)
        end
    end
    return v13
end
local vu15 = loadstring("\nlocal Players = cloneref(game:GetService(\"Players\"))\nlocal RunService = cloneref(game:GetService(\"RunService\"))\nlocal LocalPlayer = Players.LocalPlayer\nlocal Camera = workspace.CurrentCamera\n\n-- \226\156\133 Global toggle + feature-specific toggles\nlocal esp_enabled = false\n\nlocal ESP_settings = {\n    Tracers = false,\n    Box = false,\n    Name = true,\n    Highlight = false,\n    Toggle = function(value)\n        esp_enabled = value\n    end\n}\n\nlocal ESPObjects = {}\n\nlocal function createESP(player)\n    if player == LocalPlayer or ESPObjects[player] then return end\n\n    local box = Drawing.new(\"Square\")\n    box.Thickness = 1\n    box.Transparency = 1\n    box.Color = Color3.fromRGB(255, 0, 0)\n    box.Filled = false\n\n    local tracer = Drawing.new(\"Line\")\n    tracer.Thickness = 1\n    tracer.Transparency = 1\n    tracer.Color = Color3.fromRGB(255, 0, 0)\n\n    local nameTag = Drawing.new(\"Text\")\n    nameTag.Size = 13\n    nameTag.Center = true\n    nameTag.Outline = true\n    nameTag.Color = Color3.new(1, 1, 1)\n    nameTag.Visible = false\n\n    local highlight = Instance.new(\"Highlight\")\n    highlight.FillTransparency = 0.75\n    highlight.OutlineTransparency = 0\n    highlight.FillColor = Color3.fromRGB(255, 0, 0)\n    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)\n    highlight.Enabled = false\n    highlight.Parent = player.Character or nil\n\n    ESPObjects[player] = {\n        Box = box,\n        Tracer = tracer,\n        Name = nameTag,\n        Highlight = highlight\n    }\nend\n\n-- \226\157\140 Remove ESP visuals when a player leaves\nlocal function removeESP(player)\n    local esp = ESPObjects[player]\n    if esp then\n        for _, obj in pairs(esp) do\n            if typeof(obj) == \"Instance\" then\n                obj:Destroy()\n            else\n                obj:Remove()\n            end\n        end\n        ESPObjects[player] = nil\n    end\nend\n\n-- \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Add ESP to all players\nfor _, player in pairs(Players:GetPlayers()) do\n    createESP(player)\nend\n\nPlayers.PlayerAdded:Connect(createESP)\nPlayers.PlayerRemoving:Connect(removeESP)\n\n-- \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Update ESP every frame\nRunService.RenderStepped:Connect(function()\n    for player, esp in pairs(ESPObjects) do\n        local char = player.Character\n        if char and char:FindFirstChild(\"HumanoidRootPart\") and char:FindFirstChild(\"Head\") then\n            local hrp = char.HumanoidRootPart\n            local head = char.Head\n            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)\n            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))\n\n            if onscreen and esp_enabled then\n                local dist = (hrp.Position - Camera.CFrame.Position).Magnitude\n                local scale = 1 / dist * 100\n                local width = 30 * scale\n                local height = 60 * scale\n\n                -- \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Box\n                esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)\n                esp.Box.Size = Vector2.new(width, height)\n                esp.Box.Visible = ESP_settings.Box\n\n                -- \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Tracer\n                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)\n                esp.Tracer.To = Vector2.new(pos.X, pos.Y + height / 2)\n                esp.Tracer.Visible = ESP_settings.Tracers\n\n                -- \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Name Tag\n                local name = player.Name\n                if player.DisplayName ~= name then\n                    name = name .. \" (\" .. player.DisplayName .. \")\"\n                end\n                esp.Name.Text = name\n                esp.Name.Position = Vector2.new(headPos.X, headPos.Y - 15)\n                esp.Name.Visible = ESP_settings.Name\n\n                -- \239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Highlight\n                if ESP_settings.Highlight then\n                    esp.Highlight.Adornee = char\n                    esp.Highlight.Enabled = true\n                else\n                    esp.Highlight.Enabled = false\n                end\n            else\n                esp.Box.Visible = false\n                esp.Tracer.Visible = false\n                esp.Name.Visible = false\n                if esp.Highlight then\n                    esp.Highlight.Enabled = false\n                end\n            end\n        end\n    end\nend)\n\nreturn ESP_settings\n")()
v7.Main = v6:Tab({
    Title = "Main"
})
v8.Visual = v7.Main:Section({
    Title = "Visual (Esp)"
})
v8.Visual:Toggle({
    Title = "Toggle esp",
    Desc = "Enable/Disable esp",
    Default = false,
    Callback = function(p16)
        vu15.Toggle(p16)
    end
})
v8.Visual:Dropdown({
    Title = "Esp options",
    Values = {
        "Names",
        "Box",
        "Highlight",
        "Tracers"
    },
    Value = {
        "Names"
    },
    Multi = true,
    AllowNone = false,
    Callback = function(p17)
        if type(p17) == "table" then
            local v18, v19, v20 = ipairs({
                "Names",
                "Box",
                "Highlight",
                "Tracers"
            })
            while true do
                local v21
                v20, v21 = v18(v19, v20)
                if v20 == nil then
                    break
                end
                vu15[v21] = false
            end
            local v22, v23, v24 = ipairs(p17)
            while true do
                local v25
                v24, v25 = v22(v23, v24)
                if v24 == nil then
                    break
                end
                vu15[v25] = true
            end
        end
    end
})
v8.Admin = v7.Main:Section({
    Title = "HD Admin"
})
local vu26 = vu3:FindFirstChild("HDAdminClient") and true or false
local vu27 = ""
local vu28 = ";"
v8.Admin:Paragraph({
    Title = "HD Admin detected:",
    Desc = tostring(vu26)
})
v8.Admin:Input({
    Title = "Input Prefix",
    Desc = "Input your prefix to change HD Admin prefix",
    Value = ";",
    Callback = function(p29)
        vu28 = p29
        if vu26 then
            vu3.HDAdminClient.Signals.ChangeSetting:InvokeServer({
                "Prefix",
                vu28
            })
        end
    end
})
v8.Admin:Input({
    Title = "Input command",
    Value = "",
    Callback = function(p30)
        vu27 = p30
    end
})
v8.Admin:Button({
    Title = "send for all",
    Callback = function()
        if vu26 then
            if vu27 ~= "" then
                local v31 = vu3.HDAdminClient.Signals.RequestCommand
                local v32 = vu1
                local v33, v34, v35 = pairs(v32:GetPlayers())
                while true do
                    local v36
                    v35, v36 = v33(v34, v35)
                    if v35 == nil then
                        break
                    end
                    v31:InvokeServer(string.format("%s%s %s", vu28, vu27, v36.Name))
                end
            end
        else
            vu5:Notify({
                Title = "HD Admin was not detected on this game.",
                Content = "You need to be in a game that has HD admin like the game FREE ADMIN.",
                Time = 5
            })
            return
        end
    end
})
v8.Admin:Button({
    Title = "send for others",
    Callback = function()
        if vu26 then
            if vu27 ~= "" then
                local v37 = vu3.HDAdminClient.Signals.RequestCommand
                local v38 = vu1
                local v39, v40, v41 = pairs(v38:GetPlayers())
                while true do
                    local v42
                    v41, v42 = v39(v40, v41)
                    if v41 == nil then
                        break
                    end
                    if v42 ~= vu2 then
                        v37:InvokeServer(string.format("%s%s %s", vu28, vu27, v42.Name))
                    end
                end
            end
        else
            vu5:Notify({
                Title = "HD Admin was not detected on this game.",
                Content = "You need to be in a game that has HD admin like the game FREE ADMIN.",
                Time = 5
            })
            return
        end
    end
})
local vu43 = ""
v8.SilentCMD = v7.Main:Section({
    Title = "HD Admin Silent Commands"
})
v8.SilentCMD:Input({
    Title = "Input command here",
    Value = "",
    Callback = function(p44)
        vu43 = p44
    end
})
v8.SilentCMD:Button({
    Title = "Send command",
    Callback = function()
        if vu43 ~= "" then
            vu3.HDAdminClient.Signals.RequestCommand:InvokeServer(vu43)
        end
    end
})
v7.LocalPlayer = v6:Tab({
    Title = "LocalPlayer"
})
v8.FlyPlr = v7.LocalPlayer:Section({
    Title = "Fly"
})
v8.FlyPlr:Button({
    Title = "Load Fly Gui",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CaseohCASEOH/Gui/refs/heads/main/Fly"))()
    end
})
v8.WalkSpeed = v7.LocalPlayer:Section({
    Title = "Player Walkspeed"
})
local vu45 = 16
local vu46 = 50
local vu47 = 2
v8.WalkSpeed:Input({
    Title = "Input WalkSpeed",
    Value = "16",
    Callback = function(p48)
        vu45 = tonumber(p48)
    end
})
v8.WalkSpeed:Button({
    Title = "Set WalkSpeed",
    Callback = function()
        vu2.Character.Humanoid.WalkSpeed = vu45
    end
})
v8.JumpPower = v7.LocalPlayer:Section({
    Title = "Player JumpPower"
})
v8.JumpPower:Input({
    Title = "Input JumpPower",
    Value = "50",
    Callback = function(p49)
        vu46 = tostring(p49)
    end
})
v8.JumpPower:Button({
    Title = "Set JumpPower",
    Callback = function()
        vu2.Character.Humanoid.JumpPower = vu46
    end
})
v8.HipHeight = v7.LocalPlayer:Section({
    Title = "Player HipHeight"
})
v8.HipHeight:Input({
    Title = "Input HipHeight",
    Value = "2",
    Callback = function(p50)
        vu47 = tostring(p50)
    end
})
v8.HipHeight:Button({
    Title = "Set HipHeight",
    Callback = function()
        vu2.Character.Humanoid.HipHeight = vu47
    end
})
v8.Health = v7.LocalPlayer:Section({
    Title = "Player Health"
})
v8.Health:Button({
    Title = "Reset Player",
    Callback = function()
        local v51 = vu2.Character
        local v52 = v51.Humanoid
        v52.BreakJointsOnDeath = true
        v51:BreakJoints()
        v52.Health = 0
    end
})
local vu53 = false
v8.AntiFling = v7.LocalPlayer:Section({
    Title = "AntiFling"
})
local vu55 = v8.AntiFling:Toggle({
    Title = "Toggle AntiFling",
    Default = false,
    Callback = function(p54)
        vu53 = p54
    end
})
task.spawn(function()
    local v56 = vu1
    local v57, v58, v59 = pairs(v56:GetPlayers())
    if v64 ~= vu2 and v64.Character then
        local v60, v61, v62 = pairs(v64.Character:GetDescendants())
        while true do
            local v63
            v62, v63 = v60(v61, v62)
            if v62 == nil then
                break
            end
            if v63:IsA("BasePart") then
                v63.CanCollide = false
            end
        end
    end
    local v64
    v59, v64 = v57(v58, v59)
    if v59 ~= nil then
    else
    end
    task.wait(0.2)
	
end)
v8.OtherC = v7.LocalPlayer:Section({
    Title = "Other character scripts"
})
local vu65 = false
v8.OtherC:Toggle({
    Title = "Noclip",
    Callback = function(p66)
        vu65 = p66
    end
})
task.spawn(function()
    while true do
        if vu65 == true then
            local v67 = vu2.Character
            local v68, v69, v70 = pairs(v67:GetChildren())
            while true do
                local v71
                v70, v71 = v68(v69, v70)
                if v70 == nil then
                    break
                end
                if v71:IsA("BasePart") and v71.CanCollide ~= false then
                    v71.CanCollide = false
                end
            end
        end
        task.wait(0.3)
    end
end)
local vu72 = false
v8.OtherC:Toggle({
    Title = "Infinite Jump",
    Callback = function(p73)
        vu72 = p73
    end
})
game:GetService("UserInputService").JumpRequest:connect(function()
    if vu72 == true then
        vu2.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
local vu74 = false
vu4.Heartbeat:Connect(function()
    if vu2.Character and (vu2.Character.HumanoidRootPart and vu74 == true) then
        pcall(function()
            vu2.Character.HumanoidRootPart.CFrame = vu2.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(3), 0)
        end)
    end
end)
v8.OtherC:Button({
    Title = "Spin",
    Desc = "Makes your character spin",
    Callback = function()
        vu74 = true
    end
})
v8.OtherC:Button({
    Title = "Stop spin",
    Desc = "Stops your character from spinning",
    Callback = function()
        vu74 = false
    end
})
v8.OtherC:Button({
    Title = "Freeze Character",
    Callback = function()
        if vu2.Character then
            local v75, v76, v77 = pairs(vu2.Character:GetDescendants())
            while true do
                local v78
                v77, v78 = v75(v76, v77)
                if v77 == nil then
                    break
                end
                if v78:IsA("BasePart") then
                    v78.Anchored = true
                end
            end
        end
    end
})
v8.OtherC:Button({
    Title = "Unfreeze Character",
    Callback = function()
        if vu2.Character then
            local v79, v80, v81 = pairs(vu2.Character:GetDescendants())
            while true do
                local v82
                v81, v82 = v79(v80, v81)
                if v81 == nil then
                    break
                end
                if v82:IsA("BasePart") then
                    v82.Anchored = false
                end
            end
        end
    end
})
v8.OtherC:Button({
    Title = "Permanent death",
    Callback = function()
        if replicatesignal then
            vu5:Notify({
                Title = "Wait a little bit",
                Content = "Wait: " .. vu1.RespawnTime .. " so Permanent death works",
                Duration = 5
            })
            replicatesignal(vu2.ConnectDiedSignalBackend)
            task.wait(vu1.RespawnTime + 0.2)
            replicatesignal(vu2.Kill)
            vu2.Character:FindFirstChildOfClass("Humanoid").Health = 0
        else
            vu5:Notify({
                Title = "Your executor doesn\'t support ReplicateSignal",
                Content = "Your executor don\'t support ReplicateSignal, use a Executor like Delta or Arceus X, that support ReplicateSignal",
                Duration = 5
            })
        end
    end
})
v7.Funny = v6:Tab({
    Title = "Funny"
})
v7.Funny:Button({
    Title = "FE Roblox_Egor",
    Callback = function()
        local v83 = vu2.Character
        local vu84 = v83.Humanoid
        local v85 = v83.HumanoidRootPart
        local v86 = v83:FindFirstChild("Torso") or v83:FindFirstChild("UpperTorso")
        local vu87 = true
        vu84.WalkSpeed = 2
        v85.CustomPhysicalProperties = PhysicalProperties.new(1, 0.3, 0.5)
        local vu93 = vu4.Stepped:Connect(function()
            local v88 = vu84
            local v89, v90, v91 = pairs(v88:GetPlayingAnimationTracks())
            while true do
                local v92
                v91, v92 = v89(v90, v91)
                if v91 == nil then
                    break
                end
                v92:AdjustSpeed(5)
            end
        end)
        vu84.Died:Connect(function()
            vu93:Disconnect()
            vu87 = false
        end)
        while true do
            v86.Anchored = not v86.Anchored
            if vu87 == false then
                break
            end
            task.wait(0.4)
        end
        v86.Anchored = false
    end
})
v7.Funny:Button({
    Title = "Fling yourself",
    Callback = function()
        local v94 = vu2.Character.HumanoidRootPart
        local v95 = Instance.new("BodyAngularVelocity")
        v95.Parent = v94
        v95.AngularVelocity = Vector3.new(99999, 99999, 99999)
        v95.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        v95.P = 99999
    end
})
local vu96 = false
v8.Troll = v7.Funny:Section({
    Title = "Trolls"
})
v8.Troll:Toggle({
    Title = "WalkFling",
    Default = false,
    Callback = function(p97)
        vu96 = p97
        if p97 == true then
            vu55:Set(true)
        else
            vu55:Set(false)
        end
    end
})
task.spawn(function()
    while vu4.Heartbeat:Wait() do
        if vu96 == true then
            local v98 = vu2.Character
            local v99 = v98.HumanoidRootPart
            local v100 = 0.1
            while not (v98 and (v98.Parent and (v99 and v99.Parent))) do
                vu4.Heartbeat:Wait()
                v98 = vu2.Character
                v99 = v98.HumanoidRootPart
            end
            local v101 = v99.Velocity
            v99.Velocity = v101 * 10000 + Vector3.new(0, 10000, 0)
            vu4.RenderStepped:Wait()
            if v98 and (v98.Parent and (v99 and v99.Parent)) then
                v99.Velocity = v101
            end
            vu4.Stepped:Wait()
            if v98 and (v98.Parent and (v99 and v99.Parent)) then
                v99.Velocity = v101 + Vector3.new(0, v100, 0)
                local _ = v100 * - 1
            end
        end
    end
end)
v8.Troll:Button({
    Title = "Expand Hitboxes",
    Callback = function()
        local v102 = vu1
        local v103, v104, v105 = pairs(v102:GetPlayers())
        while true do
            local v106
            v105, v106 = v103(v104, v105)
            if v105 == nil then
                break
            end
            if v106 ~= vu2 and v106.Character then
                local v107 = v106.Character.HumanoidRootPart
                v107.Transparency = 0.5
                v107.Size = Vector3.new(50, 50, 50)
            end
        end
    end
})
v8.Troll:Button({
    Title = "Tool Reach",
    Callback = function()
        local v108 = vu2.Character
        if v108:FindFirstChildOfClass("Tool") then
            local v109 = v108:FindFirstChildOfClass("Tool")
            if v109:FindFirstChild("Handle") then
                local v110 = v109:FindFirstChild("Handle")
                v110.Size = Vector3.new(v110.Size.X + 10, v110.Size.Y + 10, v110.Size.Z + 10)
            else
                OrionLib:MakeNotification({
                    Name = "Tool Handle not found.",
                    Content = "Your tool needs a Handle to enable reach.",
                    Duration = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Tool not found.",
                Content = "You need to hold a tool to enable Reach.",
                Duration = 5
            })
        end
    end
})
local vu111 = 0.1
local vu112 = 80
local function vu120(p113)
    local v114 = vu96
    vu96 = true
    local v115 = (vu2.Character or vu2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    local v116 = p113.Character or p113.CharacterAdded:Wait()
    local v117 = v116:WaitForChild("HumanoidRootPart")
    set_noclip(v116)
    local v118 = Instance.new("BodyAngularVelocity")
    v118.MaxTorque = Vector3.new(100000, 100000, 100000)
    v118.P = 100000
    v118.AngularVelocity = Vector3.new(9000000000, 9000000000, 9000000000)
    v118.Parent = v115
    local v119 = Instance.new("BodyPosition")
    v119.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
    v119.Position = v117.Position
    v119.P = 1000000000
    v119.D = 100000
    v119.Parent = v115
    while v116.Parent and (v117.Parent and vu112 >= v117.Velocity.Magnitude) do
        if not (v115 and v115.Parent) then
            v115 = (vu2.Character or vu2.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
            v118.Parent = v115
            v119.Parent = v115
        end
        v119.Position = v117.Position + Vector3.new(math.random(- 3, 3), 0, math.random(- 3, 3))
        task.wait(0.05)
    end
    v118:Destroy()
    v119:Destroy()
    if v114 == false then
        vu96 = false
    end
end
local vu121 = false
local vu122 = {}
local function vu126(p123)
    table.insert(vu122, p123)
    if not vu121 then
        vu121 = true
        local v124 = vu2.Character or vu2.CharacterAdded:Wait()
        local vu125 = v124:WaitForChild("HumanoidRootPart")
        v124:FindFirstChildOfClass("Humanoid").Died:Connect(function()
            vu121 = false
        end)
        while # vu122 > 0 do
            vu120((table.remove(vu122, 1)))
        end
        if vu125 then
            vu125.Anchored = true
            vu125.Velocity = Vector3.zero
            vu125.RotVelocity = Vector3.zero
            task.delay(vu111, function()
                if vu125 and vu125.Parent then
                    vu125.Anchored = false
                    vu125.CFrame = CFrame.new(vu125.Position)
                end
            end)
        end
        vu121 = false
    end
end
local vu127 = nil
v8.FlingAny = v7.Funny:Section({
    Title = "Fling Anyone"
})
local vu129 = v8.FlingAny:Dropdown({
    Title = "Select Player",
    Value = "none",
    Values = UpdatePlayerList(),
    Callback = function(p128)
        if vu1:FindFirstChild(p128) then
            vu127 = vu1:FindFirstChild(p128)
        end
    end
})
v8.FlingAny:Button({
    Title = "Fling Player",
    Callback = function()
        if vu127 then
            vu126(vu127)
        end
    end
})
vu1.PlayerAdded:Connect(function()
    vu129:Refresh(UpdatePlayerList())
end)
vu1.PlayerRemoving:Connect(function()
    vu129:Refresh(UpdatePlayerList())
end)
v8.Troll:Paragraph({
    Title = "Lack of ideas",
    Desc = "Idk what do i add here, but in future updates i will add more things here.\n\nbut you can suggest me what i should add here on my discord server"
})
function UpdatePlayerList()
    local v130 = vu1
    local v131, v132, v133 = pairs(v130:GetPlayers())
    local v134 = {}
    while true do
        local v135
        v133, v135 = v131(v132, v133)
        if v133 == nil then
            break
        end
        if v135 ~= vu2 then
            table.insert(v134, v135.Name)
        end
    end
    return v134
end
v7.Teleport = v6:Tab({
    Title = "Teleports"
})
local vu136 = nil
v8.TeleportTo = v7.Teleport:Section({
    Title = "Teleport to anyone"
})
local vu138 = v8.TeleportTo:Dropdown({
    Title = "Select Player",
    Value = "none",
    Values = UpdatePlayerList(),
    Callback = function(p137)
        if vu1:FindFirstChild(p137) then
            vu136 = vu1:FindFirstChild(p137)
        end
    end
})
v8.TeleportTo:Button({
    Title = "Teleport to player",
    Callback = function()
        if vu136 then
            vu2.Character.HumanoidRootPart.CFrame = vu136.Character.HumanoidRootPart.CFrame
        end
    end
})
vu1.PlayerAdded:Connect(function()
    vu138:Refresh(UpdatePlayerList())
end)
vu1.PlayerRemoving:Connect(function()
    vu138:Refresh(UpdatePlayerList())
end)
local vu139 = nil
v7.VPlr = v6:Tab({
    Title = "View Player"
})
v7.VPlr:Dropdown({
    Title = "Select player",
    Value = "none",
    Values = UpdatePlayerList(),
    Callback = function(p140)
        if vu1:FindFirstChild(p140) then
            vu139 = vu1:FindFirstChild(p140)
        end
    end
})
local vu142 = v7.VPlr:Toggle({
    Title = "View player",
    Callback = function(p141)
        if p141 == true and vu139 then
            workspace.CurrentCamera.CameraSubject = vu139.Character
        else
            workspace.CurrentCamera.CameraSubject = vu2.Character
        end
    end
})
vu1.PlayerRemoving:Connect(function(p143)
    if p143 == vu139 then
        vu142:Set(false)
    end
end)
local vu144 = false
local vu145 = false
v7.Others = v6:Tab({
    Title = "Others"
})
v7.Others:Toggle({
    Title = "Notify Player joins",
    Callback = function(p146)
        vu144 = p146
    end
})
v7.Others:Toggle({
    Title = "Notify Player left",
    Callback = function(p147)
        vu145 = p147
    end
})
function format_name(p148)
    if p148.Name ~= p148.DisplayName then
        return p148.DisplayName .. " (" .. p148.Name .. ")"
    else
        return p148.Name
    end
end
vu1.PlayerAdded:Connect(function(p149)
    if vu144 == true then
        vu5:Notify({
            Title = "Player joined!",
            Content = "Player name: " .. format_name(p149),
            Duration = 3
        })
    end
end)
vu1.PlayerRemoving:Connect(function(p150)
    if vu145 == true then
        vu5:Notify({
            Title = "Player left!",
            Content = "Player name: " .. format_name(p150),
            Duration = 3
        })
    end
end)
v7.OScripts = v6:Tab({
    Title = "Other scripts"
})
local v151, v152, v153 = pairs({
    {
        Name = "Infinite Yield",
        Url = "https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"
    },
    {
        Name = "Dark dex (IY Ver.)",
        Url = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"
    },
    {
        Name = "Aimbot script (prob made with AI)",
        Url = "https://pastebin.com/raw/pLxzQHke"
    },
    {
        Name = "Backdoor scanner script",
        Url = "https://raw.githubusercontent.com/its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script"
    },
    {
        Name = "Remote Spy (IY Ver.)",
        Url = "https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"
    },
    {
        Name = "Turtle Spy",
        Url = "https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua"
    },
    {
        Name = "Hydroxide",
        Url = "https://rscripts.net/raw/hydroxide-universal_1720078098815_aLqFNPdZ9j.txt"
    },
    {
        Name = "GoldenZ Executor (Made By me)",
        Url = "https://gist.githubusercontent.com/noob-scripts/47fee17724862c73ca42b0eaaaa76d56/raw/124140ba4f4dd8cc548e69dcd9e2276cf4c90b92/GoldenZ.lua"
    }
})
local vu154 = vu2
while true do
    local vu155
    v153, vu155 = v151(v152, v153)
    if v153 == nil then
        break
    end
    v7.OScripts:Button({
        Title = vu155.Name,
        Callback = function()
            loadstring(game:HttpGet(vu155.Url))()
        end
    })
end
v8.Honorable = v7.OScripts:Section({
    Title = "Partner scripts"
})
v8.Honorable:Paragraph({
    Title = "Honorable Mentions:",
    Desc = "Aabaaii"
})
v8.Honorable:Button({
    Title = "Abaui Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CaseohCASEOH/aabbaaii/refs/heads/main/executer.lua"))()
    end
})
local vu156 = ""
v7.Executor = v6:Tab({
    Title = "Executor"
})
v8.nexec = v7.Executor:Section({
    Title = "Normal executor"
})
v8.nexec:Input({
    Title = "Input code",
    Type = "Textarea",
    Callback = function(p157)
        vu156 = p157
    end
})
v8.nexec:Button({
    Title = "Execute code",
    Callback = function()
        loadstring(vu156)()
    end
})
v8.nexec:Button({
    Title = "Copy code",
    Callback = function()
        setclipboard(vu156)
    end
})
local vu158 = {
    "UpdatePlayerBlockList",
    "NewPlayerGroupDetails",
    "NewPlayerCanManageDetails",
    "SendPlayerBlockList",
    "UpdateLocalPlayerBlockList",
    "SendPlayerProfileSettings",
    "UpdatePlayerProfileSettings",
    "ShowPlayerJoinedFriendsToast",
    "ShowFriendJoinedPlayerToast",
    "CreateOrJoinParty",
    "LeaderstatsOrder",
    "DeathType",
    "ServerSideBulkPurchaseEvent",
    "SetDialogInUse",
    "GetServerVersion",
    "GetServerChannel",
    "ExperienceChat",
    "ContactListInvokeIrisInvite",
    "ContactListIrisInviteTeleport",
    "UpdateCurrentCall",
    "RequestDeviceCameraOrientationCapability",
    "ReferredPlayerJoin",
    "GetServerType",
    "CanChatWith",
    "SetPlayerBlockList",
    "IntegrityCheckProcessorKey2_LocalizationTableAnalyticsSender_LocalizationService",
    "IntegrityCheckProcessorKey2_DynamicTranslationSender_LocalizationService"
}
function fire_remote(pu159, ...)
    if pu159 then
        if table.find(vu158, pu159.Name) then
            return
        elseif pu159.Parent.Name ~= "DefaultChatSystemChatEvents" then
            if pu159.Name == "__FUNCTION" or pu159:FindFirstChild("__FUNCTION") then
                return
            elseif not (vu3:FindFirstChild("HDAdminClient") and pu159:IsDescendantOf(vu3:FindFirstChild("HDAdminClient"))) then
                local vu160 = {
                    ...
                }
                if pu159:IsA("RemoteEvent") or pu159:IsA("UnreliableRemoteEvent") then
                    pu159:FireServer(table.unpack(vu160))
                elseif pu159:IsA("RemoteFunction") or pu159:IsA("UnreliableRemoteFunction") then
                    task.spawn(function()
                        replicatesignal(pu159.OnServerInvoke, vu154, table.unpack(vu160))
                        pu159:InvokeServer(table.unpack(vu160))
                    end)
                end
            end
        else
            return
        end
    else
        return
    end
end
local vu161 = "\nlocal a = Instance.new(\"Folder\", game:GetService(\"ReplicatedStorage\"))\na.Name = \"WH_BACKDOOR\"\n"
local vu162 = false
local vu163 = nil
local vu164 = false
local vu165 = false
local vu166 = 0
local vu167 = 0
function scan_backdoor()
    local v168 = tick()
    vu166 = 0
    local v169, v170, v171 = pairs(game:GetDescendants())
    while true do
        local v172
        v171, v172 = v169(v170, v171)
        if v171 == nil then
            break
        end
        if table.find({
            "RemoteEvent",
            "RemoteFunction",
            "UnreliableRemoteEvent",
            "UnreliableRemoteFunction"
        }, v172.ClassName) then
            vu166 = vu166 + 1
            fire_remote(v172, vu161)
            task.wait(0.2)
            if vu3:FindFirstChild("WH_BACKDOOR") then
                vu163 = v172
                vu165 = true
                break
            end
            task.wait(0.25 + math.random() * 0.02)
        end
    end
    vu167 = tick() - v168
    vu162 = true
    vu164 = true
end
v8.Backdoor = v8.Backdoor or v7.Executor:Section({
    Title = "Backdoor executor"
})
local vu173 = backdoor_found_txt or v8.Backdoor:Paragraph({
    Title = "Backdoor found:",
    Desc = "false"
})
v8.Backdoor:Button({
    Title = "Scan for backdoor",
    Callback = function()
        vu5:Notify({
            Title = "Scanning for backdoor...",
            Content = "You\'ll be notified when Wild Hub finishes scanning."
        })
        task.spawn(scan_backdoor)
        repeat
            task.wait(0.05)
        until vu162 == true
        task.wait(0.05)
        local v174 = ("Checked %d remotes in %.2f seconds."):format(vu166, vu167)
        if vu165 and vu163 then
            local v175 = vu5
            local v176 = v175.Notify
            local v177 = {
                Title = "Backdoor found!",
                Content = v174 .. "\nRemote: " .. vu163:GetFullName()
            }
            v176(v175, v177)
            vu173:SetDesc("true :: " .. vu163:GetFullName())
        else
            vu5:Notify({
                Title = "Backdoor not found",
                Content = v174 .. "\nThis game might not have any backdoor."
            })
        end
        vu162 = false
    end
})
local vu178 = ""
v8.Backdoor:Input({
    Title = "Input code",
    Type = "Textarea",
    Callback = function(p179)
        vu178 = p179
    end
})
v8.Backdoor:Button({
    Title = "Execute code",
    Callback = function()
        if vu163 then
            fire_remote(vu163, vu178)
        end
    end
})
v8.Backdoor:Button({
    Title = "Copy code",
    Callback = function()
        setclipboard(vu178)
    end
})
v8.Backdoor:Button({
    Title = "Copy remote path",
    Callback = function()
        if vu163 then
            local v180 = vu163
            setclipboard(v180:GetFullName())
        else
            vu5:Notify({
                Title = "No backdoor remote",
                Content = "You can\'t copy the path of a remote that doesn\'t exist."
            })
        end
    end
})
v7.Misc = v6:Tab({
    Title = "Miscellaneous"
})
v7.Misc:Button({
    Title = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, vu154)
    end
})
v7.Misc:Button({
    Title = "Server Hop",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))():Teleport(game.PlaceId)
    end
})
v7.Misc:Button({
    Title = "Leave game",
    Callback = function()
        game:Shutdown()
    end
})
local vu181 = false
local vu182 = game:GetService("VirtualUser")
vu154.Idled:connect(function()
    if vu181 == true then
        vu182:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(0.1)
        vu182:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)
v7.Misc:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(p183)
        vu181 = p183
    end
})
v7.Misc:Button({
    Title = "Copy Server/Job ID",
    Callback = function()
        if setclipboard then
            setclipboard(game.JobId)
        end
    end
})
v7.Misc:Button({
    Title = "Copy game ID",
    Callback = function()
        if setclipboard then
            setclipboard(game.PlaceId)
        end
    end
})
v8.Join = v7.Misc:Section({
    Title = "Join server"
})
local vu184 = ""
v8.Join:Input({
    Title = "Input Server/Job ID",
    Value = "none",
    Callback = function(p185)
        vu184 = p185
    end
})
v8.Join:Button({
    Title = "Join Server",
    Callback = function()
        if vu184 ~= "" and vu184 ~= "none" then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, vu184, vu154)
        end
    end
})
v8.GFPS = v7.Misc:Section({
    Title = "Change FPS"
})
local vu186 = 60
v8.GFPS:Input({
    Title = "Input FPS",
    Value = "60",
    TextDisappear = true,
    Callback = function(p187)
        vu186 = tostring(p187)
    end
})
v8.GFPS:Button({
    Title = "Change FPS",
    Callback = function()
        if setfpscap then
            setfpscap(vu186)
        end
    end
})
v7.Credits = v6:Tab({
    Title = "Credits"
})
v8.Discord = v7.Credits:Section({
    Title = "Join Discord (.gg/mhzDcapGgA)"
})
v8.Discord:Button({
    Title = "Copy discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/mhzDcapGgA")
        end
    end
})
v8.Creator = v7.Credits:Section({
    Title = "Creators of the script"
})
v8.Creator:Paragraph({
    Title = "Creators",
    Desc = "Wild -> Wide",
    Image = getcustomasset("WildHub/assets/WW-Logo.png")
})