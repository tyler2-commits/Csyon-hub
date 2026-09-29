--//====================================================
--// AUTO CAR E-CLICK (Fehlerfrei)
--//====================================================

local AutoCarRunning = false
local AutoCarThread = nil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CarsFolder = workspace
    :WaitForChild("LocalParkingVisuals")
    :WaitForChild("Cars")


--//====================================================
--// CHARACTER
--//====================================================

local function GetRoot()
    if not LocalPlayer then return nil end
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end


--//====================================================
--// TARGET PART
--//====================================================

local function GetTargetPart(car)
    if not car or not car.Parent then return nil end
    if car:IsA("BasePart") then return car end
    if car.PrimaryPart then return car.PrimaryPart end
    return car:FindFirstChildWhichIsA("BasePart", true)
end


--//====================================================
--// PROXIMITY PROMPT
--//====================================================

local function GetPrompt(car)
    if not car or not car.Parent then return nil end
    local prompt = car:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt and prompt:IsA("ProximityPrompt") then
        return prompt
    end
    return nil
end


--//====================================================
--// PRESS E (Sicherer gemacht gegen "nil" Fehler)
--//====================================================

local function PressE(prompt)
    if not prompt then return false end

    -- Prüfen ob die globale Funktion existiert, bevor sie aufgerufen wird
    if _G.fireproximityprompt or (typeof(fireproximityprompt) == "function") then
        local success = pcall(function()
            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
            else
                _G.fireproximityprompt(prompt)
            end
        end)
        if success then return true end
    end

    -- Fallback: Simulieren über Events oder ProximityPrompt-Eigenschaften falls möglich
    local successFallback = pcall(function()
        -- Manche Executors unterstützen das direkte Auslösen via Trigger
        if prompt.Enabled then
            -- Alternativer Klick-Versuch
            fireclickdetector(prompt.Parent) -- falls ClickDetector da ist
        end
    end)

    if successFallback then
        return true
    end

    -- Letzter Ausweg: Versuchen, die Hold-Funktionen sicher aufzurufen
    local ok = pcall(function()
        if prompt.InputHoldBegin and prompt.InputHoldEnd then
            prompt:InputHoldBegin()
            task.wait(tonumber(prompt.HoldDuration) or 0.1)
            prompt:InputHoldEnd()
        end
    end)

    return ok
end


--//====================================================
--// AUTO CLICK CAR
--//====================================================

local function AutoClickCar(car)
    if not AutoCarRunning or not car or not car.Parent then return end

    local root = GetRoot()
    local target = GetTargetPart(car)

    if not root or not target then return end

    -- Zum Auto teleportieren
    root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.15)

    if not AutoCarRunning then return end

    local prompt = GetPrompt(car)
    if not prompt then return end

    PressE(prompt)
    task.wait(0.2)
end


--//====================================================
--// START AUTO CARS (1 bis 100.000)
--//====================================================

local function StartAutoCars()
    if AutoCarRunning then return end
    AutoCarRunning = true
    print("[CYSON] Auto Cars (1 - 100.000) gestartet.")

    AutoCarThread = task.spawn(function()
        while AutoCarRunning do
            for i = 1, 100000 do
                if not AutoCarRunning then break end

                local carName = "Car_" .. tostring(i)
                local car = CarsFolder:FindFirstChild(carName)

                if car then
                    AutoClickCar(car)
                end

                if i % 100 == 0 then
                    task.wait(0.03) -- Kleines Yield gegen Lag
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
    print("[CYSON] Auto Cars gestoppt.")
end


--//====================================================
--// UI & TOGGLE
--//====================================================

local AutoCarCard = CreateFeatureCard(
    FeaturesTab,
    "Auto Collect Cars",
    "Fliegt automatisch von Car 1 bis 100.000 und scannt sie.",
    9
)

local AutoCarToggle, SetAutoCarToggle = CreateToggle(AutoCarCard)

AutoCarToggle.MouseButton1Click:Connect(function()
    if AutoCarRunning then
        StopAutoCars()
        SetAutoCarToggle(false)
        print("[CYSON] Auto Cars: OFF")
    else
        StartAutoCars()
        SetAutoCarToggle(true)
        print("[CYSON] Auto Cars: ON")
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if AutoCarRunning then
        StopAutoCars()
        SetAutoCarToggle(false)
    end
end)
