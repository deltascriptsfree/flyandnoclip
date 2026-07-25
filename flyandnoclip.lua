-- FlyAndNoclip Script for Delta Executor (Injector)
-- Telegram: t.me/freedeltascripts

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Services
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")

-- State
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 60
local menuVisible = true
local flyBodyVelocity = nil
local flyBodyGyro = nil
local noclipConnection = nil

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyAndNoclip"
screenGui.Parent = player.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local shadow = Instance.new("UICorner")
shadow.CornerRadius = UDim.new(0, 10)
shadow.Parent = mainFrame

local shadow2 = Instance.new("UIStroke")
shadow2.Color = Color3.fromRGB(80, 80, 200)
shadow2.Thickness = 1.5
shadow2.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✦ FlyAndNoclip ✦"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -33, 0, 3)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- Tab Buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 35)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local mainTabBtn = Instance.new("TextButton")
mainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
mainTabBtn.Position = UDim2.new(0, 0, 0, 0)
mainTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
mainTabBtn.BorderSizePixel = 0
mainTabBtn.Text = "Main"
mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTabBtn.TextScaled = true
mainTabBtn.Font = Enum.Font.GothamBold
mainTabBtn.Parent = tabFrame

local mainTabCorner = Instance.new("UICorner")
mainTabCorner.CornerRadius = UDim.new(0, 0)
mainTabCorner.Parent = mainTabBtn

local infoTabBtn = Instance.new("TextButton")
infoTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
infoTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
infoTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
infoTabBtn.BorderSizePixel = 0
infoTabBtn.Text = "Info"
infoTabBtn.TextColor3 = Color3.fromRGB(200, 200, 230)
infoTabBtn.TextScaled = true
infoTabBtn.Font = Enum.Font.GothamBold
infoTabBtn.Parent = tabFrame

local infoTabCorner = Instance.new("UICorner")
infoTabCorner.CornerRadius = UDim.new(0, 0)
infoTabCorner.Parent = infoTabBtn

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -65)
contentContainer.Position = UDim2.new(0, 0, 0, 65)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Main Content
local mainContent = Instance.new("Frame")
mainContent.Size = UDim2.new(1, 0, 1, 0)
mainContent.BackgroundTransparency = 1
mainContent.Parent = contentContainer

-- Info Content
local infoContent = Instance.new("Frame")
infoContent.Size = UDim2.new(1, 0, 1, 0)
infoContent.BackgroundTransparency = 1
infoContent.Visible = false
infoContent.Parent = contentContainer

-- Function to create toggle
local function createToggle(parent, text, state, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 70, 0, 28)
    button.Position = UDim2.new(1, -80, 0.5, -14)
    button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
    button.BorderSizePixel = 0
    button.Text = state and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        state = not state
        button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        button.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return {frame, button}
end

-- Fly Toggle
local flyToggle = createToggle(mainContent, "Fly", false, function(state)
    flyEnabled = state
    if state then
        enableFly()
    else
        disableFly()
    end
end)

-- Noclip Toggle
local noclipToggle = createToggle(mainContent, "Noclip", false, function(state)
    noclipEnabled = state
    if state then
        enableNoclip()
    else
        disableNoclip()
    end
end)

-- Speed Controls
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 50)
speedFrame.Position = UDim2.new(0, 10, 0, 85)
speedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = mainContent

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
speedLabel.Position = UDim2.new(0, 10, 0, 2)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 60"
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedValue = Instance.new("TextBox")
speedValue.Size = UDim2.new(0, 60, 0, 30)
speedValue.Position = UDim2.new(0.65, 0, 0.5, -15)
speedValue.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
speedValue.BorderSizePixel = 0
speedValue.Text = "60"
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.TextScaled = true
speedValue.Font = Enum.Font.Gotham
speedValue.Parent = speedFrame

local speedCorner2 = Instance.new("UICorner")
speedCorner2.CornerRadius = UDim.new(0, 6)
speedCorner2.Parent = speedValue

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 28, 0, 28)
minusBtn.Position = UDim2.new(0.52, 0, 0.5, -14)
minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minusBtn.BorderSizePixel = 0
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = speedFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 6)
minusCorner.Parent = minusBtn

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 28, 0, 28)
plusBtn.Position = UDim2.new(0.85, 0, 0.5, -14)
plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = speedFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusBtn

