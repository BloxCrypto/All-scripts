--// Lonaria UI Library
--// Loadstring-ready | Executor compatible
--// Sliders | Dropdowns | Keybinds

local Lonaria = {}
Lonaria.__index = Lonaria

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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

	create("UICorner", { Parent = Main, CornerRadius = UDim.new(0, 10) })

	create("TextLabel", {
		Parent = Main,
		Size = UDim2.fromScale(1, 0.1),
		BackgroundTransparency = 1,
		Text = title or "Lonaria",
		TextColor3 = Color3.new(1,1,1),
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

	-- Create Tab
	function Window:CreateTab(name)
		local Tab = {}

		local TabButton = create("TextButton", {
			Parent = TabsFrame,
			Size = UDim2.new(1, -10, 0, 35),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40),
			Text = name,
			TextColor3 = Color3.new(1,1,1),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			BorderSizePixel = 0
		})

		create("UICorner", { Parent = TabButton, CornerRadius = UDim.new(0, 6) })

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

		-- BUTTON
		function Tab:AddButton(text, callback)
			local Btn = create("TextButton", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Text = text,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BorderSizePixel = 0
			})

			create("UICorner", { Parent = Btn, CornerRadius = UDim.new(0, 6) })

			Btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
		end

		-- TOGGLE
		function Tab:AddToggle(text, callback)
			local state = false

			local Btn = create("TextButton", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Text = text .. " : OFF",
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BorderSizePixel = 0
			})

			create("UICorner", { Parent = Btn, CornerRadius = UDim.new(0, 6) })

			Btn.MouseButton1Click:Connect(function()
				state = not state
				Btn.Text = text .. (state and " : ON" or " : OFF")
				if callback then callback(state) end
			end)
		end

		-- SLIDER
		function Tab:AddSlider(text, min, max, default, callback)
			local value = default or min

			local Holder = create("Frame", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 50),
				BackgroundTransparency = 1
			})

			local Label = create("TextLabel", {
				Parent = Holder,
				Size = UDim2.new(1, 0, 0.4, 0),
				BackgroundTransparency = 1,
				Text = text .. ": " .. value,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextXAlignment = Left
			})

			local Bar = create("Frame", {
				Parent = Holder,
				Position = UDim2.new(0, 0, 0.6, 0),
				Size = UDim2.new(1, 0, 0.25, 0),
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BorderSizePixel = 0
			})

			create("UICorner", { Parent = Bar, CornerRadius = UDim.new(1, 0) })

			local Fill = create("Frame", {
				Parent = Bar,
				Size = UDim2.new((value-min)/(max-min), 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(90, 90, 255),
				BorderSizePixel = 0
			})

			create("UICorner", { Parent = Fill, CornerRadius = UDim.new(1, 0) })

			local dragging = false

			Bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)

			Bar.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)

			UserInputService.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					local pct = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
					value = math.floor(min + (max - min) * pct)
					Fill.Size = UDim2.new(pct, 0, 1, 0)
					Label.Text = text .. ": " .. value
					if callback then callback(value) end
				end
			end)
		end

		-- DROPDOWN
		function Tab:AddDropdown(text, options, callback)
			local Btn = create("TextButton", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Text = text,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BorderSizePixel = 0
			})

			create("UICorner", { Parent = Btn, CornerRadius = UDim.new(0, 6) })

			Btn.MouseButton1Click:Connect(function()
				for _, option in ipairs(options) do
					local Opt = create("TextButton", {
						Parent = Content,
						Size = UDim2.new(1, -20, 0, 30),
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						Text = option,
						TextColor3 = Color3.new(1,1,1),
						Font = Enum.Font.Gotham,
						TextSize = 13,
						BorderSizePixel = 0
					})

					create("UICorner", { Parent = Opt, CornerRadius = UDim.new(0, 6) })

					Opt.MouseButton1Click:Connect(function()
						Btn.Text = text .. ": " .. option
						if callback then callback(option) end
						Opt:Destroy()
					end)
				end
			end)
		end

		-- KEYBIND
		function Tab:AddKeybind(text, defaultKey, callback)
			local key = defaultKey or Enum.KeyCode.RightShift

			local Btn = create("TextButton", {
				Parent = Content,
				Size = UDim2.new(1, -10, 0, 35),
				BackgroundColor3 = Color3.fromRGB(45, 45, 45),
				Text = text .. ": " .. key.Name,
				TextColor3 = Color3.new(1,1,1),
				Font = Enum.Font.Gotham,
				TextSize = 14,
				BorderSizePixel = 0
			})

			create("UICorner", { Parent = Btn, CornerRadius = UDim.new(0, 6) })

			UserInputService.InputBegan:Connect(function(i, g)
				if not g and i.KeyCode == key then
					if callback then callback() end
				end
			end)
		end

		return Tab
	end

	return Window
end

return Lonaria