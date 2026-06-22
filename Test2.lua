local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v4",
   LoadingTitle = "Modüller Yükleniyor...",
   LoadingSubtitle = "by MM2 Pro",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- Tab1: Helper Özellikleri
Tab1:CreateButton({ Name = "Full ESP (Fix)", Callback = function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            if p.Character:FindFirstChild("Knife") then h.FillColor = Color3.fromRGB(255, 0, 0) -- Murder Kırmızı
            elseif p.Character:FindFirstChild("Gun") then h.FillColor = Color3.fromRGB(0, 0, 255) -- Sheriff Mavi
            else h.FillColor = Color3.fromRGB(0, 255, 0) end -- Inno Yeşil
        end
    end
end})

local TriggerBotEnabled = false
Tab1:CreateToggle({ Name = "Trigger Bot", CurrentValue = false, Callback = function(Value)
    TriggerBotEnabled = Value
    game:GetService("RunService").Heartbeat:Connect(function()
        if TriggerBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Knife") and v.Character:FindFirstChild("HumanoidRootPart") then
                    game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(v.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart)
                end
            end
        end
    end)
end})

-- Tab2: Misc Özellikleri (Eskileri Korundu)
local FlingEnabled = false
Tab2:CreateToggle({ Name = "Touch Fling", CurrentValue = false, Callback = function(Value)
    FlingEnabled = Value
    if FlingEnabled then
        LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
            if FlingEnabled and hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= LocalPlayer.Name then
                hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9)
            end
        end)
    end
end})

local NoclipEnabled = false
Tab2:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(Value)
    NoclipEnabled = Value
    game:GetService("RunService").Stepped:Connect(function()
        if NoclipEnabled and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end})

local FlyEnabled = false
local bv = Instance.new("BodyVelocity")
Tab2:CreateToggle({ Name = "Fly (Uçuş)", CurrentValue = false, Callback = function(Value)
    FlyEnabled = Value
    if FlyEnabled then
        bv.Parent = LocalPlayer.Character.HumanoidRootPart
        bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        bv.Velocity = Vector3.new(0, 0, 0)
    else
        bv.Parent = nil
    end
end})

Tab2:CreateSlider({ Name = "Speed Hack", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value)
    LocalPlayer.Character.Humanoid.WalkSpeed = Value
end})

Tab2:CreateSlider({ Name = "Jump Power", Range = {50, 300}, Increment = 10, CurrentValue = 50, Callback = function(Value)
    LocalPlayer.Character.Humanoid.JumpPower = Value
end})
