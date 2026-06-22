-- Yükleme ekranı yok, direkt panel açılacak
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v9",
   LoadingTitle = "Yükleniyor...", -- Burayı çok basit tuttuk
   LoadingSubtitle = "",
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
    if TriggerBotEnabled then
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("Gun") then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if v:FindFirstChild("Murderer") or (v.Backpack and v.Backpack:FindFirstChild("Knife")) then
                        local shoot = game:GetService("ReplicatedStorage"):FindFirstChild("Shoot", true)
                        if shoot then shoot:FireServer(v.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart) end
                    end
                end
            end
        end
    end
end)

-- Basit bir butonla kontrol (Ekran açılmazsa en azından bildirim alalım)
Tab1:CreateButton({ Name = "Test Bildirimi", Callback = function()
    Rayfield:Notify({Title = "Başarılı", Content = "Script çalışıyor!", Duration = 5})
end})

Rayfield:LoadConfiguration()
