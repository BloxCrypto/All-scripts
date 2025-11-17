-- AetherUI.lua
local AetherUI = {}
AetherUI.__index = AetherUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Tween Info
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- Create Main UI
function AetherUI.new(config)
    config = config or {}
    local self = setmetatable({}, AetherUI)
    
    self.Name = config.Name or "AetherUI"
    self.Keybind = config.Keybind or Enum.KeyCode.RightControl
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AetherUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui

    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 600, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Visible = false
    self.MainFrame.Parent = self.ScreenGui

    local Corner = Instance.new("UICorner", self.MainFrame)
    Corner.CornerRadius = UDim.new(0, 12)

    local Stroke = Instance.new("UIStroke", self.MainFrame)
    Stroke.Color = Color3.fromRGB(60, 60, 80)
    Stroke.Thickness = 1.5

    -- Title Bar
    self.Title = Instance.new("TextLabel")
    self.Title.Size = UDim2.new(1, 0, 0, 50)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = self.Name
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextSize = 18
    self.Title.Parent = self.MainFrame

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 24
    CloseBtn.Parent = self.MainFrame

    CloseBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(0, 140, 1, -50)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 50)
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    self.TabContainer.Parent = self.MainFrame

    local TabCorner = Instance.new("UICorner", self.TabContainer)
    TabCorner.CornerRadius = UDim.new(0, 12)

    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -140, 1, -50)
    self.ContentArea.Position = UDim2.new(0, 140, 0, 50)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.MainFrame

    self.Tabs = {}
    self.CurrentTab = nil

    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil

    self.Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)

    self.Title.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Toggle with keybind
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.Keybind then
            self:Toggle()
        end
    end)

    return self
end

-- Create Tab
function AetherUI:Tab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Button = Instance.new("TextButton")
    tab.Button.Size = UDim2.new(1, -10, 0, 45)
    tab.Button.Position = UDim2.new(0, 5, 0, #self.Tabs * 50 + 10)
    tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tab.Button.Text = "  " .. (icon or "■") .. "  " .. name
    tab.Button.TextColor3 = Color3.fromRGB(180, 180, 200)
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.TextXAlignment = Enum.TextXAlignment.Left
    tab.Button.Parent = self.TabContainer

    local btnCorner = Instance.new("UICorner", tab.Button)
    btnCorner.CornerRadius = UDim.new(0, 8)

    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1, -20, 1, -20)
    tab.Content.Position = UDim2.new(0, 10, 0, 10)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 4
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentArea

    local layout = Instance.new("UIListLayout", tab.Content)
    layout.Padding = UDim.new(0, 8)
    layout.FillDirection = Enum.FillDirection.Vertical

    tab.Button.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Content.Visible = false
            TweenService:Create(self.CurrentTab.Button, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            TweenService:Create(self.CurrentTab.Button.TextColor3, TWEEN_INFO, {Value = Color3.fromRGB(180, 180, 200)}):Play()
        end
        self.CurrentTab = tab
        tab.Content.Visible = true
        TweenService:Create(tab.Button, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(70, 70, 255)}):Play()
    end)

    if #self.Tabs == 0 then
        tab.Button:MouseButton1Click()
    end

    table.insert(self.Tabs, tab)
    return tab
end

-- Elements
function AetherUI:Button(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = tab.Content

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(callback)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
    end)

    return btn
end

function AetherUI:Toggle(tab, text, default, callback)
    local toggle = {Value = default or false}
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.Parent = tab.Content

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 15, 0, 0)

    local switch = Instance.new("Frame", frame)
    switch.Size = UDim2.new(0, 50, 0, 25)
    switch.Position = UDim2.new(1, -65, 0.5, -12.5)
    switch.BackgroundColor3 = toggle.Value and Color3.fromRGB(70, 70, 255) or Color3.fromRGB(70, 70, 70)

    local switchCorner = Instance.new("UICorner", switch)
    switchCorner.CornerRadius = UDim.new(0, 12)

    local circle = Instance.new("Frame", switch)
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = toggle.Value and UDim2.new(1, -25, 0.5, -10) or UDim2.new(0, 5, 0.5, -10)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local circleCorner = Instance.new("UICorner", circle)
    circleCorner.CornerRadius = UDim.new(1, 0)

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle.Value = not toggle.Value
            callback(toggle.Value)
            TweenService:Create(switch, TWEEN_INFO, {BackgroundColor3 = toggle.Value and Color3.fromRGB(70, 70, 255) or Color3.fromRGB(70, 70, 70)}):Play()
            TweenService:Create(circle, TWEEN_INFO, {Position = toggle.Value and UDim2.new(1, -25, 0.5, -10) or UDim2.new(0, 5, 0.5, -10)}):Play()
        end
    end)

    return toggle
end

-- Add more elements (Slider, Dropdown, Keybind, etc.) if you want — let me know!

function AetherUI:Notify(title, text, duration)
    duration = duration or 5
    local notify = Instance.new("Frame")
    notify.Size = UDim2.new(0, 300, 0, 80)
    notify.Position = UDim2.new(1, -320, 1, -100)
    notify.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    notify.Parent = self.ScreenGui

    local corner = Instance.new("UICorner", notify)
    corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", notify)
    stroke.Color = Color3.fromRGB(70, 70, 255)

    local t = Instance.new("TextLabel", notify)
    t.Text = title
    t.Position = UDim2.new(0, 15, 0, 10)
    t.Size = UDim2.new(1, -30, 0, 25)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(70, 70, 255)
    t.Font = Enum.Font.GothamBold

    local d = Instance.new("TextLabel", notify)
    d.Text = text
    d.Position = UDim2.new(0, 15, 0, 35)
    d.Size = UDim2.new(1, -30, 0, 30)
    d.BackgroundTransparency = 1
    d.TextColor3 = Color3.fromRGB(200, 200, 200)
    d.Font = Enum.Font.Gotham
    d.TextWrapped = true

    TweenService:Create(notify, TweenInfo.new(0.4), {Position = UDim2.new(1, -320, 1, -100)}):Play()
    task.wait(0.4)
    task.delay(duration, function()
        TweenService:Create(notify, TweenInfo.new(0.5), {Position = UDim2.new(1, 10, 1, -100)}):Play()
        task.wait(0.6)
        notify:Destroy()
    end)
end

function AetherUI:Toggle()
    self.MainFrame.Visible = not self.MainFrame.Visible
    if self.MainFrame.Visible then
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 600, 0, 450)}):Play()
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    end
end

return AetherUI
