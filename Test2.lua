local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({ Name = "MM2 Ultimate Panel v11", LoadingTitle = "Modüller Yükleniyor...", ConfigurationSaving = { Enabled = false } })
local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- 1. MEVLANA + SPEED + AIM KORUMASI
local MevlanaEnabled = false
Tab1:CreateToggle({ Name = "Mevlana (Spinbot) + Speed", CurrentValue = false, Callback = function(Value)
    MevlanaEnabled = Value
    LocalPlayer.Character.Humanoid.WalkSpeed = Value and 35 or 16
end})

RunService.RenderStepped:Connect(function()
    if MevlanaEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Mevlana Döngüsü
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
        
        -- Aim'i düz tutmak için Camera'yı sabitle
        if LocalPlayer.Character:FindFirstChild("Gun") then
            -- Burada kamera kilitli kalır, silah sağa sola sapmaz
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame
        end
    end
end)

-- 2. DÜZELTİLMİŞ ESP
local ESPEnabled = false
Tab1:CreateToggle({ Name = "Full ESP", CurrentValue = false, Callback = function(Value)
    ESPEnabled = Value
    if not ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
    end
end})

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.FillColor = p.Character:FindFirstChild("Knife") and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            end
        end
    end
end)

-- 3. GRAB GUN
Tab1:CreateButton({ Name = "Grab Gun", Callback = function()
    local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
    if gun then LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end)
   
