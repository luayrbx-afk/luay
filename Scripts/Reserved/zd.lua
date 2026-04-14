local WindUI =

loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/ma

in.lua"))()

local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")

local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

_G.LockAll = false

_G.ESPEnabled = false

_G.AutoGrabGun = false -- Replaced AutoCoins with Auto Grab Gun

_G.FlingTarget = "Sheriff"

_G.IsFlinging = false

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "LuayFloatingUI"

ScreenGui.ResetOnSpawn = false

ScreenGui.Parent = game.CoreGui

local function syncRGB(stroke)

task.spawn(function()

while stroke and stroke.Parent do

local hue = tick() % 5 / 5

stroke.Color = Color3.fromHSV(hue,1,1)

task.wait(0.03)

          end
end)

end

local function createBaseButton(name,text,pos,isCircle,isRect)

local btn = Instance.new("TextButton")

btn.Name = name

btn.Visible = false

btn.Size = isRect and UDim2.new(0,140,0,60) or UDim2.new(0,80,0,80)

btn.Position = pos

btn.BackgroundColor3 = Color3.fromRGB(15,15,15)

btn.BackgroundTransparency = 0.5

btn.Text = text

btn.TextColor3 = Color3.fromRGB(255,255,255)

btn.Font = Enum.Font.GothamBold

btn.TextSize = 18

btn.ZIndex = 10

btn.Parent = ScreenGui

local corner = Instance.new("UICorner")

corner.CornerRadius = isCircle and UDim.new(1,0) or UDim.new(0,12)

corner.Parent = btn

local stroke = Instance.new("UIStroke")

stroke.Thickness = 2.5

stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

stroke.Parent = btn

syncRGB(stroke)

return btn
      end

local ShootBtn =

createBaseButton("ShootButton","SHOOT",UDim2.new(0.5,-160,0.5,-100),false,true)

local GunBtn = createBaseButton("GunButton","GUN",UDim2.new(0.5,-120,0.5,0),true,false)

local ThrowBtn =

createBaseButton("ThrowButton","THROW",UDim2.new(0.5,-40,0.5,0),false,false)

local function getMurderer()

for _,v in pairs(Players:GetPlayers()) do

if v ~= lp and v.Character and (v.Character:FindFirstChild("Knife") or

v.Backpack:FindFirstChild("Knife")) then

return v

end

end

end

local function getSheriff()

for _,v in pairs(Players:GetPlayers()) do

if v ~= lp and v.Character and (v.Character:FindFirstChild("Gun") or

v.Backpack:FindFirstChild("Gun")) then

return v

end

end

end

local function fireGun()

local gun = lp.Character:FindFirstChild("Gun") or lp.Backpack:FindFirstChild("Gun")

local m = getMurderer()
      if gun and m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then

if gun.Parent == lp.Backpack then

lp.Character.Humanoid:EquipTool(gun)

task.wait(0.1)

end

local mHRP = m.Character.HumanoidRootPart

local origin = mHRP.Position + Vector3.new(0,0,1)

local targetPos = mHRP.Position + (mHRP.Velocity * 0.25)

local args = {

CFrame.new(origin,targetPos) *

CFrame.Angles(1.4531978368759155,0.04432811588048935,1.6501713991165161),

CFrame.new(targetPos)

}

if gun:FindFirstChild("Shoot") then

gun.Shoot:FireServer(unpack(args))

end

end

end

local function throwAction()

local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")

local near

local dist = math.huge

for _,v in pairs(Players:GetPlayers()) do

if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then

local d = (lp.Character.HumanoidRootPart.Position -

v.Character.HumanoidRootPart.Position).Magnitude
          if d < dist then

dist = d

near = v

end

end

end

if knife and near and near.Character and near.Character:FindFirstChild("HumanoidRootPart")

then

if knife.Parent == lp.Backpack then

lp.Character.Humanoid:EquipTool(knife)

end

local hrp = near.Character.HumanoidRootPart

local origin = hrp.Position + Vector3.new(0,0,3)

local args = {

CFrame.new(origin,hrp.Position) *

CFrame.Angles(1.4531978368759155,0.04432811588048935,1.6501713991165161),

CFrame.new(hrp.Position)

}

if knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown") then

