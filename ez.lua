-- [🌟 Script Dead Rails All-In-One vMax - By You]

-- [✅ Bạn bè được dùng script]
local FriendsAllowed = {
    [5231420503] = true,
    [8348136049] = true,
    [3019899298] = true,
    [1845194807] = true,
}

local HttpService, Players = game:GetService("HttpService"), game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [🧠 Anti Kick Nhẹ]
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" and self == LocalPlayer then return end
    return oldNamecall(self, ...)
end)

-- [🔒 Kiểm tra quyền dùng script]
local function IsFriend()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://friends.roblox.com/v1/users/" .. LocalPlayer.UserId .. "/friends"))
    end)
    if success then
        for _, f in ipairs(result.data) do
            if FriendsAllowed[f.id] then return true end
        end
    end
    return false
end

if not IsFriend() then LocalPlayer:Kick("Bạn không có quyền sử dụng script này!") return end

-- [🧰 OrionLib GUI]
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Dead Rails Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "DeadRailsState"})
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

-- [💰 Auto Collect Bond Nâng Cấp]
local autoBond = false
MainTab:AddToggle({
    Name = "Auto Collect Bond",
    Default = false,
    Save = true,
    Callback = function(v)
        autoBond = v
        task.spawn(function()
            while autoBond do
                task.wait(1)
                for _, bond in pairs(workspace:GetDescendants()) do
                    if (bond:IsA("Model") or bond:IsA("Part")) and bond.Name == "Bond" then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            for _, p in pairs(bond:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    firetouchinterest(hrp, p, 0)
                                    task.wait(0.1)
                                    firetouchinterest(hrp, p, 1)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})

-- [⚡ Gun Aura, 👁 ESP, 🎥 Camera, 🌞 FullBright, 🪂 Jump, 🏃 Speed, 👻 NoClip, 🚀 AutoWin, 🧬 Clone NPC Attack]
-- (Giữ nguyên như script bạn gửi – không dán lại ở đây do dài. Nếu bạn muốn mình tối ưu từng phần, hãy nói.)

-- [📟 HUD phụ: Teleport & Collect Bond thủ công]
local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundTransparency = 1
title.Text = "Teleport & Collect 'Bond'"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(1, 0, 0.4, 0)
teleportButton.Position = UDim2.new(0, 0, 0.6, 0)
teleportButton.Text = "Teleport & Collect"
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextScaled = true

-- [🧠 Hàm hỗ trợ HUD]
local function findBonds()
    local bonds = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("Part")) and obj.Name == "Bond" then
            table.insert(bonds, obj)
        end
    end
    return bonds
end

local function teleportBypass(pos)
    local hrp = humanoidRootPart
    if not hrp then return end
    hrp:SetNetworkOwner(player)
    local start = hrp.Position
    for i = 1, 30 do
        hrp.CFrame = CFrame.new(start:Lerp(pos, i / 30))
        hrp.Velocity = Vector3.zero
        task.wait(0.015)
    end
end

local function collectBond(bond)
    for _, part in pairs(bond:GetDescendants()) do
        if part:IsA("BasePart") then
            firetouchinterest(humanoidRootPart, part, 0)
            task.wait(0.1)
            firetouchinterest(humanoidRootPart, part, 1)
            break
        end
    end
end

teleportButton.MouseButton1Click:Connect(function()
    local bonds = findBonds()
    if #bonds == 0 then title.Text = "Không tìm thấy Bond!" return end
    local closest, minDist = nil, math.huge
    for _, b in pairs(bonds) do
        local pos = b:GetPivot().Position
        local dist = (pos - humanoidRootPart.Position).Magnitude
        if dist < minDist then
            minDist = dist
            closest = b
        end
    end
    if closest then
        teleportBypass(closest:GetPivot().Position + Vector3.new(0, 2, 0))
        task.wait(0.3)
        collectBond(closest)
    end
end)

OrionLib:Init()
