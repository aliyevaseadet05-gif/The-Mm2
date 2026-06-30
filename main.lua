-- TRH Visuals - Main Loader Script
-- Базовый URL для загрузки модулей из твоего репозитория
local GithubURL = "https://raw.githubusercontent.com/aliyevaseadet05-gif/The-Mm2/refs/heads/main/"

-- Инициализация библиотеки Rayfield UI (отлично подходит для Delta)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создание главного окна (вверху будет кнопка сворачивания в кружок)
local Window = Rayfield:CreateWindow({
    Name = "TRH Visuals | Tap to minimize",
    LoadingTitle = "TRH Visuals Loading...",
    LoadingSubtitle = "by Miri G.",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TRH_Visuals_Configs",
        FileName = "TRH_Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Установка фиолетовой темы по умолчанию
Rayfield:ChangeTheme("Purple")

-------------------------------------------------------------------------------
-- [ВКЛАДКА: ВЫБОР ИГРЫ (GAMES)]
-------------------------------------------------------------------------------
local GamesTab = Window:CreateTab("Games", 4483362458)

local SelectedPlace = "Murder Mystery 2" -- Значение по умолчанию
local PlaceDropdown = GamesTab:CreateDropdown({
    Name = "Select Current Place",
    Options = {"Murder Mystery 2", "Forsaken", "Brookhaven"},
    CurrentOption = {"Murder Mystery 2"},
    MultipleOptions = false,
    Callback = function(Options)
        SelectedPlace = Options[1]
        Rayfield:Notify({
            Title = "Place Selected",
            Content = "You selected: " .. SelectedPlace,
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

GamesTab:CreateButton({
    Name = "Load Script for Selected Place",
    Callback = function()
        if SelectedPlace == "Murder Mystery 2" then
            -- Загружает mm2.lua из твоего репозитория
            loadstring(game:HttpGet(GithubURL .. "mm2.lua"))()
        elseif SelectedPlace == "Forsaken" then
            -- Загружает sasaken.lua (как ты указал в названии файла)
            loadstring(game:HttpGet(GithubURL .. "sasaken.lua"))()
        elseif SelectedPlace == "Brookhaven" then
            -- Загружает Brookhaven.lua
            loadstring(game:HttpGet(GithubURL .. "Brookhaven.lua"))()
        else
            Rayfield:Notify({Title = "Error", Content = "Invalid place selected!", Duration = 3})
        end
    end,
})

-------------------------------------------------------------------------------
-- [ВКЛАДКА: ЗАДАНИЯ (TASKS)]
-------------------------------------------------------------------------------
local TasksTab = Window:CreateTab("Tasks", 4483345998)

TasksTab:CreateLabel("Current Game Tasks:")
local TaskList = TasksTab:CreateLabel("No tasks loaded. Please load a game script first.")

-- Глобальная функция для обновления списка заданий из других файлов
_G.UpdateTRHTasks = function(text)
    TaskList:Set(text)
end

-------------------------------------------------------------------------------
-- [ВКЛАДКА: ВИЗУАЛЫ (VISUALS)]
-------------------------------------------------------------------------------
local VisualsTab = Window:CreateTab("Visuals", 4483354297)

-- Логика Fullbright
local Light = game:GetService("Lighting")
local OldAmbient = Light.Ambient
local OldColorShift_Top = Light.ColorShift_Top
local OldColorShift_Bottom = Light.ColorShift_Bottom

local FullbrightToggle = VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "FullbrightToggle",
    Callback = function(Value)
        if Value then
            Light.Ambient = Color3.fromRGB(255, 255, 255)
            Light.ColorShift_Top = Color3.fromRGB(255, 255, 255)
            Light.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        else
            Light.Ambient = OldAmbient
            Light.ColorShift_Top = OldColorShift_Top
            Light.ColorShift_Bottom = OldColorShift_Bottom
        end
    end,
})

-- Дополнительный визуал: Фиолетовый ESP на игроков
local ESPToggle = VisualsTab:CreateToggle({
    Name = "Player ESP (Visual)",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        _G.TRH_ESP_Enabled = Value
        while _G.TRH_ESP_Enabled do
            for _, player in pairs(game:GetService("Players"):GetChildren()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not player.Character.HumanoidRootPart:FindFirstChild("TRH_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "TRH_Highlight"
                        highlight.FillColor = Color3.fromRGB(138, 43, 226)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = player.Character
                    end
                end
            end
            task.wait(2)
        end
        if not Value then
            for _, player in pairs(game:GetService("Players"):GetChildren()) do
                if player.Character and player.Character:FindFirstChild("TRH_Highlight") then
                    player.Character.TRH_Highlight:Destroy()
                end
            end
        end
    end,
})

-------------------------------------------------------------------------------
-- [ВКЛАДКА: НАСТРОЙКИ (SETTINGS)]
-------------------------------------------------------------------------------
local SettingsTab = Window:CreateTab("Settings", 4483362748)

-- Переключатель языков (по умолчанию English)
SettingsTab:CreateDropdown({
    Name = "Language / Язык",
    Options = {"English", "Russian (Русский)", "German (Deutsch)", "Azerbaijani (Azərbaycan)"},
    CurrentOption = {"English"},
    MultipleOptions = false,
    Callback = function(Options)
        local lang = Options[1]
        if lang == "Russian (Русский)" then
            Rayfield:Notify({Title = "Язык", Content = "Интерфейс переведен на Русский", Duration = 2})
        elseif lang == "Azerbaijani (Azərbaycan)" then
            Rayfield:Notify({Title = "Dil", Content = "Dil Azərbaycan dilinə dəyişdirildi", Duration = 2})
        elseif lang == "German (Deutsch)" then
            Rayfield:Notify({Title = "Sprache", Content = "Sprache auf Deutsch geändert", Duration = 2})
        end
    end,
})

-- Кастомизация темы и анимаций ("Желейность")
SettingsTab:CreateDropdown({
    Name = "UI Theme & Jelly Mode",
    Options = {"Purple Default", "Arch Jelly Theme (Smooth)", "Dark Mode"},
    CurrentOption = {"Purple Default"},
    MultipleOptions = false,
    Callback = function(Options)
        if Options[1] == "Arch Jelly Theme (Smooth)" then
            Rayfield:ChangeTheme("Serpents") -- Плавная «желейная» тема
        elseif Options[1] == "Purple Default" then
            Rayfield:ChangeTheme("Purple")
        elseif Options[1] == "Dark Mode" then
            Rayfield:ChangeTheme("Default")
        end
    end,
})

-- Секция профиля в самом низу вкладки Settings
SettingsTab:CreateSection("User Profile")
local LocalPlayer = game.Players.LocalPlayer
local UserId = LocalPlayer.UserId
SettingsTab:CreateLabel("Logged in as: " .. LocalPlayer.Name)

-- Авто-определение плейса при запуске
local currentId = game.PlaceId
if currentId == 142823291 or currentId == 636821210 then
    PlaceDropdown:Set({"Murder Mystery 2"})
elseif currentId == 15312711116 then -- Сюда встанет реальный ID Forsaken
    PlaceDropdown:Set({"Fors
      
