--[[
    ONYX LIB 1.6 (i rewrote the code since it was ass hope you enjoy this new code) 
    dev by: ONYX
    status: working / optimized
]] 

--- Configuration ---
local DiscordInvite = "https://discord.gg/aYxDs6KsWZ" ---you can change this to your own discord server ---

--- Services ---
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--- Constants & Tweens ---
local TWEEN_TOGGLE_OPEN = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local TWEEN_TOGGLE_CLOSE = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
local TWEEN_MINIMIZE = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local TWEEN_CLOSE_X = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

local TWEEN_QUINT = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_CLICK = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_RESET = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local TWEEN_DROPDOWN = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out) 

--- Theme Configuration ---
local Themes = {
    Purple = {Header = Color3.fromRGB(20, 20, 28), Accent1 = Color3.fromRGB(130, 0, 255), Accent2 = Color3.fromRGB(190, 100, 255), SwitchOn = Color3.fromRGB(140, 0, 255), Text = Color3.fromRGB(255, 255, 255)},
    Green = {Header = Color3.fromRGB(20, 28, 20), Accent1 = Color3.fromRGB(0, 255, 110), Accent2 = Color3.fromRGB(120, 255, 160), SwitchOn = Color3.fromRGB(0, 200, 80), Text = Color3.fromRGB(255, 255, 255)},
    Blue = {Header = Color3.fromRGB(20, 24, 30), Accent1 = Color3.fromRGB(0, 160, 255), Accent2 = Color3.fromRGB(80, 220, 255), SwitchOn = Color3.fromRGB(0, 140, 255), Text = Color3.fromRGB(255, 255, 255)},
    Red = {Header = Color3.fromRGB(30, 20, 20), Accent1 = Color3.fromRGB(255, 40, 60), Accent2 = Color3.fromRGB(255, 100, 120), SwitchOn = Color3.fromRGB(220, 0, 60), Text = Color3.fromRGB(255, 255, 255)}
}

local CurrentTheme = {
    Background = Color3.fromRGB(12, 12, 18),
    Header = Themes.Purple.Header,
    Accent1 = Themes.Purple.Accent1,
    Accent2 = Themes.Purple.Accent2,
    Text = Themes.Purple.Text,
    SwitchOff = Color3.fromRGB(50, 50, 55),
    SwitchOn = Themes.Purple.SwitchOn,
    IsGradient = true
}

local Registry = {Gradients = {}, Headers = {}, Accents = {}, AccentFills = {}, Switches = {}, Strokes = {}, Keybinds = {}}
local ElementCount = 0

--- UI Initialization ---
local OnyxLib = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ONYX LIB 1.6" 
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local function attemptParenting(gui)
    local success, err = pcall(function() gui.Parent = CoreGui end)
    if not success then gui.Parent = PlayerGui end
end
attemptParenting(ScreenGui)

local Blur = Instance.new("BlurEffect")
Blur.Name = "OnyxDepthField"
Blur.Size = 0
Blur.Parent = Lighting

--- Utility Functions ---
local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function ApplyGradient(instance)
    local Gradient = Create("UIGradient", {Parent = instance})
    if CurrentTheme.IsGradient then
        Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, CurrentTheme.Accent1), ColorSequenceKeypoint.new(1, CurrentTheme.Accent2)}
    else
        Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, CurrentTheme.Accent1), ColorSequenceKeypoint.new(1, CurrentTheme.Accent1)}
    end
    table.insert(Registry.Gradients, Gradient)
    return Gradient
end

local function UpdateThemeVisuals()
    for _, grad in pairs(Registry.Gradients) do
        local CSeq = CurrentTheme.IsGradient 
            and ColorSequence.new{ColorSequenceKeypoint.new(0, CurrentTheme.Accent1), ColorSequenceKeypoint.new(1, CurrentTheme.Accent2)} 
            or ColorSequence.new{ColorSequenceKeypoint.new(0, CurrentTheme.Accent1), ColorSequenceKeypoint.new(1, CurrentTheme.Accent1)}
        grad.Color = CSeq
    end
    for _, obj in pairs(Registry.Headers) do TweenService:Create(obj, TWEEN_QUINT, {BackgroundColor3 = CurrentTheme.Header}):Play() end
    for _, obj in pairs(Registry.Accents) do TweenService:Create(obj, TWEEN_QUINT, {TextColor3 = CurrentTheme.Accent1}):Play() end
    for _, obj in pairs(Registry.AccentFills) do TweenService:Create(obj, TWEEN_QUINT, {BackgroundColor3 = CurrentTheme.Accent1}):Play() end
    for _, item in pairs(Registry.Switches) do
        local targetColor = item.Active and CurrentTheme.SwitchOn or CurrentTheme.SwitchOff
        TweenService:Create(item.Instance, TWEEN_QUINT, {BackgroundColor3 = targetColor}):Play()
    end
    for _, kb in pairs(Registry.Keybinds) do TweenService:Create(kb.Label, TWEEN_QUINT, {TextColor3 = CurrentTheme.Accent1}):Play() end
