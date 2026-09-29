--//====================================================
--// CYSON VALUABLES HUB (MOBILE & PC COMPATIBLE)
--//====================================================

--// SERVICES
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

--// CHARACTER HELPER
local function GetRoot()
    if not LocalPlayer then return nil end
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

--// REMOVE OLD UI
pcall(function()
    if CoreGui:FindFirstChild("CYSONValuablesHub") then
        CoreGui.CYSONValuablesHub:Destroy()
    end
end)

--// THEME (PURPLE/CYBER)
local Colors = {
    Background = Color3.fromRGB(7, 8, 16),
    Panel = Color3.fromRGB(12, 13, 24),
    Card = Color3.fromRGB(15, 17, 29),
    Accent = Color3.fromRGB(132, 60, 255),
    Accent2 = Color3.fromRGB(190, 70, 255),
    Green = Color3.fromRGB(50, 220, 130),
    Red = Color3.fromRGB(255, 65, 85),
    White = Color3.fromRGB(245, 245, 255),
    Text = Color3.fromRGB(205, 208, 230),
    Muted = Color3.fromRGB(125, 130, 155),
    Dark = Color3.fromRGB(30, 32, 48)
}

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CYSONValuablesHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

--// MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 310)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Color = Colors.Accent
MainStroke.Parent = MainFrame

local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.85
UIScale.Parent = MainFrame

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundColor3 = Colors.Panel
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local TopBottom = Instance.new("Frame")
TopBottom.Size = UDim2.new(1, 0, 0, 15)
TopBottom.Position = UDim2.new(0, 0, 1, -15)
TopBottom.BackgroundColor3 = Colors.Panel
TopBottom.BorderSizePixel = 0
TopBottom.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 26)
Title.Position = UDim2.new(0, 18, 0, 17)
Title.BackgroundTransparency = 1
Title.Text = "💎 CYSON VALUABLES FARM"
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Colors.White
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -44, 0.5, -16)
CloseButton.BackgroundColor3 = Colors.Dark
CloseButton.TextColor3 = Colors.White
CloseButton.Text = "×"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.AutoButtonColor = false
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

--// CONTENT CONTAINER
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -24, 1, -75)
ContentContainer.Position = UDim2.new(0, 12, 0, 68)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Colors.Accent
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 12)
UIListLayout.Parent = ContentContainer

--// TOGGLE CREATOR HELPER
local function CreateValuableToggle(titleText, descText, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, 75)
    card.BackgroundColor3 = Colors.Card
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.8
    stroke.Color = Colors.Accent
    stroke.Parent = card

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -20)
    accent.Position = UDim2.new(0, 0, 0, 10)
    accent.BackgroundColor3 = Colors.Accent2
    accent.BorderSizePixel = 0
    accent.Parent = card

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accent

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 0, 22)
    title.Position = UDim2.new(0, 16, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Colors.White
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -90, 0, 26)
    desc.Position = UDim2.new(0, 16, 0, 34)
    desc.BackgroundTransparency = 1
    desc.Text = descText
    desc.Font = Enum.Font.Gotham
    desc.TextColor3 = Colors.Muted
    desc.TextSize = 9
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = card

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 26)
    button.Position = UDim2.new(1, -62, 0.5, -13)
    button.BackgroundColor3 = Colors.Dark
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = button

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 4, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(145, 145, 160)
    knob.BorderSizePixel = 0
    knob.Parent = button

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local stateLabel = Instance.new("TextLabel")
    stateLabel.Size = UDim2.new(0, 20, 1, 0)
    stateLabel.Position = UDim2.new(0, 26, 0, 0)
    stateLabel.BackgroundTransparency = 1
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.TextColor3 = Colors.Muted
    stateLabel.TextSize = 7
    stateLabel.Text = "OFF"
    stateLabel.Parent = button

    local enabled = false

    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Accent}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -22, 0.5, -9), BackgroundColor3 = Colors.White}):Play()
            stateLabel.Text = "ON"
            stateLabel.TextColor3 = Colors.White
        else
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Dark}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 4, 0.5, -9), BackgroundColor3 = Color3.fromRGB(145, 145, 160)}):Play()
            stateLabel.Text = "OFF"
            stateLabel.TextColor3 = Colors.Muted
        end
    end)

    return function() return enabled end
end

--// LOGIK & TOGGLES ERSTELLEN

-- 1. Fly Valuables + Mobile Touch / ProximityPrompt Support
local GetValEnabled = CreateValuableToggle("Fly Valuables + Loot", "Teleportiert zu Wertsachen/Coins & triggert Touch/Prompts.", 1)

task.spawn(function()
    while true do
        if GetValEnabled() then
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not GetValEnabled() then break end
                    local nameLower = obj.Name:lower()
                    if nameLower:find("valuable") or nameLower:find("coin") or nameLower:find("loot") or nameLower:find("item") or nameLower:find("cash") then
                        local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if part then
                            pcall(function()
                                rootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            end)
                            task.wait(0.05)
                            
                            -- PC Unterstützung (Taste F)
                            pcall(function()
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                task.wait(0.02)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                            end)

                            -- Handy / Mobile Unterstützung (ProximityPrompts automatisch auslösen)
                            pcall(function()
                                for _, prompt in ipairs(obj:GetDescendants()) do
                                    if prompt:IsA("ProximityPrompt") then
                                        fireproximityprompt(prompt)
                                    end
                                end
                                if obj:IsA("Model") then
                                    for _, prompt in ipairs(obj:GetDescendants()) do
                                        if prompt:IsA("ProximityPrompt") then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end)

                            task.wait(0.2)
                        end
                    end
                end
            end
            task.wait(0.4)
        else
            task.wait(0.5)
        end
    end
end)


--// OPEN BUTTON (WENN UI GESCHLOSSEN WIRD)
OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 110, 0, 40)
OpenButton.Position = UDim2.new(0, 15, 0.5, -20)
OpenButton.BackgroundColor3 = Colors.Panel
OpenButton.TextColor3 = Colors.White
OpenButton.Text = "💎 OPEN"
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 11
OpenButton.Visible = false
OpenButton.AutoButtonColor = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 1.5
OpenStroke.Color = Colors.Accent
OpenStroke.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

--// DRAGGING (FÜR MOBILE & PC)
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
