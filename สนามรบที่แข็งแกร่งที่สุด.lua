--=========================================
-- 1220Hub | By.128Bit / น้อวเติ้ลคุคิ
-- แจกต่อให้เครดิตด้วยฮับ
--=========================================
local WindUI = loadstring(game:HttpGet(
"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local function getHRP(p)
    return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
    return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
end
local function isAlive(p)
    local h = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function getNearest()
    local best, dist = nil, math.huge
    local my = getHRP(LP)
    if not my then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and isAlive(p) then
            local hrp = getHRP(p)
            if hrp then
                local d = (hrp.Position - my.Position).Magnitude
                if d < dist then
                    dist = d
                    best = p
                end
            end
        end
    end
    return best
end
local VALID_KEYS = {
    "1220Hub-FREE"
}

local KEY_FILE = "nexzus1220.json"
local DISCORD_LINK = "https://discord.gg/U2Pfvc9JaZ"
local KEY_DURATION = 24 * 60 * 60
local function IsValidKey(input)
    for _, key in ipairs(VALID_KEYS) do
        if input == key then
            return true
        end
    end
    return false    
end
local function HasSavedKey()
    if not isfile(KEY_FILE) then return false end
    
    local data = readfile(KEY_FILE)
    local saved = game:GetService("HttpService"):JSONDecode(data)

    if not saved.key or not saved.time then
        return false
    end

    if os.time() - saved.time > KEY_DURATION then
        delfile(KEY_FILE)
        return false
    end

    return IsValidKey(saved.key)
end
local function SaveKey(key)
    local data = {
        key = key,
        time = os.time()
    }
    writefile(KEY_FILE, game:GetService("HttpService"):JSONEncode(data))
end
WindUI.Services.multikey = {
    Name = "Copy Discord",
    Icon = "key",
    Args = {},
    New = function()
        return {
            Verify = function(inputKey)
    if HasSavedKey() then
        return true, "ใจเย็นอ้วงคีย์ใช้ได้อยู่"
    end
    if IsValidKey(inputKey) then
        SaveKey(inputKey)
        return true, "พร้อมลั่นแล้วอ้วง"
    end

    return false, "ใส่คีย์ไม่ถูกค้าบอ้วง"
end,
            Copy = function()
                setclipboard(DISCORD_LINK)
            end
        }
    end
}
local Window = WindUI:CreateWindow({
    Title = "สนามรบที่แข็งแกร่งที่สุด",
    Icon = "https://img2.pic.in.th/orca-image--1265220924.jpeg.png",
    Author = "By.128Bit/น้อวเติ้ลคุคิ",
    Theme = "Dark",
    Transparent = true,
    Blur = true,
    KeySystem = {
        Note = "ไปรับคีย์ได้ที่ดิสคอร์ด 1220",
        API = {
            {
                Type = "multikey"
            }
        }
    }
})
local bg = Instance.new("ImageLabel")
bg.Name = "CustomBG"
bg.Parent = Window.Container
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.5
bg.ScaleType = Enum.ScaleType.Crop
bg.ZIndex = -1
Window:EditOpenButton({
    Title = "Nexzus1220 Hub",
    Icon = "https://img2.pic.in.th/orca-image--1265220924.jpeg.png",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("8A2BE2"),
        Color3.fromHex("9370DB")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})
Window:Tag({
    Title = "VIP",
    Icon = "crown",
    Color = Color3.fromRGB(168,85,247),
   })
local TabMain = Window:Tab({ Title = "Main", Icon = "target" })
local TabPlayer = Window:Tab({ Title = "Players", Icon = "user" })
local TabSetting = Window:Tab({ Title = "Setting", Icon = "settings" })
TabMain:Select()
local Enabled = false
local Offset = 5
local SelectedTarget = nil

local function getHRP(plr)
    if plr and plr.Character then
        return plr.Character:FindFirstChild("HumanoidRootPart")
    end
end

-- วาร์ปไปด้านหลัง
local function backTurn(target)
    local my = getHRP(LP)
    local hrp = getHRP(target)
    if not my or not hrp then return end

    local back = hrp.CFrame * CFrame.new(0, 0, Offset)

    my.CFrame = CFrame.lookAt(
        back.Position,
        hrp.Position
    )
end

-- รายชื่อผู้เล่น
local function getPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(list, plr.Name)
        end
    end
    return list
end

-- หา player
local function getPlayerByName(name)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name == name then
            return plr
        end
    end
end

-- LOOP
RunService.Stepped:Connect(function()
    if not Enabled then return end

    local target

    if SelectedTarget then
        target = getPlayerByName(SelectedTarget)
    else
        target = getNearest()
    end

    if target then
        backTurn(target)
    end
end)
-- ================= ESP SYSTEM =================
local ESPEnabled = false
local NameESPEnabled = false

local ESP_Objects = {}
local NameESP_Objects = {}

-- ===== ESP Highlight =====
local function createESP(plr)
    if plr == LP then return end
    if ESP_Objects[plr] then return end

    local function apply(char)
        if not char then return end

        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char

        ESP_Objects[plr] = highlight
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(function(char)
        if ESPEnabled then
            task.wait(0.5)
            apply(char)
        end
    end)
end

local function removeESP(plr)
    if ESP_Objects[plr] then
        ESP_Objects[plr]:Destroy()
        ESP_Objects[plr] = nil
    end
end

-- ===== Rainbow Color Loop =====
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end

    local hue = (tick() % 5) / 5
    local color = Color3.fromHSV(hue, 1, 1)

    for _,esp in pairs(ESP_Objects) do
        if esp then
            esp.FillColor = color
            esp.OutlineColor = color
        end
    end
end)

-- ===== Name ESP =====
local function createNameESP(plr)
    if plr == LP then return end
    if NameESP_Objects[plr] then return end

    local function apply(char)
        local head = char:FindFirstChild("Head")
        if not head then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 100, 0, 18)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1,0,1,0)
        text.BackgroundTransparency = 1
        text.TextSize = 12
        text.Font = Enum.Font.GothamBold
        text.TextColor3 = Color3.fromRGB(255,255,255)
        text.TextStrokeTransparency = 0.5
        text.Text = plr.DisplayName.." (@"..plr.Name..")"

        text.Parent = billboard
        billboard.Parent = head

        NameESP_Objects[plr] = billboard
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(function(char)
        if NameESPEnabled then
            task.wait(0.5)
            apply(char)
        end
    end)
