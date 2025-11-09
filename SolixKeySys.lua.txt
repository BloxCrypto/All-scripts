repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create a notification function that we can use throughout the script
local function createNotification(title, content, duration, color, parent)
    duration = duration or 5
    color = color or Color3.fromRGB(255, 188, 254)
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.AnchorPoint = Vector2.new(1, 1)
    Notification.BackgroundTransparency = 0.06
    Notification.AutomaticSize = Enum.AutomaticSize.XY
    Notification.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(1, -25, 1, -25)
    Notification.Size = UDim2.fromOffset(232, 59)
    Notification.Parent = parent
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Name = "_CHILD"
    NotifStroke.Color = Color3.fromRGB(158, 114, 158)
    NotifStroke.Transparency = 0.9
    NotifStroke.Parent = Notification
    
    local NotifAcrylic1 = Instance.new("ImageLabel")
    NotifAcrylic1.Name = "acrylicthing"
    NotifAcrylic1.Image = "rbxassetid://9968344105"
    NotifAcrylic1.ImageTransparency = 0.98
    NotifAcrylic1.ScaleType = Enum.ScaleType.Tile
    NotifAcrylic1.TileSize = UDim2.fromOffset(128, 128)
    NotifAcrylic1.BackgroundTransparency = 1
    NotifAcrylic1.Size = UDim2.fromScale(1, 1)
    
    local NotifAcrylicCorner1 = Instance.new("UICorner")
    NotifAcrylicCorner1.CornerRadius = UDim.new(0, 12)
    NotifAcrylicCorner1.Parent = NotifAcrylic1
    
    NotifAcrylic1.Parent = Notification
    
    local NotifAcrylic2 = Instance.new("ImageLabel")
    NotifAcrylic2.Name = "acrylicthing"
    NotifAcrylic2.Image = "rbxassetid://9968344227"
    NotifAcrylic2.ImageTransparency = 0.9
    NotifAcrylic2.ScaleType = Enum.ScaleType.Tile
    NotifAcrylic2.TileSize = UDim2.fromOffset(128, 128)
    NotifAcrylic2.BackgroundTransparency = 1
    NotifAcrylic2.Size = UDim2.fromScale(1, 1)
    
    local NotifAcrylicCorner2 = Instance.new("UICorner")
    NotifAcrylicCorner2.CornerRadius = UDim.new(0, 12)
    NotifAcrylicCorner2.Parent = NotifAcrylic2
    
    NotifAcrylic2.Parent = Notification
    
    local TextHolder = Instance.new("Frame")
    TextHolder.Name = "TextHolder"
    TextHolder.AutomaticSize = Enum.AutomaticSize.XY
    TextHolder.BackgroundTransparency = 1
    TextHolder.Position = UDim2.new(0, 7, 0.12, 0)
    TextHolder.Size = UDim2.fromOffset(20, 12)
    
    local TextLayout = Instance.new("UIListLayout")
    TextLayout.Padding = UDim.new(0, -4)
    TextLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextLayout.Parent = TextHolder
    
    local TitleText = Instance.new("TextLabel")
    TitleText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    TitleText.Text = title
    TitleText.TextColor3 = Color3.fromRGB(199, 199, 203)
    TitleText.TextSize = 14
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.AutomaticSize = Enum.AutomaticSize.X
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.fromOffset(10, 8)
    TitleText.Size = UDim2.fromOffset(212, 20)
    TitleText.Parent = TextHolder
    
    local ContentText = Instance.new("TextLabel")
    ContentText.Name = "TextLabel"
    ContentText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ContentText.Text = content
    ContentText.TextColor3 = Color3.fromRGB(127, 127, 130)
    ContentText.TextSize = 12
    ContentText.TextXAlignment = Enum.TextXAlignment.Left
    ContentText.AutomaticSize = Enum.AutomaticSize.X
    ContentText.BackgroundTransparency = 1
    ContentText.Position = UDim2.fromOffset(10, 8)
    ContentText.Size = UDim2.fromOffset(212, 20)
    ContentText.Parent = TextHolder
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingBottom = UDim.new(0, 25)
    TextPadding.Parent = TextHolder
    
    TextHolder.Parent = Notification
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.BackgroundColor3 = Color3.fromRGB(44, 38, 44)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.fromScale(0.0282, 0.8)
    ProgressBar.Size = UDim2.new(1, -20, 0, 7)
    
    local ProgressLayout = Instance.new("UIListLayout")
    ProgressLayout.Name = "UIListLayout"
    ProgressLayout.Wraps = true
    ProgressLayout.FillDirection = Enum.FillDirection.Horizontal
    ProgressLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ProgressLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    ProgressLayout.Parent = ProgressBar
    
    local ProgressFill = Instance.new("Frame")
    ProgressFill.BackgroundColor3 = color
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Size = UDim2.fromScale(1, 1)
    
    local ProgressFillCorner = Instance.new("UICorner")
    ProgressFillCorner.Parent = ProgressFill
    
    local ProgressGradient = Instance.new("UIGradient")
    ProgressGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.752, Color3.fromRGB(147, 147, 147)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(127, 127, 127))
    }
    ProgressGradient.Parent = ProgressFill
    
    ProgressFill.Parent = ProgressBar
    
    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.Parent = ProgressBar
    
    ProgressBar.Parent = Notification
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 4)
    NotifCorner.Parent = Notification
    
    local NotifPadding = Instance.new("UIPadding")
    NotifPadding.PaddingBottom = UDim.new(0, 12)
    NotifPadding.Parent = Notification
    
    local DismissButton = Instance.new("TextButton")
    DismissButton.Name = "DismissButton"
    DismissButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DismissButton.BackgroundTransparency = 1
    DismissButton.Size = UDim2.fromScale(1, 1)
    DismissButton.Text = ""
    DismissButton.Parent = Notification
    
    TweenService:Create(ProgressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    
    task.delay(duration, function()
        TweenService:Create(Notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 25, 1, -25)}):Play()
        task.wait(0.5)
        Notification:Destroy()
    end)
    
    DismissButton.MouseButton1Click:Connect(function()
        TweenService:Create(Notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 25, 1, -25)}):Play()
        task.wait(0.5)
        Notification:Destroy()
    end)
    
    DismissButton.MouseEnter:Connect(function()
        TweenService:Create(DismissButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.65}):Play()
    end)
    
    DismissButton.MouseLeave:Connect(function()
        TweenService:Create(DismissButton, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
    end)
    
    return Notification
end

-- Get the script loader URL for the current game
local function getScriptLoaderUrl()
    local creatorId = game.CreatorId
    
    local scriptMap = {
        [4372130] = "https://api.luarmor.net/files/v3/loaders/e2718ddebf562c5c4080dfce26b09398.lua", 
        [11867394] = "https://api.luarmor.net/files/v3/loaders/98f5c64a0a9ecca29517078597bbcbdb.lua", 
        [4294803] = "https://api.luarmor.net/files/v3/loaders/9b64d07193c7c2aef970d57aeb286e70.lua", 
        [1226491] = "https://api.luarmor.net/files/v3/loaders/fefdf5088c44beb34ef52ed6b520507c.lua", 
        [2613928] = "https://api.luarmor.net/files/v3/loaders/0e0166cb8f3c5c189c6a1f2532db2125.lua", 
        [3229308] = "https://api.luarmor.net/files/v3/loaders/4b2841eb3e1345dd1aa50da164ca2bbe.lua", 
        [7381705] = "https://api.luarmor.net/files/v3/loaders/8bbc8a7c4e023bc0c80799fec3233162.lua", 
        [15557357] = "https://api.luarmor.net/files/v3/loaders/4fe2dfc202115670b1813277df916ab2.lua", 
        [1848960] = "https://api.luarmor.net/files/v3/loaders/9c916252a9f79bbf5a108f97c531e807.lua", 
        [3959677] = "https://api.luarmor.net/files/v3/loaders/e95ef6f27596e636a7d706375c040de4.lua", 
        [3461453] = "https://api.luarmor.net/files/v3/loaders/3bb7969a9ecb9e317b0a24681327c2e2.lua", 
        [17219742] = "https://api.luarmor.net/files/v3/loaders/25116432b45b1a5ea7811c264a731941.lua", 
        [3059674] = "https://api.luarmor.net/files/v3/loaders/21ad7f491e4658e9dc9529a60c887c6e.lua", 
        [34644452] = "https://api.luarmor.net/files/v3/loaders/0c8fdf9bb25a6a7071731b72a90e3c69.lua", 
        [3333298] = "https://api.luarmor.net/files/v3/loaders/e1d276b47f79a40a336a530f3bd6268c.lua", 
    }
    
    return scriptMap[creatorId]
end

local function isGameSupported()
    return getScriptLoaderUrl() ~= nil
end

local function initLuarmorAPI()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    end)
    
    if not success then
        return nil
    end
    
    local scriptUrl = getScriptLoaderUrl()
    if not scriptUrl then
        return nil
    end
    
    local scriptId = scriptUrl:match("loaders/([^.]+)%.lua")
    if not scriptId then
        return nil
    end
    
    result.script_id = scriptId
    
    return result
