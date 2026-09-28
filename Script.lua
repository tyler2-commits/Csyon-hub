--//====================================================
--// CYSON HUB - MODERN UI EDITION
--// Mobile Friendly / Themes / Auto Save / Drag / Scaling
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

--//====================================================
--// REMOVE OLD UI
--//====================================================

pcall(function()
    if CoreGui:FindFirstChild("CYSONHubUI") then
        CoreGui.CYSONHubUI:Destroy()
    end

    if CoreGui:FindFirstChild("NeonHubUI") then
        CoreGui.NeonHubUI:Destroy()
    end
end)

--//====================================================
--// REMOTES
--//====================================================

local increaseSpeedEvent = ReplicatedStorage:FindFirstChild("IncreaseSpeed")

local spinEvent = nil
local spinFolder = ReplicatedStorage:FindFirstChild("SpinFolder")

if spinFolder then
    spinEvent = spinFolder:FindFirstChild("Spin")
end

local freeSpinEvent =
    ReplicatedStorage:FindFirstChild("ClaimSpin")
    or ReplicatedStorage:FindFirstChild("FreeSpin")
    or (spinFolder and spinFolder:FindFirstChild("Claim"))

local rebirthEvent = nil

pcall(function()
    rebirthEvent = ReplicatedStorage:WaitForChild("RebirthEvent", 2)
end)

--//====================================================
--// WORLDS
--//====================================================

local winLocations = {
    "ObbyTower",
    "RedTower",
    "Walls",
    "World1",
    "World2",
    "World3",
    "World4",
    "World5",
    "World6",
    "World7",
    "World8",
    "World9",
    "World10",
    "World11",
    "World12",
    "World13",
    "World14",
    "World15",
    "World16",
    "World17",
    "World18",
    "World19"
}

local selectedWorld = winLocations[1]

--//====================================================
--// CONFIG
--//====================================================

local ConfigName = "CYSON_Hub_Config.json"

local Settings = {
    AntiAFK = false,
    Fly = false,
    WalkSpeed = 16,
    Theme = "Purple",
    UISize = "MOBILE",
    AutoBuyBest = false -- Auto Buy Setting hinzugefügt
}

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(
                ConfigName,
                HttpService:JSONEncode(Settings)
            )
        end)
    end
end

local function LoadConfig()
    if isfile and readfile and isfile(ConfigName) then
        pcall(function()
            local decoded = HttpService:JSONDecode(
                readfile(ConfigName)
            )

            if type(decoded) == "table" then
                for key, value in pairs(decoded) do
                    Settings[key] = value
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

    Purple = {
        Background = Color3.fromRGB(7, 8, 16),
        Panel = Color3.fromRGB(12, 13, 24),
        Panel2 = Color3.fromRGB(18, 19, 34),
        Card = Color3.fromRGB(15, 17, 29),
        Accent = Color3.fromRGB(132, 60, 255),
        Accent2 = Color3.fromRGB(190, 70, 255),
        Secondary = Color3.fromRGB(45, 130, 255),
        Green = Color3.fromRGB(50, 220, 130),
        Red = Color3.fromRGB(255, 65, 85),
        White = Color3.fromRGB(245, 245, 255),
        Text = Color3.fromRGB(205, 208, 230),
        Muted = Color3.fromRGB(125, 130, 155),
        Dark = Color3.fromRGB(30, 32, 48)
    },

    Blue = {
        Background = Color3.fromRGB(5, 10, 18),
        Panel = Color3.fromRGB(8, 17, 30),
        Panel2 = Color3.fromRGB(12, 25, 42),
        Card = Color3.fromRGB(13, 27, 45),
        Accent = Color3.fromRGB(30, 120, 255),
        Accent2 = Color3.fromRGB(0, 200, 255),
        Secondary = Color3.fromRGB(50, 160, 255),
        Green = Color3.fromRGB(50, 230, 150),
        Red = Color3.fromRGB(255, 65, 85),
        White = Color3.fromRGB(245, 250, 255),
        Text = Color3.fromRGB(200, 220, 240),
        Muted = Color3.fromRGB(120, 150, 180),
        Dark = Color3.fromRGB(22, 35, 50)
    },

    Red = {
        Background = Color3.fromRGB(16, 6, 9),
        Panel = Color3.fromRGB(27, 10, 15),
        Panel2 = Color3.fromRGB(40, 14, 21),
        Card = Color3.fromRGB(34, 13, 20),
        Accent = Color3.fromRGB(230, 40, 70),
        Accent2 = Color3.fromRGB(255, 75, 95),
        Secondary = Color3.fromRGB(255, 120, 70),
        Green = Color3.fromRGB(50, 220, 130),
        Red = Color3.fromRGB(255, 65, 85),
        White = Color3.fromRGB(255, 245, 245),
        Text = Color3.fromRGB(235, 205, 210),
        Muted = Color3.fromRGB(165, 120, 130),
        Dark = Color3.fromRGB(50, 25, 32)
    },

    Green = {
        Background = Color3.fromRGB(5, 15, 12),
        Panel = Color3.fromRGB(8, 23, 18),
        Panel2 = Color3.fromRGB(12, 35, 27),
        Card = Color3.fromRGB(13, 32, 25),
        Accent = Color3.fromRGB(30, 190, 110),
        Accent2 = Color3.fromRGB(70, 255, 160),
        Secondary = Color3.fromRGB(30, 220, 190),
        Green = Color3.fromRGB(50, 230, 130),
        Red = Color3.fromRGB(255, 65, 85),
        White = Color3.fromRGB(240, 255, 245),
        Text = Color3.fromRGB(200, 230, 215),
        Muted = Color3.fromRGB(115, 155, 135),
        Dark = Color3.fromRGB(24, 48, 38)
    },

    Cyan = {
        Background = Color3.fromRGB(4, 12, 16),
        Panel = Color3.fromRGB(7, 20, 27),
        Panel2 = Color3.fromRGB(10, 31, 40),
        Card = Color3.fromRGB(11, 29, 37),
        Accent = Color3.fromRGB(0, 190, 220),
        Accent2 = Color3.fromRGB(0, 245, 255),
        Secondary = Color3.fromRGB(50, 140, 255),
        Green = Color3.fromRGB(50, 230, 150),
        Red = Color3.fromRGB(255, 65, 85),
        White = Color3.fromRGB(240, 255, 255),
        Text = Color3.fromRGB(195, 225, 230),
        Muted = Color3.fromRGB(110, 150, 160),
        Dark = Color3.fromRGB(22, 45, 52)
    },

    Gold = {
        Background = Color3.fromRGB(15, 12, 6),
        Panel = Color3.fromRGB(25, 20, 10),
        Panel2 = Color3.fromRGB(38, 30, 14),
        Card = Color3.fromRGB(32, 26, 13),
        Accent = Color3.fromRGB(220, 160, 30),
        Accent2 = Color3.fromRGB(255, 205, 70),
        Secondary = Color3.fromRGB(255, 130, 40),
        Green = Color3.fromRGB(70, 220, 120),
        Red = Color3.fromRGB(255, 65, 85),
        White = Color3.fromRGB(255, 250, 235),
        Text = Color3.fromRGB(235, 220, 190),
        Muted = Color3.fromRGB(160, 140, 100),
        Dark = Color3.fromRGB(55, 45, 25)
    }
}

