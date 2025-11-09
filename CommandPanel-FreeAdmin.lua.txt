local Players = game:GetService('Players')

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local player = Players.LocalPlayer

local playerGui = player:WaitForChild('PlayerGui')

local requestCommand = ReplicatedStorage:WaitForChild('HDAdminClient')

    :WaitForChild('Signals')

    :WaitForChild('RequestCommand')



local commands = {

    ':Fly',

    ':Invisible',

    ':Fire',

    ':Sparkles',

    ':Lasereyes',

    ':FF',

    ':Control',

    ':TP',

    ':Bring',

    ':Clown',

    ':Jail',

    ':Freeze',

    ':Ice',

    ':Clone',

    ':Rainbowfart',

    ':Fart',

    ':Explode',

    ':Fling',

    ':Warp',

    ':Boing',

    ':Res',

    ':God',

    ':Morphs',

    ':Dino',

    ':Bighead',

    ':Smallhead',

    ':Potatohead',

    ':Ghost',

    ':Gold',

    ':Shine',

    ':Neon',

    ':Glass',

    ':Smoke',

    ':Disco',

    ':Music',

    ':M',

    ':Logs',

    ':R15',

    ':Thin',

    ':Giant',



    ':selene',

    ':hamster',

    ':fish',

    ':ballerina',

    ':brr',

    ':lirilarila',

    ':chimpanzini',

    ':tralala',

    ':assassino',

    ':trippitroppi',

    ':boneca',

    ':din',

    ':garamaraman',



    ':floppa',

    ':doctorstrange',

    ':lockPlayer',

    ':backrooms',

    ':wednesday',

    ':flamingo',

    ':baller',

    ':mummy',

    ':billy',

    ':ManFace',

    ':toilet',

    ':p90',

    ':baby',

    ':hand',

    ':1x1x1x1',

    ':roach',

    ':smite',

    ':stun',

    ':rocket',

    ':box',

    ':telescope',

    ':teslawoman',

    ':boomboxman',

    ':spice',

    ':spider',

    ':grandma',

    ':shark',

    ':doll',

    ':Player230',

}



local commandsWithValue = {

    [':Size'] = 'number',

    [':Heal'] = 'number',

}



local commandsWithText = {

    [':Talk'] = 'text',

}



local screenGui = Instance.new('ScreenGui')

screenGui.Name = 'CommandGui'

screenGui.ResetOnSpawn = false

screenGui.Parent = playerGui



local mainFrame = Instance.new('Frame')

mainFrame.Size = UDim2.new(0, 300, 0, 400)

mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)

mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

mainFrame.BorderSizePixel = 0

mainFrame.Parent = screenGui

mainFrame.Active = true

mainFrame.Draggable = true



local uiCorner = Instance.new('UICorner')

uiCorner.CornerRadius = UDim.new(0, 12)

uiCorner.Parent = mainFrame



local title = Instance.new('TextLabel')

title.Size = UDim2.new(1, 0, 0, 40)

title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

title.Text = 'Command Panel'

title.TextColor3 = Color3.fromRGB(255, 255, 255)

title.Font = Enum.Font.GothamBold

title.TextSize = 18

title.Parent = mainFrame



local searchBox = Instance.new('TextBox')

searchBox.Size = UDim2.new(1, -20, 0, 30)

searchBox.Position = UDim2.new(0, 10, 0, 50)

searchBox.PlaceholderText = 'Search command...'

searchBox.Text = ''

searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)

searchBox.Parent = mainFrame



local playerBox = Instance.new('TextBox')

playerBox.Size = UDim2.new(1, -20, 0, 30)

playerBox.Position = UDim2.new(0, 10, 0, 90)

playerBox.PlaceholderText = 'Enter player (leave empty = all)'

playerBox.Text = ''

playerBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

playerBox.TextColor3 = Color3.fromRGB(255, 255, 255)

playerBox.Parent = mainFrame



local commandList = Instance.new('ScrollingFrame')

commandList.Size = UDim2.new(1, -20, 1, -160)

commandList.Position = UDim2.new(0, 10, 0, 130)

commandList.CanvasSize = UDim2.new(0, 0, 0, 0)

commandList.ScrollBarThickness = 6

commandList.BackgroundTransparency = 1

commandList.Parent = mainFrame



local listLayout = Instance.new('UIListLayout')

listLayout.Parent = commandList

