--[[
    Yuszx Hub
    Fitur: Auto Collect Code Redeem (delay 4-5 detik), Auto Perfect Forging
    UI: hitam + biru neon, icon toggle buka/tutup, switch button hidup per fitur
    Referensi forging: remote AnvilService Hammer (InvokeServer "Perfect")
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ====== KONFIGURASI ======
local CONFIG = {
    RedeemDelay = 4.5,  -- detik antar kode redeem (4-5 detik)
    ForgeDelay  = 0.1,  -- delay perfect forge (referensi Zyrion: 0.1)
    Theme = {
        Background  = Color3.fromRGB(10, 10, 14),
        Stroke      = Color3.fromRGB(0, 170, 255),
        Accent      = Color3.fromRGB(0, 200, 255),
        Text        = Color3.fromRGB(230, 230, 230),
        TextDim     = Color3.fromRGB(140, 140, 150),
        Button      = Color3.fromRGB(18, 18, 24),
        ButtonHover = Color3.fromRGB(25, 25, 35),
        SwitchOn    = Color3.fromRGB(0, 170, 255),
        SwitchOff   = Color3.fromRGB(40, 40, 50),
    },
}

-- ====== REMOTES (Forge Master) ======
local PerfectForgeRemote = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("Knit")
    :WaitForChild("Services")
    :WaitForChild("AnvilService")
    :WaitForChild("RF")
    :WaitForChild("Hammer")

local RedeemRemote = nil -- isi path remote redeem di sini

local RedeemCodes = {
"runekify",
"Dray28",
"RIKUSOULS",
"Ahjughh",
"T3nsei",
"Ghifa",
"ALLWAONIRONSOUL",
"Sukunay",
"MERGIXS",
"SIGURIH",
"CA2",
"Lulzsec",
"druscxlla",
"MAHAFEY",
"LALAGANG",
"Luthador2121",
"AAM",
"ToadPlaysGamesTTV",
"Uzi",
"TT_Mentally_ill_K.N",
"luknojo",
"Zeny",
"Clipz7112",
"PaPaX",
"Ryu",
"Chrisss",
"Ryokenn",
"DEI_Yumeko",
"Gryffin",
"ARKANGHEL",
"tony_vt",
"ReyPomuchi",
"Freca",
"Shan",
"TT_oratttt",
"Lifauzi",
"Ewaa",
"FRanime_OFFICIEL",
"Maple",
"Fujiesane",
"VeeruChan",
"HELOS",
"LezoCr",
"ARES",
"Laplace",
"Deco",
"dasher",
"Nyxaria",
"ProfGab",
"SUB2BLAZESTARS",
"Nothing",
"Dism",
"FannTzy",
"Darkfeniks",
"Sneptuno",
"SUPER MBUD",
"Marcell",
"Markbhatra",
"DrekathSenpai",
"Maniaco_666",
"Kiota2",
"WerNate",
"Ascart",
"Sweetiee24",
"Monarch",
"Aetherix",
"SUB2MULTIST789",
"Heso",
"RENZEI100",
"Skywinter86",
"Ghelayyy",
"Heartguard",
"RaykorBR",
"ZARGAKSTONE",
"aldoDM",
"Kurt",
"7Ds_Fangku",
"scarletditadora",
"Kuyabing",
"smiley",
"Sine",
"GT_HANNI",
"Erijero",
"DanoNano",
"WettySNK",
"Astral",
"obe",
"Dekday",
"Qyuu",
"Qwynne",
"PapiJoy",
"Taalonely",
"Darren",
"MADUNN",
"LZZ_019BEST",
"NisardHelpOnlyWoman",
"Staysmoovey",
"Les",
"Bebek",
"PepCalcot",
"Shirooo0312_IRONSOUL",
"omjiwa",
}

-- ====== STATE ======
local AutoRedeem = false
local AutoForge = false

-- ====== LOOP FITUR ======
local function redeemLoop()
    while AutoRedeem do
        for _, code in ipairs(RedeemCodes) do
            if not AutoRedeem then break end
            if RedeemRemote then
                pcall(function() RedeemRemote:FireServer(code) end)
                print("[Yuszx] Redeem kode: " .. tostring(code))
            end
            task.wait(CONFIG.RedeemDelay)
        end
        task.wait(1)
    end
end

local function forgeLoop()
    while AutoForge do
        local ok, err = pcall(function()
            PerfectForgeRemote:InvokeServer("Perfect", true)
        end)
        if not ok then
            warn("[Yuszx] Forge error: " .. tostring(err))
            task.wait(1)
        end
        task.wait(CONFIG.ForgeDelay)
    end
end

-- ====== BUILD UI ======
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuszxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 300)
Main.Position = UDim2.new(0.5, -190, 0.5, -150)
Main.BackgroundColor3 = CONFIG.Theme.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CONFIG.Theme.Stroke
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "YUSZX HUB"
Title.TextColor3 = CONFIG.Theme.Accent
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.Parent = Main

-- ====== SWITCH BUTTON HIDUP (ON/OFF + glow + pulse) ======
local function makeSwitch(name, yPos, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -40, 0, 44)
    Row.Position = UDim2.new(0, 20, 0, yPos)
    Row.BackgroundColor3 = CONFIG.Theme.Button
    Row.Parent = Main
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = CONFIG.Theme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 15
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    -- switch (tombol geser)
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 52, 0, 26)
    Switch.Position = UDim2.new(1, -64, 0.5, -13)
    Switch.BackgroundColor3 = CONFIG.Theme.SwitchOff
    Switch.Text = ""
    Switch.Parent = Row
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = CONFIG.Theme.TextDim
    Knob.Parent = Switch
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    -- glow neon di sekeliling switch
    local Glow = Instance.new("UIStroke")
    Glow.Color = CONFIG.Theme.Accent
    Glow.Thickness = 2
    Glow.Transparency = 1
    Glow.Parent = Switch

    local state = false
    local pulseOn = false

    -- efek pulse berdenyut saat ON
    task.spawn(function()
        while ScreenGui.Parent do
            if pulseOn then
                local t1 = TweenService:Create(Glow, TweenInfo.new(0.6), {Transparency = 0, Thickness = 4})
                t1:Play()
                t1.Completed:Wait()
                local t2 = TweenService:Create(Glow, TweenInfo.new(0.6), {Transparency = 0.4, Thickness = 2})
                t2:Play()
                t2.Completed:Wait()
            else
                task.wait(0.2)
            end
        end
    end)

    Switch.MouseButton1Click:Connect(function()
        state = not state
        pulseOn = state
        local knobTarget = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = knobTarget,
            BackgroundColor3 = state and CONFIG.Theme.Accent or CONFIG.Theme.TextDim,
        }):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = state and CONFIG.Theme.SwitchOn or CONFIG.Theme.SwitchOff,
        }):Play()
        TweenService:Create(Glow, TweenInfo.new(0.2), {Transparency = state and 0 or 1}):Play()
        TweenService:Create(Label, TweenInfo.new(0.2), {
            TextColor3 = state and CONFIG.Theme.Accent or CONFIG.Theme.Text,
        }):Play()
        task.spawn(callback, state)
    end)

    -- hover effect
    Row.MouseEnter:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.Theme.ButtonHover}):Play()
    end)
    Row.MouseLeave:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.Theme.Button}):Play()
    end)

    return Row
