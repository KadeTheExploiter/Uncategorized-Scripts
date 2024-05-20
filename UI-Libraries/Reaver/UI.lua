local Library = {}
local UDim2New = UDim2.new
local FromRGB = Color3.fromRGB
local MakeInstance = Instance.new
local TweenService = game:FindFirstChildOfClass("TweenService")

local function GetColor(percentage, ColorKeyPoints)
	if (percentage < 0) or (percentage>1) then
		warn'getColor got out of bounds percentage (less than 0 or greater than 1'
	end
	local closestToLeft = ColorKeyPoints[1]
	local closestToRight = ColorKeyPoints[#ColorKeyPoints]
	local LocalPercentage = .5
	local Color = closestToLeft.Value
	for i=1,#ColorKeyPoints-1 do
		if (ColorKeyPoints[i].Time <= percentage) and (ColorKeyPoints[i+1].Time >= percentage) then
			closestToLeft = ColorKeyPoints[i]
			closestToRight = ColorKeyPoints[i+1]
			LocalPercentage = (percentage-closestToLeft.Time)/(closestToRight.Time-closestToLeft.Time)
			Color = closestToLeft.Value:lerp(closestToRight.Value,LocalPercentage)
			return Color
		end
	end
	warn('Color not found!')
	return Color
end
local function TweenTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {Transparency= Property["Transparency"]}):Play()
	return Tween
end
local function TweenBackgroundTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {BackgroundTransparency= Property["BackgroundTransparency"]}):Play()
	return Tween
end
local function TweenImageTransparency(Object, Property)
	local Tween =TweenService:Create(Object, TweenInfo.new(Property["Time"]), {ImageTransparency= Property["ImageTransparency"]}):Play()
	return Tween
end
local function TweenTextTransparency(Object, Property)
	local Tween = TweenService:Create(Object, TweenInfo.new(Property["Time"]), {TextTransparency= Property["TextTransparency"]}):Play()
	return Tween
end	
local Mouse = game:FindFirstChildOfClass("Players").LocalPlayer:GetMouse()
local UserInputService = game:FindFirstChildOfClass("UserInputService")