end

-- Execute the script with the provided key
local function executeScript(key)
    local scriptUrl = getScriptLoaderUrl()
    
    if not scriptUrl then
        return false, "Game not supported"
    end
    
    -- Set the key before executing the script
    getgenv().script_key = key
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if not success then
        return false, "Failed to execute script: " .. tostring(result)
    end
    
    return true
end

-- Check if the key exists and is valid
local function validateKey(key)
    if not key or key == "" then
        return false, "KEY_NOT_FOUND"
    end
    
    if not isGameSupported() then
        return false, "GAME_NOT_SUPPORTED"
    end
    
    local api = initLuarmorAPI()
    if not api then
        return false, "API_INIT_FAILED"
    end
    
    local success, status = pcall(function()
        return api.check_key(key)
    end)
    
    if not success then
        return false, "API_CALL_FAILED"
    end
    
    if status.code == "KEY_VALID" then
        return true, status
    else
        return false, status.code
    end
end

-- Main function to check if there's a valid key and show UI if needed
local function main()
    -- Create a ScreenGui for notifications
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotificationGui"
    notifGui.ResetOnSpawn = false
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Try to read the key from file
    local keySuccess, keyContent = pcall(function()
        return readfile("Key.txt")
    end)
    
    -- If we couldn't read the key file, show the key system UI
    if not keySuccess or not keyContent or keyContent == "" then
        -- Delete the key file if it exists but is empty
        if keySuccess then
            pcall(function() delfile("Key.txt") end)
        end
        
        createNotification("Key System", "No valid key found. Please enter your key.", 5, Color3.fromRGB(255, 85, 85), notifGui)
        return false
    end
    
    -- Initialize Luarmor API
    local api = initLuarmorAPI()
    if not api then
        createNotification("API Error", "Failed to initialize Luarmor API", 5, Color3.fromRGB(255, 85, 85), notifGui)
        return false
    end
    
    -- Validate the key with Luarmor
    local success, status = pcall(function()
        return api.check_key(keyContent)
    end)
    
    -- If the API call failed, show the key system UI
    if not success then
        createNotification("API Error", "Failed to check key with Luarmor", 5, Color3.fromRGB(255, 85, 85), notifGui)
        pcall(function() delfile("Key.txt") end)
        return false
    end
    
    -- If the key is not valid, delete it and show the key system UI
    if status.code ~= "KEY_VALID" then
        pcall(function() delfile("Key.txt") end)
        
        local statusMessage = "Invalid key"
        if status.code == "KEY_EXPIRED" then
            statusMessage = "Key expired"
        elseif status.code == "KEY_HWID_LOCKED" then
            statusMessage = "Key HWID locked"
        elseif status.code == "KEY_BANNED" then
            statusMessage = "Key banned"
        elseif status.code == "KEY_INCORRECT" or status.code == "KEY_INVALID" then
            statusMessage = "Invalid key - key does not exist"
        end
        
        createNotification("Key Error", statusMessage, 5, Color3.fromRGB(255, 85, 85), notifGui)
        return false
    end
    
    -- Key is valid, set up queue_on_teleport
    local saveSuccess, saveError = pcall(function()
        writefile("Key.txt", keyContent)
    end)
    
    if not saveSuccess then
        createNotification("Warning", "Failed to save key: " .. tostring(saveError), 5, Color3.fromRGB(255, 170, 0), notifGui)
    else
        -- Verify the key was saved correctly
        local readSuccess, savedKey = pcall(function()
            return readfile("Key.txt")
        end)
        
        if not readSuccess or savedKey ~= keyContent then
            createNotification("Warning", "Key verification failed. Teleport may not work correctly.", 5, Color3.fromRGB(255, 170, 0), notifGui)
        else
            -- Only set up queue_on_teleport if the key was saved successfully
            queue_on_teleport([[
                loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/keysystest/refs/heads/main/keyssys.lua"))()
            ]])
            
            createNotification("Info", "Key saved successfully. Ready for teleport.", 3, Color3.fromRGB(85, 255, 127), notifGui)
        end
    end
    
    -- Try to execute the script with the valid key
    local execSuccess, execError = executeScript(keyContent)
    
    -- If execution failed, show an error notification and show the key system UI
    if not execSuccess then
        createNotification("Script Error", execError, 5, Color3.fromRGB(255, 85, 85), notifGui)
        return false
    end
    
    -- If we got here, the script executed successfully
    task.delay(1, function()
        notifGui:Destroy()
    end)
    
    return true
