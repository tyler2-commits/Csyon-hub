--// =========================================================
--// CSYON HUB - CYBER LOADER
--// Neon Cyber • Mobile • Draggable • Minimizable
--// =========================================================

--// SERVICES
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

	Title = "CSYON",
	Subtitle = "HUB LOADER",
	Version = "v2.0",

	DesktopSize = Vector2.new(500, 400),

	-- Handy automatisch kleiner
	MobileScale = 0.78,

	-- Background
	Background = Color3.fromRGB(7, 5, 16),
	Background2 = Color3.fromRGB(12, 8, 25),

	-- Panels
	Panel = Color3.fromRGB(15, 11, 29),
	Panel2 = Color3.fromRGB(22, 16, 40),
	Card = Color3.fromRGB(18, 13, 35),

	-- Neon
	Purple = Color3.fromRGB(145, 70, 255),
	Purple2 = Color3.fromRGB(205, 65, 255),

	Blue = Color3.fromRGB(55, 135, 255),
	Cyan = Color3.fromRGB(0, 235, 255),

	Pink = Color3.fromRGB(255, 55, 190),

	-- Status
	Green = Color3.fromRGB(45, 255, 155),
	Yellow = Color3.fromRGB(255, 200, 65),
	Red = Color3.fromRGB(255, 65, 100),

	-- Text
	White = Color3.fromRGB(248, 247, 255),
	Text = Color3.fromRGB(205, 201, 225),
	Muted = Color3.fromRGB(125, 116, 155),

	OpenTime = 0.5,
	CloseTime = 0.3,
}

--// =========================================================
--// SUPPORTED GAMES
--// =========================================================

local supportedGames = {

	{
		Id = 140317247681516,
		Name = "+1 Jump Clicker",
		ShortName = "JUMP CLICKER",
		Icon = "⚡",
		ScriptUrl = "https://raw.githubusercontent.com/tyler2-commits/Csyon-hub/refs/heads/main/Script.lua"
	},

	{
		Id = 92630121427800,
		Name = "Where Did I Park?",
		ShortName = "WHERE DID I PARK?",
		Icon = "🚗",
		ScriptUrl = ""
	},

	{
		Id = 1122334455,
		Name = "New Game",
		ShortName = "COMING SOON",
		Icon = "🎮",
		ScriptUrl = ""
	},
}

--// =========================================================
--// CLEAN OLD UI
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
--// UI SCALE
--// =========================================================

local uiScale = Instance.new("UIScale")

if UserInputService.TouchEnabled then
	uiScale.Scale = Config.MobileScale
else
	uiScale.Scale = 1
end

--// =========================================================
--// MAIN
--// =========================================================

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(0, 0)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Config.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

uiScale.Parent = main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 22)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Config.Purple
mainStroke.Transparency = 0.2
mainStroke.Thickness = 1.5
mainStroke.Parent = main

--// MAIN GRADIENT
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Config.Background),
	ColorSequenceKeypoint.new(0.5, Config.Background2),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 7, 20))
})
mainGradient.Rotation = 135
mainGradient.Parent = main

--// =========================================================
--// BACKGROUND GLOW
--// =========================================================

local glowLeft = Instance.new("Frame")
glowLeft.Size = UDim2.fromOffset(180, 180)
glowLeft.Position = UDim2.fromOffset(-100, 100)
glowLeft.BackgroundColor3 = Config.Purple
glowLeft.BackgroundTransparency = 0.88
glowLeft.BorderSizePixel = 0
glowLeft.Parent = main

local glowLeftCorner = Instance.new("UICorner")
glowLeftCorner.CornerRadius = UDim.new(1, 0)
glowLeftCorner.Parent = glowLeft

local glowRight = Instance.new("Frame")
glowRight.Size = UDim2.fromOffset(200, 200)
glowRight.Position = UDim2.new(1, -100, 1, -130)
glowRight.BackgroundColor3 = Config.Blue
glowRight.BackgroundTransparency = 0.9
glowRight.BorderSizePixel = 0
glowRight.Parent = main

local glowRightCorner = Instance.new("UICorner")
glowRightCorner.CornerRadius = UDim.new(1, 0)
glowRightCorner.Parent = glowRight

--// =========================================================
--// TOP BAR
--// =========================================================

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 76)
topBar.BackgroundTransparency = 1
topBar.Parent = main