end

-- ====== FITUR SWITCHES ======
makeSwitch("Auto Collect Code Redeem", 60, function(on)
    AutoRedeem = on
    if on then task.spawn(redeemLoop) end
end)

makeSwitch("Auto Perfect Forging", 112, function(on)
    AutoForge = on
    if on then task.spawn(forgeLoop) end
end)

-- Info
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -40, 0, 60)
Info.Position = UDim2.new(0, 20, 0, 170)
Info.BackgroundTransparency = 1
Info.Text = "Redeem delay: " .. CONFIG.RedeemDelay .. "s  |  Forge delay: " .. CONFIG.ForgeDelay .. "s\nPastikan remote & daftar kode sudah diisi."
Info.TextColor3 = CONFIG.Theme.TextDim
Info.Font = Enum.Font.Gotham
Info.TextSize = 13
Info.TextWrapped = true
Info.Parent = Main

-- Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 8)
CloseBtn.BackgroundColor3 = CONFIG.Theme.Button
CloseBtn.Text = "X"
CloseBtn.TextColor3 = CONFIG.Theme.Stroke
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = Main
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    ToggleIcon.Visible = true
end)

-- ====== ICON TOGGLE BUKA/TUTUP ======
local ToggleIcon = Instance.new("ImageButton")
ToggleIcon.Size = UDim2.new(0, 50, 0, 50)
ToggleIcon.Position = UDim2.new(0, 10, 0.5, -25)
ToggleIcon.BackgroundColor3 = CONFIG.Theme.Background
ToggleIcon.Image = "rbxassetid://10723407389"
ToggleIcon.Parent = ScreenGui
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = CONFIG.Theme.Stroke
IconStroke.Thickness = 2
IconStroke.Parent = ToggleIcon

ToggleIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Glow icon berdenyut
task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(IconStroke, TweenInfo.new(1), {Transparency = 0.3}):Play()
        task.wait(1)
        TweenService:Create(IconStroke, TweenInfo.new(1), {Transparency = 0}):Play()
        task.wait(1)
    end
end)

print("[Yuszx] Hub loaded. GameId: " .. game.GameId)
