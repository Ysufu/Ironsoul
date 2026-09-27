--[[
    ═══════════════════════════════════════════
    YUSZX HUB - Iron Soul Auto Claim v6 FINAL
    ═══════════════════════════════════════════
    102 kode redeem | Delay 5 detik | Tema Hitam-Biru Neon
]]

-- ============================================
-- DAFTAR KODE (102)
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
local DELAY_PER_CODE = 5
local Player = game:GetService("Players").LocalPlayer

-- ============================================
-- CARI REMOTE
-- ============================================
local function findCodeRemote()
    local RS = game:GetService("ReplicatedStorage")
    local ok, remote = pcall(function()
        return RS:WaitForChild("Framework", 5)
            :WaitForChild("Systems", 5)
            :WaitForChild("CodeSystem", 5)
            :WaitForChild("CodeRE", 5)
    end)
    if ok and remote then return remote end
    for _, obj in ipairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local n = string.lower(obj.Name)
            if string.find(n, "codere") or string.find(n, "redeem") then
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
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
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

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "YUSZX | Iron Soul"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Position = UDim2.new(1, -70, 0, 3)
MinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MinButton.Text = "—"
MinButton.TextColor3 = Color3.fromRGB(0, 200, 255)
MinButton.Font = Enum.Font.Code
MinButton.TextSize = 16
MinButton.BorderSizePixel = 0
MinButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(80, 10, 20)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Font = Enum.Font.Code
CloseButton.TextSize = 16
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Floating Reopen
local ReopenButton = Instance.new("TextButton")
ReopenButton.Size = UDim2.new(0, 100, 0, 35)
ReopenButton.Position = UDim2.new(0, 20, 0, 100)
ReopenButton.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
ReopenButton.Text = "🚀 Yuszx"
ReopenButton.TextColor3 = Color3.fromRGB(0, 200, 255)
ReopenButton.Font = Enum.Font.Code
ReopenButton.TextSize = 13
ReopenButton.BorderSizePixel = 0
ReopenButton.Active = true
ReopenButton.Draggable = true
ReopenButton.Visible = false
ReopenButton.Parent = ScreenGui

local ReopenCorner = Instance.new("UICorner")
ReopenCorner.CornerRadius = UDim.new(0, 8)
ReopenCorner.Parent = ReopenButton

local ReopenStroke = Instance.new("UIStroke")
ReopenStroke.Color = Color3.fromRGB(0, 200, 255)
ReopenStroke.Thickness = 1.5
ReopenStroke.Parent = ReopenButton

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 42)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Siap"
StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Size = UDim2.new(1, -20, 0, 22)
ProgressLabel.Position = UDim2.new(0, 10, 0, 85)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Progress: 0 / " .. #REDEEM_CODES
ProgressLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
ProgressLabel.Font = Enum.Font.Code
ProgressLabel.TextSize = 12
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(1, -20, 0, 18)
DelayLabel.Position = UDim2.new(0, 10, 0, 112)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay per kode (detik):"
DelayLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
DelayLabel.Font = Enum.Font.Code
DelayLabel.TextSize = 11
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = MainFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 28)
DelayBox.Position = UDim2.new(0, 10, 0, 132)
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

-- Tombol Claim
local ClaimButton = Instance.new("TextButton")
ClaimButton.Size = UDim2.new(1, -20, 0, 40)
ClaimButton.Position = UDim2.new(0, 10, 0, 168)
ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
ClaimButton.Text = "🚀 CLAIM ALL CODES"
ClaimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClaimButton.Font = Enum.Font.Code
ClaimButton.TextSize = 14
ClaimButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ClaimButton

-- Tombol Stop
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -20, 0, 30)
StopButton.Position = UDim2.new(0, 10, 0, 215)
StopButton.BackgroundColor3 = Color3.fromRGB(60, 5, 20)
StopButton.Text = "⛔ STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 100, 100)
StopButton.Font = Enum.Font.Code
StopButton.TextSize = 12
StopButton.Parent = MainFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

-- Info akun
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 20)
InfoLabel.Position = UDim2.new(0, 10, 0, 250)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Akun: " .. Player.Name .. " | " .. #REDEEM_CODES .. " kode"
InfoLabel.TextColor3 = Color3.fromRGB(100, 130, 180)
InfoLabel.Font = Enum.Font.Code
InfoLabel.TextSize = 10
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = MainFrame

-- ============================================
-- LOGIKA
-- ============================================
local isMinimized = false
local isClaiming = false

local uiElements = {StatusLabel, ProgressLabel, DelayLabel, DelayBox, ClaimButton, StopButton, InfoLabel}

MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 400, 0, 35)
        MinButton.Text = "□"
        for _, o in ipairs(uiElements) do o.Visible = false end
    else
        MainFrame.Size = UDim2.new(0, 400, 0, 300)
        MinButton.Text = "—"
        for _, o in ipairs(uiElements) do o.Visible = true end
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ReopenButton.Visible = true
end)

ReopenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ReopenButton.Visible = false
end)

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

        StatusLabel.Text = "✅ Remote OK. Mulai claim..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)

        local sent = 0
        for i, code in ipairs(REDEEM_CODES) do
            if not isClaiming then break end

            pcall(function()
                remote:FireServer({
                    event = "usecode",
                    code = code
                })
            end)

            sent = sent + 1
            ProgressLabel.Text = "Progress: " .. sent .. " / " .. #REDEEM_CODES
            StatusLabel.Text = "🎁 Claim: " .. code
            StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)

            local delay = tonumber(DelayBox.Text) or DELAY_PER_CODE
            task.wait(delay)
        end

        StatusLabel.Text = "✅ Done! Total: " .. sent
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

print("[Yuszx] Iron Soul v6 loaded! Total: " .. #REDEEM_CODES .. " kode")
