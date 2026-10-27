-- JARVIS | Blade Ball | Delta
-- UI Nova (Estilo Neon / DRAK inspirado)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Tema Neon
local Theme = {
	Background = Color3.fromRGB(6, 8, 14),
	Sidebar = Color3.fromRGB(10, 13, 22),
	Card = Color3.fromRGB(14, 18, 28),
	Accent = Color3.fromRGB(0, 180, 255),
	AccentGlow = Color3.fromRGB(0, 220, 255),
	Text = Color3.fromRGB(230, 240, 255),
	TextDim = Color3.fromRGB(110, 130, 160),
	Success = Color3.fromRGB(0, 230, 160),
	Danger = Color3.fromRGB(255, 70, 90),
}

local Config = {
	BallVelocity = false,
	Overlays = false,
	AntiKick = true,
	AntiBan = true,
	AntiTeleport = true,
}

local function Notify(title, text, tipo)
	tipo = tipo or "info"
	local color = Theme.Accent
	if tipo == "success" then color = Theme.Success end
	if tipo == "error" then color = Theme.Danger end

	local gui = CoreGui:FindFirstChild("JARVIS")
	if not gui then return end

	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 290, 0, 62)
	notif.Position = UDim2.new(1, 30, 1, -95)
	notif.BackgroundColor3 = Theme.Card
	notif.BorderSizePixel = 0
	notif.Parent = gui

	Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", notif)
	stroke.Color = color
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2

	local t = Instance.new("TextLabel", notif)
	t.Size = UDim2.new(1, -16, 0, 22)
	t.Position = UDim2.new(0, 12, 0, 7)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = color
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", notif)
	d.Size = UDim2.new(1, -16, 0, 24)
	d.Position = UDim2.new(0, 12, 0, 28)
	d.BackgroundTransparency = 1
	d.Text = text
	d.TextColor3 = Theme.Text
	d.Font = Enum.Font.Gotham
	d.TextSize = 12
	d.TextXAlignment = Enum.TextXAlignment.Left

	notif:TweenPosition(UDim2.new(1, -310, 1, -95), "Out", "Quart", 0.3, true)
	task.delay(3, function()
		notif:TweenPosition(UDim2.new(1, 30, 1, -95), "In", "Quart", 0.25, true)
		task.wait(0.3)
		notif:Destroy()
	end)
end

-- ====================== GUI ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JARVIS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = isMobile() and UDim2.new(0.94, 0, 0.82, 0) or UDim2.new(0, 780, 0, 460)
Main.Position = isMobile() and UDim2.new(0.03, 0, 0.09, 0) or UDim2.new(0.5, -390, 0.5, -230)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.6
mainStroke.Transparency = 0.25

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, isMobile() and 70 or 160, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local sideFix = Instance.new("Frame")
sideFix.Size = UDim2.new(0, 20, 1, 0)
sideFix.Position = UDim2.new(1, -20, 0, 0)
sideFix.BackgroundColor3 = Theme.Sidebar
sideFix.BorderSizePixel = 0
sideFix.Parent = Sidebar

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(1, -12, 0, 52)
LogoFrame.Position = UDim2.new(0, 6, 0, 8)
LogoFrame.BackgroundTransparency = 1
LogoFrame.Parent = Sidebar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 28)
Logo.BackgroundTransparency = 1
Logo.Text = isMobile() and "J" or "DRAK JARVIS"
Logo.TextColor3 = Theme.AccentGlow
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = isMobile() and 20 or 16
Logo.TextXAlignment = isMobile() and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
Logo.Parent = LogoFrame

local SubLogo = Instance.new("TextLabel")
SubLogo.Size = UDim2.new(1, 0, 0, 16)
SubLogo.Position = UDim2.new(0, 0, 0, 28)
SubLogo.BackgroundTransparency = 1
SubLogo.Text = "Blade Ball"
SubLogo.TextColor3 = Theme.TextDim
SubLogo.Font = Enum.Font.Gotham
SubLogo.TextSize = 11
SubLogo.TextXAlignment = isMobile() and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
SubLogo.Visible = not isMobile()
SubLogo.Parent = LogoFrame

-- Status
local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(1, -18, 0, 12)
StatusDot.BackgroundColor3 = Theme.Success
StatusDot.BorderSizePixel = 0
StatusDot.Parent = LogoFrame
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

-- Categories
local categories = {
	{Name = "Combat", Icon = "⚔"},
	{Name = "Visuals", Icon = "👁"},
	{Name = "Security", Icon = "🛡"},
	{Name = "Misc", Icon = "⚙"},
}

local CategoryButtons = {}
local ContentScroll
local CurrentCategory = "Visuals"

