local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

repeat task.wait() until Players.LocalPlayer

local player = Players.LocalPlayer
local success, result = pcall(function()
    return player:GetMouse()
end)

local mouse = success and result or nil

-- ============================================================
--  FLUENT UI (dawid-scripts)
-- ============================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "AstaRoth",
    SubTitle = "Attack on Titan: Revolution",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local TrayIcon = {}
TrayIcon.isVisible = true
TrayIcon.connection = nil

function TrayIcon:CreateIcon()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TrayIconGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "TrayIcon"
    iconFrame.Size = UDim2.new(0, 50, 0, 50)
    iconFrame.Position = UDim2.new(1, -60, 0, 10)
    iconFrame.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = iconFrame

    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.Position = UDim2.new(0, 0, 0, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "A"
    iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconText.TextScaled = true
    iconText.Font = Enum.Font.GothamBold
    iconText.Parent = iconFrame

    local hoverTween = nil
    iconFrame.MouseEnter:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(iconFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 55, 0, 55), BackgroundColor3 = Color3.fromRGB(16, 110, 190)}
        )
        hoverTween:Play()
    end)

    iconFrame.MouseLeave:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(iconFrame,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 50, 0, 50), BackgroundColor3 = Color3.fromRGB(0, 120, 212)}
        )
        hoverTween:Play()
    end)

    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.Position = UDim2.new(0, 0, 0, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = iconFrame

    clickDetector.MouseButton1Click:Connect(function()
        self:ToggleUI()
        local clickTween = TweenService:Create(iconFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0, 45, 0, 45)}
        )
        clickTween:Play()
        clickTween.Completed:Connect(function()
            local returnTween = TweenService:Create(iconFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0, 50, 0, 50)}
            )
            returnTween:Play()
        end)
    end)

    self.gui = screenGui
    self.frame = iconFrame
    self.text = iconText
    self:CreateTooltip()
end

function TrayIcon:CreateTooltip()
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 30)
    tooltip.Position = UDim2.new(1, -210, 0.5, -15)
    tooltip.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.Parent = self.frame

    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 5)
    tooltipCorner.Parent = tooltip

    local tooltipText = Instance.new("TextLabel")
    tooltipText.Size = UDim2.new(1, -10, 1, 0)
    tooltipText.Position = UDim2.new(0, 5, 0, 0)
    tooltipText.BackgroundTransparency = 1
    tooltipText.Text = "Click to toggle UI visibility"
    tooltipText.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltipText.TextScaled = true
    tooltipText.Font = Enum.Font.Gotham
    tooltipText.Parent = tooltip

    self.frame.MouseEnter:Connect(function() tooltip.Visible = true end)
    self.frame.MouseLeave:Connect(function() tooltip.Visible = false end)
end

function TrayIcon:ToggleUI()
    if self.isVisible then self:HideUI() else self:ShowUI() end
end

function TrayIcon:HideUI()
    if Window and Window.Root then
        Window.Root.Visible = false
        self.isVisible = false
        self.text.Text = "H"
        self.frame.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        Fluent:Notify({ Title = "UI Hidden", Content = "Click the tray icon to show UI again", Duration = 3 })
    end
end

function TrayIcon:ShowUI()
    if Window and Window.Root then
        Window.Root.Visible = true
        self.isVisible = true
        self.text.Text = "A"
        self.frame.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
        Fluent:Notify({ Title = "UI Shown", Content = "UI is now visible", Duration = 2 })
    end
end

TrayIcon:CreateIcon()

--//==============================\\--
--||         TABS SETUP           ||--
--\\==============================//--

local EarlyAccountTab = Window:AddTab({ Title = "Account", Icon = "" })

local Tabs = {
    Main          = Window:AddTab({ Title = "Main(Risky)",               Icon = "" }),
    AutoJoin      = Window:AddTab({ Title = "Auto Join",                 Icon = "" }),
    Servers       = Window:AddTab({ Title = "Servers",                   Icon = "" }),
    Misc          = Window:AddTab({ Title = "Misc",                      Icon = "" }),
    Esp           = Window:AddTab({ Title = "Titans Esp",                Icon = "" }),
    Settings      = Window:AddTab({ Title = "Settings",                  Icon = "" }),
}

--//==============================\\--
--||         SETTINGS TAB         ||--
--\\==============================//--

Tabs.Settings:AddToggle("TrayIconToggle", {
    Title = "Show Tray Icon",
    Description = "Show/Hide the system tray icon",
    Default = true,
    Callback = function(state)
        if TrayIcon.gui then TrayIcon.gui.Enabled = state end
    end
})

Tabs.Settings:AddParagraph({
    Title = "Tray Icon Usage",
    Content = "• The tray icon appears in the top-right corner\n• Click it to hide/show the UI\n• Red icon = UI hidden, Blue icon = UI visible\n• Ctrl+H (keyboard) or double-tap the screen (mobile) also toggles the UI"
})

--//==============================\\--
--||       MAINMENU (PlaceId)     ||--
--\\==============================//--

local allowedPlaceId = 13379208636
if game.PlaceId == allowedPlaceId then
    Tabs.Mainmenu = Window:AddTab({ Title = "Mainmenu", Icon = "" })
    Tabs.Mainmenu:AddToggle("AutoRollToggle", {
        Title = "Auto Roll",
        Default = false,
        Callback = function(state) ENABLED = state end
    })
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        TrayIcon:ToggleUI()
    end
end)

game.Players.PlayerRemoving:Connect(function(plr)
    if plr == player and TrayIcon.gui then TrayIcon.gui:Destroy() end
end)

--------------------------------------------------------------------------

local HttpService     = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInput    = game:GetService("VirtualInputManager")
local GuiService      = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")

local char = player.Character or player.CharacterAdded:Wait()
local hrp  = char:WaitForChild("HumanoidRootPart")

local retryRemote = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("GET")

local isFlying   = false
local bodyPos
local LocalPlayer = Players.LocalPlayer
local startDelay  = 0
local flyHeight   = 250

--//==============================\\--
--||      👑 AUTO KILL TITANS     ||--
--\\==============================//--

local Services = {
    Players         = game:GetService("Players"),
    RunService      = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService    = game:GetService("TweenService"),
    CoreGui         = game:GetService("CoreGui")
}

local Player = {
    self      = Services.Players.LocalPlayer,
    character = nil,
    hrp       = nil,
    gui       = nil
}

local Config = {
    flySpeed              = 250,
    canHit                = true,
    isFlying              = false,
    moveMode              = "Teleportation",
    notificationsEnabled  = true,
    startDelay            = 0,
    flyHeight             = 250,
    titanKillCount        = 0,
    autoRefill            = false,
    lastBladesEmpty       = false,
    lastSpearsEmpty       = false
}

local Data = {
    notified    = {},
    activeNotifs = {},
    POST        = nil,
    refill      = nil
}

Player.character = Player.self.Character or Player.self.CharacterAdded:Wait()
Player.hrp       = Player.character:WaitForChild("HumanoidRootPart")
Player.gui       = Player.self:WaitForChild("PlayerGui")

task.spawn(function()
    local success2, result2 = pcall(function()
        return Services.ReplicatedStorage:WaitForChild("Assets", 10):WaitForChild("Remotes", 10):WaitForChild("POST", 10)
    end)
    Data.POST = success2 and result2 or nil
end)

