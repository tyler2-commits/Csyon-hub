--//====================================================
--// CYSON HUB - AUTO CAR SCANNER & MODERN UI
--//====================================================

--// SERVICES
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

-- Remote Event über Pfad holen
local ParkingGame = ReplicatedStorage:FindFirstChild("ParkingGame")
local Event = ParkingGame and ParkingGame:FindFirstChild("Action")

local CarsFolder = Workspace:WaitForChild("LocalParkingVisuals"):WaitForChild("Cars")

local AutoCarRunning = false
local AutoCarThread = nil

local selectedCarColor = "blau"

--// CHARACTER HELPER
local function GetRoot()
    if not LocalPlayer then return nil end
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

--//====================================================
--// REMOVE OLD UI
--//====================================================

pcall(function()
    if CoreGui:FindFirstChild("CYSONHubUI") then
        CoreGui.CYSONHubUI:Destroy()
    end
end)

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

LoadTheme(CurrentTheme)

--// UI REFERENCES
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

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CYSONHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

--// MAIN WINDOW
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
UIScale.Scale = 0.70
UIScale.Parent = MainFrame

--// TOP BAR
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
Subtitle.Text = "Clean interface • Fast controls • UI Only"
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar
BindTheme(Subtitle, "TextColor3", "Muted")

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
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Red}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Dark}):Play()
end)

--// SIDEBAR
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

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -28, 0, 1)
Divider.Position = UDim2.new(0, 14, 0, 43)
Divider.BorderSizePixel = 0
Divider.Parent = Sidebar
BindTheme(Divider, "BackgroundColor3", "Dark")

--// CONTENT
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
local ValuablesTab = CreateTab("Valuables")
local SettingsTab = CreateTab("Settings")

--// TAB BUTTONS
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
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
        end
    end)

    button.MouseLeave:Connect(function()
        if not activeBar.Visible then
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end)

    return Activate
end

CreateTabButton("Player", "♙", 58, PlayerTab)
CreateTabButton("Game Cheats", "⚡", 110, FeaturesTab)
CreateTabButton("Valuables & Farm", "💎", 162, ValuablesTab)
CreateTabButton("Settings", "⚙", 214, SettingsTab)

--// UI HELPERS
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

local function CreateToggle(parent)
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
    local data = { Button = button, Knob = knob, Enabled = false }
    table.insert(ToggleObjects, data)

    local function Set(value)
        enabled = value
        data.Enabled = value
        if enabled then
            TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = Colors.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -25, 0.5, -10), BackgroundColor3 = Colors.White}):Play()
            stateLabel.Text = "ON"
            stateLabel.TextColor3 = Colors.White
        else
            TweenService:Create(button, TweenInfo.new(0.18), {BackgroundColor3 = Colors.Dark}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 4, 0.5, -10), BackgroundColor3 = Color3.fromRGB(145,145,160)}):Play()
            stateLabel.Text = "OFF"
            stateLabel.TextColor3 = Colors.Muted
        end
    end

    button.MouseButton1Click:Connect(function()
        Set(not enabled)
    end)

    Set(false)
    return button, Set
end

--// BUILD TABS CONTENT

-- Player Tab
CreateSectionTitle(PlayerTab, "Player Modifications", "Steuere Bewegung und Spielkomfort.", 1)
local antiAfkCard = CreateFeatureCard(PlayerTab, "Anti-AFK Protection", "Verhindert automatische Kicks wegen Inaktivität.", 2)
CreateToggle(antiAfkCard)

-- Features Tab (Game Automation & Autofarm Farbe)
CreateSectionTitle(FeaturesTab, "Game Automation", "Automatisierte Funktionen für das Spiel.", 1)

local AutoCarCard = CreateFeatureCard(FeaturesTab, "Auto Collect Cars", "Scannt Autos von 1 bis 100.000 via Remote und teleportiert danach.", 2)
local AutoCarToggle, SetAutoCarToggle = CreateToggle(AutoCarCard)

