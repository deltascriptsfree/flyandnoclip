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
local FlySpeed = 65
local BodyVelocity, BodyGyro
local movementConnection = nil

-- Cleanup previous GUI
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

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -140, 0.4, -120)
MainFrame.Size = UDim2.new(0, 280, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 35)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(1, -35, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "FlyAndNoclip"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab Switcher Bar
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TabBar.BorderSizePixel = 0
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.Size = UDim2.new(1, 0, 0, 32)

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Parent = TabBar
MainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
MainTabBtn.BorderSizePixel = 0
MainTabBtn.Position = UDim2.new(0, 0, 0, 0)
MainTabBtn.Size = UDim2.new(0.5, -1, 1, 0)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.Text = "Main"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextSize = 12

local InfoTabBtn = Instance.new("TextButton")
InfoTabBtn.Parent = TabBar
InfoTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InfoTabBtn.BorderSizePixel = 0
InfoTabBtn.Position = UDim2.new(0.5, 1, 0, 0)
InfoTabBtn.Size = UDim2.new(0.5, -1, 1, 0)
InfoTabBtn.Font = Enum.Font.GothamBold
InfoTabBtn.Text = "Info"
InfoTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoTabBtn.TextSize = 12

-- Content Container
local MainContent = Instance.new("Frame")
MainContent.Parent = MainFrame
MainContent.BackgroundTransparency = 1
MainContent.Position = UDim2.new(0, 0, 0, 67)
MainContent.Size = UDim2.new(1, 0, 1, -67)

local InfoContent = Instance.new("Frame")
InfoContent.Parent = MainFrame
InfoContent.BackgroundTransparency = 1
InfoContent.Position = UDim2.new(0, 0, 0, 67)
InfoContent.Size = UDim2.new(1, 0, 1, -67)
InfoContent.Visible = false

-- Tab switching
MainTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = true
    InfoContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    InfoTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

InfoTabBtn.MouseButton1Click:Connect(function()
    MainContent.Visible = false
    InfoContent.Visible = true
    InfoTabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    InfoTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- ================= MAIN CONTENT =================

-- Noclip Toggle
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Parent = MainContent
NoclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
NoclipBtn.BorderSizePixel = 0
NoclipBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
NoclipBtn.Size = UDim2.new(0.9, 0, 0, 38)
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
NoclipBtn.TextSize = 13

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 6)
NoclipCorner.Parent = NoclipBtn

local noclipState = false
NoclipBtn.MouseButton1Click:Connect(function()
    noclipState = not noclipState
    NoclipActive = noclipState
    if noclipState then
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 70)
        NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        NoclipBtn.Text = "Noclip: ON"
    else
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        NoclipBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        NoclipBtn.Text = "Noclip: OFF"
    end
end)

-- Fly Toggle
local FlyBtn = Instance.new("TextButton")
FlyBtn.Parent = MainContent
FlyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FlyBtn.BorderSizePixel = 0
FlyBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 38)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
FlyBtn.TextSize = 13

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 6)
FlyCorner.Parent = FlyBtn

local flyState = false
FlyBtn.MouseButton1Click:Connect(function()
    flyState = not flyState
    Flying = flyState
    if flyState then
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 70)
        FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        FlyBtn.Text = "Fly: ON"
    else
        FlyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        FlyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        FlyBtn.Text = "Fly: OFF"
        disableFly()
    end
    if flyState then
        enableFly()
    end
end)

-- Speed Controls
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainContent
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.42, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "Speed: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Center

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Parent = MainContent
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 36)

local SpeedDown = Instance.new("TextButton")
SpeedDown.Parent = SpeedFrame
SpeedDown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedDown.BorderSizePixel = 0
SpeedDown.Position = UDim2.new(0, 0, 0, 0)
SpeedDown.Size = UDim2.new(0.45, 0, 1, 0)
SpeedDown.Font = Enum.Font.GothamBold
SpeedDown.Text = "−"
SpeedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDown.TextSize = 20

local SpeedDownCorner = Instance.new("UICorner")
SpeedDownCorner.CornerRadius = UDim.new(0, 6)
SpeedDownCorner.Parent = SpeedDown

local SpeedValue = Instance.new("TextLabel")
SpeedValue.Parent = SpeedFrame
SpeedValue.BackgroundTransparency = 1
SpeedValue.Position = UDim2.new(0.45, 0, 0, 0)
SpeedValue.Size = UDim2.new(0.1, 0, 1, 0)
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.Text = tostring(FlySpeed)
SpeedValue.TextColor3 = Color3.fromRGB(0, 170, 255)
SpeedValue.TextSize = 18
SpeedValue.TextXAlignment = Enum.TextXAlignment.Center