end

local function SetTheme(ThemeName)
    local Data = Themes[ThemeName]
    if not Data then return end
    CurrentTheme.Header = Data.Header; CurrentTheme.Accent1 = Data.Accent1; CurrentTheme.Accent2 = Data.Accent2; CurrentTheme.SwitchOn = Data.SwitchOn; CurrentTheme.Text = Data.Text
    UpdateThemeVisuals()
    OnyxLib:Notify("THEME UPDATED", "Active: " .. ThemeName, 2)
end

local function SetGradientMode(bool)
    CurrentTheme.IsGradient = bool; UpdateThemeVisuals()
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function Update(input)
        local delta = input.Position - dragStart
        local ScreenSize = ScreenGui.AbsoluteSize; local FrameSize = frame.AbsoluteSize
        local TargetX = (ScreenSize.X * startPos.X.Scale) + startPos.X.Offset + delta.X
        local TargetY = (ScreenSize.Y * startPos.Y.Scale) + startPos.Y.Offset + delta.Y
        local AnchorX = frame.AnchorPoint.X * FrameSize.X; local AnchorY = frame.AnchorPoint.Y * FrameSize.Y
        local TopLeftX = TargetX - AnchorX; local TopLeftY = TargetY - AnchorY
        local ClampedX = math.clamp(TopLeftX, 0, ScreenSize.X - FrameSize.X); local ClampedY = math.clamp(TopLeftY, 0, ScreenSize.Y - FrameSize.Y)
        TweenService:Create(frame, TweenInfo.new(0.05), {Position = UDim2.fromOffset(ClampedX + AnchorX, ClampedY + AnchorY)}):Play()
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then Update(input) end end)
end

--- Notification System ---
local NotifContainer = Create("Frame", {Size = UDim2.new(0.3, 0, 1, 0), AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(0.98, 0, 0.98, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2000, Parent = ScreenGui})
local NList = Create("UIListLayout", {Parent = NotifContainer, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 10)})
local ActiveNotifications = {}

function OnyxLib:Notify(title, message, duration, tag)
    if tag and ActiveNotifications[tag] then
        local Existing = ActiveNotifications[tag]
        Existing.Expiry = tick() + duration
        if Existing.Frame and Existing.Frame.Parent then
            local Content = Existing.Frame:FindFirstChild("Content")
            if Content then local MsgLabel = Content:FindFirstChild("Message"); if MsgLabel then MsgLabel.Text = message end end
        end
        return
    end
    if tag then ActiveNotifications[tag] = {Frame = nil, Expiry = tick() + duration} end
    task.spawn(function()
        local Frame = Create("Frame", {Name = "Notif", Size = UDim2.new(0, 280, 0, 0), BackgroundColor3 = CurrentTheme.Background, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 2001, Parent = NotifContainer})
        Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = Frame}); local S = Create("UIStroke", {Thickness = 1.5, Parent = Frame}); local SG = ApplyGradient(S); SG.Rotation = 45
        local Content = Create("Frame", {Name = "Content", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = Frame, ZIndex = 2002})
        local Icon = Create("TextLabel", {Text = "â–", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, Parent = Content, ZIndex = 2002}); ApplyGradient(Icon)
        Create("TextLabel", {Text = title, Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1, 1, 1), TextSize = 14, Size = UDim2.new(1, -50, 0, 20), Position = UDim2.new(0, 40, 0, 8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = Content, ZIndex = 2002})
        Create("TextLabel", {Name = "Message", Text = message, Font = Enum.Font.Gotham, TextColor3 = CurrentTheme.Text, TextSize = 12, Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 15, 0, 30), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = Content, ZIndex = 2002})
        if tag and ActiveNotifications[tag] then ActiveNotifications[tag].Frame = Frame end
        local t = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 70)}); t:Play(); t.Completed:Wait(); Content.Visible = true
        if tag then
            while tick() < ActiveNotifications[tag].Expiry do task.wait(0.1); if not ActiveNotifications[tag] or not Frame.Parent then return end end
            ActiveNotifications[tag] = nil
        else task.wait(duration) end
        if Frame.Parent then
            local Clone = Frame:Clone(); Clone.Parent = ScreenGui; Clone.Position = UDim2.fromOffset(Frame.AbsolutePosition.X, Frame.AbsolutePosition.Y); Clone.AnchorPoint = Vector2.new(0, 0); Frame:Destroy()
            TweenService:Create(Clone, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.fromOffset(Clone.AbsolutePosition.X + 300, Clone.AbsolutePosition.Y), BackgroundTransparency = 1}):Play(); task.wait(0.6); Clone:Destroy()
        end
    end)
