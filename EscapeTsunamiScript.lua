--[[
    Escape Tsunami For Brainrots - Advanced Auto Collect with GUI
    Features:
    - Simple GUI Toggle
    - Auto Collect Money (No Teleport)
    - Multi-Floor Support (House detection)
    - Auto Tycoon Detection
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local autoCollectEnabled = false

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 50)
mainFrame.Position = UDim2.new(0.5, -75, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -10, 1, -10)
toggleButton.Position = UDim2.new(0, 5, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.Text = "Auto-Collect: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Parent = mainFrame

toggleButton.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    if autoCollectEnabled then
        toggleButton.Text = "Auto-Collect: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleButton.Text = "Auto-Collect: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Function to find the player's tycoon/house
local function getPlayerTycoon()
    local tycoons = Workspace:FindFirstChild("Tycoons") or Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Houses")
    if not tycoons then return nil end

    for _, tycoon in pairs(tycoons:GetChildren()) do
        local owner = tycoon:FindFirstChild("Owner") or tycoon:GetAttribute("Owner")
        if (owner and (owner == LocalPlayer.Name or owner == tostring(LocalPlayer.UserId))) or tycoon.Name:find(LocalPlayer.Name) then
            return tycoon
        end
    end
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:find("Tycoon") and obj:FindFirstChild("Owner") and (obj.Owner.Value == LocalPlayer or obj.Owner.Value == LocalPlayer.Name) then
            return obj
        end
    end
    return nil
end

-- Function to collect money using firetouchinterest
local function autoCollect()
    if not autoCollectEnabled then return end
    
    local tycoon = getPlayerTycoon()
    if not tycoon then return end

    for _, obj in pairs(tycoon:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Collector" or obj.Name == "Collect" or obj.Name == "CollectionPad") then
            local touchInterest = obj:FindFirstChildOfClass("TouchInterest")
            if touchInterest and firetouchinterest then
                firetouchinterest(obj, LocalPlayer.Character.PrimaryPart, 0)
                firetouchinterest(obj, LocalPlayer.Character.PrimaryPart, 1)
            end
        end
    end

    local drops = Workspace:FindFirstChild("Drops") or Workspace:FindFirstChild("Coins") or Workspace:FindFirstChild("Brainrots")
    if drops then
        for _, drop in pairs(drops:GetChildren()) do
            if drop:IsA("BasePart") and firetouchinterest then
                firetouchinterest(drop, LocalPlayer.Character.PrimaryPart, 0)
                firetouchinterest(drop, LocalPlayer.Character.PrimaryPart, 1)
            end
        end
    end
end

-- Main Loop
print("Script Loaded: Brainrot Hub Active")
while true do
    if autoCollectEnabled then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                autoCollect()
            end
        end)
    end
    task.wait(0.5)
end
