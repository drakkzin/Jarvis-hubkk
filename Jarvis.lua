-- JARVIS | Blade Ball | Delta
-- Versão corrigida (mais estável)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local Theme = {
	Background = Color3.fromRGB(8, 10, 14),
	Sidebar = Color3.fromRGB(12, 15, 20),
	Panel = Color3.fromRGB(16, 20, 27),
	Card = Color3.fromRGB(20, 25, 33),
	Accent = Color3.fromRGB(0, 190, 255),
	Accent2 = Color3.fromRGB(0, 230, 210),
	Text = Color3.fromRGB(235, 240, 245),
	TextDim = Color3.fromRGB(120, 130, 145),
	Success = Color3.fromRGB(0, 220, 145),
	Danger = Color3.fromRGB(255, 70, 70),
	Warning = Color3.fromRGB(255, 175, 40)
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
	if tipo == "warning" then color = Theme.Warning end

	local gui = CoreGui:FindFirstChild("JARVIS")
	if not gui then return end

	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 300, 0, 65)
	notif.Position = UDim2.new(1, 30, 1, -100)
	notif.BackgroundColor3 = Theme.Card
	notif.BorderSizePixel = 0
	notif.Parent = gui

	Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", notif)
	stroke.Color = color
	stroke.Thickness = 1.3

	local t = Instance.new("TextLabel", notif)
	t.Size = UDim2.new(1, -16, 0, 22)
	t.Position = UDim2.new(0, 12, 0, 8)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = color
	t.Font = Enum.Font.GothamBold
	t.TextSize = 14
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", notif)
	d.Size = UDim2.new(1, -16, 0, 26)
	d.Position = UDim2.new(0, 12, 0, 30)
	d.BackgroundTransparency = 1
	d.Text = text
	d.TextColor3 = Theme.Text
	d.Font = Enum.Font.Gotham
	d.TextSize = 13
	d.TextXAlignment = Enum.TextXAlignment.Left
	d.TextWrapped = true

	notif:TweenPosition(UDim2.new(1, -320, 1, -100), "Out", "Quart", 0.3, true)
	task.delay(3.2, function()
		notif:TweenPosition(UDim2.new(1, 30, 1, -100), "In", "Quart", 0.25, true)
		task.wait(0.3)
		notif:Destroy()
	end)
end

-- ====================== GUI PRIMEIRO ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JARVIS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

if isMobile() then
	Main.Size = UDim2.new(0.95, 0, 0.85, 0)
	Main.Position = UDim2.new(0.025, 0, 0.08, 0)
else
	Main.Size = UDim2.new(0, 720, 0, 480)
	Main.Position = UDim2.new(0.5, -360, 0.5, -240)
end

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Theme.Accent
stroke.Thickness = 1.4
stroke.Transparency = 0.3

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, isMobile() and 64 or 150, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

local SideFix = Instance.new("Frame")
SideFix.Size = UDim2.new(0, 16, 1, 0)
SideFix.Position = UDim2.new(1, -16, 0, 0)
SideFix.BackgroundColor3 = Theme.Sidebar
SideFix.BorderSizePixel = 0
SideFix.Parent = Sidebar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -6, 0, 46)
Logo.Position = UDim2.new(0, 6, 0, 6)
Logo.BackgroundTransparency = 1
Logo.Text = isMobile() and "J" or "J.A.R.V.I.S"
Logo.TextColor3 = Theme.Accent
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = isMobile() and 18 or 16
Logo.TextXAlignment = isMobile() and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
Logo.Parent = Sidebar

local categories = {
	{Name = "Visuals", Icon = "👁"},
	{Name = "Security", Icon = "🛡"},
	{Name = "Misc", Icon = "⚙"},
}

local CategoryButtons = {}
local ContentScroll

local function clearContent()
	for _, c in ipairs(ContentScroll:GetChildren()) do
		if not c:IsA("UIListLayout") then
			c:Destroy()
		end
	end
end

local function createCard(title, desc)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 70)
	card.BackgroundColor3 = Theme.Card
	card.BorderSizePixel = 0
	card.Parent = ContentScroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

	local t = Instance.new("TextLabel", card)
	t.Size = UDim2.new(1, -65, 0, 22)
	t.Position = UDim2.new(0, 12, 0, 10)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = Theme.Text
	t.Font = Enum.Font.GothamBold
	t.TextSize = 14
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", card)
	d.Size = UDim2.new(1, -65, 0, 20)
	d.Position = UDim2.new(0, 12, 0, 34)
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
	btn.Position = UDim2.new(1, -54, 0.5, -12)
	btn.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(45, 52, 65)
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
		TweenService:Create(btn, TweenInfo.new(0.18), {
			BackgroundColor3 = Config[key] and Theme.Accent or Color3.fromRGB(45, 52, 65)
		}):Play()
		TweenService:Create(circle, TweenInfo.new(0.18), {
			Position = Config[key] and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		}):Play()
	end)
end

local function loadVisuals()
	clearContent()
	local list = {
		{"Ball Velocity", "Mostra a velocidade da bola", "BallVelocity"},
		{"Overlays (Ping/FPS)", "Mostra Ping e FPS na tela", "Overlays"},
	}
	for _, v in ipairs(list) do
		local card = createCard(v[1], v[2])
		addToggle(card, v[3], false)
	end
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 80)
end