end

local function removeNameESP(plr)
    if NameESP_Objects[plr] then
        NameESP_Objects[plr]:Destroy()
        NameESP_Objects[plr] = nil
    end
end

-- ===== Player Join/Leave =====
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if ESPEnabled then createESP(plr) end
        if NameESPEnabled then createNameESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
    removeNameESP(plr)
end)
-- ================= AUTO BLOCK SYSTEM =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer

local AutoBlock = false
local BlockDelay = 0.15

-- ===== SETTINGS =====
local normalRange, specialRange, skillRange = 30, 50, 50
local skillDelay = 1.2

local m1AfterEnabled = false
local m1CatchEnabled = false

-- ===== ANIMATION DATA =====
local comboIDs = {10480793962, 10480796021}

local allIDs = {
	Saitama = {10469493270,10469630950,10469639222,10469643643, special = 10479335397},
	Garou = {13532562418,13532600125,13532604085,13294471966, special = 10479335397},
	Cyborg = {13491635433,13296577783,13295919399,13295936866, special = 10479335397},
	Sonic = {13370310513,13390230973,13378751717,13378708199, special = 13380255751},
	Metal = {14004222985,13997092940,14001963401,14136436157, special = 13380255751},
	Blade = {15259161390,15240216931,15240176873,15162694192, special = 13380255751},
	Tatsumaki = {16515503507,16515520431,16515448089,16552234590, special = 10479335397},
	Dragon = {17889458563,17889461810,17889471098,17889290569, special = 10479335397},
	Tech = {123005629431309,100059874351664,104895379416342,134775406437626, special = 10479335397}
}

