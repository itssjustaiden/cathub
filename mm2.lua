local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local plr = game:GetService("Players")
local lp = plr and plr.LocalPlayer
local hs = game:GetService("HttpService")
local sheriff = nil
local murderer = nil
local mapNames = {
	"Bank2",
	"BioLab",
	"Factory",
	"Hospital3",
	"Hotel",
	"House2",
	"Mansion2",
	"MilBase",
	"Office3",
	"PoliceStation",
	"ResearchFacility",
	"Workplace",
	"BeachResort",
	"Yacht",
	"Manor",
	"Farmhouse",
	"Mineshaft",
	"BarnInfection",
	"VampiresCastle",
	"Workshop",
	"LogCabin",
	"TrainStation",
	"IceCastle",
	"SkiLodge",
	"ChristmasInItaly",
}
setclipboard("https://discord.gg/VrgNpdeHa3")
local colors = {
	Survivor = Color3.fromRGB(0, 255, 0),
	Sheriff = Color3.fromRGB(0, 0, 255),
	Murderer = Color3.fromRGB(255, 0, 0),
	GunDrop = Color3.fromRGB(255, 255, 0),
}
local espToggles = {
	SurvivorESP = false,
	SheriffESP = false,
	MurdererESP = false,
	GunDropESP = false,
}
local walkspeedEnabled = false
local walkspeedValue = 16
local camlockEnabled = false
local selectedWeapon = "Gun"


local function tptoGun()
	if not lp or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
		return
	end
	local hrp = lp.Character.HumanoidRootPart
	local originalPos = hrp.Position
	for _, map in pairs(mapNames) do
		local mapFolder = workspace and workspace:FindFirstChild(map)
		if mapFolder and mapFolder:FindFirstChild("GunDrop") then
			hrp.CFrame = mapFolder.GunDrop.CFrame
			wait(0.1)
			hrp.CFrame = CFrame.new(originalPos)
			return
		end
	end
end

local function getPlayerRole(player)
	if not player then
		return "Survivor"
	end
	if player == murderer then
		return "Murderer"
	elseif player == sheriff then
		return "Sheriff"
	end
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		if backpack:FindFirstChild("Knife") then
			murderer = player
			return "Murderer"
		elseif backpack:FindFirstChild("Gun") then
			sheriff = player
			return "Sheriff"
		end
	end
	return "Survivor"
end
local function createCham(character, role)
	if not character or not character:FindFirstChild("HumanoidRootPart") or not colors[role] then
		return
	end
	local toggle = false
	if role == "Survivor" then
		toggle = espToggles.SurvivorESP
	elseif role == "Sheriff" then
		toggle = espToggles.SheriffESP
	elseif role == "Murderer" then
		toggle = espToggles.MurdererESP
	elseif role == "GunDrop" then
		toggle = espToggles.GunDropESP
	end
	local existing = character:FindFirstChild("ESP")
	if toggle then
		if not existing then
			local cham = Instance.new("Highlight")
			cham.Name = "ESP"
			cham.Adornee = character
			cham.DepthMode = Enum.HighlightDepthMode and Enum.HighlightDepthMode.AlwaysOnTop
			cham.FillTransparency = 0.5
			cham.OutlineTransparency = 0.5
			cham.FillColor = colors[role]
			cham.OutlineColor = colors[role]
			cham.Parent = character
		else
			existing.FillColor = colors[role]
			existing.OutlineColor = colors[role]
		end
	else
		if existing then
			existing:Destroy()
		end
	end
end

local function createGunCham(gunDrop)
	if not gunDrop or not espToggles.GunDropESP then
		return
	end
	local existing = gunDrop:FindFirstChild("ESP")
	if espToggles.GunDropESP then
		if not existing then
			local cham = Instance.new("Highlight")
			cham.Name = "ESP"
			cham.Adornee = gunDrop
			cham.DepthMode = Enum.HighlightDepthMode and Enum.HighlightDepthMode.AlwaysOnTop
			cham.FillColor = colors.GunDrop
			cham.OutlineColor = colors.GunDrop
			cham.FillTransparency = 0.5
			cham.OutlineTransparency = 0.5
			cham.Parent = gunDrop
		end
	else
		if existing then
			existing:Destroy()
		end
	end
end

local function onPlayerAdded(player)
	if not player then
		return
	end
	player.CharacterAdded:Connect(function(char)
		if not char then
			return
		end
		local role = getPlayerRole(player)
		if role == "Survivor" and espToggles.SurvivorESP then
			createCham(char, "Survivor")
		elseif role == "Sheriff" and espToggles.SheriffESP then
			createCham(char, "Sheriff")
		elseif role == "Murderer" and espToggles.MurdererESP then
			createCham(char, "Murderer")
		end
	end)
	if player.Character then
		local role = getPlayerRole(player)
		if role == "Survivor" and espToggles.SurvivorESP then
			createCham(player.Character, "Survivor")
		elseif role == "Sheriff" and espToggles.SheriffESP then
			createCham(player.Character, "Sheriff")
		elseif role == "Murderer" and espToggles.MurdererESP then
			createCham(player.Character, "Murderer")
		end
	end
end

if plr then
	for _, player in pairs(plr:GetPlayers()) do
		onPlayerAdded(player)
	end
	plr.PlayerAdded:Connect(onPlayerAdded)
end

local function anyToggleOn()
	return espToggles.SurvivorESP or espToggles.SheriffESP or espToggles.MurdererESP or espToggles.GunDropESP