knife.Events.KnifeThrown:FireServer(unpack(args))

end

end

end

local function makeDraggable(btn,action)

local dragging=false

local dragStart

local startPos

btn.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType ==

Enum.UserInputType.Touch then

if action then action() end

if not _G.LockAll then

dragging=true

dragStart=input.Position

startPos=btn.Position

            end
            end

end)

btn.InputChanged:Connect(function(input)

if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or

input.UserInputType==Enum.UserInputType.Touch) then

local delta=input.Position-dragStart

btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.

Offset+delta.Y)

end

end)

btn.InputEnded:Connect(function(input)

if input.UserInputType==Enum.UserInputType.MouseButton1 or

input.UserInputType==Enum.UserInputType.Touch then

dragging=false

end

end)

end

makeDraggable(ShootBtn,fireGun)

makeDraggable(ThrowBtn,throwAction)

makeDraggable(GunBtn,function()

local d = workspace:FindFirstChild("GunDrop",true)

if d and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then

local old = lp.Character.HumanoidRootPart.CFrame

lp.Character.HumanoidRootPart.CFrame = d.CFrame

task.wait(0.1)

lp.Character.HumanoidRootPart.CFrame = old

end

end)
    local function applyESP(p)

if p==lp then return end

local function setup(char)

if not char then return end

local highlight = char:FindFirstChild("ExodusHighlight") or Instance.new("Highlight")

highlight.Name="ExodusHighlight"

highlight.FillTransparency=0.5

highlight.Parent=char

local head = char:WaitForChild("Head",5)

if not head then return end

local bill = head:FindFirstChild("ExodusBill") or Instance.new("BillboardGui")

bill.Name="ExodusBill"

bill.Size=UDim2.new(0,100,0,50)

bill.AlwaysOnTop=true

bill.ExtentsOffset=Vector3.new(0,3,0)

bill.Parent=head

local label = bill:FindFirstChild("ExodusLabel") or Instance.new("TextLabel")

label.Name="ExodusLabel"

label.Size=UDim2.new(1,0,1,0)

label.BackgroundTransparency=1

label.Font=Enum.Font.GothamBold

label.TextSize=14

label.Parent=bill

task.spawn(function()

while char.Parent do

if _G.ESPEnabled then

local isM = p.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")

local isS = p.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun")

highlight.Enabled=true

if isM then

bill.Enabled=true

highlight.FillColor=Color3.new(1,0,0)

label.Text="MURDERER"

label.TextColor3=Color3.new(1,0,0)

elseif isS then

bill.Enabled=true
                  highlight.FillColor=Color3.new(0,0,1)

label.Text="SHERIFF"

label.TextColor3=Color3.new(0,0,1)

else

bill.Enabled=false

highlight.FillColor=Color3.new(0,1,0)

end

else

highlight.Enabled=false

bill.Enabled=false

end

task.wait(0.5)

end

end)

end

p.CharacterAdded:Connect(setup)

if p.Character then setup(p.Character) end

end

for _,v in pairs(Players:GetPlayers()) do applyESP(v) end

Players.PlayerAdded:Connect(applyESP)

-- Gun Drop ESP Logic

task.spawn(function()

while task.wait(0.5) do

local gunDrop = workspace:FindFirstChild("GunDrop", true)

if gunDrop then

local highlight = gunDrop:FindFirstChild("GunDropHighlight")

local bill = gunDrop:FindFirstChild("GunDropBill")

if _G.ESPEnabled then

if not highlight then

highlight = Instance.new("Highlight")
                highlight.Name = "GunDropHighlight"

highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Yellow

highlight.FillTransparency = 0.5

highlight.Parent = gunDrop

end

if not bill then

bill = Instance.new("BillboardGui")

bill.Name = "GunDropBill"

bill.Size = UDim2.new(0, 100, 0, 50)

bill.AlwaysOnTop = true

bill.ExtentsOffset = Vector3.new(0, 2, 0)

bill.Parent = gunDrop

local label = Instance.new("TextLabel")

label.Size = UDim2.new(1, 0, 1, 0)

label.BackgroundTransparency = 1

label.Font = Enum.Font.GothamBold

label.TextSize = 14

label.Text = "DROPPED GUN"

label.TextColor3 = Color3.fromRGB(255, 255, 0)

label.Parent = bill

end

highlight.Enabled = true

bill.Enabled = true

else

if highlight then highlight.Enabled = false end

if bill then bill.Enabled = false end

end

end

end

end)
    local function restoreCollision(char)

