-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

-- Funktion zum sicheren Abrufen des Remote Events erst bei Bedarf
local function getActionEvent()
	local parkingGame = ReplicatedStorage:FindFirstChild("ParkingGame")
	if parkingGame then
		return parkingGame:FindFirstChild("Action")
	end
	return nil
end

-- Altes GUI löschen falls vorhanden
if CoreGui:FindFirstChild("ParkingGameUI") then
	CoreGui.ParkingGameUI:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ParkingGameUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- Main Frame (Startet klein für die Öffnungs-Animation)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
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

-- Öffnungs-Animation beim Start
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 380, 0, 390),
	Position = UDim2.new(0.5, -190, 0.5, -195)
}):Play()

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
	local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tw:Play()
	tw.Completed:Connect(function()
		ScreenGui:Destroy()
	end)
end)

-- Container für Toggles
local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -40, 1, -120)
ContainerFrame.Position = UDim2.new(0, 20, 0, 65)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)
UIList.Parent = ContainerFrame

-- Generator für moderne Toggles im einheitlichen Look
local function createToggleRow(labelText, defaultState)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 48)
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

-- Toggles erstellen
local CollectToggleBtn, CollectCircle = createToggleRow("Auto-Collect (1321)", false)
local SearchToggleBtn, SearchCircle = createToggleRow("Auto-Search Event", false)
local TeleportBlueCarBtn, TeleportBlueCarCircle = createToggleRow("Fly Blue Cars (2,99,255) + E", false)
local TeleportValuablesBtn, TeleportValuablesCircle = createToggleRow("Fly Valuables + F", false)

-- Footer Status
local Footer = Instance.new("TextLabel")
Footer.Name = "FooterStatus"
Footer.Size = UDim2.new(1, -40, 0, 30)
Footer.Position = UDim2.new(0, 20, 1, -40)
Footer.Text = "Status: Bereit"
Footer.TextColor3 = Color3.fromRGB(0, 255, 140)
Footer.TextSize = 12
Footer.Font = Enum.Font.GothamMedium
Footer.BackgroundTransparency = 1
Footer.TextXAlignment = Enum.TextXAlignment.Left
Footer.Parent = MainFrame

---------------------------------------------------------
-- Logik & Ereignisse
---------------------------------------------------------

local autoCollectActive = false
local autoSearchActive = false
local autoTeleportBlueCarActive = false
local autoTeleportValuablesActive = false

local collectThread = nil
local searchThread = nil
local teleportBlueCarThread = nil
local teleportValuablesThread = nil

local visitedCars = {}

local function pressKey(keyCode)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.03)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

local function smoothFlyTo(rootPart, targetCFrame, duration)
    pcall(function()
        local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 4, 0)})
        tween:Play()
        tween.Completed:Wait()
    end)
end

local function updateToggleVisual(btn, circle, state)
    local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    local targetBgColor = state and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(45, 45, 55)

    TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = targetPos
    }):Play()

    TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundColor3 = targetBgColor
    }):Play()
end

-- 1. Auto-Collect
CollectToggleBtn.MouseButton1Click:Connect(function()
    autoCollectActive = not autoCollectActive
    updateToggleVisual(CollectToggleBtn, CollectCircle, autoCollectActive)

    if autoCollectActive then
        collectThread = task.spawn(function()
            while autoCollectActive do
                local actionEvent = getActionEvent()
                if actionEvent then actionEvent:FireServer("Collect", 1321) end
                task.wait(0.1)
            end
        end)
    else
        if collectThread then task.cancel(collectThread); collectThread = nil end
    end
end)

-- 2. Auto-Search
SearchToggleBtn.MouseButton1Click:Connect(function()
    autoSearchActive = not autoSearchActive
    updateToggleVisual(SearchToggleBtn, SearchCircle, autoSearchActive)

    if autoSearchActive then
        searchThread = task.spawn(function()
            while autoSearchActive do
                local actionEvent = getActionEvent()
                if actionEvent then actionEvent:FireServer("Search") end
                task.wait(0.4)
            end
        end)
    else
        if searchThread then task.cancel(searchThread); searchThread = nil end
    end
end)