listLayout.SortOrder = Enum.SortOrder.LayoutOrder



local credit = Instance.new('TextLabel')

credit.Size = UDim2.new(1, 0, 0, 20)

credit.Position = UDim2.new(0, 0, 1, -20)

credit.BackgroundTransparency = 1

credit.Text = 'Made by Flex'

credit.TextColor3 = Color3.fromRGB(150, 150, 150)

credit.Font = Enum.Font.Gotham

credit.TextSize = 14

credit.Parent = mainFrame



local function runCommand(command, target)

    local requiresValue = commandsWithValue[command]

    local requiresText = commandsWithText[command]



    if requiresValue or requiresText then

        local popup = Instance.new('Frame')

        popup.Size = UDim2.new(0, 250, 0, 120)

        popup.Position = UDim2.new(0.5, -125, 0.5, -60)

        popup.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

        popup.Parent = screenGui



        local uiCorner2 = Instance.new('UICorner')

        uiCorner2.CornerRadius = UDim.new(0, 10)

        uiCorner2.Parent = popup



        local label = Instance.new('TextLabel')

        label.Size = UDim2.new(1, 0, 0, 30)

        label.Text = requiresValue and 'Enter Number' or 'Enter Text'

        label.TextColor3 = Color3.fromRGB(255, 255, 255)

        label.BackgroundTransparency = 1

        label.Font = Enum.Font.GothamBold

        label.TextSize = 16

        label.Parent = popup



        local input = Instance.new('TextBox')

        input.Size = UDim2.new(1, -20, 0, 30)

        input.Position = UDim2.new(0, 10, 0, 40)

        input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

        input.TextColor3 = Color3.fromRGB(255, 255, 255)

        input.PlaceholderText = requiresValue and 'Enter number...'

            or 'Enter text...'

        input.Parent = popup



        local submit = Instance.new('TextButton')

        submit.Size = UDim2.new(1, -20, 0, 30)

        submit.Position = UDim2.new(0, 10, 0, 80)

        submit.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

        submit.Text = 'Submit'

        submit.TextColor3 = Color3.fromRGB(255, 255, 255)

        submit.Font = Enum.Font.GothamBold

        submit.TextSize = 14

        submit.Parent = popup



        submit.MouseButton1Click:Connect(function()

            local value = input.Text

            popup:Destroy()

            if target == 'all' then

                for _, plr in pairs(Players:GetPlayers()) do

                    requestCommand:InvokeServer(

                        command .. ' ' .. plr.Name .. ' ' .. value

                    )

                end

            else

                local found = nil

                for _, plr in pairs(Players:GetPlayers()) do

                    if plr.Name:lower():sub(1, #target) == target:lower() then

                        found = plr

                        break

                    end

                end

                if found then

                    requestCommand:InvokeServer(

                        command .. ' ' .. found.Name .. ' ' .. value

                    )

                end

            end

        end)

    else

        if target == 'all' then

            for _, plr in pairs(Players:GetPlayers()) do

                requestCommand:InvokeServer(command .. ' ' .. plr.Name)

            end

        else

            local found = nil

            for _, plr in pairs(Players:GetPlayers()) do

                if plr.Name:lower():sub(1, #target) == target:lower() then

                    found = plr

                    break

                end

            end

            if found then

                requestCommand:InvokeServer(command .. ' ' .. found.Name)

            end

        end

    end

end



local function createCommandButton(cmd)

    local button = Instance.new('TextButton')

    button.Size = UDim2.new(1, -5, 0, 30)

    button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    button.Text = cmd

    button.TextColor3 = Color3.fromRGB(255, 255, 255)

    button.Font = Enum.Font.Gotham

    button.TextSize = 14

    button.Parent = commandList



    button.MouseButton1Click:Connect(function()

        local target = playerBox.Text ~= '' and playerBox.Text or 'all'

        runCommand(cmd, target)

    end)

end



local function refreshCommands()

    for _, child in pairs(commandList:GetChildren()) do

        if child:IsA('TextButton') then

            child:Destroy()

        end

    end

    for _, cmd in ipairs(commands) do

        if searchBox.Text == '' or cmd:lower():find(searchBox.Text:lower()) then

            createCommandButton(cmd)

        end

    end

    commandList.CanvasSize = UDim2.new(0, 0, 0, #commands * 35)

end



searchBox:GetPropertyChangedSignal('Text'):Connect(refreshCommands)

refreshCommands()