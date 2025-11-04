--// identity fraud script \\--
--[[ 
should i make my variables sound AI? anyways...
to-do: add auto morse code
]]
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
	Name = "Idenkitty Fraud",
	Icon = 0,
	LoadingTitle = "cats",
	LoadingSubtitle = "stan is coming for you.",
	ShowText = "",
	Theme = "Default",
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = true,
	DisableBuildWarnings = true,
	ConfigurationSaving = { Enabled = true, FolderName = "cathub", FileName = "idenkitty_fraud" },
	KeySystem = false,
})

local highlights, labels = {}, {}
local monsters, players = {}, {}
local doors = {
	workspace.Doors:WaitForChild("Door1"),
	workspace:WaitForChild("Second Door"):WaitForChild("Door2"),
	workspace:WaitForChild("Radio"),
}

local function addESP(part, name)
	local hl = Instance.new("Highlight")
	hl.Adornee = part
	hl.FillColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.5
	hl.OutlineColor = Color3.fromRGB(0, 0, 0)
	hl.OutlineTransparency = 0
	hl.Enabled = false
	hl.Parent = part
	highlights[part] = hl
	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Enabled = false
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = name
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 14
	textLabel.Parent = billboard
	billboard.Parent = part
	labels[part] = billboard
end

for _, part in ipairs(doors) do
	addESP(part, part.Name)
end

for _, ladder in ipairs(workspace["Maze 2"]["Ladder Colliders"]:GetChildren()) do
	if ladder:IsA("BasePart") and ladder.Name == "Truss" then
		addESP(ladder, "Ladder")
		table.insert(doors, ladder)
	end
end

workspace["Maze 2"]["Ladder Colliders"].ChildAdded:Connect(function(ladder)
	if ladder:IsA("BasePart") and ladder.Name == "Truss" then
		addESP(ladder, "Ladder")
		table.insert(doors, ladder)
	end
end)

for _, npc in ipairs(workspace.NPCs:GetChildren()) do
	if npc:IsA("Model") and npc:FindFirstChildWhichIsA("BasePart") then
		local part = npc:FindFirstChildWhichIsA("BasePart")
		local hl = Instance.new("Highlight")
		hl.Adornee = part
		hl.FillColor = Color3.fromRGB(255, 255, 255)
		hl.FillTransparency = 0.5
		hl.OutlineColor = Color3.fromRGB(0, 0, 0)
		hl.OutlineTransparency = 0
		hl.Enabled = false
		hl.Parent = part
		local billboard = Instance.new("BillboardGui")
		billboard.Adornee = part
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Enabled = false
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = npc.Name
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextSize = 14
		textLabel.Parent = billboard
		billboard.Parent = part
		monsters[npc] = { highlight = hl, label = billboard }
	end
end

local function addPlayerESP(plr, char)
	if plr == game.Players.LocalPlayer then
		return
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local hl = Instance.new("Highlight")
	hl.Adornee = root
	hl.FillColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.5
	hl.OutlineColor = Color3.fromRGB(0, 0, 0)
	hl.OutlineTransparency = 0
	hl.Enabled = false
	hl.Parent = root
	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = root
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Enabled = false
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = plr.Name
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 14
	textLabel.Parent = billboard
	billboard.Parent = root
	players[plr] = { highlight = hl, label = billboard }
end

local function setupPlayer(plr)
	if plr == game.Players.LocalPlayer then
		return
	end
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart")
		task.wait(0.1)
		addPlayerESP(plr, char)
		updateESP()
	end)
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		addPlayerESP(plr, plr.Character)
	end
end

for _, plr in ipairs(game.Players:GetPlayers()) do
	setupPlayer(plr)
end

game.Players.PlayerAdded:Connect(setupPlayer)
game.Players.PlayerRemoving:Connect(function(plr)
	if players[plr] then
		players[plr].highlight:Destroy()
		players[plr].label:Destroy()
		players[plr] = nil
	end
end)

local espEnabled, chamsEnabled, namesEnabled = false, false, false
local walkSpeed, walkSpeedEnabled = 16, false
local xrayEnabled, noclipEnabled = false, false
local selectedESPOptions = { "Door" }