--// Logo circle
local logo = Instance.new("TextLabel")
logo.Size = UDim2.fromOffset(46, 46)
logo.Position = UDim2.fromOffset(17, 15)
logo.BackgroundColor3 = Config.Purple
logo.Text = "⚡"
logo.TextColor3 = Config.White
logo.TextSize = 21
logo.Font = Enum.Font.GothamBold
logo.Parent = topBar

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 14)
logoCorner.Parent = logo

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Config.Purple2),
	ColorSequenceKeypoint.new(1, Config.Blue)
})
logoGradient.Rotation = 45
logoGradient.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Config.Cyan
logoStroke.Transparency = 0.35
logoStroke.Thickness = 1
logoStroke.Parent = logo

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -180, 0, 27)
title.Position = UDim2.fromOffset(76, 13)
title.BackgroundTransparency = 1
title.Text = Config.Title
title.TextColor3 = Config.White
title.TextSize = 20
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

--// Title gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Config.Purple2),
	ColorSequenceKeypoint.new(0.5, Config.Cyan),
	ColorSequenceKeypoint.new(1, Config.Pink)
})
titleGradient.Parent = title

--// Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -180, 0, 18)
subtitle.Position = UDim2.fromOffset(77, 39)
subtitle.BackgroundTransparency = 1
subtitle.Text = Config.Subtitle .. "  •  " .. Config.Version
subtitle.TextColor3 = Config.Muted
subtitle.TextSize = 9
subtitle.Font = Enum.Font.GothamBold
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = topBar

--// =========================================================
--// TOP BUTTONS
--// =========================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 34)
minimize.Position = UDim2.new(1, -82, 0, 21)
minimize.BackgroundColor3 = Config.Panel2
minimize.Text = "−"
minimize.TextColor3 = Config.Text
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.AutoButtonColor = false
minimize.Parent = topBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimize

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -42, 0, 21)
close.BackgroundColor3 = Color3.fromRGB(48, 18, 36)
close.Text = "×"
close.TextColor3 = Config.Pink
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = false
close.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = close

--// =========================================================
--// DIVIDER
--// =========================================================

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -34, 0, 1)
divider.Position = UDim2.fromOffset(17, 75)
divider.BackgroundColor3 = Config.Purple
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0
divider.Parent = main

--// =========================================================
--// CURRENT GAME HERO
--// =========================================================

local currentGameData = nil

for _, data in ipairs(supportedGames) do
	if gameId == data.Id then
		currentGameData = data
		break
	end
end

local hero = Instance.new("Frame")
hero.Name = "CurrentGame"
hero.Size = UDim2.new(1, -34, 0, 125)
hero.Position = UDim2.fromOffset(17, 91)
hero.BackgroundColor3 = Config.Card
hero.BorderSizePixel = 0
hero.Parent = main

local heroCorner = Instance.new("UICorner")
heroCorner.CornerRadius = UDim.new(0, 17)
heroCorner.Parent = hero

local heroGradient = Instance.new("UIGradient")
heroGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 18, 58)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(20, 18, 43)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 27, 53))
})
heroGradient.Rotation = 15
heroGradient.Parent = hero

local heroStroke = Instance.new("UIStroke")
heroStroke.Color = currentGameData
	and Config.Purple2
	or Config.Blue
heroStroke.Transparency = 0.25
heroStroke.Thickness = 1.5
heroStroke.Parent = hero

--// Hero icon
local heroIcon = Instance.new("TextLabel")
heroIcon.Size = UDim2.fromOffset(62, 62)
heroIcon.Position = UDim2.fromOffset(18, 18)
heroIcon.BackgroundColor3 = Config.Purple
heroIcon.Text = currentGameData and currentGameData.Icon or "?"
heroIcon.TextSize = 27
heroIcon.Font = Enum.Font.GothamBold
heroIcon.Parent = hero

local heroIconCorner = Instance.new("UICorner")
heroIconCorner.CornerRadius = UDim.new(0, 17)
heroIconCorner.Parent = heroIcon

local heroIconGradient = Instance.new("UIGradient")
heroIconGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Config.Purple2),
	ColorSequenceKeypoint.new(1, Config.Blue)
})
heroIconGradient.Rotation = 45
heroIconGradient.Parent = heroIcon

