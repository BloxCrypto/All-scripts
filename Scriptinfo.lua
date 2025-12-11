local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Nopeewddkdkdkfkswllkfjfncndmdmdkkelskvtnkfkdodofk", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("Info", 238316631) -- Title, Image

local Paragraph = Tab:CreateParagraph({
    Title = "Server Info",
    Content = "Loading..."
})

--// Services
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--// Get Game Name
local gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local gameName = gameInfo.Name or "Unknown"

--// FPS Tracking
local fps = 0
RunService.RenderStepped:Connect(function(dt)
    fps = math.floor(1 / dt)
end)

--// Auto-update
task.spawn(function()
    while task.wait(1) do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local players = #game.Players:GetPlayers()
        
        -- memory usage (MB)
        local mem = math.floor(Stats:GetTotalMemoryUsageMb())

        Paragraph:Set({
            Title = "Server Info",
            Content =
                "Game Name: " .. gameName ..
                "\nServer ID: " .. game.JobId ..
                "\nGame ID: " .. game.PlaceId ..
                "\nJob ID: " .. game.JobId ..
                "\nFPS: " .. fps ..
                "\nPing: " .. ping .. " ms" ..
                "\nPlayers: " .. players ..
                "\nMemory Usage: " .. mem .. " MB"
        })
    end
end)

local Divider = Tab:CreateDivider()

local Paragraph = Tab:CreateParagraph({
    Title = "Your Account Info",
    Content = "Loading..."
})

--// Get local player
local player = game.Players.LocalPlayer

-- Roblox does **not provide age directly**; you can only get:
-- Username, DisplayName
-- If you have age stored in DataStore or PlayerAttributes, you can get it.

-- Example using PlayerAttributes (if you have 'Age' attribute)
-- player:SetAttribute("Age", 18) -- for testing

-- Auto-update every 1 second
task.spawn(function()
    while task.wait(1) do
        local username = player.Name
        local displayName = player.DisplayName
        local age = player:GetAttribute("Age") or "N/A"

        Paragraph:Set({
            Title = "Your Account Info",
            Content =
                "Username: " .. username ..
                "\nDisplay Name: " .. displayName ..
                "\nAge: " .. age
        })
    end
end)

local Divider = Tab:CreateDivider()

local Paragraph = Tab:CreateParagraph({
    Title = "Your Account Movement",
    Content = "Loading..."
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Helper function to detect if the player might be flying
local function isFlying()
    -- Simple detection: if HumanoidState is Freefall for too long while Y velocity is high
    local state = humanoid:GetState()
    if state == Enum.HumanoidStateType.Freefall then
        if rootPart.Velocity.Y > 50 then
            return true
        end
    end
    return false
end

-- Auto-update every 1 second
task.spawn(function()
    while task.wait(1) do
        -- Make sure character still exists
        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            character = player.Character or player.CharacterAdded:Wait()
            humanoid = character:WaitForChild("Humanoid")
            rootPart = character:WaitForChild("HumanoidRootPart")
        end

        local jumpPower = humanoid.JumpPower
        local walkspeed = humanoid.WalkSpeed
        local flying = isFlying() and "Yes" or "No"
        local collisions = rootPart.CanCollide and "Enabled" or "Disabled"

        Paragraph:Set({
            Title = "Your Account Movement",
            Content =
                "Jump Power: " .. jumpPower ..
                "\nWalkSpeed: " .. walkspeed ..
                "\nFlying: " .. flying ..
                "\nCollisions: " .. collisions
        })
    end
end)