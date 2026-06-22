local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel v3",
   LoadingTitle = "Modüller Yükleniyor...",
   LoadingSubtitle = "by MM2 Pro",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- Tab1: Helper Özellikleri
Tab1:CreateButton({ Name = "Full ESP (Murder/Sheriff/Innocent)", Callback = function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local h = Instance.new("Highlight", p.Character)
            if p.Character:FindFirstChild("Knife") then h.FillColor = Color3.fromRGB(255, 0, 0)
            elseif p.Character:FindFirstChild("Gun") then h.FillColor = Color3.fromRGB(0, 0, 255)
            else h.FillColor = Color3.fromRGB(0, 255, 0) end
        end
    end
end})

local TriggerBotEnabled = false
Tab1:CreateToggle({
   Name = "Trigger Bot (Otomatik Vur)",
   CurrentValue = false,
   Callback = function(Value)
      TriggerBotEnabled = Value
      if TriggerBotEnabled then
         game:GetService("RunService").Heartbeat:Connect(function()
            if not TriggerBotEnabled then return end
            local lp = game.Players.LocalPlayer
            if lp.Character and lp.Character:FindFirstChild("Gun") then
               for _, v in pairs(game.Players:GetPlayers()) do
                  if v.Character and v.Character:FindFirstChild("Knife") and v.Character:FindFirstChild("HumanoidRootPart") then
                     game:GetService("ReplicatedStorage").Remotes.Shoot:FireServer(v.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart)
                  end
               end
            end
         end)
      end
   end
})

-- Tab2: Misc (Toggle Özellikleri)
local FlingEnabled = false
Tab2:CreateToggle({
   Name = "Touch Fling (Dokununca Uçur)",
   CurrentValue = false,
   Callback = function(Value)
      FlingEnabled = Value
      if FlingEnabled then
         game.Players.LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
            if FlingEnabled and hit.Parent:FindFirstChild("Humanoid") then
               hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9)
            end
         end)
      end
   end
})

local NoclipEnabled = false
Tab2:CreateToggle({
   Name = "No Clip (Duvarlardan Geç)",
   CurrentValue = false,
   Callback = function(Value)
      NoclipEnabled = Value
      game:GetService("RunService").Stepped:Connect(function()
         if NoclipEnabled and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end
})

local FlyEnabled = false
Tab2:CreateToggle({
   Name = "Fly (Uçuş Modu)",
   CurrentValue = false,
   Callback = function(Value)
      FlyEnabled = Value
      local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
      hrp.Anchored = FlyEnabled
   end
})

Tab2:CreateSlider({ Name = "Speed Hack", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end})

Tab2:CreateSlider({ Name = "Jump Power", Range = {50, 300}, Increment = 10, CurrentValue = 50, Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end})
