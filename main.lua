-- Проверяем, что скрипт запущен в правильном окружении
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 1. Создание основного контейнера UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernMenu_V1"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Главная панель (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 550, 0, 350)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- Темный стильный фон
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

-- 3. Боковое меню для вкладок (Sidebar)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 14)
sidebarCorner.Parent = sidebar

-- Ограничитель, чтобы углы справа у боковой панели не скруглялись внутрь основного меню
local sidebarFix = Instance.new("Frame")
sidebarFix.Size = UDim2.new(0, 20, 1, 0)
sidebarFix.Position = UDim2.new(1, -20, 0, 0)
sidebarFix.BackgroundColor3 = sidebar.BackgroundColor3
sidebarFix.BorderSizePixel = 0
sidebarFix.Parent = sidebar

-- 4. Заголовок меню
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "PROJECT UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = sidebar

-- 5. Контейнер для контента вкладок
local container = Instance.new("Frame")
container.Name = "ContentContainer"
container.Size = UDim2.new(1, -160, 1, -20)
container.Position = UDim2.new(0, 155, 0, 10)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Список всех страниц
local pages = {}
local currentTab = nil

-- Функция для создания страницы
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    pages[name] = page
    return page
end

-- Функция переключения вкладок
local function showPage(name)
    for _, page in pairs(pages) do
        page.Visible = false
    end
    if pages[name] then
        pages[name].Visible = true
    end
end

-- 6. Функция создания красивой кнопки в меню
local buttonCount = 0
local function createMenuButton(text, pageName)
    buttonCount = buttonCount + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 50 + (buttonCount * 40))
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        showPage(pageName)
    end)
end

-- 7. Функция добавления интерактивных элементов (кнопок действий) внутрь страниц
local function addActionButton(parentPage, text, callback)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(1, -10, 0, 40)
    actionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    actionBtn.Text = text
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.Font = Enum.Font.Gotham
    actionBtn.TextSize = 14
    actionBtn.Parent = parentPage

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = actionBtn

    actionBtn.MouseButton1Click:Connect(callback)
end

--- ====================================================================
--- СБОРКА ИНТЕРФЕЙСА И НАПОЛНЕНИЕ ВКЛАДОК
--- ====================================================================

-- Создаем страницы
local innocentPage = createPage("Innocent")
local sheriffPage   = createPage("Sheriff")
local murdererPage  = createPage("Murderer")

-- Создаем кнопки переключения в боковой панели
createMenuButton("😇 Innocent", "Innocent")
createMenuButton("🤠 Sheriff", "Sheriff")
createMenuButton("🔪 Murderer", "Murderer")

-- Наполнение вкладки Innocent
addActionButton(innocentPage, "Teleport to Lobby", function()
    print("Логика: Телепортация игрока в безопасную зону лобби.")
end)

addActionButton(innocentPage, "Coin Collector (Status)", function()
    print("Логика: Проверка доступных элементов на карте.")
end)

-- Наполнение вкладки Sheriff
addActionButton(sheriffPage, "Track Target", function()
    print("Логика: Подсветка текущих целей или параметров окружения.")
end)

-- Наполнение вкладки Murderer
addActionButton(murdererPage, "Custom Overlay Notification", function()
    print("Логика: Вывод красивого кастомного уведомления вверху экрана.")
end)

-- По умолчанию открываем первую вкладку
showPage("Innocent")

print("Интерфейс успешно инициализирован и загружен!")