--// Current label
local currentLabel = Instance.new("TextLabel")
currentLabel.Size = UDim2.new(1, -115, 0, 17)
currentLabel.Position = UDim2.fromOffset(95, 14)
currentLabel.BackgroundTransparency = 1
currentLabel.Text = "CURRENT GAME"
currentLabel.TextColor3 = Config.Cyan
currentLabel.TextSize = 8
currentLabel.Font = Enum.Font.GothamBlack
currentLabel.TextXAlignment = Enum.TextXAlignment.Left
currentLabel.Parent = hero

--// Game name
local currentName = Instance.new("TextLabel")
currentName.Size = UDim2.new(1, -125, 0, 27)
currentName.Position = UDim2.fromOffset(95, 30)
currentName.BackgroundTransparency = 1
currentName.Text = currentGameData
	and currentGameData.Name
	or "Unsupported Game"
currentName.TextColor3 = Config.White
currentName.TextSize = 15
currentName.Font = Enum.Font.GothamBold
currentName.TextXAlignment = Enum.TextXAlignment.Left
currentName.TextTruncate = Enum.TextTruncate.AtEnd
currentName.Parent = hero

--// Status
local currentStatus = Instance.new("TextLabel")
currentStatus.Size = UDim2.new(1, -125, 0, 18)
currentStatus.Position = UDim2.fromOffset(95, 57)
currentStatus.BackgroundTransparency = 1

if currentGameData and currentGameData.ScriptUrl ~= "" then
	currentStatus.Text = "●  SCRIPT AVAILABLE"
	currentStatus.TextColor3 = Config.Green
elseif currentGameData then
	currentStatus.Text = "●  COMING SOON"
	currentStatus.TextColor3 = Config.Yellow
else
	currentStatus.Text = "●  NOT SUPPORTED"
	currentStatus.TextColor3 = Config.Red
end

currentStatus.TextSize = 8
currentStatus.Font = Enum.Font.GothamBold
currentStatus.TextXAlignment = Enum.TextXAlignment.Left
currentStatus.Parent = hero

--// =========================================================
--// LOAD BUTTON
--// =========================================================

local loadButton = Instance.new("TextButton")
loadButton.Size = UDim2.new(1, -36, 0, 32)
loadButton.Position = UDim2.new(0, 18, 1, -43)
loadButton.BackgroundColor3 = Config.Purple
loadButton.Text = "⚡  LOAD CSYON HUB"
loadButton.TextColor3 = Config.White
loadButton.TextSize = 10
loadButton.Font = Enum.Font.GothamBlack
loadButton.AutoButtonColor = false
loadButton.Parent = hero

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 10)
loadCorner.Parent = loadButton

local loadGradient = Instance.new("UIGradient")
loadGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Config.Purple),
	ColorSequenceKeypoint.new(0.5, Config.Pink),
	ColorSequenceKeypoint.new(1, Config.Blue)
})
loadGradient.Rotation = 0
loadGradient.Parent = loadButton

local loadStroke = Instance.new("UIStroke")
loadStroke.Color = Config.Cyan
loadStroke.Transparency = 0.5
loadStroke.Thickness = 1
loadStroke.Parent = loadButton

--// Disable if unavailable
if not currentGameData or currentGameData.ScriptUrl == "" then
	loadButton.Text = currentGameData
		and "COMING SOON"
		or "GAME NOT SUPPORTED"

	loadButton.BackgroundColor3 = Config.Panel2
	loadButton.TextColor3 = Config.Muted
	loadButton.Active = false
end

--// =========================================================
--// OTHER GAMES LABEL
--// =========================================================

local otherLabel = Instance.new("TextLabel")
otherLabel.Size = UDim2.new(1, -34, 0, 20)
otherLabel.Position = UDim2.fromOffset(17, 230)
otherLabel.BackgroundTransparency = 1
otherLabel.Text = "OTHER GAMES"
otherLabel.TextColor3 = Config.Muted
otherLabel.TextSize = 8
otherLabel.Font = Enum.Font.GothamBlack
otherLabel.TextXAlignment = Enum.TextXAlignment.Left
otherLabel.Parent = main

--// =========================================================
--// OTHER GAMES SCROLL
--// =========================================================

