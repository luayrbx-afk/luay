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

local LuayLib = {}
LuayLib.Options = {
    ExcutorAndSavesTab = true,
    TabsSystem = true
}
LuayLib.ExecutorBuilt = false

local MainFrameLuay = createUI("Frame", {
    Name = "MainFrameLuay",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1
})

local TopSection = createUI("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Parent = MainFrameLuay
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

local TabsBar = createUI("ScrollingFrame", {
    Size = UDim2.new(1, -150, 1, 0),
    Position = UDim2.new(0, 150, 0, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = TopSection
})

local TabsLayout = createUI("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10),
    Parent = TabsBar
})

TabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabsBar.CanvasSize = UDim2.new(0, TabsLayout.AbsoluteContentSize.X, 0, 0)
end)

local PagesContainer = createUI("Frame", {
    Size = UDim2.new(1, 0, 1, -50),
    Position = UDim2.new(0, 0, 0, 50),
    BackgroundTransparency = 1,
    Parent = MainFrameLuay
})

local tabsList = {}

function LuayLib.CreateTab(nameInfo)
    local name = type(nameInfo) == "table" and nameInfo[1] or nameInfo
    
    local newPage = createUI("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 9999),
        Visible = false,
        Parent = PagesContainer
    })
    
    createUI("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 20),
        Parent = newPage
    })
    
    addPadding(newPage, 20, 20, 20, 20)
    
    local tabBtn = createUI("TextButton", {
        Size = UDim2.new(0, 100, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Parent = TabsBar
    })
    
    addCorner(tabBtn, 6)
    
    table.insert(tabsList, {Page = newPage, Button = tabBtn})
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabsList) do
            t.Page.Visible = (t.Page == newPage)
            t.Button.BackgroundColor3 = (t.Page == newPage) and Color3.fromRGB(46, 160, 85) or Color3.fromRGB(35, 35, 40)
        end
    end)
    
    if #tabsList == 1 then
        newPage.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(46, 160, 85)
    end
    
    return newPage
end

local function buildExecutorTab()
    local execPage = LuayLib.CreateTab("EXECUTOR")

    local NameInput = createUI("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        TextColor3 = Color3.fromRGB(200, 200, 200),
        PlaceholderText = "Name...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        Text = "",
        LayoutOrder = 1,
        Parent = execPage
    })
    addCorner(NameInput, 6)
    addPadding(NameInput, 0, 0, 10, 10)

    local EditorSection = createUI("Frame", {
        Size = UDim2.new(1, 0, 0, 250),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Parent = execPage
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
        Parent = execPage
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
        Parent = execPage
    })
    addCorner(SearchInput, 6)
    addPadding(SearchInput, 0, 0, 10, 10)

    local SavesGridContainer = createUI("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        LayoutOrder = 5,
        Parent = execPage
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

function LuayLib.config(opts)
    if opts.ExcutorAndSavesTab ~= nil then
        LuayLib.Options.ExcutorAndSavesTab = opts.ExcutorAndSavesTab
    end
    if opts.TabsSystem ~= nil then
        LuayLib.Options.TabsSystem = opts.TabsSystem
    end

    TabsBar.Visible = LuayLib.Options.TabsSystem
    if not LuayLib.Options.TabsSystem then
        TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    end

    if LuayLib.Options.ExcutorAndSavesTab and not LuayLib.ExecutorBuilt then
        LuayLib.ExecutorBuilt = true
        buildExecutorTab()
    end
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

                if not pageInst:FindFirstChild("MainFrameLuay") then
                    MainFrameLuay.Parent = pageInst
                end
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

return LuayLib
