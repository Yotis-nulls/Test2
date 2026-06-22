-- Garanti Yükleme Koruması
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v8",
   LoadingTitle = "Ostam Sunar :D",
   LoadingSubtitle = "Yükleniyor...",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- Trigger Bot
local TriggerBotEnabled = false
Tab1:CreateToggle({ Name = "Trigger Bot", CurrentValue = false, Callback = function(Value)
    TriggerBotEnabled = Value
end})

game:GetService("RunService").Heartbeat:Connect(function()
    if TriggerBotEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Gun") then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if v:FindFirstChild("Murderer") or (v.Backpack and v.Backpack:FindFirstChild("Knife")) then
                    local shoot = game:GetService("ReplicatedStorage"):FindFirstChild("Shoot", true)
                    if shoot then shoot:FireServer(v.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart) end
                end
            end
        end
    end
end)

-- Diğer özellikler (ESP, Fling vs.)
Tab1:CreateButton({ Name = "Grab Gun", Callback = function()
    local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
    if gun then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end})

-- Basit ESP
Tab1:CreateToggle({ Name = "Full ESP", CurrentValue = false, Callback = function(Value)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.Enabled = Value
            h.FillColor = Color3.fromRGB(255, 255, 255)
        end
    end
end})

Tab2:CreateSlider({ Name = "Speed Hack", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end})

Rayfield:LoadConfiguration()
