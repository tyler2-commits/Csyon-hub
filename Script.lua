--//====================================================
--// CYSON HUB (Optimierte & Fehlerfreie Version)
--// Mobile Friendly UI + Themes + UI Scaling + Auto-Layout
--//====================================================

--// SERVICES
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

--// REMOVE OLD UI
if CoreGui:FindFirstChild("CYSONHubUI") then
    CoreGui.CYSONHubUI:Destroy()
end
if CoreGui:FindFirstChild("NeonHubUI") then
    CoreGui.NeonHubUI:Destroy()
end

--// EVENT-REFERENZEN
local increaseSpeedEvent = ReplicatedStorage:FindFirstChild("IncreaseSpeed")

local spinEvent = nil
local spinFolder = ReplicatedStorage:FindFirstChild("SpinFolder")
if spinFolder then
	spinEvent = spinFolder:FindFirstChild("Spin")
end

local freeSpinEvent = ReplicatedStorage:FindFirstChild("ClaimSpin") or ReplicatedStorage:FindFirstChild("FreeSpin") or (spinFolder and spinFolder:FindFirstChild("Claim"))

local rebirthEvent = nil
pcall(function()
	rebirthEvent = ReplicatedStorage:WaitForChild("RebirthEvent", 2)
end)

--// WELTEN / ZIELE LISTE
local winLocations = {
	"ObbyTower",
	"RedTower",
	"Walls",
	"Earth", "Moon", "Lava", "Ice", "Flower",
	"Snow", "Dark", "Void", "Desert", "Forest",
	"Candy", "Steampunk", "Beach", "Heaven", "Hell",
	"Cyber", "Galaxy", "Crystal", "Rainbow"
}
local selectedWorld = winLocations[1]

--//====================================================
--// CONFIG SYSTEM (AUTO-SAVE)
--//====================================================

local ConfigName = "CYSON_Hub_Config.json"
local Settings = {
    AntiAFK = false,
    Fly = false,
    WalkSpeed = 16,
    Theme = "Purple",
    UISize = "MOBILE"
}

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(ConfigName, HttpService:JSONEncode(Settings))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile(ConfigName) and readfile then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(ConfigName))
            if type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    Settings[k] = v
                end
            end
        end)
    end
end

LoadConfig()

--//====================================================
--// THEMES
--//====================================================