-- 3. Blaue Autos
TeleportBlueCarBtn.MouseButton1Click:Connect(function()
    autoTeleportBlueCarActive = not autoTeleportBlueCarActive
    updateToggleVisual(TeleportBlueCarBtn, TeleportBlueCarCircle, autoTeleportBlueCarActive)

    if autoTeleportBlueCarActive then
        teleportBlueCarThread = task.spawn(function()
            while autoTeleportBlueCarActive do
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if rootPart then
                    Footer.Text = "Status: Suche blaue Autos..."
                    local targetCars = {}
                    
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") then
                            local isBlueCar = false
                            for _, part in ipairs(obj:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    local col = part.Color
                                    local r = math.floor(col.R * 255 + 0.5)
                                    local g = math.floor(col.G * 255 + 0.5)
                                    local b = math.floor(col.B * 255 + 0.5)
                                    
                                    if math.abs(r - 2) <= 25 and math.abs(g - 99) <= 25 and math.abs(b - 255) <= 25 then
                                        isBlueCar = true
                                        break
                                    end
                                end
                            end
                            
                            if isBlueCar and not visitedCars[obj] then
                                local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                if primaryPart then
                                    table.insert(targetCars, {model = obj, part = primaryPart})
                                end
                            end
                        end
                    end
                    
                    if #targetCars == 0 then
                        Footer.Text = "Status: Keine blauen Autos da (Warte...)"
                        visitedCars = {}
                        task.wait(1.5)
                    else
                        Footer.Text = "Status: " .. #targetCars .. " blaue Autos im Anflug!"
                        for _, carInfo in ipairs(targetCars) do
                            if not autoTeleportBlueCarActive then break end
                            visitedCars[carInfo.model] = true
                            smoothFlyTo(rootPart, carInfo.part.CFrame, 0.25)
                            task.wait(0.05)
                            pressKey(Enum.KeyCode.E)
                            local actionEvent = getActionEvent()
                            if actionEvent then pcall(function() actionEvent:FireServer("Collect", 1321) end) end
                            task.wait(0.35)
                        end
                    end
                else
                    Footer.Text = "Status: Kein Charakter!"
                end
                task.wait(0.5)
            end
        end)
    else
        Footer.Text = "Status: Bereit"
        if teleportBlueCarThread then task.cancel(teleportBlueCarThread); teleportBlueCarThread = nil end
    end
end)

-- 4. Valuables
TeleportValuablesBtn.MouseButton1Click:Connect(function()
    autoTeleportValuablesActive = not autoTeleportValuablesActive
    updateToggleVisual(TeleportValuablesBtn, TeleportValuablesCircle, autoTeleportValuablesActive)

    if autoTeleportValuablesActive then
        teleportValuablesThread = task.spawn(function()
            while autoTeleportValuablesActive do
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if rootPart then
                    Footer.Text = "Status: Suche Valuables..."
                    local valuables = {}
                    
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        local nameLower = obj.Name:lower()
                        if nameLower:find("valuable") or nameLower:find("coin") or nameLower:find("loot") or nameLower:find("item") or nameLower:find("pickup") then
                            local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                            if part and not table.find(valuables, part) then
                                table.insert(valuables, part)
                            end
                        end
                    end
                    
                    if #valuables == 0 then
                        Footer.Text = "Status: Keine Valuables gefunden..."
                        task.wait(1)
                    else
                        Footer.Text = "Status: " .. #valuables .. " Valuables gefunden!"
                        for _, valuablePart in ipairs(valuables) do
                            if not autoTeleportValuablesActive then break end
                            smoothFlyTo(rootPart, valuablePart.CFrame, 0.25)
                            task.wait(0.05)
                            pressKey(Enum.KeyCode.F)
                            task.wait(0.25)
                        end
                    end
                else
                    Footer.Text = "Status: Kein Charakter!"
                end
                task.wait(0.5)
            end
        end)
    else
        Footer.Text = "Status: Bereit"
        if teleportValuablesThread then task.cancel(teleportValuablesThread); teleportValuablesThread = nil end
    end
end)