local function updateSpeed(val)
    flySpeed = math.clamp(val, 1, 200)
    speedValue.Text = tostring(flySpeed)
    speedLabel.Text = "Speed: " .. tostring(flySpeed)
    if flyEnabled and flyBodyVelocity then
        flyBodyVelocity.Velocity = flyBodyVelocity.Velocity.Unit * flySpeed
    end
end

speedValue.FocusLost:Connect(function()
    local num = tonumber(speedValue.Text)
    if num then
        updateSpeed(num)
    else
        speedValue.Text = tostring(flySpeed)
    end
end)

minusBtn.MouseButton1Click:Connect(function()
    updateSpeed(flySpeed - 5)
end)

plusBtn.MouseButton1Click:Connect(function()
    updateSpeed(flySpeed + 5)
end)

-- Info Content
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -20)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Telegram: t.me/freedeltascripts"
infoLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextWrapped = true
infoLabel.Parent = infoContent

-- Tab switching
mainTabBtn.MouseButton1Click:Connect(function()
    mainContent.Visible = true
    infoContent.Visible = false
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    infoTabBtn.TextColor3 = Color3.fromRGB(200, 200, 230)
end)

infoTabBtn.MouseButton1Click:Connect(function()
    mainContent.Visible = false
    infoContent.Visible = true
    infoTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    infoTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    mainTabBtn.TextColor3 = Color3.fromRGB(200, 200, 230)
end)

-- Fly Functions
function enableFly()
    if not rootPart or not humanoid then return end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.D = 500
    flyBodyGyro.P = 5000
    flyBodyGyro.CFrame = rootPart.CFrame
    flyBodyGyro.Parent = rootPart
    
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    
    runService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Camera.Value, function()
        if not flyEnabled then return end
        if not rootPart or not rootPart.Parent then return end
        
        local moveDirection = Vector3.new()
        local camera = workspace.CurrentCamera
        
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector * Vector3.new(1, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector * Vector3.new(1, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector * Vector3.new(1, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector * Vector3.new(1, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        else
            moveDirection = Vector3.new(0, 0, 0)
        end
        
        flyBodyVelocity.Velocity = moveDirection
        flyBodyGyro.CFrame = camera.CFrame * CFrame.Angles(0, 0, 0)
    end)
end

function disableFly()
    flyEnabled = false
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
    end
    runService:UnbindFromRenderStep("FlyMovement")
end

-- Noclip Functions
function enableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    noclipConnection = runService.Stepped:Connect(function()
        if not noclipEnabled then return end
        local char = player.Character
        if not char then return end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

function disableNoclip()
    noclipEnabled = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Minimize
local menuHidden = false
minimizeButton.MouseButton1Click:Connect(function()
    menuHidden = not menuHidden
    contentContainer.Visible = not menuHidden
    tabFrame.Visible = not menuHidden
    minimizeButton.Text = menuHidden and "+" or "−"
    if menuHidden then
        mainFrame.Size = UDim2.new(0, 280, 0, 35)
    else
        mainFrame.Size = UDim2.new(0, 280, 0, 200)
    end
end)

-- Keybinds
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        local state = not flyEnabled
        flyEnabled = state
        flyToggle[2].BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        flyToggle[2].Text = state and "ON" or "OFF"
        if state then
            enableFly()
        else
            disableFly()
        end
    end
    
    if input.KeyCode == Enum.KeyCode.N then
        local state = not noclipEnabled
        noclipEnabled = state
        noclipToggle[2].BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(200, 50, 50)
        noclipToggle[2].Text = state and "ON" or "OFF"
        if state then
            enableNoclip()
        else
            disableNoclip()
        end
    end
    
    if input.KeyCode == Enum.KeyCode.V then
        minimizeButton.MouseButton1Click:Fire()
    end
end)

-- Cleanup
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    
    if flyEnabled then
        disableFly()
        flyEnabled = false
        flyToggle[2].BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        flyToggle[2].Text = "OFF"
    end
    if noclipEnabled then
        disableNoclip()
        noclipEnabled = false
        noclipToggle[2].BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        noclipToggle[2].Text = "OFF"
    end
end)

print("✦ FlyAndNoclip Loaded ✦")
print("Telegram: t.me/freedeltascripts")
print("Keys: [F] Fly | [N] Noclip | [V] Menu")