local Themes = {
    ["Purple"] = { Background = Color3.fromRGB(7, 8, 16), Panel = Color3.fromRGB(12, 13, 24), Panel2 = Color3.fromRGB(16, 17, 31), Card = Color3.fromRGB(15, 17, 29), Accent = Color3.fromRGB(132, 60, 255), Accent2 = Color3.fromRGB(190, 70, 255), Secondary = Color3.fromRGB(45, 130, 255), Green = Color3.fromRGB(50, 220, 130), Red = Color3.fromRGB(255, 65, 85), White = Color3.fromRGB(245, 245, 255), Text = Color3.fromRGB(205, 208, 230), Muted = Color3.fromRGB(125, 130, 155), Dark = Color3.fromRGB(30, 32, 48) },
    ["Blue"] = { Background = Color3.fromRGB(5, 10, 18), Panel = Color3.fromRGB(8, 17, 30), Panel2 = Color3.fromRGB(12, 25, 42), Card = Color3.fromRGB(13, 27, 45), Accent = Color3.fromRGB(30, 120, 255), Accent2 = Color3.fromRGB(0, 200, 255), Secondary = Color3.fromRGB(50, 160, 255), Green = Color3.fromRGB(50, 230, 150), Red = Color3.fromRGB(255, 65, 85), White = Color3.fromRGB(245, 250, 255), Text = Color3.fromRGB(200, 220, 240), Muted = Color3.fromRGB(120, 150, 180), Dark = Color3.fromRGB(22, 35, 50) },
    ["Red"] = { Background = Color3.fromRGB(16, 6, 9), Panel = Color3.fromRGB(27, 10, 15), Panel2 = Color3.fromRGB(40, 14, 21), Card = Color3.fromRGB(34, 13, 20), Accent = Color3.fromRGB(230, 40, 70), Accent2 = Color3.fromRGB(255, 75, 95), Secondary = Color3.fromRGB(255, 120, 70), Green = Color3.fromRGB(50, 220, 130), Red = Color3.fromRGB(255, 65, 85), White = Color3.fromRGB(255, 245, 245), Text = Color3.fromRGB(235, 205, 210), Muted = Color3.fromRGB(165, 120, 130), Dark = Color3.fromRGB(50, 25, 32) },
    ["Green"] = { Background = Color3.fromRGB(5, 15, 12), Panel = Color3.fromRGB(8, 23, 18), Panel2 = Color3.fromRGB(12, 35, 27), Card = Color3.fromRGB(13, 32, 25), Accent = Color3.fromRGB(30, 190, 110), Accent2 = Color3.fromRGB(70, 255, 160), Secondary = Color3.fromRGB(30, 220, 190), Green = Color3.fromRGB(50, 230, 130), Red = Color3.fromRGB(255, 65, 85), White = Color3.fromRGB(240, 255, 245), Text = Color3.fromRGB(200, 230, 215), Muted = Color3.fromRGB(115, 155, 135), Dark = Color3.fromRGB(24, 48, 38) },
    ["Cyan"] = { Background = Color3.fromRGB(4, 12, 16), Panel = Color3.fromRGB(7, 20, 27), Panel2 = Color3.fromRGB(10, 31, 40), Card = Color3.fromRGB(11, 29, 37), Accent = Color3.fromRGB(0, 190, 220), Accent2 = Color3.fromRGB(0, 245, 255), Secondary = Color3.fromRGB(50, 140, 255), Green = Color3.fromRGB(50, 230, 150), Red = Color3.fromRGB(255, 65, 85), White = Color3.fromRGB(240, 255, 255), Text = Color3.fromRGB(195, 225, 230), Muted = Color3.fromRGB(110, 150, 160), Dark = Color3.fromRGB(22, 45, 52) },
    ["Gold"] = { Background = Color3.fromRGB(15, 12, 6), Panel = Color3.fromRGB(25, 20, 10), Panel2 = Color3.fromRGB(38, 30, 14), Card = Color3.fromRGB(32, 26, 13), Accent = Color3.fromRGB(220, 160, 30), Accent2 = Color3.fromRGB(255, 205, 70), Secondary = Color3.fromRGB(255, 130, 40), Green = Color3.fromRGB(70, 220, 120), Red = Color3.fromRGB(255, 65, 85), White = Color3.fromRGB(255, 250, 235), Text = Color3.fromRGB(235, 220, 190), Muted = Color3.fromRGB(160, 140, 100), Dark = Color3.fromRGB(55, 45, 25) }
}

local CurrentTheme = "Purple"
local Colors = {}

local function LoadTheme(themeName)
    local theme = Themes[themeName] or Themes["Purple"]
    for key, value in pairs(theme) do
        Colors[key] = value
    end
    CurrentTheme = themeName
end

LoadTheme(Settings.Theme)

local ThemeBindings = {}
local function BindTheme(object, property, colorName)
    table.insert(ThemeBindings, { Object = object, Property = property, Color = colorName })
    if object then
        object[property] = Colors[colorName]
    end
end

local ToggleObjects = {}
local TabObjects = {}
local OptionButtons = {}

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CYSONHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 820, 0, 520)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
BindTheme(MainFrame, "BackgroundColor3", "Background")

local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.72
UIScale.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Transparency = 0.15
MainStroke.Parent = MainFrame
BindTheme(MainStroke, "Color", "Accent")