function showKillNotification(count)
    if not Config.notificationsEnabled then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "TN_" .. tick()
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = Services.CoreGui
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 190, 0, 75)
    frame.Position = UDim2.new(1, 20, 0, 10 + (#Data.activeNotifs * 80))
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(184, 164, 101)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "Successfully\nHit:"
    label.TextColor3 = Color3.fromRGB(184, 164, 101)
    label.Font = Enum.Font.Fantasy
    label.TextScaled = true
    local counter = Instance.new("TextLabel", frame)
    counter.Size = UDim2.new(0, 60, 0.5, 0)
    counter.Position = UDim2.new(1, -65, 0, 0)
    counter.BackgroundTransparency = 1
    counter.Text = tostring(count)
    counter.TextColor3 = Color3.fromRGB(255, 255, 255)
    counter.Font = Enum.Font.Fantasy
    counter.TextScaled = true
    table.insert(Data.activeNotifs, gui)
    Services.TweenService:Create(frame, TweenInfo.new(0.35), {
        Position = UDim2.new(1, -210, 0, 10 + ((#Data.activeNotifs - 1) * 80))
    }):Play()
    task.delay(5, function()
        gui:Destroy()
        for i, v in ipairs(Data.activeNotifs) do
            if v == gui then table.remove(Data.activeNotifs, i) break end
        end
    end)
end

local TITAN_PRIORITY = { "Attack_Titan", "Female_Titan", "Armored_Titan" }

local function napeOf(titan)
    local hb = titan:FindFirstChild("Hitboxes")
    local hit = hb and hb:FindFirstChild("Hit")
    return hit and hit:FindFirstChild("Nape")
end

local function isAlive(titan)
    local h = titan:FindFirstChildWhichIsA("Humanoid")
    return h and h.Health > 0
end

-- keep the character reference fresh after respawn (the old code kept a dead HRP)
Player.self.CharacterAdded:Connect(function(c)
    Player.character = c
    Player.hrp = c:WaitForChild("HumanoidRootPart")
end)

local targetList, lastScan = {}, 0

local function scanTargets()
    table.clear(targetList)
    local folder = workspace:FindFirstChild("Titans")
    if not folder or not Player.hrp then return end
    local pos = Player.hrp.Position
    for _, name in ipairs(TITAN_PRIORITY) do
        local t = folder:FindFirstChild(name)
        if t and isAlive(t) then
            local n = napeOf(t)
            if n then targetList[#targetList + 1] = n end
        end
    end
    local others = {}
    for _, t in ipairs(folder:GetChildren()) do
        if not table.find(TITAN_PRIORITY, t.Name) and isAlive(t) then
            local n = napeOf(t)
            if n then others[#others + 1] = { n, (pos - n.Position).Magnitude } end
        end
    end
    table.sort(others, function(a, b) return a[2] < b[2] end)
    for _, o in ipairs(others) do targetList[#targetList + 1] = o[1] end
end

-- target list is rebuilt at most 10x/second instead of every frame
function getClosestValidNape()
    local first = targetList[1]
    if os.clock() - lastScan > 0.1 or not first or not first.Parent then
        scanTargets()
        lastScan = os.clock()
    end
    return targetList[1]
end

Config.hitCooldown = 0.12   -- seconds between hit bursts (was 0.25)
Config.multiHit    = 8      -- napes hit per burst (was 3)

local killConnection
local killStartAt = 0

function killFromAbove()
    killStartAt = os.clock() + Config.startDelay
    if killConnection then return end -- one connection only (old code stacked a new one on every toggle)
    killConnection = Services.RunService.Heartbeat:Connect(function()
        if not Config.isFlying or os.clock() < killStartAt then return end
        local hrp = Player.hrp
        if not hrp or not hrp.Parent then return end
        local nape = getClosestValidNape()
        if not nape then return end
        local targetPos = nape.Position + Vector3.new(0, Config.flyHeight, 0)
        if Config.moveMode == "Gliding" then
            local delta = targetPos - hrp.Position
            if delta.Magnitude > 1 then hrp.AssemblyLinearVelocity = delta.Unit * Config.flySpeed end
        else
            hrp.CFrame = CFrame.new(targetPos)
        end
        if Config.canHit and (hrp.Position - nape.Position).Magnitude <= 1520 then
            Config.canHit = false
            task.spawn(function()
                local post = Data.POST
                local count = math.min(Config.multiHit, #targetList)
                for i = 1, count do
                    local n = targetList[i]
                    if n and n.Parent then
                        if post then
                            post:FireServer("Hitboxes", "Register", n, math.random(200, 300), math.random(20, 30) / 100)
                            post:FireServer("Attacks", "Slash", true)
                        end
                        local id = tostring(n:GetDebugId())
                        if not Data.notified[id] then
                            Data.notified[id] = true
                            Config.titanKillCount = Config.titanKillCount + 1
                            showKillNotification(Config.titanKillCount)
                        end
                    end
                end
                if Config.onKillBurst then task.spawn(Config.onKillBurst) end
                task.wait(Config.hitCooldown)
                Config.canHit = true
            end)
        end
    end)
end

--//==============================\\--
--||   👑 REFILL / RELOAD SYSTEM  ||--
--\\==============================//--

local BladeUI_S2       = nil
local Gradient_S2      = nil
local SetsLabel_S2     = nil
local autoBladeRunning = false

pcall(function()
    BladeUI_S2    = player.PlayerGui.Interface.HUD.Main.Top["7"].Blades
    Gradient_S2   = BladeUI_S2.Inner.Bar.Gradient
    SetsLabel_S2  = BladeUI_S2.Sets
end)

local function TweenTo_S2(cf, speed)
    local charRef = player.Character if not charRef then return end
    local hrpRef  = charRef:FindFirstChild("HumanoidRootPart")
    local humRef  = charRef:FindFirstChild("Humanoid")
    if not hrpRef or not humRef or humRef.Health <= 0 then return end
    local distance = (hrpRef.Position - cf.Position).Magnitude
    local t        = distance / speed
    local tween    = TweenService:Create(hrpRef, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    return tween
end

local refillParts, refillScanAt = nil, 0

local function FindRefillPart()
    -- scan the whole workspace once, then only re-check the cached parts
    local stale = os.clock() - refillScanAt
    if not refillParts or stale > 30 or (#refillParts == 0 and stale > 3) then
        refillParts = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local name = v.Name:lower()
                if name:find("refill") or name:find("fill") then
                    refillParts[#refillParts + 1] = v
                end
            end
        end
        refillScanAt = os.clock()
    end
    for _, v in ipairs(refillParts) do
        if v.Parent then
            local display = v:FindFirstChild("Display")
            if display then
                local ok, title = pcall(function() return display.Main.Top.Title.Text end)
                if ok and title ~= "REFILLS: 0 / 3 [R]" then return v end
            end
        end
    end
    return nil
end

local function Refill_S2()
    local refillPart = FindRefillPart()
    if not refillPart then return end
    TweenTo_S2(refillPart.CFrame, 6000)
    pcall(function()
        ReplicatedStorage.Assets.Remotes.POST:FireServer("Attacks", "Reload", refillPart)
    end)
end

local function ChangeBlade_S2()
    pcall(function()
        ReplicatedStorage.Assets.Remotes.GET:InvokeServer("Blades", "Reload")
    end)
end

local function CheckBlade_S2()
    if not Gradient_S2 then return false end
    local x = Gradient_S2.Offset.X
    if x < 0 then
        local bladeOk = false
        pcall(function()
            local rig = workspace.Characters[player.Name]["Rig_" .. player.Name]
            local blade = rig.LeftHand.Blade_1
            if blade.Transparency == 0 then bladeOk = true end
        end)
        if bladeOk then return false end
        if SetsLabel_S2 and SetsLabel_S2.Text == "0 / 3" then
            Refill_S2()
        else
            ChangeBlade_S2()
        end
        return true
    end
    return false
end

if Gradient_S2 then
    Gradient_S2:GetPropertyChangedSignal("Offset"):Connect(function()
        if autoBladeRunning then CheckBlade_S2() end
    end)
end

local bladeLoopToken = 0
local function StartBladeLoop()
    bladeLoopToken = bladeLoopToken + 1
    local my = bladeLoopToken
    autoBladeRunning = true
    task.spawn(function()
        while autoBladeRunning and bladeLoopToken == my do
            CheckBlade_S2()
            task.wait(0.2)
        end
    end)
end

local BladeToggle = Tabs.Main:AddToggle("AutoBladeReload", {
    Title = "Auto Reload / Refill Blades",
    Description = "Switches blade sets automatically; teleports to refill station when all sets are empty",
    Default = true,
    Callback = function(state)
        if state then
            StartBladeLoop()
        else
            autoBladeRunning = false
            bladeLoopToken = bladeLoopToken + 1
        end
    end
})
-- callbacks don't fire on creation, so start it for the default-on state
if BladeToggle.Value then StartBladeLoop() end

--//==============================\\--
--||        👑 AUTO CLICK M1       ||--
--\\==============================//--

local autoM1Running = false
local autoM1Token   = 0
local M1_DELAY       = 0.25
local M1Toggle

local RESULT_TITLES_M1 = { ["MISSION COMPLETED"] = true, ["RAID COMPLETED"] = true }

local function GuiVisibleM1(obj)
    local cur = obj
    while cur and cur ~= game do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("ScreenGui") and not cur.Enabled then return false end
        cur = cur.Parent
    end
    return true
end

local function MissionCompleted()
    local ok, res = pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return false end
        for _, d in ipairs(pg:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = tostring(d.Text or ""):gsub("<[^>]->", "")
                t = t:gsub("^%s+", ""):gsub("%s+$", "")
                if RESULT_TITLES_M1[t:upper()] and GuiVisibleM1(d) then return true end
            end
        end
        return false
    end)
    return ok and res
end

local cachedAttackBtn
local function FindAttackButton()
    if cachedAttackBtn and cachedAttackBtn.Parent and cachedAttackBtn.Visible then return cachedAttackBtn end
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return nil end
    for _, d in ipairs(pg:GetDescendants()) do
        if d:IsA("GuiButton") and d.Visible then
            local n = d.Name:lower()
            if n == "attack" or n == "m1" or n == "slash" then cachedAttackBtn = d return d end
        end
    end
    return nil
end

local function ClickM1()
    -- real mouse click in the screen centre (M1)
    pcall(function()
        local cam = workspace.CurrentCamera
        local size = cam and cam.ViewportSize or Vector2.new(800, 600)
        local x, y = size.X / 2, size.Y / 2
        VirtualInput:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.03)
        VirtualInput:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
    -- on-screen attack button (mobile layout), if one exists
    pcall(function()
        local btn = FindAttackButton()
        if btn then
            if firesignal then
                firesignal(btn.MouseButton1Down)
                firesignal(btn.MouseButton1Up)
                firesignal(btn.MouseButton1Click)
                firesignal(btn.Activated)
            else
                local pos, sz = btn.AbsolutePosition, btn.AbsoluteSize
                local inset = GuiService:GetGuiInset()
                local cx, cy = pos.X + sz.X / 2, pos.Y + sz.Y / 2 + inset.Y
                VirtualInput:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
                task.wait(0.03)
                VirtualInput:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
            end
        end
    end)
end

-- M1 no longer spams on its own: it only clicks when Auto Kill actually fires a hit burst
local M1Enabled = true
local lastM1 = 0

Config.onKillBurst = function()
    if not M1Enabled then return end
    if os.clock() - lastM1 < M1_DELAY then return end
    lastM1 = os.clock()
    ClickM1()
end

M1Toggle = Tabs.Main:AddToggle("AutoClickM1", {
    Title = "Auto Click M1 (only while killing)",
    Description = "Clicks M1 only when Auto Kill is hitting titans. Follows the Auto Kill switch",
    Default = true,
    Callback = function(state)
        M1Enabled = state and true or false
    end
})
if M1Toggle and M1Toggle.Value ~= nil then M1Enabled = M1Toggle.Value and true or false end

local KillToggle = Tabs.Main:AddToggle("AutoKillTitans", {
    Title = "Auto Kill Titans",
    Description = "Don't Finish the mission under 17 sec",
    Default = true,
    Callback = function(state)
        Config.isFlying = state
        if state then task.spawn(killFromAbove) end
        -- M1 setting turns on/off together with Auto Kill
        if M1Toggle and M1Toggle.SetValue then pcall(function() M1Toggle:SetValue(state and true or false) end) end
    end
})
if KillToggle.Value then Config.isFlying = true task.spawn(killFromAbove) end

Tabs.Main:AddDropdown("MoveMode", {
    Title = "Movement Mode",
    Values = {"Teleportation", "Gliding"},
    Default = 1,
    Callback = function(option) Config.moveMode = option end
})

Tabs.Main:AddSlider("StartDelaySlider", {
    Title = "Farm Delay",
    Description = "0 = start instantly. Raise it if the mission ends too early",
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Callback = function(value) Config.startDelay = value end
})

Tabs.Main:AddSlider("FlySpeedSlider", {
    Title = "Gliding Speed",
    Default = 300,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(value) Config.flySpeed = value end
})

Tabs.Main:AddSlider("FlyHeightSlider", {
    Title = "Float Height",
    Default = 250,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Callback = function(value) Config.flyHeight = value end
})

Tabs.Main:AddSlider("HitSpeedSlider", {
    Title = "Hit Interval (ms) - lower = faster",
    Default = 120,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(value) Config.hitCooldown = value / 1000 end
})

Tabs.Main:AddSlider("MultiHitSlider", {
    Title = "Titans Hit Per Burst",
    Default = 8,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Callback = function(value) Config.multiHit = value end
})

local _Remotes = game:GetService("ReplicatedStorage").Assets.Remotes
local GET, POST = _Remotes.GET, _Remotes.POST

--//==============================\\--
--||        👑 AUTO Retry         ||--
--\\==============================//--

local VIM = game:GetService("VirtualInputManager")

local interface = player:FindFirstChild("PlayerGui")
    and player.PlayerGui:FindFirstChild("Interface")

local rewards     = interface and interface:FindFirstChild("Rewards")
local rewardsMain = rewards and rewards:FindFirstChild("Main")
local retryBtn    = rewardsMain
    and rewardsMain:FindFirstChild("Info")
    and rewardsMain.Info:FindFirstChild("Main")
    and rewardsMain.Info.Main:FindFirstChild("Buttons")
    and rewardsMain.Info.Main.Buttons:FindFirstChild("Retry")

local autoRetryEnabled = false

local function showDebugDot(x, y)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, x - 5, 0, y - 5)
    dot.BackgroundColor3 = Color3.new(1, 0, 0)
    dot.BorderSizePixel = 0
    dot.ZIndex = 10000
    dot.Name = "DebugDot"
    pcall(function() dot.Parent = game:GetService("CoreGui") end)
    game:GetService("Debris"):AddItem(dot, 2)
end

local function Retryshi()
    local pos  = retryBtn.AbsolutePosition
    local size = retryBtn.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local x = pos.X + size.X / 2 + 20
    local y
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        y = pos.Y + size.Y / 2 + 60
    else
        y = pos.Y + size.Y / 2 + inset.Y
    end
    showDebugDot(x, y)
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function shouldClickRetry()
    return retryBtn
        and rewards and rewards.Visible
        and rewardsMain and rewardsMain.Visible
        and retryBtn.Visible
        and retryBtn.AbsoluteSize.Magnitude > 10
end

task.spawn(function()
    while true do
        if autoRetryEnabled and shouldClickRetry() then
            task.wait(0.3)
            if shouldClickRetry() then
                Retryshi()
                task.wait(2)
            end
        end
        task.wait(0.25)
    end
end)

Tabs.Main:AddToggle("AutoRetryToggle", {
    Title = "Auto Retry",
    Default = false,
    Callback = function(state) autoRetryEnabled = state end
})

--//==============================\\--
--||        👑 AUTO Escape        ||--
--\\==============================//--

local escapeRunning    = false
local escapeThread     = nil
local cleanGUIThread   = nil
local lastEscapeButton = nil

Tabs.Main:AddToggle("Escape", {
    Title = "Auto Escape",
    Default = false,
    Callback = function(Value)
        escapeRunning = Value
        if not Value then lastEscapeButton = nil return end
        escapeThread = task.spawn(function()
            local pg = player:WaitForChild("PlayerGui")
            while escapeRunning do
                local iface   = pg:FindFirstChild("Interface")
                local buttons = iface and iface:FindFirstChild("Buttons")
                if buttons then
                    local list = buttons:GetChildren()
                    if #list > 0 then
                        POST:FireServer("Attacks", "Slash_Escape")
                        for _, b in ipairs(list) do b:Destroy() end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
})

--//==============================\\--
--||        👑 Nape extend        ||--
--\\==============================//--

local newSize   = Vector3.new(1500, 1500, 1500)
local connection
local ripperConnection

local function resizeNapes()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Nape" then
            v.Size = newSize
            local cf = v.CFrame v.CFrame = cf
        end
    end
end

Tabs.Main:AddToggle("nape", {
    Title = "Nape extend",
    Default = false,
    Callback = function(state)
        if state then
            resizeNapes()
            if connection then connection:Disconnect() end
            connection = workspace.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") and desc.Name == "Nape" then
                    task.wait(0.1)
                    desc.Size = newSize
                    local cf = desc.CFrame desc.CFrame = cf
                end
            end)
        else
            if connection then connection:Disconnect() connection = nil end
        end
    end
})

--//==============================\\--
--||       👑  Titan Ripper       ||--
--\\==============================//--

local Event = ReplicatedStorage.Assets.Remotes.GET

local SkillData
local success2, result2 = pcall(function()
    return ReplicatedStorage:WaitForChild("Modules", 5)
        :WaitForChild("Storage", 5)
        :WaitForChild("Skill", 5)
end)

if success2 and result2 then SkillData = require(result2) else SkillData = {} end

local autoSkillEnabled = false

local skills = {
    ["14"] = { lastUsed = 0, initialDelay = 0 },
    ["23"] = { lastUsed = 0, initialDelay = 0.4 }
}

for skillID, info in pairs(skills) do
    task.spawn(function()
        task.wait(info.initialDelay)
        while true do
            task.wait(0.1)
            if autoSkillEnabled then
                local now = tick()
                local skillInfo = typeof(SkillData) == "table" and SkillData[skillID]
                if skillInfo and skillInfo.Cooldown then
                    if now - info.lastUsed >= skillInfo.Cooldown then
                        local ok = pcall(function()
                            Event:InvokeServer("S_Skills", "Usage", skillID, false)
                        end)
                        if ok then info.lastUsed = tick() end
                    end
                end
            end
        end
    end)
end

Tabs.Main:AddToggle("AutoSkillNapeToggle", {
    Title = "Titan Ripper",
    Default = false,
    Callback = function(state)
        autoSkillEnabled = state
        if state then
            for _, info in pairs(skills) do info.lastUsed = 0 end
            resizeNapes()
            if ripperConnection then ripperConnection:Disconnect() end
            ripperConnection = workspace.DescendantAdded:Connect(function(desc)
                if desc:IsA("BasePart") and desc.Name == "Nape" then
                    task.wait(0.1)
                    desc.Size = newSize
                    desc.CFrame = desc.CFrame
                end
            end)
        else
            if ripperConnection then ripperConnection:Disconnect() ripperConnection = nil end
        end
    end
})

--//==============================\\--
--||         👑 Auto Roll         ||--
--\\==============================//--

local CLICK_DELAY = 0.2
local WAIT_DELAY  = 1
local ENABLED     = false

local function canClick(btn)
    return btn and btn.Visible and btn.AbsoluteSize.Magnitude > 10
end

local function isActuallyVisible(obj)
    if not obj then return false end
    local current = obj
    local Gui = player:WaitForChild("PlayerGui")
    while current and current ~= Gui do
        local success3, result3 = pcall(function() return current.Visible end)
        if success3 and not result3 then return false end
        current = current.Parent
    end
    return obj.AbsoluteSize.Magnitude > 10
end

local function clickButton(btn)
    if not btn then return false end
    local pos  = btn.AbsolutePosition
    local size = btn.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2 + inset.Y
    VIM:SendMouseMoveEvent(x, y, game)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
    return true
end

local function findButton(parent, buttonName)
    if not parent then return nil end
    local function searchRecursive(obj)
        if obj.Name == buttonName and obj:IsA("GuiButton") then return obj end
        for _, child in pairs(obj:GetChildren()) do
            local result4 = searchRecursive(child)
            if result4 then return result4 end
        end
        return nil
    end
    return searchRecursive(parent)
end

local function findButtonByText(parent, text)
    if not parent then return nil end
    local function searchRecursive(obj)
        if obj:IsA("GuiButton") or obj:IsA("TextButton") then
            local hasText = obj:FindFirstChild("Text") or obj.Text
            if hasText and string.find(string.lower(tostring(hasText)), string.lower(text)) then return obj end
        end
        for _, child in pairs(obj:GetChildren()) do
            local result5 = searchRecursive(child)
            if result5 then return result5 end
        end
        return nil
    end
    return searchRecursive(parent)
end

task.spawn(function()
    local Gui = player:WaitForChild("PlayerGui")
    local interface2 = Gui:WaitForChild("Interface", 10)
    if not interface2 then return end
    local rollButton = nil
    local searchPaths = {"Customisation.Family.Buttons_2.Roll", "Roll", "RollButton"}
    for _, path in pairs(searchPaths) do
        local pathParts = string.split(path, ".")
        local current = interface2
        for _, part in pairs(pathParts) do
            if current then current = current:FindFirstChild(part) end
        end
        if current and current:IsA("GuiButton") then rollButton = current break end
    end
    if not rollButton then rollButton = findButton(interface2, "Roll") end
    if not rollButton then rollButton = findButtonByText(interface2, "roll") end
    if not rollButton then return end
    while true do
        if ENABLED then
            if canClick(rollButton) and isActuallyVisible(rollButton) then
                clickButton(rollButton)
                task.wait(CLICK_DELAY)
            else task.wait(WAIT_DELAY) end
        else task.wait(1) end
    end
end)

--//==============================\\--
--||        AUTO JOIN TAB         ||--
--\\==============================//--

local Difficulties      = {"Best For You","Easy","Normal","Hard","Severe","Aberrant"}
local DifficultiesRaids = {"Best For You","Hard","Severe","Aberrant"}
local ModifiersList     = {"No Perks","No Skills","No Memories","Nightmare","Oddball","Injury Prone","Chronic Injuries","Fog","Glass Cannon","Time Trial","Boring","Simple"}
local MissionMaps       = {"Shiganshina","Trost","Outskirts","Forest","Utgard","Docks","Stohess","Chapel"}
local MissionObjectives = {
    ["Shiganshina"]={"Skirmish","Breach","Random"},
    ["Trost"]      ={"Skirmish","Protect","Random"},
    ["Outskirts"]  ={"Skirmish","Escort","Random"},
    ["Forest"]     ={"Skirmish","Guard","Random"},
    ["Utgard"]     ={"Skirmish","Defend","Random"},
    ["Docks"]      ={"Skirmish","Stall","Random"},
    ["Stohess"]    ={"Skirmish","Random"},
    ["Chapel"]     ={"Skirmish","Random"},
}
local RaidMaps      = {"Shiganshina","Trost","Stohess"}
local RaidObjectives= {["Shiganshina"]={"Armored Titan","Colossal Titan"},["Trost"]={"Attack Titan"},["Stohess"]={"Female Titan"}}
local WaveMaps      = {"Trost"}

_G.AJ = {
    SelectMissionMap        = MissionMaps[1],
    SelectMissionObjective  = MissionObjectives[MissionMaps[1]][1],
    SelectMissionDifficulty = "Easy",
    SelectMissionModifiers  = {},
    SelectRaidMap           = RaidMaps[1],
    SelectRaidObjective     = RaidObjectives[RaidMaps[1]][1],
    SelectRaidDifficulty    = "Easy",
    SelectRaidModifiers     = {},
    SelectWaveMap           = WaveMaps[1],
    AutoJoinMission         = false,
    AutoJoinMissionBoost    = false,
    AutoJoinRaid            = false,
    AutoJoinWaves           = false,
}

local function PressButton(d)
    game:GetService("GuiService").SelectedObject = d
    VIM:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

local function CreateAndStart(data)
    if game.PlaceId == 14916516914 then
        local ok, res = pcall(function() return GET:InvokeServer("S_Missions","Create",data) end)
        if ok and typeof(res) == "Instance" then
            task.wait(1)
            pcall(function() return GET:InvokeServer("S_Missions","Start") end)
            return true
        end
        return false
    end
end

-- Mission section
Tabs.AutoJoin:AddSection("Auto Join Missions")

local MissionObjectiveDropdown2

Tabs.AutoJoin:AddDropdown("AJ_MissionMap", {
    Title = "Select Map",
    Values = MissionMaps,
    Default = _G.AJ.SelectMissionMap,
    Callback = function(v)
        _G.AJ.SelectMissionMap = v
        local objs = MissionObjectives[v]
        if objs then _G.AJ.SelectMissionObjective = objs[1] end
        if MissionObjectiveDropdown2 then MissionObjectiveDropdown2:SetValues(MissionObjectives[v] or {}) end
    end
})

MissionObjectiveDropdown2 = Tabs.AutoJoin:AddDropdown("AJ_MissionObjective", {
    Title = "Select Objective",
    Values = MissionObjectives[_G.AJ.SelectMissionMap] or {},
    Default = _G.AJ.SelectMissionObjective,
    Callback = function(v) _G.AJ.SelectMissionObjective = v end
})

Tabs.AutoJoin:AddDropdown("AJ_MissionDifficulty", {
    Title = "Select Difficulty",
    Values = Difficulties,
    Default = _G.AJ.SelectMissionDifficulty,
    Callback = function(v) _G.AJ.SelectMissionDifficulty = v end
})

Tabs.AutoJoin:AddDropdown("AJ_MissionModifiers", {
    Title = "Select Modifiers",
    Values = ModifiersList,
    Multi = true,
    Default = _G.AJ.SelectMissionModifiers,
    Callback = function(v) _G.AJ.SelectMissionModifiers = v end
})

Tabs.AutoJoin:AddToggle("AJ_AutoJoinMission", {
    Title = "Auto Join Mission",
    Description = "Automatically joins missions",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinMission = v end
})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AJ.AutoJoinMission then
            CreateAndStart({Name=_G.AJ.SelectMissionMap,Type="Missions",Difficulty=_G.AJ.SelectMissionDifficulty,Objective=_G.AJ.SelectMissionObjective,Modifiers=_G.AJ.SelectMissionModifiers,Limit=8})
        end
    end
end)

Tabs.AutoJoin:AddToggle("AJ_AutoJoinMissionBoost", {
    Title = "Auto Join Mission (Rewards Boost)",
    Description = "Automatically joins boosted missions",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinMissionBoost = v end
})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AJ.AutoJoinMissionBoost then
            CreateAndStart({Name=game:GetService("Workspace"):GetAttribute("Boosted_Map"),Type="Missions",Difficulty=_G.AJ.SelectMissionDifficulty,Objective=_G.AJ.SelectMissionObjective,Modifiers=_G.AJ.SelectMissionModifiers,Limit=8})
        end
    end
end)

-- Raids section
Tabs.AutoJoin:AddSection("Auto Join Raids")

local RaidObjectiveDropdown2

Tabs.AutoJoin:AddDropdown("AJ_RaidMap", {
    Title = "Select Raid Map",
    Values = RaidMaps,
    Default = _G.AJ.SelectRaidMap,
    Callback = function(v)
        _G.AJ.SelectRaidMap = v
        local objs = RaidObjectives[v]
        if objs then _G.AJ.SelectRaidObjective = objs[1] end
        if RaidObjectiveDropdown2 then RaidObjectiveDropdown2:SetValues(RaidObjectives[v] or {}) end
    end
})

RaidObjectiveDropdown2 = Tabs.AutoJoin:AddDropdown("AJ_RaidObjective", {
    Title = "Select Raid Boss",
    Values = RaidObjectives[_G.AJ.SelectRaidMap] or {},
    Default = _G.AJ.SelectRaidObjective,
    Callback = function(v) _G.AJ.SelectRaidObjective = v end
})

Tabs.AutoJoin:AddDropdown("AJ_RaidDifficulty", {
    Title = "Select Difficulty",
    Values = DifficultiesRaids,
    Default = _G.AJ.SelectRaidDifficulty,
    Callback = function(v) _G.AJ.SelectRaidDifficulty = v end
})

Tabs.AutoJoin:AddDropdown("AJ_RaidModifiers", {
    Title = "Select Modifiers",
    Values = ModifiersList,
    Multi = true,
    Default = _G.AJ.SelectRaidModifiers,
    Callback = function(v) _G.AJ.SelectRaidModifiers = v end
})

Tabs.AutoJoin:AddToggle("AJ_AutoJoinRaid", {
    Title = "Auto Join Raid",
    Description = "Automatically joins raids",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinRaid = v end
})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AJ.AutoJoinRaid then
            CreateAndStart({Name=_G.AJ.SelectRaidMap,Type="Raids",Difficulty=_G.AJ.SelectRaidDifficulty,Objective=_G.AJ.SelectRaidObjective,Modifiers=_G.AJ.SelectRaidModifiers,Limit=8})
        end
    end
end)

-- Waves section
Tabs.AutoJoin:AddSection("Auto Join Waves")

Tabs.AutoJoin:AddDropdown("AJ_WaveMap", {
    Title = "Select Wave Map",
    Values = WaveMaps,
    Default = _G.AJ.SelectWaveMap,
    Callback = function(v) _G.AJ.SelectWaveMap = v end
})

Tabs.AutoJoin:AddToggle("AJ_AutoJoinWaves", {
    Title = "Auto Join Waves",
    Description = "Automatically joins waves",
    Default = false,
    Callback = function(v) _G.AJ.AutoJoinWaves = v end
})

task.spawn(function()
    while task.wait(0.1) do
        if _G.AJ.AutoJoinWaves then
            CreateAndStart({Name=_G.AJ.SelectWaveMap,Type="Waves",Difficulty="Easy",Objective="Waves",Limit=8})
        end
    end
end)

-- Leave wrong mission auto-correct
spawn(function()
    while task.wait(0.1) do
        if _G.AJ.AutoJoinMission or _G.AJ.AutoJoinRaid or _G.AJ.AutoJoinWaves then
            for _, v in pairs(game:GetService("ReplicatedStorage").Missions:GetChildren()) do
                if v.Leader.Value == player.Name then
                    local Target = nil
                    if _G.AJ.AutoJoinMission then Target = _G.AJ.SelectMissionMap
                    elseif _G.AJ.AutoJoinMissionBoost then Target = game:GetService("Workspace"):GetAttribute("Boosted_Map")
                    elseif _G.AJ.AutoJoinRaid then Target = _G.AJ.SelectRaidMap
                    elseif _G.AJ.AutoJoinWaves then Target = _G.AJ.SelectWaveMap end
                    if v.Name ~= Target then
                        GET:InvokeServer("S_Missions","Leave")
                    end
                end
            end
        end
    end
end)

--//==============================\\--
--||        SERVERS TAB           ||--
--\\==============================//--

local TPS = TeleportService

Tabs.Servers:AddSection("Server")

Tabs.Servers:AddInput("JobIDInput", {
    Title = "JobID",
    Placeholder = "Paste Job ID here",
    Callback = function(x) _G.JobId_Textbox = x end
})

Tabs.Servers:AddToggle("AutoJoinJobID", {
    Title = "Auto Join JobID",
    Default = false,
    Callback = function(v)
        _G.AutoJoinJobID = v
        if v then
            task.spawn(function()
                while _G.AutoJoinJobID do
                    if _G.JobId_Textbox and _G.JobId_Textbox ~= "" then
                        TPS:TeleportToPlaceInstance(game.PlaceId, _G.JobId_Textbox, player)
                        Fluent:Notify({ Title="AstaRoth", Content="Joining JobID... Please wait.", Duration=3 })
                    else
                        warn("Please enter a JobID before enabling Auto Join JobID")
                        _G.AutoJoinJobID = false break
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Servers:AddButton({
    Title = "Join JobID",
    Callback = function()
        TPS:TeleportToPlaceInstance(game.PlaceId, _G.JobId_Textbox, player)
        Fluent:Notify({ Title="AstaRoth", Content="Joining JobID... Please wait.", Duration=3 })
    end
})

Tabs.Servers:AddButton({
    Title = "Copy JobID",
    Callback = function()
        setclipboard(game.JobId)
        Fluent:Notify({ Title="AstaRoth", Content="Copied JobID!", Duration=3 })
    end
})

Tabs.Servers:AddSection("Basic")

Tabs.Servers:AddButton({
    Title = "Rejoin",
    Description = "Re-enter the same server",
    Callback = function() TeleportService:Teleport(game.PlaceId, player) end
})

getgenv().ServerHop = function()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local data = HttpService:JSONDecode(game:HttpGet(url))
    for _, v in ipairs(data.data or {}) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Players.LocalPlayer) return
        end
    end
end

Tabs.Servers:AddButton({
    Title = "Server Hop",
    Description = "Move to new server",
    Callback = function() getgenv().ServerHop() end
})

Tabs.Servers:AddSection("Smart Server")

Tabs.Servers:AddSlider("MaxPlayersFilter", {
    Title = "Max Players Filter",
    Min = 1,
    Max = 20,
    Default = 5,
    Rounding = 0,
    Callback = function(v) _G.SetP = v end
})

Tabs.Servers:AddButton({
    Title = "Smart Hop",
    Description = "Find server with fewest players",
    Callback = function()
        local limit = _G.SetP
        local body = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
        for _, v in ipairs(body.data or {}) do
            if v.playing <= limit then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, player) break end
        end
    end
})

Tabs.Servers:AddButton({
    Title = "Low Ping Hop",
    Description = "Find lowest ping server",
    Callback = function()
        pcall(function()
            local bestServer, lowestPing = nil, math.random(50, 200)
            local body = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
            for _, v in ipairs(body.data or {}) do
                local ping = tonumber(v.ping)
                if ping and ping < lowestPing then lowestPing = ping bestServer = v.id end
            end
            if bestServer then TeleportService:TeleportToPlaceInstance(game.PlaceId, tostring(bestServer), player) end
        end)
    end
})

--//==============================\\--
--||           MISC TAB           ||--
--\\==============================//--

getgenv().AutoHideAfterDelay = false

Tabs.Misc:AddToggle("AutoHideAfter10s", {
    Title = "Auto Hide UI (5s)",
    Default = false,
    Callback = function(state)
        getgenv().AutoHideAfterDelay = state
        if state then
            task.delay(5, function()
                if not getgenv().AutoHideAfterDelay then return end
                getgenv().AutoHideUI = true
                Window:Minimize(true)
            end)
        end
    end
})

local lastTap = 0
local function toggleUI()
    Window:Minimize()
end

UserInputService.TouchTap:Connect(function(_, gameProcessed)
    if gameProcessed then return end
    local now = tick()
    if now - lastTap <= 0.4 then toggleUI() end
    lastTap = now
end)

Tabs.Misc:AddToggle("ToggleNotifications", {
    Title = "Notifications",
    Default = false,
    Callback = function(value) Config.notificationsEnabled = value end
})

-- Delete Map
local hiddenFolder = ReplicatedStorage:FindFirstChild("aristo_deletemap")
if not hiddenFolder then
    hiddenFolder = Instance.new("Folder")
    hiddenFolder.Name = "aristo_deletemap"
    hiddenFolder.Parent = ReplicatedStorage
end

Tabs.Misc:AddToggle("del", {
    Title = "Delete Map",
    Default = false,
    Callback = function(state)
        if state then
            local climbable = workspace:FindFirstChild("Climbable")
            if climbable then
                local fakeClimbable = Instance.new("Folder")
                fakeClimbable.Name = "Climbable"
                fakeClimbable.Parent = workspace
                climbable.Parent = hiddenFolder
            end
            local unclimbable = workspace:FindFirstChild("Unclimbable")
            if unclimbable then
                for _, child in ipairs(unclimbable:GetChildren()) do
                    local name = child.Name
                    local shouldKeep = (name == "Reloads" or name == "Objective" or name == "Cutscene")
                    if not shouldKeep and not child:IsA("Terrain") and not (child:IsA("BasePart") and child.Size.Magnitude > 100) then
                        pcall(function() child.Parent = hiddenFolder end)
                    end
                end
                local objective = unclimbable:FindFirstChild("Objective")
                if objective then
                    local guard = objective:FindFirstChild("Guard")
                    if guard then
                        local collider = guard:FindFirstChild("Collider")
                        if collider and collider:IsA("BasePart") then
                            collider.CanTouch    = false
                            collider.CanCollide  = false
                            collider.Transparency = 1
                        end
                    end
                end
            end
        else
            for _, item in ipairs(hiddenFolder:GetChildren()) do
                if item.Name == "Climbable" then item.Parent = workspace
                elseif item:IsA("Instance") then
                    item.Parent = workspace:FindFirstChild("Unclimbable") or workspace
                end
            end
        end
    end
})

local delaySeconds = 180
local toggleActive = false

Tabs.Misc:AddToggle("ForceRetryToggle", {
    Title = "Fail Safe",
    Default = false,
    Callback = function(state)
        toggleActive = state
        if state then
            task.delay(delaySeconds, function()
                if toggleActive then
                    pcall(function() retryRemote:InvokeServer("Functions", "Retry", "Add") end)
                end
            end)
        end
    end
})

-- Damage Text
local iface2 = player:WaitForChild("PlayerGui"):WaitForChild("Interface")
local damageConnection

Tabs.Misc:AddToggle("dmg", {
    Title = "Remove Dmg Text",
    Default = false,
    Callback = function(state)
        if state then
            for _, obj in pairs(iface2:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Name == "Number" then obj.Visible = false end
            end
            damageConnection = iface2.DescendantAdded:Connect(function(obj)
                if obj:IsA("TextLabel") and obj.Name == "Number" then obj.Visible = false end
            end)
        else
            if damageConnection then damageConnection:Disconnect() damageConnection = nil end
        end
    end
})

-- Teleport buttons
local lobbyPlaceId    = 14916516914
local mainMenuPlaceId = 13379208636

Tabs.Misc:AddButton({
    Title = "Return to Lobby",
    Callback = function() TeleportService:Teleport(lobbyPlaceId, player) end
})

Tabs.Misc:AddButton({
    Title = "Return to Main Menu",
    Callback = function() TeleportService:Teleport(mainMenuPlaceId, player) end
})

Tabs.Misc:AddButton({
    Title = "Force Retry",
    Callback = function()
        local ok, err = pcall(function()
            retryRemote:InvokeServer("Functions", "Retry", "Add")
        end)
        if not ok then warn(".") end
    end,
})

--//==============================\\--
--||            👑 ESP            ||--
--\\==============================//--

local ESPEnabled = false
local ESPColor   = Color3.fromRGB(96, 205, 255)
local ESPSize    = Vector3.new(50, 50, 50)

local function createNapeESP(nape)
    if not nape:FindFirstChild("NapeESP") then
        local esp = Instance.new("BoxHandleAdornment")
        esp.Name        = "NapeESP"
        esp.Adornee     = nape
        esp.AlwaysOnTop = true
        esp.ZIndex      = 5
        esp.Size        = ESPSize
        esp.Transparency = 0.5
        esp.Color3      = ESPColor
        esp.Parent      = nape
    end
end

local function applyNapeESP()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return end
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit  = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:IsA("BasePart") then createNapeESP(nape) end
            end
        end
    end
end

local function removeAllNapeESP()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return end
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape and nape:FindFirstChild("NapeESP") then nape.NapeESP:Destroy() end
            end
        end
    end
end

local function updateNapeESPColor()
    local titansFolder = workspace:FindFirstChild("Titans")
    if not titansFolder then return end
    for _, titan in ipairs(titansFolder:GetChildren()) do
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape then
                    local esp = nape:FindFirstChild("NapeESP")
                    if esp then esp.Color3 = ESPColor end
                end
            end
        end
    end
end

local titansFolderEsp = workspace:FindFirstChild("Titans")
if titansFolderEsp then
    titansFolderEsp.ChildAdded:Connect(function(titan)
        if not ESPEnabled then return end
        task.wait(0.5)
        local hitboxes = titan:FindFirstChild("Hitboxes")
        if hitboxes then
            local hit = hitboxes:FindFirstChild("Hit")
            if hit then
                local nape = hit:FindFirstChild("Nape")
                if nape then createNapeESP(nape) end
            end
        end
    end)
end

Tabs.Esp:AddToggle("NapeESP", {
    Title = "Enable Nape ESP",
    Default = false,
    Callback = function(value)
        ESPEnabled = value
        if value then applyNapeESP() else removeAllNapeESP() end
    end
})

local Colorpicker = Tabs.Esp:AddColorpicker("ESPColorPicker", {
    Title = "ESP Color",
    Default = ESPColor
})

Colorpicker:OnChanged(function(newColor)
    ESPColor = newColor
    updateNapeESPColor()
end)

Colorpicker:SetValueRGB(Color3.fromRGB(96, 205, 255))

-- ============================================================
--  Account / Webhook  (ported from Smooth Hub)
--  Logic is copied verbatim from the original; only the UI layer is Fluent.
-- ============================================================
do
local okMod, errMod = pcall(function()

-- ---------- compat layer (replaces Smooth Hub globals the extracted code expects) ----------
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IN_MENU = (game.PlaceId == 13379208636)
local modToken = {}
_G.AstaRothModToken = modToken
local function Alive() return _G.AstaRothModToken == modToken end
local SH = { DEV = false }
function SH.say(...) print("[AstaRoth]", ...) end
function SH.dbg(...) if SH.DEV then print(...) end end
function SH.Guard(name, fn)
    local ok, err = xpcall(fn, function(e) return tostring(e) .. "\n" .. debug.traceback() end)
    if not ok then warn("[AstaRoth] block " .. tostring(name) .. " failed to load: " .. tostring(err)) end
end
function SH.PlayOn() return true end
local Farm = {}
SH.Farm = Farm
function Farm.CanUseHere()
    return not IN_MENU and game.PlaceId ~= 14916516914
end
local Cfg = {
    AutoFarmThunder = false,
    UseThunderSpears = false,
}
local function Save() end
-- thunder-spear counter (verbatim from Smooth Hub; the "stuck" detector belongs to its farm loop and is not included)
    local function SpearsLeft()
        local char = LocalPlayer.Character
        local n = char and char:GetAttribute("Spears")
        if type(n) == "number" then return n end
        return nil
    end
Farm.SpearsLeft = SpearsLeft
local function IsShown(obj)
    local cur = obj
    while cur and cur ~= PlayerGui do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("ScreenGui") and not cur.Enabled then return false end
        cur = cur.Parent
    end
    return obj:IsA("GuiObject") and obj.AbsoluteSize.X > 0 and obj.AbsoluteSize.Y > 0
end

-- tiny file store for the Webhook tab (own file, never mixed into configs)
local SettingsStore = {}
do
    local DIR = "AstaRoth/" .. tostring(LocalPlayer.UserId)
    local function Path(file) return DIR .. "/" .. file .. ".json" end
    function SettingsStore.Load(file)
        local data = {}
        pcall(function()
            if isfile and readfile and isfile(Path(file)) then
                local d = HttpService:JSONDecode(readfile(Path(file)))
                if type(d) == "table" then data = d end
            end
        end)
        return data
    end
    function SettingsStore.Write(file, data)
        pcall(function()
            if not (writefile and makefolder) then return end
            if isfolder and not isfolder("AstaRoth") then makefolder("AstaRoth") end
            if isfolder and not isfolder(DIR) then makefolder(DIR) end
            writefile(Path(file), HttpService:JSONEncode(data))
        end)
    end
    function SettingsStore.Restore(target, data)
        if type(data) ~= "table" then return end
        for k, v in pairs(data) do
            if target[k] ~= nil and type(target[k]) == type(v) then target[k] = v end
        end
    end
end

-- Fluent paragraph -> object with a .Text setter, so the original update code works unchanged
local function MakeLabel(para)
    local obj = { __instance = para and para.DescLabel }
    return setmetatable(obj, { __newindex = function(_, k, v)
        if k == "Text" then pcall(function() para:SetDesc(tostring(v)) end) end
    end })
end

-- keep the Webhook URL / switch out of shared SaveManager configs (it has its own file)
pcall(function() SaveManager:SetIgnoreIndexes({ "WebhookEnabled", "WebhookUrl" }) end)

local AccountTab = EarlyAccountTab
local WebhookTab = Window:AddTab({ Title = "Webhook", Icon = "" })
Tabs.Account, Tabs.Webhook = AccountTab, WebhookTab


-- ================== ACCOUNT TAB ==================
AccountTab:AddSection("📊 Account Overview")
AccountTab:AddParagraph({ Title = "Info", Content = "Read from your player data. N/A = this value was not found." })
local ReplicatedStorageSvc = game:GetService("ReplicatedStorage")
local function FindGui(path)
    local cur = PlayerGui
    for seg in path:gmatch("[^%.]+") do
        cur = cur and cur:FindFirstChild(seg)
        if not cur then return nil end
    end
    return cur
end
local function CountShards()
    local items = FindGui("Interface.Inventory.Main.Holder.Items")
    if not items then return nil end
    local total = 0
    for _, c in ipairs(items:GetChildren()) do
        if c.Name:lower():find("shard", 1, true) then
            local q = 1
            local label = c:FindFirstChild("Quantity", true)
            if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
                q = tonumber((label.Text:gsub("[^%d]", ""))) or 1
            end
            total += q
        end
    end
    return total
end
local function CurrentFamily()
    local items = FindGui("Interface.Inventory.Main.Holder.Items")
    if not items then return nil end
    for _, c in ipairs(items:GetChildren()) do
        local id, name = c.Name:match("^(%d+)%s*%-%s*(.+)$")
        if id and tonumber(id) % 100 == 2 then
            local main = c:FindFirstChild("Main")
            local eq = main and main:FindFirstChild("Equipped")
            if eq and eq:IsA("GuiObject") and eq.Visible then
                local check = eq:FindFirstChild("Checkmark")
                local on = true
                if check and check:IsA("ImageLabel") and check.ImageTransparency >= 1 then on = false end
                if on then return name end
            end
        end
    end
    return "None"
end
local function AttrTrue(v)
    if type(v) == "boolean" then return v end
    if type(v) == "number" then return v ~= 0 end
    if type(v) == "string" then
        local x = v:lower()
        return x == "true" or x == "yes" or x == "1"
    end
    return false
end
local hiddenLabelCache, hiddenLabelAt = nil, 0
local function FindWarningLabel()
    if os.clock() - hiddenLabelAt < 15 then return hiddenLabelCache end
    hiddenLabelAt = os.clock()
    hiddenLabelCache = false
    local n = 0
    for _, d in ipairs(PlayerGui:GetDescendants()) do
        n += 1
        if n % 600 == 0 then task.wait() end
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local t = (d.Text or ""):lower()
            if t:find("exploiter", 1, true) or t:find("shadow ban", 1, true) or t:find("shadowban", 1, true) then
                hiddenLabelCache = d:GetFullName():gsub("^Players%.[^%.]+%.PlayerGui%.", "")
                break
            end
        end
    end
    return hiddenLabelCache
end
local function ShadowStatus()
    if FindWarningLabel() then return "✅" end
    if AttrTrue(LocalPlayer:GetAttribute("Exploiter")) or AttrTrue(LocalPlayer:GetAttribute("Blacklisted")) then
        return "✅"
    end
    return "❌"
end
local function FlagCompare()
    local others, flagged = 0, 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            others += 1
            if AttrTrue(plr:GetAttribute("Exploiter")) or AttrTrue(plr:GetAttribute("Blacklisted")) then
                flagged += 1
            end
        end
    end
    local mine = (AttrTrue(LocalPlayer:GetAttribute("Exploiter")) or AttrTrue(LocalPlayer:GetAttribute("Blacklisted"))) and "flagged" or "clear"
    return ("You: %s | Others flagged: %d/%d"):format(mine, flagged, others)
end
local FIELDS = {
    { key = "ShadowBan", title = "🛠️ Shadow Ban", raw = true, aliases = {}, calc = ShadowStatus,
      colors = { ["✅"] = Color3.fromRGB(80, 200, 120), ["❌"] = Color3.fromRGB(235, 87, 87) } },
    { key = "FlagCompare", title = "🔍 Flag Compare", raw = true, aliases = {}, calc = FlagCompare },
    { key = "Blacklisted", title = "🚫 Blacklisted", flag = true, aliases = { "blacklisted" } },
    { key = "Exploiter", title = "⚠️ Exploiter Flag", flag = true, aliases = { "exploiter" } },
    { key = "Level",     title = "▶️ Level",    aliases = { "level", "lvl", "playerlevel" } },
    { key = "XP",        title = "📈 XP",       aliases = {}, strip = "^XP:%s*",
      gui = "Interface.Gear_Up.XP.Percentage" },
    { key = "Prestige",  title = "🔺 Prestige", aliases = { "prestige", "prestigelevel" } },
    { key = "Gold",      title = "💰 Gold",     aliases = { "gold", "coins", "money" },
      gui = "Interface.Topbar.Main.Currencies.Gold.Amount" },
    { key = "Gems",      title = "💎 Gems",     aliases = { "gems", "gem" },
      gui = "Interface.Topbar.Main.Currencies.Gems.Amount" },
    { key = "Family",    title = "⚡ Family",   aliases = { "family", "familyname", "clan" }, calc = CurrentFamily },
    { key = "Title",     title = "🏷️ Title",    aliases = { "title" }, pretty = true },
    { key = "Shards",    title = "✨ Shards",   aliases = { "shards", "shard" }, calc = CountShards },
}
for _, f in ipairs(FIELDS) do
    local para = AccountTab:AddParagraph({ Title = f.title, Content = "..." })
    f.label = MakeLabel(para)
    f.last = nil
end
local function NormName(s)
    return (tostring(s):lower():gsub("[^%w]", ""))
end
local function Fmt(v)
    if type(v) == "number" then
        if v ~= math.floor(v) then return string.format("%.2f", v) end
        local s = tostring(math.floor(v))
        local neg = s:sub(1, 1) == "-"
        if neg then s = s:sub(2) end
        s = s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        return (neg and "-" or "") .. s
    end
    return tostring(v)
end
local function Truthy(v)
    if type(v) == "boolean" then return v end
    if type(v) == "number" then return v ~= 0 end
    if type(v) == "string" then
        local s = v:lower()
        return s == "true" or s == "yes" or s == "1"
    end
    return false
end
local dataRoots = { LocalPlayer }
local lastRootScan = 0
local function ScanRoots(force)
    if not force and os.clock() - lastRootScan < 15 then return end
    lastRootScan = os.clock()
    local roots = { LocalPlayer }
    local uid = tostring(LocalPlayer.UserId)
    local n = 0
    for _, d in ipairs(ReplicatedStorageSvc:GetDescendants()) do
        n += 1
        if n % 500 == 0 then task.wait() end
        if d.Name == LocalPlayer.Name or d.Name == uid then
            table.insert(roots, d)
        end
    end
    dataRoots = roots
end
local SKIP_NAMES = { PlayerGui = true, PlayerScripts = true }
local function CollectEntries()
    local entries = {}
    local function keep(v)
        local t = type(v)
        return t == "number" or t == "string" or t == "boolean"
    end
    local function walk(inst, depth)
        pcall(function()
            for k, v in pairs(inst:GetAttributes()) do
                if keep(v) then
                    entries[#entries + 1] = { name = k, value = v, path = inst:GetFullName() .. " @" .. k }
                end
            end
            if inst:IsA("ValueBase") then
                local ok, v = pcall(function() return inst.Value end)
                if ok and keep(v) then
                    entries[#entries + 1] = { name = inst.Name, value = v, path = inst:GetFullName() }
                end
            end
        end)
        if depth >= 6 then return end
        for _, c in ipairs(inst:GetChildren()) do
            if not SKIP_NAMES[c.Name] then walk(c, depth + 1) end
        end
    end
    for _, root in ipairs(dataRoots) do
        if root and root.Parent then walk(root, 0) end
    end
    return entries
end
local function IsExcludedPath(path)
    return path:find("%.Boosts") ~= nil or path:find("%.Gamepasses") ~= nil
end
local function LookupField(entries, field)
    for _, alias in ipairs(field.aliases) do
        for _, e in ipairs(entries) do
            if NormName(e.name) == alias and not IsExcludedPath(e.path) then
                return e.value
            end
        end
    end
    return nil
end
local function ReadGui(path)
    local cur = FindGui(path)
    if cur and (cur:IsA("TextLabel") or cur:IsA("TextButton")) then
        local t = (cur.Text or ""):gsub("<[^>]->", "")
        t = t:gsub("^%s+", ""):gsub("%s+$", "")
        if t ~= "" then return t end
    end
    return nil
end
local function LabelObject(label)
    local inst = label and label.__instance
    if not inst then return nil end
    if inst:IsA("TextLabel") then return inst end
    return inst:FindFirstChildWhichIsA("TextLabel", true)
end
local lastEntries = {}
local function RefreshOverview()
    ScanRoots(false)
    local entries = CollectEntries()
    lastEntries = entries
    for _, f in ipairs(FIELDS) do
        local v
        if f.calc then
            local okC, r = pcall(f.calc)
            if okC then v = r end
        end
        if v == nil and f.gui then v = ReadGui(f.gui) end
        if v == nil then v = LookupField(entries, f) end
        local text
        if v == nil then
            text = "N/A"
        elseif f.raw then
            text = tostring(v)
        elseif f.flag then
            text = Truthy(v) and "⚠️ Yes" or "✅ No"
        elseif f.strip then
            text = (tostring(v):gsub(f.strip, ""))
        elseif f.pretty then
            text = (tostring(v):gsub("_", " "))
        else
            text = Fmt(v)
        end
        if text ~= f.last then
            f.last = text
            pcall(function() f.label.Text = text end)
            if f.colors and f.colors[text] then
                pcall(function()
                    local obj = LabelObject(f.label)
                    if obj then obj.TextColor3 = f.colors[text] end
                end)
            end
        end
    end
end
task.spawn(function()
    while Alive() do
        pcall(RefreshOverview)
        for _ = 1, 12 do
            if not Alive() then return end
            task.wait(0.25)
        end
    end
end)

-- ================== WEBHOOK ==================
SH.Guard("webhook", function()
    local HttpService = game:GetService("HttpService")
    local TAB = WebhookTab

    local FILE = "Webhook"
    local SEND_DELAY = 1.2      -- รอหลังเจอหน้า MISSION COMPLETED ก่อนอ่านตัวเลข (ส่งเร็วเพื่อไม่ให้ Retry วาร์ปไปก่อน)
    local SESSION_GAP = 600     -- ห่างกันเกินกี่วินาทีถึงเริ่มเซสชันใหม่ (ยอดสะสม/เวลาออนไลน์)

    local W = {
        Enabled = false,
        Url = "",
        SendResultTexts = true,
        Start = 0, LastSeen = 0, Matches = 0, Gold = 0, Gems = 0, Exp = 0,
        CurGold = 0, CurGems = 0, -- ยอด Gold/Gems ล่าสุดที่รู้ (เก็บไว้เพราะในแมตช์ไม่มี Topbar ให้อ่าน)
    }
    SettingsStore.Restore(W, SettingsStore.Load(FILE))

    local function NewSession()
        W.Start, W.LastSeen, W.Matches, W.Gold, W.Gems, W.Exp = os.time(), os.time(), 0, 0, 0, 0
    end
    if W.Start == 0 or os.time() - W.LastSeen > SESSION_GAP then NewSession() end
    local function SaveW()
        W.LastSeen = os.time()
        SettingsStore.Write(FILE, W)
    end

    local PREFIXES = {
        "^https://discord%.com/api/webhooks/",
        "^https://discordapp%.com/api/webhooks/",
        "^https://canary%.discord%.com/api/webhooks/",
        "^https://ptb%.discord%.com/api/webhooks/",
    }
    local function ValidUrl(url)
        url = tostring(url or "")
        for _, p in ipairs(PREFIXES) do
            if url:match(p) then return true end
        end
        return false
    end
    local function GetRequest()
        return (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
    end

    local Status = function() end

    -- ---------- อ่านค่า ----------
    local function ParseNum(s)
        if s == nil then return nil end
        s = tostring(s):gsub(",", ""):gsub("%s", "")
        local n, suf = s:match("^([%d%.]+)([KkMmBb]?)$")
        if not n then return nil end
        n = tonumber(n)
        if not n then return nil end
        local mult = { k = 1e3, m = 1e6, b = 1e9 }
        return n * (mult[(suf or ""):lower()] or 1)
    end
    local function FieldText(key)
        for _, f in ipairs(FIELDS) do
            if f.key == key then return f.last end
        end
        return nil
    end
    local GOLD_PATHS = { "Interface.Topbar.Main.Currencies.Gold.Amount", "Interface.HUD.Main.Top.2.Gold.Title" }
    local GEM_PATHS = { "Interface.Topbar.Main.Currencies.Gems.Amount" }
    local function ReadLive(paths)
        for _, p in ipairs(paths) do
            local ok, t = pcall(ReadGui, p)
            local v = ok and ParseNum(t)
            if v and v > 0 then return v end
        end
        return nil
    end
    -- อ่านค่าจริงจากหน้าจอ (ถ้าอ่านได้ก็จำไว้) ถ้าอ่านไม่ได้ค่อยใช้ยอดที่จำไว้/ค่าจากแท็บ Account
    local function Snapshot()
        local gold, gems = ReadLive(GOLD_PATHS), ReadLive(GEM_PATHS)
        if gold then W.CurGold = gold
        elseif W.CurGold <= 0 then W.CurGold = ParseNum(FieldText("Gold")) or 0 end
        if gems then W.CurGems = gems
        elseif W.CurGems <= 0 then W.CurGems = ParseNum(FieldText("Gems")) or 0 end
        return { gold = gold, gems = gems }
    end
    local function Clock(sec)
        sec = math.max(0, math.floor(sec))
        return ("%02d:%02d:%02d"):format(math.floor(sec / 3600), math.floor(sec % 3600 / 60), sec % 60)
    end
    local function CleanText(o)
        local t = tostring(o.Text or ""):gsub("<[^>]->", "")
        return (t:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    -- อ่านหน้าสรุปแมตช์ แล้วแยกเป็น "Stats" (ชื่อ: ค่า) และ "Obtained" (EXP / Gold / Gems / ไอเท็ม)
    local STAT_DEFS = {
        { "TIME TAKEN", "Time Taken" },
        { "DAMAGE DEALT", "Damage Dealt" },
        { "TITANS KILLED", "Titans Killed" },
        { "CRITICAL HITS", "Critical Hits" },
    }
    local function IsValueText(t)
        return t:match("^[%d,%.]+$") or t:match("^%d+:%d+$") or t:match("^[%d,%.]+[KkMmBb]$")
    end
    local GENERIC = { amount = true, quantity = true, count = true, title = true, label = true, frame = true,
        textlabel = true, text = true, value = true, stack = true, main = true, content = true, holder = true, item = true }
    -- [smooth] Raid support: the Raid result screen says "RAID COMPLETED" instead of "MISSION COMPLETED"
    local RESULT_TITLES = { ["MISSION COMPLETED"] = true, ["RAID COMPLETED"] = true }
    local rTitle, rScanAt = nil, 0
    local function ResultShown()
        if Farm.CompleteScreenShown and Farm.CompleteScreenShown() then return true end
        if rTitle and rTitle.Parent then return IsShown(rTitle) and true or false end
        rTitle = nil
        if os.clock() - rScanAt < 1 then return false end
        rScanAt = os.clock()
        local n = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and RESULT_TITLES[CleanText(d):upper()] then
                rTitle = d
                return IsShown(d) and true or false
            end
        end
        return false
    end
    -- [smooth] Reward names: look at attributes, name values, sibling texts, frame / icon names (not just the frame name)
    local NAME_SKIP = { icon = true, image = true, img = true, slot = true, template = true, reward = true, rewards = true,
        obtained = true, itemframe = true, bg = true, background = true, border = true, glow = true, shadow = true,
        scrolling = true, scroll = true, list = true, grid = true, container = true, layout = true, rarity = true, star = true, stars = true }
    local function Pretty(n)
        n = tostring(n):gsub("_", " "):gsub("(%l)(%u)", "%1 %2"):gsub("%s+", " ")
        return (n:gsub("^%s+", ""):gsub("%s+$", ""))
    end
    local function GoodName(n)
        local l = tostring(n):lower():gsub("%d+$", "")
        if l == "" or GENERIC[l] or NAME_SKIP[l] then return false end
        if l:find("^ui") or l:find("layout") or l:find("padding") or l:find("corner") or l:find("stroke") or l:find("gradient") then return false end
        return true
    end
    local function ItemName(lbl, root)
        local a = lbl
        for _ = 1, 4 do
            if not a or a == root then break end
            for _, key in ipairs({ "ItemName", "DisplayName", "Name", "Title", "Item", "ItemId", "Id" }) do
                local v
                pcall(function() v = a:GetAttribute(key) end)
                if type(v) == "string" and v ~= "" then return Pretty(v) end
            end
            for _, c in ipairs(a:GetChildren()) do
                if c:IsA("StringValue") and c.Value ~= "" then
                    local cn = c.Name:lower()
                    if cn:find("name") or cn:find("item") or cn:find("title") then return Pretty(c.Value) end
                end
                if c:IsA("TextLabel") and c ~= lbl then
                    local t = CleanText(c)
                    if t ~= "" and #t <= 40 and not IsValueText(t) and not t:match("^[IVX]+$") then return t end
                end
            end
            if a ~= lbl and GoodName(a.Name) then return Pretty(a.Name) end
            if a ~= lbl then
                for _, c in ipairs(a:GetChildren()) do
                    if (c:IsA("ImageLabel") or c:IsA("ImageButton")) and GoodName(c.Name) then return Pretty(c.Name) end
                end
            end
            a = a.Parent
        end
        return nil
    end
    local function ReadResult()
        local title, n = nil, 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            n += 1
            if n % 800 == 0 then task.wait() end
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and RESULT_TITLES[CleanText(d):upper()] and IsShown(d) then
                title = d
                break
            end
        end
        if not title then return nil end
        local root = title
        for _ = 1, 4 do
            if root.Parent and root.Parent ~= PlayerGui then root = root.Parent end
        end

        local labels = {}
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") and IsShown(d) then
                labels[#labels + 1] = { obj = d, text = CleanText(d) }
            end
        end

        -- Stats: หาป้ายชื่อ แล้วหาค่าที่อยู่แถวเดียวกัน
        local stats, used = {}, {}
        for _, def in ipairs(STAT_DEFS) do
            for _, e in ipairs(labels) do
                if e.text:upper() == def[1] then
                    local a = e.obj.Parent
                    for _ = 1, 3 do
                        if not a or a == root.Parent then break end
                        local found
                        for _, o in ipairs(a:GetDescendants()) do
                            if o ~= e.obj and o:IsA("TextLabel") and IsShown(o) and not used[o] and IsValueText(CleanText(o)) then
                                found = o
                                break
                            end
                        end
                        if found then
                            used[found] = true
                            stats[#stats + 1] = { name = def[2], text = CleanText(found) }
                            break
                        end
                        a = a.Parent
                    end
                    break
                end
            end
        end

        -- Obtained: ตัวเลข/เลขโรมันที่เหลือ คือจำนวนของรางวัลแต่ละช่อง
        local cands = {}
        for _, e in ipairs(labels) do
            if not used[e.obj] and (IsValueText(e.text) or e.text:match("^[IVX]+$")) then
                local names, best = {}, nil
                local a = e.obj
                for _ = 1, 4 do
                    if not a or a == root then break end
                    names[#names + 1] = a.Name:lower()
                    if not best and a ~= e.obj and not GENERIC[a.Name:lower()] then best = a.Name end
                    if a ~= e.obj then
                        for _, c in ipairs(a:GetChildren()) do
                            if c:IsA("ImageLabel") or c:IsA("ImageButton") then names[#names + 1] = c.Name:lower() end
                        end
                    end
                    a = a.Parent
                end
                local p = e.obj.AbsolutePosition
                local nm = ItemName(e.obj, root)
                if not nm and not (e.text:match("^[IVX]+$")) then
                    -- [smooth] could not find a name: print the path to F9 so it can be added
                    local path, q = {}, e.obj
                    for _ = 1, 5 do
                        if not q or q == root then break end
                        path[#path + 1] = q.ClassName .. ":" .. q.Name
                        q = q.Parent
                    end
                    print("[Smooth Hub] Reward name not found for '" .. e.text .. "': " .. table.concat(path, " < "))
                end
                cands[#cands + 1] = { text = e.text, names = table.concat(names, " "), best = best, name = nm, x = p.X, y = p.Y }
            end
        end
        table.sort(cands, function(a, b)
            if math.abs(a.y - b.y) > 20 then return a.y < b.y end
            return a.x < b.x
        end)

        local items, got = {}, {}
        for _, c in ipairs(cands) do
            local kind = "other"
            if c.names:find("gold") or c.names:find("coin") then kind = "gold"
            elseif c.names:find("exp") then kind = "exp"
            elseif c.names:find("gem") then kind = "gems" end
            if kind ~= "other" then got[kind] = true end
            items[#items + 1] = { kind = kind, name = c.name or (c.best and Pretty(c.best)) or "Item", text = c.text, num = ParseNum(c.text) }
        end
        -- ถ้าอ่านชื่อไม่ได้ ใช้ลำดับช่องตามหน้าจอจริง: ช่อง 1 = EXP, ช่อง 2 = Gold
        if not got.exp and not got.gold and #items >= 2 and items[1].num and items[2].num then
            items[1].kind, items[2].kind = "exp", "gold"
        end
        local raw, seenRaw = {}, {}
        for _, e in ipairs(labels) do
            local up = e.text:upper()
            if #e.text >= 1 and #e.text <= 40 and not seenRaw[e.text] and up ~= "MISSION COMPLETED" and up ~= "RAID COMPLETED" and up ~= "LEAVE"
                and up ~= "MODIFIERS" and up ~= "STATS" and up ~= "OBTAINED" and not up:match("^STARTING") then
                seenRaw[e.text] = true
                raw[#raw + 1] = e.text
            end
        end
        return { stats = stats, items = items, raw = raw }
    end

        -- ---------- สร้างข้อความ Discord ----------
    local function BuildEmbed(now, gain, res, isTest)
        gain = gain or {}
        local rewards = {}
        local function Add(g, name, total)
            if g and g > 0 then
                rewards[#rewards + 1] = ("+ %s %s (รอบที่ %d)"):format(Fmt(g), name, W.Matches)
                if total then rewards[#rewards + 1] = ("+ %s %s (สะสมทั้งหมด)"):format(Fmt(total), name) end
            end
        end
        Add(gain.gold, "Golds", W.Gold)
        Add(gain.gems, "Gems", W.Gems)
        Add(gain.exp, "EXP", W.Exp)
        if res then
            for _, it in ipairs(res.items) do
                if it.kind == "other" then
                    rewards[#rewards + 1] = ("+ %s %s (รอบที่ %d)"):format(it.name, it.text, W.Matches)
                end
            end
        end
        if #rewards == 0 then
            rewards[1] = isTest and "(ข้อความทดสอบ)" or "ไม่พบรางวัลในหน้าสรุปผล"
            rewards[2] = ("(รอบที่ %d)"):format(W.Matches)
        end

        local goldText = W.CurGold > 0 and Fmt(W.CurGold) or "N/A"
        local gemsText = W.CurGems > 0 and Fmt(W.CurGems) or "N/A"
        local desc = table.concat({
            "💰 `Golds  : " .. goldText .. "`",
            "💎 `Gems   : " .. gemsText .. "`",
            "⚡ `Level  : " .. (FieldText("Level") or "N/A") .. "`",
            "⏱️ `Online : " .. Clock(os.time() - W.Start) .. "`",
        }, "\n")

        local fields = {
            { name = "⭐ Rewards", value = "```diff\n" .. table.concat(rewards, "\n") .. "\n```", inline = false },
        }
        if W.SendResultTexts and res and #res.stats > 0 then
            local lines = {}
            for _, st in ipairs(res.stats) do
                lines[#lines + 1] = ("%-14s : %s"):format(st.name, st.text)
            end
            fields[#fields + 1] = { name = "📊 Stats", value = "```\n" .. table.concat(lines, "\n") .. "\n```", inline = false }
        end

        if W.SendResultTexts and res and #res.stats == 0 and #res.items == 0 and res.raw and #res.raw > 0 then
            fields[#fields + 1] = { name = "🧾 Result screen", value = "```\n" .. table.concat(res.raw, "\n"):sub(1, 900) .. "\n```", inline = false }
        end

        return {
            username = "Smooth Hub",
            embeds = { {
                title = "Username: " .. LocalPlayer.Name,
                description = desc,
                color = isTest and 0x5865F2 or 0x57F287,
                fields = fields,
                thumbnail = { url = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(LocalPlayer.UserId) },
                footer = { text = "Smooth Hub | AOTR" .. (isTest and " | TEST" or "") },
                timestamp = DateTime.now():ToIsoDate(),
            } },
        }
    end

        local function PostJson(payload)
        local req = GetRequest()
        if not req then return false, "executor has no http request" end
        if not ValidUrl(W.Url) then return false, "invalid webhook link" end
        local ok, res = pcall(req, {
            Url = W.Url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload),
        })
        if not ok then return false, tostring(res) end
        local code = type(res) == "table" and (res.StatusCode or res.Status) or nil
        if code and code >= 200 and code < 300 then return true, "HTTP " .. tostring(code) end
        return false, "HTTP " .. tostring(code)
    end

    -- ---------- ส่งผลหลังจบแมตช์ ----------
    local baseline = {}
    local sending = false
    local function SendMatch()
        if sending then return end
        sending = true
        -- อ่านทันทีที่เจอหน้าจอ (โหมด Raid หน้านี้หายเร็ว) แล้วรออีกนิดอ่านซ้ำ เลือกอันที่ได้ข้อมูลมากกว่า
        local res
        local function Count(r) return r and (#r.stats + #r.items) or -1 end
        pcall(function() res = ReadResult() end)
        task.wait(SEND_DELAY)
        local now = Snapshot()
        pcall(function()
            local r2 = ReadResult()
            if Count(r2) >= Count(res) and r2 then res = r2 end
        end)
        local gain = {}
        if res then
            for _, it in ipairs(res.items) do
                if it.num and (it.kind == "gold" or it.kind == "gems" or it.kind == "exp") then
                    gain[it.kind] = (gain[it.kind] or 0) + it.num
                end
            end
        end
        -- ถ้าหน้าสรุปไม่บอก Gold/Gems ใช้ส่วนต่างจาก HUD แทน
        if not gain.gold and baseline.gold and now.gold then gain.gold = now.gold - baseline.gold end
        if not gain.gems and baseline.gems and now.gems then gain.gems = now.gems - baseline.gems end
        W.Matches += 1
        if gain.gold and gain.gold > 0 then W.Gold += gain.gold end
        if gain.gems and gain.gems > 0 then W.Gems += gain.gems end
        if gain.exp and gain.exp > 0 then W.Exp += gain.exp end
        -- ยอดรวมปัจจุบัน: ถ้าอ่านจริงไม่ได้ ใช้ยอดที่จำไว้ + ที่ได้รอบนี้
        if not now.gold and gain.gold and gain.gold > 0 and W.CurGold > 0 then W.CurGold += gain.gold end
        if not now.gems and gain.gems and gain.gems > 0 and W.CurGems > 0 then W.CurGems += gain.gems end
        SaveW()

        local ok, msg = PostJson(BuildEmbed(now, gain, res, false))
        Status(ok and ("Sent (match " .. W.Matches .. ")") or ("Send failed: " .. tostring(msg)))
        baseline = { gold = now.gold, gems = now.gems }
        sending = false
    end

        task.spawn(function()
        local shownSince, goneSince, sent, lastSave = nil, nil, false, 0
        while Alive() do
            task.wait(0.3)
            if not W.Enabled or not Farm.CanUseHere() then
                shownSince, goneSince, sent = nil, nil, false
                baseline = {}
            else
                if os.clock() - lastSave >= 30 then lastSave = os.clock() SaveW() end
                local shown = ResultShown()
                if shown then
                    goneSince = nil
                    shownSince = shownSince or os.clock()
                    if not sent and os.clock() - shownSince >= 0.5 then
                        sent = true
                        task.spawn(SendMatch)
                    end
                else
                    shownSince = nil
                    goneSince = goneSince or os.clock()
                    if os.clock() - goneSince >= 3 then sent = false end
                    -- เก็บค่าตั้งต้นก่อนจบแมตช์ (เติมเฉพาะค่าที่ยังอ่านไม่ได้)
                    local snap = Snapshot()
                    if baseline.gold == nil then baseline.gold = snap.gold end
                    if baseline.gems == nil then baseline.gems = snap.gems end
                end
            end
        end
    end)

    -- ---------- UI (Fluent) ----------
    TAB:AddSection("🔔 Webhook")
    TAB:AddParagraph({ Title = "Info", Content = "Sends a reward summary to Discord every time a match ends (MISSION COMPLETED screen)." })

    local function SetStatus(text) if Status then Status(text) end end

    TAB:AddToggle("WebhookEnabled", {
        Title = "Enable Webhook",
        Description = "Post to Discord when a match ends. Needs a valid Webhook URL.",
        Default = W.Enabled,
        Callback = function(value)
            W.Enabled = value and true or false
            SaveW()
            if W.Enabled and not ValidUrl(W.Url) then SetStatus("Set a valid Webhook URL first") end
        end
    })

    local statusPara = TAB:AddParagraph({ Title = "Webhook Status", Content = "Idle" })
    local statusLabel = MakeLabel(statusPara)
    Status = function(text) pcall(function() statusLabel.Text = tostring(text) end) end

    local function SetUrl(text, save)
        W.Url = (tostring(text or ""):gsub("%s", ""))
        if save then SaveW() end
    end

    local okField, field = pcall(function()
        return TAB:AddInput("WebhookUrl", {
            Title = "Webhook URL",
            Description = "Discord: Server Settings > Integrations > Webhooks > Copy URL. Keep it private.",
            Default = W.Url,
            Placeholder = "https://discord.com/api/webhooks/...",
            Numeric = false,
            Finished = false,
            Callback = function(value) SetUrl(value, true) end
        })
    end)

    TAB:AddButton({
        Title = "Send Test",
        Description = "Send one test message now.",
        Callback = function()
            pcall(function()
                if okField and field and type(field.Value) == "string" and ValidUrl(field.Value:gsub("%s", "")) then
                    SetUrl(field.Value, false)
                end
            end)
            SaveW()
            Status("Sending...")
            local ok, msg = PostJson(BuildEmbed(Snapshot(), {}, nil, true))
            Status(ok and "Test sent" or ("Test failed: " .. tostring(msg)))
        end
    })
end)

end)
if not okMod then warn("[AstaRoth] Account/Webhook/Refill module failed: " .. tostring(errMod)) end
end

--//==============================\\--
--||         SAVE / LOAD          ||--
--\\==============================//--

Window:SelectTab(Tabs.Main)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetFolder("AstaRoth")
InterfaceManager:SetFolder("AstaRoth")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Fluent:Notify({
    Title   = "AstaRoth",
    Content = "Loaded successfully! Tap the tray icon to hide/show the UI.",
    Duration = 4,
})