local CurrentTheme = "Purple"
local Colors = {}

local function LoadTheme(themeName)
    local theme = Themes[themeName] or Themes.Purple

    for key, value in pairs(theme) do
        Colors[key] = value
    end

    CurrentTheme = themeName
end

LoadTheme(Settings.Theme)

--//====================================================
--// UI REFERENCES
--//====================================================

local ThemeBindings = {}
local ToggleObjects = {}
local TabObjects = {}

local function BindTheme(object, property, colorName)
    if not object then return end

    table.insert(ThemeBindings, {
        Object = object,
        Property = property,
        Color = colorName
    })

    object[property] = Colors[colorName]
end

--//====================================================
--// SCREEN GUI
--//====================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CYSONHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

--//====================================================
--// MAIN WINDOW
--//====================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 850, 0, 540)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
BindTheme(MainFrame, "BackgroundColor3", "Background")

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame
BindTheme(MainStroke, "Color", "Accent")

local UIScale = Instance.new("UIScale")
UIScale.Parent = MainFrame

--//====================================================
--// AUTO MOBILE SCALE
--//====================================================

local SizeOptions = {
    TINY = 0.45,
    SMALL = 0.58,
    MOBILE = 0.70,
    NORMAL = 0.82,
    LARGE = 0.95,
    XL = 1.08
}

local function ApplyUIScale()
    local camera = workspace.CurrentCamera

    if not camera then
        UIScale.Scale = SizeOptions[Settings.UISize] or 0.70
        return
    end

    local viewport = camera.ViewportSize

    if Settings.UISize == "AUTO" then
        local autoScale = math.min(
            viewport.X / 900,
            viewport.Y / 650
        )

        UIScale.Scale = math.clamp(autoScale, 0.42, 0.95)
    else
        UIScale.Scale = SizeOptions[Settings.UISize] or 0.70
    end
end

ApplyUIScale()

--//====================================================
--// TOP BAR
--//====================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 70)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
BindTheme(TopBar, "BackgroundColor3", "Panel")

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 18)
TopCorner.Parent = TopBar

local TopBottom = Instance.new("Frame")
TopBottom.Size = UDim2.new(1, 0, 0, 18)
TopBottom.Position = UDim2.new(0, 0, 1, -18)
TopBottom.BorderSizePixel = 0
TopBottom.Parent = TopBar
BindTheme(TopBottom, "BackgroundColor3", "Panel")

-- Logo background
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 44, 0, 44)
LogoFrame.Position = UDim2.new(0, 14, 0.5, -22)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = TopBar
BindTheme(LogoFrame, "BackgroundColor3", "Accent")

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 12)
LogoCorner.Parent = LogoFrame

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "⚡"
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 23
Logo.Parent = LogoFrame
BindTheme(Logo, "TextColor3", "White")

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 26)
Title.Position = UDim2.new(0, 70, 0, 12)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.Text = "CYSON HUB"
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar
BindTheme(Title, "TextColor3", "White")

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(0, 400, 0, 18)
Subtitle.Position = UDim2.new(0, 71, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Clean interface • Fast controls • Auto Save"
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar
BindTheme(Subtitle, "TextColor3", "Muted")

-- Status
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(0, 105, 0, 34)
StatusBox.Position = UDim2.new(1, -160, 0.5, -17)
StatusBox.BorderSizePixel = 0
StatusBox.Parent = TopBar
BindTheme(StatusBox, "BackgroundColor3", "Panel2")

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusBox

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 13, 0.5, -4)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusBox
BindTheme(StatusDot, "BackgroundColor3", "Green")

