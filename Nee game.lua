-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

-- Altes GUI löschen
if CoreGui:FindFirstChild("ParkingGameFixedUI") then
    CoreGui.ParkingGameFixedUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ParkingGameFixedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Hauptfenster (schönes dunkles Design)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 440)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 140)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Titel oben
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
Title.TextColor3 = Color3.fromRGB(0, 255, 140)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ PARKING GAME HUB"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
Title.Parent = MainFrame
-- Kleiner Trick, damit die Ecken oben bleiben
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 0, 35)
TitleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = MainFrame
Title.Parent = MainFrame

-- Container für Elemente
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -65)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 300)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Container

-- Event laden
local ParkingGame = ReplicatedStorage:FindFirstChild("ParkingGame")
local ActionEvent = ParkingGame and ParkingGame:FindFirstChild("Action")

local selectedCarColor = "blau"

-- 1. Farbauswahl Button
local ColorBtn = Instance.new("TextButton")
ColorBtn.Size = UDim2.new(1, 0, 0, 42)
ColorBtn.BackgroundColor3 = Color3.fromRGB(2, 99, 255)
ColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorBtn.TextSize = 13
ColorBtn.Font = Enum.Font.GothamBold
ColorBtn.Text = "Autofarm Farbe: BLAU"
ColorBtn.Parent = Container

local ColorCorner = Instance.new("UICorner")
ColorCorner.CornerRadius = UDim.new(0, 8)
ColorCorner.Parent = ColorBtn

ColorBtn.MouseButton1Click:Connect(function()
    if selectedCarColor == "blau" then
        selectedCarColor = "rot"
        ColorBtn.Text = "Autofarm Farbe: ROT"
        ColorBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        selectedCarColor = "blau"
        ColorBtn.Text = "Autofarm Farbe: BLAU"
        ColorBtn.BackgroundColor3 = Color3.fromRGB(2, 99, 255)
    end
end)

-- Funktion für saubere Toggles, die sofort stoppen wenn aus
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Text = name .. " [OFF]"
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            btn.Text = name .. " [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            btn.TextColor3 = Color3.fromRGB(220, 220, 230)
            btn.Text = name .. " [OFF]"
        end
        callback(active)
    end)
end

-- Toggles einfügen mit sofortigem Stopp-Mechanismus
createToggle("Auto-Collect (1321)", function(state)
    task.spawn(function()
        while state do
            if ActionEvent then pcall(function() ActionEvent:FireServer("Collect", 1321) end) end
            task.wait(0.1)
        end
    end)
end)

createToggle("Auto-Search Event", function(state)
    task.spawn(function()
        while state do
            if ActionEvent then pcall(function() ActionEvent:FireServer("Search") end) end
            task.wait(0.4)
        end
    end)
end)

createToggle("Fly Car Farm + E", function(state)
    task.spawn(function()
        local visitedCars = {}
        while state do
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not state then break end -- Sofort abbrechen wenn ausgeschaltet
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
                                    if ActionEvent then ActionEvent:FireServer("Collect", 1321) end
                                end)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

createToggle("Fly Valuables + F", function(state)
    task.spawn(function()
        while state do
            local character = LocalPlayer.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not state then break end -- Sofort abbrechen wenn ausgeschaltet
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
        end
    end)
end)