local SpeedUp = Instance.new("TextButton")
SpeedUp.Parent = SpeedFrame
SpeedUp.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedUp.BorderSizePixel = 0
SpeedUp.Position = UDim2.new(0.55, 0, 0, 0)
SpeedUp.Size = UDim2.new(0.45, 0, 1, 0)
SpeedUp.Font = Enum.Font.GothamBold
SpeedUp.Text = "+"
SpeedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUp.TextSize = 20

local SpeedUpCorner = Instance.new("UICorner")
SpeedUpCorner.CornerRadius = UDim.new(0, 6)
SpeedUpCorner.Parent = SpeedUp

SpeedDown.MouseButton1Click:Connect(function()
    FlySpeed = math.clamp(FlySpeed - 5, 10, 200)
    SpeedLabel.Text = "Speed: " .. FlySpeed
    SpeedValue.Text = tostring(FlySpeed)
end)

SpeedUp.MouseButton1Click:Connect(function()
    FlySpeed = math.clamp(FlySpeed + 5, 10, 200)
    SpeedLabel.Text = "Speed: " .. FlySpeed
    SpeedValue.Text = tostring(FlySpeed)
end)

-- ================= INFO CONTENT =================

local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoContent
InfoText.BackgroundTransparency = 1
InfoText.Position = UDim2.new(0, 20, 0, 30)
InfoText.Size = UDim2.new(1, -40, 1, -60)
InfoText.Font = Enum.Font.GothamBold
InfoText.Text = "Telegram: t.me/freedeltascripts"
InfoText.TextColor3 = Color3.fromRGB(0, 170, 255)
InfoText.TextSize = 16
InfoText.TextWrapped = true
InfoText.TextXAlignment = Enum.TextXAlignment.Center
InfoText.TextYAlignment = Enum.TextYAlignment.Center

local InfoSubText = Instance.new("TextLabel")
InfoSubText.Parent = InfoContent
InfoSubText.BackgroundTransparency = 1
InfoSubText.Position = UDim2.new(0, 20, 0, 70)
InfoSubText.Size = UDim2.new(1, -40, 0, 30)
InfoSubText.Font = Enum.Font.Gotham
InfoSubText.Text = "Fly: [F]  Noclip: [N]"
InfoSubText.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoSubText.TextSize = 12
InfoSubText.TextXAlignment = Enum.TextXAlignment.Center

-- ================= FLY FUNCTIONS =================

function enableFly()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    -- Clear old instances
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    if movementConnection then movementConnection:Disconnect() end
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = rootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    BodyGyro.D = 500
    BodyGyro.P = 5000
    BodyGyro.CFrame = rootPart.CFrame
    BodyGyro.Parent = rootPart
    
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    
    -- Movement loop
    movementConnection = RunService.RenderStepped:Connect(function()
        if not Flying then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        
        if root and BodyVelocity and BodyGyro then
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector * Vector3.new(1, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector * Vector3.new(1, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector * Vector3.new(1, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector * Vector3.new(1, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir + Vector3.new(0, -1, 0)
            end
            
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * FlySpeed
            else
                moveDir = Vector3.new(0, 0, 0)
            end
            
            BodyVelocity.Velocity = moveDir
            BodyGyro.CFrame = cam.CFrame
        end
    end)
end

function disableFly()
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
    if movementConnection then
        movementConnection:Disconnect()
        movementConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.AutoRotate = true
        end
    end
end

-- ================= NOCLIP LOOP =================

RunService.Stepped:Connect(function()
    if NoclipActive then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ================= KEYBINDS =================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        flyState = not flyState
        Flying = flyState
        if flyState then
            FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 70)
            FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            FlyBtn.Text = "Fly: ON"
            enableFly()
        else
            FlyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            FlyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            FlyBtn.Text = "Fly: OFF"
            disableFly()
        end
    end
    
    if input.KeyCode == Enum.KeyCode.N then
        noclipState = not noclipState
        NoclipActive = noclipState
        if noclipState then
            NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 70)
            NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            NoclipBtn.Text = "Noclip: ON"
        else
            NoclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            NoclipBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            NoclipBtn.Text = "Noclip: OFF"
        end
    end
end)

-- ================= CLEANUP =================

LocalPlayer.CharacterAdded:Connect(function()
    if Flying then
        disableFly()
        enableFly()
    end
end)

print("FlyAndNoclip Loaded!")
print("Telegram: t.me/freedeltascripts")
print("Keys: [F] Fly | [N] Noclip")
