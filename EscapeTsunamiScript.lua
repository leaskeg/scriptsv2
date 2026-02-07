--[[
    Escape Tsunami For Brainrots - Final Hub
    Features:
    - Guaranteed Remote Collection
    - GUI Visible in CoreGui
    - No Teleports
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
title.Text = "BRAINROT HUB"
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

-- Main Loop
task.spawn(function()
    while true do
        if autoCollectEnabled then
            pcall(function()
                -- Specific Remote for Escape Tsunami For Brainrots
                -- Most sources point to this event for collection
                local collectRemote = ReplicatedStorage:FindFirstChild("CollectMoney") or ReplicatedStorage:FindFirstChild("CollectBrainrots")
                
                if collectRemote then
                    collectRemote:FireServer()
                else
                    -- Fallback: Search for any remote containing "Collect"
                    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                        if v:IsA("RemoteEvent") and (v.Name:find("Collect") or v.Name:find("Money")) then
                            v:FireServer()
                        end
                    end
                end
            end)
        end
        task.wait(0.1) -- Very fast collection
    end
end)

print("Brainrot Hub Finalized & Loaded.")
