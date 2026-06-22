local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultimate Panel",
   LoadingTitle = "Yükleniyor...",
   LoadingSubtitle = "",
   ConfigurationSaving = { Enabled = false }
})

local Tab1 = Window:CreateTab("Murderer & Helper")
local Tab2 = Window:CreateTab("Misc")

-- 1. ESP (Kapatınca Temizlenen)
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
                h.Adornee = p.Character
                if p.Character:FindFirstChild("Knife") then h.FillColor = Color3.fromRGB(255, 0, 0)
                elseif p.Character:FindFirstChild("Gun") then h.FillColor = Color3.fromRGB(0, 0, 255)
                else h.FillColor = Color3.fromRGB(0, 255, 0) end
            end
        end
    end
end)

-- 2. AIMLOCK
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
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)

-- 3. GRAB GUN
Tab1:CreateButton({ Name = "Grab Gun", Callback = function()
    local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
    if gun then LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end})

-- 4. MISC (TÜMÜ)
Tab2:CreateToggle({ Name = "Touch Fling", CurrentValue = false, Callback = function(Value)
    if Value then
        LocalPlayer.Character.HumanoidRootPart.Touched:Connect(function(hit)
            if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= LocalPlayer.Name then hit.Parent.HumanoidRootPart.Velocity = Vector3.new(9e9, 9e9, 9e9) end
        end)
    end
end})

Tab2:CreateToggle({ Name = "No Clip", CurrentValue = false, Callback = function(Value)
    local conn
    if Value then
        conn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end)
    else
        if conn then conn:Disconnect() end
    end
end})

Tab2:CreateSlider({ Name = "Speed Hack", Range = {16, 100}, Increment = 1, CurrentValue = 16, Callback = function(Value)
    LocalPlayer.Character.Humanoid.WalkSpeed = Value
end})