end

local function updateESP()
	if not plr then
		return
	end
	for _, player in pairs(plr:GetPlayers()) do
		if player and player.Character then
			local role = getPlayerRole(player)
			if role == "Survivor" and espToggles.SurvivorESP then
				createCham(player.Character, "Survivor")
			elseif role == "Sheriff" and espToggles.SheriffESP then
				createCham(player.Character, "Sheriff")
			elseif role == "Murderer" and espToggles.MurdererESP then
				createCham(player.Character, "Murderer")
			else
				local existing = player.Character:FindFirstChild("ESP")
				if existing then
					existing:Destroy()
				end
			end
		end
	end
	for _, map in pairs(mapNames) do
		local gunDrop = workspace and workspace:FindFirstChild(map)
		if gunDrop and gunDrop:FindFirstChild("GunDrop") then
			createGunCham(gunDrop.GunDrop)
		end
	end
end

spawn(function()
	while true do
		if anyToggleOn() then
			pcall(updateESP)
		end
		wait(2)
	end
end)

local Window = Rayfield:CreateWindow({
	Name = "Miawder Mystery 2",
	Icon = 0,
	LoadingTitle = "cats",
	LoadingSubtitle = "Herobrine is behind you.",
	ShowText = "",
	Theme = "Default",
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = true,
	DisableBuildWarnings = true,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "cathub",
		FileName = "miawdermystery2",
	},
	KeySystem = true,
	KeySettings = {
		Title = "Myawder Mystery 2",
		Subtitle = "meows",
		Note = "Go to our discord to get key. Link has been copied to the clipboard!",
		FileName = "mm2cathubkey",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = { "121284264304750" },
	},
})

local mainTab = Window:CreateTab("Main", "home")
mainTab:CreateToggle({
	Name = "Survivor Chams",
	CurrentValue = false,
	Flag = "survivor_esp",
	Callback = function(Value)
		espToggles.SurvivorESP = Value
	end,
})
mainTab:CreateToggle({
	Name = "Sheriff Chams",
	CurrentValue = false,
	Flag = "sheriff_esp",
	Callback = function(Value)
		espToggles.SheriffESP = Value
	end,
})
mainTab:CreateToggle({
	Name = "Murderer Chams",
	CurrentValue = false,
	Flag = "murderer_esp",
	Callback = function(Value)
		espToggles.MurdererESP = Value
	end,
})
mainTab:CreateToggle({
	Name = "Gun Drop Chams",
	CurrentValue = false,
	Flag = "gun_drop_chams",
	Callback = function(Value)
		espToggles.GunDropESP = Value
	end,
})
local lpTab = Window:CreateTab("Player", "user")
lpTab:CreateToggle({
	Name = "Walkspeed",
	CurrentValue = false,
	Flag = "walkspeed_toggle",
	Callback = function(Value)
		walkspeedEnabled = Value
		if not walkspeedEnabled and lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
			lp.Character.Humanoid.WalkSpeed = 16
		end
	end,
})
lpTab:CreateSlider({
	Name = "Walkspeed",
	Range = { 1, 100 },
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Flag = "walkspeed_slider",
	Callback = function(Value)
		walkspeedValue = Value
		if walkspeedEnabled and lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
			lp.Character.Humanoid.WalkSpeed = walkspeedValue
		end
	end,
})
spawn(function()
	while true do
		if walkspeedEnabled and lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
			pcall(function()
				lp.Character.Humanoid.WalkSpeed = walkspeedValue
			end)
		end
		wait(0.5)
	end
end)
local rageTab = Window:CreateTab("Rage", "skull")
rageTab:CreateToggle({
	Name = "Aimbot (camlock)",
	CurrentValue = false,
	Flag = "camlock_toggle",
	Callback = function(Value)
		camlockEnabled = Value
	end,
})
rageTab:CreateButton({
	Name = "TP to gun",
	Callback = function()
		tptoGun()
	end,
})
rageTab:CreateButton({
	Name = "TP to Lobby",
	Callback = function()
		if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lp.Character.HumanoidRootPart.CFrame = CFrame.new(114, 156, 60)
		end
	end,
})

local setsTab = Window:CreateTab("Settings", "settings")
setsTab:CreateDropdown({
	Name = "Weapon for aimbot",
	Options = { "Gun" },
	CurrentOption = { "Gun" },
	Flag = "weapon_dropdown",
	Callback = function(option)
		selectedWeapon = option[1]
	end,
})
spawn(function()
	while true do
		if
			camlockEnabled
			and selectedWeapon == "Gun"
			and lp
			and lp.Character
			and lp.Character:FindFirstChild("HumanoidRootPart")
		then
			local tool = lp.Character:FindFirstChildOfClass("Tool")
			if
				tool
				and tool.Name == "Gun"
				and murderer
				and murderer.Character
				and murderer.Character:FindFirstChild("HumanoidRootPart")
			then
				pcall(function()
					local hrp = murderer.Character.HumanoidRootPart
					workspace.CurrentCamera.CFrame =
						CFrame.new(workspace.CurrentCamera.CFrame.Position, hrp.Position + Vector3.new(0, 1, 0))
				end)
			end
		end
		wait(0.01)
	end
end)

setsTab:CreateButton({
	Name = "Rejoin",
	Callback = function()
		local teleportService = game:GetService("TeleportService")
		if teleportService and lp then
			teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
		end
	end,
})

Rayfield:LoadConfiguration()
