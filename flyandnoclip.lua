-- ============================================================================
-- FLYANDNOCLIP ULTIMATE SUITE (DELTA MOBILE OPTIMIZED)
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Flying = false
local NoclipActive = false
local FlySpeed = 60
local BodyVelocity, BodyGyro

-- Cleanup previous GUI safely
if CoreGui:FindFirstChild("FlyAndNoclipSuite") then
    CoreGui.FlyAndNoclipSuite:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyAndNoclipSuite"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- Floating Toggle Button to Open/Close Menu
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.BorderSizePixel = 2
ToggleButton.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.TextSize = 11
ToggleButton.Active = true
ToggleButton.Draggable = true

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.08, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 270)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 32)

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(1, -35, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "FlyAndNoclip"
TitleText.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleText.TextSize = 12
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -26, 0, 6)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 10

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab Switcher Bar (Main & Info)
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 32)
TabBar.Size = UDim2.new(1, 0, 0, 30)

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Parent = TabBar
MainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MainTabBtn.BorderSizePixel = 0
MainTabBtn.Position = UDim2.new(0, 0, 0, 0)
MainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.Text = "Main"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextSize = 11

local InfoTabBtn = Instance.new("TextButton")
InfoTabBtn.Parent = TabBar
InfoTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InfoTabBtn.BorderSizePixel = 0
InfoTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
InfoTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
InfoTabBtn.Font = Enum.Font.GothamBold
InfoTabBtn.Text = "Info"
InfoTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoTabBtn.TextSize = 11

-- Content Container Frames
local MainContent = Instance.new("Frame")
MainContent.Parent = MainFrame
MainContent.BackgroundTransparency = 1
MainContent.Position = UDim2.new(0, 0, 0, 72)
MainContent.Size = UDim2.new(1, 0, 1, -72)
MainContent.Visible = true

local InfoContent = Instance.new("Frame")
InfoContent.Parent = MainFrame
InfoContent.BackgroundTransparency = 1
InfoContent.Position = UDim2.new(0, 0, 0, 72)
InfoContent.Size = UDim2.new(1, 0, 1, -72)
InfoContent.Visible = false

-- Tab switching logic
MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    InfoContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    InfoTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

InfoTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    InfoContent.Visible = true
    InfoTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    InfoTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Layout for Main Tab Content
local MainLayout = Instance.new("UIListLayout")
MainLayout.Parent = MainContent
MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 10)

local Spacer1 = Instance.new("Frame")
Spacer1.Parent = MainContent
Spacer1.BackgroundTransparency = 1
Spacer1.Size = UDim2.new(1, 0, 0, 5)

-- Helper to create toggle buttons in Main tab
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainContent
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 210, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    btn.TextSize = 11

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.TextColor3 = Color3.fromRGB(160, 160, 160)
            btn.Text = name .. ": OFF"
        end
        callback(state)
    end)
end

-- 1. Noclip Toggle
createToggle("Noclip", function(state)
    NoclipActive = state
end)

-- 2. Fly Toggle with absolute stable physics configuration
createToggle("Fly", function(state)
    Flying = state
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if Flying then
        if rootPart then
            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end

            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.Parent = rootPart
            
            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro.CFrame = rootPart.CFrame
            BodyGyro.Parent = rootPart
            
            if humanoid then
                humanoid.PlatformStand = true
            end
        end
    else
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end)

-- 3. Speed Control Section
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainContent
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 210, 0, 18)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "Fly Speed: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 11

local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = MainContent
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Size = UDim2.new(0, 210, 0, 32)

local SpeedDown = Instance.new("TextButton")
SpeedDown.Parent = SpeedContainer
SpeedDown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedDown.BorderSizePixel = 0
SpeedDown.Position = UDim2.new(0, 0, 0, 0)
SpeedDown.Size = UDim2.new(0, 100, 0, 32)
SpeedDown.Font = Enum.Font.GothamBold
SpeedDown.Text = "- Speed"
SpeedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDown.TextSize = 11

local SpeedUp = Instance.new("TextButton")
SpeedUp.Parent = SpeedContainer
SpeedUp.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedUp.BorderSizePixel = 0
SpeedUp.Position = UDim2.new(0, 110, 0, 0)
SpeedUp.Size = UDim2.new(0, 100, 0, 32)
SpeedUp.Font = Enum.Font.GothamBold
SpeedUp.Text = "+ Speed"
SpeedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUp.TextSize = 11

SpeedDown.MouseButton1Click:Connect(function()
    FlySpeed = math.clamp(FlySpeed - 10, 10, 300)
    SpeedLabel.Text = "Fly Speed: " .. FlySpeed
end)

SpeedUp.MouseButton1Click:Connect(function()
    FlySpeed = math.clamp(FlySpeed + 10, 10, 300)
    SpeedLabel.Text = "Fly Speed: " .. FlySpeed
end)

-- Info Tab Content
local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoContent
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0, 15, 0, 20)
InfoText.Size = UDim2.new(1, -30, 1, -40)
InfoText.Font = Enum.Font.Gotham
InfoText.Text = "Telegram: t.me/freedeltascripts"
InfoText.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoText.TextSize = 13
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Center
InfoText.TextYAlignment = Enum.TextYAlignment.Center

-- Main Loops (Noclip and Fully Responsive Fly Movement for Mobile & PC)
RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local camera = workspace.CurrentCamera
        
        if rootPart and BodyVelocity and BodyGyro then
            local moveDir = Vector3.new(0, 0, 0)
            
            -- Keyboard input handling (PC)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            
            -- Mobile Thumbstick integration
            if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                moveDir = humanoid.MoveDirection
            end
            
            BodyVelocity.Velocity = moveDir * FlySpeed
            BodyGyro.CFrame = camera.CFrame
        end
    end
end)
