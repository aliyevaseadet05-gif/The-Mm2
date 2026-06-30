print("[TRH] Brookhaven Module Loaded!")
Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:Notify({
    Title = "TRH Brookhaven",
    Content = "Brookhaven visual tools ready.",
    Duration = 3
})

if _G.UpdateTRHTasks then
    _G.UpdateTRHTasks("- Unlock House (Done)\n- Adopt a Pet")
end