end

--- Main Window ---
local MainFrame = Create("Frame", {Name = "OnyxMain", BackgroundColor3 = CurrentTheme.Background, BorderSizePixel = 0, Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), Visible = false, ClipsDescendants = true, Active = true, ZIndex = 1, Parent = ScreenGui})
MakeDraggable(MainFrame)
Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = MainFrame}); local MS = Create("UIStroke", {Thickness = 2, Parent = MainFrame}); local BG = ApplyGradient(MS); BG.Rotation = 60
local HeaderFrame = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = CurrentTheme.Header, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = MainFrame}); table.insert(Registry.Headers, HeaderFrame)
local Title = Create("TextLabel", {Text = "ONYX LIB 1.6", Font = Enum.Font.GothamBlack, TextSize = 18, TextColor3 = Color3.new(1, 1, 1), Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.05, 0, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = HeaderFrame}); ApplyGradient(Title)
local Controls = Create("Frame", {Size = UDim2.new(0, 160, 0, 30), Position = UDim2.new(1, -170, 0.5, -15), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = HeaderFrame})

local function CreateBtn(text, order, callback)
    local B = Create("TextButton", {Size = UDim2.new(0, 35, 1, 0), Position = UDim2.new(0, (order - 1) * 40, 0, 0), BackgroundColor3 = CurrentTheme.Header, BackgroundTransparency = 0.5, Text = text, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBlack, TextSize = 13, AutoButtonColor = false, BorderSizePixel = 0, Parent = Controls})
    Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = B}); local S = Create("UIStroke", {Thickness = 1.5, Parent = B}); ApplyGradient(S); ApplyGradient(B); table.insert(Registry.Headers, B); B.MouseButton1Click:Connect(callback)
end

local IsOpen = false; local IsAnimating = false; local ToggleBtn, ToggleIcon

CreateBtn("X", 4, function() 
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
    local t = TweenService:Create(MainFrame, TWEEN_CLOSE_X, {Size = UDim2.new(0, 0, 0, 0)}); t:Play()
    t.Completed:Wait(); ScreenGui:Destroy() 
end)

CreateBtn("-", 3, function() 
    if IsAnimating then return end; IsAnimating = true
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
    local t = TweenService:Create(MainFrame, TWEEN_MINIMIZE, {Size = UDim2.new(0, 0, 0, 0)}); t:Play()
    IsOpen = false
    TweenService:Create(ToggleIcon, TweenInfo.new(0.4), {Rotation = 0}):Play()
    t.Completed:Wait(); MainFrame.Visible = false; IsAnimating = false
    OnyxLib:Notify("SYSTEM", "Minimized to tray.", 2) 
end)

CreateBtn("DC", 2, function() if setclipboard then pcall(setclipboard, DiscordInvite); OnyxLib:Notify("DISCORD", "Invite copied to clipboard!", 2) else OnyxLib:Notify("DISCORD", "Check console for invite.", 2); print("Discord Invite: " .. DiscordInvite) end end)

local Scroll = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -50), Position = UDim2.new(0, 0, 0, 50), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = MainFrame})
Create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = Scroll}); Create("UIListLayout", {Parent = Scroll, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}); Create("UIPadding", {PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), Parent = Scroll})

--- Settings Panel ---
local SettingsFrame = Create("Frame", {Size = UDim2.new(0.9, 0, 0, 0), Position = UDim2.new(0.05, 0, 0.15, 0), BackgroundColor3 = CurrentTheme.Header, BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 10, BorderSizePixel = 0, Parent = MainFrame})
Create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = SettingsFrame}); local SS = Create("UIStroke", {Thickness = 2, Parent = SettingsFrame, Transparency = 1}); ApplyGradient(SS); Registry.Strokes["Settings"] = SS; table.insert(Registry.Headers, SettingsFrame)