local Glow = Instance.new("UIStroke")
Glow.Thickness = 5
Glow.Transparency = 0.82
Glow.Parent = MainFrame
BindTheme(Glow, "Color", "Secondary")

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 68)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
BindTheme(TopBar, "BackgroundColor3", "Panel")

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 15)
TopFix.Position = UDim2.new(0, 0, 1, -15)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar
BindTheme(TopFix, "BackgroundColor3", "Panel")

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 45, 0, 45)
Logo.Position = UDim2.new(0, 15, 0.5, -22)
Logo.BackgroundTransparency = 1
Logo.Font = Enum.Font.GothamBlack
Logo.Text = "⚡"
Logo.TextSize = 27
Logo.Parent = TopBar
BindTheme(Logo, "TextColor3", "Accent2")

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 28)
Title.Position = UDim2.new(0, 58, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.Text = "CYSON HUB"
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar
BindTheme(Title, "TextColor3", "White")

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 350, 0, 20)
Subtitle.Position = UDim2.new(0, 60, 0, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Powerful tools. Clean interface. Better control."
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar
BindTheme(Subtitle, "TextColor3", "Muted")

local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(0, 125, 0, 38)
StatusBox.Position = UDim2.new(1, -180, 0.5, -19)
StatusBox.BorderSizePixel = 0
StatusBox.Parent = TopBar
BindTheme(StatusBox, "BackgroundColor3", "Panel2")

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 10)
StatusCorner.Parent = StatusBox

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Transparency = 0.55
StatusStroke.Parent = StatusBox
BindTheme(StatusStroke, "Color", "Accent")

local StatusDot = Instance.new("TextLabel")
StatusDot.Size = UDim2.new(0, 20, 1, 0)
StatusDot.Position = UDim2.new(0, 10, 0, 0)
StatusDot.BackgroundTransparency = 1
StatusDot.Text = "●"
StatusDot.TextSize = 14
StatusDot.Parent = StatusBox
BindTheme(StatusDot, "TextColor3", "Green")

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -35, 1, 0)
StatusText.Position = UDim2.new(0, 32, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamBold
StatusText.Text = "ACTIVE"
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBox
BindTheme(StatusText, "TextColor3", "White")

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 38, 0, 38)
CloseButton.Position = UDim2.new(1, -48, 0.5, -19)
CloseButton.BackgroundColor3 = Color3.fromRGB(35, 20, 40)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 23
CloseButton.AutoButtonColor = false
CloseButton.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

--// SIDEBAR & TABS
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 175, 1, -68)
Sidebar.Position = UDim2.new(0, 0, 0, 68)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
BindTheme(Sidebar, "BackgroundColor3", "Background")

local SideTitle = Instance.new("TextLabel")
SideTitle.Size = UDim2.new(1, -25, 0, 25)
SideTitle.Position = UDim2.new(0, 15, 0, 15)
SideTitle.BackgroundTransparency = 1
SideTitle.Font = Enum.Font.GothamBold
SideTitle.Text = "MAIN MENU"
SideTitle.TextSize = 10
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.Parent = Sidebar
BindTheme(SideTitle, "TextColor3", "Muted")

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -190, 1, -105)
ContentContainer.Position = UDim2.new(0, 190, 0, 82)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local function CreateTab(name)
    local tab = Instance.new("ScrollingFrame")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.BorderSizePixel = 0
    tab.ScrollBarThickness = 3
    tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Visible = false
    tab.Parent = ContentContainer
    BindTheme(tab, "ScrollBarImageColor3", "Accent")

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = tab

    Tabs[name] = tab
    return tab
end

local PlayerTab = CreateTab("Player")
local MainScriptTab = CreateTab("Features")
local SettingsTab = CreateTab("Settings")