function Library:Create(Name, StartupText, Color)
	local Color = Color or FromRGB(247, 83, 91)
	local GelatekUI = MakeInstance("ScreenGui")
	local Main = MakeInstance("Frame")
	local MainCorner = MakeInstance("UICorner")
	local Title = MakeInstance("TextLabel")
	local Exit = MakeInstance("ImageButton")
	local LineSide = MakeInstance("TextLabel")
	local LineTop = MakeInstance("TextLabel")
	
	local TabList = MakeInstance("ScrollingFrame")
	local TabListLayout = MakeInstance("UIListLayout")
	local OffsetFixer = MakeInstance("TextLabel")	
	
	local Shadow = MakeInstance("ImageLabel")
	local Logo = MakeInstance("ImageLabel")
	local Credit = MakeInstance("TextLabel")
	
	local Tabs = MakeInstance("Folder")
	local Drag = MakeInstance("Frame")

	--Properties:
	GelatekUI.Name = "GelatekUI"

	Main.Name = "Main"
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = FromRGB(34, 34, 34)
	Main.ClipsDescendants = true
	Main.Position = UDim2New(0.5, 0, 0.5, 0)
	Main.Size = UDim2New(0, 375, 0, 267)

	MainCorner.CornerRadius = UDim.new(0, 4)
	MainCorner.Name = "MainCorner"

	Title.Name = "Title"
	Title.BackgroundColor3 = FromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2New(0.0266666673, 0, 0, 0)
	Title.Size = UDim2New(0, 168, 0, 29)
	Title.Font = Enum.Font.GothamMedium
	Title.Text = Name or "Gelatek UI"
	Title.TextColor3 = Color or FromRGB(247, 83, 91)
	Title.TextSize = 14.000
	Title.TextTransparency = 1.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Exit.Name = "Exit"
	Exit.BackgroundColor3 = FromRGB(255, 255, 255)
	Exit.BackgroundTransparency = 1.000
	Exit.BorderColor3 = FromRGB(27, 42, 53)
	Exit.Position = UDim2New(0.938666642, 0, 0.0262172278, 0)
	Exit.Size = UDim2New(0, 15, 0, 15)
	Exit.Image = "http://www.roblox.com/asset/?id=10444336846"
	Exit.ImageTransparency = 1.000

	LineSide.Name = "LineSide"
	LineSide.BackgroundColor3 = FromRGB(54, 54, 54)
	LineSide.BackgroundTransparency = 1.000
	LineSide.BorderSizePixel = 0
	LineSide.Position = UDim2New(0.301333338, 0, 0.10899999, 0)
	LineSide.Size = UDim2New(0, 1, 0, 237)
	LineSide.Font = Enum.Font.SourceSans
	LineSide.Text = " "
	LineSide.TextColor3 = FromRGB(0, 0, 0)
	LineSide.TextSize = 14.000
	
	LineTop.Name = "LineTop"
	LineTop.BackgroundColor3 = FromRGB(54, 54, 54)
	LineTop.BackgroundTransparency = 1.000
	LineTop.BorderSizePixel = 0
	LineTop.Position = UDim2New(0, 0, 0.104868911, 0)
	LineTop.Size = UDim2New(0, 375, 0, 1)
	LineTop.Font = Enum.Font.SourceSans
	LineTop.Text = " "
	LineTop.TextColor3 = FromRGB(0, 0, 0)
	LineTop.TextSize = 14.000
	
	TabList.Name = "TabList"
	TabList.Active = true
	TabList.BackgroundColor3 = FromRGB(255, 255, 255)
	TabList.BackgroundTransparency = 1.000
	TabList.BorderSizePixel = 0
	TabList.Position = UDim2New(0, 0, 0.112745307, 0)
	TabList.Size = UDim2New(0, 0, 0, 235)
	TabList.ScrollBarThickness = 1
	TabList.ScrollBarImageTransparency = 1
	
	TabListLayout.Name = "TabListLayout"
	TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 3)

	OffsetFixer.Name = "OffsetFixer"
	OffsetFixer.BackgroundColor3 = FromRGB(255, 255, 255)
	OffsetFixer.BackgroundTransparency = 1.000
	OffsetFixer.Position = UDim2New(0.0663716793, 0, 1.2986203e-07, 0)
	OffsetFixer.Size = UDim2New(0, 105, 0, 2)
	OffsetFixer.Font = Enum.Font.SourceSans
	OffsetFixer.Text = " "
	OffsetFixer.TextColor3 = FromRGB(0, 0, 0)
	OffsetFixer.TextSize = 14.000

	Shadow.Name = "Shadow"
	Shadow.BackgroundColor3 = FromRGB(255, 255, 255)
	Shadow.BackgroundTransparency = 1.000
	Shadow.Position = UDim2New(-0.0533333346, 0, -0.0557678454, 0)
	Shadow.Rotation = 0.001
	Shadow.Size = UDim2New(0, 415, 0, 296)
	Shadow.ZIndex = -1
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = FromRGB(0, 0, 0)

	Logo.Name = "Logo"
	Logo.BackgroundColor3 = FromRGB(255, 255, 255)
	Logo.BackgroundTransparency = 1.000
	Logo.Position = UDim2New(0.298999995, 0, -0.670000017, 0)
	Logo.Size = UDim2New(0, 150, 0, 150)
	Logo.Image = "rbxassetid://10981775665"
	Logo.ImageColor3 = Color

	Credit.Name = "Credit"
	Credit.BackgroundColor3 = FromRGB(255, 255, 255)
	Credit.BackgroundTransparency = 1.000
	Credit.Position = UDim2New(-0.166666672, 0, 1.05999994, 0)
	Credit.Size = UDim2New(0, 200, 0, 17)
	Credit.Font = Enum.Font.GothamMedium
	Credit.Text = StartupText or "UI Library By Gelatek"
	Credit.TextColor3 = FromRGB(255, 255, 255)
	Credit.TextSize = 14.000
	
	Tabs.Name = "Tabs"
	
	Drag.Name = "Drag"
	Drag.Parent = Main
	Drag.BackgroundColor3 = FromRGB(255, 255, 255)
	Drag.BackgroundTransparency = 1.000
	Drag.Size = UDim2New(0, 375, 0, 29)
	
	GelatekUI.Parent = game:GetService("CoreGui")
	Main.Parent = GelatekUI
	MainCorner.Parent = Main
	Title.Parent = Main
	Exit.Parent = Main
	LineSide.Parent = Main
	LineTop.Parent = Main
	TabList.Parent = Main
	TabListLayout.Parent = TabList
	OffsetFixer.Parent = TabList
	Shadow.Parent = Main
	Logo.Parent = Main
	Credit.Parent = Logo
	Tabs.Parent = Main
	task.spawn(function()
		Logo:TweenPosition(UDim2New(0.299,0,0.2,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 1)
		wait(1.5)
		Logo:TweenPosition(UDim2New(0.299,0,1,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
		wait(0.6)
		TweenTransparency(Main.LineTop, {
			["Time"] = 0.3,
			["Transparency"] = 0
		})
		TweenTransparency(Main.LineSide, {
			["Time"] = 0.3,
			["Transparency"] = 0
		})
		TweenTextTransparency(Main.Title, {
			["Time"] = 0.3,
			["TextTransparency"] = 0
		})
		TweenImageTransparency(Main.Exit, {
			["Time"] = 0.3,
			["ImageTransparency"] = 0
		})
		Main.TabList:TweenSize(UDim2New(0,113,0,235), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.3)
	end)


    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local Delta, Position, startPos;
    local function updateInput(input)
        Delta = input.Position - dragStart
        Position = UDim2New(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        Frame.Position = Position
    end

	do --// Dragging
		local dragToggle
		local dragSpeed = 0.1 -- You can edit this.
		local dragInput
		local dragStart
		local dragPos
		local startPos
		local inputchanged
		local function updateInput(input)
			local Delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
			game:GetService("TweenService"):Create(Main, TweenInfo.new(.25), {Position = Position}):Play()
		end

		Drag.InputBegan:Connect(function(input)
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

		Drag.InputChanged:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				dragInput = input
			end
		end)

		inputchanged = UserInputService.InputChanged:Connect(function(input)
			if not Main and Main.Parent then
				inputchanged:Disconnect()
			end
			if (input == dragInput and dragToggle) then
				updateInput(input)
			end
		end)
	end


	Exit.MouseButton1Click:Connect(function()
		Main.Parent:Destroy()
	end)
	
	local LibraryTabs = {}
	function LibraryTabs:MakeTab(Name)
		local TabButton = MakeInstance("TextButton")
		local TabButtonCorner = MakeInstance("UICorner")
		local Tab = MakeInstance("ScrollingFrame")
		local TabLayout = MakeInstance("UIListLayout")
		
		TabButton.Name = "TabButton"
		TabButton.BackgroundColor3 = FromRGB(45, 45, 45)
		TabButton.BackgroundTransparency = 1
		TabButton.Position = UDim2New(0.0663716793, 0, 0.0212767255, 0)
		TabButton.Size = UDim2New(0, 98, 0, 23)
		TabButton.Font = Enum.Font.GothamMedium
		TabButton.Text = Name or "Tab"
		TabButton.TextColor3 = FromRGB(217, 217, 217)
		TabButton.TextSize = 12.000

		TabButtonCorner.CornerRadius = UDim.new(0, 3)
		TabButtonCorner.Name = "TabButtonCorner"
		
		Tab.Name = "Tab"
		Tab.Active = true
		Tab.BackgroundColor3 = FromRGB(255, 255, 255)
		Tab.BackgroundTransparency = 1.000
		Tab.BorderSizePixel = 0
		Tab.Position = UDim2New(0.30399999, 0, 0.131086141, 0)
		Tab.Size = UDim2New(0, 253, 0, 231)
		Tab.Visible = false
		Tab.ScrollBarThickness = 1
		Tab.CanvasSize = UDim2New(0,1,0,0)
		TabLayout.Name = "TabLayout"
		TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabLayout.Padding = UDim.new(0, 3)
		
		TabButton.Parent = TabList
		TabButtonCorner.Parent = TabButton
		Tab.Parent = Tabs
		TabLayout.Parent = Tab
		
		TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Tab.CanvasSize = UDim2.fromOffset(TabLayout.AbsoluteContentSize.X, TabLayout.AbsoluteContentSize.Y + 5)
		end)

		TabButton.MouseButton1Down:Connect(function()
			for _, v in pairs(Tabs:GetChildren()) do
				v.Visible = false
			end
			for _, v in pairs(TabList:GetChildren()) do
				if v:IsA("TextButton") then
					TweenBackgroundTransparency(v, {
						["Time"] = 0.3,
						["BackgroundTransparency"] = 1
					})
				end
			end
			TweenBackgroundTransparency(TabButton, {
				["Time"] = 0.3,
				["BackgroundTransparency"] = 0
			})
			Tab.Visible = true
			print("Tab Visible".. Tab.Name)
		end)
		local LibraryItems = {}
		function LibraryItems:MakeLabel(Text)
			local Label = MakeInstance("Frame")
			local LabelText = MakeInstance("TextLabel")
			local LabelCorner = MakeInstance("UICorner")
			
			Label.Name = "Label"
			Label.BackgroundColor3 = FromRGB(44, 44, 44)
			Label.Position = UDim2New(-0.272727281, 0, 0.00749063678, 0)
			Label.Size = UDim2New(0, 238, 0, 30)

			LabelText.Name = "LabelText"
			LabelText.BackgroundColor3 = FromRGB(255, 255, 255)
			LabelText.BackgroundTransparency = 1.000
			LabelText.Position = UDim2New(0.045363225, 0, 0, 0)
			LabelText.Size = UDim2New(0, 219, 0, 30)
			LabelText.Font = Enum.Font.GothamMedium
			LabelText.Text = Text or "Fun Fact: 127.0.0.1 Is a local IP."
			LabelText.TextColor3 = FromRGB(211, 211, 211)
			LabelText.TextSize = 13.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Left
			
			LabelCorner.CornerRadius = UDim.new(0, 3)
			LabelCorner.Name = "LabelCorner"
			
			LabelText.Parent = Label
			LabelCorner.Parent = Label
			Label.Parent = Tab
			
			local LabelAddon = {}
			function LabelAddon:UpdateLabel(UpdatedText)
				LabelText.Text = UpdatedText or "Update"
			end
			return LabelAddon
		end
		function LibraryItems:MakeButton(Text, Call)
			local Callback = Call or function() end
			local Button = MakeInstance("TextButton")
			local ButtonCorner = MakeInstance("UICorner")
			local ButtonText = MakeInstance("TextLabel")

			Button.Name = "Button"
			Button.BackgroundColor3 = FromRGB(44, 44, 44)
			Button.Position = UDim2New(0.0296442695, 0, 0, 0)
			Button.Size = UDim2New(0, 238, 0, 30)
			Button.Font = Enum.Font.SourceSans
			Button.Text = " "
			Button.TextColor3 = FromRGB(0, 0, 0)
			Button.TextSize = 14.000

			ButtonCorner.CornerRadius = UDim.new(0, 3)
			ButtonCorner.Name = "ButtonCorner"

			ButtonText.Name = "ButtonText"
			ButtonText.BackgroundColor3 = FromRGB(255, 255, 255)
			ButtonText.BackgroundTransparency = 1.000
			ButtonText.Position = UDim2New(0.045363225, 0, 0, 0)
			ButtonText.Size = UDim2New(0, 219, 0, 30)
			ButtonText.Font = Enum.Font.GothamMedium
			ButtonText.Text = Text or "Hello"
			ButtonText.TextColor3 = FromRGB(211, 211, 211)
			ButtonText.TextSize = 13.000
			ButtonText.TextXAlignment = Enum.TextXAlignment.Left
			
			Button.Parent = Tab
			ButtonCorner.Parent = Button
			ButtonText.Parent = Button
			Button.MouseButton1Click:Connect(Callback)
		end
		function LibraryItems:MakeToggle(Text, Call)
			local Callback = Call or function() end
			local State
			
			local Toggle = MakeInstance("TextButton")
			local ToggleCorner = MakeInstance("UICorner")
			local ToggleText = MakeInstance("TextLabel")
			local ToggleCheck = MakeInstance("Frame")
			local ToggleCheckCorner = MakeInstance("UICorner")
			local ToggleCheckStroke = MakeInstance("UIStroke")
			
			Toggle.Name = "Toggle"
			Toggle.BackgroundColor3 = FromRGB(44, 44, 44)
			Toggle.Position = UDim2New(0.0296442695, 0, 0, 0)
			Toggle.Size = UDim2New(0, 238, 0, 30)
			Toggle.Font = Enum.Font.SourceSans
			Toggle.Text = " "
			Toggle.TextColor3 = FromRGB(0, 0, 0)
			Toggle.TextSize = 14.000

			ToggleCorner.CornerRadius = UDim.new(0, 3)
			ToggleCorner.Name = "ToggleCorner"

			ToggleText.Name = "ToggleText"
			ToggleText.BackgroundColor3 = FromRGB(255, 255, 255)
			ToggleText.BackgroundTransparency = 1.000
			ToggleText.Position = UDim2New(0.045363225, 0, 0, 0)
			ToggleText.Size = UDim2New(0, 198, 0, 30)
			ToggleText.Font = Enum.Font.GothamMedium
			ToggleText.Text = Text or "Do you like me?"
			ToggleText.TextColor3 = FromRGB(211, 211, 211)
			ToggleText.TextSize = 13.000
			ToggleText.TextXAlignment = Enum.TextXAlignment.Left

			ToggleCheck.Name = "ToggleCheck"
			ToggleCheck.BackgroundColor3 = Color
			ToggleCheck.BackgroundTransparency = 1.000
			ToggleCheck.Position = UDim2New(0.902506053, 0, 0.170100912, 0)
			ToggleCheck.Size = UDim2New(0, 19, 0, 19)

			ToggleCheckCorner.CornerRadius = UDim.new(0, 4)
			ToggleCheckCorner.Name = "ToggleCheckStroke"
			
			ToggleCheckStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			ToggleCheckStroke.Color = FromRGB(13, 13, 13)
			ToggleCheckStroke.LineJoinMode = Enum.LineJoinMode.Round
			ToggleCheckStroke.Thickness = 1
			
			Toggle.Parent = Tab
			ToggleCorner.Parent = Toggle
			ToggleText.Parent = Toggle
			ToggleCheck.Parent = Toggle
			ToggleCheckCorner.Parent = ToggleCheck
			ToggleCheckStroke.Parent = ToggleCheck
			Toggle.MouseButton1Down:Connect(function()
				task.spawn(function()
					State = not State
					Callback(State)
					if State then
						TweenBackgroundTransparency(ToggleCheck, {
							["Time"] = 0.3,
							["BackgroundTransparency"] = 0.4
						})
					else
						TweenBackgroundTransparency(ToggleCheck, {
							["Time"] = 0.3,
							["BackgroundTransparency"] = 1
						})
					end
				end)
			end)
		end
		function LibraryItems:MakeTextBox(Text, Call)
			local Callback = Call or function() end
			local Textbox = MakeInstance("Frame")
			local TextboxLabel = MakeInstance("TextLabel")
			local TextboxCorner = MakeInstance("UICorner")
			local TextboxMain = MakeInstance("TextBox")
			local TextboxMainCorner = MakeInstance("UICorner")
			local TextboxMainTextSize = MakeInstance("UITextSizeConstraint")
			
			Textbox.Name = "Textbox"
			Textbox.BackgroundColor3 = FromRGB(44, 44, 44)
			Textbox.Position = UDim2New(-0.272727281, 0, 0.00749063678, 0)
			Textbox.Size = UDim2New(0, 238, 0, 30)

			TextboxLabel.Name = "TextboxLabel"
			TextboxLabel.BackgroundColor3 = FromRGB(255, 255, 255)
			TextboxLabel.BackgroundTransparency = 1.000
			TextboxLabel.Position = UDim2New(0.045363225, 0, 0, 0)
			TextboxLabel.Size = UDim2New(0, 157, 0, 30)
			TextboxLabel.Font = Enum.Font.GothamMedium
			TextboxLabel.Text = Text or "Enter your code"
			TextboxLabel.TextColor3 = FromRGB(211, 211, 211)
			TextboxLabel.TextSize = 13.000
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

			TextboxCorner.CornerRadius = UDim.new(0, 3)
			TextboxCorner.Name = "TextboxCorner"

			TextboxMain.Name = "TextboxMain"
			TextboxMain.BackgroundColor3 = FromRGB(29, 29, 29)
			TextboxMain.Position = UDim2New(0.705027103, 0, 0.199393719, 0)
			TextboxMain.Size = UDim2New(0, 64, 0, 18)
			TextboxMain.Font = Enum.Font.GothamMedium
			TextboxMain.Text = ""
			TextboxMain.TextColor3 = FromRGB(212, 212, 212)
			TextboxMain.TextScaled = true
			TextboxMain.TextSize = 12.000
			TextboxMain.TextWrapped = true

			TextboxMainCorner.CornerRadius = UDim.new(0, 3)
			TextboxMainCorner.Name = "TextboxMainCorner"

			TextboxMainTextSize.Name = "TextboxMainTextSize"
			TextboxMainTextSize.MaxTextSize = 12
			TextboxMainTextSize.MinTextSize = 2
			
			Textbox.Parent = Tab
			TextboxLabel.Parent = Textbox
			TextboxCorner.Parent = Textbox
			TextboxMain.Parent = Textbox
			TextboxMainCorner.Parent = TextboxMain
			TextboxMainTextSize.Parent = TextboxMain
			
			TextboxMain.FocusLost:Connect(function(enterPressed)
				if enterPressed and TextboxMain.Text ~= "" then
					if Callback then
						Callback(TextboxMain.Text)
					end
					TextboxMain.Text = ""
				end
			end)
		end
		function LibraryItems:MakeSlider(Name, Minimum, Maximum, Call)
			local Callback = Call or function() end
			local MinimumValue = Minimum or 0
			local MaximumValue = Maximum or 100
			
			local Slider = MakeInstance("Frame")
			local SliderText = MakeInstance("TextLabel")
			local SliderCorner = MakeInstance("UICorner")
			local SliderMain = MakeInstance("TextButton")
			local SliderMainCorner = MakeInstance("UICorner")
			local SliderLine = MakeInstance("Frame")
			local SliderLineCorner = MakeInstance("UICorner")
			local SliderLineGradient = MakeInstance("UIGradient")
			local SliderValue = MakeInstance("TextLabel")
			
			Slider.Name = "Slider"
			Slider.BackgroundColor3 = FromRGB(44, 44, 44)
			Slider.Position = UDim2New(-0.0335968323, 0, 0.411717504, 0)
			Slider.Size = UDim2New(0, 238, 0, 40)

			SliderText.Name = "SliderText"
			SliderText.Parent = Slider
			SliderText.BackgroundColor3 = FromRGB(255, 255, 255)
			SliderText.BackgroundTransparency = 1.000
			SliderText.Position = UDim2New(0.045363225, 0, 0.100000001, 0)
			SliderText.Size = UDim2New(0, 198, 0, 19)
			SliderText.Font = Enum.Font.GothamMedium
			SliderText.Text = Name or "Slide for fun!"
			SliderText.TextColor3 = FromRGB(211, 211, 211)
			SliderText.TextSize = 13.000
			SliderText.TextXAlignment = Enum.TextXAlignment.Left

			SliderCorner.CornerRadius = UDim.new(0, 3)
			SliderCorner.Name = "SliderCorner"

			SliderMain.Name = "SliderMain"
			SliderMain.BackgroundColor3 = FromRGB(29, 29, 29)
			SliderMain.BorderSizePixel = 0
			SliderMain.Position = UDim2New(0.0340000018, 0, 0.600000024, 0)
			SliderMain.Size = UDim2New(0, 221, 0, 10)
			SliderMain.AutoButtonColor = false
			SliderMain.Font = Enum.Font.SourceSans
			SliderMain.Text = " "
			SliderMain.TextColor3 = FromRGB(0, 0, 0)
			SliderMain.TextSize = 14.000

			SliderMainCorner.CornerRadius = UDim.new(0, 3)
			SliderMainCorner.Name = "SliderMainCorner"

			SliderLine.Name = "SliderLine"
			SliderLine.BackgroundColor3 = FromRGB(255, 255, 255)
			SliderLine.BorderSizePixel = 0
			SliderLine.Position = UDim2New(2.7617719e-07, 0, 0, 0)
			SliderLine.Size = UDim2New(0, 0, 0, 10)

			SliderLineCorner.CornerRadius = UDim.new(0, 3)
			SliderLineCorner.Name = "SliderLineCorner"
			 
			SliderLineGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color), ColorSequenceKeypoint.new(1.00, FromRGB(88, 88, 88))}
			SliderLineGradient.Name = "SliderLineGradient"

			SliderValue.Name = "SliderValue"
			SliderValue.BackgroundColor3 = FromRGB(255, 255, 255)
			SliderValue.BackgroundTransparency = 1.000
			SliderValue.Position = UDim2New(0.877295971, 0, 0.163274378, 0)
			SliderValue.Size = UDim2New(0, 24, 0, 12)
			SliderValue.Font = Enum.Font.GothamMedium
			SliderValue.Text = tostring(MinimumValue)
			SliderValue.TextColor3 = FromRGB(211, 211, 211)
			SliderValue.TextSize = 12.000
			SliderValue.TextWrapped = true
	
			local Value;
			local Move_Connection, Release_Connection
			
			Slider.Parent = Tab
			SliderCorner.Parent = Slider
			SliderMain.Parent = Slider
			SliderMainCorner.Parent = SliderMain
			SliderLine.Parent = SliderMain
			SliderLineCorner.Parent = SliderLine
			SliderLineGradient.Parent = SliderLine
			SliderValue.Parent = Slider
			
			SliderMain.MouseButton1Down:Connect(function()
				Value = math.floor((((tonumber(MaximumValue) - tonumber(MinimumValue)) / 221) * SliderLine.AbsoluteSize.X) + tonumber(MinimumValue)) or 0
				pcall(function()
					Callback(Value)
				end)
				SliderLine.Size = UDim2New(0, math.clamp(Mouse.X - SliderLine.AbsolutePosition.X, 0, 221), 0, 10)
				Move_Connection = Mouse.Move:Connect(function()
					SliderValue.Text = Value
					Value = math.floor((((tonumber(MaximumValue) - tonumber(MinimumValue)) / 221) * SliderLine.AbsoluteSize.X) + tonumber(MinimumValue))
					pcall(function()
						Callback(Value)
					end)
					SliderLine.Size = UDim2New(0, math.clamp(Mouse.X - SliderLine.AbsolutePosition.X, 0, 221), 0, 10)
				end)
				Release_Connection = UserInputService.InputEnded:Connect(function(MouseUIS)
					if MouseUIS.UserInputType == Enum.UserInputType.MouseButton1 then
						Value = math.floor((((tonumber(MaximumValue) - tonumber(MinimumValue)) / 221) * SliderLine.AbsoluteSize.X) + tonumber(MinimumValue))
						pcall(function()
							Callback(Value)
						end)
						SliderLine.Size = UDim2New(0, math.clamp(Mouse.X - SliderLine.AbsolutePosition.X, 0, 221), 0, 10)
						Move_Connection:Disconnect()
						Release_Connection:Disconnect()
					end
				end)
			end)
		end
		function LibraryItems:MakeDropdown(Name, Table, Call)
			local TableInfo = Table or {}
			local Callback = Call or function() end
			local Size = UDim2New(0, 238, 0, 0)
			local Dropdown = MakeInstance("Frame")
			local DropdownLabel = MakeInstance("TextLabel")
			local DropdownCorner = MakeInstance("UICorner")
			local Opener = MakeInstance("TextButton")
			local OpenerCorner = MakeInstance("UICorner")
			local DropdownMain = MakeInstance("Frame")
			local DropdownMainList = MakeInstance("UIListLayout")
			local DropdownMainCorner = MakeInstance("UICorner")
			
			Dropdown.Name = "Dropdown"
			Dropdown.BackgroundColor3 = FromRGB(44, 44, 44)
			Dropdown.Position = UDim2New(-0.272727281, 0, 0.00749063678, 0)
			Dropdown.Size = UDim2New(0, 238, 0, 30)

			DropdownLabel.Name = "DropdownLabel"
			DropdownLabel.BackgroundColor3 = FromRGB(255, 255, 255)
			DropdownLabel.BackgroundTransparency = 1.000
			DropdownLabel.Position = UDim2New(0.045363225, 0, 0, 0)
			DropdownLabel.Size = UDim2New(0, 157, 0, 30)
			DropdownLabel.Font = Enum.Font.GothamMedium
			DropdownLabel.Text = Name or "Select Your Team"
			DropdownLabel.TextColor3 = FromRGB(211, 211, 211)
			DropdownLabel.TextSize = 13.000
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

			DropdownCorner.CornerRadius = UDim.new(0, 3)
			DropdownCorner.Name = "DropdownCorner"

			Opener.Name = "Opener"
			Opener.BackgroundColor3 = FromRGB(29, 29, 29)
			Opener.Position = UDim2New(0.705027103, 0, 0.200000003, 0)
			Opener.Size = UDim2New(0, 64, 0, 18)
			Opener.Font = Enum.Font.GothamMedium
			Opener.Text = "Select"
			Opener.TextColor3 = FromRGB(211, 211, 211)
			Opener.TextSize = 12.000
			Opener.TextWrapped = true

			OpenerCorner.CornerRadius = UDim.new(0, 3)
			OpenerCorner.Name = "OpenerCorner"

			DropdownMain.Name = "DropdownMain"
			DropdownMain.BackgroundColor3 = FromRGB(29, 29, 29)
			DropdownMain.BorderSizePixel = 0
			DropdownMain.ClipsDescendants = true
			DropdownMain.Position = UDim2New(-2.6218195, 0, 1.28526819, 0)
			DropdownMain.Size = UDim2New(0, 238, 0, 0)
			DropdownMain.ZIndex = 2

			DropdownMainList.Name = "DropdownMainList"
			DropdownMainList.HorizontalAlignment = Enum.HorizontalAlignment.Center
			DropdownMainList.SortOrder = Enum.SortOrder.LayoutOrder
			DropdownMainList.Padding = UDim.new(0, 2)

			DropdownMainCorner.CornerRadius = UDim.new(0, 3)
			DropdownMainCorner.Name = "DropdownMainCorner"
			
			for i,v in next, TableInfo do
				local Option = MakeInstance("TextButton")
				local OptionCorner = MakeInstance("UICorner")
				Option.Name = "Option"
				Option.BackgroundColor3 = FromRGB(22, 22, 22)
				Option.BackgroundTransparency = 1.000
				Option.Position = UDim2New(0.115546219, 0, 0, 0)
				Option.Size = UDim2New(0, 181, 0, 18)
				Option.ZIndex = 2
				Option.Font = Enum.Font.GothamMedium
				Option.Text = v
				Option.TextColor3 = FromRGB(211, 211, 211)
				Option.TextSize = 12.000

				OptionCorner.CornerRadius = UDim.new(0, 3)
				OptionCorner.Name = "OptionCorner"
				
				Option.Parent = DropdownMain
				OptionCorner.Parent = Option
				
				Size = Size + UDim2New(0, 0, 0, 20)
				Option.MouseButton1Down:Connect(function()
					Opener.Text = v
					Callback(v)
					DropdownMain:TweenSize(UDim2New(0, 238, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, false)
				end)
			end
			Opener.MouseButton1Down:Connect(function()
				if DropdownMain.Size == UDim2New(0, 238, 0, 0) then
					DropdownMain:TweenSize(Size, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
				end
			end)
			
			Dropdown.Parent = Tab
			DropdownLabel.Parent = Dropdown
			DropdownCorner.Parent = Dropdown
			Opener.Parent = Dropdown
			OpenerCorner.Parent = Opener
			DropdownMain.Parent = Opener
			DropdownMainList.Parent = DropdownMain
			DropdownMainCorner.Parent = DropdownMain
		end
		function LibraryItems:MakeColorPicker(Name, Call)
			local Callback = Call or function() end
			local ColorPicker = MakeInstance("Frame")
			local ColorPickerTitle = MakeInstance("TextLabel")
			local ColorPickerCorner = MakeInstance("UICorner")
			local ColorPickerBar = MakeInstance("Frame")
			local ColorPickerBarCorner = MakeInstance("UICorner")
			local ColorPickerBarGradient = MakeInstance("UIGradient")
			local Picker = MakeInstance("TextLabel")
			local PickerCorner = MakeInstance("UICorner")
			
			ColorPicker.Name = "ColorPicker"
			ColorPicker.BackgroundColor3 = FromRGB(44, 44, 44)
			ColorPicker.Position = UDim2New(0.0296442695, 0, 0.251082242, 0)
			ColorPicker.Size = UDim2New(0, 238, 0, 51)

			ColorPickerTitle.Name = "ColorPickerTitle"
			ColorPickerTitle.BackgroundColor3 = FromRGB(255, 255, 255)
			ColorPickerTitle.BackgroundTransparency = 1.000
			ColorPickerTitle.Position = UDim2New(0.045363225, 0, 0, 0)
			ColorPickerTitle.Size = UDim2New(0, 219, 0, 30)
			ColorPickerTitle.Font = Enum.Font.GothamMedium
			ColorPickerTitle.Text = Name or "Select Team Color"
			ColorPickerTitle.TextColor3 = FromRGB(211, 211, 211)
			ColorPickerTitle.TextSize = 13.000
			ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left

			ColorPickerCorner.CornerRadius = UDim.new(0, 3)
			ColorPickerCorner.Name = "ColorPickerCorner"

			ColorPickerBar.Name = "ColorPickerBar"
			ColorPickerBar.BackgroundColor3 = FromRGB(255, 255, 255)
			ColorPickerBar.Position = UDim2New(0.0252100863, 0, 0.588235319, 0)
			ColorPickerBar.Size = UDim2New(0, 223, 0, 14)

			ColorPickerBarCorner.CornerRadius = UDim.new(0, 3)
			ColorPickerBarCorner.Name = "ColorPickerBarCorner"

			ColorPickerBarGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, FromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.12, FromRGB(255, 130, 47)), ColorSequenceKeypoint.new(0.22, FromRGB(255, 243, 73)), ColorSequenceKeypoint.new(0.34, FromRGB(133, 255, 89)), ColorSequenceKeypoint.new(0.45, FromRGB(108, 255, 182)), ColorSequenceKeypoint.new(0.52, FromRGB(121, 249, 255)), ColorSequenceKeypoint.new(0.61, FromRGB(144, 168, 255)), ColorSequenceKeypoint.new(0.72, FromRGB(160, 51, 255)), ColorSequenceKeypoint.new(0.80, FromRGB(255, 98, 227)), ColorSequenceKeypoint.new(0.88, FromRGB(139, 76, 47)), ColorSequenceKeypoint.new(0.94, FromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, FromRGB(255, 255, 255))}
			ColorPickerBarGradient.Name = "ColorPickerBarGradient"

			Picker.Name = "Picker"
			Picker.BackgroundColor3 = FromRGB(29, 29, 29)
			Picker.Position = UDim2New(0.705027103, 0, 0.101960786, 0)
			Picker.Size = UDim2New(0, 64, 0, 18)
			Picker.Font = Enum.Font.GothamMedium
			Picker.Text = "Preview"
			Picker.TextColor3 = FromRGB(211, 211, 211)
			Picker.TextSize = 12.000
			Picker.TextWrapped = true

			PickerCorner.CornerRadius = UDim.new(0, 3)
			PickerCorner.Name = "PickerCorner"
			
			
			ColorPicker.Parent = Tab
			ColorPickerCorner.Parent = ColorPicker
			ColorPickerTitle.Parent = ColorPicker
			ColorPickerBar.Parent = ColorPicker
			ColorPickerBarCorner.Parent = ColorPickerBar
			ColorPickerBarGradient.Parent = ColorPickerBar
			Picker.Parent = ColorPicker
			PickerCorner.Parent = Picker
			local ColorKeyPoints = ColorPickerBarGradient.Color.Keypoints
			local Selecting = false
			
			local function beginSelection()
				Selecting = true
				repeat wait()
					local minXPos = ColorPickerBar.AbsolutePosition.X
					local maxXPos = minXPos+ColorPickerBar.AbsoluteSize.X
					local xPixelSize = maxXPos-minXPos
					local mouseX = UserInputService:GetMouseLocation().X
					if mouseX<minXPos then
						mouseX = minXPos
					elseif mouseX>maxXPos then
						mouseX = maxXPos
					end
					local xPos = (mouseX-minXPos)/xPixelSize
					Picker.TextColor3 = GetColor(xPos,ColorKeyPoints)
					Callback(GetColor(xPos,ColorKeyPoints))
				until not Selecting
			end

			local function EndSelection()
				Selecting = false
			end

			local function InputBegan(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					beginSelection()
				end
			end
			ColorPickerBar.InputBegan:Connect(InputBegan)

			local function InputEnded(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					EndSelection()
				end
			end
			ColorPickerBar.InputEnded:Connect(InputEnded)
		end
		return LibraryItems
	end
	return LibraryTabs
end

return Library
