-- ============================================================================
-- MOBILE FLY SUITE (DELTA OPTIMIZED)
-- Features: Smooth camera-directed flight with mobile UI toggle.
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Flying = false
local FlySpeed = 50
local BodyVelocity, BodyGyro

-- Cleanup old GUI
if CoreGui:FindFirstChild("MobileFlyGui") then
    CoreGui.MobileFlyGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFlyGui"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- Fly Toggle Button
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = ScreenGui
FlyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FlyButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
FlyButton.BorderSizePixel = 2
FlyButton.Position = UDim2.new(0.02, 0, 0.45, 0)
FlyButton.Size = UDim2.new(0, 50, 0, 50)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "FLY"
FlyButton.TextColor3 = Color3.fromRGB(0, 170, 255)
FlyButton.TextSize = 12
FlyButton.Active = true
FlyButton.Draggable = true

local function toggleFly(state)
    Flying = state
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if Flying then
        if humanoidRootPart then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.Parent = humanoidRootPart
            
            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro.CFrame = humanoidRootPart.CFrame
            BodyGyro.Parent = humanoidRootPart
            
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
end

FlyButton.MouseButton1Click:Connect(function()
    local newState = not Flying
    if newState then
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 60)
        FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        FlyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        FlyButton.TextColor3 = Color3.fromRGB(0, 170, 255)
    end
    toggleFly(newState)
end)

RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local camera = workspace.CurrentCamera
        if rootPart and BodyVelocity and BodyGyro then
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            
            BodyVelocity.Velocity = moveDir * FlySpeed
            BodyGyro.CFrame = camera.CFrame
        end
    end
end)

