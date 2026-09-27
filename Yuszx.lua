--[[
    ═══════════════════════════════════════════════
    YUSZX HUB - Iron Soul Auto Claim v5 FINAL
    ═══════════════════════════════════════════════
    
    Features:
    ✅ Auto-claim 102 kode redeem
    ✅ Smart Tracker (auto-save kode yang berhasil)
    ✅ Per-Akun (history kepisah by UserId)
    ✅ Auto-skip kode yang udah pernah sukses
    ✅ Delay 5 detik (aman dari rate limit)
    ✅ UI dengan tombol X & Minimize
    ✅ Anti-hilang pas respawn
    ✅ Tema Hitam & Biru Neon
    
    Credits: Recoded by Yuszx
    ═══════════════════════════════════════════════
]]

-- ============================================
-- DAFTAR KODE REDEEM (102 KODE)
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
local RESPONSE_WAIT = 2
local Player = game:GetService("Players").LocalPlayer
local SAVE_FILE = "Yuszx_claimed_" .. Player.UserId .. ".json"
local HttpService = game:GetService("HttpService")

-- ============================================
-- GLITCH ANIMATION
-- ============================================
local function playGlitch()
    local gui = Instance.new("ScreenGui")
    gui.Name = "YuszxGlitch"
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "YUSZX"
    label.TextColor3 = Color3.fromRGB(0, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Code
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 100, 255)
    label.Parent = frame

    local chars = {"#", "@", "!", "$", "%", "&", "?", "~", "|", "/", "\\"}
    local orig = "YUSZX"
    local start = tick()

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if tick() - start >= 1.5 then
            label.Text = orig
            task.wait(0.3)
            gui:Destroy()
            conn:Disconnect()
            return
        end
        local g = ""
        for i = 1, #orig do
            if math.random() > 0.5 then
                g = g .. chars[math.random(#chars)]
            else
                g = g .. orig:sub(i, i)
            end
        end
        label.Text = g
        label.TextColor3 = Color3.fromRGB(math.random(0, 255), 0, 255)
    end)
end

playGlitch()
task.wait(2)

-- ============================================
-- SMART TRACKER (Per-Akun)
-- ============================================
local claimedCodes = {}

local function loadClaimed()
    if not readfile or not isfile then return end
    pcall(function()
        if isfile(SAVE_FILE) then
            claimedCodes = HttpService:JSONDecode(readfile(SAVE_FILE)) or {}
            print("[Yuszx] ✅ Loaded " .. #claimedCodes .. " claimed for " .. Player.Name)
        else
            print("[Yuszx] 🆕 Akun baru: " .. Player.Name)
        end
    end)
end

local function saveClaimed()
    if not writefile then return end
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(claimedCodes))
    end)
end

local function markClaimed(code)
    claimedCodes[code] = os.time()
    saveClaimed()
end

local function isClaimed(code)
    return claimedCodes[code] ~= nil
end

local function resetClaimed()
    claimedCodes = {}
    if delfile and isfile then
        pcall(function()
            if isfile(SAVE_FILE) then delfile(SAVE_FILE) end
        end)
    end
    saveClaimed()
end

loadClaimed()

-- ============================================
-- HOOK RESPONSE SERVER
-- ============================================
local StarterGui = game:GetService("StarterGui")
local lastSentCode = nil

local oldSend = StarterGui.SendNotification
StarterGui.SendNotification = newcclosure(function(self, ...)
    local args = {...}
    if args[1] == "SendNotification" and args[2] and args[2].Text and lastSentCode then
        local t = string.lower(args[2].Text)
        if string.find(t, "berhasil") or string.find(t, "success")
           or string.find(t, "received") or string.find(t, "menerima")
           or string.find(t, "claimed") or string.find(t, "reward")
           or string.find(t, "hadiah") then
            if not isClaimed(lastSentCode) then
                markClaimed(lastSentCode)
                print("[Yuszx] ✅ SUKSES: " .. lastSentCode)
            end
        end
    end
    return oldSend(self, ...)
end)

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
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 330)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -165)
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
Title.Text = "YUSZX | " .. Player.Name
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 13
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

-- Stats
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 22)
StatsLabel.Position = UDim2.new(0, 10, 0, 42)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "📊 Claimed: 0 / " .. #REDEEM_CODES
StatsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 12
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

local PendingLabel = Instance.new("TextLabel")
PendingLabel.Size = UDim2.new(1, -20, 0, 22)
PendingLabel.Position = UDim2.new(0, 10, 0, 64)
PendingLabel.BackgroundTransparency = 1
PendingLabel.Text = "⏳ Pending: " .. #REDEEM_CODES
PendingLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
PendingLabel.Font = Enum.Font.Code
PendingLabel.TextSize = 12
PendingLabel.TextXAlignment = Enum.TextXAlignment.Left
PendingLabel.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 40)
StatusLabel.Position = UDim2.new(0, 10, 0, 90)
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
ProgressLabel.Position = UDim2.new(0, 10, 0, 132)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Progress: 0 / 0"
ProgressLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
ProgressLabel.Font = Enum.Font.Code
ProgressLabel.TextSize = 12
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = MainFrame

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Size = UDim2.new(1, -20, 0, 18)
DelayLabel.Position = UDim2.new(0, 10, 0, 158)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Delay per kode (detik):"
DelayLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
DelayLabel.Font = Enum.Font.Code
DelayLabel.TextSize = 11
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = MainFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(1, -20, 0, 28)
DelayBox.Position = UDim2.new(0, 10, 0, 178)
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
ClaimButton.Position = UDim2.new(0, 10, 0, 214)
ClaimButton.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
ClaimButton.Text = "🚀 CLAIM PENDING CODES"
ClaimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClaimButton.Font = Enum.Font.Code
ClaimButton.TextSize = 13
ClaimButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ClaimButton

