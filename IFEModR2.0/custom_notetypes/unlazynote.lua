-- Pun intended //// Found by LazyRemixMan

function onCreate()
    for i = 0, getProperty("unspawnNotes.length") - 1 do
        if getProperty("unspawnNotes["..i.."].noteType") == "unlazynote" then
          setProperty("unspawnNotes["..i.."].multSpeed", 1.5) -- You can change the 0.2 to anything. Notes have a multSpeed of 1 as the default.
        end
    end
end