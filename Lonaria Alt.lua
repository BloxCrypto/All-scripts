--// Lonaria UI Library
--// Loadstring-ready | Executor compatible
--// Returns table correctly

local Lonaria = {}
Lonaria.__index = Lonaria

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Prevent duplicates
if PlayerGui:FindFirstChild("LonariaUI") then
	PlayerGui.LonariaUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LonariaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Utility
local function create(class, props)
	local obj = Instance.new(class)
	for i, v in pairs(props) do
		obj[i] = v
	end
	return obj
end

-- Window
function Lonaria:CreateWindow(title)
	local Window = {}

	local Main = create("Frame", {
		Parent = ScreenGui,
		Size = UDim2.fromScale(0.4, 0.5),
		Position = UDim2.fromScale(0.3, 0.25),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderSizePixel = 0
	})

	create("UICorner", {
		CornerRadius = UDim.new(0, 10),
		Parent = Main
	})

	local Title = create("TextLabel", {
		Parent = Main,
		Size = UDim2.fromScale(1, 0.1),
		BackgroundTransparency = 1,
		Text = title or "Lonaria",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 18
	})

	local TabsFrame = create("Frame", {
		Parent = Main,
		Position = UDim2.fromScale(0, 0.1),
		Size = UDim2.fromScale(0.3, 0.9),
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0
	})

	create("UIListLayout", {
		Parent = TabsFrame,
		Padding = UDim.new(0, 6)
	})

	-- Drag
	do
		local dragging, dragStart, startPos
		Main.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = Main.Position
			end
		end)

		Main.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				Main.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)
	end

	-- Create Tab
	function Window:CreateTab(name)
		local Tab = {}

		local TabButton = create("TextButton", {
			Parent = TabsFrame,
			Size = UDim2.new(1, -10, 0, 35),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			Text = name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			BorderSizePixel = 0
		})

		create("UICorner", {
			Parent = TabButton,
			CornerRadius = UDim.new(0, 6)
		})

		local Content = create("Frame", {
			Parent = Main,
			Position = UDim2.fromScale(0.32, 0.12),
			Size = UDim2.fromScale(0.66, 0.85),
			BackgroundTransparency = 1,
			Visible = false
		})

		create("UIListLayout", {
			Parent = Content,
			Padding = UDim.new(0, 8)
		})

		TabButton.MouseButton1Click:Connect(function()
			for _, v in ipairs(Main:GetChildren()) do
				if v:IsA("Frame") and v ~= TabsFrame then
					v.Visible = false
				end
			end
			Content.Visible = true
		end)

		-- Button
		function Tab:AddButton(text, callback)
			local Btn = create("TextButton", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Text = text,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BorderSizePixel = 0
			})

			create("UICorner", {
				Parent = Btn,
				CornerRadius = UDim.new(0, 6)
			})

			Btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
		end

		-- Toggle
		function Tab:AddToggle(text, callback)
			local state = false

			local Btn = create("TextButton", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Text = text .. " : OFF",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BorderSizePixel = 0
			})

			create("UICorner", {
				Parent = Btn,
				CornerRadius = UDim.new(0, 6)
			})

			Btn.MouseButton1Click:Connect(function()
				state = not state
				Btn.Text = text .. (state and " : ON" or " : OFF")
				if callback then callback(state) end
			end)
		end

		return Tab
	end

	return Window
end

return Lonaria
