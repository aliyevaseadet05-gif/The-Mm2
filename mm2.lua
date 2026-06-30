print("[TRH] Murder Mystery 2 Module Loaded!")
Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:Notify({
    Title = "TRH MM2",
    Content = "Murder Mystery 2 scripts injected!",
    Duration = 3
})

-- Обновляем вкладку заданий в главном меню
if _G.UpdateTRHTasks then
    _G.UpdateTRHTasks("- Collect 10 Coins (In Progress)\n- Survive the Round (Not Done)\n- Complete Lobby Obby (Check)")
end

-- Сюда можно вписать любой чит-код специально для MM2 (например, показ убийцы)