local StatusDotCorner = Instance.new("UICorner")
StatusDotCorner.CornerRadius = UDim.new(1, 0)
StatusDotCorner.Parent = StatusDot

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -32, 1, 0)
StatusText.Position = UDim2.new(0, 28, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.GothamBold
StatusText.Text = "ONLINE"
StatusText.TextSize = 10
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBox
BindTheme(StatusText, "TextColor3", "White")

-- Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -47, 0.5, -18)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 22
CloseButton.AutoButtonColor = false
CloseButton.Parent = TopBar
BindTheme(CloseButton, "BackgroundColor3", "Dark")
BindTheme(CloseButton, "TextColor3", "White")

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.15),
        {BackgroundColor3 = Colors.Red}
    ):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.15),
        {BackgroundColor3 = Colors.Dark}
    ):Play()
end)

--//====================================================
--// SIDEBAR
--//====================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 185, 1, -70)
Sidebar.Position = UDim2.new(0, 0, 0, 70)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
BindTheme(Sidebar, "BackgroundColor3", "Background")

local SideTitle = Instance.new("TextLabel")
SideTitle.Size = UDim2.new(1, -28, 0, 20)
SideTitle.Position = UDim2.new(0, 16, 0, 16)
SideTitle.BackgroundTransparency = 1
SideTitle.Text = "NAVIGATION"
SideTitle.Font = Enum.Font.GothamBold
SideTitle.TextSize = 9
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.Parent = Sidebar
BindTheme(SideTitle, "TextColor3", "Muted")

-- sidebar divider
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -28, 0, 1)
Divider.Position = UDim2.new(0, 14, 0, 43)
Divider.BorderSizePixel = 0
Divider.Parent = Sidebar
BindTheme(Divider, "BackgroundColor3", "Dark")

--//====================================================
--// CONTENT
--//====================================================

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -205, 1, -90)
ContentContainer.Position = UDim2.new(0, 200, 0, 82)
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

    local padding = Instance.new("UIPadding")
    padding.PaddingRight = UDim.new(0, 7)
    padding.Parent = tab

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = tab

    Tabs[name] = tab

    return tab
end

local PlayerTab = CreateTab("Player")
local FeaturesTab = CreateTab("Features")
local SettingsTab = CreateTab("Settings")

--//====================================================
--// TAB BUTTONS
--//====================================================

local function CreateTabButton(text, icon, y, target)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 46)
    button.Position = UDim2.new(0, 12, 0, y)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = button

    local activeBar = Instance.new("Frame")
    activeBar.Size = UDim2.new(0, 3, 0, 24)
    activeBar.Position = UDim2.new(0, 0, 0.5, -12)
    activeBar.BorderSizePixel = 0
    activeBar.Visible = false
    activeBar.Parent = button
    BindTheme(activeBar, "BackgroundColor3", "Accent2")

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 38, 1, 0)
    iconLabel.Position = UDim2.new(0, 10, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 17
    iconLabel.Parent = button
    BindTheme(iconLabel, "TextColor3", "Muted")

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -55, 1, 0)
    textLabel.Position = UDim2.new(0, 50, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 11
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button
    BindTheme(textLabel, "TextColor3", "Muted")

    local tabInfo = {
        Button = button,
        Text = textLabel,
        Icon = iconLabel,
        Bar = activeBar
    }

    table.insert(TabObjects, tabInfo)

    local function Activate()

        for _, tab in pairs(Tabs) do
            tab.Visible = false
        end

        for _, info in ipairs(TabObjects) do
            info.Bar.Visible = false
            info.Text.TextColor3 = Colors.Muted
            info.Icon.TextColor3 = Colors.Muted
            info.Button.BackgroundTransparency = 1
        end

        target.Visible = true

        activeBar.Visible = true
        textLabel.TextColor3 = Colors.White
        iconLabel.TextColor3 = Colors.Accent2

        button.BackgroundColor3 = Colors.Panel2
        button.BackgroundTransparency = 0

    end

    button.MouseButton1Click:Connect(Activate)

    button.MouseEnter:Connect(function()
        if not activeBar.Visible then
            TweenService:Create(
                button,
                TweenInfo.new(0.15),
                {BackgroundTransparency = 0.5}
            ):Play()
        end
    end)

    button.MouseLeave:Connect(function()
        if not activeBar.Visible then
            TweenService:Create(
                button,
                TweenInfo.new(0.15),
                {BackgroundTransparency = 1}
            ):Play()
        end
    end)

    return Activate
end

local activatePlayer = CreateTabButton(
    "Player",
    "♙",
    58,
    PlayerTab
)

local activateFeatures = CreateTabButton(
    "Game Cheats",
    "⚡",
    112,
    FeaturesTab
)

local activateSettings = CreateTabButton(
    "Settings",
    "⚙",
    166,
    SettingsTab
)

--//====================================================
--// UI HELPERS
--//====================================================

local function CreateSectionTitle(parent, title, subtitle, order)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -4, 0, 54)
    container.BackgroundTransparency = 1
    container.LayoutOrder = order or 0
    container.Parent = parent

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 27)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 17
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = container
    BindTheme(titleLabel, "TextColor3", "White")

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 28)
    sub.BackgroundTransparency = 1
    sub.Text = subtitle
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 10
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Parent = container
    BindTheme(sub, "TextColor3", "Muted")

    return container
end