local skillIDs = {
	[10468665991]=true,[10466974800]=true,[10471336737]=true,[12510170988]=true,
	[12272894215]=true,[12296882427]=true,[12307656616]=true
}

-- ===== REMOTE =====
local function fireRemote(goal, mobile)
	local args = {{
		Goal = goal,
		Key = (goal == "KeyPress" or goal == "KeyRelease") and Enum.KeyCode.F or nil,
		Mobile = mobile or nil
	}}
	LP.Character:WaitForChild("Communicate"):FireServer(unpack(args))
end

-- ===== AFTER BLOCK =====
local function doAfterBlock(hrp)
	if not m1AfterEnabled then return end

	local my = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not my or not hrp then return end

	if (hrp.Position - my.Position).Magnitude <= 10 then
		fireRemote("LeftClick", true)
		task.delay(0.3, function()
			fireRemote("LeftClickRelease", true)
		end)
	end
end

-- ===== CHECK ANIMATION =====
local function checkAnims()
	for _,player in ipairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then

			local char = player.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

			if hrp and hum and myHRP then
				local dist = (hrp.Position - myHRP.Position).Magnitude
				local animator = hum:FindFirstChildOfClass("Animator")

				if animator then
					local anims = {}

					for _,track in ipairs(animator:GetPlayingAnimationTracks()) do
						local id = tonumber(track.Animation.AnimationId:match("%d+"))
						if id then anims[id] = true end
					end

					-- combo
					local comboCount = 0
					for _,id in ipairs(comboIDs) do
						if anims[id] then comboCount += 1 end
					end

					for _,group in pairs(allIDs) do
						local hits = 0
						for i = 1,4 do
							if anims[group[i]] then hits += 1 end
						end

						local special = anims[group.special]

						if comboCount == 2 and hits >= 2 and dist <= specialRange then
							fireRemote("KeyPress")
							task.wait(BlockDelay)
							fireRemote("KeyRelease")
							return

						elseif hits > 0 and dist <= normalRange then
							fireRemote("KeyPress")
							task.wait(BlockDelay)
							fireRemote("KeyRelease")
							doAfterBlock(hrp)
							return

						elseif special and dist <= specialRange then
							fireRemote("KeyPress")
							task.delay(1, function()
								fireRemote("KeyRelease")
							end)
							return
						end
					end

					-- skill
					for id in pairs(anims) do
						if skillIDs[id] and dist <= skillRange then
							fireRemote("KeyPress")
							task.delay(skillDelay, function()
								fireRemote("KeyRelease")
							end)
							return
						end
					end
				end
			end
		end
	end
end

-- ===== LOOP =====
RunService.Heartbeat:Connect(function()
	if AutoBlock then
		pcall(checkAnims)
	end
end)
-- ================= NO DASH COOLDOWN =================
local NoDash = false

-- loop กันเกมปิดค่า
task.spawn(function()
    while true do
        if NoDash then
            workspace:SetAttribute("NoDashCooldown", true)
        end
        task.wait(1)
    end
end)
-- ================= UI =================
TabMain:Section({
    Title = "Combat"
})

TabMain:Toggle({
    Title = "Auto Block"",
    Desc = "บล็อคอัตโนมัติ",
    Callback = function(v)
        AutoBlock = v
    end
})
TabMain:Toggle({
    Title = "Dash No Cooldown",
    Desc = "แดชได้ไม่จำกัด",
    Callback = function(v)
        NoDash = v

        -- ปิดแล้วคืนค่า
        if not v then
            workspace:SetAttribute("NoDashCooldown", false)
        end
    end
})
TabMain:Section({
    Title = "Back Aim อยู่ข้างหลังผู้เล่น"
})
local PlayerDropdown = TabMain:Dropdown({
    Title = "Select Player",
    Desc = "เลือกเป้าหมาย",
    Values = getPlayerList(),
    Callback = function(v)
        SelectedTarget = v
    end
})
TabMain:Toggle({
    Title = "Back Aim",
    Desc = "วาปไปข้างหลัง",
    Callback = function(v)
        Enabled = v
    end
})
TabMain:Input({
    Title = "Back Offset",
    Desc = "ปรับระยะห่าง",
    Numeric = true,
    Placeholder = "2",
    Callback = function(v)
        Offset = tonumber(v) or 2.9
    end
})
TabMain:Button({
    Title = "Refresh Player",
    Desc = "รีเฟรชรายชื่อผู้เล่น",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerList())
        if not getPlayerByName(SelectedTarget) then
            SelectedTarget = nil
        end

        TabMain:Notify({
            Title = "Updated",
            Desc = "รีเฟรชแล้วไอ้อ้วง",
            Time = 2
        })
    end
})
Players.PlayerAdded:Connect(function()
    PlayerDropdown:Refresh(getPlayerList())
end)