local function loadSecurity()
	clearContent()
	local list = {
		{"Anti Kick", "Bloqueia tentativas de Kick", "AntiKick"},
		{"Anti Ban", "Proteção extra", "AntiBan"},
		{"Anti Teleport", "Bloqueia teleports forçados", "AntiTeleport"},
	}
	for _, v in ipairs(list) do
		local card = createCard(v[1], v[2])
		addToggle(card, v[3], true)
	end
	ContentScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 80)
end

for i, cat in ipairs(categories) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 36)
	btn.Position = UDim2.new(0, 4, 0, 55 + (i-1)*42)
	btn.BackgroundColor3 = Theme.Sidebar
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local icon = Instance.new("TextLabel", btn)
	icon.Size = UDim2.new(0, 26, 1, 0)
	icon.Position = UDim2.new(0, 5, 0, 0)
	icon.BackgroundTransparency = 1
	icon.Text = cat.Icon
	icon.TextColor3 = Theme.TextDim
	icon.Font = Enum.Font.Gotham
	icon.TextSize = 14

	local label = Instance.new("TextLabel", btn)
	label.Size = UDim2.new(1, -34, 1, 0)
	label.Position = UDim2.new(0, 32, 0, 0)
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
		btn.BackgroundColor3 = Theme.Panel
		icon.TextColor3 = Theme.Accent
		if label then label.TextColor3 = Theme.Accent end

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

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, isMobile() and -70 or -158, 1, -48)
Content.Position = UDim2.new(0, isMobile() and 66 or 154, 0, 48)
Content.BackgroundTransparency = 1
Content.Parent = Main

ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -8, 1, -8)
ContentScroll.Position = UDim2.new(0, 4, 0, 4)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = Theme.Accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
ContentScroll.Parent = Content
Instance.new("UIListLayout", ContentScroll).Padding = UDim.new(0, 8)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, isMobile() and -70 or -158, 0, 44)
Header.Position = UDim2.new(0, isMobile() and 66 or 154, 0, 0)
Header.BackgroundColor3 = Theme.Background
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "J.A.R.V.I.S"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Theme.Card
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Ativa Visuals por padrão
if CategoryButtons["Visuals"] then
	CategoryButtons["Visuals"].Button.BackgroundColor3 = Theme.Panel
	CategoryButtons["Visuals"].Icon.TextColor3 = Theme.Accent
	if CategoryButtons["Visuals"].Label then
		CategoryButtons["Visuals"].Label.TextColor3 = Theme.Accent
	end
	loadVisuals()
end

-- Arrastar (PC)
if not isMobile() then
	local dragging, dragStart, startPos
	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
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

-- ====================== SEGURANÇA (com proteção) ======================
task.spawn(function()
	local success, err = pcall(function()
		if not getrawmetatable or not newcclosure or not setreadonly then
			Notify("Security", "Executor não suporta hooks avançados", "warning")
			return
		end

		local mt = getrawmetatable(game)
		local oldNamecall = mt.__namecall
		setreadonly(mt, false)

		mt.__namecall = newcclosure(function(self, ...)
			local method = getnamecallmethod()
			if method == "Kick" and Config.AntiKick then
				Notify("Security", "Kick bloqueado", "warning")
				return
			end
			if (method == "FireServer" or method == "InvokeServer") and Config.AntiKick then
				local name = tostring(self.Name):lower()
				if name:find("kick") or name:find("ban") then
					Notify("Security", "Remote de Kick/Ban bloqueado", "warning")
					return
				end
			end
			return oldNamecall(self, ...)
		end)

		setreadonly(mt, true)

		local oldKick = LocalPlayer.Kick
		LocalPlayer.Kick = function()
			if Config.AntiKick then
				Notify("Security", "LocalPlayer:Kick bloqueado", "warning")
				return
			end
			return oldKick(LocalPlayer)
		end

		Notify("Security", "Anti-Kick ativado", "success")
	end)

	if not success then
		warn("[JARVIS] Erro na segurança:", err)
	end
end)

-- ====================== VISUAIS ======================
local VelocityGui = Instance.new("ScreenGui")
VelocityGui.Name = "JARVIS_Velocity"
VelocityGui.ResetOnSpawn = false
VelocityGui.Parent = CoreGui

local VelFrame = Instance.new("Frame")
VelFrame.Size = UDim2.new(0, 150, 0, 55)
VelFrame.Position = UDim2.new(0, 15, 0, 110)
VelFrame.BackgroundColor3 = Theme.Card
VelFrame.BorderSizePixel = 0
VelFrame.Visible = false
VelFrame.Parent = VelocityGui
Instance.new("UICorner", VelFrame).CornerRadius = UDim.new(0, 8)

local VelTitle = Instance.new("TextLabel", VelFrame)
VelTitle.Size = UDim2.new(1, 0, 0, 20)
VelTitle.Position = UDim2.new(0, 0, 0, 4)
VelTitle.BackgroundTransparency = 1
VelTitle.Text = "Ball Velocity"
VelTitle.TextColor3 = Theme.Accent
VelTitle.Font = Enum.Font.GothamBold
VelTitle.TextSize = 12

local VelText = Instance.new("TextLabel", VelFrame)
VelText.Size = UDim2.new(1, -8, 0, 26)
VelText.Position = UDim2.new(0, 6, 0, 24)
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
OverlayLabel.Size = UDim2.new(0, 190, 0, 35)
OverlayLabel.Position = UDim2.new(1, -210, 0, 10)
OverlayLabel.BackgroundTransparency = 1
OverlayLabel.Text = ""
OverlayLabel.TextColor3 = Theme.Accent2
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

Notify("J.A.R.V.I.S", "Interface carregada com sucesso", "success")
print("[JARVIS] Script carregado.")
