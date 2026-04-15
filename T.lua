local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local basePath = "luayrbx"
local savesPath = basePath .. "/saves"

if isfolder and makefolder then
    if not isfolder(basePath) then
        makefolder(basePath)
    end
    if not isfolder(savesPath) then
        makefolder(savesPath)
    end
end

local isAntiFlingEnabled = false
local antiFlingConnections = {}
local antiFlingGui = nil
local playerCache = {}

local function toggleAntiFling(state)
    local LocalPlayer = Players.LocalPlayer
    
    if state then
        playerCache = {}
        local lastUpdate = 0
        
        antiFlingGui = Instance.new("ScreenGui")
        antiFlingGui.Name = "FlingCounterUI"
        antiFlingGui.ResetOnSpawn = false
        antiFlingGui.DisplayOrder = 10
        antiFlingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local CounterLabel = Instance.new("TextLabel")
        CounterLabel.Size = UDim2.new(0, 150, 0, 30)
        CounterLabel.Position = UDim2.new(1, -160, 0, 10)
        CounterLabel.BackgroundTransparency = 1
        CounterLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        CounterLabel.TextStrokeTransparency = 0.5
        CounterLabel.TextSize = 22
        CounterLabel.Font = Enum.Font.SourceSansBold
        CounterLabel.TextXAlignment = Enum.TextXAlignment.Right
        CounterLabel.Text = " 0"
        CounterLabel.Parent = antiFlingGui

        local function isAPlayerPart(part)
            local model = part:FindFirstAncestorOfClass("Model")
            if model then
                if model:FindFirstChildOfClass("Humanoid") or part:FindFirstAncestorOfClass("Accessory") then
                    return true
                end
            end
            return part:IsDescendantOf(Players)
        end

        local function setup(player, character)
            if player == LocalPlayer then return end
            local data = { parts = {}, root = nil }
            local function process()
                data.parts = {}
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(data.parts, part)
                        part.CanCollide = false 
                    end
                end
                data.root = character:FindFirstChild("HumanoidRootPart")
            end
            process()
            playerCache[player] = data
        end

        local function onPlayer(player)
            local charConn = player.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                setup(player, char)
            end)
            table.insert(antiFlingConnections, charConn)
            if player.Character then setup(player, player.Character) end
        end

        table.insert(antiFlingConnections, Players.PlayerAdded:Connect(onPlayer))
        table.insert(antiFlingConnections, Players.PlayerRemoving:Connect(function(p) playerCache[p] = nil end))
        
        for _, p in ipairs(Players:GetPlayers()) do onPlayer(p) end

        table.insert(antiFlingConnections, RunService.Stepped:Connect(function()
            for _, data in pairs(playerCache) do
                for i = #data.parts, 1, -1 do
                    local p = data.parts[i]
                    if p and p.Parent then
                        p.CanCollide = false
                    else
                        table.remove(data.parts, i)
                    end
                end
            end
            
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and not obj.Anchored and not isAPlayerPart(obj) then
                    if obj.AssemblyLinearVelocity.Magnitude > 50 or obj.AssemblyAngularVelocity.Magnitude > 45 then
                        obj.CanCollide = false
                        obj.Transparency = 0.7
                    else
                        if obj.Transparency == 0.7 then
                            obj.CanCollide = true
                            obj.Transparency = 0
                        end
                    end
                elseif obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid") then
                    for _, p in ipairs(obj:GetDescendants()) do
                        if p:IsA("BasePart") and not p.Anchored then
                            if p.AssemblyLinearVelocity.Magnitude > 50 or p.AssemblyAngularVelocity.Magnitude > 45 then
                                p.CanCollide = false
                                p.Transparency = 0.7
                            else
                                if p.Transparency == 0.7 then
                                    p.CanCollide = true
                                    p.Transparency = 0
                                end
                            end
                        end
                    end
                end
            end
        end))

        table.insert(antiFlingConnections, RunService.Heartbeat:Connect(function(dt)
            lastUpdate = lastUpdate + dt
            if lastUpdate < 0.1 then return end
            lastUpdate = 0
            local suspectCount = 0
            for _, data in pairs(playerCache) do
                if data.root and data.root.Parent then
                    if data.root.AssemblyLinearVelocity.Magnitude >= 80 or data.root.AssemblyAngularVelocity.Magnitude >= 45 then
                        suspectCount = suspectCount + 1
                    end
                end
            end
            if CounterLabel and CounterLabel.Parent then
                CounterLabel.Text = " " .. tostring(suspectCount)
            end
        end))
    else
        for _, conn in ipairs(antiFlingConnections) do
            conn:Disconnect()
        end
        antiFlingConnections = {}
        if antiFlingGui then
            antiFlingGui:Destroy()
            antiFlingGui = nil
        end
        playerCache = {}
    end
end

