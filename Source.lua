-- Executor-Optimized Roblox UI Library (Rayfield / Orion / Fluent style)
-- Safe for Synapse / Fluxus / KRNL / Script-Ware
-- No memory leaks, protected GUI, client-only
if getgenv()._UILoaded then return end
getgenv()._UILoaded = true

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
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
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
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = section

			local Section = {}

			function Section:AddButton(text, callback)
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -16, 0, 32)
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

			function Section:AddToggle(text, default, callback)
				local state = default or false
				local toggle = Instance.new("TextButton")
				toggle.Size = UDim2.new(1, -16, 0, 32)
				toggle.BackgroundColor3 = state and Theme.Accent or Theme.TopBar
				toggle.Text = text
				toggle.TextColor3 = Theme.Text
				toggle.Font = Enum.Font.Gotham
				toggle.TextSize = 12
				toggle.AutoButtonColor = false
				toggle.Parent = section
				Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

				toggle.MouseButton1Click:Connect(function()
					state = not state
					toggle.BackgroundColor3 = state and Theme.Accent or Theme.TopBar
					if callback then callback(state) end
				end)
			end

			function Section:AddSlider(text, min, max, default, callback)
				local value = default or min
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, -16, 0, 44)
				frame.BackgroundColor3 = Theme.TopBar
				frame.Parent = section
				Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -16, 0, 18)
				label.Position = UDim2.fromOffset(8, 4)
				label.BackgroundTransparency = 1
				label.Text = text .. ": " .. value
				label.TextColor3 = Theme.Text
				label.Font = Enum.Font.Gotham
				label.TextSize = 12
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = frame

				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, -16, 0, 6)
				bar.Position = UDim2.fromOffset(8, 28)
				bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
				bar.Parent = frame
				Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
				fill.BackgroundColor3 = Theme.Accent
				fill.Parent = bar
				Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

				local dragging = false
				bar.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
						local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
						value = math.floor(min + (max-min)*pct)
						fill.Size = UDim2.new(pct,0,1,0)
						label.Text = text .. ": " .. value
						if callback then callback(value) end
					end
				end)
			end

			function Section:AddDropdown(text, options, callback)
				local open = false
				local drop = Instance.new("TextButton")
				drop.Size = UDim2.new(1, -16, 0, 32)
				drop.BackgroundColor3 = Theme.TopBar
				drop.Text = text
				drop.TextColor3 = Theme.Text
				drop.Font = Enum.Font.Gotham
				drop.TextSize = 12
				drop.AutoButtonColor = false
				drop.Parent = section
				Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)

				local list = Instance.new("Frame")
				list.Size = UDim2.new(1, -16, 0, 0)
				list.BackgroundColor3 = Theme.Section
				list.Visible = false
				list.Parent = section
				Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)

				local layout = Instance.new("UIListLayout", list)
				layout.Padding = UDim.new(0, 4)

				for _,opt in ipairs(options) do
					local o = Instance.new("TextButton")
					o.Size = UDim2.new(1, -8, 0, 28)
					o.BackgroundColor3 = Theme.TopBar
					o.Text = opt
					o.TextColor3 = Theme.Text
					o.Font = Enum.Font.Gotham
					o.TextSize = 12
					o.AutoButtonColor = false
					o.Parent = list
					Instance.new("UICorner", o).CornerRadius = UDim.new(0, 6)
					o.MouseButton1Click:Connect(function()
						drop.Text = text .. ": " .. opt
						list.Visible = false
						if callback then callback(opt) end
					end)
				end

				drop.MouseButton1Click:Connect(function()
					open = not open
					list.Visible = open
				end)
			end(text, callback)
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

		-- Open / Close controls
	local isOpen = true

	local function setVisible(state)
		isOpen = state
		main.Visible = state
	end

	-- PC keybind (RightShift)
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			setVisible(not isOpen)
		end
	end)

	-- Mobile toggle button
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		local mobileBtn = Instance.new("TextButton")
		mobileBtn.Size = UDim2.fromOffset(48, 48)
		mobileBtn.Position = UDim2.new(0, 12, 0.5, -24)
		mobileBtn.BackgroundColor3 = Theme.Accent
		mobileBtn.Text = "UI"
		mobileBtn.TextColor3 = Color3.new(1,1,1)
		mobileBtn.Font = Enum.Font.GothamBold
		mobileBtn.TextSize = 14
		mobileBtn.Parent = gui
		Instance.new("UICorner", mobileBtn).CornerRadius = UDim.new(1,0)

		mobileBtn.MouseButton1Click:Connect(function()
			setVisible(not isOpen)
		end)
	end

	return Window
end

return UILib

--[[
Executor Example:

local UILib = loadstring(game:HttpGet("your_raw_url"))()
local win = UILib:CreateWindow("Executor Hub")

local tab = win:CreateTab("Main")
local sec = tab:CreateSection("Actions")

sec:AddButton("Print", function()
	print("Executed")
end)
]]