function updateESP()
	local function enabledFor(opt)
		return table.find(selectedESPOptions, opt)
	end
	for _, part in ipairs(doors) do
		highlights[part].Enabled = espEnabled and chamsEnabled and enabledFor("Door") or false
		labels[part].Enabled = espEnabled and namesEnabled and enabledFor("Door") or false
	end
	for npc, data in pairs(monsters) do
		data.highlight.Enabled = espEnabled and chamsEnabled and enabledFor("Monster") or false
		data.label.Enabled = espEnabled and namesEnabled and enabledFor("Monster") or false
	end
	for plr, data in pairs(players) do
		data.highlight.Enabled = espEnabled and chamsEnabled and enabledFor("Player") or false
		data.label.Enabled = espEnabled and namesEnabled and enabledFor("Player") or false
	end
end

local function toggleNoclip(state)
	noclipEnabled = state
end

local function updateWalkSpeed()
	local character = game.Players.LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = walkSpeedEnabled and walkSpeed or 16
		end
	end
end
local textLabel = workspace["ROT13 Panel"].Panel:WaitForChild("SurfaceGui"):WaitForChild("TextLabel")
local function rot13(str)
	return (
		str:gsub("%a", function(c)
			local offset = (c:lower() < "n") and 13 or -13
			local base = c:lower() < "a" and 65 or 97
			return string.char(((c:byte() - base + offset) % 26) + base)
		end)
	)
end
local mainTab = Window:CreateTab("Main", "eye")
mainTab:CreateDropdown({
	Name = "ESP Options",
	Options = { "Door", "Monster", "Player" },
	CurrentOption = selectedESPOptions,
	MultipleOptions = true,
	Flag = "esp_option_picker",
	Callback = function(options)
		selectedESPOptions = options
		updateESP()
	end,
})
mainTab:CreateToggle({
	Name = "Enable ESP",
	CurrentValue = false,
	Flag = "esp_enabled",
	Callback = function(Value)
		espEnabled = Value
		updateESP()
	end,
})
mainTab:CreateToggle({
	Name = "Chams ESP",
	CurrentValue = false,
	Flag = "chams_esp",
	Callback = function(Value)
		chamsEnabled = Value
		updateESP()
	end,
})
mainTab:CreateToggle({
	Name = "Name ESP",
	CurrentValue = false,
	Flag = "name_esp",
	Callback = function(Value)
		namesEnabled = Value
		updateESP()
	end,
})
local Section2 = mainTab:CreateSection("Code Stuff")

local Label1 = mainTab:CreateLabel("Final Door Code:", 0)
local hexLabel = mainTab:CreateLabel("Searching...", 0, Color3.fromRGB(255, 255, 255), true)
local decodedBox = mainTab:CreateParagraph({ Title = "ROT13", Content = "Waiting..." })

local finale = workspace:WaitForChild("Finale")
local panel = finale:WaitForChild("Panel")
local surfaceGui = panel:WaitForChild("SurfaceGui")
local frame = surfaceGui:WaitForChild("Frame")
local function updateHexLabel(hexText)
	local tokens = {}
	for token in hexText:gmatch("%S+") do
		table.insert(tokens, token)
	end
	local decoded = {}
	for _, t in ipairs(tokens) do
		local s = tostring(t):lower():gsub("[^0-9a-f]", "")
		if #s == 1 then
			s = "0" .. s
		end
		local n = tonumber(s, 16)
		if n and n >= 32 and n <= 126 then
			table.insert(decoded, string.char(n))
		else
			table.insert(decoded, "?")
		end
	end
	hexLabel:Set(table.concat(decoded))
end
local hexObj = frame:FindFirstChild("Hexadecimals")
if hexObj then
	updateHexLabel(hexObj.Text)
end
frame.ChildAdded:Connect(function(child)
	if child.Name == "Hexadecimals" then
		updateHexLabel(child.Text)
	end
end)