local function CreateTabButton(text, icon, y, target)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 43)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextSize = 17
    iconLabel.Parent = button
    BindTheme(iconLabel, "TextColor3", "Muted")

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -50, 1, 0)
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = text
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button
    BindTheme(textLabel, "TextColor3", "Muted")

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 22)
    indicator.Position = UDim2.new(0, 0, 0.5, -11)
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = button
    BindTheme(indicator, "BackgroundColor3", "Accent2")

    table.insert(TabObjects, { Button = button, Text = textLabel, Icon = iconLabel, Indicator = indicator })

    local function Activate()
        for _, tab in pairs(Tabs) do tab.Visible = false end
        for _, info in ipairs(TabObjects) do
            info.Indicator.Visible = false
            info.Text.TextColor3 = Colors.Muted
            info.Icon.TextColor3 = Colors.Muted
        end
        target.Visible = true
        indicator.Visible = true
        textLabel.TextColor3 = Colors.White
        iconLabel.TextColor3 = Colors.Accent2
    end

    button.MouseButton1Click:Connect(Activate)
    return button, Activate
end

local _, activatePlayer = CreateTabButton("Player", "♙", 50, PlayerTab)
CreateTabButton("Game Cheats", "⚡", 100, MainScriptTab)
CreateTabButton("Settings", "⚙", 150, SettingsTab)

-- UI HELPERS
local function CreateSectionTitle(parent, title, subtitle, layoutOrder)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -5, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = layoutOrder or 0
    container.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Text = title
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = container
    BindTheme(titleLabel, "TextColor3", "White")

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.Text = subtitle
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = container
    BindTheme(sub, "TextColor3", "Muted")
    
    return container
end

local function CreateFeatureCard(parent, titleText, descText, layoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -5, 0, 80)
    card.BorderSizePixel = 0
    card.LayoutOrder = layoutOrder or 0
    card.Parent = parent
    BindTheme(card, "BackgroundColor3", "Card")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = card
    BindTheme(stroke, "Color", "Accent")

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -20)
    accent.Position = UDim2.new(0, 0, 0, 10)
    accent.BorderSizePixel = 0
    accent.Parent = card
    BindTheme(accent, "BackgroundColor3", "Accent2")
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 3)
    accentCorner.Parent = accent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 0, 22)
    title.Position = UDim2.new(0, 18, 0, 12)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = titleText
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    BindTheme(title, "TextColor3", "White")

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -100, 0, 32)
    desc.Position = UDim2.new(0, 18, 0, 34)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.Text = descText
    desc.TextSize = 10
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = card
    BindTheme(desc, "TextColor3", "Muted")

    return card
end

local function CreateToggle(parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 26)
    button.Position = UDim2.new(1, -64, 0.5, -13)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 4, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(150,150,165)
    knob.BorderSizePixel = 0
    knob.Parent = button

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local enabled = false
    local toggleData = { Button = button, Knob = knob, Enabled = false }
    table.insert(ToggleObjects, toggleData)

    local function Set(value)
        enabled = value
        toggleData.Enabled = value

        if enabled then
            TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = Colors.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(1, -22, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        else
            TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = Colors.Dark}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(0, 4, 0.5, -9), BackgroundColor3 = Color3.fromRGB(150,150,165)}):Play()
        end
        if callback then callback(enabled) end
    end

    button.MouseButton1Click:Connect(function()
        Set(not enabled)
    end)

    Set(false)
    return button, Set
end

--// PLAYER TAB FEATURES
CreateSectionTitle(PlayerTab, "Player Modifications", "Steuere Bewegungen und Anti-AFK", 1)

local afkCard = CreateFeatureCard(PlayerTab, "Anti-AFK Schutz", "Verhindert, dass du wegen Inaktivität gekickt wirst.", 2)
local antiAfkActive = false
local _, setAfk = CreateToggle(afkCard, function(enabled)
    antiAfkActive = enabled
    Settings.AntiAFK = enabled
    SaveConfig()
end)

LocalPlayer.Idled:Connect(function()
    if antiAfkActive then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)
