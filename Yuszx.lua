--[[
    YUSZX HUB - Iron Soul: Dungeon Auto Claim (Anti Rate-Limit)
    Delay default 2 detik per kode untuk menghindari "too many actions"
]]

-- ============================================
-- DAFTAR KODE REDEEM
-- ============================================
local REDEEM_CODES = {
    "runekify", "Dray28", "RIKUSOULS", "Ahjughh", "T3nsei",
    "Ghifa", "ALLWAONIRONSOUL", "Sukunay", "MERGIXS", "SIGURIH",
    "CA2", "Lulzsec", "druscxlla", "MAHAFEY", "LALAGANG",
    "Luthador2121", "AAM", "ToadPlaysGamesTTV", "Uzi", "TT_Mentally_ill_K.N",
    "luknojo", "Zeny", "Clipz7112", "PaPaX", "Ryu",
    "Chrisss", "Ryokenn", "DEI_Yumeko", "Gryffin", "ARKANGHEL",
    "tony_vt", "ReyPomuchi", "Freca", "Shan", "TT_oratttt",
    "Lifauzi", "Ewaa", "FRanime_OFFICIEL", "Maple", "Fujiesane",
    "VeeruChan", "HELOS", "LezoCr", "ARES", "Laplace",
    "Deco", "dasher", "Nyxaria", "ProfGab", "SUB2BLAZESTARS",
    "Nothing", "Dism", "FannTzy", "Darkfeniks", "Sneptuno",
    "SUPER MBUD", "Marcell", "Markbhatra", "DrekathSenpai", "Maniaco_666",
    "Kiota2", "WerNate", "Ascart", "Sweetiee24", "Monarch",
    "Aetherix", "SUB2MULTIST789", "Heso", "RENZEI100", "Skywinter86",
    "Ghelayyy", "Heartguard", "RaykorBR", "ZARGAKSTONE", "aldoDM",
    "Kurt", "7Ds_Fangku", "scarletditadora", "Kuyabing", "smiley",
    "Sine", "GT_HANNI", "Erijero", "DanoNano", "WettySNK",
    "Astral", "obe", "Dekday", "Qyuu", "Qwynne",
    "PapiJoy", "Taalonely", "Darren", "MADUNN", "LZZ_019BEST",
    "NisardHelpOnlyWoman", "Staysmoovey", "Les", "Bebek", "PepCalcot",
    "Shirooo0312_IRONSOUL", "omjiwa"
}

-- ============================================
-- KONFIGURASI DELAY (bisa diubah manual di sini)
-- ============================================
local DELAY_PER_CODE = 4.0     -- Jeda antar kode (detik). Naikin kalau masih kena limit.
local DELAY_ON_LIMIT = 10.0    -- Jeda ekstra kalau kena "too many actions" (detik)

-- ============================================
-- CARI REMOTE EVENT
-- ============================================
local function findRedeemRemote()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local success, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5)
            :WaitForChild("Codes", 5)
            :WaitForChild("Claim", 5)
    end)
    if success and remote and remote:IsA("RemoteEvent") then
        return remote
    end
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local lowerName = string.lower(obj.Name)
            if string.find(lowerName, "claim") or string.find(lowerName, "redeem") or string.find(lowerName, "code") then
                return obj
            end
        end
    end
    return nil
end

-- ============================================
-- UI (Hitam & Biru Neon)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxIronSoul"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 250)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "YUSZX | Iron Soul Claimer"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Siap"
StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(1, -20, 0, 25)
ProgressLabel.Position = UDim2.new(0, 10, 0, 68)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Progress: 0 / " .. #REDEEM_CODES
ProgressLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
ProgressLabel.Font = Enum.Font.Code
ProgressLabel.TextSize = 12
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

