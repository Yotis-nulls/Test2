local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v14",
   LoadingTitle = "Modüller Yükleniyor...",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- 1. ESP (Oyuncu + Silah)
local ESPEnabled = false
Tab1:CreateToggle({ Name = "Full ESP (Oyuncu + Silah)", CurrentValue = false, Callback = function(Value) ESPEnabled = Value end})

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.Adornee = p.Character
                h.FillColor = p.Character:FindFirstChild("Knife") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            end
        end
        local gun = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        if gun and not gun:FindFirstChild("Highlight") then
            local h = Instance.new("Highlight", gun)
            h.FillColor = Color3.fromRGB(255, 255, 0)
        end
    else
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
        local gun = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        if gun and gun:FindFirstChild("Highlight") then gun.Highlight:Destroy() end
    end
end)

-- 2. AUTO TP & GRAB GUN
local AutoTPGun = false
Tab1:CreateToggle({ Name = "Auto TP to Gun", CurrentValue = false, Callback = function(Value) AutoTPGun = Value end})

Tab1:CreateButton({ Name = "Grab Gun (Manuel)", Callback = function()
    local gun = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
    if gun then LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end})

RunService.RenderStepped:Connect(function()
    if AutoTPGun then
        local gun = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        if gun and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame
        end
    end
end)

-- 3. AIMLOCK
local AimlockEnabled = false
Tab1:CreateToggle({ Name = "Aimlock (Murderer)", CurrentValue = false, Callback = function(Value) AimlockEnabled = Value end})

RunService.RenderStepped:Connect(function()
    if AimlockEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        local target = nil
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Knife") then
                target = v.Character:FindFirstChild("HumanoidRootPart")
            end
        end
        if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position) end
    end
end)

-- 4. MISC
Tab2:CreateToggle({ Name = "Touch Fling", CurrentValue = false, Callback = function(Value)
    if Value then
        LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= LocalPlayer.Name then hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9) end
        end)
    end
end})

Tab2:CreateSlider({ Name = "Speed", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value) LocalPlayer.Character.Humanoid.WalkSpeed = Value end})
