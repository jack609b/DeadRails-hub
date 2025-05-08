--// AppleLib GUI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/destylol/applelib/main/main.lua"))()
local window = library:CreateWindow("Dead Rails Hub - AppleLib")

local main = window:CreateTab("Main")
local misc = window:CreateTab("Misc")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ws = workspace

-- 🧠 Anti Kick Nhẹ
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" and self == LocalPlayer then
        return
    end
    return oldNamecall(self, ...)
end)

-- ⚡ Gun Aura
local aura = false
main:AddToggle("Gun Aura", false, function(v)
    aura = v
    task.spawn(function()
        while aura do
            task.wait(0.1)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Team ~= LocalPlayer.Team then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Shoot") then
                        tool.Shoot:FireServer(plr.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end)
end)

-- 💰 Auto Collect Bond
local autoCollect = false
main:AddToggle("Auto Collect Bond", false, function(v)
    autoCollect = v
    task.spawn(function()
        while autoCollect do
            task.wait(1)
            for _, obj in pairs(ws:GetDescendants()) do
                if obj:IsA("TouchTransmitter") and obj.Parent:FindFirstChild("TouchInterest") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 1)
                end
            end
        end
    end)
end)

-- 👁 ESP
local esp = false
main:AddToggle("ESP", false, function(v)
    esp = v
    if esp then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and not plr.Character:FindFirstChild("NameESP") then
                local tag = Instance.new("BillboardGui", plr.Character)
                tag.Name = "NameESP"
                tag.Adornee = plr.Character:FindFirstChild("Head")
                tag.Size = UDim2.new(0, 100, 0, 20)
                tag.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", tag)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                txt.TextStrokeTransparency = 0
                txt.Text = plr.Name
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("NameESP") then
                plr.Character.NameESP:Destroy()
            end
        end
    end
end)

-- 🎥 Unlock Camera
main:AddButton("Unlock Camera", function()
    LocalPlayer.CameraMaxZoomDistance = 999
    LocalPlayer.CameraMinZoomDistance = 0
end)

-- 🌞 Full Bright
main:AddButton("Full Bright", function()
    local lighting = game:GetService("Lighting")
    lighting.Brightness = 2
    lighting.ClockTime = 12
    lighting.FogEnd = 100000
end)

-- 🪂 Infinite Jump
local infJump = false
main:AddToggle("Infinite Jump", false, function(v)
    infJump = v
end)

UserInputService.JumpRequest:Connect(function()
    if infJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 🏃 WalkSpeed
main:AddSlider("WalkSpeed", 16, 100, 16, function(value)
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
end)

-- 👻 NoClip
local noclip = false
main:AddToggle("NoClip", false, function(v)
    noclip = v
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

-- 🚀 Auto Win
main:AddButton("Auto Win (Bypass)", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:MoveTo(Vector3.new(9999, 100, 0)) -- Điều chỉnh tọa độ nếu cần
    end
end)

-- 🧬 Clone tự tấn công NPC đánh mình
misc:AddButton("Clone Auto Attack NPC", function()
    local clone = LocalPlayer.Character:Clone()
    clone.Name = "AttackClone"
    clone.Parent = workspace
    clone.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    clone.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local cTool = tool:Clone()
        cTool.Parent = clone
        cTool:Activate()
    end

    local attackedNPCs = {}
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").HealthChanged:Connect(function(hp)
        if hp < LocalPlayer.Character.Humanoid.MaxHealth then
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    if (npc.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 30 then
                        attackedNPCs[npc] = true
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            for npc, _ in pairs(attackedNPCs) do
                if npc:FindFirstChild("HumanoidRootPart") and clone then
                    clone:MoveTo(npc.HumanoidRootPart.Position)
                end
            end
        end
    end)
end)

-- 🔚 Khởi tạo GUI
library:Init()