local trollTab = Window:CreateTab("Troll", "zap")
local walkSpeedToggle = trollTab:CreateToggle({
	Name = "WalkSpeed Changer",
	CurrentValue = false,
	Flag = "walkspeed_toggle",
	Callback = function(Value)
		walkSpeedEnabled = Value
		updateWalkSpeed()
	end,
})
trollTab:CreateSlider({
	Name = "WalkSpeed",
	Range = { 16, 200 },
	Increment = 1,
	Suffix = "Studs",
	CurrentValue = 16,
	Flag = "walkspeed_slider",
	Callback = function(Value)
		walkSpeed = Value
		updateWalkSpeed()
	end,
})
trollTab:CreateKeybind({
	Name = "WalkSpeed Keybind",
	CurrentKeybind = "M",
	HoldToInteract = false,
	Flag = "walkspeed_keybind",
	Callback = function()
		walkSpeedEnabled = not walkSpeedEnabled
		walkSpeedToggle:Set(walkSpeedEnabled)
		updateWalkSpeed()
	end,
})
trollTab:CreateToggle({
	Name = "X-Ray",
	CurrentValue = false,
	Flag = "xray_toggle",
	Callback = function(Value)
		xrayEnabled = Value
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players) then
				obj.LocalTransparencyModifier = Value and 0.5 or 0
			end
		end
	end,
})
trollTab:CreateKeybind({
	Name = "X-Ray Keybind",
	CurrentKeybind = "X",
	HoldToInteract = false,
	Flag = "xray_keybind",
	Callback = function()
		xrayEnabled = not xrayEnabled
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players) then
				obj.LocalTransparencyModifier = xrayEnabled and 0.5 or 0
			end
		end
	end,
})

game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled then
		local character = game.Players.LocalPlayer.Character
		if character then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z)
			end
		end
	end
end)

local noclipToggle = trollTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "noclip_toggle",
	Callback = function(Value)
		toggleNoclip(Value)
	end,
})
trollTab:CreateKeybind({
	Name = "Noclip Keybind",
	CurrentKeybind = "N",
	HoldToInteract = false,
	Flag = "noclip_keybind",
	Callback = function()
		toggleNoclip(not noclipEnabled)
		noclipToggle:Set(noclipEnabled)
	end,
})

local setsTab = Window:CreateTab("Settings", "settings")
setsTab:CreateColorPicker({
	Name = "Chams Color",
	Color = Color3.fromRGB(255, 255, 255),
	Flag = "color_picker_chams",
	Callback = function(Value)
		for _, hl in pairs(highlights) do
			hl.FillColor = Value
			hl.Enabled = hl.Enabled
		end
		for _, data in pairs(monsters) do
			data.highlight.FillColor = Value
			data.highlight.Enabled = data.highlight.Enabled
		end
		for _, data in pairs(players) do
			data.highlight.FillColor = Value
			data.highlight.Enabled = data.highlight.Enabled
		end
	end,
})
setsTab:CreateColorPicker({
	Name = "Name Color",
	Color = Color3.fromRGB(255, 255, 255),
	Flag = "color_picker_name",
	Callback = function(Value)
		for _, lbl in pairs(labels) do
			lbl.TextLabel.TextColor3 = Value
		end
		for _, data in pairs(monsters) do
			data.label.TextLabel.TextColor3 = Value
		end
		for _, data in pairs(players) do
			data.label.TextLabel.TextColor3 = Value
		end
	end,
})
setsTab:CreateToggle({
	Name = "Fullbright",
	CurrentValue = false,
	Flag = "fullbright_toggle",
	Callback = function(Value)
		local lighting = game:GetService("Lighting")
		if Value then
			lighting.Brightness = 2
			lighting.ClockTime = 14
			lighting.FogEnd = 100000
			lighting.GlobalShadows = false
		else
			lighting.Brightness = 1
			lighting.ClockTime = 12
			lighting.FogEnd = 1000
			lighting.GlobalShadows = true
		end
	end,
})

local function update()
	local encoded = textLabel.Text
	local decoded = rot13(encoded)
	decodedBox:Set({ Title = "ROT13 Code:", Content = decoded })
end

textLabel:GetPropertyChangedSignal("Text"):Connect(update)
update()
Rayfield:LoadConfiguration()
