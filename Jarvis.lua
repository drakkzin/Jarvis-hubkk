--[[ DRAK JARVIS · Blade Ball ]]
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui", 10)

pcall(function()
	for _, n in ipairs({"JARVIS","DRAKJARVIS","MemeHub","ZyxHub","JARVIS_Float","JARVIS_Vel","JARVIS_Over"}) do
		local o = (PG and PG:FindFirstChild(n)) or CoreGui:FindFirstChild(n)
		if o then o:Destroy() end
	end
end)

local function GG()
	local ok, g = pcall(getgenv)
	return (ok and type(g) == "table") and g or _G
end

local function loadJSON(name, def)
	local d = def
	pcall(function()
		if GG()["Jarvis_"..name] then d = GG()["Jarvis_"..name] return end
		if isfile and readfile and isfile("Jarvis_"..name..".json") then
			d = HttpService:JSONDecode(readfile("Jarvis_"..name..".json"))
		end
	end)
	return d or def
end

local function saveJSON(name, data)
	pcall(function()
		GG()["Jarvis_"..name] = data
		if writefile then writefile("Jarvis_"..name..".json", HttpService:JSONEncode(data)) end
	end)
end

local Theme = loadJSON("Theme", {
	accentR = 0, accentG = 180, accentB = 255,
	bgR = 8, bgG = 10, bgB = 18,
	cardR = 16, cardG = 20, cardB = 34,
	guiTrans = 0.12,
	cardTrans = 0.18,
	sidebarTrans = 0.08,
	wallTrans = 0.55,
	wallpaper = "",
	floatImage = "",
	floatSize = 56,
	uiScale = 1,
	winW = 820,
	winH = 500,
	showFloat = true,
})

local function C(r,g,b) return Color3.fromRGB(r,g,b) end
local function accent() return C(Theme.accentR, Theme.accentG, Theme.accentB) end

local T = {
	bg = C(Theme.bgR, Theme.bgG, Theme.bgB),
	sidebar = C(12, 15, 26),
	card = C(Theme.cardR, Theme.cardG, Theme.cardB),
	text = C(235, 242, 255),
	dim = C(130, 145, 170),
	accent = accent(),
	success = C(0, 220, 150),
	danger = C(255, 80, 100),
	line = C(35, 45, 70),
}

local function corner(p, r)
	Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 10)
end

local function stroke(p, col, th, tr)
	local s = Instance.new("UIStroke", p)
	s.Color = col or T.line
	s.Thickness = th or 1
	s.Transparency = tr or 0.4
end

local Config = {
	BallVelocity = false,
	Overlays = false,
	AntiKick = true,
	AntiBan = true,
	AntiTeleport = true,
	ShowFloat = Theme.showFloat \~= false,
}

local function Notify(title, text, tipo)
	local gui = CoreGui:FindFirstChild("DRAKJARVIS")
	if not gui then return end
	local color = T.accent
	if tipo == "success" then color = T.success end
	if tipo == "error" then color = T.danger end

	local n = Instance.new("Frame")
	n.Size = UDim2.new(0, 280, 0, 58)
	n.Position = UDim2.new(1, 20, 1, -90)
	n.BackgroundColor3 = T.card
	n.BackgroundTransparency = Theme.cardTrans
	n.BorderSizePixel = 0
	n.Parent = gui
	corner(n, 10)
	stroke(n, color, 1.3, 0.2)

	local t = Instance.new("TextLabel", n)
	t.Size = UDim2.new(1, -14, 0, 20)
	t.Position = UDim2.new(0, 10, 0, 7)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = color
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", n)
	d.Size = UDim2.new(1, -14, 0, 22)
	d.Position = UDim2.new(0, 10, 0, 28)
	d.BackgroundTransparency = 1
	d.Text = text
	d.TextColor3 = T.text
	d.Font = Enum.Font.Gotham
	d.TextSize = 12
	d.TextXAlignment = Enum.TextXAlignment.Left

	n:TweenPosition(UDim2.new(1, -300, 1, -90), "Out", "Quart", 0.28, true)
	task.delay(2.8, function()
		n:TweenPosition(UDim2.new(1, 20, 1, -90), "In", "Quart", 0.22, true)
		task.wait(0.25)
		n:Destroy()
	end)
end

-- ====================== MAIN ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DRAKJARVIS"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, Theme.winW or 820, 0, Theme.winH or 500)
Main.Position = UDim2.new(0.5, -(Theme.winW or 820)/2, 0.5, -(Theme.winH or 500)/2)
Main.BackgroundColor3 = T.bg
Main.BackgroundTransparency = Theme.guiTrans
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = true
Main.Parent = ScreenGui
corner(Main, 14)
stroke(Main, T.accent, 1.5, 0.25)

