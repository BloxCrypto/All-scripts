-- Create Tab (100% Fixed – No More Errors)
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
    tab.Button.BorderSizePixel = 0
    tab.Button.Parent = self.TabContainer

    local btnCorner = Instance.new("UICorner", tab.Button)
    btnCorner.CornerRadius = UDim.new(0, 8)

    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Size = UDim2.new(1, -20, 1, -20)
    tab.Content.Position = UDim2.new(0, 10, 0, 10)
    tab.Content.BackgroundTransparency = 1
    tab.Content.ScrollBarThickness = 4
    tab.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.Content.Visible = false
    tab.Content.BorderSizePixel = 0
    tab.Content.Parent = self.ContentArea

    local layout = Instance.new("UIListLayout", tab.Content)
    layout.Padding = UDim.new(0, 8)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Wait one frame so the button exists in the game
    RunService.Heartbeat:Wait()

    -- Click handler
    tab.Button.MouseButton1Click:Connect(function()
        if self.CurrentTab and self.CurrentTab ~= tab then
            self.CurrentTab.Content.Visible = false
            TweenService:Create(self.CurrentTab.Button, TWEEN_INFO, {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                TextColor3 = Color3.fromRGB(180, 180, 200)
            }):Play()
        end

        self.CurrentTab = tab
        tab.Content.Visible = true
        TweenService:Create(tab.Button, TWEEN_INFO, {
            BackgroundColor3 = Color3.fromRGB(70, 70, 255),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    -- Auto-select first tab properly
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        -- Just trigger the same code as a click
        self.CurrentTab = tab
        tab.Content.Visible = true
        tab.Button.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
        tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return tab
end