local function StartAutoCars()
    if AutoCarRunning then return end
    AutoCarRunning = true

    AutoCarThread = task.spawn(function()
        while AutoCarRunning do
            for i = 1, 100000 do
                if not AutoCarRunning then break end

                local carName = "Car_" .. tostring(i)
                local car = CarsFolder:FindFirstChild(carName)

                if car then
                    pcall(function()
                        if Event then Event:FireServer("Search") end
                    end)
                    
                    task.wait(0.05)

                    local root = GetRoot()
                    local target = car:IsA("BasePart") and car or (car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart", true))

                    if root and target then
                        root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                    end

                    task.wait(0.15)
                end

                if i % 100 == 0 then
                    task.wait(0.03)
                end
            end

            if AutoCarRunning then
                task.wait(1)
            end
        end
    end)
end

local function StopAutoCars()
    AutoCarRunning = false
    AutoCarThread = nil
end

AutoCarToggle.MouseButton1Click:Connect(function()
    task.spawn(function()
        task.wait(0.01)
        if AutoCarRunning then
            StopAutoCars()
            SetAutoCarToggle(false)
        else
            StartAutoCars()
            SetAutoCarToggle(true)
        end
    end)
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if AutoCarRunning then
        StopAutoCars()
        SetAutoCarToggle(false)
    end
end)


--// VALUABLES & INTEGRATED FUNCTIONS TAB
CreateSectionTitle(ValuablesTab, "Valuables & Extra Cheats", "Sammle Wertsachen und steuere Autofarm-Farben.", 1)

-- Farbauswahl Card / Button
local ColorCard = CreateFeatureCard(ValuablesTab, "Autofarm Farbe", "Wechsle die Zielfarbe für den Car-Farm (Blau / Rot).", 2)
local ColorBtn = Instance.new("TextButton")
ColorBtn.Size = UDim2.new(0, 110, 0, 32)
ColorBtn.Position = UDim2.new(1, -125, 0.5, -16)
ColorBtn.BackgroundColor3 = Color3.fromRGB(2, 99, 255)
ColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorBtn.TextSize = 11
ColorBtn.Font = Enum.Font.GothamBold
ColorBtn.Text = "BLAU"
ColorBtn.Parent = ColorCard

local ColorCorner = Instance.new("UICorner")
ColorCorner.CornerRadius = UDim.new(0, 8)
ColorCorner.Parent = ColorBtn

ColorBtn.MouseButton1Click:Connect(function()
    if selectedCarColor == "blau" then
        selectedCarColor = "rot"
        ColorBtn.Text = "ROT"
        ColorBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        selectedCarColor = "blau"
        ColorBtn.Text = "BLAU"
        ColorBtn.BackgroundColor3 = Color3.fromRGB(2, 99, 255)
    end
end)

-- 1. Auto-Collect (1321)
local collectCard = CreateFeatureCard(ValuablesTab, "Auto-Collect (1321)", "Führt automatisch Collect-Events im Hintergrund aus.", 3)
local _, setCollect = CreateToggle(collectCard)
task.spawn(function()
    while true do
        local state = _G.AutoCollect1321
        if state then
            if Event then pcall(function() Event:FireServer("Collect", 1321) end) end
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)
-- Verknüpfe den UI-Toggle mit der Logik
local originalCollectClick = collectCard:FindFirstChildWhichIsA("TextButton", true)
if originalCollectClick then
    -- Wir hängen uns an den bestehenden Click-Event
end

-- 2. Auto-Search Event
local searchCard = CreateFeatureCard(ValuablesTab, "Auto-Search Event", "Sendet kontinuierlich Suchanfragen an den Server.", 4)
local _, setSearch = CreateToggle(searchCard)
task.spawn(function()
    while true do
        if _G.AutoSearchState then
            if Event then pcall(function() Event:FireServer("Search") end) end
            task.wait(0.4)
        else
            task.wait(0.5)
        end
    end
end)

-- 3. Fly Car Farm + E
local flyCarCard = CreateFeatureCard(ValuablesTab, "Fly Car Farm + E", "Teleportiert zu passenden Autos und drückt automatisch E.", 5)
local _, setFlyCar = CreateToggle(flyCarCard)
task.spawn(function()
    local visitedCars = {}
    while true do
        if _G.FlyCarFarmState then
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not _G.FlyCarFarmState then break end
                    if obj:IsA("Model") then
                        local isTargetCar = false
                        for _, part in ipairs(obj:GetDescendants()) do
                            if part:IsA("BasePart") then
                                local col = part.Color
                                local r, g, b = math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5)
                                if selectedCarColor == "blau" and math.abs(r - 2) <= 25 and math.abs(g - 99) <= 25 and math.abs(b - 255) <= 25 then
                                    isTargetCar = true; break
                                elseif selectedCarColor == "rot" and math.abs(r - 255) <= 35 and math.abs(g - 50) <= 35 and math.abs(b - 50) <= 35 then
                                    isTargetCar = true; break
                                end
                            end
                        end
                        if isTargetCar and not visitedCars[obj] then
                            local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if primaryPart then
                                visitedCars[obj] = true
                                pcall(function()
                                    rootPart.CFrame = primaryPart.CFrame + Vector3.new(0, 4, 0)
                                end)
                                task.wait(0.05)
                                pcall(function()
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                    task.wait(0.03)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                    if Event then Event:FireServer("Collect", 1321) end
                                end)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

-- 4. Fly Valuables + F
local flyValCard = CreateFeatureCard(ValuablesTab, "Fly Valuables + F", "Sucht nach Valuables/Coins/Loot, teleportiert hin und drückt F.", 6)
local _, setFlyVal = CreateToggle(flyValCard)
task.spawn(function()
    while true do
        if _G.FlyValuablesState then
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not _G.FlyValuablesState then break end
                    local nameLower = obj.Name:lower()
                    if nameLower:find("valuable") or nameLower:find("coin") or nameLower:find("loot") or nameLower:find("item") then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part then
                            pcall(function()
                                rootPart.CFrame = part.CFrame + Vector3.new(0, 4, 0)
                            end)
                            task.wait(0.05)
                            pcall(function()
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                task.wait(0.03)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                            end)
                            task.wait(0.25)
                        end
                    end
                end
            end
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end)

-- Globale Toggles mit den UI-Schaltern verbinden
collectCard:FindFirstChildWhichIsA("TextButton", true).MouseButton1Click:Connect(function()
    task.wait(0.01)
    _G.AutoCollect1321 = not _G.AutoCollect1321
end)

searchCard:FindFirstChildWhichIsA("TextButton", true).MouseButton1Click:Connect(function()
    task.wait(0.01)
    _G.AutoSearchState = not _G.AutoSearchState
end)

flyCarCard:FindFirstChildWhichIsA("TextButton", true).MouseButton1Click:Connect(function()
    task.wait(0.01)
    _G.FlyCarFarmState = not _G.FlyCarFarmState
end)

flyValCard:FindFirstChildWhichIsA("TextButton", true).MouseButton1Click:Connect(function()
    task.wait(0.01)
    _G.FlyValuablesState = not _G.FlyValuablesState
end)


-- Settings Tab
CreateSectionTitle(SettingsTab, "Settings", "Passe Theme, Größe und Darstellung an.", 1)

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

local ThemeButtons = {}
local ThemeOrder = {"Purple", "Blue", "Red", "Green", "Cyan", "Gold"}

for index, themeName in ipairs(ThemeOrder) do
    local row = math.floor((index - 1) / 3)
    local column = (index - 1) % 3
    local theme = Themes[themeName]

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 108, 0, 45)
    button.Position = UDim2.new(0, 18 + column * 116, 0, 64 + row * 52)
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

    ThemeButtons[themeName] = { Button = button, Label = label }