if isMobile then
	Main.Size = UDim2.new(0.95, 0, 0.80, 0)
	Main.Position = UDim2.new(0.025, 0, 0.10, 0)
end

local UIScale = Instance.new("UIScale", Main)
UIScale.Scale = Theme.uiScale or 1

local Wall = Instance.new("ImageLabel", Main)
Wall.Size = UDim2.new(1, 0, 1, 0)
Wall.BackgroundTransparency = 1
Wall.ImageTransparency = Theme.wallTrans
Wall.ScaleType = Enum.ScaleType.Crop
Wall.ZIndex = 0
if Theme.wallpaper and Theme.wallpaper \~= "" then
	pcall(function() Wall.Image = Theme.wallpaper end)
end

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, isMobile and 62 or 150, 1, 0)
Sidebar.BackgroundColor3 = T.sidebar
Sidebar.BackgroundTransparency = Theme.sidebarTrans
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
corner(Sidebar, 14)

local sideFix = Instance.new("Frame")
sideFix.Size = UDim2.new(0, 16, 1, 0)
sideFix.Position = UDim2.new(1, -16, 0, 0)
sideFix.BackgroundColor3 = T.sidebar
sideFix.BackgroundTransparency = Theme.sidebarTrans
sideFix.BorderSizePixel = 0
sideFix.Parent = Sidebar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -8, 0, 26)
Logo.Position = UDim2.new(0, 6, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Text = isMobile and "J" or "DRAK JARVIS"
Logo.TextColor3 = T.accent
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = isMobile and 17 or 14
Logo.TextXAlignment = isMobile and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
Logo.Parent = Sidebar

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -8, 0, 14)
Status.Position = UDim2.new(0, 6, 0, 36)
Status.BackgroundTransparency = 1
Status.Text = "● Online"
Status.TextColor3 = T.success
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.TextXAlignment = isMobile and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
Status.Parent = Sidebar

local categories = {
	{Name = "Visuals", Icon = "👁"},
	{Name = "Security", Icon = "🛡"},
	{Name = "Combat", Icon = "⚔"},
	{Name = "Config", Icon = "⚙"},
}

local CatButtons = {}
local ContentScroll

local function clearContent()
	if not ContentScroll then return end
	for _, c in ipairs(ContentScroll:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
end

local function createCard(title, desc)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 66)
	card.BackgroundColor3 = T.card
	card.BackgroundTransparency = Theme.cardTrans
	card.BorderSizePixel = 0
	card.Parent = ContentScroll
	corner(card, 10)
	stroke(card, T.line, 1, 0.5)

	local t = Instance.new("TextLabel", card)
	t.Size = UDim2.new(1, -68, 0, 20)
	t.Position = UDim2.new(0, 12, 0, 10)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = T.text
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", card)
	d.Size = UDim2.new(1, -68, 0, 18)
	d.Position = UDim2.new(0, 12, 0, 34)
	d.BackgroundTransparency = 1
	d.Text = desc or ""
	d.TextColor3 = T.dim
	d.Font = Enum.Font.Gotham
	d.TextSize = 11
	d.TextXAlignment = Enum.TextXAlignment.Left

	return card
end

local function addToggle(card, key, default, onChange)
	Config[key] = default
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 42, 0, 22)
	btn.Position = UDim2.new(1, -54, 0.5, -11)
	btn.BackgroundColor3 = default and T.accent or Color3.fromRGB(45, 52, 70)
	btn.Text = ""
	btn.Parent = card
	corner(btn, 11)

	local circle = Instance.new("Frame", btn)
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	corner(circle, 8)

	btn.MouseButton1Click:Connect(function()
		Config[key] = not Config[key]
		TS:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Config[key] and T.accent or Color3.fromRGB(45, 52, 70)
		}):Play()
		TS:Create(circle, TweenInfo.new(0.15), {
			Position = Config[key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		}):Play()
		if onChange then onChange(Config[key]) end
	end)
end

local FloatGui, FloatBtn

local function updateFloatVisibility()
	if FloatGui then
		FloatGui.Enabled = Config.ShowFloat
	end
end

local function loadVisuals()
	clearContent()
	local list = {
		{"Ball Velocity", "Mostra velocidade da bola", "BallVelocity"},
		{"Overlays (Ping / FPS)", "Exibe Ping e FPS", "Overlays"},
	}
	for _, v in ipairs(list) do
		local card = createCard(v[1], v[2])
		addToggle(card, v[3], false)
	end
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 76)
end

