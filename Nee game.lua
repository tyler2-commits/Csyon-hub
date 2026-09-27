-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Exakter direkter Zugriff auf das Event über deine Liste
local ParkingGame = ReplicatedStorage:WaitForChild("ParkingGame")
local ActionEvent = ParkingGame:WaitForChild("Action")

print("ParkingGame UI geladen. Event gefunden:", ActionEvent ~= nil)

-- Altes GUI löschen falls vorhanden
if CoreGui:FindFirstChild("ParkingGameUI") then
	CoreGui.ParkingGameUI:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ParkingGameUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
        return
    end
end)
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 430)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 140)
UIStroke.Transparency = 0.5
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Top-Bar (Titel)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local FixFrame = Instance.new("Frame")
FixFrame.Size = UDim2.new(1, 0, 0, 10)
FixFrame.Position = UDim2.new(0, 0, 1, -10)
FixFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
FixFrame.BorderSizePixel = 0
FixFrame.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "⚡ PARKING GAME HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -38, 0, 11)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Container für Elemente
local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -40, 1, -110)
ContainerFrame.Position = UDim2.new(0, 20, 0, 60)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = ContainerFrame

-- Variable für die Autofarm-Farbe ("blau" oder "rot")
local selectedCarColor = "blau"

-- 1. Farbauswahl-Reihe
local ColorPickerFrame = Instance.new("Frame")
ColorPickerFrame.Size = UDim2.new(1, 0, 0, 45)
ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ColorPickerFrame.BorderSizePixel = 0
ColorPickerFrame.Parent = ContainerFrame

local CPCorner = Instance.new("UICorner")
CPCorner.CornerRadius = UDim.new(0, 10)
CPCorner.Parent = ColorPickerFrame

local CPLabel = Instance.new("TextLabel")
CPLabel.Size = UDim2.new(1, -120, 1, 0)
CPLabel.Position = UDim2.new(0, 15, 0, 0)
CPLabel.Text = "Autofarm Farbe"
CPLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
CPLabel.TextSize = 13
CPLabel.Font = Enum.Font.GothamMedium
CPLabel.TextXAlignment = Enum.TextXAlignment.Left
CPLabel.BackgroundTransparency = 1
CPLabel.Parent = ColorPickerFrame

local ColorSwitchBtn = Instance.new("TextButton")
ColorSwitchBtn.Size = UDim2.new(0, 90, 0, 26)
ColorSwitchBtn.Position = UDim2.new(1, -100, 0.5, -13)
ColorSwitchBtn.BackgroundColor3 = Color3.fromRGB(2, 99, 255)
ColorSwitchBtn.Text = "BLAU"
ColorSwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorSwitchBtn.TextSize = 12
ColorSwitchBtn.Font = Enum.Font.GothamBold
ColorSwitchBtn.Parent = ColorPickerFrame

local CSBCorner = Instance.new("UICorner")
CSBCorner.CornerRadius = UDim.new(0, 8)
CSBCorner.Parent = ColorSwitchBtn

ColorSwitchBtn.MouseButton1Click:Connect(function()
    if selectedCarColor == "blau" then
        selectedCarColor = "rot"
        ColorSwitchBtn.Text = "ROT"
        ColorSwitchBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        selectedCarColor = "blau"
        ColorSwitchBtn.Text = "BLAU"
        ColorSwitchBtn.BackgroundColor3 = Color3.fromRGB(2, 99, 255)
    end
end)

-- Generator für moderne Toggles
local function createToggleRow(labelText, defaultState)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ContainerFrame

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 10)
    FrameCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.Text = labelText
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Parent = ToggleFrame

    local ToggleBg = Instance.new("TextButton")
    ToggleBg.Size = UDim2.new(0, 44, 0, 22)
    ToggleBg.Position = UDim2.new(1, -54, 0.5, -11)
    ToggleBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(45, 45, 55)
    ToggleBg.AutoButtonColor = false
    ToggleBg.Text = ""
    ToggleBg.Parent = ToggleFrame

    local ToggleBgCorner = Instance.new("UICorner")
    ToggleBgCorner.CornerRadius = UDim.new(1, 0)
    ToggleBgCorner.Parent = ToggleBg

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleBg

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle

    return ToggleBg, ToggleCircle
end

local CollectToggleBtn, CollectCircle = createToggleRow("Auto-Collect (1321)", false)
local SearchToggleBtn, SearchCircle = createToggleRow("Auto-Search Event", false)

-- Footer Status
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -40, 0, 25)
Footer.Position = UDim2.new(0, 20, 1, -35)
Footer.Text = "Status: Bereit"
Footer.TextColor3 = Color3.fromRGB(0, 255, 140)
Footer.TextSize = 12
Footer.Font = Enum.Font.GothamMedium
Footer.BackgroundTransparency = 1
Footer.TextXAlignment = Enum.TextXAlignment.Left
Footer.Parent = MainFrame

-- Logik
local autoCollectActive = false
local autoSearchActive = false

CollectToggleBtn.MouseButton1Click:Connect(function()
    autoCollectActive = not autoCollectActive
    CollectCircle.Position = autoCollectActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    CollectToggleBtn.BackgroundColor3 = autoCollectActive and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(45, 45, 55)

    if autoCollectActive then
        task.spawn(function()
            while autoCollectActive do
                pcall(function()
                    ActionEvent:FireServer("Collect", 1321)
                end)
                task.wait(0.1)
            end
        end)
    end
end)

SearchToggleBtn.MouseButton1Click:Connect(function()
    autoSearchActive = not autoSearchActive
    SearchCircle.Position = autoSearchActive and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    SearchToggleBtn.BackgroundColor3 = autoSearchActive and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(45, 45, 55)

    if autoSearchActive then
        task.spawn(function()
            while autoSearchActive do
                pcall(function()
                    ActionEvent:FireServer("Search")
                end)
                task.wait(0.4)
            end
        end)
    end
end)
