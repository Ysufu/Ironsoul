--[[
    YUSZX HUB - Iron Soul Auto Claim v3 FINAL
    Format: FireServer({event = "usecode", code = "..."})
    Remote: Framework.Systems.CodeSystem.CodeRE
]]

-- ============================================
-- DAFTAR KODE
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
-- KONFIGURASI
-- ============================================
local DELAY_PER_CODE = 4  -- detik, aman dari rate limit

-- ============================================
-- CARI REMOTE
-- ============================================
local function findCodeRemote()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Path yang udah ke-detect
    local ok, remote = pcall(function()
        return ReplicatedStorage
            :WaitForChild("Framework", 5)
            :WaitForChild("Systems", 5)
            :WaitForChild("CodeSystem", 5)
            :WaitForChild("CodeRE", 5)
    end)
    if ok and remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
        return remote
    end
    
    -- Fallback: scan manual
    warn("[Yuszx] Path utama gagal, scan manual...")
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = string.lower(obj.Name)
            if string.find(n, "codere") or string.find(n, "code") or string.find(n, "redeem") then
                return obj
            end
        end
    end
    return nil
end

-- ============================================
-- UI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxIronSoul"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 240)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
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
Title.Text = "YUSZX | Iron Soul v3"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Siap"
StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(1, -20, 0, 25)
ProgressLabel.Position = UDim2.new(0, 10, 0, 82)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Progress: 0 / " .. #REDEEM_CODES
ProgressLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
ProgressLabel.Font = Enum.Font.Code
ProgressLabel.TextSize = 12
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(1, -20, 0, 18)
DelayLabel.Position = UDim2.new(0, 10, 0, 110)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay per kode (detik):"
DelayLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
DelayLabel.Font = Enum.Font.Code
DelayLabel.TextSize = 11
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = MainFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 28)
DelayBox.Position = UDim2.new(0, 10, 0, 130)
DelayBox.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
DelayBox.BorderSizePixel = 0
DelayBox.Text = tostring(DELAY_PER_CODE)
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
ClaimButton.Size = UDim2.new(1, -20, 0, 38)
ClaimButton.Position = UDim2.new(0, 10, 0, 165)
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
StopButton.Size = UDim2.new(1, -20, 0, 28)
StopButton.Position = UDim2.new(0, 10, 0, 207)
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
-- LOGIKA
-- ============================================
local isClaiming = false

local function getDelay()
    local val = tonumber(DelayBox.Text)
    if not val or val < 1 then return DELAY_PER_CODE end
    return val
end

ClaimButton.MouseButton1Click:Connect(function()
    if isClaiming then return end
    isClaiming = true
    ClaimButton.Text = "⏳ CLAIMING..."

    task.spawn(function()
        local remote = findCodeRemote()
        if not remote then
            StatusLabel.Text = "❌ Remote gak ketemu!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            ClaimButton.Text = "🚀 CLAIM ALL CODES"
            isClaiming = false
            return
        end
        StatusLabel.Text = "✅ Remote OK: " .. remote.Name
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)

        local sent, failed = 0, 0
        for i, code in ipairs(REDEEM_CODES) do
            if not isClaiming then break end

            -- FORMAT BARU: kirim table!
            local success = pcall(function()
                remote:FireServer({
                    event = "usecode",
                    code = code
                })
            end)

            if success then sent = sent + 1 else failed = failed + 1 end
            ProgressLabel.Text = "Progress: " .. (sent + failed) .. " / " .. #REDEEM_CODES
            StatusLabel.Text = "🎁 Claim: " .. code
            StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)

            task.wait(getDelay())
        end

        StatusLabel.Text = "✅ Done! Sent: " .. sent .. " | Failed: " .. failed
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        ClaimButton.Text = "🚀 CLAIM ALL CODES"
        isClaiming = false
    end)
end)

StopButton.MouseButton1Click:Connect(function()
    isClaiming = false
    StatusLabel.Text = "⛔ Dihentikan"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    ClaimButton.Text = "🚀 CLAIM ALL CODES"
end)

print("[Yuszx] Iron Soul v3 loaded! Format: {event=usecode, code=...}")
