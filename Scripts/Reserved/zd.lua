--// =========================
--// Luay Universal Extra Addon
--// =========================

_G.LuayExtraConfig = {
    Name = "Extra",
    NoclipAntiFling = true,
    NameToggleNoclipFling = "Antifling",
    TapFling = true,
    NameToggleTapFling = "TapFling"
}

local Ly = {}

function Ly:Config(cfg)
    for i,v in pairs(cfg) do
        _G.LuayExtraConfig[i] = v
    end
end

_G.TapFlingEnabled = false
_G.NoclipAntiFlingEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

--========================--
-- TAP FLING
--========================--
task.spawn(function()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local FORCA_QUEDA = -95000
    local FORCA_GIRO = 1000000

    lp.CharacterAdded:Connect(function(c)
        char = c
        root = c:WaitForChild("HumanoidRootPart")
    end)

    RunService.Heartbeat:Connect(function()
        if not _G.TapFlingEnabled then return end

        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local vel = root.AssemblyLinearVelocity
            local rot = root.AssemblyAngularVelocity

            root.AssemblyAngularVelocity = Vector3.new(FORCA_GIRO,FORCA_GIRO,FORCA_GIRO)
            root.AssemblyLinearVelocity = Vector3.new(0,FORCA_QUEDA,0)

            RunService.RenderStepped:Wait()

            root.AssemblyLinearVelocity = vel
            root.AssemblyAngularVelocity = rot
        end)
    end)
end)

--========================--
-- NOCLIP / ANTIFLING
--========================--
task.spawn(function()
    local cache = {}
    local last = 0

    local function setup(p, char)
        local data = {parts={},root=nil}
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                table.insert(data.parts,v)
                v.CanCollide=false
            end
        end
        data.root = char:FindFirstChild("HumanoidRootPart")
        cache[p]=data
    end

    local function onPlayer(p)
        p.CharacterAdded:Connect(function(c)
            task.wait(0.2)
            setup(p,c)
        end)
        if p.Character then setup(p,p.Character) end
    end

    for _,p in ipairs(Players:GetPlayers()) do onPlayer(p) end
    Players.PlayerAdded:Connect(onPlayer)

    RunService.Stepped:Connect(function()
        if not _G.NoclipAntiFlingEnabled then return end

        for _,data in pairs(cache) do
            for i=#data.parts,1,-1 do
                local part=data.parts[i]
                if part and part.Parent then
                    part.CanCollide=false
                else
                    table.remove(data.parts,i)
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function(dt)
        if not _G.NoclipAntiFlingEnabled then return end

        last+=dt
        if last<0.1 then return end
        last=0

        for p,data in pairs(cache) do
            if p~=lp and data.root and data.root.Parent then
                local vel=data.root.AssemblyLinearVelocity.Magnitude
                local ang=data.root.AssemblyAngularVelocity.Magnitude

                local ghost = (vel>=80) or (ang>=45) or (vel>=400)
                local t = ghost and 0.75 or 0

                for _,part in ipairs(data.parts) do
                    if part.Name~="HumanoidRootPart" then
                        part.Transparency=t
                    end
                end
            end
        end
    end)
end)

--========================--
-- UI DETECTOR
--========================--
task.spawn(function()
    repeat task.wait() until game:IsLoaded()

    local tabName = _G.LuayExtraConfig.Name

    -- WINDUI
    if rawget(_G,"Window") then
        local tab = Window:Tab({Title=tabName,Icon="rbxassetid://4483362458"})

        tab:Toggle({
            Title=_G.LuayExtraConfig.NameToggleTapFling,
            Value=false,
            Callback=function(v) _G.TapFlingEnabled=v end
        })

        tab:Toggle({
            Title=_G.LuayExtraConfig.NameToggleNoclipFling,
            Value=false,
            Callback=function(v) _G.NoclipAntiFlingEnabled=v end
        })

        return
    end

    -- RAYFIELD
    if rawget(_G,"Rayfield") then
        local win = Rayfield:CreateWindow({Name="Luay Extra"})
        local tab = win:CreateTab(tabName,4483362458)

        tab:CreateToggle({
            Name=_G.LuayExtraConfig.NameToggleTapFling,
            CurrentValue=false,
            Callback=function(v) _G.TapFlingEnabled=v end
        })

        tab:CreateToggle({
            Name=_G.LuayExtraConfig.NameToggleNoclipFling,
            CurrentValue=false,
            Callback=function(v) _G.NoclipAntiFlingEnabled=v end
        })

        return
    end

    -- TURTLE UI (fallback simples)
    local gui = Instance.new("ScreenGui",game.CoreGui)
    gui.Name="LuayExtraMini"

    local function makeToggle(text,pos,callback)
        local b=Instance.new("TextButton",gui)
        b.Size=UDim2.new(0,140,0,40)
        b.Position=pos
        b.Text=text.." OFF"
        b.BackgroundColor3=Color3.fromRGB(20,20,20)
        b.TextColor3=Color3.new(1,1,1)

        local state=false
        b.MouseButton1Click:Connect(function()
            state=not state
            b.Text=text.." "..(state and "ON" or "OFF")
            callback(state)
        end)
    end

    makeToggle(_G.LuayExtraConfig.NameToggleTapFling,UDim2.new(0,10,0,200),function(v)
        _G.TapFlingEnabled=v
    end)

    makeToggle(_G.LuayExtraConfig.NameToggleNoclipFling,UDim2.new(0,10,0,250),function(v)
        _G.NoclipAntiFlingEnabled=v
    end)
end)

return Ly
