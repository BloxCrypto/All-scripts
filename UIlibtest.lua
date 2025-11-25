-- Single loadstring-ready UI library
local UILibrary = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function UILibrary:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = title
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = frame

    local window = {}

    function window:Button(text, callback)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(1, -20, 0, 50)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Parent = frame

        button.MouseButton1Click:Connect(callback)
    end

    function window:Toggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -20, 0, 50)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleFrame.Parent = frame

        local label = Instance.new("TextLabel")
        label.Text = text
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Parent = toggleFrame

        local toggleButton = Instance.new("TextButton")
        toggleButton.Text = default and "ON" or "OFF"
        toggleButton.Size = UDim2.new(0.3, -10, 1, 0)
        toggleButton.Position = UDim2.new(0.7, 10, 0, 0)
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.Parent = toggleFrame

        local toggled = default
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggleButton.Text = toggled and "ON" or "OFF"
            toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            callback(toggled)
        end)
    end

    function window:Slider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -20, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderFrame.Parent = frame

        local label = Instance.new("TextLabel")
        label.Text = text .. ": " .. default
        label.Size = UDim2.new(1, 0, 0.4, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Parent = sliderFrame

        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -20, 0, 10)
        sliderBar.Position = UDim2.new(0, 10, 0.6, 0)
        sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        sliderBar.Parent = sliderFrame

        local sliderHandle = Instance.new("Frame")
        sliderHandle.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        sliderHandle.Parent = sliderBar

        local dragging = false
        sliderHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        sliderHandle.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouseX = input.Position.X - sliderBar.AbsolutePosition.X
                local percent = math.clamp(mouseX / sliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor((min + (max - min) * percent) * 100) / 100
                sliderHandle.Size = UDim2.new(percent, 0, 1, 0)
                label.Text = text .. ": " .. value
                callback(value)
            end
        end)
    end

    return window
end

return UILibrary
]])()