end

-- Run the main function and show the key system UI if needed
if main() then
    return
end

-- If we get here, we need to show the key system UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolixHubLogin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
MainFrame.BackgroundTransparency = 0.06
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.Size = UDim2.fromOffset(400, 370)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local AcrylicEffect1 = Instance.new("ImageLabel")
AcrylicEffect1.Name = "acrylicthing"
AcrylicEffect1.Image = "rbxassetid://9968344105"
AcrylicEffect1.ImageTransparency = 0.98
AcrylicEffect1.ScaleType = Enum.ScaleType.Tile
AcrylicEffect1.TileSize = UDim2.fromOffset(128, 128)
AcrylicEffect1.BackgroundTransparency = 1
AcrylicEffect1.Size = UDim2.fromScale(1, 1)
AcrylicEffect1.ZIndex = 0
AcrylicEffect1.Parent = MainFrame

local AcrylicCorner1 = Instance.new("UICorner")
AcrylicCorner1.CornerRadius = UDim.new(0, 12)
AcrylicCorner1.Parent = AcrylicEffect1

local AcrylicEffect2 = Instance.new("ImageLabel")
AcrylicEffect2.Name = "acrylicthing"
AcrylicEffect2.Image = "rbxassetid://9968344227"
AcrylicEffect2.ImageTransparency = 0.9
AcrylicEffect2.ScaleType = Enum.ScaleType.Tile
AcrylicEffect2.TileSize = UDim2.fromOffset(128, 128)
AcrylicEffect2.BackgroundTransparency = 1
AcrylicEffect2.Size = UDim2.fromScale(1, 1)
AcrylicEffect2.ZIndex = 0
AcrylicEffect2.Parent = MainFrame

