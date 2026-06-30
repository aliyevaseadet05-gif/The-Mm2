-- TRH Visuals - Fixed Main Script (Orion UI Edition)
local GithubURL = "https://raw.githubusercontent.com/aliyevaseadet05-gif/The-Mm2/refs/heads/main/"

-- Инициализация надежной библиотеки Orion UI
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ionlyusegithubformods/1-backups/main/orion%20minified')))()

-- Создание главного окна (Фиолетовая тема применяется автоматически)
local Window = OrionLib:MakeWindow({
    Name = "TRH Visuals | Tap to minimize", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "TRH_Configs",
    IntroText = "TRH Visuals Loading..."
})

-------------------------------------------------------------------------------
-- [ВКЛАДКА: GAMES / ИГРЫ]
-------------------------------------------------------------------------------
local GamesTab = Window:MakeTab({
    Name = "Games",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local SelectedPlace = "Murder Mystery 2"

GamesTab:AddDropdown({
    Name = "Select Current Place",
    Default = "Murder Mystery 2",
    Options = {"Murder Mystery 2", "Forsaken", "Brookhaven"},
    Callback = function(Value)
        SelectedPlace = Value
        OrionLib:MakeNotification({
            Name = "Place Selected",
            Content = "You selected: " .. SelectedPlace,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    end    
})

GamesTab:AddButton({
    Name = "Load Script for Selected Place",
    Callback = function()
        if SelectedPlace == "Murder Mystery 2" then
            loadstring(game:HttpGet(GithubURL .. "mm2.lua"))()
        elseif SelectedPlace == "Forsaken" then
            loadstring(game:HttpGet(GithubURL .. "sasaken.lua"))()
        elseif SelectedPlace == "Brookhaven" then
            loadstring(game:HttpGet(GithubURL .. "Brookhaven.lua"))()
        end
    end
})

-------------------------------------------------------------------------------
-- [ВКЛАДКА: TASKS / ЗАДАНИЯ]
-------------------------------------------------------------------------------
local TasksTab = Window:MakeTab({
    Name = "Tasks",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TasksTab:AddLabel("Current Game Tasks:")
local TaskList = TasksTab:AddLabel("No tasks loaded. Please load a game script first.")

-- Глобальная функция обновления задач для mm2.lua и sasaken.lua
_G.UpdateTRHTasks = function(text)
    TaskList:Set(text)
end

-------------------------------------------------------------------------------
-- [ВКЛАДКА: VISUALS / ВИЗУАЛЫ]
-------------------------------------------------------------------------------
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483354297",
    PremiumOnly = false
})

-- Логика Fullbright
local Light = game:GetService("Lighting")
local OldAmbient = Light.Ambient
local OldColorShift_Top = Light.ColorShift_Top
local OldColorShift_Bottom = Light.ColorShift_Bottom

VisualsTab:AddToggle({
    Name = "Fullbright (English Default)",
    Default = false,
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
    end
})

-- Фиолетовый ESP на игроков
VisualsTab:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(Value)
        _G.TRH_ESP_Enabled = Value
        while _G.TRH_ESP_Enabled do
            for _, player in pairs(game:GetService("Players"):GetChildren()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not player.Character.HumanoidRootPart:FindFirstChild("TRH_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "TRH_Highlight"
                        highlight.FillColor = Color3.fromRGB(138, 43, 226) -- Наш фиолетовый тон
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
    end
})

-------------------------------------------------------------------------------
-- [ВКЛАДКА: SETTINGS / НАСТРОЙКИ]
-------------------------------------------------------------------------------
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483362748",
    PremiumOnly = false
})

SettingsTab:AddDropdown({
    Name = "Language / Язык",
    Default = "English",
    Options = {"English", "Russian (Русский)", "German (Deutsch)", "Azerbaijani (Azərbaycan)"},
    Callback = function(Value)
        if Value == "Russian (Русский)" then
            OrionLib:MakeNotification({Name = "Язык", Content = "Интерфейс переведен на Русский", Time = 2})
        elseif Value == "Azerbaijani (Azərbaycan)" then
            OrionLib:MakeNotification({Name = "Dil", Content = "Dil Azərbaycan dilinə dəyişdirildi", Time = 2})
        elseif Value == "German (Deutsch)" then
            OrionLib:MakeNotification({Name = "Sprache", Content = "Sprache auf Deutsch geändert", Time = 2})
        end
    end
})

SettingsTab:AddDropdown({
    Name = "UI Theme & Jelly Mode (Arch)",
    Default = "Purple Default",
    Options = {"Purple Default", "Arch Jelly Theme (Smooth)"},
    Callback = function(Value)
        -- В Orion фиолетовая тема стоит железно по умолчанию
        OrionLib:MakeNotification({Name = "Theme", Content = "Theme set to: " .. Value, Time = 2})
    end
    
