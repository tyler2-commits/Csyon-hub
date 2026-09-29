--//====================================================
--// AUTO CAR E-CLICK (1 bis 100.000)
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
--// PRESS E
--//====================================================

local function PressE(prompt)
    if not prompt then return false end

    if typeof(fireproximityprompt) == "function" then
        local success = pcall(function()
            fireproximityprompt(prompt)
        end)
        if success then return true end
    end

    local holdBegin = prompt.InputHoldBegin
    local holdEnd = prompt.InputHoldEnd

    if typeof(holdBegin) == "function" and typeof(holdEnd) == "function" then
        pcall(function()
            prompt:InputHoldBegin()
            local duration = tonumber(prompt.HoldDuration) or 0
            if duration > 0 then
                task.wait(duration + 0.1)
            else
                task.wait(0.1)
            end
            prompt:InputHoldEnd()
        end)
        return true
    end

    warn("[CYSON] E konnte nicht ausgelöst werden (fireproximityprompt fehlt).")
    return false
end


--//====================================================
--// AUTO CLICK CAR
--//====================================================

local function AutoClickCar(car)
    if not AutoCarRunning or not car or not car.Parent then return end

    local root = GetRoot()
    local target = GetTargetPart(car)

    if not root then
        warn("[CYSON] HumanoidRootPart nicht gefunden.")
        return
    end

    if not target then
        return
    end

    -- Zum Auto teleportieren (etwas erhöht)
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
            -- Schleife von Car 1 bis 100.000
            for i = 1, 100000 do
                if not AutoCarRunning then break end

                local carName = "Car_" .. tostring(i)
                local car = CarsFolder:FindFirstChild(carName)

                if car then
                    print("[CYSON] Scanne Auto:", carName)
                    AutoClickCar(car)
                end

                -- Kurzer Yield alle paar Autos, um Lag / Crashes zu verhindern
                if i % 50 == 0 then
                    task.wait(0.05)
                end
            end

            -- Wenn alle 100.000 durch sind, kurz warten und ggf. neu starten
            if AutoCarRunning then
                print("[CYSON] Durchlauf beendet. Warte vor dem nächsten Scan...")
                task.wait(2)
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
