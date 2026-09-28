--// =========================================================
--// CSYON HUB - GAME LOADER
--// Modern • Mobile Friendly • Draggable • Minimizable
--// =========================================================

--// Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gameId = game.PlaceId

--// =========================================================
--// CONFIG
--// =========================================================

local Config = {
	Title = "CSYON HUB",
	Version = "v1.0",

	-- Größe des Loaders
	DesktopSize = Vector2.new(450, 350),
	MobileScale = 0.82,

	-- Farben
	Background = Color3.fromRGB(8, 9, 15),
	Panel = Color3.fromRGB(14, 15, 23),
	Panel2 = Color3.fromRGB(19, 20, 31),

	Accent = Color3.fromRGB(0, 255, 150),
	AccentDark = Color3.fromRGB(0, 190, 110),

	White = Color3.fromRGB(245, 247, 255),
	Text = Color3.fromRGB(210, 213, 230),
	Muted = Color3.fromRGB(120, 125, 145),

	Red = Color3.fromRGB(255, 70, 85),
	Yellow = Color3.fromRGB(255, 190, 60),

	-- Animation
	OpenTime = 0.45,
	CloseTime = 0.30,
}

--// =========================================================
--// SUPPORTED GAMES
--// =========================================================

local supportedGames = {
	{
		Id = 140317247681516,
		Name = "+1 Jump Clicker",
		ScriptUrl = "https://raw.githubusercontent.com/tyler2-commits/Csyon-hub/refs/heads/main/Script.lua"
	},

	{
		Id = 92630121427800,
		Name = "Where Did I Park? 🚗",
		ScriptUrl = ""
	},

	{
		Id = 1122334455,
		Name = "Soon",
		ScriptUrl = ""
	},
}

--// =========================================================
--// CLEAN OLD GUI
--// =========================================================

local oldGui = CoreGui:FindFirstChild("CsyonLoaderGUI")

if oldGui then
	oldGui:Destroy()
end

--// =========================================================
--// SCREEN GUI
--// =========================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CsyonLoaderGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

--// =========================================================
--// SCALE
--// =========================================================

local uiScale = Instance.new("UIScale")
uiScale.Scale = UserInputService.TouchEnabled
	and Config.MobileScale
	or 1

--// =========================================================
--// MAIN FRAME
--// =========================================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.fromOffset(0, 0)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Config.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

uiScale.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Config.Accent
mainStroke.Transparency = 0.45
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

--// =========================================================
--// TOP BAR
--// =========================================================

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 64)
topBar.BackgroundColor3 = Config.Panel
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 18)
topCorner.Parent = topBar

-- Fix lower corners
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 18)
topFix.Position = UDim2.new(0, 0, 1, -18)
topFix.BackgroundColor3 = Config.Panel
topFix.BorderSizePixel = 0
topFix.Parent = topBar

--// Logo
local logo = Instance.new("TextLabel")
logo.Size = UDim2.fromOffset(38, 38)
logo.Position = UDim2.fromOffset(14, 13)
logo.BackgroundColor3 = Config.Accent
logo.Text = "⚡"
logo.TextColor3 = Config.Background
logo.TextSize = 18
logo.Font = Enum.Font.GothamBold
logo.Parent = topBar

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 10)
logoCorner.Parent = logo

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -140, 0, 25)
title.Position = UDim2.fromOffset(62, 10)
title.BackgroundTransparency = 1
title.Text = Config.Title
title.TextColor3 = Config.White
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

--// Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -140, 0, 20)
subtitle.Position = UDim2.fromOffset(62, 34)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Game Loader • " .. Config.Version
subtitle.TextColor3 = Config.Muted
subtitle.TextSize = 10
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = topBar

--// =========================================================
--// CLOSE BUTTON
--// =========================================================

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.fromOffset(32, 32)
closeBtn.Position = UDim2.new(1, -44, 0, 16)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 31)
closeBtn.Text = "×"
closeBtn.TextColor3 = Config.Red
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = closeBtn

--// =========================================================
--// MINIMIZE BUTTON
--// =========================================================

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "Minimize"
minimizeBtn.Size = UDim2.fromOffset(32, 32)
minimizeBtn.Position = UDim2.new(1, -82, 0, 16)
minimizeBtn.BackgroundColor3 = Config.Panel2
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Config.Text
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 9)
minimizeCorner.Parent = minimizeBtn

