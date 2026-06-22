local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel",
   LoadingTitle = "Modüller Yükleniyor...",
   LoadingSubtitle = "by MM2 Pro",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- 1. SÜRÜKLENEBİLİR ATEŞ ET BUTONU
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local FireButton = Instance.new("TextButton", ScreenGui)
FireButton.Size = UDim2.new(0, 120, 0, 50)
FireButton.Position = UDim2.new(0.5, 0, 0.8, 0)
FireButton.Text = "ATEŞ ET"
FireButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FireButton.Draggable = true
FireButton.Visible = false

FireButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Knife") then
                local shootRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Shoot", true)
                if shootRemote then shootRemote:FireServer(v.Character.HumanoidRootPart.Position, v.Character.HumanoidRootPart) end
            end
        end
    end
end)

Tab1:CreateToggle({ Name = "Ateş Et Butonunu Göster", CurrentValue = false, Callback = function(Value) FireButton.Visible = Value end})

-- 2. ESP ve GRAB GUN
Tab1:CreateToggle({ Name = "Full ESP", CurrentValue = false, Callback = function(Value)
    while Value do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                if p.Character:FindFirstChild("Knife") then h.FillColor = Color3.fromRGB(255, 0, 0)
                elseif p.Character:FindFirstChild("Gun") then h.FillColor = Color3.fromRGB(0, 0, 255)
                else h.FillColor = Color3.fromRGB(0, 255, 0) end
            end
        end
        task.wait(1)
    end
    for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
end})

Tab1:CreateButton({ Name = "Grab Gun", Callback = function()
    local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
    if gun then LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end})

-- 3. MISC TAB (Fling, Noclip, Fly, Speed)
Tab2:CreateToggle({ Name = "Touch Fling", CurrentValue = false, Callback = function(Value)
    if Value then
        LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= LocalPlayer.Name then hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9) end
        end)
    end
end})

Tab2:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(Value)
    game:GetService("RunService").Stepped:Connect(function() if Value and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
end})

Tab2:CreateToggle({ Name = "Fly (Uçuş)", CurrentValue = false, Callback = function(Value)
    local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
    bv.Name = "FlyBV"
    bv.MaxForce = Value and Vector3.new(1/0, 1/0, 1/0) or Vector3.new(0, 0, 0)
    bv.Velocity = Vector3.new(0, 0, 0)
end})

Tab2:CreateSlider({ Name = "Speed Hack", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value) LocalPlayer.Character.Humanoid.WalkSpeed = Value end})