local games = Instance.new("ScrollingFrame")
games.Name = "Games"
games.Size = UDim2.new(1, -34, 0, 92)
games.Position = UDim2.fromOffset(17, 251)
games.BackgroundTransparency = 1
games.BorderSizePixel = 0
games.ScrollBarThickness = 2
games.ScrollBarImageColor3 = Config.Purple
games.CanvasSize = UDim2.new(0, 0, 0, 0)
games.AutomaticCanvasSize = Enum.AutomaticSize.Y
games.Parent = main

local gamesLayout = Instance.new("UIListLayout")
gamesLayout.FillDirection = Enum.FillDirection.Horizontal
gamesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
gamesLayout.SortOrder = Enum.SortOrder.LayoutOrder
gamesLayout.Padding = UDim.new(0, 10)
gamesLayout.Parent = games

--// =========================================================
--// GAME CARDS
--// =========================================================

for index, data in ipairs(supportedGames) do

	if data ~= currentGameData then

		local hasScript = data.ScriptUrl ~= ""

		local card = Instance.new("Frame")
		card.Name = "GameCard_" .. index
		card.Size = UDim2.fromOffset(145, 78)
		card.BackgroundColor3 = Config.Panel
		card.BorderSizePixel = 0
		card.Parent = games

		local cardCorner = Instance.new("UICorner")
		cardCorner.CornerRadius = UDim.new(0, 13)
		cardCorner.Parent = card

		local cardStroke = Instance.new("UIStroke")
		cardStroke.Color = hasScript
			and Config.Blue
			or Color3.fromRGB(43, 36, 65)
		cardStroke.Transparency = 0.25
		cardStroke.Thickness = 1
		cardStroke.Parent = card

		-- Icon
		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.fromOffset(32, 32)
		icon.Position = UDim2.fromOffset(10, 10)
		icon.BackgroundColor3 = Config.Panel2
		icon.Text = data.Icon
		icon.TextSize = 15
		icon.Font = Enum.Font.GothamBold
		icon.Parent = card

		local iconCorner = Instance.new("UICorner")
		iconCorner.CornerRadius = UDim.new(0, 9)
		iconCorner.Parent = icon

		-- Name
		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, -52, 0, 32)
		name.Position = UDim2.fromOffset(49, 9)
		name.BackgroundTransparency = 1
		name.Text = data.ShortName or data.Name
		name.TextColor3 = Config.Text
		name.TextSize = 8
		name.Font = Enum.Font.GothamBold
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextYAlignment = Enum.TextYAlignment.Center
		name.TextWrapped = true
		name.Parent = card

		-- Status
		local status = Instance.new("TextLabel")
		status.Size = UDim2.new(1, -20, 0, 17)
		status.Position = UDim2.fromOffset(10, 53)
		status.BackgroundTransparency = 1

		if hasScript then
			status.Text = "● AVAILABLE"
			status.TextColor3 = Config.Green
		else
			status.Text = "● COMING SOON"
			status.TextColor3 = Config.Yellow
		end

		status.TextSize = 7
		status.Font = Enum.Font.GothamBlack
		status.TextXAlignment = Enum.TextXAlignment.Left
		status.Parent = card

	end
end

--// =========================================================
--// FOOTER
--// =========================================================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -34, 0, 25)
footer.Position = UDim2.new(0, 17, 1, -31)
footer.BackgroundTransparency = 1
footer.Text = "◆  CSYON HUB   •   ONLINE"
footer.TextColor3 = Config.Muted
footer.TextSize = 8
footer.Font = Enum.Font.GothamBold
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = main

--// =========================================================
--// LOAD FUNCTION
--// =========================================================