local function clearContent()
	for _, c in ipairs(ContentScroll:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
end

local function createCard(title, desc)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 68)
	card.BackgroundColor3 = Theme.Card
	card.BorderSizePixel = 0
	card.Parent = ContentScroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke", card)
	stroke.Color = Color3.fromRGB(30, 40, 60)
	stroke.Thickness = 1

	local t = Instance.new("TextLabel", card)
	t.Size = UDim2.new(1, -70, 0, 22)
	t.Position = UDim2.new(0, 14, 0, 10)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = Theme.Text
	t.Font = Enum.Font.GothamBold
	t.TextSize = 14
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", card)
	d.Size = UDim2.new(1, -70, 0, 20)
	d.Position = UDim2.new(0, 14, 0, 34)
	d.BackgroundTransparency = 1
	d.Text = desc or ""
	d.TextColor3 = Theme.TextDim
	d.Font = Enum.Font.Gotham
	d.TextSize = 12
	d.TextXAlignment = Enum.TextXAlignment.Left

	return card
end

local function addToggle(card, key, default)
	Config[key] = default
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 44, 0, 24)
	btn.Position = UDim2.new(1, -56, 0.5, -12)
	btn.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(40, 48, 65)
	btn.Text = ""
	btn.Parent = card
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

	local circle = Instance.new("Frame", btn)
	circle.Size = UDim2.new(0, 18, 0, 18)
	circle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

	btn.MouseButton1Click:Connect(function()
		Config[key] = not Config[key]
		TweenService:Create(btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Config[key] and Theme.Accent or Color3.fromRGB(40, 48, 65)
		}):Play()
		TweenService:Create(circle, TweenInfo.new(0.2), {
			Position = Config[key] and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		}):Play()
	end)
end

local function loadVisuals()
	clearContent()
	local list = {
		{"Ball Velocity", "Mostra velocidade da bola em tempo real", "BallVelocity"},
		{"Overlays (Ping / FPS)", "Exibe Ping e FPS na tela", "Overlays"},
	}
	for _, v in ipairs(list) do
		local card = createCard(v[1], v[2])
		addToggle(card, v[3], false)
	end
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 78)
end

local function loadSecurity()
	clearContent()
	local list = {
		{"Anti Kick", "Bloqueia tentativas de Kick", "AntiKick"},
		{"Anti Ban", "Proteção adicional contra bans", "AntiBan"},
		{"Anti Teleport", "Bloqueia teleports forçados", "AntiTeleport"},
	}
	for _, v in ipairs(list) do
		local card = createCard(v[1], v[2])
		addToggle(card, v[3], true)
	end
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 78)
end

for i, cat in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 38)
	btn.Position = UDim2.new(0, 5, 0, 68 + (i-1)*46)
	btn.BackgroundColor3 = Theme.Sidebar
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

	local icon = Instance.new("TextLabel", btn)
	icon.Size = UDim2.new(0, 28, 1, 0)
	icon.Position = UDim2.new(0, 6, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = cat.Icon
	icon.TextColor3 = Theme.TextDim
	icon.Font = Enum.Font.Gotham
	icon.TextSize = 15

	local label = Instance.new("TextLabel", btn)
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.new(0, 36, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = cat.Name
	label.TextColor3 = Theme.TextDim
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Visible = not isMobile()

	btn.MouseButton1Click:Connect(function()
		for _, b in pairs(CategoryButtons) do
			b.Button.BackgroundColor3 = Theme.Sidebar
			b.Icon.TextColor3 = Theme.TextDim
			if b.Label then b.Label.TextColor3 = Theme.TextDim end
		end
		btn.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
		icon.TextColor3 = Theme.AccentGlow
		if label then label.TextColor3 = Theme.AccentGlow end

		if cat.Name == "Visuals" then
			loadVisuals()
		elseif cat.Name == "Security" then
			loadSecurity()
		else
			clearContent()
		end
	end)

	CategoryButtons[cat.Name] = {Button = btn, Icon = icon, Label = label}
end

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, isMobile() and -78 or -168, 1, -52)
Content.Position = UDim2.new(0, isMobile() and 74 or 164, 0, 52)
Content.BackgroundTransparency = 1
Content.Parent = Main

ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -12, 1, -12)
ContentScroll.Position = UDim2.new(0, 6, 0, 6)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = Theme.Accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
ContentScroll.Parent = Content
Instance.new("UIListLayout", ContentScroll).Padding = UDim.new(0, 9)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, isMobile() and -78 or -168, 0, 48)
Header.Position = UDim2.new(0, isMobile() and 74 or 164, 0, 0)
Header.BackgroundColor3 = Theme.Background
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VISUALS"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Ativar Visuals
if CategoryButtons["Visuals"] then
	CategoryButtons["Visuals"].Button.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
	CategoryButtons["Visuals"].Icon.TextColor3 = Theme.AccentGlow
	if CategoryButtons["Visuals"].Label then
		CategoryButtons["Visuals"].Label.TextColor3 = Theme.AccentGlow
	end
	loadVisuals()
