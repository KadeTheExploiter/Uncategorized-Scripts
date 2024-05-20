# Reaver / Gelatek UI
- Please credit when used

![image](https://github.com/KadeTheExploiter/Uncategorized-Scripts/assets/140114827/d148f8c1-48df-4e65-b442-424b300442fc)

# Cannot be bothered to do explain this one for now so take sample from this (There are more functions in the code like dropdowns etc.)

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/Uncategorized-Scripts/main/UI-Libraries/Reaver/UI.lua"))()
local Main = Library:Create("HubName", "Welcome to the underground")

local HomeTab = Main:MakeTab("Home")
local ReanimTab = Main:MakeTab("ReanimTab")
local ScriptsTab = Main:MakeTab("Scripts")
local AnimsTab = Main:MakeTab("Animations")

local Playing = false
AnimsTab:MakeLabel("ae")

AnimsTab:MakeTextBox("Custom Anim", function(Text)
    PlayAnimation(Text)
end)

AnimsTab:MakeButton("Freestylin'", function()
    PlayAnimation(4432024917, "GelatekHub/Animations/Freestylin.mp3")
end)
```
