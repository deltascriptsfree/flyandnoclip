-- Murder Mystery 2 Fly + Noclip Script
-- Telegram: @freedeltascripts
-- Delta Executor Compatible

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Services
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")

-- State
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local menuVisible = true
local flyBodyVelocity = nil
local flyBodyGyro = nil
local noclipConnection = nil

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TweakosGUI"
screenGui.Parent = player.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("UICorner")
shadow.CornerRadius = UDim.new(0, 12)
shadow.Parent = mainFrame

local shadow2 = Instance.new("UIStroke")
shadow2.Color = Color3.fromRGB(100, 100, 255)
shadow2.Thickness = 1.5
shadow2.Parent = mainFrame

-- Title
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✧ TWEAKOS FLY ✧"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

-- Content Frame (scrollable)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
contentFrame.ScrollBarThickness = 4
contentFrame.Parent = mainFrame

-- Function to create toggle button
local function createToggleButton(text, state, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BorderSizePixel = 0
    frame.Parent = contentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.Position = UDim2.new(1, -90, 0.5, -15)
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

    return {frame, button, label}
end

-- Fly Toggle
local flyToggle = createToggleButton("✈ FLY MODE", false, function(state)
    flyEnabled = state
    if state then
        enableFly()
    else
        disableFly()
    end
end)

-- Noclip Toggle
local noclipToggle = createToggleButton("⊘ NOCLIP", false, function(state)
    noclipEnabled = state
    if state then
        enableNoclip()
    else
        disableNoclip()
    end
end)

-- Speed Slider
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -10, 0, 55)
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = contentFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
speedLabel.Position = UDim2.new(0, 10, 0, 2)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 230)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedSlider = Instance.new("Slider")
-- Using a simple textbox + increment buttons since Slider is not in all executors
local speedValue = Instance.new("TextBox")
speedValue.Size = UDim2.new(0, 60, 0, 30)
speedValue.Position = UDim2.new(0.7, 0, 0.5, -15)
speedValue.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
speedValue.BorderSizePixel = 0
speedValue.Text = "50"
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.TextScaled = true
speedValue.Font = Enum.Font.Gotham
speedValue.Parent = speedFrame

local speedCorner2 = Instance.new("UICorner")
speedCorner2.CornerRadius = UDim.new(0, 6)
speedCorner2.Parent = speedValue

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 30, 0, 30)
minusBtn.Position = UDim2.new(0.55, 0, 0.5, -15)
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
plusBtn.Size = UDim2.new(0, 30, 0, 30)
plusBtn.Position = UDim2.new(0.85, 0, 0.5, -15)
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

-- Info Section
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -10, 0, 40)
infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
infoFrame.BorderSizePixel = 0
infoFrame.Parent = contentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 1, 0)
infoLabel.Position = UDim2.new(0, 5, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📢 Telegram: @freedeltascripts"
infoLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.GothamBold
infoLabel.Parent = infoFrame

-- Keybinds info
local keybindsFrame = Instance.new("Frame")
keybindsFrame.Size = UDim2.new(1, -10, 0, 35)
keybindsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
keybindsFrame.BorderSizePixel = 0
keybindsFrame.Parent = contentFrame

local keybindsCorner = Instance.new("UICorner")
keybindsCorner.CornerRadius = UDim.new(0, 8)
keybindsCorner.Parent = keybindsFrame

local keybindsLabel = Instance.new("TextLabel")
keybindsLabel.Size = UDim2.new(1, -10, 1, 0)
keybindsLabel.Position = UDim2.new(0, 5, 0, 0)
keybindsLabel.BackgroundTransparency = 1
keybindsLabel.Text = "[F] Fly  |  [N] Noclip  |  [V] Menu"
keybindsLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
keybindsLabel.TextScaled = true
keybindsLabel.Font = Enum.Font.Gotham
keybindsLabel.Parent = keybindsFrame

-- Fly Functions
function enableFly()
    if not rootPart or not humanoid then return end
    
    -- Create BodyVelocity for movement
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
    
    -- Create BodyGyro for orientation
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.D = 500
    flyBodyGyro.P = 5000
    flyBodyGyro.CFrame = rootPart.CFrame
    flyBodyGyro.Parent = rootPart
    
    -- Disable gravity and physics
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    
    -- Movement loop
    runService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Camera.Value, function()
        if not flyEnabled then return end
        if not rootPart or not rootPart.Parent then return end
        
        local moveDirection = Vector3.new()
        local camera = workspace.CurrentCamera
        
        -- WASD movement
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
        -- Space to fly up, Shift to fly down
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
    -- Re-enable collision for all parts
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Minimize functionality
local menuHidden = false
minimizeButton.MouseButton1Click:Connect(function()
    menuHidden = not menuHidden
    contentFrame.Visible = not menuHidden
    minimizeButton.Text = menuHidden and "+" or "−"
    if menuHidden then
        mainFrame.Size = UDim2.new(0, 320, 0, 40)
    else
        mainFrame.Size = UDim2.new(0, 320, 0, 420)
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

-- Cleanup on character reset
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    
    -- Reset states
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

-- Initial message
print("✧ TWEAKOS FLY + NOCLIP LOADED ✧")
print("📢 Telegram: @freedeltascripts")
print("Keys: [F] Fly | [N] Noclip | [V] Menu")