for _,v in pairs(char:GetDescendants()) do

if v:IsA("BasePart") then

v.CanCollide=true

end

end

end

-- =========================================================

-- OPTIMIZED ANTI-COLLISION / ANTI-FLING SYSTEM

-- =========================================================

local SPEED_THRESHOLD = 80

local ANGULAR_LIMIT = 45

local UPDATE_INTERVAL = 0.1 -- Updates visuals every 0.1s to prevent lag

local lastUpdate = 0

local playerCache = {}

-- Function to map character parts and avoid heavy loops

local function cacheCharacter(player, character)

local parts = {}

for _, part in ipairs(character:GetDescendants()) do

if part:IsA("BasePart") then

table.insert(parts, part)

-- We only alter collisions when flinging

end

      end
      end

end

end

end)

-- Visual Loop (Slower to save CPU) - RESTORES VISUALS WHEN NOT FLINGING

RunService.Heartbeat:Connect(function(dt)

if not _G.IsFlinging then

-- Safely reset player transparency when the fling ends

for player, data in pairs(playerCache) do

if player ~= lp and data.parts then

for _, part in ipairs(data.parts) do

if part.Name ~= "HumanoidRootPart" and part.Transparency == 0.75 then

part.Transparency = 0

end

end

end

end

return

end

lastUpdate = lastUpdate + dt

if lastUpdate < UPDATE_INTERVAL then return end

lastUpdate = 0

for player, data in pairs(playerCache) do

if player ~= lp and data.root and data.root.Parent then

local velocity = data.root.AssemblyLinearVelocity.Magnitude

local angular = data.root.AssemblyAngularVelocity.Magnitude
    local isGhost = (velocity >= SPEED_THRESHOLD) or (angular >= ANGULAR_LIMIT)

local targetTransparency = isGhost and 0.75 or 0

for _, part in ipairs(data.parts) do

if part.Name ~= "HumanoidRootPart" then

part.Transparency = targetTransparency

end

end

end

end

end)

-- =========================================================

-- Auto Grab Gun Loop

task.spawn(function()

while task.wait() do

if _G.AutoGrabGun and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then

local gunDrop = workspace:FindFirstChild("GunDrop", true)

if gunDrop then

local hrp = lp.Character.HumanoidRootPart

hrp.CFrame = gunDrop.CFrame

task.wait(0.2) -- Prevents excessive teleport spamming

end

end

end

end)

-- =========================================================

-- PERSISTENT VOID FLING
-- =========================================================

-- Works even after death (Auto-Rebind)

-- Focuses on burying targets into the ground (Void)

-- Expanded hitbox via angular velocity

-- Extreme Force Settings

local FORCA_QUEDA = -95000 -- Downward velocity

local FORCA_GIRO = 1000000 -- Expands the hitbox (centrifuge effect)

local function executeFling()

if _G.IsFlinging then return end

local targetPlayer

if _G.FlingTarget == "Sheriff" then

targetPlayer = getSheriff()

elseif _G.FlingTarget == "Murderer" then

targetPlayer = getMurderer()

else

targetPlayer = Players:FindFirstChild(_G.FlingTarget)

end

if not targetPlayer or not targetPlayer.Character or not

targetPlayer.Character:FindFirstChild("Head") then return end

local char = lp.Character

local hrp = char and char:FindFirstChild("HumanoidRootPart")

if not hrp then return end

local savedCFrame = hrp.CFrame

_G.IsFlinging = true