Players.PlayerRemoving:Connect(function()
    PlayerDropdown:Refresh(getPlayerList())

    if not getPlayerByName(SelectedTarget) then
        SelectedTarget = nil
    end
end)
TabMain:Section({
    Title = "ESP มองผู้เล่น"
})

TabMain:Toggle({
    Title = "ESP",
    Desc = "มองตัวผู้เล่น",
    Callback = function(v)
        ESPEnabled = v

        for _,plr in ipairs(Players:GetPlayers()) do
            if v then
                createESP(plr)
            else
                removeESP(plr)
            end
        end
    end
})

TabMain:Toggle({
    Title = "ESP NAME",
    Desc = "มองชื่อเล่น",
    Callback = function(v)
        NameESPEnabled = v

        for _,plr in ipairs(Players:GetPlayers()) do
            if v then
                createNameESP(plr)
            else
                removeNameESP(plr)
            end
        end
    end
})
local SpeedEnabled = false
local SpeedValue = 16
TabPlayer:Toggle({
   Title = "Speed Boost",
   Desc = "วิ่งเร็ว",
   Callback = function(v)
     SpeedEnabled = v
     local h = getHumanoid()
     if h then
        h.WalkSpeed = v and SpeedValue or 16
     end
   end
})
TabPlayer:Input({
   Title = "Speed Value",
   Desc = "ปรับความเร็ว",
   Numeric = true,
   Placeholder = "16 - 999",
   Callback = function(v)
      local n = math.clamp(tonumber(v) or 16, 16, 999)
      SpeedValue = n
      local h = getHumanoid()
      if SpeedEnabled and h then
          h.WalkSpeed = n
      end
   end
})
local infJump = false
TabPlayer:Toggle({
  Title = "Infinite Jump",
  Desc = "กระโดดไม่จำกัด",
  Callback = function(v)
    infJump = v
  end
})
UserInputService.JumpRequest:Connect(function()
    if infJump then
        local h = getHumanoid()
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local PlaceId = game.PlaceId
local JobId = game.JobId
TabSetting:Button({
    Title = "Anti AFK",
    Callback = function()
        LP.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
})
local function ServerHop_EmptyOnly()
    local cursor = ""
    for _ = 1, 10 do
        local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end
        local ok, res = pcall(function()
            return game:HttpGet(url)
        end)
        if not ok then break end
        local data = HttpService:JSONDecode(res)
        for _,server in ipairs(data.data) do
            if server.playing == 0 and server.id ~= JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LP)
                return
            end
        end
        cursor = data.nextPageCursor
        if not cursor then break end
        task.wait(0.2)
    end
    TeleportService:Teleport(PlaceId, LP)
end
TabSetting:Button({
    Title = "Server Hop",
    Desc  = "หาเซิฟเวอร์ว่าง",
    Callback = function()
        ServerHop_EmptyOnly()
    end
})
TabSetting:Button({
    Title = "Rejoin",
    Desc = "ออกเข้าใหม่",
    Callback = function()
        TeleportService:Teleport(PlaceId, LP)
    end
})
WindUI:Notify({
    Title = "Nexzus1220 Hub",
    Content = "คำเตือน | สคริปต์ทุกตัวมีสิทธ์โดนแบนกรุณาใช้อย่างระมัดระวัง",
    Duration = 5,
    Icon = "box",
})
