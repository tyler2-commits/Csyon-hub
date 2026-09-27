-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local starterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Referenzen aus deiner StarterPlayerScripts Liste
local clientScripts = {
	AFK = starterPlayerScripts:FindFirstChild("AFK"),
	AdsSystem = starterPlayerScripts:FindFirstChild("AdsSystem"),
	ButtonClickSound = starterPlayerScripts:FindFirstChild("ButtonClickSound"),
	ClickScriptLocal = starterPlayerScripts:FindFirstChild("ClickScriptLocal"),
	DJump = starterPlayerScripts:FindFirstChild("DJump"),
	DeathParts = starterPlayerScripts:FindFirstChild("DeathParts"),
	Door = starterPlayerScripts:FindFirstChild("Door"),
	EggSetup = starterPlayerScripts:FindFirstChild("EggSetup"),
	Favorite = starterPlayerScripts:FindFirstChild("Favorite"),
	FriendInvite = starterPlayerScripts:FindFirstChild("FriendInvite"),
	GearShopPrompt = starterPlayerScripts:FindFirstChild("GearShopPrompt"),
	InvitePart = starterPlayerScripts:FindFirstChild("InvitePart"),
	ItemsShopSign = starterPlayerScripts:FindFirstChild("ItemsShopSign"),
	Lava = starterPlayerScripts:FindFirstChild("Lava"),
	LocalFeedback = starterPlayerScripts:FindFirstChild("LocalFeedback"),
	NPCRaceClient = starterPlayerScripts:FindFirstChild("NPCRaceClient"),
	NoJump = starterPlayerScripts:FindFirstChild("NoJump"),
	PetFollowStyle = starterPlayerScripts:FindFirstChild("PetFollowStyle"),
	PlayerScriptsLoader = starterPlayerScripts:FindFirstChild("PlayerScriptsLoader"),
	ProductStandLabels = starterPlayerScripts:FindFirstChild("ProductStandLabels"),
	PvPRaceClient = starterPlayerScripts:FindFirstChild("PvPRaceClient"),
	RaceUIPositioner = starterPlayerScripts:FindFirstChild("RaceUIPositioner"),
	RbxCharacterSounds = starterPlayerScripts:FindFirstChild("RbxCharacterSounds"),
	SpeedPopups = starterPlayerScripts:FindFirstChild("SpeedPopups"),
	Subscription = starterPlayerScripts:FindFirstChild("Subscription"),
	TeleportDoors = starterPlayerScripts:FindFirstChild("TeleportDoors"),
	TopBar = starterPlayerScripts:FindFirstChild("TopBar"),
	TowerLabels = starterPlayerScripts:FindFirstChild("TowerLabels"),
	TreadmillClient = starterPlayerScripts:FindFirstChild("TreadmillClient"),
	TutorialSystem = starterPlayerScripts:FindFirstChild("TutorialSystem"),
	UIController = starterPlayerScripts:FindFirstChild("UIController"),
	VIP = starterPlayerScripts:FindFirstChild("VIP"),
	WorldUnlocked = starterPlayerScripts:FindFirstChild("WorldUnlocked"),
	PlayerModule = starterPlayerScripts:FindFirstChild("PlayerModule"),
}

-- Event-Referenzen (Speed & Spin)
local increaseSpeedEvent = ReplicatedStorage:FindFirstChild("IncreaseSpeed")

local spinEvent = nil
local spinFolder = ReplicatedStorage:FindFirstChild("SpinFolder")
if spinFolder then
	spinEvent = spinFolder:FindFirstChild("Spin")
end

-- Rebirth Event Referenz
local rebirthEvent = nil
pcall(function()
	rebirthEvent = ReplicatedStorage:WaitForChild("RebirthEvent", 2)
end)

-- Exakte Liste der 19 Welten / Ziele
local winLocations = {
	"ObbyTower",
	"RedTower",
	"Walls",
	"World1", "World2", "World3", "World4", "World5",
	"World6", "World7", "World8", "World9", "World10",
	"World11", "World12", "World13", "World14", "World15",
	"World16", "World17", "World18", "World19"
}

-- Altes GUI löschen falls vorhanden
if playerGui:FindFirstChild("CsyonHubGUI") then
	playerGui.CsyonHubGUI:Destroy()
end

