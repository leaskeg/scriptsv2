--[[
    Escape Tsunami For Brainrots - Advanced Hub
    Features:
    - Auto Collect (Remote & Touch)
    - Auto Tycoon Detection
    - Draggable GUI
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local autoCollectEnabled = false

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHubV2"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 80)
mainFrame.Position = UDim2.new(0.5, -100, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "ETFB Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 35)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
toggleButton.Text = "Auto-Collect: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

toggleButton.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    if autoCollectEnabled then
        toggleButton.Text = "Auto-Collect: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        print("Auto-Collect Started")
    else
        toggleButton.Text = "Auto-Collect: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        print("Auto-Collect Stopped")
    end
end)

-- Function to find the player's tycoon/house
local function getPlayerTycoon()
    -- Check common tycoon containers
    local containers = {Workspace:FindFirstChild("Tycoons"), Workspace:FindFirstChild("Plots"), Workspace:FindFirstChild("Houses"), Workspace}
    
    for _, folder in pairs(containers) do
        if folder then
            for _, tycoon in pairs(folder:GetChildren()) do
                -- Check Owner value
                local ownerValue = tycoon:FindFirstChild("Owner")
                if ownerValue and (ownerValue.Value == LocalPlayer or ownerValue.Value == LocalPlayer.Name or ownerValue.Value == tostring(LocalPlayer.UserId)) then
                    return tycoon
                end
                -- Check Attributes
                if tycoon:GetAttribute("Owner") == LocalPlayer.UserId or tycoon:GetAttribute("Owner") == LocalPlayer.Name then
                    return tycoon
                end
                -- Check Name
                if tycoon.Name:find(LocalPlayer.Name) then
                    return tycoon
                end
            end
        end
    end
    return nil
end

-- Collection Logic
local function collect()
    if not autoCollectEnabled then return end
    
    local tycoon = getPlayerTycoon()
    if not tycoon then return end

    -- Method 1: Fire Touch Interests
    for _, obj in pairs(tycoon:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:find("Collect") or obj.Name:find("Collector") or obj.Name:find("Bank")) then
            if obj:FindFirstChildOfClass("TouchInterest") and firetouchinterest then
                firetouchinterest(obj, LocalPlayer.Character.PrimaryPart, 0)
                firetouchinterest(obj, LocalPlayer.Character.PrimaryPart, 1)
            end
        end
    end

    -- Method 2: Fire Common Remotes (Game-specific)
    -- We'll try to find a RemoteEvent that handles collection
    local remotes = {
        ReplicatedStorage:FindFirstChild("CollectMoney"),
        ReplicatedStorage:FindFirstChild("CollectCash"),
        ReplicatedStorage:FindFirstChild("Collect"),
        tycoon:FindFirstChild("Collect", true)
    }

    for _, remote in pairs(remotes) do
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer()
        end
    end

    -- Method 3: Drops
    local drops = Workspace:FindFirstChild("Drops") or Workspace:FindFirstChild("Coins")
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
task.spawn(function()
    while true do
        if autoCollectEnabled then
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    collect()
                end
            end)
        end
        task.wait(0.2) -- Faster checking
    end
end)

print("Brainrot Hub V2 Loaded!")