local function CreateFeatureCard(parent, titleText, descText, order)

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 82)
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    card.Parent = parent

    BindTheme(card, "BackgroundColor3", "Card")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.82
    stroke.Parent = card
    BindTheme(stroke, "Color", "Accent")

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -24)
    accent.Position = UDim2.new(0, 0, 0, 12)
    accent.BorderSizePixel = 0
    accent.Parent = card
    BindTheme(accent, "BackgroundColor3", "Accent2")

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -105, 0, 24)
    title.Position = UDim2.new(0, 18, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    BindTheme(title, "TextColor3", "White")

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -105, 0, 32)
    desc.Position = UDim2.new(0, 18, 0, 36)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 10
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = card
    BindTheme(desc, "TextColor3", "Muted")

    return card
end

--//====================================================
--// MODERN TOGGLE
--//====================================================

local function CreateToggle(parent, callback)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 54, 0, 29)
    button.Position = UDim2.new(1, -69, 0.5, -14)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 21, 0, 21)
    knob.Position = UDim2.new(0, 4, 0.5, -10)
    knob.BorderSizePixel = 0
    knob.Parent = button

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Size = UDim2.new(0, 22, 1, 0)
    stateLabel.Position = UDim2.new(0, 30, 0, 0)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.TextSize = 8
    stateLabel.Parent = button

    local enabled = false

    local data = {
        Button = button,
        Knob = knob,
        Enabled = false
    }

    table.insert(ToggleObjects, data)

    local function Set(value)

        enabled = value
        data.Enabled = value

        if enabled then

            TweenService:Create(
                button,
                TweenInfo.new(0.18),
                {
                    BackgroundColor3 = Colors.Accent
                }
            ):Play()

            TweenService:Create(
                knob,
                TweenInfo.new(0.18, Enum.EasingStyle.Quart),
                {
                    Position = UDim2.new(1, -25, 0.5, -10),
                    BackgroundColor3 = Colors.White
                }
            ):Play()

            stateLabel.Text = "ON"
            stateLabel.TextColor3 = Colors.White

        else

            TweenService:Create(
                button,
                TweenInfo.new(0.18),
                {
                    BackgroundColor3 = Colors.Dark
                }
            ):Play()

            TweenService:Create(
                knob,
                TweenInfo.new(0.18, Enum.EasingStyle.Quart),
                {
                    Position = UDim2.new(0, 4, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(145,145,160)
                }
            ):Play()

            stateLabel.Text = "OFF"
            stateLabel.TextColor3 = Colors.Muted

        end

        if callback then
            callback(enabled)
        end
    end

    button.MouseButton1Click:Connect(function()
        Set(not enabled)
    end)

    Set(false)

    return button, Set
end

--//====================================================
--// PLAYER TAB
--//====================================================

CreateSectionTitle(
    PlayerTab,
    "Player Modifications",
    "Steuere Bewegung und Spielkomfort.",
    1
)

-- Anti AFK
local afkCard = CreateFeatureCard(
    PlayerTab,
    "Anti-AFK Protection",
    "Verhindert automatische Kicks wegen Inaktivität.",
    2
)

local antiAfkActive = false

local _, setAfk = CreateToggle(
    afkCard,
    function(enabled)

        antiAfkActive = enabled
        Settings.AntiAFK = enabled

        SaveConfig()
    end
)

LocalPlayer.Idled:Connect(function()

    if antiAfkActive then

        VirtualUser:Button2Down(
            Vector2.new(0,0),
            workspace.CurrentCamera.CFrame
        )

        task.wait(1)

        VirtualUser:Button2Up(
            Vector2.new(0,0),
            workspace.CurrentCamera.CFrame
        )

    end
end)

setAfk(Settings.AntiAFK)

-- WalkSpeed
local speedCard = CreateFeatureCard(
    PlayerTab,
    "WalkSpeed",
    "Lege deine gewünschte Laufgeschwindigkeit fest.",
    3
)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 68, 0, 34)
speedInput.Position = UDim2.new(1, -83, 0.5, -17)
speedInput.BorderSizePixel = 0
speedInput.Font = Enum.Font.GothamBold
speedInput.Text = tostring(Settings.WalkSpeed)
speedInput.TextSize = 12
speedInput.ClearTextOnFocus = false
speedInput.TextXAlignment = Enum.TextXAlignment.Center
speedInput.Parent = speedCard

BindTheme(speedInput, "BackgroundColor3", "Panel2")
BindTheme(speedInput, "TextColor3", "White")

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 9)
speedCorner.Parent = speedInput

local speedStroke = Instance.new("UIStroke")
speedStroke.Thickness = 1
speedStroke.Transparency = 0.6
speedStroke.Parent = speedInput
BindTheme(speedStroke, "Color", "Accent")

speedInput.FocusLost:Connect(function()

    local newSpeed = tonumber(speedInput.Text)

    if newSpeed then

        Settings.WalkSpeed = newSpeed
        SaveConfig()

        if LocalPlayer.Character then

            local humanoid =
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = newSpeed
            end
        end

    else

        speedInput.Text = tostring(Settings.WalkSpeed)

    end
end)

-- Fly
local flyCard = CreateFeatureCard(
    PlayerTab,
    "Fly Mode",
    "Fliege frei mit WASD, Space und LeftControl.",
    4
)

local flying = false
local bg
local bv

local function StopFly()

    flying = false

    if bg then
        bg:Destroy()
        bg = nil
    end

    if bv then
        bv:Destroy()
        bv = nil
    end
end