setAfk(Settings.AntiAFK)

local speedCard = CreateFeatureCard(PlayerTab, "WalkSpeed", "Passe deine Gehgeschwindigkeit an.", 3)
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 65, 0, 30)
speedInput.Position = UDim2.new(1, -78, 0.5, -15)
speedInput.BorderSizePixel = 0
speedInput.Font = Enum.Font.GothamBold
speedInput.Text = tostring(Settings.WalkSpeed)
speedInput.TextSize = 12
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedCard
BindTheme(speedInput, "BackgroundColor3", "Panel2")
BindTheme(speedInput, "TextColor3", "White")
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedInput

speedInput.FocusLost:Connect(function()
    local newSpeed = tonumber(speedInput.Text)
    if newSpeed then
        Settings.WalkSpeed = newSpeed
        SaveConfig()
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = newSpeed end
        end
    end
end)

local flyCard = CreateFeatureCard(PlayerTab, "Fly Mode", "Fliege frei mit WASD und Leertaste durch die Luft.", 4)
local flying = false
local bg, bv

local function StopFly()
    flying = false
    if bg then bg:Destroy(); bg = nil end
    if bv then bv:Destroy(); bv = nil end
end

local _, setFly = CreateToggle(flyCard, function(enabled)
    Settings.Fly = enabled
    SaveConfig()

    if not enabled then
        StopFly()
        return
    end

    flying = true
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bg = Instance.new("BodyGyro")
    bg.P = 90000
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp

    task.spawn(function()
        while flying and hrp.Parent do
            local camera = workspace.CurrentCamera
            local direction = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0, 1, 0) end

            bv.Velocity = direction * 50
            bg.CFrame = camera.CFrame
            RunService.RenderStepped:Wait()
        end
        StopFly()
    end)
end)
setFly(Settings.Fly)

--// GAME CHEATS TAB
CreateSectionTitle(MainScriptTab, "Game Automation", "Automatisierte Skripte für das Spiel", 1)

local clickCard = CreateFeatureCard(MainScriptTab, "Ultra Speed Clicker", "Erhöht automatisch deine Geschwindigkeit im Sekundentakt.", 2)
local autoFarmActive = false
local farmConnection
CreateToggle(clickCard, function(enabled)
    autoFarmActive = enabled
    if autoFarmActive then
        farmConnection = RunService.Heartbeat:Connect(function()
            if increaseSpeedEvent then pcall(function() increaseSpeedEvent:FireServer() end) end
        end)
    else
        if farmConnection then farmConnection:Disconnect() farmConnection = nil end
    end
end)