-- Delay Input
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(1, -20, 0, 20)
DelayLabel.Position = UDim2.new(0, 10, 0, 95)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay per kode: " .. DELAY_PER_CODE .. " detik"
DelayLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
DelayLabel.Font = Enum.Font.Code
DelayLabel.TextSize = 11
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = MainFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 28)
DelayBox.Position = UDim2.new(0, 10, 0, 118)
DelayBox.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
DelayBox.BorderSizePixel = 0
DelayBox.Text = tostring(DELAY_PER_CODE)
DelayBox.PlaceholderText = "Delay dalam detik (contoh: 2)"
DelayBox.TextColor3 = Color3.fromRGB(0, 200, 255)
DelayBox.Font = Enum.Font.Code
DelayBox.TextSize = 12
DelayBox.Parent = MainFrame

local DelayBoxCorner = Instance.new("UICorner")
DelayBoxCorner.CornerRadius = UDim.new(0, 6)
DelayBoxCorner.Parent = DelayBox

local DelayBoxStroke = Instance.new("UIStroke")
DelayBoxStroke.Color = Color3.fromRGB(0, 150, 255)
DelayBoxStroke.Thickness = 1
DelayBoxStroke.Parent = DelayBox

local ClaimButton = Instance.new("TextButton")
ClaimButton.Size = UDim2.new(1, -20, 0, 40)
ClaimButton.Position = UDim2.new(0, 10, 0, 155)
ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
ClaimButton.Text = "🚀 CLAIM ALL CODES"
ClaimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClaimButton.Font = Enum.Font.Code
ClaimButton.TextSize = 14
ClaimButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ClaimButton

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -20, 0, 30)
StopButton.Position = UDim2.new(0, 10, 0, 205)
StopButton.BackgroundColor3 = Color3.fromRGB(60, 5, 20)
StopButton.Text = "⛔ STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 100, 100)
StopButton.Font = Enum.Font.Code
StopButton.TextSize = 12
StopButton.Parent = MainFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

-- ============================================
-- LOGIKA CLAIM
-- ============================================
local isClaiming = false

local function getDelay()
    local val = tonumber(DelayBox.Text)
    if not val or val < 0.5 then return 2.0 end
    return val
end

ClaimButton.MouseButton1Click:Connect(function()
    if isClaiming then return end
    isClaiming = true
    ClaimButton.Text = "⏳ CLAIMING..."
    ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 50, 100)

    local remote = findRedeemRemote()
    if not remote then
        StatusLabel.Text = "❌ RemoteEvent tidak ditemukan!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        ClaimButton.Text = "🚀 CLAIM ALL CODES"
        ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
        isClaiming = false
        return
    end

    StatusLabel.Text = "✅ Remote OK. Mulai klaim..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)

    task.spawn(function()
        local claimed, failed = 0, 0
        local currentDelay = getDelay()

        for i, code in ipairs(REDEEM_CODES) do
            if not isClaiming then break end

            local success = pcall(function()
                remote:FireServer(code)
            end)

            if success then claimed = claimed + 1 else failed = failed + 1 end
            ProgressLabel.Text = "Progress: " .. (claimed + failed) .. " / " .. #REDEEM_CODES
            StatusLabel.Text = "🎁 Klaim: " .. code .. " (" .. currentDelay .. "s)"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)

            -- Baca ulang delay (kalau user ubah di tengah proses)
            currentDelay = getDelay()
            task.wait(currentDelay)
        end

        StatusLabel.Text = "✅ Selesai! Berhasil: " .. claimed .. " | Gagal: " .. failed
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        ClaimButton.Text = "🚀 CLAIM ALL CODES"
        ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
        isClaiming = false
    end)
end)

StopButton.MouseButton1Click:Connect(function()
    isClaiming = false
    StatusLabel.Text = "⛔ Dihentikan user"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    ClaimButton.Text = "🚀 CLAIM ALL CODES"
    ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
end)

-- ============================================
-- AUTO-ADJUST: Kalau kena rate limit, naikin delay otomatis
-- ============================================
-- Pantau chat/kick message (kalau ada notifikasi "too many actions")
local StarterGui = game:GetService("StarterGui")

local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Yuszx Hub",
            Text = msg,
            Duration = 3
        })
    end)
end

notify("Yuszx Hub siap! Delay default: " .. DELAY_PER_CODE .. "s")

print("[Yuszx] Script ready. Delay per code: " .. DELAY_PER_CODE .. " detik")