local AcrylicCorner2 = Instance.new("UICorner")
AcrylicCorner2.CornerRadius = UDim.new(0, 12)
AcrylicCorner2.Parent = AcrylicEffect2

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "_CHILD"
UIStroke.Color = Color3.fromRGB(158, 114, 158)
UIStroke.Transparency = 0.9
UIStroke.Parent = MainFrame

local SideIndicator = Instance.new("Frame")
SideIndicator.Name = "sideindicator"
SideIndicator.AnchorPoint = Vector2.new(0.5, 0)
SideIndicator.BackgroundColor3 = Color3.fromRGB(255, 188, 254)
SideIndicator.BorderSizePixel = 0
SideIndicator.Position = UDim2.fromScale(0.5, 0)
SideIndicator.Size = UDim2.new(1, -50, 0, 2)
SideIndicator.Parent = MainFrame

local SideIndicatorCorner = Instance.new("UICorner")
SideIndicatorCorner.CornerRadius = UDim.new(0, 634)
SideIndicatorCorner.Parent = SideIndicator

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "title"
TitleLabel.FontFace = Font.new("rbxassetid://12187361378", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TitleLabel.Text = "SolixHub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 19
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.fromOffset(37, 15)
TitleLabel.Size = UDim2.new(0, 88, 0, 30)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "Frame"
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Position = UDim2.new(1, -75, 0, 15)
ControlsFrame.Size = UDim2.new(0, 60, 0, 30)
ControlsFrame.Parent = MainFrame

local ControlsLayout = Instance.new("UIListLayout")
ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ControlsLayout.Padding = UDim.new(0, 6)
ControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ControlsLayout.Parent = ControlsFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Text = ""
CloseButton.BackgroundColor3 = Color3.fromRGB(252, 95, 83)
CloseButton.Size = UDim2.fromOffset(7, 7)
CloseButton.AutoButtonColor = false
CloseButton.Parent = ControlsFrame

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 50)
CloseButtonCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Text = ""
MinimizeButton.BackgroundColor3 = Color3.fromRGB(242, 191, 60)
MinimizeButton.Size = UDim2.fromOffset(7, 7)
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = ControlsFrame

local MinimizeButtonCorner = Instance.new("UICorner")
MinimizeButtonCorner.CornerRadius = UDim.new(0, 50)
MinimizeButtonCorner.Parent = MinimizeButton

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "Open"
OpenButton.Text = ""
OpenButton.BackgroundColor3 = Color3.fromRGB(117, 166, 87)
OpenButton.Size = UDim2.fromOffset(7, 7)
OpenButton.AutoButtonColor = false
OpenButton.Parent = ControlsFrame