local spinCard = CreateFeatureCard(MainScriptTab, "Auto Claim / Free Spins", "Sammelt automatisch Gratis-Spins und Belohnungen ein.", 3)
local autoSpinActive = false
CreateToggle(spinCard, function(enabled)
    autoSpinActive = enabled
    if autoSpinActive then
        task.spawn(function()
            while autoSpinActive do
                pcall(function()
                    if freeSpinEvent then
                        freeSpinEvent:FireServer()
                    elseif spinEvent then
                        spinEvent:FireServer("Claim")
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

CreateSectionTitle(MainScriptTab, "Auto Win Teleport", "Wähle deine Zielwelt für den Auto-Teleport aus:", 4)

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -5, 0, 45)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true
dropdownFrame.LayoutOrder = 5
dropdownFrame.Parent = MainScriptTab
BindTheme(dropdownFrame, "BackgroundColor3", "Card")

local dfCorner = Instance.new("UICorner")
dfCorner.CornerRadius = UDim.new(0, 10)
dfCorner.Parent = dropdownFrame

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, 0, 0, 45)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Text = ""
dropdownBtn.Parent = dropdownFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, -40, 0, 45)
wsLabel.Position = UDim2.new(0, 15, 0, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Ziel-Welt: " .. selectedWorld
wsLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
wsLabel.TextSize = 13
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = dropdownFrame

local arrowLabel = Instance.new("TextLabel")
arrowLabel.Size = UDim2.new(0, 30, 0, 45)
arrowLabel.Position = UDim2.new(1, -35, 0, 0)
arrowLabel.BackgroundTransparency = 1
arrowLabel.Text = "▼"
arrowLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
arrowLabel.TextSize = 12
arrowLabel.Font = Enum.Font.GothamBold
arrowLabel.Parent = dropdownFrame

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, -12, 0, 150)
listScroll.Position = UDim2.new(0, 6, 0, 48)
listScroll.BackgroundTransparency = 1
listScroll.BorderSizePixel = 0
listScroll.CanvasSize = UDim2.new(0, 0, 0, #winLocations * 28)
listScroll.ScrollBarThickness = 3
listScroll.Parent = dropdownFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = listScroll

for _, worldName in ipairs(winLocations) do
	local itemBtn = Instance.new("TextButton")
	itemBtn.Size = UDim2.new(1, -4, 0, 25)
	itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	itemBtn.Text = "  " .. worldName
	itemBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
	itemBtn.TextSize = 12
	itemBtn.Font = Enum.Font.GothamMedium
	itemBtn.TextXAlignment = Enum.TextXAlignment.Left
	itemBtn.Parent = listScroll
	
	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 5)
	itemCorner.Parent = itemBtn
	
	itemBtn.MouseButton1Click:Connect(function()
		selectedWorld = worldName
		wsLabel.Text = "Ziel-Welt: " .. selectedWorld
		TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -5, 0, 45)}):Play()
		TweenService:Create(arrowLabel, TweenInfo.new(0.2), {Rotation = 0}):Play()
	end)
end

local dropdownOpen = false
dropdownBtn.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	if dropdownOpen then
		TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -5, 0, 205)}):Play()
		TweenService:Create(arrowLabel, TweenInfo.new(0.2), {Rotation = 180}):Play()
	else
		TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -5, 0, 45)}):Play()
		TweenService:Create(arrowLabel, TweenInfo.new(0.2), {Rotation = 0}):Play()
	end
end)

local winCard = CreateFeatureCard(MainScriptTab, "Auto Win Teleport Ausführen", "Teleportiert dich direkt zur gewählten Welt und simuliert den Touch.", 6)
local autoWinActive = false
CreateToggle(winCard, function(enabled)
    autoWinActive = enabled
    if autoWinActive then
        task.spawn(function()
            while autoWinActive do
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    local hrp = char.HumanoidRootPart

                    local targetPart = nil
                    for _, folderName in ipairs({"Wins", "WorldGoals", "GoalParts", "Portals", "Maps", "Stages", "Towers"}) do
                        local folder = workspace:FindFirstChild(folderName)
                        if folder then
                            local found = folder:FindFirstChild(selectedWorld, true)
                            if found then
                                targetPart = found
                                break
                            else
                                for _, descendant in ipairs(folder:GetDescendants()) do
                                    if descendant.Name:lower():find(selectedWorld:lower()) then
                                        targetPart = descendant
                                        break
                                    end
                                end
                            end
                        end
                        if targetPart then break end
                    end

                    if not targetPart then
                        for _, descendant in ipairs(workspace:GetDescendants()) do
                            if descendant.Name:lower():find(selectedWorld:lower()) and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
                                targetPart = descendant
                                break
                            end
                        end
                    end

                    local finalPart = nil
                    if targetPart then
                        if targetPart:IsA("BasePart") then
                            finalPart = targetPart
                        elseif targetPart:IsA("Model") then
                            finalPart = targetPart.PrimaryPart or targetPart:FindFirstChildWhichIsA("BasePart", true)
                        end
                    end

                    if finalPart then
                        hrp.CFrame = finalPart.CFrame + Vector3.new(0, 3, 0)
                        if firetouchinterest then
                            firetouchinterest(hrp, finalPart, 0)
                            task.wait(0.05)
                            firetouchinterest(hrp, finalPart, 1)
                        end
                    end
                end)
                task.wait(3.5)
            end
        end)
    end