end

local function ApplyTheme(themeName)
    if not Themes[themeName] then return end
    LoadTheme(themeName)

    for _, binding in ipairs(ThemeBindings) do
        if binding.Object and binding.Object.Parent then
            local color = Colors[binding.Color]
            if color then
                binding.Object[binding.Property] = color
            end
        end
    end

    for _, toggle in ipairs(ToggleObjects) do
        if toggle.Enabled then
            toggle.Button.BackgroundColor3 = Colors.Accent
            toggle.Knob.BackgroundColor3 = Colors.White
        else
            toggle.Button.BackgroundColor3 = Colors.Dark
            toggle.Knob.BackgroundColor3 = Color3.fromRGB(145,145,160)
        end
    end

    for name, info in pairs(ThemeButtons) do
        if name == themeName then
            info.Button.BackgroundColor3 = Colors.Accent
            info.Label.TextColor3 = Colors.White
        else
            info.Button.BackgroundColor3 = Colors.Panel2
            info.Label.TextColor3 = Colors.Muted
        end
    end
end

for themeName, info in pairs(ThemeButtons) do
    info.Button.MouseButton1Click:Connect(function()
        ApplyTheme(themeName)
    end)
end

ApplyTheme("Purple")

--// DRAGGING
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
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

--// OPEN / CLOSE
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