-- Haupt-GUI erstellen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CsyonHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Floating Button (Öffnen/Schließen)
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 52, 0, 52)
openButton.Position = UDim2.new(0, 20, 0.5, -26)
openButton.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
openButton.Text = "C"
openButton.TextColor3 = Color3.fromRGB(0, 255, 140)
openButton.TextSize = 22
openButton.Font = Enum.Font.GothamBold
openButton.Active = true
openButton.Draggable = true
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(0, 255, 140)
openStroke.Thickness = 2
openStroke.Parent = openButton

-- Hauptfenster
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 460)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(35, 35, 50)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Fließende Öffnungs/Schließ-Animation für das Hauptfenster
local isOpen = false
openButton.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	if isOpen then
		mainFrame.Visible = true
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		
		TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 400, 0, 460),
			Position = UDim2.new(0.5, -200, 0.5, -230)
		}):Play()
		
		TweenService:Create(openButton, TweenInfo.new(0.2), {Rotation = 360}):Play()
	else
		local tw = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tw:Play()
		TweenService:Create(openButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
		tw.Completed:Connect(function()
			if not isOpen then mainFrame.Visible = false end
		end)
	end
end)

-- Titelbalken
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local fixCover = Instance.new("Frame")
fixCover.Size = UDim2.new(1, 0, 0, 10)
fixCover.Position = UDim2.new(0, 0, 1, -10)
fixCover.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
fixCover.BorderSizePixel = 0
fixCover.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ CSYON HUB"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	isOpen = false
	local tw = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tw:Play()
	tw.Completed:Connect(function() mainFrame.Visible = false end)
end)

-- Scrolling Container für Features
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 52)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 580)
container.ScrollBarThickness = 3
container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 140)
container.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 10)
uiList.Parent = container

-- Toggle Generator
local function createToggle(name, defaultState, callback)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(1, 0, 0, 44)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	toggleFrame.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(220, 220, 230)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 44, 0, 22)
	btn.Position = UDim2.new(1, -54, 0.5, -11)
	btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(45, 45, 55)
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = toggleFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = btn
	
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BorderSizePixel = 0
	circle.Parent = btn
	
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle
	
	local state = defaultState
	btn.MouseButton1Click:Connect(function()
		state = not state
		local targetColor = state and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(45, 45, 55)
		local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		
		TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(circle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = targetPos}):Play()
		callback(state)
	end)
	
	return toggleFrame
end

-- 1. Clicker
local autoFarmActive = false
local farmConnection
createToggle("Ultra Speed Clicker (Max)", false, function(enabled)
	autoFarmActive = enabled
	if autoFarmActive then
		farmConnection = RunService.Heartbeat:Connect(function()
			if increaseSpeedEvent then pcall(function() increaseSpeedEvent:FireServer() end) end
		end)
	else
		if farmConnection then farmConnection:Disconnect() farmConnection = nil end
	end
end).Parent = container

-- 2. Spin
local autoSpinActive = false
local spinConnection
createToggle("Auto Infinite Spin", false, function(enabled)
	autoSpinActive = enabled
	if autoSpinActive then
		spinConnection = RunService.Heartbeat:Connect(function()
			if spinEvent then pcall(function() spinEvent:FireServer() end) end
		end)
	else
		if spinConnection then spinConnection:Disconnect() spinConnection = nil end
	end
end).Parent = container

-- 3. Modernes Dropdown-Menü für Welten
local selectedWorld = winLocations[1]
local dropdownOpen = false

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, 0, 0, 44)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = container

local dfCorner = Instance.new("UICorner")
dfCorner.CornerRadius = UDim.new(0, 8)
dfCorner.Parent = dropdownFrame

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, 0, 0, 44)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Text = ""
dropdownBtn.Parent = dropdownFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(1, -40, 0, 44)
wsLabel.Position = UDim2.new(0, 14, 0, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Ziel-Welt: " .. selectedWorld
wsLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
wsLabel.TextSize = 13
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = dropdownFrame

local arrowLabel = Instance.new("TextLabel")
arrowLabel.Size = UDim2.new(0, 30, 0, 44)
arrowLabel.Position = UDim2.new(1, -35, 0, 0)
arrowLabel.BackgroundTransparency = 1
arrowLabel.Text = "▼"
arrowLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
arrowLabel.TextSize = 12
arrowLabel.Font = Enum.Font.GothamBold
arrowLabel.Parent = dropdownFrame

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, -12, 0, 150)
listScroll.Position = UDim2.new(0, 6, 0, 46)
listScroll.BackgroundTransparency = 1
listScroll.BorderSizePixel = 0
listScroll.CanvasSize = UDim2.new(0, 0, 0, #winLocations * 28)
listScroll.ScrollBarThickness = 3
listScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 140)
listScroll.Parent = dropdownFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = listScroll

