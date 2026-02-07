--[[
    Escape Tsunami For Brainrots - Final Hub V4
    Features:
    - Ultra Aggressive Collection
    - Remote Event Sniping
    - Draggable GUI (CoreGui)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local autoCollectEnabled = false

-- Cleanup old GUI if it exists
if CoreGui:FindFirstChild("BrainrotHubFinal") then
    CoreGui.BrainrotHubFinal:Destroy()
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHubFinal"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 70)
mainFrame.Position = UDim2.new(0.5, -90, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "BRAINROT HUB V4"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.5, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toggleButton.Text = "Auto-Collect: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 5)
btnCorner.Parent = toggleButton

-- Toggle Logic
toggleButton.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    if autoCollectEnabled then
        toggleButton.Text = "Auto-Collect: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
    else
        toggleButton.Text = "Auto-Collect: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

-- Find the player's collector pad
local function getCollector()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
            if v.Name:lower():find("collect") or v.Parent.Name:lower():find("collect") then
                -- Check distance to player's base (optional)
                return v
            end
        end
    end
    return nil
end

-- Main Loop
task.spawn(function()
    while true do
        if autoCollectEnabled then
            pcall(function()
                -- Method 1: Remote Events (Fastest)
                local remotes = {"CollectMoney", "CollectCash", "CollectBrainrots", "Collect"}
                for _, name in ipairs(remotes) do
                    local remote = ReplicatedStorage:FindFirstChild(name)
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    end
                end

                -- Method 2: firetouchinterest (Fallback)
                local collector = getCollector()
                if collector and firetouchinterest then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(collector, character.HumanoidRootPart, 0)
                        firetouchinterest(collector, character.HumanoidRootPart, 1)
                    end
                end

                -- Method 3: Pick up physical drops in the workspace
                for _, v in pairs(Workspace:GetChildren()) do
                    if v:IsA("BasePart") and (v.Name == "Part" or v.Name == "Brainrot") and v:FindFirstChild("TouchInterest") then
                        if firetouchinterest then
                            firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart, 0)
                            firetouchinterest(v, LocalPlayer.Character.HumanoidRootPart, 1)
                        end
                    end
                end
            end)
        end
        task.wait(0.1) -- Very high frequency
    end
end)

print("Brainrot Hub V4 Loaded.")
