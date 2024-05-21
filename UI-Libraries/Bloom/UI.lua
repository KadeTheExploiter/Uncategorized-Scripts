-- PinkGUI by gelatek#9889 / source code recovered by TimedMarch#3330

local Library = {}
local DefaultColor = Color3.fromRGB(255, 224, 242)
local FontColor = Color3.new(244,244,244)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")


local function TweenTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {Transparency= Property["Transparency"]}):Play()
	return Tween
end
local function TweenBackgroundTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {BackgroundTransparency= Property["BackgroundTransparency"]}):Play()
	return Tween
end
local function TweenImageTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {ImageTransparency= Property["ImageTransparency"]}):Play()
	return Tween
end
local function TweenTextTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {TextTransparency= Property["TextTransparency"]}):Play()
	return Tween
end
local function TweenImageColor(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {ImageColor3= Property["ImageColor3"]}):Play()
	return Tween
end
local function TweenTextColor(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {TextColor3= Property["TextColor3"]}):Play()
	return Tween
end
local function TweenBackgroundColor(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {BackgroundColor3= Property["BackgroundColor3"]}):Play()
	return Tween
end
local function TweenRotateFrame(Object, RotateBy)
	local Tween = TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 0), {Rotation= RotateBy}):Play()
	return Tween
end

