# Machina
<img width="646" height="530" alt="image" src="https://github.com/user-attachments/assets/19ae680d-b1c6-46bc-8213-a859d07f4f46" />

# Features:
- Resizing
- Maximizing and Minimizing
- A lot of eye candy.
- Fairly decent codebase
- Lots of customization.
- Licensing: BSD-3

```lua
-- For Details, check https://github.com/KadeTheExploiter/Uncategorized-Scripts/blob/main/UI-Libraries/Machina/DocumentedExample.luau
local HttpRequest = request or http_request or http and http.request or syn and syn.request
local ModuleData = HttpRequest({Method = "GET", Url = "https://raw.githubusercontent.com/KadeTheExploiter/Uncategorized-Scripts/refs/heads/main/UI-Libraries/Machina/Module.luau"})
local GuiLibrary = loadstring(ModuleData.Body)()

local MainFrame, ScreenGui = GuiLibrary:Load("Gui Name", "Dark")

print(MainFrame:GetScreenGui().Parent)

local Tabs = {
	Home = MainFrame:NewTabEntry("Home Page", "rbxassetid://12974400533"),
	Information = MainFrame:NewTabEntry("Information")
}

local HomeButton; HomeButton = Tabs.Home:NewButtonEntry("Notify me!", "Notifies you with something.", function()
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Notified!"})
	HomeButton:UpdateText("Notified!")

	task.delay(0.25, HomeButton.UpdateText, HomeButton, "Notify me!")
end)

local HomeToggle = Tabs.Home:NewToggleEntry("Hii!!", "Toggle to explode!!", false, function(Bool: boolean)
	print(Bool and "Checked!" or "Unchecked.")
end)

local DetectionStatusLabel = Tabs.Home:NewLabelEntry(
	"You won't be detected!", 
	"Detection on all devices!!!", 
	"Positive"
)

DetectionStatusLabel:UpdateEverything("Severe Warning!", "The anti tamper has been triggered.", "Danger")

local TextboxPrinter = Tabs.Home:NewTextboxEntry("Print out your text!", "Simple as that!", function(Text)
	print(Text)
end)

local DropdownItems = {
    {game.Players.LocalPlayer, "LocalPlayer", "Located in Players."},
    {workspace.CurrentCamera, "CurrentCamera", "That's your camera."},
    workspace.Terrain,
    {game.ReplicatedStorage}
}

local HomeDropdown = Tabs.Home:NewDropdownEntry("Instance Selection", "Select Your Instance.", DropdownItems, 1, function(Selected)
	warn("Your choice was:", Selected)
end)

HomeDropdown:UpdateList({{workspace.Terrain, "Bad move...", "All done!"}, 1, {1}, {"1"}, {1, "1", "1"}, 1, "1"})

local ExperienceSlider = Tabs.Home:NewSliderEntry("Select Your Level!", "The bigger the numbers, the harder.", 10, 100, 60, function(Numbers)
	print(Numbers)
end)
```