local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0.5, -15, 0, 28)
ResetButton.Position = UDim2.new(0, 10, 0, 260)
ResetButton.BackgroundColor3 = Color3.fromRGB(80, 60, 5)
ResetButton.Text = "🔄 RESET LIST"
ResetButton.TextColor3 = Color3.fromRGB(255, 220, 100)
ResetButton.Font = Enum.Font.Code
ResetButton.TextSize = 11
ResetButton.Parent = MainFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 6)
ResetCorner.Parent = ResetButton

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.5, -15, 0, 28)
StopButton.Position = UDim2.new(0.5, 5, 0, 260)
StopButton.BackgroundColor3 = Color3.fromRGB(60, 5, 20)
StopButton.Text = "⛔ STOP"
StopButton.TextColor3 = Color3.fromRGB(255, 100, 100)
StopButton.Font = Enum.Font.Code
StopButton.TextSize = 11
StopButton.Parent = MainFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopButton

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 20)
InfoLabel.Position = UDim2.new(0, 10, 0, 295)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Akun: " .. Player.Name .. " (ID: " .. Player.UserId .. ")"
InfoLabel.TextColor3 = Color3.fromRGB(100, 130, 180)
InfoLabel.Font = Enum.Font.Code
InfoLabel.TextSize = 10
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = MainFrame

-- ============================================
-- HELPER
-- ============================================
local function updateStats()
    local c = 0
    for _, code in ipairs(REDEEM_CODES) do
        if isClaimed(code) then c = c + 1 end
    end
    StatsLabel.Text = "📊 Claimed: " .. c .. " / " .. #REDEEM_CODES
    PendingLabel.Text = "⏳ Pending: " .. (#REDEEM_CODES - c)
end

local function getPending()
    local p = {}
    for _, code in ipairs(REDEEM_CODES) do
        if not isClaimed(code) then table.insert(p, code) end
    end
    return p
end

local function getDelay()
    local v = tonumber(DelayBox.Text)
    if not v or v < 1 then return DELAY_PER_CODE end
    return v
end

-- ============================================
-- LOGIKA UI
-- ============================================
local isMinimized = false
local isClaiming = false

local uiElements = {StatsLabel, PendingLabel, StatusLabel, ProgressLabel, DelayLabel, DelayBox, ClaimButton, ResetButton, StopButton, InfoLabel}

MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 400, 0, 35)
        MinButton.Text = "□"
        for _, o in ipairs(uiElements) do o.Visible = false end
    else
        MainFrame.Size = UDim2.new(0, 400, 0, 330)
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

ResetButton.MouseButton1Click:Connect(function()
    resetClaimed()
    updateStats()
    StatusLabel.Text = "🔄 History direset! Semua kode bakal di-scan ulang."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
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
            ClaimButton.Text = "🚀 CLAIM PENDING CODES"
            isClaiming = false
            return
        end

        local pending = getPending()
        if #pending == 0 then
            StatusLabel.Text = "✅ Semua kode udah di-claim! Klik RESET kalau mau scan ulang."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            ClaimButton.Text = "🚀 CLAIM PENDING CODES"
            isClaiming = false
            return
        end

        StatusLabel.Text = "✅ Remote OK. " .. #pending .. " kode pending."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)

        local sent = 0
        for i, code in ipairs(pending) do
            if not isClaiming then break end

            lastSentCode = code

            pcall(function()
                remote:FireServer({
                    event = "usecode",
                    code = code
                })
            end)

            sent = sent + 1
            ProgressLabel.Text = "Progress: " .. sent .. " / " .. #pending
            StatusLabel.Text = "🎁 Claim: " .. code
            StatusLabel.TextColor3 = Color3.fromRGB(200, 220, 255)

            task.wait(RESPONSE_WAIT)
            updateStats()

            local totalDelay = getDelay()
            local extra = totalDelay - RESPONSE_WAIT
            if extra > 0 then task.wait(extra) end
        end

        StatusLabel.Text = "✅ Done! Total pending yang di-scan: " .. sent
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        ClaimButton.Text = "🚀 CLAIM PENDING CODES"
        isClaiming = false
        updateStats()
    end)
end)

StopButton.MouseButton1Click:Connect(function()
    isClaiming = false
    StatusLabel.Text = "⛔ Dihentikan user"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    ClaimButton.Text = "🚀 CLAIM PENDING CODES"
end)

-- ============================================
-- INIT
-- ============================================
updateStats()
print("[Yuszx] ══════════════════════════════════")
print("[Yuszx] Iron Soul v5 FINAL loaded!")
print("[Yuszx] User: " .. Player.Name .. " (" .. Player.UserId .. ")")
print("[Yuszx] Total kode: " .. #REDEEM_CODES)
print("[Yuszx] Delay: " .. DELAY_PER_CODE .. " detik")
print("[Yuszx] ══════════════════════════════════")