local _, setFly = CreateToggle(
    flyCard,
    function(enabled)

        Settings.Fly = enabled
        SaveConfig()

        if not enabled then
            StopFly()
            return
        end

        flying = true

        local char = LocalPlayer.Character

        if not char then
            return
        end

        local hrp =
            char:FindFirstChild("HumanoidRootPart")

        if not hrp then
            return
        end

        bg = Instance.new("BodyGyro")
        bg.P = 90000
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Parent = hrp

        task.spawn(function()

            while flying and hrp.Parent do

                local camera =
                    workspace.CurrentCamera

                local direction =
                    Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction += camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction -= camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction -= camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction += camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction += Vector3.new(0,1,0)
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    direction -= Vector3.new(0,1,0)
                end

                bv.Velocity = direction * 50
                bg.CFrame = camera.CFrame

                RunService.RenderStepped:Wait()
            end

            StopFly()
        end)
    end
)

setFly(Settings.Fly)

--//====================================================
--// FEATURES TAB
--//====================================================

CreateSectionTitle(
    FeaturesTab,
    "Game Automation",
    "Automatisierte Funktionen für das Spiel.",
    1
)

-- Speed Clicker
local clickCard = CreateFeatureCard(
    FeaturesTab,
    "Ultra Speed Clicker",
    "Fordert automatisch das Speed-Event an.",
    2
)

local autoFarmActive = false
local farmConnection

CreateToggle(
    clickCard,
    function(enabled)

        autoFarmActive = enabled

        if autoFarmActive then

            farmConnection =
                RunService.Heartbeat:Connect(function()

                    if increaseSpeedEvent then

                        pcall(function()
                            increaseSpeedEvent:FireServer()
                        end)

                    end

                end)

        else

            if farmConnection then
                farmConnection:Disconnect()
                farmConnection = nil
            end

        end
    end
)

-- Auto Spin
local spinCard = CreateFeatureCard(
    FeaturesTab,
    "Auto Claim / Free Spins",
    "Sammelt automatisch verfügbare Spins und Belohnungen.",
    3
)

local autoSpinActive = false

CreateToggle(
    spinCard,
    function(enabled)

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
    end
)

--//====================================================
--// AUTO BUY BEST ITEMS INTEGRATION
--//====================================================

local autoBuyCard = CreateFeatureCard(
    FeaturesTab,
    "Auto Buy Best Items",
    "Kauft automatisch die verfügbaren besseren Trail-, Aura- und Skin-Upgrades.",
    4
)

local autoBuyActive = false
local autoBuyRunning = false

-- Inventory purchase RemoteFunction
local inventoryEvents = ReplicatedStorage:FindFirstChild("InventoryEvents")
local inventoryAction = nil

if inventoryEvents then
    inventoryAction = inventoryEvents:FindFirstChild("Action")
end

-- Die gewünschten Upgrades.
-- Reihenfolge: Trail -> Aura -> Skin
local BestItems = {
    {
        Category = "Trail",
        Action = "BuyWins",
        Item = "Ash"
    },

    {
        Category = "Aura",
        Action = "BuyWins",
        Item = "Dust"
    },

    {
        Category = "Skin",
        Action = "BuyWins",
        Item = "Bronze"
    }
}

local function TryBuyBestItems()

    if not inventoryAction then
        inventoryEvents =
            ReplicatedStorage:FindFirstChild("InventoryEvents")

        if inventoryEvents then
            inventoryAction =
                inventoryEvents:FindFirstChild("Action")
        end
    end

    if not inventoryAction then
        return
    end

    for _, item in ipairs(BestItems) do

        if not autoBuyActive then
            break
        end

        pcall(function()

            inventoryAction:InvokeServer(
                item.Category,
                item.Action,
                item.Item,
                nil
            )

        end)

        task.wait(0.35)
    end
end

local function StartAutoBuy()

    if autoBuyRunning then
        return
    end

    autoBuyRunning = true

    task.spawn(function()

        while autoBuyActive do

            TryBuyBestItems()

            -- Nicht dauerhaft das Remote spammen
            task.wait(3)

        end

        autoBuyRunning = false

    end)
end

local _, setAutoBuy = CreateToggle(
    autoBuyCard,
    function(enabled)

        autoBuyActive = enabled
        Settings.AutoBuyBest = enabled

        SaveConfig()

        if enabled then
            StartAutoBuy()
        end

    end
)

-- Auto Buy beim Start wiederherstellen
task.defer(function()

    if Settings.AutoBuyBest then

        task.wait(0.5)
        setAutoBuy(true)

    end

end)

-- Auto Win section
CreateSectionTitle(
    FeaturesTab,
    "Auto Win Teleport",
    "Wähle eine Zielwelt für den Teleport.",
    5
)

--//====================================================
--// MODERN WORLD DROPDOWN
--//====================================================

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -4, 0, 48)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true
dropdownFrame.LayoutOrder = 6
dropdownFrame.Parent = FeaturesTab

BindTheme(dropdownFrame, "BackgroundColor3", "Card")

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 12)
dropdownCorner.Parent = dropdownFrame

local dropdownStroke = Instance.new("UIStroke")
dropdownStroke.Thickness = 1
dropdownStroke.Transparency = 0.75
dropdownStroke.Parent = dropdownFrame
BindTheme(dropdownStroke, "Color", "Accent")

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, 0, 0, 48)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Text = ""
dropdownBtn.Parent = dropdownFrame

