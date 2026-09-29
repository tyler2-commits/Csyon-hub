--//====================================================
--// AUTO CAR SCANNER (COBALT REMOTE EVENT)
--//====================================================

local AutoCarRunning = false
local AutoCarThread = nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Remote Event über Cobalt Pfad holen
local Event = ReplicatedStorage:WaitForChild("ParkingGame"):WaitForChild("Action")

local CarsFolder = workspace
    :WaitForChild("LocalParkingVisuals")
    :WaitForChild("Cars")


--//====================================================
--// CHARACTER (zum Teleportieren über die Autos)
--//====================================================

local function GetRoot()
    if not LocalPlayer then return nil end
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end


--//====================================================
--// START AUTO CARS
--//====================================================

local function StartAutoCars()
    if AutoCarRunning then return end
    AutoCarRunning = true
    print("[CYSON] Auto Remote Scanner gestartet.")

    AutoCarThread = task.spawn(function()
        while AutoCarRunning do
            for i = 1, 100000 do
                if not AutoCarRunning then break end

                local carName = "Car_" .. tostring(i)
                local car = CarsFolder:FindFirstChild(carName)

                if car then
                    local root = GetRoot()
                    local target = car:IsA("BasePart") and car or (car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart", true))

                    -- Zum Auto fliegen/teleportieren
                    if root and target then
                        root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                    end

                    -- Remote Event auslösen ("Search")
                    pcall(function()
                        Event:FireServer("Search")
                    end)

                    task.wait(0.15)
                end

                -- Kleiner Yield alle 100 Schritte gegen Lag
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


--//====================================================
--// STOP AUTO CARS
--//====================================================

local function StopAutoCars()
    AutoCarRunning = false
    AutoCarThread = nil
    print("[CYSON] Auto Remote Scanner gestoppt.")
end


--//====================================================
--// SICHERE UI / TOGGLE EINBINDUNG
--// (Verhindert den "nil value" Fehler komplett)
--//====================================================

-- Wir prüfen ob deine UI-Funktionen existieren, ansonsten nutzen wir Fallbacks
local FeaturesTab = FeaturesTab or nil

if typeof(CreateFeatureCard) == "function" and FeaturesTab then
    local AutoCarCard = CreateFeatureCard(
        FeaturesTab,
        "Auto Collect Cars",
        "Triggert automatisch das Search-Event für Car 1 bis 100.000.",
        9
    )

    local AutoCarToggle, SetAutoCarToggle = CreateToggle(AutoCarCard)

    AutoCarToggle.MouseButton1Click:Connect(function()
        if AutoCarRunning then
            StopAutoCars()
            SetAutoCarToggle(false)
        else
            StartAutoCars()
            SetAutoCarToggle(true)
        end
    end)
else
    -- Fallback: Falls die UI-Funktionen im Loadstring fehlen, startet es direkt per Druck oder Print
    warn("[CYSON] UI-Funktionen nicht gefunden – starte direkt im Loop.")
    StartAutoCars()
end

LocalPlayer.CharacterRemoving:Connect(function()
    if AutoCarRunning then
        StopAutoCars()
    end
end)
