# Bloom UI Library
- Credit when used.

![image](https://github.com/KadeTheExploiter/Uncategorized-Scripts/assets/140114827/03e6eda6-4d39-4c9e-8cd9-3b3b468537a2)

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/Uncategorized-Scripts/main/UI-Libraries/Bloom/UI.lua"))()
-- find icons here https://www.roblox.com/users/2050262468/inventory/#!/decals (make sure to get their textureid!)
local Main = Library:Create("Hello") -- Library:Create(<string: Name>, <Color3: DetailColor>, <Color3: TextColor>)
local TabH = Main.MakeTab("Home", 6023426922) -- Main.MakeTab(<string: Tab_Name>, <Int: Icon_Texture_ID>
local TabS = Main.MakeTab("Scripts", 6034837807)


local Sections = {
    ['Home'] = {
        Info = TabH.MakeSection("Tests"), -- Tab.MakeSection(<string: Section_Name>)
        Credits = TabH.MakeSection("Credits"),
    },
    ['Scripts'] = {
        Free = TabS.MakeSection("Free"),
    }
}

local Info = Sections.Home.Info
Info.Label("Welcome!") -- Section.Label(<string: Text>) / Label.UpdateLabel(<string: UpdatedText>)
Info.Button("Check this out!", function() -- Section.Button(<string: Text>, <function: Callback>)
    print("Fire!")
end)
Info.Textbox("Type anything!", function(String) -- Section.Textbox(<string: Text>, <function: Callback>)
    warn(String)
end)
Info.Toggle("Toggle me!", false, function(Bool)  -- Section.Toggle(<string: Text>, <boolean: DefaultBool>, <function: Callback>)
    print(Bool)
end)
Info.Slider("Slide me!", 0, 100, function(Int)  -- Section.Slider(<string: Text>, <int: MinValue>, <int: MaxValue>, <function: Callback>)
    print(Int)
end)
Info.Dropdown("Pick anything!", {"Red", "Yellow", "Orange"}, function(String) -- Section.Dropdown(<string: Text>, <table: Table>, <function: Callback>)
    print(String)
end)
```
