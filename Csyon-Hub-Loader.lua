-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gameId = game.PlaceId

-- Queue on Teleport einrichten, damit das Skript nach einem Serverwechsel/Teleport weiterlebt
local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport)

if queueTeleport then
	queueTeleport([[
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tyler2-commits/Csyon-hub/refs/heads/main/Nee"))()
	]])
end

-- Trage hier deine unterstützten Spiele ein (mit der echten PlaceId)
local supportedGames = {
	{
		Id = 140317247681516, -- +1 Jump Clicker
		Name = "+1 Jump Clicker",
		ScriptUrl = "https://raw.githubusercontent.com/tyler2-commits/Csyon-hub/refs/heads/main/Script.lua"
	},
	{
		Id = 92630121427800, -- Deine echte ID von "Where Did I Park? 🚗"
		Name = "Where Did I Park? 🚗",
		ScriptUrl = "https://raw.githubusercontent.com/tyler2-commits/Csyon-hub/refs/heads/main/Nee%20game.lua
	},
	{
		Id = 1122334455, -- Dritte Spiel-ID (Platzhalter für später)
		Name = "Spiel Nummer 3",
		ScriptUrl = "https://raw.githubusercontent.com/tyler2-commits/Csyon-hub/refs/heads/main/DeinDrittesSkript"
	}
}

-- Altes GUI löschen
if CoreGui:FindFirstChild("CsyonLoaderGUI") then
	CoreGui.CsyonLoaderGUI:Destroy()
end

-- Haupt GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CsyonLoaderGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- Main Container (Startet klein für die Öffnungs-Animation)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 255, 140)
mainStroke.Transparency = 0.5
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Öffnungs-Animation beim Start
TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 400, 0, 310),
	Position = UDim2.new(0.5, -200, 0.5, -155)
}):Play()

-- Top-Bar (Titel)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 16)
topCorner.Parent = topBar

local fixFrame = Instance.new("Frame")
fixFrame.Size = UDim2.new(1, 0, 0, 10)
fixFrame.Position = UDim2.new(0, 0, 1, -10)
fixFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
fixFrame.BorderSizePixel = 0
fixFrame.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ CSYON LOADER (3 GAMES)"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Schließen-Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 11)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	local tw = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	tw:Play()
	tw.Completed:Connect(function()
		screenGui:Destroy()
	end)
end)

-- Container für die Spiel-Felder
local gamesContainer = Instance.new("Frame")
gamesContainer.Size = UDim2.new(1, -40, 0, 175)
gamesContainer.Position = UDim2.new(0, 20, 0, 65)
gamesContainer.BackgroundTransparency = 1
gamesContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = gamesContainer

local isAnyGameSupported = false

for i, gameData in ipairs(supportedGames) do
	local isCurrentGame = (gameId == gameData.Id)
	if isCurrentGame then
		isAnyGameSupported = true
	end

	local gameCard = Instance.new("Frame")
	gameCard.Size = UDim2.new(1, 0, 0, 50)
	gameCard.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	gameCard.BorderSizePixel = 0
	gameCard.Parent = gamesContainer

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = gameCard

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = isCurrentGame and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(35, 35, 50)
	cardStroke.Thickness = isCurrentGame and 1.5 or 1
	cardStroke.Parent = gameCard

	-- Status-Punkt links
	local statusDot = Instance.new("Frame")
	statusDot.Size = UDim2.new(0, 8, 0, 8)
	statusDot.Position = UDim2.new(0, 15, 0.5, -4)
	statusDot.BackgroundColor3 = isCurrentGame and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(80, 80, 100)
	statusDot.BorderSizePixel = 0
	statusDot.Parent = gameCard

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = statusDot

	-- Spielname & ID Info
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -140, 1, 0)
	nameLabel.Position = UDim2.new(0, 32, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = gameData.Name
	nameLabel.TextColor3 = isCurrentGame and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
	nameLabel.TextSize = 12
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = gameCard

	-- Ausführen-Button pro Spiel
	local loadBtn = Instance.new("TextButton")
	loadBtn.Size = UDim2.new(0, 90, 0, 30)
	loadBtn.Position = UDim2.new(1, -98, 0.5, -15)
	loadBtn.BackgroundColor3 = isCurrentGame and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(30, 30, 42)
	loadBtn.Text = isCurrentGame and "LADEN" or "GESPERRT"
	loadBtn.TextColor3 = isCurrentGame and Color3.fromRGB(12, 12, 18) or Color3.fromRGB(100, 100, 120)
	loadBtn.TextSize = 11
	loadBtn.Font = Enum.Font.GothamBold
	loadBtn.Parent = gameCard

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = loadBtn

	if isCurrentGame then
		loadBtn.MouseButton1Click:Connect(function()
			screenGui:Destroy()
			pcall(function()
				loadstring(game:HttpGet(gameData.ScriptUrl))()
			end)
		end)
	else
		loadBtn.Active = false
	end
end

-- Unterer globaler Status
local globalStatus = Instance.new("TextLabel")
globalStatus.Size = UDim2.new(1, -40, 0, 30)
globalStatus.Position = UDim2.new(0, 20, 1, -38)
globalStatus.BackgroundTransparency = 1
globalStatus.Text = isAnyGameSupported and "Status: Unterstütztes Spiel erkannt!" or "Status: Du bist in keinem unterstützten Spiel."
globalStatus.TextColor3 = isAnyGameSupported and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 80, 80)
globalStatus.TextSize = 11
globalStatus.Font = Enum.Font.GothamMedium
globalStatus.TextXAlignment = Enum.TextXAlignment.Center
globalStatus.Parent = mainFrame
