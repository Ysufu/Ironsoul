-- ============================================
--        IRON SOUL : DUNGEON AUTO CLAIM
-- ============================================
local Players = game:GetService("Players")
local player  = Players.LocalPlayer
local pg      = player:WaitForChild("PlayerGui")

local JEDA_MIN, JEDA_MAX = 4.0, 5.0

local CODES = {
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

local function cariKotak()
    for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("TextBox") then
            local ph = string.lower(o.PlaceholderText or "")
            local nm = string.lower(o.Name)
            if ph:find("code") or nm:find("code") or ph:find("enter") then
                return o
            end
        end
    end
end

local function cariTombol(box)
    for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("TextButton") or o:IsA("ImageButton") then
            local t = string.lower((o.Text ~= "" and o.Text) or o.Name)
            if t:find("confirm") or t:find("submit") or t:find("redeem") then
                return o
            end
        end
    end
end

local box = cariKotak()
if not box then
    warn("[iron-soul] Kotak 'Enter Code' tidak ada. Buka popup Discord dulu.")
    return
end

local btn = cariTombol(box)
print(("[iron-soul] box=%s | confirm=%s")
    :format(box:GetFullName(), btn and btn:GetFullName() or "nil"))

for i, code in ipairs(CODES) do
    print(("[iron-soul] (%d/%d) %s"):format(i, #CODES, code))

    box:CaptureFocus(); task.wait(0.2)
    box.Text = code;    task.wait(0.2)
    box:ReleaseFocus(); task.wait(0.2)
    if btn then btn:Activate() end

    if i < #CODES then
        task.wait(JEDA_MIN + math.random() * (JEDA_MAX - JEDA_MIN))
    end
end
print("[iron-soul] SELESAI.")