local function closeLoader()

	TweenService:Create(
		main,
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

if currentGameData and currentGameData.ScriptUrl ~= "" then

	loadButton.MouseEnter:Connect(function()

		TweenService:Create(
			loadButton,
			TweenInfo.new(0.18),
			{
				Size = UDim2.new(1, -30, 0, 35),
				Position = UDim2.new(0, 15, 1, -46)
			}
		):Play()

	end)

	loadButton.MouseLeave:Connect(function()

		TweenService:Create(
			loadButton,
			TweenInfo.new(0.18),
			{
				Size = UDim2.new(1, -36, 0, 32),
				Position = UDim2.new(0, 18, 1, -43)
			}
		):Play()

	end)

	loadButton.MouseButton1Click:Connect(function()

		loadButton.Active = false
		loadButton.Text = "◌  LOADING..."
		currentStatus.Text = "●  LOADING SCRIPT..."
		currentStatus.TextColor3 = Config.Yellow

		local success, result = pcall(function()

			local source = game:HttpGet(currentGameData.ScriptUrl)

			if not source or source == "" then
				error("Empty script")
			end

			local func = loadstring(source)

			if not func then
				error("Script compilation failed")
			end

			return func()
		end)

		if success then

			loadButton.Text = "✓  LOADED"
			currentStatus.Text = "●  SCRIPT LOADED"
			currentStatus.TextColor3 = Config.Green
			footer.Text = "◆  CSYON HUB   •   LOADED"

			task.wait(0.5)

			closeLoader()

		else

			warn("[CSYON HUB] Error:", result)

			loadButton.Active = true
			loadButton.Text = "↻  RETRY"
			currentStatus.Text = "●  LOAD FAILED"
			currentStatus.TextColor3 = Config.Red
			footer.Text = "◆  CSYON HUB   •   ERROR"

			task.delay(2, function()

				if loadButton and loadButton.Parent then

					loadButton.Text = "⚡  LOAD CSYON HUB"
					currentStatus.Text = "●  SCRIPT AVAILABLE"
					currentStatus.TextColor3 = Config.Green
					footer.Text = "◆  CSYON HUB   •   ONLINE"

				end

			end)
		end
	end)
end

--// =========================================================
--// DRAGGING
--// =========================================================

local dragging = false
local dragStart
local startPosition

topBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position

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

			local delta = input.Position - dragStart

			main.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)

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

	if state then

		minimize.Text = "+"

		for _, child in ipairs(main:GetChildren()) do

			if child ~= topBar
				and child ~= mainStroke
				and child ~= mainGradient
				and child ~= mainCorner
				and child ~= glowLeft
				and child ~= glowRight
				and child ~= uiScale then

				if child:IsA("GuiObject") then
					child.Visible = false
				end
			end
		end

		topBar.Visible = true

		TweenService:Create(
			main,
			TweenInfo.new(0.3, Enum.EasingStyle.Quart),
			{
				Size = UDim2.fromOffset(290, 76)
			}
		):Play()

	else

		minimize.Text = "−"

		for _, child in ipairs(main:GetChildren()) do

			if child:IsA("GuiObject") then
				child.Visible = true
			end
		end

		TweenService:Create(
			main,
			TweenInfo.new(0.3, Enum.EasingStyle.Quart),
			{
				Size = normalSize
			}
		):Play()
	end
end

minimize.MouseButton1Click:Connect(function()
	setMinimized(not minimized)
end)

--// =========================================================
--// BUTTON HOVERS
--// =========================================================

close.MouseEnter:Connect(function()

	TweenService:Create(
		close,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Config.Red
		}
	):Play()

	close.TextColor3 = Config.White

end)

close.MouseLeave:Connect(function()

	TweenService:Create(
		close,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Color3.fromRGB(48, 18, 36)
		}
	):Play()

	close.TextColor3 = Config.Pink

end)

minimize.MouseEnter:Connect(function()

	TweenService:Create(
		minimize,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Config.Purple
		}
	):Play()

	minimize.TextColor3 = Config.White

end)

minimize.MouseLeave:Connect(function()

	TweenService:Create(
		minimize,
		TweenInfo.new(0.15),
		{
			BackgroundColor3 = Config.Panel2
		}
	):Play()

	minimize.TextColor3 = Config.Text

end)

--// =========================================================
--// CLOSE BUTTON
--// =========================================================

close.MouseButton1Click:Connect(function()
	closeLoader()
end)

--// =========================================================
--// PULSE EFFECT
--// =========================================================

task.spawn(function()

	while screenGui and screenGui.Parent do

		TweenService:Create(
			mainStroke,
			TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{
				Transparency = 0.55
			}
		):Play()

		task.wait(1.4)

		TweenService:Create(
			mainStroke,
			TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{
				Transparency = 0.15
			}
		):Play()

		task.wait(1.4)
	end

end)

--// =========================================================
--// OPEN ANIMATION
--// =========================================================

TweenService:Create(
	main,
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
--// DEBUG
--// =========================================================

print("╔══════════════════════════════╗")
print("║       ⚡ CSYON HUB           ║")
print("║       Cyber Loader v2.0      ║")
print("╚══════════════════════════════╝")
print("Game ID:", gameId)

if currentGameData then
	print("Detected:", currentGameData.Name)
else
	print("No supported game detected.")
end