local worldIcon = Instance.new("TextLabel")
worldIcon.Size = UDim2.new(0, 35, 0, 48)
worldIcon.Position = UDim2.new(0, 10, 0, 0)
worldIcon.BackgroundTransparency = 1
worldIcon.Text = "🌎"
worldIcon.TextSize = 17
worldIcon.Parent = dropdownFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, -90, 0, 48)
wsLabel.Position = UDim2.new(0, 48, 0, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = selectedWorld
wsLabel.TextSize = 12
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = dropdownFrame
BindTheme(wsLabel, "TextColor3", "White")

local wsSub = Instance.new("TextLabel")
wsSub.Size = UDim2.new(1, -90, 0, 16)
wsSub.Position = UDim2.new(0, 48, 0, 26)
wsSub.BackgroundTransparency = 1
wsSub.Text = "TARGET WORLD"
wsSub.TextSize = 7
wsSub.Font = Enum.Font.GothamBold
wsSub.TextXAlignment = Enum.TextXAlignment.Left
wsSub.Parent = dropdownFrame
BindTheme(wsSub, "TextColor3", "Muted")

local arrowLabel = Instance.new("TextLabel")
arrowLabel.Size = UDim2.new(0, 30, 0, 48)
arrowLabel.Position = UDim2.new(1, -40, 0, 0)
arrowLabel.BackgroundTransparency = 1
arrowLabel.Text = "⌄"
arrowLabel.TextSize = 18
arrowLabel.Font = Enum.Font.GothamBold
arrowLabel.Parent = dropdownFrame
BindTheme(arrowLabel, "TextColor3", "Accent2")

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, -16, 0, 145)
listScroll.Position = UDim2.new(0, 8, 0, 54)
listScroll.BackgroundTransparency = 1
listScroll.BorderSizePixel = 0
listScroll.ScrollBarThickness = 3
listScroll.CanvasSize = UDim2.new(0,0,0,0)
listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
listScroll.Parent = dropdownFrame

BindTheme(listScroll, "ScrollBarImageColor3", "Accent")

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = listScroll

for index, worldName in ipairs(winLocations) do

    local itemBtn = Instance.new("TextButton")
    itemBtn.Size = UDim2.new(1, -4, 0, 27)
    itemBtn.BorderSizePixel = 0
    itemBtn.Text = "   " .. worldName
    itemBtn.TextSize = 10
    itemBtn.Font = Enum.Font.GothamMedium
    itemBtn.TextXAlignment = Enum.TextXAlignment.Left
    itemBtn.AutoButtonColor = false
    itemBtn.LayoutOrder = index
    itemBtn.Parent = listScroll

    BindTheme(itemBtn, "BackgroundColor3", "Panel2")
    BindTheme(itemBtn, "TextColor3", "Text")

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 7)
    itemCorner.Parent = itemBtn

    itemBtn.MouseEnter:Connect(function()

        TweenService:Create(
            itemBtn,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 = Colors.Accent
            }
        ):Play()

    end)

    itemBtn.MouseLeave:Connect(function()

        TweenService:Create(
            itemBtn,
            TweenInfo.new(0.12),
            {
                BackgroundColor3 = Colors.Panel2
            }
        ):Play()

    end)

    itemBtn.MouseButton1Click:Connect(function()

        selectedWorld = worldName
        wsLabel.Text = selectedWorld

        dropdownOpen = false

        TweenService:Create(
            dropdownFrame,
            TweenInfo.new(
                0.22,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.new(1, -4, 0, 48)
            }
        ):Play()

        TweenService:Create(
            arrowLabel,
            TweenInfo.new(0.18),
            {
                Rotation = 0
            }
        ):Play()

    end)
end

local dropdownOpen = false

dropdownBtn.MouseButton1Click:Connect(function()

    dropdownOpen = not dropdownOpen

    local targetHeight =
        dropdownOpen and 205 or 48

    TweenService:Create(
        dropdownFrame,
        TweenInfo.new(
            0.25,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(1, -4, 0, targetHeight)
        }
    ):Play()

    TweenService:Create(
        arrowLabel,
        TweenInfo.new(0.2),
        {
            Rotation = dropdownOpen and 180 or 0
        }
    ):Play()

end)

-- Auto Win
local winCard = CreateFeatureCard(
    FeaturesTab,
    "Auto Win Teleport",
    "Teleportiert dich automatisch zur gewählten Welt.",
    7
)

local autoWinActive = false

