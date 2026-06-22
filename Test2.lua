local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({ Name = "MM2 Ultimate Panel v12", LoadingTitle = "Modüller Yükleniyor...", ConfigurationSaving = { Enabled = false } })

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- 1. MEVLANA + SPEED (Eski sistemle birleşik)
local MevlanaEnabled = false
Tab1:CreateToggle({ Name = "Mevlana + Speed", CurrentValue = false, Callback = function(Value)
    MevlanaEnabled = Value
    LocalPlayer.Character.Humanoid.WalkSpeed = Value and 35 or 16
end})

RunService.RenderStepped:Connect(function()
    if MevlanaEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)

-- 2. ESP (Kapanabilen)
local ESPEnabled = false
Tab1:CreateToggle({ Name = "Full ESP", CurrentValue = false, Callback = function(Value)
    ESPEnabled = Value
    if not ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
        end
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
end})

-- 4. MISC (Fling, Noclip)
Tab2:CreateToggle({ Name = "Touch Fling", CurrentValue = false, Callback = function(Value)
    if Value then
        LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= LocalPlayer.Name then hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9) end
        end)
    end
end})

Tab2:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(Value)
    RunService.Stepped:Connect(function() 
        if Value and LocalPlayer.Character then 
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end 
        end 
    end)
end})
