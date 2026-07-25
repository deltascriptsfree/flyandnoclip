-- ============================================================================
-- MM2 FLY & NOCLIP SUITE WITH SPEED CONTROL (DELTA OPTIMIZED)
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local Flying = false
local NoclipActive = false
local FlySpeed = 50
local BodyVelocity, BodyGyro, TargetMoveDir
local MobileMoveVector = Vector3.new(0, 0, 0)

-- Prevent idle kick
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Cleanup previous GUI
if CoreGui:FindFirstChild("MM2FlyNoclipMenu") then
    CoreGui.MM2FlyNoclipMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2FlyNoclipMenu"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(1, -10, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "FLY & NOCLIP MENU"
TitleText.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleText.TextSize = 11
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Container Layout
local UIList = Instance.new("UIListLayout")
UIList.Parent = MainFrame
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local Spacer = Instance.new("Frame")
Spacer.Parent = MainFrame
Spacer.BackgroundTransparency = 1
Spacer.Size = UDim2.new(1, 0, 0, 32)

-- Helper: Create Toggles inside single menu
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 11

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Text = name .. ": OFF"
        end
        callback(state)
    end)
end

-- Fly Toggle
createToggle("Fly", function(state)
    Flying = state
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if Flying then
        if rootPart then
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

-- Noclip Toggle (Forced CanCollide = false every frame via RunService.Stepped)
createToggle("Noclip", function(state)
    NoclipActive = state
end)

RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Speed Adjustment UI Section inside the same menu
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Size = UDim2.new(0, 180, 0, 20)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "Fly Speed: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 11

local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = MainFrame
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Size = UDim2.new(0, 180, 0, 30)

local SpeedDown = Instance.new("TextButton")
SpeedDown.Parent = SpeedContainer
SpeedDown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedDown.BorderSizePixel = 0
SpeedDown.Position = UDim2.new(0, 0, 0, 0)
SpeedDown.Size = UDim2.new(0, 85, 0, 30)
SpeedDown.Font = Enum.Font.GothamBold
SpeedDown.Text = "- Speed"
SpeedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDown.TextSize = 11

local SpeedUp = Instance.new("TextButton")
SpeedUp.Parent = SpeedContainer
SpeedUp.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedUp.BorderSizePixel = 0
SpeedUp.Position = UDim2.new(0, 95, 0, 0)
SpeedUp.Size = UDim2.new(0, 85, 0, 30)
SpeedUp.Font = Enum.Font.GothamBold
SpeedUp.Text = "+ Speed"
SpeedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUp.TextSize = 11

SpeedDown.MouseButton1Click:Connect(function()
    FlySpeed = math.clamp(FlySpeed - 15, 15, 200)
    SpeedLabel.Text = "Fly Speed: " .. FlySpeed
end)

SpeedUp.MouseButton1Click:Connect(function()
    FlySpeed = math.clamp(FlySpeed + 15, 15, 200)
    SpeedLabel.Text = "Fly Speed: " .. FlySpeed
end)

-- Mobile Joystick & Keyboard Movement Integration (Fixes immobility bug)
RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local camera = workspace.CurrentCamera
        
        if rootPart and BodyVelocity and BodyGyro then
            local moveDir = Vector3.new(0, 0, 0)
            
            -- Keyboard input handling (PC / Keyboards)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            
            -- Mobile Thumbstick integration fallback
            if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                moveDir = humanoid.MoveDirection
            end
            
            BodyVelocity.Velocity = moveDir * FlySpeed
            BodyGyro.CFrame = camera.CFrame
        end
    end
end)