local SettingsScroll = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollingDirection = Enum.ScrollingDirection.Y, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0), Parent = SettingsFrame})
local SettingsLayout = Create("UIListLayout", {Parent = SettingsScroll, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
Create("UIPadding", {PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10), Parent = SettingsScroll})

-- Color Picker Variables
local CP_H, CP_S, CP_V = 0.6, 1, 1
local ColorBox, Cursor, BrightnessBar -- Forward declarations

local function UpdatePickerFromTheme(color)
    local h, s, v = color:ToHSV()
    CP_H, CP_S, CP_V = h, s, v
    
    if ColorBox and Cursor and BrightnessBar then
        ColorBox.BackgroundColor3 = Color3.fromHSV(CP_H, 1, 1)
        Cursor.Position = UDim2.new(1 - CP_H, 0, 1 - CP_S, 0)
    end
end

CreateBtn("âš™", 1, function()
    local SettingsOpen = (SettingsFrame.Size.Y.Scale > 0.1)
    local Stroke = Registry.Strokes["Settings"]
    if not SettingsOpen then
        SettingsFrame.BackgroundTransparency = 0.5; SettingsFrame.Visible = true
        TweenService:Create(SettingsFrame, TWEEN_QUINT, {Size = UDim2.new(0.9, 0, 0.65, 0)}):Play()
        if Stroke then TweenService:Create(Stroke, TWEEN_QUINT, {Transparency = 0}):Play() end
    else
        local t = TweenService:Create(SettingsFrame, TWEEN_FAST, {Size = UDim2.new(0.9, 0, 0, 0)}); if Stroke then TweenService:Create(Stroke, TWEEN_FAST, {Transparency = 1}):Play() end
        t:Play(); t.Completed:Wait(); SettingsFrame.BackgroundTransparency = 1; SettingsFrame.Visible = false
    end
end)

-- Layout Order 1: Title
local S_Title = Create("TextLabel", {Text = "THEME SETTINGS", Font = Enum.Font.GothamBold, TextColor3 = CurrentTheme.Text, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = SettingsScroll, LayoutOrder = 1})

-- Layout Order 2: Gradient Toggle
local GradToggle = Create("TextButton", {Size = UDim2.new(0.85, 0, 0, 32), BackgroundColor3 = CurrentTheme.SwitchOn, Text = "Gradient Mode: ON", Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1, 1, 1), AutoButtonColor = false, BorderSizePixel = 0, Parent = SettingsScroll, LayoutOrder = 2})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = GradToggle}); table.insert(Registry.Switches, {Instance = GradToggle, Active = true})
GradToggle.MouseButton1Click:Connect(function() SetGradientMode(not CurrentTheme.IsGradient); local State = CurrentTheme.IsGradient; TweenService:Create(GradToggle, TWEEN_FAST, {BackgroundColor3 = State and CurrentTheme.SwitchOn or CurrentTheme.SwitchOff}):Play(); GradToggle.Text = State and "Gradient Mode: ON" or "Gradient Mode: OFF" end)

-- Layout Order 3: Preset Buttons
local ThemeButtonContainer = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = SettingsScroll, LayoutOrder = 3})
local SGrid = Create("UIGridLayout", {Parent = ThemeButtonContainer, CellSize = UDim2.new(0.2, 0, 0.9, 0), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, CellPadding = UDim2.new(0, 10, 0, 0)})

local function AddThemeBtn(name, a1)
    local B = Create("TextButton", {BackgroundColor3 = a1, Text = "", AutoButtonColor = false, BorderSizePixel = 0, Parent = ThemeButtonContainer})
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = B}); Create("UIStroke", {Thickness = 2, Color = Color3.fromRGB(255, 255, 255), Transparency = 0.5, Parent = B})
    B.MouseButton1Up:Connect(function() 
        SetTheme(name)
        UpdatePickerFromTheme(a1) -- SYNC PICKER
    end)
end
AddThemeBtn("Purple", Themes.Purple.Accent1); AddThemeBtn("Green", Themes.Green.Accent1); AddThemeBtn("Blue", Themes.Blue.Accent1); AddThemeBtn("Red", Themes.Red.Accent1)

-- Layout Order 4: Custom Accent Label
Create("TextLabel", {Text = "CUSTOM ACCENT", Font = Enum.Font.GothamBold, TextColor3 = CurrentTheme.Text, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextTransparency = 0.5, TextSize = 12, Parent = SettingsScroll, LayoutOrder = 4})

-- Layout Order 5: Color Picker Container
local PickerFrame = Create("Frame", {Size = UDim2.new(0.85, 0, 0, 130), BackgroundTransparency = 1, Parent = SettingsScroll, LayoutOrder = 5})

ColorBox = Create("ImageButton", {Size = UDim2.new(1, 0, 0, 100), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromHSV(CP_H, 1, 1), Imag