end)

local rebirthCard = CreateFeatureCard(MainScriptTab, "Auto Rebirth", "Führt automatisch Rebirths aus, sobald es möglich ist.", 7)
local autoRebirthActive = false
CreateToggle(rebirthCard, function(enabled)
    autoRebirthActive = enabled
    if autoRebirthActive then
        task.spawn(function()
            while autoRebirthActive do
                pcall(function()
                    if rebirthEvent then
                        rebirthEvent:FireServer()
                    else
                        local foundRebirth = ReplicatedStorage:FindFirstChild("RebirthEvent")
                        if foundRebirth then foundRebirth:FireServer() end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

local fpsCard = CreateFeatureCard(MainScriptTab, "FPS Boost (Partikel aus)", "Schaltet Partikel und Effekte ab, um die FPS zu erhöhen.", 8)
CreateToggle(fpsCard, function(enabled)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = not enabled
        end
    end
end)

--// SETTINGS TAB
CreateSectionTitle(SettingsTab, "Settings & Anpassung", "Wähle Themes und UI-Größen", 1)

local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(1, -5, 0, 190)
themeCard.BorderSizePixel = 0
themeCard.LayoutOrder = 2
themeCard.Parent = SettingsTab
BindTheme(themeCard, "BackgroundColor3", "Card")
local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 12)
themeCorner.Parent = themeCard

local themeTitle = Instance.new("TextLabel")
themeTitle.Size = UDim2.new(1, -30, 0, 25)
themeTitle.Position = UDim2.new(0, 18, 0, 12)
themeTitle.BackgroundTransparency = 1
themeTitle.Font = Enum.Font.GothamBold
themeTitle.Text = "Themes"
themeTitle.TextSize = 14
themeTitle.TextXAlignment = Enum.TextXAlignment.Left
themeTitle.Parent = themeCard
BindTheme(themeTitle, "TextColor3", "White")

local function CreateThemeButton(name, x, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 105, 0, 38)
    button.Position = UDim2.new(0, x, 0, y)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = name
    button.TextSize = 11
    button.AutoButtonColor = false
    button.Parent = themeCard
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    table.insert(OptionButtons, { Button = button })
    return button
end

local ThemeButtons = {}
ThemeButtons["Purple"] = CreateThemeButton("PURPLE", 18, 50)
ThemeButtons["Blue"] = CreateThemeButton("BLUE", 132, 50)
ThemeButtons["Red"] = CreateThemeButton("RED", 246, 50)
ThemeButtons["Green"] = CreateThemeButton("GREEN", 18, 98)
ThemeButtons["Cyan"] = CreateThemeButton("CYAN", 132, 98)
ThemeButtons["Gold"] = CreateThemeButton("GOLD", 246, 98)

local sizeCard = Instance.new("Frame")
sizeCard.Size = UDim2.new(1, -5, 0, 190)
sizeCard.BorderSizePixel = 0
sizeCard.LayoutOrder = 3
sizeCard.Parent = SettingsTab
BindTheme(sizeCard, "BackgroundColor3", "Card")
local sizeCorner = Instance.new("UICorner")
sizeCorner.CornerRadius = UDim.new(0, 12)
sizeCorner.Parent = sizeCard

local sizeTitle = Instance.new("TextLabel")
sizeTitle.Size = UDim2.new(1, -30, 0, 25)
sizeTitle.Position = UDim2.new(0, 18, 0, 12)
sizeTitle.BackgroundTransparency = 1
sizeTitle.Font = Enum.Font.GothamBold
sizeTitle.Text = "UI Size"
sizeTitle.TextSize = 14
sizeTitle.TextXAlignment = Enum.TextXAlignment.Left
sizeTitle.Parent = sizeCard
BindTheme(sizeTitle, "TextColor3", "White")

local SizeButtons = {}
local SizeOptions = {
    { Name = "TINY", Scale = 0.48, X = 18, Y = 50 },
    { Name = "SMALL", Scale = 0.60, X = 132, Y = 50 },
    { Name = "MOBILE", Scale = 0.72, X = 246, Y = 50 },
    { Name = "NORMAL", Scale = 0.85, X = 18, Y = 98 },
    { Name = "LARGE", Scale = 1.00, X = 132, Y = 98 },
    { Name = "XL", Scale = 1.15, X = 246, Y = 98 }
}

for _, option in ipairs(SizeOptions) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 105, 0, 38)
    button.Position = UDim2.new(0, option.X, 0, option.Y)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = option.Name
    button.TextSize = 11
    button.AutoButtonColor = false
    button.Parent = sizeCard
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    SizeButtons[option.Name] = button

    button.MouseButton1Click:Connect(function()
        UIScale.Scale = option.Scale
        Settings.UISize = option.Name
        SaveConfig()

        for name, btn in pairs(SizeButtons) do
            if name == option.Name then
                btn.BackgroundColor3 = Colors.Accent
                btn.TextColor3 = Colors.White
            else
                btn.BackgroundColor3 = Colors.Panel2
                btn.TextColor3 = Colors.Muted
            end
        end
    end)
end

local function ApplyTheme(themeName)
    if not Themes[themeName] then return end
    LoadTheme(themeName)
    Settings.Theme = themeName
    SaveConfig()

    for _, binding in ipairs(ThemeBindings) do
        if binding.Object and binding.Object.Parent then
            local color = Colors[binding.Color]
            if color then binding.Object[binding.Property] = color end
        end
    end

    for _, toggle in ipairs(ToggleObjects) do
        if toggle.Enabled then
            toggle.Button.BackgroundColor3 = Colors.Accent
            toggle.Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        else
            toggle.Button.BackgroundColor3 = Colors.Dark
            toggle.Knob.BackgroundColor3 = Color3.fromRGB(150,150,165)
        end
    end

    for name, button in pairs(ThemeButtons) do
        if name == themeName then
            button.BackgroundColor3 = Colors.Accent
            button.TextColor3 = Colors.White
        else
            button.BackgroundColor3 = Colors.Panel2
            button.TextColor3 = Colors.Muted
        end
    end
end

for name, button in pairs(ThemeButtons) do
    button.MouseButton1Click:Connect(function()
        ApplyTheme(name)
    end)
end

ApplyTheme(Settings.Theme)

UIScale.Scale = (function()
    for _, opt in ipairs(SizeOptions) do
        if opt.Name == Settings.UISize then return opt.Scale end
    end
    return 0.72
end)()

for name, button in pairs(SizeButtons) do
    if name == Settings.UISize then
        button.BackgroundColor3 = Colors.Accent
        button.TextColor3 = Colors.White
    else
        button.BackgroundColor3 = Colors.Panel2
        button.TextColor3 = Colors.Muted
    end
end

--// DRAGGING & CLOSE BUTTONS
local dragging, dragStart, startPosition
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 125, 0, 42)
OpenButton.Position = UDim2.new(0, 18, 0.5, -21)
OpenButton.BorderSizePixel = 0
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "⚡  CYSON"
OpenButton.TextSize = 12
OpenButton.Visible = false
OpenButton.AutoButtonColor = false
OpenButton.Parent = ScreenGui
BindTheme(OpenButton, "BackgroundColor3", "Panel")
BindTheme(OpenButton, "TextColor3", "White")
local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton
local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton
BindTheme(OpenStroke, "Color", "Accent")

CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenButton.Visible = false end)

activatePlayer()
print("CYSON HUB erfolgreich geladen!")