task.spawn(function()

local start = tick()

local flingConn

flingConn = RunService.Heartbeat:Connect(function()

pcall(function()

-- Check if character and RootPart exist and are alive

if char and hrp and char:FindFirstChildOfClass("Humanoid") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")

-- If the humanoid is dead, we don't apply logic to avoid camera bugs

if humanoid.Health <= 0 then return end

if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then

hrp.CFrame = CFrame.new(targetPlayer.Character.Head.Position)

end

-- Save the original state to maintain local stability

local velOriginal = hrp.AssemblyLinearVelocity

local rotOriginal = hrp.AssemblyAngularVelocity

-- FLING APPLICATION:

-- 1. Create a massive spin to "catch" anyone nearby

hrp.AssemblyAngularVelocity = Vector3.new(FORCA_GIRO, FORCA_GIRO,

FORCA_GIRO)

-- 2. Force the velocity straight to the bottom of the map (Negative Y axis)

-- We remove X and Z interference so the push is 100% vertical

hrp.AssemblyLinearVelocity = Vector3.new(0, FORCA_QUEDA, 0)

-- Small frame delay to let the server physics register the impact

RunService.RenderStepped:Wait()

-- 3. Restore your velocity so you don't get pulled down alongside them

hrp.AssemblyLinearVelocity = velOriginal

hrp.AssemblyAngularVelocity = rotOriginal

end

end)

end)

-- Keep flinging for 1.5 seconds to guarantee they drop

while _G.IsFlinging and tick() - start < 1.5 do

task.wait()

end

_G.IsFlinging = false

flingConn:Disconnect()

-- Restore local player state

hrp.Anchored = true

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero
  hrp.CFrame = savedCFrame

task.wait(0.3)

restoreCollision(char)

hrp.AssemblyLinearVelocity = Vector3.zero

hrp.AssemblyAngularVelocity = Vector3.zero

hrp.Anchored = false

end)

end

local function findMapPart()

local part

for _,v in pairs(workspace:GetDescendants()) do

if v:IsA("BasePart") and v.Size.Magnitude > 10 then

part = v

end

end

return part

end

RunService.Heartbeat:Connect(function()

local char = lp.Character

if not char then return end

local hrp = char:FindFirstChild("HumanoidRootPart")

if not hrp then return end

if hrp.Position.Y < -50 then

local map = findMapPart()

if map then

hrp.CFrame = map.CFrame + Vector3.new(0,10,0)
    else

local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation",true)

if spawn then

hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0)

end

end

end

end)

local Window = WindUI:CreateWindow({

Title="Luay | MM2",

Icon="rbxassetid://4483362458",

Author="Luay",

Folder="LuayConfigs",

Size=UDim2.fromOffset(580,460),

Transparent=true,

Theme="Dark"

})

local MainTab = Window:Tab({Title="Main",Icon="rbxassetid://4483362458"})

MainTab:Toggle({Title="Enable ESP",Value=false,Callback=function(v) _G.ESPEnabled=v end})

MainTab:Toggle({Title="Lock Floating UI",Value=false,Callback=function(v) _G.LockAll=v end})

MainTab:Toggle({Title="Show Gun Button",Value=false,Callback=function(v) GunBtn.Visible=v

end})

MainTab:Toggle({Title="Show Shoot Button",Value=false,Callback=function(v) ShootBtn.Visible=v

end})

MainTab:Toggle({Title="Show Throw Button",Value=false,Callback=function(v)

ThrowBtn.Visible=v end})

-- Replaced Auto Farm with Auto Grab Settings Tab
local AutoTab = Window:Tab({Title="Auto Grab",Icon="rbxassetid://4483362458"})

AutoTab:Toggle({Title="Auto Grab Gun",Value=false,Callback=function(v) _G.AutoGrabGun=v

end})

local PlayerTab = Window:Tab({Title="Player / Fling",Icon="rbxassetid://4483362458"})

PlayerTab:Input({

Title="WalkSpeed",

PlaceholderText="16",

Callback=function(t)

local n=tonumber(t)

if n and lp.Character and lp.Character:FindFirstChild("Humanoid") then

lp.Character.Humanoid.WalkSpeed=n

end

end

})

local function getPlayerList()

local list={"Sheriff","Murderer"}

for _,p in pairs(Players:GetPlayers()) do

if p~=lp then

table.insert(list,p.Name)

end

end

return list

end

local FlingDropdown = PlayerTab:Dropdown({Title="Fling Target",

Values=getPlayerList(),

Value="Sheriff",

Callback=function(v)

_G.FlingTarget=v

end

})

PlayerTab:Button({

Title="Refresh Player List",

Callback=function()

FlingDropdown:Refresh(getPlayerList())

end

})

PlayerTab:Button({

Title="Execute Fling",

Callback=function()

executeFling()

end

})
