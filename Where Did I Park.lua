--//====================================================
--// AUTO CAR E-CLICK
--//====================================================

local AutoCarRunning = false
local AutoCarThread = nil

local CarsFolder = workspace
    :WaitForChild("LocalParkingVisuals")
    :WaitForChild("Cars")

local CarIDs = {
    44194,44195,44196,44198,44200,44201,44203,44204,44205,
    44206,44207,44208,44592,44593,44594,44595,44596,44601,
    44602,44604,44605,44609,44610,44992,44994,44995,44998,
    45000,45001,45004,45005,45006,45007,45010,45390,45396,
    45397,45398,45399,45401,45403,45406,45410,45411,45412,
    45789,45790,45792,45796,45798,45799,45800,45801,45803,
    45809,45811,45812,45813,46188,46189,46190,46191,46194,
    46197,46201,46206,46208,46210,46211,46213,46589,46591,
    46592,46593,46597,46598,46600,46603,46604,46606,46608,
    46610,46612,46614,46990,46991,46992,46994,46996,46997,
    46999,47005,47006,47011,47013,47015,47387,47388,47391,
    47393,47394,47395,47400,47401,47402,47406,47407,47409,
    47410,47412,47414,47415,47789,47792,47793,47799,47801,
    47803,47805,47806,47807,47810,47814,47815,48191,48193,
    48195,48196,48197,48198,48199,48200,48201,48203,48207,
    48211,48212,48213,48215,48588,48589,48592,48594,48595,
    48596,48598,48599,48601,48603,48604,48605,48606,48610,
    48611,48612,48613,48991,48993,48995,48997,48998,48999,
    49002,49004,49008,49009,49010,49012,49013,49014,49391,
    49394,49397,49398,49399,49400,49401,49402,49404,49406,
    49407,49409,49411,49412,49791,49794,49798,49802,49803,
    49805,49809,49811,49812,50191,50193,50196,50200,50203,
    50207,50208,50209,50210,50211,50596,50597,50598,50602,
    50603,50606,50607,50608,50610,50993,50997,50998,51002,
    51004,51005,51006,51009,51396,51400,51403,51404,51405
}

local function GetRoot()
    local character = game.Players.LocalPlayer.Character

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function GetTargetPart(car)
    if car:IsA("BasePart") then
        return car
    end

    if car.PrimaryPart then
        return car.PrimaryPart
    end

    return car:FindFirstChildWhichIsA("BasePart", true)
end

local function GetPrompt(car)
    return car:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local function AutoClickCar(car)
    if not AutoCarRunning then
        return
    end

    if not car or not car.Parent then
        return
    end

    local root = GetRoot()
    local target = GetTargetPart(car)

    if not root or not target then
        return
    end

    --// Zum Auto teleportieren
    root.CFrame = target.CFrame + Vector3.new(0, 3, 0)

    task.wait(0.15)

    if not AutoCarRunning then
        return
    end

    --// ProximityPrompt suchen
    local prompt = GetPrompt(car)

    if prompt then
        -- Falls deine Executor-Umgebung fireproximityprompt unterstützt
        pcall(function()
            fireproximityprompt(prompt)
        end)

        task.wait(0.25)
    else
        warn("[CYSON] Kein ProximityPrompt gefunden:", car.Name)
    end
end

local function StartAutoCars()
    if AutoCarRunning then
        return
    end

    AutoCarRunning = true

    AutoCarThread = task.spawn(function()

        while AutoCarRunning do

            for _, id in ipairs(CarIDs) do

                if not AutoCarRunning then
                    break
                end

                local carName = "Car_" .. tostring(id)
                local car = CarsFolder:FindFirstChild(carName)

                if car then
                    print("[CYSON] Auto:", carName)

                    AutoClickCar(car)

                    task.wait(0.15)
                end
            end

            --// Runde beendet
            if AutoCarRunning then
                task.wait(0.5)
            end
        end

    end)
end

local function StopAutoCars()
    AutoCarRunning = false
    AutoCarThread = nil
end


--//====================================================
--// UI
--//====================================================

local AutoCarCard = CreateFeatureCard(
    FeaturesTab,
    "Auto Collect Cars",
    "Teleportiert automatisch zu den angegebenen Cars und drückt E.",
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