local OpenButtonCorner = Instance.new("UICorner")
OpenButtonCorner.CornerRadius = UDim.new(0, 50)
OpenButtonCorner.Parent = OpenButton

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.fromOffset(0, 60)
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Parent = MainFrame

local GameLabel = Instance.new("TextLabel")
GameLabel.Name = "GameLabel"
GameLabel.FontFace = Font.new("rbxassetid://12187365364")
GameLabel.Text = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
GameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
GameLabel.TextSize = 12
GameLabel.BackgroundTransparency = 1
GameLabel.Position = UDim2.fromOffset(20, 0)
GameLabel.Size = UDim2.new(1, -40, 0, 20)
GameLabel.Parent = ContentFrame

local KeySection = Instance.new("Frame")
KeySection.Name = "KeySection"
KeySection.BackgroundTransparency = 1
KeySection.Position = UDim2.fromOffset(20, 25) 
KeySection.Size = UDim2.new(1, -40, 0, 70)
KeySection.Parent = ContentFrame

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Name = "KeyLabel"
KeyLabel.FontFace = Font.new("rbxassetid://12187365364")
KeyLabel.Text = "Key"
KeyLabel.TextColor3 = Color3.fromRGB(122, 122, 122)
KeyLabel.TextSize = 12
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.BackgroundTransparency = 1
KeyLabel.Position = UDim2.fromOffset(0, 0)
KeyLabel.Size = UDim2.new(1, 0, 0, 20)
KeyLabel.Parent = KeySection

local KeyTextboxHolder = Instance.new("Frame")
KeyTextboxHolder.Name = "TextboxHolder"
KeyTextboxHolder.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
KeyTextboxHolder.BackgroundTransparency = 0.95
KeyTextboxHolder.BorderSizePixel = 0
KeyTextboxHolder.Position = UDim2.fromOffset(0, 25)
KeyTextboxHolder.Size = UDim2.new(1, -80, 0, 30)
KeyTextboxHolder.Parent = KeySection

local KeyTextboxCorner = Instance.new("UICorner")
KeyTextboxCorner.CornerRadius = UDim.new(0, 4)
KeyTextboxCorner.Parent = KeyTextboxHolder

local KeyTextboxStroke = Instance.new("UIStroke")
KeyTextboxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
KeyTextboxStroke.Color = Color3.fromRGB(56, 56, 56)
KeyTextboxStroke.Transparency = 0.5
KeyTextboxStroke.Parent = KeyTextboxHolder

local KeyTextbox = Instance.new("TextBox")
KeyTextbox.Name = "TextBox"
KeyTextbox.ClearTextOnFocus = false
KeyTextbox.FontFace = Font.new("rbxassetid://12187365364")
KeyTextbox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
KeyTextbox.PlaceholderText = "Enter your key..."
KeyTextbox.Text = ""
KeyTextbox.TextColor3 = Color3.fromRGB(240, 240, 240)
KeyTextbox.TextSize = 12
KeyTextbox.TextXAlignment = Enum.TextXAlignment.Left
KeyTextbox.BackgroundTransparency = 1
KeyTextbox.Position = UDim2.fromOffset(10, 0)
KeyTextbox.Size = UDim2.fromScale(1, 1)
KeyTextbox.Parent = KeyTextboxHolder

local CheckButton = Instance.new("TextButton")
CheckButton.Name = "CheckButton"
CheckButton.FontFace = Font.new("rbxassetid://12187365364")
CheckButton.Text = "Check"
CheckButton.TextColor3 = Color3.fromRGB(0, 0, 0)
CheckButton.TextSize = 12
CheckButton.BackgroundColor3 = Color3.fromRGB(255, 188, 254)
CheckButton.BorderSizePixel = 0
CheckButton.Position = UDim2.new(1, -70, 0, 25)
CheckButton.Size = UDim2.fromOffset(70, 30)
CheckButton.Parent = KeySection

local CheckButtonCorner = Instance.new("UICorner")
CheckButtonCorner.CornerRadius = UDim.new(0, 4)
CheckButtonCorner.Parent = CheckButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.FontFace = Font.new("rbxassetid://12187365364")
StatusLabel.Text = "Key Status: Not Checked"
StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
StatusLabel.TextSize = 12
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.fromOffset(0, 60)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Parent = KeySection

