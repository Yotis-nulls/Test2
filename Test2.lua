local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v6",
   LoadingTitle = "Modüller Yükleniyor...",
   LoadingSubtitle = "by MM2 Pro",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- ESP (Sürekli Güncellenen)
local ESPEnabled = false
Tab1:CreateToggle({ Name = "Full ESP (Sürekli)", CurrentValue = false, Callback = function(Value)
    ESPEnabled = Value
    while ESPEnabled do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.Adornee = p.Character
                h.FillTransparency = 0.5
                h.OutlineTransparency = 0
                
                -- Rol Kontrolü (En Güncel Yöntem)
                local backpack = p:FindFirstChildOfClass("Backpack")
                local characterItems = p.Character:GetChildren()
                
                local isMurderer = false
                local isSheriff = false
                
                for _, item in ipairs(characterItems) do
                    if item.Name == "Knife" or item:IsA("Tool") and item.Name:lower():find("knife") or item:IsA("Tool") and item:FindFirstChild("Handle") and item.Handle:FindFirstChild("TouchInterest") then
                        -- Bıçak kontrolü (Basitleştirilmiş)
                        isMurderer = true
                    elseif item.Name == "Gun" then
                        isSheriff = true
                    end
                end
                
                if isMurderer then 
                    h.FillColor = Color3.fromRGB(255, 0, 0) -- Murder Kırmızı
                elseif isSheriff then 
                    h.FillColor = Color3.fromRGB(0, 0, 255) -- Sheriff Mavi
                else 
                    h.FillColor = Color3.fromRGB(0, 255, 0) -- Inno Yeşil
                end
            end
        end
        task.wait(1)
    end
    -- Kapandığında temizle
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
    end
end})

-- DÜZELTİLMİŞ VE GÜÇLENDİRİLMİŞ TRIGGER BOT
local TriggerBotEnabled = false
Tab1:CreateToggle({ 
   Name = "Trigger Bot (Otomatik Vur)", 
   CurrentValue = false, 
   Callback = function(Value)
      TriggerBotEnabled = Value
      
      if TriggerBotEnabled then
         task.spawn(function()
            while TriggerBotEnabled do
               local lp = LocalPlayer
               -- Elinde silah olup olmadığını kontrol et
               if lp.Character and lp.Character:FindFirstChild("Gun") then
                  for _, v in pairs(Players:GetPlayers()) do
                     if v ~= lp and v.Character then
                        -- Bıçağı olan veya Murderer potansiyeli olan kişiyi tespit et
                        if v.Character:FindFirstChild("Knife") or (v.Backpack and v.Backpack:FindFirstChild("Knife")) then
                           local rootPart = v.Character:FindFirstChild("HumanoidRootPart")
                           local shootRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Shoot", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Shoot")
                           
                           if shootRemote and rootPart then
                              shootRemote:FireServer(rootPart.Position, rootPart)
                           end
                        end
                     end
                  end
               end
               task.wait(0.1) -- Sunucuyu yormamak için 0.1 saniyelik döngü
            end
         end)
      end
   end
})

-- Misc (Eskileri Korundu)
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
