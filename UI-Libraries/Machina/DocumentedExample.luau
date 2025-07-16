-- Getting the module, that's a first!

local HttpRequest = request or http_request or http and http.request or syn and syn.request
local ModuleData = HttpRequest({Method = "GET", Url = "https://raw.githubusercontent.com/KadeTheExploiter/Uncategorized-Scripts/refs/heads/main/UI-Libraries/Machina/Module.luau"})
local GuiLibrary = loadstring(ModuleData.Body)()

-- GuiLibrary:Load(<Title: string>, <Theme: string>)
-- Avaliable themes are "Dark" and "White".
-- Returns a table with functions and the ScreenGui.

local MainFrame, ScreenGui = GuiLibrary:Load("Gui Name", "Dark")

-- Alternatively, you can use MainFrame:GetScreenGui() to get the ScreenGui.

print(MainFrame:GetScreenGui().Parent)

-- MainFrame:NewTabEntry(<Name: string>, <CustomImage: string?>)
-- Padding auto-adjusts itself when CustomImage entry is nil.
-- Creates a new container for items, returns a table with functions.

local Tabs = {
	Home = MainFrame:NewTabEntry("Home Page", "rbxassetid://12974400533"),
	Information = MainFrame:NewTabEntry("Information")
}

--[[ 
	All Objects return another set of functions in a table, every Object has:
	- Object:Destroy(),
	- Object:UpdateText(<NewText: string>)
	- Object:UpdateDescription(<NewDescription: string>)

	However, some objects will have their custom functions, but we will get to them later.
]]

-- TabContainer:NewButtonEntry(<Title: string?>, <Description: string?>, <Callback: (...any) -> (...any)> 
-- Creates a button object in the container.

local HomeButton; HomeButton = Tabs.Home:NewButtonEntry("Notify me!", "Notifies you with something.", function()
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Notified!"})
	HomeButton:UpdateText("Notified!")

	task.delay(0.25, HomeButton.UpdateText, HomeButton, "Notify me!")
end)

-- TabContainer:NewToggleEntry(<Title: string?>, <Description: string?>, <Callback: (...any) -> boolean> 
-- Creates a toggle object in the container, callback returns a boolean.

local HomeToggle = Tabs.Home:NewToggleEntry("Hii!!", "Toggle to explode!!", false, function(Bool: boolean)
	print(Bool and "Checked!" or "Unchecked.")
end)

-- TabContainer:NewLabelEntry(<Title: string>, <Description: string?>, <Priority: string?>)
-- Creates a new Label object in the container, depending on its mode it will display differently, by default it's "Note"

local DetectionStatusLabel = Tabs.Home:NewLabelEntry(
	"You won't be detected!", 
	"Detection on all devices!!!", 
	"Positive"
)

--[[ Priority Options:
	"Note" - Standard, Yellow themed, Icon is a green note.
	"Info" - Blue themed, Icon is a blue information symbol.
	"Positive" - Green themed, Icon is a green check.
	"Warning" - Orange themed, Icon is a warning sign, Title becomes slightly bolder.
	"Danger" - Red themed, Icon is an alarm icon, Title becomes bold.
]]

-- Label Objects do come with their own set of functions, UpdatePriority, which changes the colors and icon smoothly, and UpdateEverything.
-- LabelObject:UpdatePriority(<NewPriority: string>)
-- LabelObject:UpdateEverything(<NewText: string>, <NewDescription: string>, <NewPriority: string>)

DetectionStatusLabel:UpdateEverything("Severe Warning!", "The anti tamper has been triggered.", "Danger")

-- TabContainer:NewTextboxEntry(<Title: string?>, <Description: string?>, <Callback: (...any) -> string>
-- Creates a new Textbox object in the container, callback returns a string.
-- Clicking on the Textbox automatically captures the focus to the textbox.
local TextboxPrinter = Tabs.Home:NewTextboxEntry("Print out your text!", "Simple as that!", function(Text)
	print(Text)
end)

-- TabContainer:NewDropdownEntry(<Title: string?>, <Description: string?>, <Items: {any}>, <DefaultIndex: number?>, <Callback: (...any) -> string>)
-- Creates a new Dropdown object in the container, callback returns the selected object / value.

--[[ 
	The Items table supports multiple formats, You can also mix these formats freely in a single table, The dropdown will automatically parse them in a readable way:

	A simple array of values, whenever they are strings, instances, booleans etc. :
		- { "Option A", "Option B", "Option C", game.Players.LocalPlayer, 12, true}

	Or a nested table with metadata:
		- Syntax: {<Value: any>, <EntryTitle: string?>, <EntryDescription: string?}
		- Example: {Workspace.Terrain, "Terrain", "Terrain yayaya! I love terrain!"}
]]

local DropdownItems = {
    {game.Players.LocalPlayer, "LocalPlayer", "Located in Players."},
    {workspace.CurrentCamera, "CurrentCamera", "That's your camera."},
    workspace.Terrain,
    {game.ReplicatedStorage}
}

local HomeDropdown = Tabs.Home:NewDropdownEntry("Instance Selection", "Select Your Instance.", DropdownItems, 1, function(Selected)
	warn("Your choice was:", Selected)
end)

-- Dropdown objects come with their own single function.
-- HomeDropdown:UpdateList(<NewListOfItems: {any}>), Purges previous entries and creates new ones.

-- Yes, that does work.
HomeDropdown:UpdateList({{workspace.Terrain, "Bad move...", "All done!"}, 1, {1}, {"1"}, {1, "1", "1"}, 1, "1"})

-- TabContainer:NewSliderEntry(<Title: string?>, <Description: string?>, <Minimum: number>, <Maximum: number>, <Default: number?>, <Callback: (...any) -> number>)
-- Creates a new Slider object in the container, callback returns a number.

local ExperienceSlider = Tabs.Home:NewSliderEntry("Select Your Level!", "The bigger the numbers, the harder.", 10, 100, 60, function(Numbers)
	print(Numbers)
end)

-- SliderEntry has also their own set of functions.
-- ExperienceSlider:UpdateMaximum(<NewMaximum: number>), Which updates the Maximum value the slider can get.
-- ExperienceSlider:UpdateMinimum(<NewMinimum: number>), Which does the same, but for Minimum value.