local AutoExecuteHolder = Instance.new("Frame")
AutoExecuteHolder.Name = "AutoExecuteHolder"
AutoExecuteHolder.BackgroundTransparency = 1
AutoExecuteHolder.Position = UDim2.fromOffset(0, 85)
AutoExecuteHolder.Size = UDim2.new(1, 0, 0, 20)
AutoExecuteHolder.Parent = KeySection

local AutoExecuteCheckbox = Instance.new("Frame")
AutoExecuteCheckbox.Name = "Checkbox"
AutoExecuteCheckbox.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
AutoExecuteCheckbox.BackgroundTransparency = 0.5
AutoExecuteCheckbox.BorderSizePixel = 0
AutoExecuteCheckbox.Position = UDim2.fromOffset(0, 0)
AutoExecuteCheckbox.Size = UDim2.fromOffset(16, 16)
AutoExecuteCheckbox.Parent = AutoExecuteHolder

local AutoExecuteCorner = Instance.new("UICorner")
AutoExecuteCorner.CornerRadius = UDim.new(0, 3)
AutoExecuteCorner.Parent = AutoExecuteCheckbox

local AutoExecuteCheck = Instance.new("Frame")
AutoExecuteCheck.Name = "Check"
AutoExecuteCheck.BackgroundColor3 = Color3.fromRGB(255, 188, 254)
AutoExecuteCheck.BorderSizePixel = 0
AutoExecuteCheck.Position = UDim2.fromOffset(3, 3)
AutoExecuteCheck.Size = UDim2.fromOffset(10, 10)
AutoExecuteCheck.Visible = true 
AutoExecuteCheck.Parent = AutoExecuteCheckbox

local AutoExecuteCheckCorner = Instance.new("UICorner")
AutoExecuteCheckCorner.CornerRadius = UDim.new(0, 2)
AutoExecuteCheckCorner.Parent = AutoExecuteCheck

local AutoExecuteButton = Instance.new("TextButton")
AutoExecuteButton.Name = "Button"
AutoExecuteButton.Text = ""
AutoExecuteButton.BackgroundTransparency = 1
AutoExecuteButton.Size = UDim2.fromOffset(16, 16)
AutoExecuteButton.Parent = AutoExecuteCheckbox

local AutoExecuteLabel = Instance.new("TextLabel")
AutoExecuteLabel.Name = "Label"
AutoExecuteLabel.FontFace = Font.new("rbxassetid://12187365364")
AutoExecuteLabel.Text = "Auto-execute script after validation"
AutoExecuteLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AutoExecuteLabel.TextSize = 12
AutoExecuteLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoExecuteLabel.BackgroundTransparency = 1
AutoExecuteLabel.Position = UDim2.fromOffset(24, 0)
AutoExecuteLabel.Size = UDim2.new(1, -24, 1, 0)
AutoExecuteLabel.Parent = AutoExecuteHolder

local ButtonsSection = Instance.new("Frame")
ButtonsSection.Name = "ButtonsSection"
ButtonsSection.BackgroundTransparency = 1
ButtonsSection.Position = UDim2.fromOffset(20, 135) 
ButtonsSection.Size = UDim2.new(1, -40, 0, 180)
ButtonsSection.Parent = ContentFrame

local LinkvertiseButton = Instance.new("TextButton")
LinkvertiseButton.Name = "LinkvertiseButton"
LinkvertiseButton.FontFace = Font.new("rbxassetid://12187365364")
LinkvertiseButton.Text = "Get Key (Linkvertise)"
LinkvertiseButton.TextColor3 = Color3.fromRGB(240, 240, 240)
LinkvertiseButton.TextSize = 12
LinkvertiseButton.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
LinkvertiseButton.BackgroundTransparency = 0.5
LinkvertiseButton.BorderSizePixel = 0
LinkvertiseButton.Position = UDim2.fromOffset(0, 0)
LinkvertiseButton.Size = UDim2.new(1, 0, 0, 40)
LinkvertiseButton.Parent = ButtonsSection

local LinkvertiseCorner = Instance.new("UICorner")
LinkvertiseCorner.CornerRadius = UDim.new(0, 6)
LinkvertiseCorner.Parent = LinkvertiseButton

local LootlabsButton = Instance.new("TextButton")
LootlabsButton.Name = "LootlabsButton"
LootlabsButton.FontFace = Font.new("rbxassetid://12187365364")
LootlabsButton.Text = "Get Key (Lootlabs)"
LootlabsButton.TextColor3 = Color3.fromRGB(240, 240, 240)
LootlabsButton.TextSize = 12
LootlabsButton.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
LootlabsButton.BackgroundTransparency = 0.5
LootlabsButton.BorderSizePixel = 0
LootlabsButton.Position = UDim2.fromOffset(0, 50)
LootlabsButton.Size = UDim2.new(1, 0, 0, 40)
LootlabsButton.Parent = ButtonsSection