function Library:Create(Name, Color, FontColor2)
	DefaultColor = Color or Color3.fromRGB(255, 224, 242)
	FontColor = FontColor2 or Color3.fromRGB(244,244,244)
	local Pinkware = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local MainCorner = Instance.new("UICorner")
	local SideBar = Instance.new("Frame")
	local SiderBarCorner = Instance.new("UICorner")
	local SelectedHighlight = Instance.new("TextLabel")
	local SelectedHighlightCorner = Instance.new("UICorner")
	local TabList = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Shadow = Instance.new("ImageLabel")
	local TabFolder = Instance.new("Folder")


	Pinkware.Name = "Pinkware"
	local cloneref = cloneref or function(x) return x end
	Pinkware.Parent = cloneref(game:GetService("CoreGui"))

	Main.Name = "Main"
	Main.Parent = Pinkware
	Main.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
	Main.Position = UDim2.new(0.321062028, 0, 0.315467715, 0)
	Main.Size = UDim2.new(0, 541, 0, 361)

	MainCorner.CornerRadius = UDim.new(0, 4)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = Main

	SideBar.Name = "SideBar"
	SideBar.Parent = Main
	SideBar.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
	SideBar.BorderSizePixel = 0
	SideBar.ClipsDescendants = true
	SideBar.Size = UDim2.new(0, 50, 0, 361)

	SiderBarCorner.CornerRadius = UDim.new(0, 4)
	SiderBarCorner.Name = "SiderBarCorner"
	SiderBarCorner.Parent = SideBar

	SelectedHighlight.Name = "SelectedHighlight"
	SelectedHighlight.Parent = SideBar
	SelectedHighlight.BackgroundColor3 = DefaultColor
	SelectedHighlight.Position = UDim2.new(0.92, 0, -0.15, 0)
	SelectedHighlight.Size = UDim2.new(0, 4, 0, 35)
	SelectedHighlight.Font = Enum.Font.SourceSans
	SelectedHighlight.Text = " "
	SelectedHighlight.TextColor3 = Color3.fromRGB(0, 0, 0)
	SelectedHighlight.TextSize = 14.000

	SelectedHighlightCorner.CornerRadius = UDim.new(0, 12)
	SelectedHighlightCorner.Name = "SelectedHighlightCorner"
	SelectedHighlightCorner.Parent = SelectedHighlight

	TabList.Name = "TabList"
	TabList.Parent = SideBar
	TabList.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
	TabList.BackgroundTransparency = 1.000
	TabList.BorderSizePixel = 0
	TabList.Size = UDim2.new(0, 50, 0, 361)

	Title.Name = "Title"
	Title.Parent = Main
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.123844735, 0, 0.0332409963, 0)
	Title.Size = UDim2.new(0, 389, 0, 23)
	Title.Font = Enum.Font.GothamBold
	Title.Text = Name or "the vbuck currency is soo good"
	Title.TextColor3 = Color3.fromRGB(243, 243, 243)
	Title.TextSize = 17.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Shadow.Name = "Shadow"
	Shadow.Parent = Main
	Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Shadow.BackgroundTransparency = 1.000
	Shadow.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Shadow.Position = UDim2.new(-0.0536044352, 0, -0.0554016605, 0)
	Shadow.Size = UDim2.new(0, 598, 0, 400)
	Shadow.ZIndex = -1
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = DefaultColor

	TabFolder.Name = "TabFolder"
	TabFolder.Parent = Main
	do --// Dragging
		local dragToggle
		local dragSpeed = 15 -- You can edit this.
		local dragInput
		local dragStart
		local dragPos
		local startPos
		local inputchanged
		local function updateInput(input)
			local Delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			--game:GetService("TweenService"):Create(Main, TweenInfo.new(.25), {Position = Position}):Play()
			Main.Position = Position
		end

		Main.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragToggle = true
				dragStart = input.Position
				startPos = Main.Position
				input.Changed:Connect(function()
					if (input.UserInputState == Enum.UserInputState.End) then
						dragToggle = false
					end
				end)
			end
		end)

		Main.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				dragInput = input
			end
		end)

		inputchanged = game:GetService("UserInputService").InputChanged:Connect(function(input)
			if not Main and Main.Parent then
				inputchanged:Disconnect()
			end
			if (input == dragInput and dragToggle) then
				updateInput(input)
			end
		end)
	end

	local Children = {
		IsVisible = function(Boolean)
			Main.Visible = Boolean or not Main.Visible
		end,
		
		MakeTab = function(Name, Icon)

			local RealIcon = "http://www.roblox.com/asset/?id="..Icon
			local TabOpener = Instance.new("Frame")
			local TabOpenerButton = Instance.new("ImageButton")
			local Tab = Instance.new("Frame")
			local Sections = Instance.new("Frame")
			local SectionList = Instance.new("Folder")
			local SectionHighlighted = Instance.new("TextLabel")
			local SectionHighlightedCorner = Instance.new("UICorner")
			local SectionsCorner = Instance.new("UICorner")

			TabOpener.Name = "TabOpener!"..#TabFolder:GetChildren()
			TabOpener.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabOpener.BackgroundTransparency = 1.000
			TabOpener.Position = UDim2.new(0, 0, 0 + (0.139 * #TabList:GetChildren()), 0)
			TabOpener.Size = UDim2.new(0, 50, 0, 50)
			TabOpener.Parent = TabList

			local MultiplyByHowMuch = string.split(TabOpener.Name, "!")
			MultiplyByHowMuch = MultiplyByHowMuch[2]
			TabOpenerButton.Name = "TabOpenerButton"
			TabOpenerButton.Parent = TabOpener
			TabOpenerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TabOpenerButton.BackgroundTransparency = 1.000
			TabOpenerButton.Position = UDim2.new(0.25, 0, 0.25, 0)
			TabOpenerButton.Size = UDim2.new(0, 25, 0, 25)
			TabOpenerButton.Image = RealIcon
			TabOpenerButton.ImageColor3 = Color3.fromRGB(109, 96, 104)

			Tab.Name = Name or "Tab"
			Tab.Parent = TabFolder
			Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Tab.BackgroundTransparency = 1.000
			Tab.Position = UDim2.new(0.123844735, 0, 0.116343491, 0)
			Tab.Size = UDim2.new(0, 459, 0, 304)
			Tab.Visible = false

			Sections.Name = "Sections"
			Sections.Parent = Tab
			Sections.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
			Sections.BorderSizePixel = 0
			Sections.Size = UDim2.new(0, 459, 0, 37)

			SectionList.Name = "SectionList"
			SectionList.Parent = Sections

			SectionHighlighted.Name = "SectionHighlighted"
			SectionHighlighted.Parent = Sections
			SectionHighlighted.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
			SectionHighlighted.Position = UDim2.new(0.00899995957, 0, 0.922972798, 0)
			SectionHighlighted.Size = UDim2.new(0, 75, 0, 2)
			SectionHighlighted.Font = Enum.Font.SourceSans
			SectionHighlighted.Text = " "
			SectionHighlighted.TextColor3 = Color3.fromRGB(0, 0, 0)
			SectionHighlighted.TextSize = 14.000

			SectionHighlightedCorner.CornerRadius = UDim.new(0, 12)
			SectionHighlightedCorner.Name = "SectionHighlightedCorner"
			SectionHighlightedCorner.Parent = SectionHighlighted

			SectionsCorner.CornerRadius = UDim.new(0, 4)
			SectionsCorner.Name = "SectionsCorner"
			SectionsCorner.Parent = Sections

			TabOpenerButton.MouseButton1Down:Connect(function()
				--print(TabOpener.Position.Y.Offset,TabOpener.Position.Y.Scale,TabOpener.Name)
				for _, OtherTab in pairs(TabFolder:GetChildren()) do
					OtherTab.Visible = false
				end
				for _, OtherButton in pairs(TabList:GetChildren()) do
					TweenImageColor(OtherButton.TabOpenerButton, {
						['Time'] = 0.25,
						['ImageColor3'] = Color3.fromRGB(109, 96, 104)
					})
				end	
				TweenImageColor(TabOpenerButton, {
					['Time'] = 0.25,
					['ImageColor3'] = DefaultColor
				})
				Tab.Visible = true -- -0.15 original
				task.defer(function()
					SelectedHighlight:TweenPosition(
						UDim2.new(0.92, 0, TabOpener.Position.Y.Scale + 0.025, 0), 
						Enum.EasingDirection.InOut, 
						Enum.EasingStyle.Quart, 
						0.25,
						true
					)
				end)
				Title.Text = Name
			end)
			
			if #TabList:GetChildren() <= 1 then
				for _, OtherTab in pairs(TabFolder:GetChildren()) do
					OtherTab.Visible = false
				end
				for _, OtherButton in pairs(TabList:GetChildren()) do
					TweenImageColor(OtherButton.TabOpenerButton, {
						['Time'] = 0.25,
						['ImageColor3'] = Color3.fromRGB(109, 96, 104)
					})
				end	
				TweenImageColor(TabOpenerButton, {
					['Time'] = 0.25,
					['ImageColor3'] = DefaultColor
				})
				Tab.Visible = true -- -0.15 original
				task.defer(function()
					SelectedHighlight:TweenPosition(
						UDim2.new(0.92, 0, TabOpener.Position.Y.Scale + 0.025, 0), 
						Enum.EasingDirection.InOut, 
						Enum.EasingStyle.Quart, 
						0.25,
						true
					)
				end)
				Title.Text = Name
			end
			
			local Descendants = { -- fix this shit tmr please
				MakeSection = function(Name)
					local Section = Instance.new("TextButton")
					local SectionTab = Instance.new("Frame")
					local SectionTabMain = Instance.new("ScrollingFrame")
					local SectionTabLayout = Instance.new("UIListLayout")
					local SectionTabCorner = Instance.new("UICorner")
					SectionTabCorner.CornerRadius = UDim.new(0, 4)
					SectionTabCorner.Name = "SectionTabCorner"
					SectionTabCorner.Parent = SectionTab
					Section.Name = "Section"..#SectionList:GetChildren()
					Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Section.BackgroundTransparency = 1.000
					Section.Position = UDim2.new(0 + (0.185 * #Tab.Sections.SectionList:GetChildren()), 0, 0.041, 0)
					Section.Size = UDim2.new(0, 85, 0, 34)
					Section.Font = Enum.Font.Gotham
					Section.Text = Name or "Section"
					Section.TextColor3 = Color3.fromRGB(109, 96, 104)
					Section.TextSize = 14.000

					SectionTab.Name = "SectionTab"
					SectionTab.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
					SectionTab.BorderSizePixel = 0
					SectionTab.Position = UDim2.new(0 + (-1 * #Tab.Sections.SectionList:GetChildren()) , 0, 1.29508519, 0)
					SectionTab.Size = UDim2.new(0, 459, 0, 260)
					SectionTab.Visible = false
					SectionTab.Parent = Section
					Section.Parent = SectionList

					SectionTabMain.Name = "SectionTabMain"
					SectionTabMain.Parent = SectionTab
					SectionTabMain.Active = true
					SectionTabMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					SectionTabMain.BackgroundTransparency = 1.000
					SectionTabMain.BorderSizePixel = 0
					SectionTabMain.Position = UDim2.new(0.0217864923, 0, 0.0346155018, 0)
					SectionTabMain.Size = UDim2.new(0, 445, 0, 248)
					SectionTabMain.CanvasSize = UDim2.new(0, 0, 0, 0)
					SectionTabMain.ScrollBarThickness = 3
					SectionTabMain.AutomaticCanvasSize = "Y"
					SectionTabLayout.Name = "SectionTabLayout"
					SectionTabLayout.Parent = SectionTabMain
					SectionTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
					SectionTabLayout.Padding = UDim.new(0, 5)

					Section.MouseButton1Down:Connect(function()
						for _,OtherSection in pairs(SectionList:GetChildren()) do
							if OtherSection:IsA("TextButton") and OtherSection.Name ~= Section.Name then
								OtherSection.SectionTab.Visible = false
								TweenTextColor(OtherSection, {
									['Time'] = 0.25,
									['TextColor3'] = Color3.fromRGB(109, 96, 104)
								})

							end
						end
						SectionTab.Visible = true
						TweenTextColor(Section, {
							['Time'] = 0.25,
							['TextColor3'] = DefaultColor
						})
						if SectionHighlighted.BackgroundColor3 ~= Color3.fromRGB(38, 38, 38) then
							SectionHighlighted:TweenPosition(
								UDim2.new(Section.Position.X.Scale + 0.01,0,0.92,0), 
								Enum.EasingDirection.InOut, 
								Enum.EasingStyle.Quart, 
								0.25,
								true
							)
						else
							TweenBackgroundColor(SectionHighlighted, {
								['Time'] = 0.25,
								['BackgroundColor3'] = DefaultColor
							})
							SectionHighlighted:TweenPosition(
								UDim2.new(Section.Position.X.Scale + 0.01,0,0.92,0), 
								Enum.EasingDirection.InOut, 
								Enum.EasingStyle.Quart, 
								0.25,
								true
							)
						end
					end)
					
					if #SectionList:GetChildren() <= 1 then
						for _,OtherSection in pairs(SectionList:GetChildren()) do
							if OtherSection:IsA("TextButton") and OtherSection.Name ~= Section.Name then
								OtherSection.SectionTab.Visible = false
								TweenTextColor(OtherSection, {
									['Time'] = 0.25,
									['TextColor3'] = Color3.fromRGB(109, 96, 104)
								})

							end
						end
						SectionTab.Visible = true
						TweenTextColor(Section, {
							['Time'] = 0.25,
							['TextColor3'] = DefaultColor
						})
						if SectionHighlighted.BackgroundColor3 ~= Color3.fromRGB(38, 38, 38) then
							SectionHighlighted:TweenPosition(
								UDim2.new(Section.Position.X.Scale + 0.01,0,0.92,0), 
								Enum.EasingDirection.InOut, 
								Enum.EasingStyle.Quart, 
								0.25,
								true
							)
						else
							TweenBackgroundColor(SectionHighlighted, {
								['Time'] = 0.25,
								['BackgroundColor3'] = DefaultColor
							})
							SectionHighlighted:TweenPosition(
								UDim2.new(Section.Position.X.Scale + 0.01,0,0.92,0), 
								Enum.EasingDirection.InOut, 
								Enum.EasingStyle.Quart, 
								0.25,
								true
							)
						end
					end
					
					local Items = {
						Label = function(Text)
							local Label = Instance.new("Frame")
							local LabelCorner = Instance.new("UICorner")
							local LabelText = Instance.new("TextLabel")
							local LabelIcon = Instance.new("ImageLabel")

							Label.Name = "Label"
							Label.Parent = SectionTabMain
							Label.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
							Label.Size = UDim2.new(0, 431, 0, 33)

							LabelCorner.CornerRadius = UDim.new(0, 3)
							LabelCorner.Name = "LabelCorner"
							LabelCorner.Parent = Label

							LabelText.Name = "LabelText"
							LabelText.Parent = Label
							LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							LabelText.BackgroundTransparency = 1.000
							LabelText.Position = UDim2.new(0.0298851356, 0, 0.181818187, 0)
							LabelText.Size = UDim2.new(0, 366, 0, 20)
							LabelText.Font = Enum.Font.Gotham
							LabelText.Text = Text or "Unknown"
							LabelText.TextColor3 = FontColor
							LabelText.TextSize = 14.000
							LabelText.TextXAlignment = Enum.TextXAlignment.Left

							LabelIcon.Parent = Label
							LabelIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							LabelIcon.BackgroundTransparency = 1.000
							LabelIcon.Position = UDim2.new(0.918793499, 0, 0.121212125, 0)
							LabelIcon.Size = UDim2.new(0, 23, 0, 23)
							LabelIcon.Image = "http://www.roblox.com/asset/?id=6031302918"
							LabelIcon.ImageColor3 = DefaultColor
							local Extra = {
								UpdateLabel = function(NewText)
									LabelText.Text = NewText
								end
							}
							return Extra
						end,
						Button = function(Text, Callback)
							local Button = Instance.new("TextButton")
							local ButtonCorner = Instance.new("UICorner")
							local ButtonText = Instance.new("TextLabel")
							local ButtonIcon = Instance.new("ImageLabel")

							Button.Name = "Button"
							Button.Parent = SectionTabMain
							Button.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
							Button.Size = UDim2.new(0, 431, 0, 33)
							Button.Font = Enum.Font.SourceSans
							Button.Text = " "
							Button.TextColor3 = Color3.fromRGB(0, 0, 0)
							Button.TextSize = 14.000

							ButtonCorner.CornerRadius = UDim.new(0, 3)
							ButtonCorner.Name = "ButtonCorner"
							ButtonCorner.Parent = Button

							ButtonText.Name = "ButtonText"
							ButtonText.Parent = Button
							ButtonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							ButtonText.BackgroundTransparency = 1.000
							ButtonText.Position = UDim2.new(0.0298851356, 0, 0.181818187, 0)
							ButtonText.Size = UDim2.new(0, 377, 0, 20)
							ButtonText.Font = Enum.Font.Gotham
							ButtonText.Text = Text or "Unknown"
							ButtonText.TextColor3 = FontColor
							ButtonText.TextSize = 14.000
							ButtonText.TextXAlignment = Enum.TextXAlignment.Left

							ButtonIcon.Name = "ButtonIcon"
							ButtonIcon.Parent = Button
							ButtonIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							ButtonIcon.BackgroundTransparency = 1.000
							ButtonIcon.Position = UDim2.new(0.918793499, 0, 0.121212125, 0)
							ButtonIcon.Size = UDim2.new(0, 23, 0, 23)
							ButtonIcon.Image = "http://www.roblox.com/asset/?id=6031229361"
							ButtonIcon.ImageColor3 = DefaultColor

							local CB = Callback or function() end
							Button.MouseButton1Down:Connect(CB)
						end,
						Textbox = function(Name, Callback)
							local Textbox = Instance.new("Frame")
							local TextboxCorner = Instance.new("UICorner")
							local TextboxText = Instance.new("TextLabel")
							local TextboxIcon = Instance.new("ImageLabel")
							local InputBox = Instance.new("TextBox")
							local InputBoxCorner = Instance.new("UICorner")
							local InputBoxSize = Instance.new("UITextSizeConstraint")


							Textbox.Name = "Textbox"
							Textbox.Parent = SectionTabMain
							Textbox.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
							Textbox.Size = UDim2.new(0, 431, 0, 33)

							TextboxCorner.CornerRadius = UDim.new(0, 3)
							TextboxCorner.Name = "TextboxCorner"
							TextboxCorner.Parent = Textbox

							TextboxText.Name = "TextboxText"
							TextboxText.Parent = Textbox
							TextboxText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							TextboxText.BackgroundTransparency = 1.000
							TextboxText.Position = UDim2.new(0.0298851356, 0, 0.181818187, 0)
							TextboxText.Size = UDim2.new(0, 291, 0, 20)
							TextboxText.Font = Enum.Font.Gotham
							TextboxText.Text = Name or "Unknown"
							TextboxText.TextColor3 = FontColor
							TextboxText.TextSize = 14.000
							TextboxText.TextXAlignment = Enum.TextXAlignment.Left

							TextboxIcon.Name = "TextboxIcon"
							TextboxIcon.Parent = Textbox
							TextboxIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							TextboxIcon.BackgroundTransparency = 1.000
							TextboxIcon.Position = UDim2.new(0.918793499, 0, 0.121212125, 0)
							TextboxIcon.Size = UDim2.new(0, 23, 0, 23)
							TextboxIcon.Image = "http://www.roblox.com/asset/?id=6034328955"
							TextboxIcon.ImageColor3 = DefaultColor

							InputBox.Name = "InputBox"
							InputBox.Parent = Textbox
							InputBox.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
							InputBox.Position = UDim2.new(0.721577704, 0, 0.181818187, 0)
							InputBox.Size = UDim2.new(0, 74, 0, 21)
							InputBox.Font = Enum.Font.Gotham
							InputBox.PlaceholderColor3 = Color3.fromRGB(191, 168, 181)
							InputBox.PlaceholderText = "Input Here"
							InputBox.Text = ""
							InputBox.TextColor3 = FontColor
							InputBox.TextScaled = true
							InputBox.TextSize = 14.000
							InputBox.TextWrapped = true

							InputBoxCorner.CornerRadius = UDim.new(0, 3)
							InputBoxCorner.Name = "InputBoxCorner"
							InputBoxCorner.Parent = InputBox

							InputBoxSize.Name = "InputBoxSize"
							InputBoxSize.Parent = InputBox
							InputBoxSize.MaxTextSize = 13

							InputBox.FocusLost:Connect(function(enterPressed)
								if enterPressed and InputBox.Text ~= "" then
									if Callback then
										Callback(InputBox.Text)
									end
									InputBox.Text = ""
								end
							end)
						end,
						Toggle = function(Name, State, Callback)
							local CurrentState = not State or false
							local CB = Callback or function() end
							local Toggle = Instance.new("TextButton")
							local ToggleCorner = Instance.new("UICorner")
							local ToggleText = Instance.new("TextLabel")
							local ToggleCheck = Instance.new("ImageLabel")
							local ToggleCheckOn = Instance.new("ImageLabel")


							Toggle.Name = "Toggle"
							Toggle.Parent = SectionTabMain
							Toggle.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
							Toggle.Size = UDim2.new(0, 431, 0, 33)
							Toggle.Font = Enum.Font.SourceSans
							Toggle.Text = " "
							Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
							Toggle.TextSize = 14.000

							ToggleCorner.CornerRadius = UDim.new(0, 3)
							ToggleCorner.Name = "ToggleCorner"
							ToggleCorner.Parent = Toggle

							ToggleText.Name = "ToggleText"
							ToggleText.Parent = Toggle
							ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							ToggleText.BackgroundTransparency = 1.000
							ToggleText.Position = UDim2.new(0.0298851356, 0, 0.181818187, 0)
							ToggleText.Size = UDim2.new(0, 377, 0, 20)
							ToggleText.Font = Enum.Font.Gotham
							ToggleText.Text = Name or "Toggle"
							ToggleText.TextColor3 = FontColor
							ToggleText.TextSize = 14.000
							ToggleText.TextXAlignment = Enum.TextXAlignment.Left

							ToggleCheck.Name = "ToggleCheck"
							ToggleCheck.Parent = Toggle
							ToggleCheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							ToggleCheck.BackgroundTransparency = 1.000
							ToggleCheck.Position = UDim2.new(0.918793499, 0, 0.121212125, 0)
							ToggleCheck.Size = UDim2.new(0, 23, 0, 23)
							ToggleCheck.Image = "http://www.roblox.com/asset/?id=6031068433"
							ToggleCheck.ImageColor3 = DefaultColor

							ToggleCheckOn.Name = "ToggleCheckOn"
							ToggleCheckOn.Parent = ToggleCheck
							ToggleCheckOn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							ToggleCheckOn.BackgroundTransparency = 1.000
							ToggleCheckOn.Size = UDim2.new(0, 23, 0, 23)
							ToggleCheckOn.Image = "http://www.roblox.com/asset/?id=6031068426"
							ToggleCheckOn.ImageColor3 = DefaultColor
							ToggleCheckOn.ImageTransparency = 1.000

							local function Change()
								task.spawn(function()
									CurrentState = not CurrentState
									Callback(CurrentState)
									if CurrentState then
										TweenImageTransparency(ToggleCheckOn, {
											["Time"] = 0.25,
											["ImageTransparency"] = 0
										})
									else
										TweenImageTransparency(ToggleCheckOn, {
											["Time"] = 0.25,
											["ImageTransparency"] = 1
										})
									end
								end)
							end
							Change()
							Toggle.MouseButton1Down:Connect(Change)
						end,
						Dropdown = function(Text, Table, Call)
							local TableInfo = Table or {}
							local Textt = Text or "Unknown"
							local Callback = Call or function() end

							local Dropdown = Instance.new("Frame")
							local DropdownCorner = Instance.new("UICorner")
							local DropdownText = Instance.new("TextLabel")
							local DropdownIcon = Instance.new("ImageButton")
							local DropdownFrame = Instance.new("ScrollingFrame")
							local DropdownFrameListLayout = Instance.new("UIListLayout")

							Dropdown.Name = "Dropdown"
							Dropdown.Parent = SectionTabMain
							Dropdown.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
							Dropdown.ClipsDescendants = true
							Dropdown.Position = UDim2.new(0, 0, 0.612903118, 0)
							Dropdown.Size = UDim2.new(0, 431, 0, 33)

							DropdownCorner.CornerRadius = UDim.new(0, 3)
							DropdownCorner.Name = "DropdownCorner"
							DropdownCorner.Parent = Dropdown

							local PrimaryText = Textt..": "
							DropdownText.Name = "DropdownText"
							DropdownText.Parent = Dropdown
							DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							DropdownText.BackgroundTransparency = 1.000
							DropdownText.Position = UDim2.new(0, 12, 0, 6)
							DropdownText.Size = UDim2.new(0.477958232, -50, 0, 20)
							DropdownText.Font = Enum.Font.Gotham
							DropdownText.Text = PrimaryText
							DropdownText.TextColor3 = FontColor
							DropdownText.TextSize = 14.000
							DropdownText.TextXAlignment = Enum.TextXAlignment.Left

							DropdownIcon.Name = "DropdownIcon"
							DropdownIcon.Parent = Dropdown
							DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							DropdownIcon.BackgroundTransparency = 1.000
							DropdownIcon.Position = UDim2.new(0, 396, 0, 5)
							DropdownIcon.Size = UDim2.new(0, 23, 0, 23)
							DropdownIcon.Image = "http://www.roblox.com/asset/?id=6034818365"
							DropdownIcon.ImageColor3 = DefaultColor

							DropdownFrame.Name = "DropdownFrame"
							DropdownFrame.Parent = Dropdown
							DropdownFrame.Active = true
							DropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							DropdownFrame.BackgroundTransparency = 1.000
							DropdownFrame.BorderSizePixel = 0
							DropdownFrame.Position = UDim2.new(0, 12, 0, 35)
							DropdownFrame.Size = UDim2.new(0, 408, 0, 67)
							DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
							DropdownFrame.AutomaticCanvasSize = "Y"
							DropdownFrame.ScrollBarThickness = 1

							DropdownFrameListLayout.Name = "DropdownFrameListLayout"
							DropdownFrameListLayout.Parent = DropdownFrame
							DropdownFrameListLayout.SortOrder = Enum.SortOrder.LayoutOrder
							DropdownFrameListLayout.Padding = UDim.new(0, 2)
							local Opened = false
							for _,v in pairs(TableInfo) do
								local DropdownItem = Instance.new("TextButton")
								local DropdownItemCorner = Instance.new("UICorner")

								DropdownItem.Name = "DropdownItem"
								DropdownItem.Parent = DropdownFrame
								DropdownItem.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
								DropdownItem.BorderSizePixel = 0
								DropdownItem.Size = UDim2.new(0, 404, 0, 19)
								DropdownItem.Font = Enum.Font.Gotham
								DropdownItem.Text = v or "nil"
								DropdownItem.TextColor3 = FontColor
								DropdownItem.TextSize = 13.000

								DropdownItemCorner.CornerRadius = UDim.new(0, 3)
								DropdownItemCorner.Name = "DropdownItemCorner"
								DropdownItemCorner.Parent = DropdownItem

								DropdownItem.MouseButton1Down:Connect(function()
									DropdownText.Text = ""..PrimaryText..v
									Callback(v)
									Opened = false
									TweenRotateFrame(DropdownIcon, 0)
									Dropdown:TweenSize(UDim2.new(0, 431, 0, 33), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.25, true)
								end)
							end

							DropdownIcon.MouseButton1Down:Connect(function()
								if not Opened then
									Opened = true
									TweenRotateFrame(DropdownIcon, 90)
									Dropdown:TweenSize(UDim2.new(0, 431, 0, 109), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.25, true)
								else
									Opened = false
									TweenRotateFrame(DropdownIcon, 0)
									Dropdown:TweenSize(UDim2.new(0, 431, 0, 33), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.25, true)
								end
							end)
						end,
						Slider = function(Name, Min, Max, Default, Callback)	
							local Slider = Instance.new("Frame")
							local SliderCorner = Instance.new("UICorner")
							local SliderText = Instance.new("TextLabel")
							local SliderIcon = Instance.new("ImageLabel")
							local SliderValue = Instance.new("TextLabel")
							local SliderHolder = Instance.new("TextButton")
							local SliderHolderCorner = Instance.new("UICorner")
							local SliderHolderColor = Instance.new("Frame")
							local SliderHolderColorCorner = Instance.new("UICorner")

							Slider.Name = "Slider"
							Slider.Parent = SectionTabMain
							Slider.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
							Slider.Position = UDim2.new(-0.0134831462, 0, 0.754032135, 0)
							Slider.Size = UDim2.new(0, 431, 0, 57)

							SliderCorner.CornerRadius = UDim.new(0, 3)
							SliderCorner.Name = "SliderCorner"
							SliderCorner.Parent = Slider

							SliderText.Name = "SliderText"
							SliderText.Parent = Slider
							SliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							SliderText.BackgroundTransparency = 1.000
							SliderText.Position = UDim2.new(0.0298851356, 0, 0.144781142, 0)
							SliderText.Size = UDim2.new(0, 345, 0, 20)
							SliderText.Font = Enum.Font.Gotham
							SliderText.Text = Name or "Unknown"
							SliderText.TextColor3 = FontColor
							SliderText.TextSize = 14.000
							SliderText.TextXAlignment = Enum.TextXAlignment.Left

							SliderIcon.Name = "SliderIcon"
							SliderIcon.Parent = Slider
							SliderIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							SliderIcon.BackgroundTransparency = 1.000
							SliderIcon.Position = UDim2.new(0.918793499, 0, 0.102693602, 0)
							SliderIcon.Size = UDim2.new(0, 23, 0, 23)
							SliderIcon.Image = "http://www.roblox.com/asset/?id=6031233863"
							SliderIcon.ImageColor3 = DefaultColor

							SliderValue.Name = "SliderValue"
							SliderValue.Parent = Slider
							SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
							SliderValue.BackgroundTransparency = 1.000
							SliderValue.Position = UDim2.new(0.85123086, 0, 0.14478074, 0)
							SliderValue.Size = UDim2.new(0, 21, 0, 20)
							SliderValue.Font = Enum.Font.Gotham
							SliderValue.Text = Default and tostring(Default) or "0"
							SliderValue.TextColor3 = DefaultColor
							SliderValue.TextSize = 14.000

							SliderHolder.Name = "SliderHolder"
							SliderHolder.Parent = Slider
							SliderHolder.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
							SliderHolder.Position = UDim2.new(0.0280000009, 0, 0.609000027, 0)
							SliderHolder.Size = UDim2.new(0, 405, 0, 15)
							SliderHolder.AutoButtonColor = false
							SliderHolder.Font = Enum.Font.SourceSans
							SliderHolder.Text = " "
							SliderHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
							SliderHolder.TextSize = 14.000

							SliderHolderCorner.CornerRadius = UDim.new(0, 3)
							SliderHolderCorner.Name = "SliderHolderCorner"
							SliderHolderCorner.Parent = SliderHolder
							
							local MinimumValue = tonumber(Min) or 0
							local MaximumValue = tonumber(Max) or 100
							
							SliderHolderColor.Name = "SliderHolderColor"
							SliderHolderColor.Parent = SliderHolder
							SliderHolderColor.BackgroundColor3 = DefaultColor
							SliderHolderColor.BorderSizePixel = 0
							SliderHolderColor.Size = UDim2.new(Default / MaximumValue, 0, 0, 15)

							SliderHolderColorCorner.CornerRadius = UDim.new(0, 3)
							SliderHolderColorCorner.Name = "SliderHolderColorCorner"
							SliderHolderColorCorner.Parent = SliderHolderColor

							local Value;
							local Move_Connection, Release_Connection
							local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

							local CB = Callback or function() end
							
							SliderHolder.MouseButton1Down:Connect(function()
								Value = math.floor((((MaximumValue - MinimumValue) / 405) * SliderHolderColor.AbsoluteSize.X) + tonumber(MinimumValue)) or 0
								pcall(function()
									Callback(Value)
								end)
								SliderHolderColor.Size = UDim2.new(0, math.clamp(Mouse.X - SliderHolderColor.AbsolutePosition.X, 0, 405), 0, 15)
								Move_Connection = Mouse.Move:Connect(function()
									SliderValue.Text = Value
									Value = math.floor((((MaximumValue - MinimumValue) / 405) * SliderHolderColor.AbsoluteSize.X) + tonumber(MinimumValue))
									pcall(function()
										Callback(Value)
									end)
									SliderHolderColor.Size = UDim2.new(0, math.clamp(Mouse.X - SliderHolderColor.AbsolutePosition.X, 0, 405), 0, 15)
								end)
								Release_Connection = UserInputService.InputEnded:Connect(function(MouseUIS)
									if MouseUIS.UserInputType == Enum.UserInputType.MouseButton1 then
										Value = math.floor((((MaximumValue - MinimumValue) / 405) * SliderHolderColor.AbsoluteSize.X) + tonumber(MinimumValue))
										pcall(function()
											Callback(Value)
										end)
										SliderHolderColor.Size = UDim2.new(0, math.clamp(Mouse.X - SliderHolderColor.AbsolutePosition.X, 0, 405), 0, 15)
										Move_Connection:Disconnect()
										Release_Connection:Disconnect()
									end
								end)
							end)
						end,
					}
					return Items
				end,
			}
			return Descendants
		end
	}
	return Children
end
return Library
