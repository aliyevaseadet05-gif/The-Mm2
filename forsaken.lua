print("[TRH] Forsaken Module Loaded!")
Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:Notify({
    Title = "TRH Forsaken",
    Content = "Forsaken settings applied!",
    Duration = 3
})

if _G.UpdateTRHTasks then
    _G.UpdateTRHTasks("- Complete Daily Dungeon\n- Upgrade Weapon to Level 5")
end