CreateToggle(
    winCard,
    function(enabled)

        autoWinActive = enabled

        if autoWinActive then

            task.spawn(function()

                while autoWinActive do

                    pcall(function()

                        local char = LocalPlayer.Character

                        if not char then
                            return
                        end

                        local hrp =
                            char:FindFirstChild("HumanoidRootPart")

                        if not hrp then
                            return
                        end

                        local targetPart = nil

                        for _, folderName in ipairs({
                            "Wins",
                            "WorldGoals",
                            "GoalParts",
                            "Portals",
                            "Maps",
                            "Stages",
                            "Towers"
                        }) do

                            local folder =
                                workspace:FindFirstChild(folderName)

                            if folder then

                                local found =
                                    folder:FindFirstChild(
                                        selectedWorld,
                                        true
                                    )

                                if found then

                                    targetPart = found
                                    break

                                end

                                for _, descendant in ipairs(
                                    folder:GetDescendants()
                                ) do

                                    if descendant.Name:lower():find(
                                        selectedWorld:lower()
                                    ) then

                                        targetPart = descendant
                                        break

                                    end
                                end

                            end

                            if targetPart then
                                break
                            end
                        end

                        if not targetPart then

                            for _, descendant in ipairs(
                                workspace:GetDescendants()
                            ) do

                                if descendant.Name:lower():find(
                                    selectedWorld:lower()
                                )
                                and (
                                    descendant:IsA("BasePart")
                                    or descendant:IsA("Model")
                                ) then

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

                                finalPart =
                                    targetPart.PrimaryPart
                                    or targetPart:FindFirstChildWhichIsA(
                                        "BasePart",
                                        true
                                    )
                            end
                        end

                        if finalPart then

                            hrp.CFrame =
                                finalPart.CFrame
                                + Vector3.new(0,3,0)

                            if firetouchinterest then

                                firetouchinterest(
                                    hrp,
                                    finalPart,
                                    0
                                )

                                task.wait(0.05)

                                firetouchinterest(
                                    hrp,
                                    finalPart,
                                    1
                                )
                            end
                        end

                    end)

                    task.wait(3.5)

                end
            end)
        end
    end
)

-- Auto Rebirth
local rebirthCard = CreateFeatureCard(
    FeaturesTab,
    "Auto Rebirth",
    "Führt automatisch Rebirths aus, sobald verfügbar.",
    8
)

local autoRebirthActive = false

CreateToggle(
    rebirthCard,
    function(enabled)

        autoRebirthActive = enabled

        if autoRebirthActive then

            task.spawn(function()

                while autoRebirthActive do

                    pcall(function()

                        if rebirthEvent then

                            rebirthEvent:FireServer()

                        else

                            local found =
                                ReplicatedStorage:FindFirstChild(
                                    "RebirthEvent"
                                )

                            if found then
                                found:FireServer()
                            end

                        end

                    end)

                    task.wait(1)
                end
            end)
        end
    end
)

-- FPS Boost
local fpsCard = CreateFeatureCard(
    FeaturesTab,
    "FPS Boost",
    "Deaktiviert Partikel, Feuer und Sparkles.",
    9
)

CreateToggle(
    fpsCard,
    function(enabled)

        for _, object in ipairs(
            workspace:GetDescendants()
        ) do

            if object:IsA("ParticleEmitter")
            or object:IsA("Fire")
            or object:IsA("Sparkles") then

                object.Enabled = not enabled

            end
        end
    end
)

--//====================================================
--// SETTINGS
--//====================================================

CreateSectionTitle(
    SettingsTab,
    "Settings",
    "Passe Theme, Größe und Darstellung an.",
    1
)

--// THEME CARD
local themeCard = Instance.new("Frame")
themeCard.Size = UDim2.new(1, -4, 0, 205)
themeCard.BorderSizePixel = 0
themeCard.LayoutOrder = 2
themeCard.Parent = SettingsTab
BindTheme(themeCard, "BackgroundColor3", "Card")

local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 13)
themeCorner.Parent = themeCard

local themeTitle = Instance.new("TextLabel")
themeTitle.Size = UDim2.new(1, -30, 0, 25)
themeTitle.Position = UDim2.new(0, 18, 0, 12)
themeTitle.BackgroundTransparency = 1
themeTitle.Text = "Color Theme"
themeTitle.Font = Enum.Font.GothamBold
themeTitle.TextSize = 14
themeTitle.TextXAlignment = Enum.TextXAlignment.Left
themeTitle.Parent = themeCard
BindTheme(themeTitle, "TextColor3", "White")

local themeSubtitle = Instance.new("TextLabel")
themeSubtitle.Size = UDim2.new(1, -30, 0, 18)
themeSubtitle.Position = UDim2.new(0, 18, 0, 36)
themeSubtitle.BackgroundTransparency = 1
themeSubtitle.Text = "Wähle deinen persönlichen Look."
themeSubtitle.Font = Enum.Font.Gotham
themeSubtitle.TextSize = 9
themeSubtitle.TextXAlignment = Enum.TextXAlignment.Left
themeSubtitle.Parent = themeCard
BindTheme(themeSubtitle, "TextColor3", "Muted")

local ThemeButtons = {}

local ThemeOrder = {
    "Purple",
    "Blue",
    "Red",
    "Green",
    "Cyan",
    "Gold"
}

for index, themeName in ipairs(ThemeOrder) do

    local row =
        math.floor((index - 1) / 3)

    local column =
        (index - 1) % 3

    local theme = Themes[themeName]

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 108, 0, 45)
    button.Position = UDim2.new(
        0,
        18 + column * 116,
        0,
        64 + row * 52
    )
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = themeCard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 22, 0, 22)
    preview.Position = UDim2.new(0, 9, 0.5, -11)
    preview.BorderSizePixel = 0
    preview.BackgroundColor3 = theme.Accent
    preview.Parent = button

    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(1, 0)
    previewCorner.Parent = preview

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -38, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = themeName
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button

    ThemeButtons[themeName] = {
        Button = button,
        Label = label,
        Preview = preview
    }

end

--//====================================================
--// UI SIZE CARD
--//====================================================

local sizeCard = Instance.new("Frame")
sizeCard.Size = UDim2.new(1, -4, 0, 205)
sizeCard.BorderSizePixel = 0
sizeCard.LayoutOrder = 3
sizeCard.Parent = SettingsTab
BindTheme(sizeCard, "BackgroundColor3", "Card")