local function createUI(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        inst[k] = v
    end
    return inst
end

local function addCorner(parent, radius)
    return createUI("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
end

local function addPadding(parent, top, bottom, left, right)
    return createUI("UIPadding", {
        PaddingTop = UDim.new(0, top),
        PaddingBottom = UDim.new(0, bottom),
        PaddingLeft = UDim.new(0, left),
        PaddingRight = UDim.new(0, right),
        Parent = parent
    })
end

local function buildLuayUI(parentPage)
    if parentPage:FindFirstChild("MainFrameLuay") then return end

    local MainFrameLuay = createUI("Frame", {
        Name = "MainFrameLuay",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = parentPage
    })

    local Scroll = createUI("ScrollingFrame", {
        Name = "ScrollingFrame",
        Size = UDim2.new(1, 0, 0, 500),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 9999),
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        Parent = MainFrameLuay
    })

    local ScrollLayout = createUI("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 20),
        Parent = Scroll
    })
    addPadding(Scroll, 20, 20, 20, 20)

    local TopSection = createUI("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = Scroll
    })

    local TitleLabel = createUI("TextLabel", {
        Size = UDim2.new(0, 140, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "LUAYRBX",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopSection
    })

    createUI("Frame", {
        Size = UDim2.new(0, 95, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Color3.fromRGB(46, 160, 85),
        BorderSizePixel = 0,
        Parent = TitleLabel
    })

    local ToggleAntiFlingBtn = createUI("TextButton", {
        Size = UDim2.new(0, 110, 0, 30),
        Position = UDim2.new(0, 140, 0.5, -15),
        BackgroundColor3 = isAntiFlingEnabled and Color3.fromRGB(46, 160, 85) or Color3.fromRGB(200, 50, 50),
        Text = isAntiFlingEnabled and "AntiFling: ON" or "AntiFling: OFF",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = TopSection
    })
    addCorner(ToggleAntiFlingBtn, 6)

    ToggleAntiFlingBtn.MouseButton1Click:Connect(function()
        isAntiFlingEnabled = not isAntiFlingEnabled
        ToggleAntiFlingBtn.Text = isAntiFlingEnabled and "AntiFling: ON" or "AntiFling: OFF"
        ToggleAntiFlingBtn.BackgroundColor3 = isAntiFlingEnabled and Color3.fromRGB(46, 160, 85) or Color3.fromRGB(200, 50, 50)
        toggleAntiFling(isAntiFlingEnabled)
    end)

    local NameInput = createUI("TextBox", {
        Size = UDim2.new(1, -260, 0, 30),
        Position = UDim2.new(0, 260, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        TextColor3 = Color3.fromRGB(200, 200, 200),
        PlaceholderText = "Name...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        Text = "",
        Parent = TopSection
    })
    addCorner(NameInput, 6)
    addPadding(NameInput, 0, 0, 10, 10)

    local EditorSection = createUI("Frame", {
        Size = UDim2.new(1, 0, 0, 250),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Parent = Scroll
    })

    local EditorContainer = createUI("Frame", {
        Size = UDim2.new(1, -165, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Parent = EditorSection
    })
    addCorner(EditorContainer, 8)

    local EditorInput = createUI("TextBox", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        PlaceholderText = "Thank you for using luay.\nLuay site: https://luay.gt.tc",
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        Font = Enum.Font.Code,
        TextSize = 14,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ClearTextOnFocus = false,
        MultiLine = true,
        Parent = EditorContainer
    })
    addPadding(EditorInput, 10, 10, 10, 10)

    local ButtonsContainer = createUI("Frame", {
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -150, 0, 0),
        BackgroundTransparency = 1,
        Parent = EditorSection
    })
    createUI("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = ButtonsContainer
    })

    local btnExecute = createUI("TextButton", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(46, 160, 85),
        Text = "EXECUTE",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        LayoutOrder = 1,
        Parent = ButtonsContainer
    })
    addCorner(btnExecute, 8)

    local btnSave = createUI("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        Text = "SAVE",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        LayoutOrder = 2,
        Parent = ButtonsContainer
    })
    addCorner(btnSave, 8)

    local btnCopy = createUI("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        Text = "COPY",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        LayoutOrder = 3,
        Parent = ButtonsContainer
    })
    addCorner(btnCopy, 8)

    local Divider = createUI("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        LayoutOrder = 3,
        Parent = Scroll
    })

    local SearchInput = createUI("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        TextColor3 = Color3.fromRGB(200, 200, 200),
        PlaceholderText = "Search...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        Text = "",
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 4,
        Parent = Scroll
    })
    addCorner(SearchInput, 6)
    addPadding(SearchInput, 0, 0, 10, 10)

    local SavesGridContainer = createUI("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 5,
        Parent = Scroll
    })

    local GridLayout = createUI("UIGridLayout", {
        CellSize = UDim2.new(0.5, -10, 0, 140),
        CellPadding = UDim2.new(0, 12, 0, 12),
        SortOrder = Enum.SortOrder.Name,
        Parent = SavesGridContainer
    })

    GridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SavesGridContainer.Size = UDim2.new(1, 0, 0, GridLayout.AbsoluteContentSize.Y)
    end)

    local function refreshSavesList(filterText)
        for _, child in ipairs(SavesGridContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        filterText = filterText and string.lower(filterText) or ""

        if not listfiles then
            return
        end

        local success, files = pcall(function()
            return listfiles(savesPath)
        end)
        if not success then
            return
        end

        for _, filePath in ipairs(files) do
            local fileName = filePath:match("([^/\\]+)$")

            if fileName and (filterText == "" or string.find(string.lower(fileName), filterText)) then
                local Card = createUI("Frame", {
                    Name = fileName,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    BorderSizePixel = 0,
                    Parent = SavesGridContainer
                })
                addCorner(Card, 8)
                addPadding(Card, 10, 10, 10, 10)

                createUI("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8),
                    Parent = Card
                })

                local NameLbl = createUI("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = fileName:gsub("%.lua$", ""),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = 1,
                    Parent = Card
                })

                local btnCardExec = createUI("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Color3.fromRGB(46, 160, 85),
                    Text = "EXECUTE",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    LayoutOrder = 2,
                    Parent = Card
                })
                addCorner(btnCardExec, 6)

                local btnCardDel = createUI("TextButton", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
                    Text = "DELETE",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    LayoutOrder = 3,
                    Parent = Card
                })
                addCorner(btnCardDel, 6)

                btnCardExec.MouseButton1Click:Connect(function()
                    if readfile then
                        local successRead, code = pcall(function()
                            return readfile(filePath)
                        end)
                        if successRead and code then
                            local func, err = loadstring(code)
                            if func then
                                task.spawn(func)
                            end
                        end
                    end
                end)

                btnCardDel.MouseButton1Click:Connect(function()
                    if delfile then
                        pcall(function()
                            delfile(filePath)
                        end)
                        refreshSavesList(SearchInput.Text)
                    end
                end)
            end
        end
    end

    btnExecute.MouseButton1Click:Connect(function()
        local code = EditorInput.Text
        if code and code ~= "" then
            local func, err = loadstring(code)
            if func then
                task.spawn(func)
            end
        end
    end)

    btnCopy.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(EditorInput.Text)
        end
    end)

    btnSave.MouseButton1Click:Connect(function()
        local fileName = NameInput.Text
        local code = EditorInput.Text

        if fileName == "" or code == "" then return end
        if not fileName:match("%.lua$") then
            fileName = fileName .. ".lua"
        end

        local fullPath = savesPath .. "/" .. fileName

        if isfile and writefile then
            if not isfile(fullPath) then
                pcall(function()
                    writefile(fullPath, code)
                end)
                NameInput.Text = ""
                refreshSavesList(SearchInput.Text)
            else
                NameInput.Text = "Already exists!"
                task.wait(1.5)
                if NameInput.Text == "Already exists!" then
                    NameInput.Text = fileName:gsub("%.lua$", "")
                end
            end
        end
    end)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        refreshSavesList(SearchInput.Text)
    end)

    refreshSavesList()
