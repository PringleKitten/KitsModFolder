-- Pun intended //// Found by LazyRemixMan
function onCreate()
    for i = 0, getProperty("unspawnNotes.length") - 1 do
        if getProperty("unspawnNotes["..i.."].noteType") == "lazynote" then
          setProperty("unspawnNotes["..i.."].multSpeed", 0.7) -- You can change the 0.2 to anything. Notes have a multSpeed of 1 as the default.
        end
    end
end