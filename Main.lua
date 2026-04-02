-- [[ MONEHUB Z-SELECTOR v23.0 : FIXED SOURCE ]]
-- 外部読み込みを排除し、このファイルだけでUIが起動するように修正

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- --- CONFIGURATION ---
_G.MoneConfig = {
    AutoGrab = false,
    Speed = false,
    Devourer = false,
    ESP = false,
    Autoplay = false,
    WalkSpeed = 31,
    GrabRange = 25,
    Minimized = false
}

-- --- UI START ---
local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 380); Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Neon = Instance.new("UIStroke", Main)
Neon.Thickness = 3; Neon.Color = Color3.fromRGB(255, 0, 60); Neon.ApplyStrokeMode = "Border"

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 45); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "MONEHUB Z"; Title.TextColor3 = Color3.fromRGB(255, 0, 60); Title.Font = "GothamBlack"; Title.TextSize = 18; Title.TextXAlignment = "Left"; Title.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, 0, 1, -50); Container.Position = UDim2.new(0, 0, 0, 50); Container.BackgroundTransparency = 1

local function AddToggleBtn(name, y, configKey)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -24, 0, 45); btn.Position = UDim2.new(0, 12, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    btn.Font = "GothamBold"; btn.TextSize = 12; Instance.new("UICorner", btn)
    local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 2; stroke.Color = Color3.fromRGB(45, 45, 45)
    btn.MouseButton1Click:Connect(function()
        _G.MoneConfig[configKey] = not _G.MoneConfig[configKey]
        local isON = _G.MoneConfig[configKey]
        btn.Text = name .. (isON and ": ON" or ": OFF")
        btn.TextColor3 = isON and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
        stroke.Color = isON and Color3.fromRGB(255, 0, 60) or Color3.fromRGB(45, 45, 45)
    end)
end

AddToggleBtn("AUTO GRAB", 10, "AutoGrab")
AddToggleBtn("SPEED BOOSTER", 65, "Speed")
AddToggleBtn("FPS DEVOURER", 120, "Devourer")
AddToggleBtn("AUTO PLAY", 175, "Autoplay")
AddToggleBtn("ESP & HITBOX", 230, "ESP")

-- --- FUNCTIONS ---
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if _G.MoneConfig.Speed and char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            local dir = hum.MoveDirection
            if dir.Magnitude > 0.1 then
                hrp.AssemblyLinearVelocity = Vector3.new(dir.Unit.X * _G.MoneConfig.WalkSpeed, hrp.AssemblyLinearVelocity.Y, dir.Unit.Z * _G.MoneConfig.WalkSpeed)
            end
        end
        if _G.MoneConfig.AutoGrab and hrp then
            for _, obj in pairs(game.Workspace:GetChildren()) do
                if obj.Name == "Brainrot" or obj:FindFirstChild("Brain") then
                    local target = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if target and (hrp.Position - target.Position).Magnitude <= _G.MoneConfig.GrabRange then
                        firetouchinterest(hrp, target, 0); task.wait(); firetouchinterest(hrp, target, 1)
                    end
                end
            end
        end
    end)
end)

print("✅ MONEHUB Z v23.0: UI INJECTED.")