end

task.spawn(function()
    local RobloxGui = CoreGui:WaitForChild("RobloxGui")
    local SettingsShield = RobloxGui:WaitForChild("SettingsClippingShield"):WaitForChild("SettingsShield")
    local MenuContainer = SettingsShield:WaitForChild("MenuContainer")
    local Page = MenuContainer:WaitForChild("Page")

    task.spawn(function()
        local HubBarContainer = Page:WaitForChild("HubBar")
            :WaitForChild("TabHeaderContainer")
            :WaitForChild("HubBarContainer")

        local HelpTab = HubBarContainer:WaitForChild("HelpTab")

        local function enforceText(instance, newText)
            if instance then
                instance.Text = newText
                instance:GetPropertyChangedSignal("Text"):Connect(function()
                    if instance.Text ~= newText then
                        instance.Text = newText
                    end
                end)
            end
        end
-- === 571 === --
        local TabLabel = HelpTab:WaitForChild("TabLabel", 10)
        if TabLabel then
            local icon = TabLabel:WaitForChild("Icon", 10)
            local title = TabLabel:WaitForChild("Title", 10)

            enforceText(icon, "")
            enforceText(title, "LuayRBX")
        end
    end)

    task.spawn(function()
        local PageViewInnerFrame = Page:WaitForChild("PageViewClipper")
            :WaitForChild("PageView")
            :WaitForChild("PageViewInnerFrame")

        local function monitorPage(pageInst)
            if pageInst.Name ~= "Page" then return end

            local function checkAndDeleteHelp()
                if pageInst:FindFirstChild("DividerContainer") then return end

                local helpContainer = pageInst:FindFirstChild("HelpPageContainer")
                if helpContainer then
                    helpContainer:Destroy()
                end

                buildLuayUI(pageInst)
            end

            checkAndDeleteHelp()

            pageInst.ChildAdded:Connect(function(child)
                task.defer(function()
                    if child.Name == "HelpPageContainer" then
                        checkAndDeleteHelp()
                    end
                end)
            end)
        end

        for _, child in ipairs(PageViewInnerFrame:GetChildren()) do
            monitorPage(child)
        end

        PageViewInnerFrame.ChildAdded:Connect(monitorPage)
    end)
end)
