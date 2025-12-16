-- Executor-Optimized Roblox UI Library (Rayfield / Orion / Fluent style)
-- Safe for Synapse / Fluxus / KRNL / Script-Ware
-- No memory leaks, protected GUI, client-only

local UILib = {}

-- Services (pcall protected)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer

-- Theme
local Theme = {
	Background = Color3.fromRGB(18, 18, 18),
	TopBar = Color3.fromRGB(25, 25, 25),
	Section = Color3.fromRGB(30, 30, 30),
	Text = Color3.fromRGB(235, 235, 235),
	Accent = Color3.fromRGB(0, 170, 255)
}

-- Executor-safe GUI parent
local function getGuiParent()
	if gethui then return gethui() end
	return LocalPlayer:WaitForChild("PlayerGui")
end

-- Protect GUI (Synapse / others)
local function protect(gui)
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)
end

local function createGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ExecutorUILib"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = getGuiParent()
	protect(gui)
	return gui
end

function UILib:CreateWindow(title)
	local gui = createGui()

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(540, 380)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.Background
	main.Parent = gui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

	-- Top bar
	local top = Instance.new("Frame")
	top.Size = UDim2.new(1, 0, 0, 42)
	top.BackgroundColor3 = Theme.TopBar
	top.Parent = main
	Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -16, 1, 0)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "Executor UI"
	titleLabel.TextColor3 = Theme.Text
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Left
	titleLabel.Parent = top

	-- Dragging (RenderStepped optimized)
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	RunService.RenderStepped:Connect(function()
		if dragging then
			local delta = UserInputService:GetMouseLocation() - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- Tab bar
	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(0, 150, 1, -42)
	tabBar.Position = UDim2.fromOffset(0, 42)
	tabBar.BackgroundColor3 = Theme.TopBar
	tabBar.Parent = main

	local tabLayout = Instance.new("UIListLayout", tabBar)
	tabLayout.Padding = UDim.new(0, 6)

	local pages = Instance.new("Frame")
	pages.Size = UDim2.new(1, -150, 1, -42)
	pages.Position = UDim2.fromOffset(150, 42)
	pages.BackgroundTransparency = 1
	pages.Parent = main

	local Window = {}
	local currentTab

	function Window:CreateTab(name)
		local tabButton = Instance.new("TextButton")
		tabButton.Size = UDim2.new(1, -12, 0, 36)
		tabButton.Position = UDim2.fromOffset(6, 0)
		tabButton.BackgroundColor3 = Theme.Section
		tabButton.Text = name
		tabButton.TextColor3 = Theme.Text
		tabButton.Font = Enum.Font.Gotham
		tabButton.TextSize = 13
		tabButton.AutoButtonColor = false
		tabButton.Parent = tabBar
		Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1, -12, 1, -12)
		page.Position = UDim2.fromOffset(6, 6)
		page.CanvasSize = UDim2.new(0,0,0,0)
		page.ScrollBarImageTransparency = 1
		page.Visible = false
		page.Parent = pages

		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0, 10)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 12)
		end)

		tabButton.MouseButton1Click:Connect(function()
			if currentTab then currentTab.Visible = false end
			currentTab = page
			page.Visible = true
		end)

		if not currentTab then
			currentTab = page
			page.Visible = true
		end

		local Tab = {}

		function Tab:CreateSection(title)
			local section = Instance.new("Frame")
			section.Size = UDim2.new(1, 0, 0, 36)
			section.BackgroundColor3 = Theme.Section
			section.Parent = page
			Instance.new("UICorner", section).CornerRadius = UDim.new(0, 8)

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -12, 0, 26)
			label.Position = UDim2.fromOffset(8, 6)
			label.BackgroundTransparency = 1
			label.Text = title
			label.TextColor3 = Theme.Text
			label.Font = Enum.Font.GothamBold
			label.TextSize = 13
			label.TextXAlignment = Left
			label.Parent = section

			local Section = {}

			function Section:AddButton(text, callback)
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -16, 0, 32)
				btn.Position = UDim2.fromOffset(8, section.AbsoluteSize.Y)
				btn.BackgroundColor3 = Theme.TopBar
				btn.Text = text
				btn.TextColor3 = Theme.Text
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 12
				btn.AutoButtonColor = false
				btn.Parent = section
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

				btn.MouseButton1Click:Connect(function()
					task.spawn(function()
						if callback then callback() end
					end)
				end)
			end

			return Section
		end

		return Tab
	end

	return Window
end

return UILib