--// =========================================================
--// STATUS HEADER
--// =========================================================

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -32, 0, 42)
statusFrame.Position = UDim2.fromOffset(16, 78)
statusFrame.BackgroundColor3 = Config.Panel
statusFrame.BorderSizePixel = 0
statusFrame.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 11)
statusCorner.Parent = statusFrame

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.fromOffset(9, 9)
statusDot.Position = UDim2.fromOffset(14, 16)
statusDot.BackgroundColor3 = Config.Yellow
statusDot.BorderSizePixel = 0
statusDot.Parent = statusFrame

local statusDotCorner = Instance.new("UICorner")
statusDotCorner.CornerRadius = UDim.new(1, 0)
statusDotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -45, 1, 0)
statusText.Position = UDim2.fromOffset(32, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "Checking current game..."
statusText.TextColor3 = Config.Text
statusText.TextSize = 11
statusText.Font = Enum.Font.GothamMedium
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusFrame

--// =========================================================
--// GAMES CONTAINER
--// =========================================================

local gamesContainer = Instance.new("ScrollingFrame")
gamesContainer.Name = "Games"
gamesContainer.Size = UDim2.new(1, -32, 1, -175)
gamesContainer.Position = UDim2.fromOffset(16, 130)
gamesContainer.BackgroundTransparency = 1
gamesContainer.BorderSizePixel = 0
gamesContainer.ScrollBarThickness = 3
gamesContainer.ScrollBarImageColor3 = Config.Accent
gamesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
gamesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
gamesContainer.Parent = mainFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingBottom = UDim.new(0, 5)
listPadding.Parent = gamesContainer

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 9)
listLayout.Parent = gamesContainer

--// =========================================================
--// FOOTER
--// =========================================================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -32, 0, 25)
footer.Position = UDim2.new(0, 16, 1, -34)
footer.BackgroundTransparency = 1
footer.Text = "◆ Csyon Hub  •  Ready"
footer.TextColor3 = Config.Muted
footer.TextSize = 9
footer.Font = Enum.Font.GothamMedium
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame

--// =========================================================
--// GAME DETECTION
--// =========================================================

local currentGameData = nil

for _, gameData in ipairs(supportedGames) do
	if gameId == gameData.Id then
		currentGameData = gameData
		break
	end
end

--// =========================================================
--// CREATE GAME CARD
--// =========================================================