local LootlabsCorner = Instance.new("UICorner")
LootlabsCorner.CornerRadius = UDim.new(0, 6)
LootlabsCorner.Parent = LootlabsButton

local DiscordButton = Instance.new("TextButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.FontFace = Font.new("rbxassetid://12187365364")
DiscordButton.Text = "Join Discord"
DiscordButton.TextColor3 = Color3.fromRGB(240, 240, 240)
DiscordButton.TextSize = 12
DiscordButton.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
DiscordButton.BackgroundTransparency = 0.5
DiscordButton.BorderSizePixel = 0
DiscordButton.Position = UDim2.fromOffset(0, 100)
DiscordButton.Size = UDim2.new(1, 0, 0, 40)
DiscordButton.Parent = ButtonsSection

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 6)
DiscordCorner.Parent = DiscordButton

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Name = "FooterLabel"
FooterLabel.FontFace = Font.new("rbxassetid://12187365364")
FooterLabel.Text = "SolixHub © 2025 | All rights reserved"
FooterLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
FooterLabel.TextSize = 12
FooterLabel.BackgroundTransparency = 1
FooterLabel.Position = UDim2.fromOffset(0, 150)
FooterLabel.Size = UDim2.new(1, 0, 0, 20)
FooterLabel.Parent = ButtonsSection

local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local function applyButtonHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundTransparency = 0.4}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    end)
end

applyButtonHoverEffect(LinkvertiseButton)
applyButtonHoverEffect(LootlabsButton)
applyButtonHoverEffect(DiscordButton)

local autoExecuteEnabled = true 
AutoExecuteButton.MouseButton1Click:Connect(function()
    autoExecuteEnabled = not autoExecuteEnabled
    AutoExecuteCheck.Visible = autoExecuteEnabled
end)

CheckButton.MouseButton1Click:Connect(function()
    local keyText = KeyTextbox.Text
    
    if keyText == "" then
        StatusLabel.Text = "Key Status: Empty"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) 
        createNotification("Error", "Please enter a key", 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        return
    end
    
    if not isGameSupported() then
        StatusLabel.Text = "Key Status: Game Not Supported"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) 
        createNotification("Error", "This game is not supported by SolixHub.", 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        return
    end
    
    local api = initLuarmorAPI()
    if not api then 
        StatusLabel.Text = "Key Status: API Error"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
        createNotification("Error", "Failed to initialize API", 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        return
    end
    
    StatusLabel.Text = "Key Status: Checking..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
    
    local success, status = pcall(function()
        return api.check_key(keyText)
    end)
    
    if not success then
        StatusLabel.Text = "Key Status: Error"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) 
        createNotification("Error", "Failed to check key: " .. tostring(status), 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        return
    end
    
    if status.code == "KEY_VALID" then
        StatusLabel.Text = "Key Status: Valid"
        StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 127) 
        
        local expiryInfo = ""
        if status.data.auth_expire == -1 or status.data.auth_expire == 0 then
            expiryInfo = "Lifetime key"
        else
            local timeLeft = status.data.auth_expire - os.time()
            if timeLeft > 0 then
                local days = math.floor(timeLeft / 86400)
                local hours = math.floor((timeLeft % 86400) / 3600)
                expiryInfo = days .. "d " .. hours .. "h remaining"
            else
                expiryInfo = "Expired"
            end
        end
        
        createNotification("Success", "Your key is valid! " .. expiryInfo, 5, Color3.fromRGB(85, 255, 127), ScreenGui)
        
        -- Save the key to file first
        local saveSuccess, saveError = pcall(function()
            writefile("Key.txt", keyText)
        end)
        
        if not saveSuccess then
            createNotification("Warning", "Failed to save key: " .. tostring(saveError), 5, Color3.fromRGB(255, 170, 0), ScreenGui)
        else
            -- Verify the key was saved correctly
            local readSuccess, savedKey = pcall(function()
                return readfile("Key.txt")
            end)
            
            if not readSuccess or savedKey ~= keyText then
                createNotification("Warning", "Key verification failed. Teleport may not work correctly.", 5, Color3.fromRGB(255, 170, 0), ScreenGui)
            else
                -- Only set up queue_on_teleport if the key was saved successfully
                queue_on_teleport([[
                    -- Always load the main loader script which will handle key validation
                    -- and show the key system if needed
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/debunked69/keysystest/refs/heads/main/keyssys.lua"))()
                ]])
                
                createNotification("Info", "Key saved successfully. Ready for teleport.", 3, Color3.fromRGB(85, 255, 127), ScreenGui)
            end
        end
        
        if autoExecuteEnabled then
            local execSuccess, execError = executeScript(keyText)
            if not execSuccess then
                createNotification("Script Error", execError, 5, Color3.fromRGB(255, 85, 85), ScreenGui)
                return
            end
            
            task.delay(1, function()
                ScreenGui:Destroy()
            end)
        end
        
    elseif status.code == "KEY_EXPIRED" then
        StatusLabel.Text = "Key Status: Expired"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 85) 
        createNotification("Expired", "Your key has expired.", 5, Color3.fromRGB(255, 255, 85), ScreenGui)
        pcall(function() delfile("Key.txt") end)
        
    elseif status.code == "KEY_HWID_LOCKED" then
        StatusLabel.Text = "Key Status: HWID Locked"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 170, 0) 
        createNotification("HWID Locked", "Key linked to a different device. Please reset it using our bot.", 5, Color3.fromRGB(255, 170, 0), ScreenGui)
        pcall(function() delfile("Key.txt") end)
        
    elseif status.code == "KEY_BANNED" then
        StatusLabel.Text = "Key Status: Banned"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) 
        createNotification("Banned", "This key has been blacklisted.", 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        pcall(function() delfile("Key.txt") end)
        
    elseif status.code == "KEY_INCORRECT" or status.code == "KEY_INVALID" then
        StatusLabel.Text = "Key Status: Invalid"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) 
        createNotification("Invalid", "The key you entered is invalid or does not exist.", 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        pcall(function() delfile("Key.txt") end)
        
    else
        StatusLabel.Text = "Key Status: Error"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) 
        createNotification("Error", status.message or "Unknown error", 5, Color3.fromRGB(255, 85, 85), ScreenGui)
        pcall(function() delfile("Key.txt") end)
    end