local function loadSecurity()
	clearContent()
	local list = {
		{"Anti Kick", "Bloqueia Kick", "AntiKick"},
		{"Anti Ban", "Proteção extra", "AntiBan"},
		{"Anti Teleport", "Bloqueia teleports", "AntiTeleport"},
	}
	for _, v in ipairs(list) do
		local card = createCard(v[1], v[2])
		addToggle(card, v[3], true)
	end
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 76)
end

local function loadConfig()
	clearContent()
	local card = createCard("Botão Flutuante", "Mostra ou esconde o botão J")
	addToggle(card, "ShowFloat", Config.ShowFloat, function(v)
		Theme.showFloat = v
		saveJSON("Theme", Theme)
		updateFloatVisibility()
		Notify("Config", v and "Float ativado" or "Float desativado", "success")
	end)
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 90)
end

for i, cat in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 36)
	btn.Position = UDim2.new(0, 4, 0, 58 + (i-1)*44)
	btn.BackgroundColor3 = T.sidebar
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = Sidebar
	corner(btn, 8)

	local icon = Instance.new("TextLabel", btn)
	icon.Size = UDim2.new(0, 26, 1, 0)
	icon.Position = UDim2.new(0, 5, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = cat.Icon
	icon.TextColor3 = T.dim
	icon.Font = Enum.Font.Gotham
	icon.TextSize = 14

	local label = Instance.new("TextLabel", btn)
	label.Size = UDim2.new(1, -36, 1, 0)
	label.Position = UDim2.new(0, 32, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = cat.Name
	label.TextColor3 = T.dim
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Visible = not isMobile

	btn.MouseButton1Click:Connect(function()
		for _, b in pairs(CatButtons) do
			b.Button.BackgroundTransparency = 1
			b.Icon.TextColor3 = T.dim
			if b.Label then b.Label.TextColor3 = T.dim end
		end
		btn.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
		btn.BackgroundTransparency = 0.25
		icon.TextColor3 = T.accent
		if label then label.TextColor3 = T.accent end

		if cat.Name == "Visuals" then loadVisuals()
		elseif cat.Name == "Security" then loadSecurity()
		elseif cat.Name == "Config" then loadConfig()
		else clearContent() end
	end)

	CatButtons[cat.Name] = {Button = btn, Icon = icon, Label = label}
end

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, isMobile and -70 or -158, 1, -50)
Content.Position = UDim2.new(0, isMobile and 66 or 154, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = Main

ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -8, 1, -8)
ContentScroll.Position = UDim2.new(0, 4, 0, 4)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = T.accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
ContentScroll.Parent = Content
Instance.new("UIListLayout", ContentScroll).Padding = UDim.new(0, 8)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, isMobile and -70 or -158, 0, 46)
Header.Position = UDim2.new(0, isMobile and 66 or 154, 0, 0)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VISUALS"
Title.TextColor3 = T.text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 38, 55)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = T.text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
corner(CloseBtn, 7)
CloseBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

if CatButtons["Visuals"] then
	CatButtons["Visuals"].Button.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
	CatButtons["Visuals"].Button.BackgroundTransparency = 0.25
	CatButtons["Visuals"].Icon.TextColor3 = T.accent
	if CatButtons["Visuals"].Label then CatButtons["Visuals"].Label.TextColor3 = T.accent end
	loadVisuals()
end

-- Drag
if not isMobile then
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
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ====================== FLOAT BUTTON ======================
FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "JARVIS_Float"
FloatGui.ResetOnSpawn = false
FloatGui.IgnoreGuiInset = true
FloatGui.DisplayOrder = 999
FloatGui.Enabled = Config.ShowFloat
FloatGui.Parent = PG

FloatBtn = Instance.new("ImageButton")
FloatBtn.Size = UDim2.new(0, Theme.floatSize or 56, 0, Theme.floatSize or 56)
FloatBtn.Position = UDim2.new(0, 14, 0.55, 0)
FloatBtn.BackgroundColor3 = T.accent
FloatBtn.BorderSizePixel = 0
FloatBtn.Image = ""
FloatBtn.Parent = FloatGui
corner(FloatBtn, 13)
stroke(FloatBtn, Color3.fromRGB(255,255,255), 1.4, 0.35)

local FloatTxt = Instance.new("TextLabel", FloatBtn)
FloatTxt.Size = UDim2.new(1, 0, 1, 0)
FloatTxt.BackgroundTransparency = 1
FloatTxt.Text = "J"
FloatTxt.TextColor3 = Color3.new(1,1,1)
FloatTxt.Font = Enum.Font.GothamBlack
FloatTxt.TextScaled = true
FloatTxt.Parent = FloatBtn

