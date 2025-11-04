--// reflex aim trainer script \\--
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local TargetsFolder = workspace:WaitForChild("Targets")
local RageSettings = {Enabled = false}
local Settings = {Enabled = false, Smooth = 55, FOV = 800}
local function getBalloons()
    local balloons = {}
    for _,obj in ipairs(TargetsFolder:GetChildren()) do
        if obj:IsA("BasePart") then
            table.insert(balloons, obj)
        elseif obj:IsA("Model") then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then table.insert(balloons, part) end
        end
    end
    return balloons
end
local function chooseTarget(candidates)
    local best, bestDist
    local mx,my = Mouse.X, Mouse.Y
    for _,p in ipairs(candidates) do
        local screenPos, onScreen = Camera:WorldToViewportPoint(p.Position)
        if onScreen then
            local dx,dy = screenPos.X-mx, screenPos.Y-my
            local dist = math.sqrt(dx*dx+dy*dy)
            if RageSettings.Enabled then if not bestDist or dist<bestDist then best, bestDist = p, dist end else if (not bestDist or dist<bestDist) and dist <= Settings.FOV then best, bestDist = p, dist end end
        end
    end
    return best
end
local function aimAt(part, dt)
    local camPos = Camera.CFrame.Position
    local goal = CFrame.new(camPos, part.Position)
    local smoothing = math.max(1, Settings.Smooth)
    local alpha = math.clamp(dt * (200 / smoothing), 0, 1)
    Camera.CFrame = Camera.CFrame:Lerp(goal, alpha)
end
RunService.RenderStepped:Connect(function(dt)
    local target = chooseTarget(getBalloons())
    if RageSettings.Enabled and target then
        local camPos = Camera.CFrame.Position
        local goal = CFrame.new(camPos, target.Position)
        Camera.CFrame = goal
    elseif Settings.Enabled and target then
        aimAt(target, dt)
    end
end)
local Window = Rayfield:CreateWindow({
   Name = "Catflex",
   Icon = 0,
   LoadingTitle = "cats",
   LoadingSubtitle = "3 days for aimbot",
   ShowText = "",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "cathub",
      FileName = "catflex"
   },
   KeySystem = false,
})
local AimTab = Window:CreateTab("Legitbot")
local LegitBotToggle = AimTab:CreateToggle({
    Name = "Enable Legitbot",
    CurrentValue = Settings.Enabled,
    Flag = "enable_legitbot",
    Callback = function(Value)
        Settings.Enabled = Value
    end,
})
local SmoothSlider = AimTab:CreateSlider({
    Name = "Smoothness",
    Range = {1, 111},
    Increment = 1,
    CurrentValue = Settings.Smooth,
    Suffix = "",
    Flag = "smoothness_slider",
    Callback = function(Value)
        Settings.Smooth = Value
    end,
})
local FOVSlider = AimTab:CreateSlider({
    Name = "FOV",
    Range = {50, 800},
    Increment = 10,
    CurrentValue = Settings.FOV,
    Suffix = "USE EIGHT HUNDRED",
    Flag = "fov_slider",
    Callback = function(Value)
        Settings.FOV = Value
    end,
})
local RageTab = Window:CreateTab("RageBot")
local RageBotToggle = RageTab:CreateToggle({
    Name = "Enable Ragebot",
    CurrentValue = RageSettings.Enabled,
    Flag = "enable_ragebot",
    Callback = function(Value)
        RageSettings.Enabled = Value
    end,
})

Rayfield:LoadConfiguration()