end)

LinkvertiseButton.MouseButton1Click:Connect(function()
    setclipboard("https://ads.luarmor.net/get_key?for=Solixhub_Free_KeySystem-OWlLHDMCHADk")
    createNotification("Copied", "Linkvertise link copied to clipboard!", 5, Color3.fromRGB(255, 188, 254), ScreenGui)
end)

LootlabsButton.MouseButton1Click:Connect(function()
    setclipboard("https://ads.luarmor.net/get_key?for=Solix_Free_Keysystems-pqJCGTqnTsng")
    createNotification("Copied", "Lootlabs link copied to clipboard!", 5, Color3.fromRGB(255, 188, 254), ScreenGui)
end)

DiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/rSZJGSr5FW")
    createNotification("Copied", "Discord invite copied to clipboard!", 5, Color3.fromRGB(88, 101, 242), ScreenGui)
end)

KeyTextbox.Focused:Connect(function()
    TweenService:Create(KeyTextboxHolder, TweenInfo.new(0.2), {BackgroundTransparency = 0.87}):Play()
    TweenService:Create(KeyLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

KeyTextbox.FocusLost:Connect(function()
    TweenService:Create(KeyTextboxHolder, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
    TweenService:Create(KeyLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    
    local RestoreButton = Instance.new("TextButton")
    RestoreButton.Name = "RestoreButton"
    RestoreButton.Text = "SolixHub"
    RestoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RestoreButton.TextSize = 14
    RestoreButton.Font = Enum.Font.Gotham
    RestoreButton.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    RestoreButton.BackgroundTransparency = 0.1
    RestoreButton.BorderSizePixel = 0
    RestoreButton.Position = UDim2.new(0, 10, 0, 10)
    RestoreButton.Size = UDim2.fromOffset(100, 30)
    RestoreButton.Parent = ScreenGui
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(0, 6)
    RestoreCorner.Parent = RestoreButton
    
    RestoreButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        RestoreButton:Destroy()
    end)
end)

if not isGameSupported() then
    GameLabel.Text = "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " (Not Supported)"
    GameLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
    
    createNotification("Warning", "This game is not currently supported by SolixHub.", 5, Color3.fromRGB(255, 170, 0), ScreenGui)
end

createNotification("SolixHub", "Welcome to SolixHub! Please enter your key to continue.", 5, Color3.fromRGB(255, 188, 254), ScreenGui)

MainFrame.Visible = true