do
	local dragging, start, pos, moved
	FloatBtn.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			start = i.Position
			pos = FloatBtn.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			local d = i.Position - start
			if math.abs(d.X) + math.abs(d.Y) > 8 then moved = true end
			FloatBtn.Position = UDim2.new(0, pos.X.Offset + d.X, 0, pos.Y.Offset + d.Y)
		end
	end)
	FloatBtn.MouseButton1Click:Connect(function()
		if moved then return end
		Main.Visible = not Main.Visible
	end)
end

-- ====================== 2 DEDOS ======================
local touchCount = 0
local lastToggle = 0

UIS.TouchStarted:Connect(function()
	touchCount = touchCount + 1
end)

UIS.TouchEnded:Connect(function()
	touchCount = math.max(0, touchCount - 1)
end)

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.Touch then
		task.wait(0.04)
		if touchCount >= 2 and tick() - lastToggle > 0.35 then
			lastToggle = tick()
			Main.Visible = not Main.Visible
			Notify("JARVIS", Main.Visible and "UI aberta" or "UI fechada", "success")
		end
	end
end)

UIS.InputBegan:Connect(function(input, g)
	if not g and input.KeyCode == Enum.KeyCode.RightShift then
		Main.Visible = not Main.Visible
	end
end)

-- ====================== SECURITY ======================
task.spawn(function()
	pcall(function()
		if getrawmetatable and newcclosure and setreadonly then
			local mt = getrawmetatable(game)
			local old = mt.__namecall
			setreadonly(mt, false)
			mt.__namecall = newcclosure(function(self, ...)
				if getnamecallmethod() == "Kick" and Config.AntiKick then
					Notify("Security", "Kick bloqueado", "warning")
					return
				end
				return old(self, ...)
			end)
			setreadonly(mt, true)
		end
	end)
end)

-- ====================== VISUALS ======================
local VelGui = Instance.new("ScreenGui")
VelGui.Name = "JARVIS_Vel"
VelGui.ResetOnSpawn = false
VelGui.Parent = CoreGui

local VelFrame = Instance.new("Frame")
VelFrame.Size = UDim2.new(0, 140, 0, 48)
VelFrame.Position = UDim2.new(0, 12, 0, 100)
VelFrame.BackgroundColor3 = T.card
VelFrame.BackgroundTransparency = Theme.cardTrans
VelFrame.BorderSizePixel = 0
VelFrame.Visible = false
VelFrame.Parent = VelGui
corner(VelFrame, 8)
stroke(VelFrame, T.accent, 1.1, 0.3)

local VelTitle = Instance.new("TextLabel", VelFrame)
VelTitle.Size = UDim2.new(1, 0, 0, 16)
VelTitle.Position = UDim2.new(0, 0, 0, 3)
VelTitle.BackgroundTransparency = 1
VelTitle.Text = "Ball Velocity"
VelTitle.TextColor3 = T.accent
VelTitle.Font = Enum.Font.GothamBold
VelTitle.TextSize = 10

local VelText = Instance.new("TextLabel", VelFrame)
VelText.Size = UDim2.new(1, -8, 0, 22)
VelText.Position = UDim2.new(0, 6, 0, 20)
VelText.BackgroundTransparency = 1
VelText.Text = "0.0"
VelText.TextColor3 = T.text
VelText.Font = Enum.Font.Gotham
VelText.TextSize = 14
VelText.TextXAlignment = Enum.TextXAlignment.Left

local OverGui = Instance.new("ScreenGui")
OverGui.Name = "JARVIS_Over"
OverGui.ResetOnSpawn = false
OverGui.Parent = CoreGui

local OverLabel = Instance.new("TextLabel")
OverLabel.Size = UDim2.new(0, 170, 0, 26)
OverLabel.Position = UDim2.new(1, -185, 0, 10)
OverLabel.BackgroundTransparency = 1
OverLabel.Text = ""
OverLabel.TextColor3 = T.accent
OverLabel.Font = Enum.Font.GothamBold
OverLabel.TextSize = 12
OverLabel.TextXAlignment = Enum.TextXAlignment.Right
OverLabel.Visible = false
OverLabel.Parent = OverGui

local lastTick, frames, fps = tick(), 0, 60
RS.RenderStepped:Connect(function()
	frames = frames + 1
	if tick() - lastTick >= 1 then
		fps = frames
		frames = 0
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
		OverLabel.Visible = true
		local ping = "?"
		pcall(function()
			ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
		end)
		OverLabel.Text = "Ping: "..tostring(ping).."  |  FPS: "..tostring(fps)
	else
		OverLabel.Visible = false
	end
end)

Notify("DRAK JARVIS", "Carregado · 2 dedos para abrir/fechar", "success")
print("[DRAK JARVIS] OK - 2 finger toggle + float config")
