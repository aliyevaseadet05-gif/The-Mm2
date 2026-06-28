local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Основной контейнер
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomPremiumMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Главное Окно (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

--- ====================================================================
--- КРАСНАЯ ПОДСВЕТКА (Анимированное неоновое свечение)
--- ====================================================================
local glowEffect = Instance.new("Frame")
glowEffect.Name = "GlowEffect"
glowEffect.Size = UDim2.new(1, 4, 1, 4)
glowEffect.Position = UDim2.new(0, -2, 0, -2)
glowEffect.BackgroundColor3 = Color3.fromRGB(255, 0, 50) -- Ярко-красный
glowEffect.BackgroundTransparency = 0.6
glowEffect.BorderSizePixel = 0
glowEffect.ZIndex = mainFrame.ZIndex - 1
glowEffect.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 14)
glowCorner.Parent = glowEffect

-- Анимация "дыхания" подсветки (плавное изменение прозрачности)
local glowInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local glowTween = TweenService:Create(glowEffect, glowInfo, {BackgroundTransparency = 0.85})
glowTween:Play()

--- ====================================================================
--- СИСТЕМА СВОР АЧИВАНИЯ (Tap to Minimize)
--- ====================================================================
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 120, 0, 25)
minimizeBtn.Position = UDim2.new(0.5, -60, 0, -30) -- Над главным GUI
minimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
minimizeBtn.Text = "tap to minimize"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamMedium
minimizeBtn.TextSize = 11
minimizeBtn.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Маленькая круглая кнопка, которая появляется при сворачивании
local compactIcon = Instance.new("TextButton")
compactIcon.Name = "CompactIcon"
compactIcon.Size = UDim2.new(0, 50, 0, 50)
compactIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
compactIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 50) -- Красная стильная кнопка
compactIcon.Text = "★"
compactIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
compactIcon.Font = Enum.Font.GothamBold
compactIcon.TextSize = 24
compactIcon.Visible = false
compactIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 25) -- Идеальный круг
iconCorner.Parent = compactIcon

-- Логика плавного сворачивания и разворачивания
local isMinimized = false

local function toggleUI()
    isMinimized = not isMinimized
    if isMinimized then
        -- Анимация исчезновения главного GUI
        local t = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        t:Play()
        t.Completed:Connect(function()
            mainFrame.Visible = false
            compactIcon.Visible = true
        end)
    else
        -- Анимация появления главного GUI
        mainFrame.Visible = true
        compactIcon.Visible = false
        local t = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 320),
            BackgroundTransparency = 0
        })
        t:Play()
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleUI)
compactIcon.MouseButton1Click:Connect(toggleUI)

--- ====================================================================
--- СТРУКТУРА ВКЛАДОК И НАВИГАЦИЯ
--- ====================================================================
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 130, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sidebar

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -140, 1, -20)
container.Position = UDim2.new(0, 135, 0, 10)
container.BackgroundTransparency = 1
container.Parent = mainFrame

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 400)
    page.ScrollBarThickness = 2
    page.Visible = false
    page.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    pages[name] = page
    return page
end

local tabCount = 0
local function addTab(name)
    tabCount = tabCount + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 10 + (tabCount - 1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local page = createPage(name)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)

    return page
end

--- ====================================================================
--- СОЗДАНИЕ НЕОНОВЫХ КНОПОК И ЭЛЕМЕНТОВ
--- ====================================================================
local function addNeonToggle(page, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            -- Синее неоновое свечение при включении
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 120, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            -- Возврат к обычному состоянию
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(22, 22, 30),
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end
        callback(state)
    end)
end

--- ====================================================================
--- НАПОЛНЕНИЕ ВКЛАДОК
--- ====================================================================

-- 1. Вкладка Target
local targetPage = addTab("Target")

-- Поле ввода никнейма (Текстовое окно)
local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(1, -5, 0, 35)
nameInput.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
nameInput.Text = ""
nameInput.PlaceholderText = "Enter Username..."
nameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
nameInput.Font = Enum.Font.Gotham
nameInput.TextSize = 14
nameInput.Parent = targetPage

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = nameInput

addNeonToggle(targetPage, "Fling Target (UI State)", function(active)
    print("Состояние Fling кнопки:", active)
end)

addNeonToggle(targetPage, "Follow Behind (UI State)", function(active)
    print("Состояние Follow кнопки:", active)
end)

addNeonToggle(targetPage, "Fly Mode", function(active)
    print("Синий неон Fly активен:", active)
end)

addNeonToggle(targetPage, "Noclip Mode", function(active)
    print("Синий неон Noclip активен:", active)
end)

-- 2. Вкладка Skin
local skinPage = addTab("Skin")

addNeonToggle(skinPage, "Equip Headless (Visual Only)", function(active)
    print("Смена отображения головы:", active)
end)

addNeonToggle(skinPage, "Equip Korblox (Visual Only)", function(active)
    print("Смена отображения ноги:", active)
end)

-- 3. Вкладка World (Кастомная от себя для удобства)
local worldPage = addTab("World")

addNeonToggle(worldPage, "Fullbright (Max Light)", function(active)
    if active then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
    end
end)

-- Делаем первую страницу видимой по умолчанию
pages["Target"].Visible = true

-- Скрипт перетаскивания (Draggable GUI) для ПК и мобильных устройств
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UniformResourceIdentifier or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