local function createGameCard(gameData, index)

	local isCurrent = gameData == currentGameData
	local hasScript = gameData.ScriptUrl ~= nil and gameData.ScriptUrl ~= ""

	-- Card
	local card = Instance.new("Frame")
	card.Name = "Game_" .. index
	card.Size = UDim2.new(1, -4, 0, 60)
	card.BackgroundColor3 = isCurrent
		and Color3.fromRGB(13, 28, 24)
		or Config.Panel
	card.BorderSizePixel = 0
	card.LayoutOrder = index
	card.Parent = gamesContainer

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 12)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = isCurrent
		and Config.Accent
		or Color3.fromRGB(35, 37, 50)
	cardStroke.Transparency = isCurrent and 0.3 or 0
	cardStroke.Thickness = isCurrent and 1.5 or 1
	cardStroke.Parent = card

	--// Status dot
	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(9, 9)
	dot.Position = UDim2.fromOffset(14, 25)
	dot.BackgroundColor3 = isCurrent
		and Config.Accent
		or Color3.fromRGB(75, 78, 95)
	dot.BorderSizePixel = 0
	dot.Parent = card

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = dot

	--// Game name
	local gameName = Instance.new("TextLabel")
	gameName.Size = UDim2.new(1, -160, 0, 22)
	gameName.Position = UDim2.fromOffset(33, 10)
	gameName.BackgroundTransparency = 1
	gameName.Text = gameData.Name
	gameName.TextColor3 = isCurrent
		and Config.White
		or Config.Muted
	gameName.TextSize = 11
	gameName.Font = Enum.Font.GothamBold
	gameName.TextXAlignment = Enum.TextXAlignment.Left
	gameName.TextTruncate = Enum.TextTruncate.AtEnd
	gameName.Parent = card

	--// Status text
	local smallStatus = Instance.new("TextLabel")
	smallStatus.Size = UDim2.new(1, -160, 0, 18)
	smallStatus.Position = UDim2.fromOffset(33, 31)
	smallStatus.BackgroundTransparency = 1
	smallStatus.Text =
		isCurrent
		and (hasScript and "● Supported • Ready" or "● Supported • Coming Soon")
		or "○ Not detected"
	smallStatus.TextColor3 =
		isCurrent
		and (hasScript and Config.Accent or Config.Yellow)
		or Config.Muted
	smallStatus.TextSize = 8
	smallStatus.Font = Enum.Font.GothamMedium
	smallStatus.TextXAlignment = Enum.TextXAlignment.Left
	smallStatus.Parent = card

	--// Load button
	local loadBtn = Instance.new("TextButton")
	loadBtn.Size = UDim2.fromOffset(96, 34)
	loadBtn.Position = UDim2.new(1, -108, 0.5, -17)
	loadBtn.AutoButtonColor = false
	loadBtn.Font = Enum.Font.GothamBold
	loadBtn.TextSize = 10
	loadBtn.Parent = card

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 9)
	btnCorner.Parent = loadBtn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Parent = loadBtn

	if isCurrent and hasScript then

		loadBtn.BackgroundColor3 = Config.Accent
		loadBtn.TextColor3 = Config.Background
		loadBtn.Text = "LOAD"
		btnStroke.Color = Config.Accent
		btnStroke.Transparency = 0

		-- Hover
		loadBtn.MouseEnter:Connect(function()
			TweenService:Create(
				loadBtn,
				TweenInfo.new(0.15),
				{
					BackgroundColor3 = Config.White
				}
			):Play()
		end)

		loadBtn.MouseLeave:Connect(function()
			TweenService:Create(
				loadBtn,
				TweenInfo.new(0.15),
				{
					BackgroundColor3 = Config.Accent
				}
			):Play()
		end)

		-- Load
		loadBtn.MouseButton1Click:Connect(function()

			loadBtn.Active = false
			loadBtn.Text = "LOADING..."
			loadBtn.TextColor3 = Config.Background

			statusText.Text = "Loading " .. gameData.Name .. "..."
			statusDot.BackgroundColor3 = Config.Yellow

			footer.Text = "◆ Csyon Hub  •  Loading..."

			local success, result = pcall(function()
				local source = game:HttpGet(gameData.ScriptUrl)

				if not source or source == "" then
					error("Script returned empty content")
				end

				local loadedFunction = loadstring(source)

				if not loadedFunction then
					error("Could not compile script")
				end

				return loadedFunction()
			end)

			if success then

				statusText.Text = "Script loaded successfully!"
				statusDot.BackgroundColor3 = Config.Accent
				footer.Text = "◆ Csyon Hub  •  Loaded"

				TweenService:Create(
					loadBtn,
					TweenInfo.new(0.2),
					{
						BackgroundColor3 = Config.AccentDark
					}
				):Play()

				loadBtn.Text = "LOADED ✓"

				task.wait(0.6)

				TweenService:Create(
					mainFrame,
					TweenInfo.new(
						Config.CloseTime,
						Enum.EasingStyle.Quart,
						Enum.EasingDirection.In
					),
					{
						Size = UDim2.fromOffset(0, 0)
					}
				):Play()

				task.wait(Config.CloseTime)

				screenGui:Destroy()

			else

				warn("[Csyon Hub] Loading failed:", result)

				statusText.Text = "Loading failed!"
				statusDot.BackgroundColor3 = Config.Red
				footer.Text = "◆ Csyon Hub  •  Error"

				loadBtn.Text = "RETRY"
				loadBtn.Active = true
				loadBtn.BackgroundColor3 = Config.Red
				loadBtn.TextColor3 = Config.White

				task.delay(2, function()
					if loadBtn and loadBtn.Parent then
						loadBtn.BackgroundColor3 = Config.Accent
						loadBtn.TextColor3 = Config.Background
						loadBtn.Text = "LOAD"

						statusText.Text = "Supported game detected!"
						statusDot.BackgroundColor3 = Config.Accent
						footer.Text = "◆ Csyon Hub  •  Ready"
					end
				end)
			end
		end)

	elseif isCurrent and not hasScript then

		loadBtn.BackgroundColor3 = Color3.fromRGB(30, 31, 42)
		loadBtn.TextColor3 = Config.Yellow
		loadBtn.Text = "SOON"
		btnStroke.Color = Config.Yellow
		btnStroke.Transparency = 0.5

		loadBtn.Active = false

	else

		loadBtn.BackgroundColor3 = Color3.fromRGB(25, 26, 36)
		loadBtn.TextColor3 = Config.Muted
		loadBtn.Text = "LOCKED"
		btnStroke.Color = Color3.fromRGB(45, 46, 60)
		btnStroke.Transparency = 0.5

		loadBtn.Active = false
	end

	return card
