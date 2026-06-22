local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. ADIM: ÖZEL YÜKLEME EKRANI
local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v7",
   LoadingTitle = "Ostam Sunar :D",
   LoadingSubtitle = "Modüller Yükleniyor...",
   ConfigurationSaving = { Enabled = false }
})

-- 2. ADIM: ASIL PANELİN (GUI) YÜKLENMESİ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- ESP, Trigger, GrabGun, Fling vs. kodlarının tamamı burada olacak
-- (Senin önceki kodlarındaki tüm fonksiyonları aşağıya ekliyoruz)

local ESPEnabled = false
Tab1:CreateToggle({ Name = "Full ESP (Sürekli)", CurrentValue = false, Callback = function(Value)
    ESPEnabled = Value
    while ESPEnabled do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.Adornee = p.Character
                h.FillColor = p:FindFirstChild("Murderer") and Color3.fromRGB(255, 0, 0) or p:FindFirstChild("Sheriff") and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(0, 255, 0)
            end
        end
        task.wait(1)
    end
end})

Tab1:CreateButton({ Name = "Grab Gun", Callback = function()
    local gun = workspace:FindFirstChild("GunDrop")
    if gun then LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end})

local TriggerBotEnabled = false
Tab1:CreateToggle({ Name = "Trigger Bot", CurrentValue = false, Callback = function(Value) TriggerBotEnabled = Value end})
game:GetService("RunService").Heartbeat:Connect(function()
    if TriggerBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v:FindFirstChild("Murderer") then
                game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(v.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart)
            end
        end
    end
end})

-- Misc (Fling, Noclip, Fly)
Tab2:CreateToggle({ Name = "Touch Fling", CurrentValue = false, Callback = function(Value) 
    LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
        if Value and hit.Parent:FindFirstChild("Humanoid") then hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9) end
    end)
end})

Tab2:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(Value)
    game:GetService("RunService").Stepped:Connect(function()
        if Value and LocalPlayer.Character then for _,v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end)
end})

Tab2:CreateSlider({ Name = "Speed", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value) LocalPlayer.Character.Humanoid.WalkSpeed = Value end})

Rayfield:LoadConfiguration()