local sizeCorner = Instance.new("UICorner")
sizeCorner.CornerRadius = UDim.new(0, 13)
sizeCorner.Parent = sizeCard

local sizeTitle = Instance.new("TextLabel")
sizeTitle.Size = UDim2.new(1, -30, 0, 25)
sizeTitle.Position = UDim2.new(0, 18, 0, 12)
sizeTitle.BackgroundTransparency = 1
sizeTitle.Text = "Interface Size"
sizeTitle.Font = Enum.Font.GothamBold
sizeTitle.TextSize = 14
sizeTitle.TextXAlignment = Enum.TextXAlignment.Left
sizeTitle.Parent = sizeCard
BindTheme(sizeTitle, "TextColor3", "White")

local sizeSubtitle = Instance.new("TextLabel")
sizeSubtitle.Size = UDim2.new(1, -30, 0, 18)
sizeSubtitle.Position = UDim2.new(0, 18, 0, 36)
sizeSubtitle.BackgroundTransparency = 1
sizeSubtitle.Text = "Passe die Größe an deinen Bildschirm an."
sizeSubtitle.Font = Enum.Font.Gotham
sizeSubtitle.TextSize = 9
sizeSubtitle.TextXAlignment = Enum.TextXAlignment.Left
sizeSubtitle.Parent = sizeCard
BindTheme(sizeSubtitle, "TextColor3", "Muted")

local SizeButtons = {}

local SizeOrder = {
    {"TINY", 0.45},
    {"SMALL", 0.58},
    {"MOBILE", 0.70},
    {"NORMAL", 0.82},
    {"LARGE", 0.95},
    {"XL", 1.08}
}

for index, option in ipairs(SizeOrder) do

    local name = option[1]
    local scale = option[2]

    local row =
        math.floor((index - 1) / 3)

    local column =
        (index - 1) % 3

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 108, 0, 45)
    button.Position = UDim2.new(
        0,
        18 + column * 116,
        0,
        64 + row * 52
    )
    button.BorderSizePixel = 0
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 9
    button.AutoButtonColor = false
    button.Parent = sizeCard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    SizeButtons[name] = button

    button.MouseButton1Click:Connect(function()

        Settings.UISize = name
        UIScale.Scale = scale

        SaveConfig()

        for optionName, btn in pairs(SizeButtons) do

            if optionName == name then

                btn.BackgroundColor3 = Colors.Accent
                btn.TextColor3 = Colors.White

            else

                btn.BackgroundColor3 = Colors.Panel2
                btn.TextColor3 = Colors.Muted

            end
        end
    end)
end

--//====================================================
--// THEME APPLY
--//====================================================

local function ApplyTheme(themeName)

    if not Themes[themeName] then
        return
    end

    LoadTheme(themeName)

    Settings.Theme = themeName

    SaveConfig()

    for _, binding in ipairs(ThemeBindings) do

        if binding.Object
        and binding.Object.Parent then

            local color =
                Colors[binding.Color]

            if color then
                binding.Object[binding.Property] = color
            end
        end
    end

    -- Toggles
    for _, toggle in ipairs(ToggleObjects) do

        if toggle.Enabled then

            toggle.Button.BackgroundColor3 =
                Colors.Accent

            toggle.Knob.BackgroundColor3 =
                Colors.White

        else

            toggle.Button.BackgroundColor3 =
                Colors.Dark

            toggle.Knob.BackgroundColor3 =
                Color3.fromRGB(145,145,160)

        end
    end

    -- Theme buttons
    for name, info in pairs(ThemeButtons) do

        if name == themeName then

            info.Button.BackgroundColor3 =
                Colors.Accent

            info.Label.TextColor3 =
                Colors.White

        else

            info.Button.BackgroundColor3 =
                Colors.Panel2

            info.Label.TextColor3 =
                Colors.Muted

        end
    end

    -- Size buttons
    for name, button in pairs(SizeButtons) do

        if name == Settings.UISize then

            button.BackgroundColor3 =
                Colors.Accent

            button.TextColor3 =
                Colors.White

        else

            button.BackgroundColor3 =
                Colors.Panel2

            button.TextColor3 =
                Colors.Muted

        end
    end
end

for themeName, info in pairs(ThemeButtons) do

    info.Button.MouseButton1Click:Connect(function()
        ApplyTheme(themeName)
    end)

end

ApplyTheme(Settings.Theme)

--//====================================================
--// DRAGGING
--//====================================================

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position

        input.Changed:Connect(function()

            if input.UserInputState ==
                Enum.UserInputState.End then

                dragging = false

            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position - dragStart

        MainFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

--//====================================================
--// OPEN BUTTON
--//====================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 130, 0, 44)
OpenButton.Position = UDim2.new(0, 18, 0.5, -22)
OpenButton.BorderSizePixel = 0
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "⚡  CYSON"
OpenButton.TextSize = 11
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

CloseButton.MouseButton1Click:Connect(function()

    MainFrame.Visible = false
    OpenButton.Visible = true

end)

OpenButton.MouseButton1Click:Connect(function()

    MainFrame.Visible = true
    OpenButton.Visible = false

end)

--//====================================================
--// CAMERA RESIZE
--//====================================================

if workspace.CurrentCamera then

    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(function()

        if Settings.UISize == "AUTO" then
            ApplyUIScale()
        end

    end)

end

--//====================================================
--// INITIAL TAB
--//====================================================

activatePlayer()

print("CYSON HUB - Modern UI erfolgreich geladen!")