end

--// =========================================================
--// CREATE ALL GAME CARDS
--// =========================================================

for index, gameData in ipairs(supportedGames) do
	createGameCard(gameData, index)
end

--// =========================================================
--// UPDATE GLOBAL STATUS
--// =========================================================

if currentGameData then

	if currentGameData.ScriptUrl ~= "" then
		statusText.Text = "Supported game detected!"
		statusDot.BackgroundColor3 = Config.Accent
	else
		statusText.Text = "Game detected • Script coming soon"
		statusDot.BackgroundColor3 = Config.Yellow
	end

else

	statusText.Text = "No supported game detected"
	statusDot.BackgroundColor3 = Config.Red
end

--// =========================================================
--// DRAGGING
--// =========================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)

	local delta = input.Position - dragStart

	mainFrame.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

topBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = mainFrame.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end

		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if dragging then

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			updateDrag(input)
		end
	end
end)

--// =========================================================
--// MINIMIZE
--// =========================================================

local minimized = false
local normalSize = UDim2.fromOffset(
	Config.DesktopSize.X,
	Config.DesktopSize.Y
)

local function setMinimized(state)

	minimized = state

	if minimized then

		minimizeBtn.Text = "+"
		gamesContainer.Visible = false
		statusFrame.Visible = false
		footer.Visible = false

		TweenService:Create(
			mainFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quart),
			{
				Size = UDim2.fromOffset(280, 64)
			}
		):Play()

	else

		minimizeBtn.Text = "−"
		gamesContainer.Visible = true
		statusFrame.Visible = true
		footer.Visible = true

		TweenService:Create(
			mainFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quart),
			{
				Size = normalSize
			}
		):Play()
	end
end

minimizeBtn.MouseButton1Click:Connect(function()
	setMinimized(not minimized)
end)

--// =========================================================
--// CLOSE
--// =========================================================

local function closeLoader()

	TweenService:Create(
		mainFrame,
		TweenInfo.new(
			Config.CloseTime,
			Enum.EasingStyle.Quart,
			Enum.EasingDirection.In
		),
		{
			Size = UDim2.fromOffset(0, 0)
		}
	):Play()

	task.wait(Config.CloseTime)

	if screenGui then
		screenGui:Destroy()
	end
end

closeBtn.MouseButton1Click:Connect(closeLoader)

--// =========================================================
--// BUTTON HOVER EFFECTS
--// =========================================================

closeBtn.MouseEnter:Connect(function()

	TweenService:Create(
		closeBtn,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Color3.fromRGB(60, 25, 32)
		}
	):Play()
end)

closeBtn.MouseLeave:Connect(function()

	TweenService:Create(
		closeBtn,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Color3.fromRGB(35, 25, 31)
		}
	):Play()
end)

minimizeBtn.MouseEnter:Connect(function()

	TweenService:Create(
		minimizeBtn,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Color3.fromRGB(30, 32, 45)
		}
	):Play()
end)

minimizeBtn.MouseLeave:Connect(function()

	TweenService:Create(
		minimizeBtn,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Config.Panel2
		}
	):Play()
end)

--// =========================================================
--// OPEN ANIMATION
--// =========================================================

mainFrame.Size = UDim2.fromOffset(0, 0)

TweenService:Create(
	mainFrame,
	TweenInfo.new(
		Config.OpenTime,
		Enum.EasingStyle.Back,
		Enum.EasingDirection.Out
	),
	{
		Size = normalSize
	}
):Play()

--// =========================================================
--// FINAL
--// =========================================================

print("⚡ Csyon Hub Loader loaded.")
print("Game ID:", gameId)

if currentGameData then
	print("Detected:", currentGameData.Name)
else
	print("No supported game detected.")
end