end

-- Arrastar
if not isMobile() then
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Segurança (leve)
task.spawn(function()
	pcall(function()
		if getrawmetatable and newcclosure and setreadonly then
			local mt = getrawmetatable(game)
			local old = mt.__namecall
			setreadonly(mt, false)
			mt.__namecall = newcclosure(function(self, ...)
				local method = getnamecallmethod()
				if method == "Kick" and Config.AntiKick then
					Notify("Security", "Kick bloqueado", "warning")
					return
				end
				return old(self, ...)
			end)
			setreadonly(mt, true)
		end
	end)
end)

-- Ball Velocity + Overlay
local VelocityGui = Instance.new("ScreenGui")
VelocityGui.Name = "JARVIS_Velocity"
VelocityGui.ResetOnSpawn = false
VelocityGui.Parent = CoreGui

local VelFrame = Instance.new("Frame")
VelFrame.Size = UDim2.new(0, 150, 0, 52)
VelFrame.Position = UDim2.new(0, 15, 0, 110)
VelFrame.BackgroundColor3 = Theme.Card
VelFrame.BorderSizePixel = 0
VelFrame.Visible = false
VelFrame.Parent = VelocityGui
Instance.new("UICorner", VelFrame).CornerRadius = UDim.new(0, 9)
local vs = Instance.new("UIStroke", VelFrame)
vs.Color = Theme.Accent
vs.Thickness = 1.2
vs.Transparency = 0.3

local VelTitle = Instance.new("TextLabel", VelFrame)
VelTitle.Size = UDim2.new(1, 0, 0, 18)
VelTitle.Position = UDim2.new(0, 0, 0, 4)
VelTitle.BackgroundTransparency = 1
VelTitle.Text = "Ball Velocity"
VelTitle.TextColor3 = Theme.Accent
VelTitle.Font = Enum.Font.GothamBold
VelTitle.TextSize = 11

local VelText = Instance.new("TextLabel", VelFrame)
VelText.Size = UDim2.new(1, -10, 0, 26)
VelText.Position = UDim2.new(0, 8, 0, 22)
VelText.BackgroundTransparency = 1
VelText.Text = "0.0"
VelText.TextColor3 = Theme.Text
VelText.Font = Enum.Font.Gotham
VelText.TextSize = 16
VelText.TextXAlignment = Enum.TextXAlignment.Left

local OverlayGui = Instance.new("ScreenGui")
OverlayGui.Name = "JARVIS_Overlay"
OverlayGui.ResetOnSpawn = false
OverlayGui.Parent = CoreGui

local OverlayLabel = Instance.new("TextLabel")
OverlayLabel.Size = UDim2.new(0, 190, 0, 32)
OverlayLabel.Position = UDim2.new(1, -210, 0, 12)
OverlayLabel.BackgroundTransparency = 1
OverlayLabel.Text = ""
OverlayLabel.TextColor3 = Theme.AccentGlow
OverlayLabel.Font = Enum.Font.GothamBold
OverlayLabel.TextSize = 13
OverlayLabel.TextXAlignment = Enum.TextXAlignment.Right
OverlayLabel.Visible = false
OverlayLabel.Parent = OverlayGui

local lastTick = tick()
local frameCount = 0
local currentFPS = 60

RunService.RenderStepped:Connect(function()
	frameCount += 1
	if tick() - lastTick >= 1 then
		currentFPS = frameCount
		frameCount = 0
		lastTick = tick()
	end

	if Config.BallVelocity then
		VelFrame.Visible = true
		local ball = Workspace:FindFirstChild("Ball")
		if ball and ball:IsA("BasePart") then
			VelText.Text = string.format("%.1f", ball.AssemblyLinearVelocity.Magnitude)
		else
			VelText.Text = "—"
		end
	else
		VelFrame.Visible = false
	end

	if Config.Overlays then
		OverlayLabel.Visible = true
		local ping = "?"
		pcall(function()
			ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
		end)
		OverlayLabel.Text = "Ping: " .. ping .. "  |  FPS: " .. currentFPS
	else
		OverlayLabel.Visible = false
	end
end)

Notify("DRAK JARVIS", "Interface carregada", "success")
print("[JARVIS] Nova UI carregada.")