for _, worldName in ipairs(winLocations) do
	local itemBtn = Instance.new("TextButton")
	itemBtn.Size = UDim2.new(1, -4, 0, 25)
	itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	itemBtn.Text = "  " .. worldName
	itemBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
	itemBtn.TextSize = 12
	itemBtn.Font = Enum.Font.GothamMedium
	itemBtn.TextXAlignment = Enum.TextXAlignment.Left
	itemBtn.Parent = listScroll
	
	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 5)
	itemCorner.Parent = itemBtn
	
	itemBtn.MouseButton1Click:Connect(function()
		selectedWorld = worldName
		wsLabel.Text = "Ziel-Welt: " .. selectedWorld
		dropdownOpen = false
		TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 44)}):Play()
		TweenService:Create(arrowLabel, TweenInfo.new(0.2), {Rotation = 0}):Play()
	end)
end

dropdownBtn.MouseButton1Click:Connect(function()
	dropdownOpen = not dropdownOpen
	if dropdownOpen then
		TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 204)}):Play()
		TweenService:Create(arrowLabel, TweenInfo.new(0.2), {Rotation = 180}):Play()
	else
		TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 44)}):Play()
		TweenService:Create(arrowLabel, TweenInfo.new(0.2), {Rotation = 0}):Play()
	end
end)

-- Auto Win Teleport
local autoWinActive = false
createToggle("Auto Win Teleport", false, function(enabled)
	autoWinActive = enabled
	if autoWinActive then
		task.spawn(function()
			while autoWinActive do
				pcall(function()
					local winsFolder = workspace:FindFirstChild("Wins")
					if winsFolder then
						local targetObj = winsFolder:FindFirstChild(selectedWorld, true)
						if targetObj and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
							local targetPart = nil
							if targetObj:IsA("BasePart") then
								targetPart = targetObj
							elseif targetObj:IsA("Model") then
								targetPart = targetObj.PrimaryPart or targetObj:FindFirstChildWhichIsA("BasePart", true)
							end
							if targetPart then
								player.Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
								if firetouchinterest then
									firetouchinterest(player.Character.HumanoidRootPart, targetPart, 0)
									task.wait(0.05)
									firetouchinterest(player.Character.HumanoidRootPart, targetPart, 1)
								end
							end
						end
					end
				end)
				task.wait(3.5)
			end
		end)
	end
end).Parent = container

-- Auto Rebirth
local autoRebirthActive = false
createToggle("Auto Rebirth", false, function(enabled)
	autoRebirthActive = enabled
	if autoRebirthActive then
		task.spawn(function()
			while autoRebirthActive do
				pcall(function()
					if rebirthEvent then
						rebirthEvent:FireServer()
					else
						local foundRebirth = ReplicatedStorage:FindFirstChild("RebirthEvent")
						if foundRebirth then foundRebirth:FireServer() end
					end
				end)
				task.wait(1)
			end
		end)
	end
end).Parent = container

-- Auto Claim TimeGifts (Exakter Cobalt Code)
local autoTimeGiftActive = false
createToggle("Auto Claim TimeGifts", false, function(enabled)
	autoTimeGiftActive = enabled
	if autoTimeGiftActive then
		task.spawn(function()
			while autoTimeGiftActive do
				pcall(function()
					local event = ReplicatedStorage:FindFirstChild("Recv")
					if event then
						event:InvokeServer("TimeGift", "1")
					end
				end)
				task.wait(3)
			end
		end)
	end
end).Parent = container

-- Anti-AFK Schutz
createToggle("Anti-AFK Schutz", false, function(enabled)
	if enabled then
		local vu = game:GetService("VirtualUser")
		player.Idled:Connect(function()
			vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
	end
end).Parent = container

-- FPS Boost
createToggle("FPS Boost (Partikel aus)", false, function(enabled)
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Sparkles") then
			v.Enabled = not enabled
		end
	end
end).Parent = container

print("Csyon Hub erfolgreich geladen!")
