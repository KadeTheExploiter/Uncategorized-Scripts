local _cloneref = cloneref
if not _cloneref then -- [[ Failsafe Cloneref | Credits: Babyhamsta ]]
	local _getreg = getreg or debug and debug.getregistry
	local InstanceList: {Instance};

	for _, Value in (_getreg and _getreg() or {}) do
		if type(Value) ~= "table" then continue end
		if not (#Value > 0) then continue end

		local Mode = rawget(Value, "__mode")
		if Mode ~= "kvs" then continue end

		for _, Value2 in Value do
			if Value2 ~= workspace then continue end

			InstanceList = Value
			break
		end
	end

	_cloneref = function(Object: Instance)
		if not InstanceList or #InstanceList < 1 then
			return Object
		end

		for _, Value in InstanceList do
			if Value == Object then
				return Value
			end
		end
	end
end

local Players = _cloneref(game:GetService("Players"))
local TweenService = _cloneref(game:GetService("TweenService"))
local UserInputService = _cloneref(game:GetService("UserInputService"))

local LocalPlayer = Players.LocalPlayer
local DisplayName = string.sub(LocalPlayer.DisplayName, 1, 7)
local Mouse = LocalPlayer:GetMouse()

type Dictionary = {
	[any]: { Text: string?, Description: string? }
}

type InfoResult = {
	Target: Instance,
	Text: string,
	Description: string
}

local GuiLibrary = {}
local TabListersTable = {}
local TabsTable = {}

local LabelIcons = {
	Info = "rbxassetid://11422155687",
	Note = "rbxassetid://11419706143",
	Warning = "rbxassetid://11963364026",
	Danger = "rbxassetid://11419713314",
	Positive = "rbxassetid://11419719540",
}

local Themes = {
	White = {
		MainFrame = Color3.fromRGB(239, 239, 239),
		MainStroke = Color3.fromRGB(126, 126, 126),
		Sidebar = Color3.fromRGB(255, 255, 255),
		WindowButtonsFrame = Color3.fromRGB(255, 255, 255),
		PrimaryText = Color3.fromRGB(0, 0, 0),
		TabListerButton = Color3.fromRGB(255, 255, 255),
		TabListerButtonSelected = Color3.fromRGB(235, 235, 235),
		TabListerImage = Color3.fromRGB(30, 30, 30),
		Splitter = Color3.fromRGB(246, 246, 246),
		ProfileFrame = Color3.fromRGB(228, 228, 228),
		ProfileStroke = Color3.fromRGB(126, 126, 126),
		ProfileUsername = Color3.fromRGB(0, 0, 0),
		ProfileShadow = Color3.fromRGB(0, 0, 0),
		TabPlaceHolder = Color3.fromRGB(246, 246, 246),
		TabPlaceHolderStroke = Color3.fromRGB(126, 126, 126),
		WindowTitle = Color3.fromRGB(0, 0, 0),
		ButtonBackground = Color3.fromRGB(247, 254, 255),
		ButtonStroke = Color3.fromRGB(126, 126, 126),
		ButtonImage = Color3.fromRGB(102, 139, 146),
		ButtonText = Color3.fromRGB(0, 0, 0),
		ButtonDescription = Color3.fromRGB(112, 112, 112),
		ToggleBackground = Color3.fromRGB(255, 244, 244),
		ToggleBackgroundSelected = Color3.fromRGB(219, 237, 219),
		ToggleStroke = Color3.fromRGB(187, 116, 116),
		ToggleImage = Color3.fromRGB(166, 103, 103),
		SwitchIndicatorBackground = Color3.fromRGB(255, 255, 255),
		SwitchIndicatorStroke = Color3.fromRGB(146, 91, 91),
		TogglerBackground = Color3.fromRGB(255, 159, 159),
		TogglerStroke = Color3.fromRGB(146, 91, 91),
		TogglerShadow = Color3.fromRGB(255, 0, 0),
		Label = {
			NoteBackground = Color3.fromRGB(247, 247, 252),
			NoteStroke = Color3.fromRGB(165, 165, 190),
			NoteImage = Color3.fromRGB(125, 125, 180),
			NoteText = Color3.fromRGB(0, 0, 0),
			NoteDescription = Color3.fromRGB(112, 112, 112),

			WarningBackground = Color3.fromRGB(255, 251, 234),
			WarningStroke = Color3.fromRGB(215, 148, 40),
			WarningImage = Color3.fromRGB(230, 160, 60),
			WarningText = Color3.fromRGB(0, 0, 0),
			WarningDescription = Color3.fromRGB(112, 112, 112),

			DangerBackground = Color3.fromRGB(255, 235, 235),
			DangerStroke = Color3.fromRGB(210, 60, 60),
			DangerImage = Color3.fromRGB(220, 70, 70),
			DangerText = Color3.fromRGB(0, 0, 0),
			DangerDescription = Color3.fromRGB(112, 112, 112),

			InfoBackground = Color3.fromRGB(230, 240, 255),
			InfoStroke = Color3.fromRGB(90, 145, 200),
			InfoImage = Color3.fromRGB(60, 120, 200),
			InfoText = Color3.fromRGB(0, 0, 0),
			InfoDescription = Color3.fromRGB(112, 112, 112),

			PositiveBackground = Color3.fromRGB(225, 245, 230),
			PositiveStroke = Color3.fromRGB(80, 180, 110),
			PositiveImage = Color3.fromRGB(70, 160, 90),
			PositiveText = Color3.fromRGB(0, 0, 0),
			PositiveDescription = Color3.fromRGB(112, 112, 112),
		},

		SliderBackground = Color3.fromRGB(255, 255, 255),
		SliderBackgroundToggled = Color3.fromRGB(250, 243, 255),
		SliderStroke = Color3.fromRGB(139, 131, 187),
		SliderImage = Color3.fromRGB(151, 122, 163),
		SliderHandleBackground = Color3.fromRGB(255, 255, 255),
		SliderHandleStroke = Color3.fromRGB(119, 102, 135),
		SliderIndicatorBackground = Color3.fromRGB(179, 163, 210),
		SliderIndicatorStroke = Color3.fromRGB(76, 72, 94),
		SliderValueText = Color3.fromRGB(75, 77, 113),
		SliderShadow = Color3.fromRGB(151, 122, 163),
		DropdownBackground = Color3.fromRGB(243, 241, 230),
		DropdownStroke = Color3.fromRGB(193, 151, 120),
		DropdownImage = Color3.fromRGB(189, 124, 60),
		DropdownContainerBackground = Color3.fromRGB(240, 240, 240),
		DropdownContainerStroke = Color3.fromRGB(191, 140, 108),
		OptionBackground = Color3.fromRGB(255, 241, 231),
		OptionStroke = Color3.fromRGB(193, 151, 120),
		OptionImage = Color3.fromRGB(146, 124, 85),
		OptionText = Color3.fromRGB(0, 0, 0),
		OptionDescription = Color3.fromRGB(112, 112, 112),
		DropdownSelectionText = Color3.fromRGB(181, 127, 88),
		DropdownSelectionStroke = Color3.fromRGB(255, 165, 86),
		DropIndicatorImage = Color3.fromRGB(192, 138, 99),
		DropIndicatorShadow = Color3.fromRGB(255, 152, 48),
		TextboxBackground = Color3.fromRGB(255, 255, 255),
		TextboxStroke = Color3.fromRGB(187, 116, 170),
		TextboxImage = Color3.fromRGB(187, 116, 170),
		TextboxInitBackground = Color3.fromRGB(250, 250, 250),
		TextboxInitText = Color3.fromRGB(0, 0, 0),
		TextboxInitPlaceholder = Color3.fromRGB(136, 136, 136),
		TextboxInitStroke = Color3.fromRGB(187, 116, 170),
		TextboxText = Color3.fromRGB(0, 0, 0),
		TextboxDescription = Color3.fromRGB(112, 112, 112),
	},
	Dark = {
		MainFrame = Color3.fromRGB(35, 35, 40),
		MainStroke = Color3.fromRGB(80, 80, 90),
		Sidebar = Color3.fromRGB(45, 45, 50),
		WindowButtonsFrame = Color3.fromRGB(45, 45, 50),
		PrimaryText = Color3.fromRGB(225, 225, 225),
		TabListerButton = Color3.fromRGB(45, 45, 50),
		TabListerButtonSelected = Color3.fromRGB(65, 65, 70),
		TabListerImage = Color3.fromRGB(200, 200, 200),
		Splitter = Color3.fromRGB(55, 55, 60),
		ProfileFrame = Color3.fromRGB(55, 55, 60),
		ProfileStroke = Color3.fromRGB(90, 90, 100),
		ProfileUsername = Color3.fromRGB(225, 225, 225),
		ProfileShadow = Color3.fromRGB(0, 0, 0),
		TabPlaceHolder = Color3.fromRGB(40, 40, 45),
		TabPlaceHolderStroke = Color3.fromRGB(80, 80, 90),
		WindowTitle = Color3.fromRGB(225, 225, 225),
		ButtonBackground = Color3.fromRGB(60, 60, 65),
		ButtonStroke = Color3.fromRGB(100, 100, 110),
		ButtonImage = Color3.fromRGB(150, 180, 190),
		ButtonText = Color3.fromRGB(225, 225, 225),
		ButtonDescription = Color3.fromRGB(170, 170, 170),
		ToggleBackground = Color3.fromRGB(60, 60, 65),
		ToggleBackgroundSelected = Color3.fromRGB(60, 65, 61),
		ToggleStroke = Color3.fromRGB(120, 80, 80),
		ToggleImage = Color3.fromRGB(200, 150, 150),
		SwitchIndicatorBackground = Color3.fromRGB(70, 70, 75),
		SwitchIndicatorStroke = Color3.fromRGB(100, 60, 60),
		TogglerBackground = Color3.fromRGB(200, 100, 100),
		TogglerStroke = Color3.fromRGB(100, 60, 60),
		TogglerShadow = Color3.fromRGB(255, 0, 0),

		Label = {
			NoteBackground = Color3.fromRGB(60, 60, 65),
			NoteStroke = Color3.fromRGB(100, 100, 80),
			NoteImage = Color3.fromRGB(180, 180, 130),
			NoteText = Color3.fromRGB(225, 225, 225),
			NoteDescription = Color3.fromRGB(170, 170, 170),

			WarningBackground = Color3.fromRGB(70, 71, 56),
			WarningStroke = Color3.fromRGB(200, 120, 40),
			WarningImage = Color3.fromRGB(220, 140, 60),
			WarningText = Color3.fromRGB(225, 225, 225),
			WarningDescription = Color3.fromRGB(144, 144, 144),

			DangerBackground = Color3.fromRGB(75, 49, 49),
			DangerStroke = Color3.fromRGB(200, 50, 50),
			DangerImage = Color3.fromRGB(220, 70, 70),
			DangerText = Color3.fromRGB(225, 225, 225),
			DangerDescription = Color3.fromRGB(133, 133, 133),

			InfoBackground = Color3.fromRGB(45, 55, 70),
			InfoStroke = Color3.fromRGB(90, 135, 180),
			InfoImage = Color3.fromRGB(110, 160, 220),
			InfoText = Color3.fromRGB(225, 225, 225),
			InfoDescription = Color3.fromRGB(170, 170, 170),

			PositiveBackground = Color3.fromRGB(40, 60, 50),
			PositiveStroke = Color3.fromRGB(80, 160, 100),
			PositiveImage = Color3.fromRGB(100, 200, 130),
			PositiveText = Color3.fromRGB(225, 225, 225),
			PositiveDescription = Color3.fromRGB(170, 170, 170),
		},

		SliderBackground = Color3.fromRGB(60, 60, 65),
		SliderBackgroundToggled = Color3.fromRGB(69, 63, 73),
		SliderStroke = Color3.fromRGB(100, 90, 130),
		SliderImage = Color3.fromRGB(170, 140, 180),
		SliderHandleBackground = Color3.fromRGB(70, 70, 75),
		SliderHandleStroke = Color3.fromRGB(90, 80, 110),
		SliderIndicatorBackground = Color3.fromRGB(150, 130, 180),
		SliderIndicatorStroke = Color3.fromRGB(80, 70, 100),
		SliderValueText = Color3.fromRGB(180, 180, 200),
		SliderShadow = Color3.fromRGB(151, 122, 163),
		DropdownBackground = Color3.fromRGB(60, 60, 65),
		DropdownStroke = Color3.fromRGB(100, 80, 70),
		DropdownImage = Color3.fromRGB(200, 150, 100),
		DropdownContainerBackground = Color3.fromRGB(50, 50, 55),
		DropdownContainerStroke = Color3.fromRGB(100, 80, 70),
		OptionBackground = Color3.fromRGB(70, 70, 75),
		OptionStroke = Color3.fromRGB(130, 100, 70),
		OptionImage = Color3.fromRGB(180, 150, 100),
		OptionText = Color3.fromRGB(225, 225, 225),
		OptionDescription = Color3.fromRGB(170, 170, 170),
		DropdownSelectionText = Color3.fromRGB(200, 150, 100),
		DropdownSelectionStroke = Color3.fromRGB(220, 170, 120),
		DropIndicatorImage = Color3.fromRGB(200, 150, 100),
		DropIndicatorShadow = Color3.fromRGB(200, 150, 100),
		TextboxBackground = Color3.fromRGB(60, 60, 65),
		TextboxStroke = Color3.fromRGB(120, 80, 110),
		TextboxImage = Color3.fromRGB(200, 150, 190),
		TextboxInitBackground = Color3.fromRGB(50, 50, 55),
		TextboxInitText = Color3.fromRGB(225, 225, 225),
		TextboxInitPlaceholder = Color3.fromRGB(150, 150, 150),
		TextboxInitStroke = Color3.fromRGB(120, 80, 110),
		TextboxText = Color3.fromRGB(225, 225, 225),
		TextboxDescription = Color3.fromRGB(170, 170, 170),
	}
}

local function GetSecureContainer(): ScreenGui?
	local HiddenGuiFunction = get_hidden_gui or gethui

	if HiddenGuiFunction then
		return HiddenGuiFunction()
	end
	
	local Success, Container = pcall(function()
		return _cloneref(game:GetService("CoreGui"))
	end)
	
	if Success then
		return Container
	end

	local Success, Container = pcall(function()
		return _cloneref(LocalPlayer:FindFirstChildOfClass("PlayerGui"))
	end)

	if Success then
		return Container
	end
end

local function TweenProperty(Object: Instance, Time: number, Properties: {any}, DestroyOnEnd: boolean?)
	local _TweenInfo = TweenInfo.new(Time)

	local _Tween = TweenService:Create(Object, _TweenInfo, Properties)

	_Tween.Completed:Once(function()
		_Tween:Destroy()
		_Tween = nil

		if DestroyOnEnd then
			Object:Destroy()
		end
	end)

	_Tween:Play()
end

local function CreateObjectWithProperties(ClassName: string, Properties: {any}, TablesToInsertTo: {}?)
	local Object = Instance.new(ClassName)

	local Parent;

	for Property, Value in Properties do
		if Property == "Parent" then
			Parent = Value
			continue
		end

		Object[Property] = Value
	end

	if Parent and typeof(Parent) == "Instance" then
		Object.Parent = Parent
	end

	if TablesToInsertTo and type(TablesToInsertTo) == "table" then
		TablesToInsertTo[#TablesToInsertTo+1] = Object
	end
	
	return Object
end

local function BubbleClickEffect(GuiInstance: GuiObject, Input: InputObject?)
	local ClickSound = Instance.new("Sound")
	ClickSound.SoundId = "rbxassetid://15675032796"
	ClickSound.Parent = GuiInstance
	ClickSound.Ended:Once(function()
		ClickSound:Destroy()
	end)

	local AbsolutePosition = GuiInstance.AbsolutePosition
	local GuiPosition = GuiInstance.Position
	local AbsoluteSize = GuiInstance.AbsoluteSize
	local Container = GuiInstance:FindFirstChild("DropContainer") or GuiInstance

	local InputPosition;

	if Input then
		InputPosition = Input.Position
	else
		InputPosition = AbsolutePosition + (AbsoluteSize / 2)
	end

	local X = InputPosition.X - AbsolutePosition.X
	local Y = InputPosition.Y - AbsolutePosition.Y

	X /= AbsoluteSize.X
	Y /= AbsoluteSize.Y

	local CircleMain = CreateObjectWithProperties("Frame", {
		Position = UDim2.new(X, 0, Y, 0),
		Size = UDim2.new(0, 0, 1, 0),
		ZIndex = 4,
		BackgroundColor3 = Color3.fromRGB(125,125,125),
		BackgroundTransparency = 0.75,
		Parent = Container
	})

	CreateObjectWithProperties("UICorner", {
		CornerRadius = UDim.new(1,0),
		Parent = CircleMain
	})

	ClickSound:Play()
	task.spawn(TweenProperty, CircleMain, 0.5, {
		Size = UDim2.fromScale(2, 10),
		Position = GuiPosition - UDim2.fromScale(1, 5);
		BackgroundTransparency = 1;
	}, true)
end

local function FluentTextChange(NewText: string, Object: GuiLabel, Parent: Instance): GuiLabel
	if type(NewText) ~= "string" then
		return
	end

	local Clone = Object:Clone()
	TweenProperty(Object, 0.25, {TextTransparency = 1}, true)

	Clone.TextTransparency = 1
	Clone.Text = NewText
	Clone.Parent = Parent

	TweenProperty(Clone, 0.25, {TextTransparency = 0})

	return Clone
end

local function ApplyCallback(Object: Instance, Signal: RBXScriptSignal, Callback: (...any) -> (...any))
	local StartSignal: RBXScriptSignal;
	local EndSignal: RBXScriptSignal;

	StartSignal = Signal:Connect(Callback)
	
	EndSignal = Object:GetPropertyChangedSignal("Parent"):Once(function()
		EndSignal:Disconnect()
		StartSignal:Disconnect()
	end)
end

local function ParseDictionary(Key: any, Value: any): InfoResult?
	local Target: Instance? = nil
	local Text: string = ""
	local Description: string = ""

	if typeof(Key) == "Instance" then
		Target = Key
		if typeof(Value) == "table" then
			Text = tostring(Value[1] or Key.Name)
			Description = tostring(Value[2] or "")
		else
			Text = tostring(Value) ~= "nil" and tostring(Value) or Key.Name
		end
	elseif typeof(Value) == "Instance" then
		Target = Value
		Text = Value.Name
	elseif typeof(Value) == "table" then
		if typeof(Value[1]) == "Instance" then
			Target = Value[1]
			Text = tostring(Value[2] or Target.Name)
			Description = tostring(Value[3] or "")
		else
			Target = Value[1] or Value[2] or Value[3]
			Text = tostring(Value[2] or Value[1])
			Description = tostring(Value[3] or "")
		end
	elseif typeof(Value) == "string" or typeof(Value) == "number" or typeof(Value) == "boolean" then
		Target = Value
		Text = tostring(Value)
	elseif typeof(Key) == "string" or typeof(Key) == "number" or typeof(Key) == "boolean" then
		Target = Key
		Text = tostring(Key)
	else
		return nil
	end

	return {
		Target = Target,
		Text = Text,
		Description = Description
	}
end

local GuiButtons = setmetatable({}, {
	__newindex = function(self, Key, Value)
		rawset(self, Key, Value)

		if typeof(Value) == "Instance" and Value:IsA("GuiButton") then
			ApplyCallback(Value, Value.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					BubbleClickEffect(Value, Input)
				end
			end)
		end
	end
})
function GuiLibrary:Load(Name: string, SelectedTheme: string)
	if type(Name) ~= "string" then
		Name = "Machina"
		warn(`[MACHINA] Wrong entry for Name.`)
	end

	if type(SelectedTheme) ~= "string" then
		SelectedTheme = "White"
		warn(`[MACHINA] SelectedTheme isn't a string.`)
	end

	if SelectedTheme ~= "White" and SelectedTheme ~= "Dark" then
		SelectedTheme = "White"
		warn(`[MACHINA] Wrong entry for SelectedTheme.`)
	end

	local MinMainHeight = 300
	local MinMainWidth = 500
	local CurrentHeight = 450
	local CurrentWidth = 550

	local IsResizing = false
	local IsInFullScreen = false
	local IsInMinimized = false

	local LastOpenTab: Frame;
	local InitialMousePosOnDrag: Vector2
	local InitialSizeOnDrag: Vector2
	local ResizeMoveConnection: RBXScriptConnection
	local ResizeUpConnection: RBXScriptConnection
	local Theme = Themes[SelectedTheme]

	local MachinaScreenGui = CreateObjectWithProperties("ScreenGui", {
		Name = Name or "Machina",
	})

	local TempFrame = CreateObjectWithProperties("Frame", {
		Size = UDim2.fromScale(1,1),
		Visible = false,
		Parent = MachinaScreenGui
	})

	local _AbsolutePosition = TempFrame.AbsolutePosition
	local _AbsoluteSize = TempFrame.AbsoluteSize

	local PreviousLocation: UDim2
	local PreviousSize: UDim2
	local CenterOfTheScreen = UDim2.new(0, _AbsolutePosition.X + (_AbsoluteSize.X / 2) - 200, 0, -_AbsolutePosition.Y + (_AbsoluteSize.Y / 2) - 200 )

	TempFrame:Destroy()

	local MainFrame = CreateObjectWithProperties("Frame", {
		Name = "Main",
		-- Parent = MachinaScreenGui, (optimization trick: parent mainframe at the end best regards kade)
		Size = UDim2.new(0, 550, 0, 450),
		Active = false,
		Position = CenterOfTheScreen,
		BackgroundColor3 = Theme.MainFrame,
		BorderSizePixel = 0
	})

	local TabsFolder = CreateObjectWithProperties("Folder", {
		Name = "Tabs",
		Parent = MainFrame
	})

	local DragDetector = CreateObjectWithProperties("UIDragDetector", {
		Parent = MainFrame
	})

	CreateObjectWithProperties("UICorner", {
		Name = "_MainCorner",
		CornerRadius = UDim.new(0, 6),
		Parent = MainFrame
	})

	CreateObjectWithProperties("UIStroke", {
		Name = "_MainStroke",
		Color = Theme.MainStroke,
		Parent = MainFrame
	})

	local MiscFolder = CreateObjectWithProperties("Folder", {
		Name = "Misc",
		Parent = MainFrame
	})

	local TabPlaceHolderShadow = CreateObjectWithProperties("ImageLabel", {
		Name = "TabPlaceHolderShadow",
		Parent = MiscFolder,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Theme.ProfileShadow,
		ImageTransparency = 0.81,
		Size = UDim2.new(1, -170, 1, -35),
		Position = UDim2.new(1, -5, 0, 35),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Active = false,
		ZIndex = 0,
	})

	local WindowTitle = CreateObjectWithProperties("TextLabel", {
		Name = "WindowTitle",
		Parent = MiscFolder,
		Text = Name,
		Size = UDim2.new(1, -160, 0, 24),
		Position = UDim2.new(1, 0, 0, 5),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextColor3 = Theme.WindowTitle,
		TextSize = 16,
		TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = 2,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		BorderSizePixel = 0, 
		Active = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	local MainFrameShadow = CreateObjectWithProperties("ImageLabel", {
		Name = "GUIShadow",
		Parent = MiscFolder,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Theme.ProfileShadow,
		Size = UDim2.new(1, 16, 1, 12),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = -1,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	local ResizeGrip = CreateObjectWithProperties("TextButton", {
		Name = "GuiGrip",
		Parent = MiscFolder,
		Text = "",
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = 3,
		BorderSizePixel = 0, 
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	ApplyCallback(ResizeGrip, ResizeGrip.MouseButton1Down, function()
		if IsInFullScreen then
			return
		end

		IsResizing = true
		InitialMousePosOnDrag = UserInputService:GetMouseLocation()
		InitialSizeOnDrag = MainFrame.AbsoluteSize

		if ResizeMoveConnection then
			ResizeMoveConnection:Disconnect()
			ResizeMoveConnection = nil
		end
		if ResizeUpConnection then
			ResizeUpConnection:Disconnect()
			ResizeUpConnection = nil
		end

		ResizeMoveConnection = UserInputService.InputChanged:Connect(function(Input)
			if IsResizing and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				local CurrentMousePos = UserInputService:GetMouseLocation()
				local Delta = CurrentMousePos - InitialMousePosOnDrag

				CurrentWidth = math.max(MinMainWidth, InitialSizeOnDrag.X + Delta.X)
				CurrentHeight = math.max(MinMainHeight, InitialSizeOnDrag.Y + Delta.Y)

				MainFrame.Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight)
			end
		end)

		ResizeUpConnection = UserInputService.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if IsResizing then
					IsResizing = false
					if ResizeMoveConnection then
						ResizeMoveConnection:Disconnect()
						ResizeMoveConnection = nil
					end
					if ResizeUpConnection then
						ResizeUpConnection:Disconnect()
						ResizeUpConnection = nil
					end
				end
			end
		end)
	end)

	local SidebarFrame = CreateObjectWithProperties("Frame", {
		Name = "Sidebar",
		Parent = MainFrame,
		Size = UDim2.new(0, 160, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	CreateObjectWithProperties("Frame", {
		Name = "GapFill",
		Parent = SidebarFrame,
		Size = UDim2.new(-0.96296, 135, 1, 0),
		Position = UDim2.new(0.96296, 0, 0, 0),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	CreateObjectWithProperties("Frame", {
		Name = "Splitter",
		Parent = SidebarFrame,
		Size = UDim2.new(1, -10, 0, 2),
		Position = UDim2.new(0.5, 0, 0, 30),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Theme.Splitter,
		ZIndex = 3,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	CreateObjectWithProperties("UICorner", {
		Name = "_SidebarCorner",
		CornerRadius = UDim.new(0, 6),
		Parent = SidebarFrame
	})

	local TabsFrame = CreateObjectWithProperties("Frame", {
		Name = "Tabs",
		Parent = SidebarFrame,
		Size = UDim2.new(1, -10, 1, -90),
		Position = UDim2.new(0.5, 0, 0, 35),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	CreateObjectWithProperties("UIGridLayout", {
		Name = "_TabsOrderLayout",
		Parent = TabsFrame,
		CellSize = UDim2.new(1, 0, 0, 28),
		CellPadding = UDim2.new(0, 0, 0, 1),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local WindowButtonsFrame = CreateObjectWithProperties("Frame", {
		Name = "WindowButtons",
		Parent = SidebarFrame,
		Size = UDim2.new(0, 54, 0, 12),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundColor3 = Theme.WindowButtonsFrame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	local CloseButton = CreateObjectWithProperties("TextButton", {
		Name = "Close",
		Text = "",
		TextSize = 14,
		TextColor3 = Theme.PrimaryText,
		BackgroundColor3 = Color3.fromRGB(255, 66, 66),
		ClipsDescendants = true,
		Size = UDim2.new(0, 14, 0, 14),
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BorderSizePixel = 0, 
		Active = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Parent = WindowButtonsFrame,
	})

	ApplyCallback(CloseButton, CloseButton.MouseButton1Down, function()
		MachinaScreenGui:Destroy()
	end)
	
	CreateObjectWithProperties("UICorner", {
		Name = "_CloseCorner",
		CornerRadius = UDim.new(1, 0),
		Parent = CloseButton
	})

	local FullscreenButton = CreateObjectWithProperties("TextButton", {
		Name = "Fullscreen",
		Parent = WindowButtonsFrame,
		Text = "",
		TextSize = 14,
		TextColor3 = Theme.PrimaryText,
		BackgroundColor3 = Color3.fromRGB(255, 211, 75),
		Size = UDim2.new(0, 14, 0, 14),
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BorderSizePixel = 0, 
		Active = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	local MinimizeButton = CreateObjectWithProperties("TextButton", {
		Name = "Minimize",
		Text = "",
		TextSize = 14,
		TextColor3 = Theme.PrimaryText,
		BackgroundColor3 = Color3.fromRGB(73, 217, 78),
		Size = UDim2.new(0, 14, 0, 14),
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BorderSizePixel = 0, 
		Active = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Parent = WindowButtonsFrame,
	})

	CreateObjectWithProperties("UICorner", {
		Name = "_FullscreenCorner",
		CornerRadius = UDim.new(1, 0),
		Parent = FullscreenButton
	})
	
	CreateObjectWithProperties("UICorner", {
		Name = "_MinimizeCorner",
		CornerRadius = UDim.new(1, 0),
		Parent = MinimizeButton
	})

	
	ApplyCallback(MinimizeButton, MinimizeButton.MouseButton1Down, function()
		local IsVisible = IsInMinimized

		if IsInFullScreen then
			IsInFullScreen = false
			TweenProperty(MainFrame, 0.25, {Size = PreviousSize, Position = PreviousLocation})

			task.wait(0.25)
		end

		IsInMinimized = not IsInMinimized

		if LastOpenTab then
			LastOpenTab.Visible = IsVisible
		end

		ResizeGrip.Visible = IsVisible
		WindowTitle.Visible = IsVisible
		TabsFrame.Visible = IsVisible
		TabPlaceHolderShadow.Visible = IsVisible
		TweenProperty(MainFrameShadow, 0.25, {ImageTransparency = IsInMinimized and 0.4 or 0})

		if IsInMinimized then
			PreviousSize = MainFrame.Size
			PreviousLocation = MainFrame.Position

			TweenProperty(MainFrame, 0.25, {Size = UDim2.fromOffset(160, 85)})
		else
			TweenProperty(MainFrame, 0.25, {Size = PreviousSize})
		end
	end)


	ApplyCallback(FullscreenButton, FullscreenButton.MouseButton1Down, function()
		IsInFullScreen = not IsInFullScreen

		if IsInMinimized then
			IsInMinimized = false

			ResizeGrip.Visible = true
			WindowTitle.Visible = true
			TabsFrame.Visible = true
			TabPlaceHolderShadow.Visible = true
			TweenProperty(MainFrameShadow, 0.25, {ImageTransparency = 0})
			TweenProperty(MainFrame, 0.25, {Size = PreviousSize})

			task.wait(0.25)
		end

		if IsInFullScreen then
			IsInMinimized = false
			PreviousSize = MainFrame.Size
			PreviousLocation = MainFrame.Position

			TweenProperty(MainFrame, 0.25, {Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0,0)})
		else
			if LastOpenTab then
				LastOpenTab.Visible = true
			end

			TweenProperty(MainFrame, 0.25, {Size = PreviousSize, Position = PreviousLocation})
		end
	end)
	
	ApplyCallback(DragDetector, DragDetector.DragEnd, function()
		if IsInFullScreen then
			IsInFullScreen = false

			local NewPosition = UDim2.fromOffset(Mouse.X, Mouse.Y)

			task.spawn(TweenProperty, MainFrame, 0.2, {Size = PreviousSize, Position = NewPosition})
		end
	end)

	CreateObjectWithProperties("UIListLayout", {
		Name = "WindowButtonsLayout",
		Parent = WindowButtonsFrame,
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6)
	})


	local ProfileFrame = CreateObjectWithProperties("Frame", {
		Name = "Profile",
		Parent = SidebarFrame,
		Size = UDim2.new(1, -20, 0, 35),
		Position = UDim2.new(0.5, 0, 1, -45),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Theme.ProfileFrame,
		ZIndex = 3,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	CreateObjectWithProperties("UICorner", {
		Name = "_ProfileCorner",
		CornerRadius = UDim.new(0, 6),
		Parent = ProfileFrame
	})

	CreateObjectWithProperties("UIStroke", {
		Name = "_ProfileStroke",
		Color = Theme.ProfileStroke,
		Parent = ProfileFrame
	})

	CreateObjectWithProperties("TextLabel", {
		Name = "_ProfileUsername",
		Parent = ProfileFrame,
		Text = "Hello, " .. DisplayName,
		TextSize = 16,
		TextColor3 = Theme.ProfileUsername,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1.04667, -45, 0, 20),
		Position = UDim2.new(-0.04667, 46, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = 3,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	local ImageAsset, IsReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)

	local ProfileIcon = CreateObjectWithProperties("ImageLabel", {
		Name = "_ProfileIcon",
		Parent = ProfileFrame,
		Image = (IsReady and ImageAsset) or "rbxassetid://192608797",
		Size = UDim2.new(0, 24, 0, 24),
		Position = UDim2.new(0, 5, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex = 3,
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	CreateObjectWithProperties("UICorner", {
		Name = "_TabListerCorner",
		CornerRadius = UDim.new(25, 0),
		Parent = ProfileIcon
	})

	CreateObjectWithProperties("UIStroke", {
		Parent = ProfileIcon,
		Color = Theme.ProfileStroke
	})

	CreateObjectWithProperties("ImageLabel", {
		Name = "_ProfileShadow",
		Parent = ProfileFrame,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Theme.ProfileShadow,
		ImageTransparency = 0.8,
		Size = UDim2.new(1, 6, 1, 4),
		Position = UDim2.new(0.5, 0, 0.5, 3),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0, 
		Active = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0)
	})

	local Children = {}

	function Children:GetScreenGui()
		return MachinaScreenGui
	end

	function Children:NewTabEntry(TabName: string, CustomImage: string?)
		if type(TabName) ~= "string" then
			TabName = "New Tab"
			warn(`[MACHINA] Wrong entry for TabName.`)
		end

		if type(CustomImage) ~= "string" then
			CustomImage = nil
		end

		if CustomImage and string.len(CustomImage) < 5 then
			CustomImage = nil
		end
		
		-- TabLister

		local TabListerButton = CreateObjectWithProperties("TextButton", {
			Name = "TabLister" .. TabName,
			Parent = TabsFrame,
			Text = "",
			TextSize = 14,
			TextColor3 = Theme.PrimaryText,
			BackgroundColor3 = Theme.TabListerButton,
			Size = UDim2.new(0, 150, 0, 28),
			Position = UDim2.new(0, 0, 0.08065, 0),
			AutoButtonColor = false,
			ZIndex = 2,
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			BorderSizePixel = 0, 
			Active = true,
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		local GuiOffset = CustomImage and 30 or 10
		CreateObjectWithProperties("TextLabel", {
			Name = "_TabListerText",
			Parent = TabListerButton,
			Text = TabName,
			TextSize = 16,
			TextColor3 = Theme.PrimaryText,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -GuiOffset, 1, -1),
			Position = UDim2.new(0, GuiOffset, 0, 1),
			ZIndex = 2,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			BorderSizePixel = 0, 
			Active = true,
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		if CustomImage then
			CreateObjectWithProperties("ImageLabel", {
				Name = "_TabListerImage",
				Parent = TabListerButton,
				Image = CustomImage, --"rbxassetid://11419717892",
				ImageColor3 = Theme.TabListerImage,
				Size = UDim2.new(0, 20, 0, 20),
				Position = UDim2.new(0, 5, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0, 
				Active = false,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})
		end

		CreateObjectWithProperties("UICorner", {
			Name = "_TabListerCorner",
			CornerRadius = UDim.new(0, 6),
			Parent = TabListerButton
		})

		-- TabFrame

		local TabPlaceHolderFrame = CreateObjectWithProperties("Frame", {
			Name = "TabContainer",
			Parent = TabsFolder,
			Visible = false,
			Size = UDim2.new(1, -180, 1, -45),
			Position = UDim2.new(1, -10, 0, 35),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Theme.TabPlaceHolder,
			ClipsDescendants = true,
			BorderSizePixel = 0, 
			Active = false,
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		CreateObjectWithProperties("UIStroke", {
			Name = "_TabPlaceHolderStroke",
			Color = Theme.TabPlaceHolderStroke,
			Parent = TabPlaceHolderFrame
		})

		CreateObjectWithProperties("UICorner", {
			Name = "_TabPlaceHolderCorner",
			CornerRadius = UDim.new(0, 6),
			Parent = TabPlaceHolderFrame
		})

		local TabScrollingFrame = CreateObjectWithProperties("ScrollingFrame", {
			Name = "Tab" .. TabName,
			Parent = TabPlaceHolderFrame,
			Size = UDim2.new(1, -10, 1, -21),
			Position = UDim2.new(0.5, 0, 0, 10),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ClipsDescendants = false,
			ScrollBarThickness = 0,
			BorderSizePixel = 0, 
			Active = false,
			BorderColor3 = Color3.fromRGB(0, 0, 0)
		})

		CreateObjectWithProperties("UIListLayout", {
			Name = "TabLayout",
			Parent = TabScrollingFrame,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
		})

		table.insert(TabsTable, TabPlaceHolderFrame)
		table.insert(TabListersTable, TabListerButton)

		ApplyCallback(TabListerButton, TabListerButton.MouseButton1Down, function()
			for _, Tab: Instance in TabsTable do
				if Tab == TabPlaceHolderFrame then
					continue
				end

				Tab.Visible = false
			end

			for _, TabLister: Instance in TabListersTable do
				if TabLister == TabListerButton then
					continue
				end

				TweenProperty(TabLister, 0.33, {BackgroundColor3 = Theme.TabListerButton})
			end

			TweenProperty(TabListerButton, 0.33, {BackgroundColor3 = Theme.TabListerButtonSelected})
			LastOpenTab = TabPlaceHolderFrame
			TabPlaceHolderFrame.Visible = true
		end)

		local Descendants = {}

		function Descendants:NewButtonEntry(ButtonText: string, ButtonDescription: string, Callback: (...any?) -> (...any?))
			if type(Callback) ~= "function" then
				warn(`[MACHINA] Callback is not a function, Ignoring.`)
				
				return;
			end

			if type(ButtonText) ~= "string" then
				ButtonText = "Click Me!"
				warn(`[MACHINA] ButtonText is not a string.`)
			end

			if type(ButtonDescription) ~= "string" then
				ButtonDescription = "Short Description."
				warn(`[MACHINA] ButtonDescription is not a string.`)
			end

			local ButtonTemplate = CreateObjectWithProperties("TextButton", {
				Name = "Button" .. ButtonText,
				Parent = TabScrollingFrame,
				Text = "",
				Size = UDim2.new(1, -10, 0, 45),
				AutoButtonColor = false,
				BackgroundColor3 = Theme.ButtonBackground,
				ZIndex = 2,
				BorderSizePixel = 0, 
				Active = true,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				TextColor3 = Theme.ButtonText,
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			}, GuiButtons)

			CreateObjectWithProperties("Frame", {
				Name = "DropContainer",
				ClipsDescendants = true,
				Parent = ButtonTemplate,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0, 
				Active = true,
			}, GuiButtons)

			CreateObjectWithProperties("UICorner", {
				Name = "_ButtonCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = ButtonTemplate
			})

			CreateObjectWithProperties("UIStroke", {
				Name = "_ButtonStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.ButtonStroke,
				Parent = ButtonTemplate
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_ButtonShadow",
				Parent = ButtonTemplate,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 14, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0, 
				Active = false,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_ButtonImage",
				Parent = ButtonTemplate,
				Image = "rbxassetid://12974400533",
				ImageColor3 = Theme.ButtonImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0, 
				Active = false,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _ButtonText = CreateObjectWithProperties("TextLabel", {
				Name = "_ButtonText",
				Parent = ButtonTemplate,
				Text = ButtonText,
				Size = UDim2.new(1, -41, 0, 21),
				Position = UDim2.new(0, 41, 0, 5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonText,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0, 
				Active = false,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _ButtonDescription = CreateObjectWithProperties("TextLabel", {
				Name = "_ButtonDescription",
				Parent = ButtonTemplate,
				Text = ButtonDescription,
				Size = UDim2.new(1, -41, 0, 18),
				Position = UDim2.new(0, 41, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonDescription,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
				BorderSizePixel = 0, 
				Active = false,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})
			
			local function Wrap()
				return task.spawn(Callback)
			end
			
			ApplyCallback(ButtonTemplate, ButtonTemplate.MouseButton1Down, Wrap)

			local Extras = {}

			function Extras:UpdateText(NewButtonText: string)
				local Clone = FluentTextChange(NewButtonText, _ButtonText, ButtonTemplate)
				_ButtonText = Clone
			end

			function Extras:UpdateDescription(NewButtonDescription: string)
				local Clone = FluentTextChange(NewButtonDescription, _ButtonDescription, ButtonTemplate)
				_ButtonText = Clone
			end

			function Extras:Destroy()
				ButtonTemplate:Destroy()
			end

			return Extras
		end

		function Descendants:NewToggleEntry(ToggleText: string, ToggleDescription: string, DefaultState: boolean, Callback: (...any?) -> (...any?))
			if type(Callback) ~= "function" then
				warn(`[MACHINA] Callback is not a function, Ignoring.`)
				
				return;
			end

			if type(ToggleText) ~= "string" then
				ToggleText = "Click Me!"
				warn(`[MACHINA] ToggleText is not a string.`)
			end

			if type(DefaultState) ~= "boolean" then
				DefaultState = false

				warn(`[MACHINA] DefaultState is not a boolean.`)
			end

			if type(ToggleDescription) ~= "string" then
				ToggleDescription = "noob"
				warn(`[MACHINA] ToggleDescription is not a string.`)
			end

			local ToggleTemplate = CreateObjectWithProperties("TextButton", {
				Name = "Toggle",
				Parent = TabScrollingFrame,
				Text = "",
				Size = UDim2.new(1, -10, 0, 45),
				Position = UDim2.new(0.00836, 0, 0.01689, 0),
				AutoButtonColor = false,
				BackgroundColor3 = Theme.ToggleBackground,
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				TextColor3 = Theme.PrimaryText,
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			}, GuiButtons)

			CreateObjectWithProperties("UICorner", {
				Name = "_ToggleCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = ToggleTemplate
			})

			local ToggleStroke = CreateObjectWithProperties("UIStroke", {
				Name = "_ToggleStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.ToggleStroke,
				Parent = ToggleTemplate
			})

			CreateObjectWithProperties("Frame", {
				Name = "DropContainer",
				ClipsDescendants = true,
				Parent = ToggleTemplate,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0, 
				Active = true,
			}, GuiButtons)

			CreateObjectWithProperties("ImageLabel", {
				Name = "_ToggleShadow",
				Parent = ToggleTemplate,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 14, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local ToggleImage = CreateObjectWithProperties("ImageLabel", {
				Name = "_ToggleImage",
				Parent = ToggleTemplate,
				Image = "rbxassetid://14187776323",
				ImageColor3 = Theme.ToggleImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(187, 116, 116),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local SwitchIndicatorFrame = CreateObjectWithProperties("Frame", {
				Name = "SwitchIndicator",
				Parent = ToggleTemplate,
				Size = UDim2.new(0, 38, 0, 18),
				Position = UDim2.new(1, -15, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme.SwitchIndicatorBackground,
				ZIndex = 3,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_SwitchIndicatorCorner",
				CornerRadius = UDim.new(0, 3),
				Parent = SwitchIndicatorFrame
			})

			local SwitchIndicatorStroke = CreateObjectWithProperties("UIStroke", {
				Name = "_SwitchIndicatorStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.SwitchIndicatorStroke,
				Parent = SwitchIndicatorFrame
			})

			local TogglerFrame = CreateObjectWithProperties("Frame", {
				Name = "Toggler",
				Parent = SwitchIndicatorFrame,
				Size = UDim2.new(0.5, -4, 1, -4),
				Position = UDim2.new(0, 2, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Theme.TogglerBackground,
				ZIndex = 4,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_TogglerCorner",
				CornerRadius = UDim.new(0, 3),
				Parent = TogglerFrame
			})

			local TogglerStroke = CreateObjectWithProperties("UIStroke", {
				Name = "_TogglerStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.TogglerStroke,
				Parent = TogglerFrame
			})

			local TogglerShadow = CreateObjectWithProperties("ImageLabel", {
				Name = "_TogglerShadow",
				Parent = TogglerFrame,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.TogglerShadow,
				ImageTransparency = 0.9,
				Size = UDim2.new(1, 8, 1, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 3,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local SwitchIndicatorShadow = CreateObjectWithProperties("ImageLabel", {
				Name = "_SwitchIndicatorShadow",
				Parent = SwitchIndicatorFrame,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 8, 1, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			_ToggleDescription = CreateObjectWithProperties("TextLabel", {
				Name = "_ToggleDescription",
				Parent = ToggleTemplate,
				Text = ToggleDescription,
				Size = UDim2.new(1, -41, 0, 18),
				Position = UDim2.new(0, 41, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonDescription,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			_ToggleText = CreateObjectWithProperties("TextLabel", {
				Name = "_ToggleText",
				Parent = ToggleTemplate,
				Text = ToggleText,
				Size = UDim2.new(1, -41, 0, 21),
				Position = UDim2.new(0, 41, 0, 5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonText,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local ColorPatterns = {
				Off = {
					[SwitchIndicatorStroke] = {"Color", SwitchIndicatorStroke.Color},
					[SwitchIndicatorShadow] = {"ImageColor3", SwitchIndicatorShadow.ImageColor3},

					[TogglerStroke] = {"Color", TogglerStroke.Color},
					[TogglerShadow] = {"ImageColor3", TogglerShadow.ImageColor3},
					[TogglerFrame] = {"BackgroundColor3", TogglerFrame.BackgroundColor3},

					[ToggleTemplate] = {"BackgroundColor3", Theme.ToggleBackground},
					[ToggleImage] = {"ImageColor3", ToggleImage.ImageColor3},
					[ToggleStroke] = {"Color", ToggleStroke.Color},
				},

				On = {
					[SwitchIndicatorStroke] = {"Color", Color3.fromRGB(60, 120, 60)},
					[SwitchIndicatorShadow] = {"ImageColor3", Color3.fromRGB(0, 0, 0)},

					[TogglerStroke] = {"Color", Color3.fromRGB(40, 140, 40)},
					[TogglerShadow] = {"ImageColor3", Color3.fromRGB(0, 255, 0)},
					[TogglerFrame] = {"BackgroundColor3", Color3.fromRGB(100, 200, 100)},

					[ToggleTemplate] = {"BackgroundColor3", Theme.ToggleBackgroundSelected},
					[ToggleImage] = {"ImageColor3", Color3.fromRGB(123, 146, 123)},
					[ToggleStroke] = {"Color", Color3.fromRGB(87, 134, 87)},
				}
			}

			local BooleanState = DefaultState or false

			local TransitionStartUDimSize = UDim2.new(0.5, 0, 1, 0)
			local TransitionEndUDimSize = TogglerFrame.Size

			local FalseUDimPosition = TogglerFrame.Position
			local TrueUDimPosition = UDim2.new(1, -17, 0.5, 0)
			
			local function ToggleVisual()
				TweenProperty(TogglerFrame, 0.125, {Size = TransitionStartUDimSize})
				TweenProperty(TogglerFrame, 0.25, {Position = BooleanState and TrueUDimPosition or FalseUDimPosition})
				task.delay(0.125, TweenProperty, TogglerFrame, 0.125, {Size = TransitionEndUDimSize})

				for Object, Properties in ColorPatterns[BooleanState and "On" or "Off"] do
					local PropertyName = Properties[1]
					local Value = Properties[2]

					TweenProperty(Object, 0.25, {[PropertyName] = Value})
				end
			end

			local function Wrap()
				BooleanState = not BooleanState
				ToggleVisual()

				return task.spawn(Callback, BooleanState)
			end

			ToggleVisual()

			ApplyCallback(ToggleTemplate, ToggleTemplate.MouseButton1Down, Wrap)

			local Extras = {}

			function Extras:Destroy()
				ToggleTemplate:Destroy()
			end
			
			function Extras:UpdateText(NewToggleText: string)
				local Clone = FluentTextChange(NewToggleText, _ToggleText, ToggleTemplate)
				_ToggleText = Clone
			end

			function Extras:UpdateDescription(NewToggleDescription: string)
				local Clone = FluentTextChange(NewToggleDescription, _ToggleDescription, ToggleTemplate)
				_ToggleDescription = Clone
			end

			return Extras
		end

		function Descendants:NewLabelEntry(LabelText: string, LabelDescription: string, LabelPriority: string?)
			if type(LabelText) ~= "string" then
				LabelText = "Hi, Hello, How are you?"
				warn(`[MACHINA] LabelText is not a string.`)
			end

			if type(LabelDescription) ~= "string" then
				LabelDescription = "I'm Fine."
				warn(`[MACHINA] LabelDescription is not a string.`)
			end
			
			if LabelPriority ~= "Warning" and LabelPriority ~= "Danger" and LabelPriority ~= "Positive" and LabelPriority ~= "Info" then
				LabelPriority = "Note"
			end

			local LabelTheme = {
				LabelBackground = Theme.Label[LabelPriority .. "Background"],
				LabelStroke = Theme.Label[LabelPriority .. "Stroke"],
				LabelImage = Theme.Label[LabelPriority .. "Image"],
				LabelText = Theme.Label[LabelPriority .. "Text"],
				LabelDescription = Theme.Label[LabelPriority .. "Description"],
			}

			local LabelTemplate = CreateObjectWithProperties("Frame", {
				Name = "Label",
				Parent = TabScrollingFrame,
				Size = UDim2.new(1, -10, 0, 45),
				BackgroundColor3 = LabelTheme.LabelBackground,
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
			}, GuiButtons)

			CreateObjectWithProperties("Frame", {
				Name = "DropContainer",
				ClipsDescendants = true,
				Parent = LabelTemplate,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0, 
				Active = true,
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_LabelCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = LabelTemplate
			})

			local LabelStroke = CreateObjectWithProperties("UIStroke", {
				Name = "_LabelStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = LabelTheme.LabelStroke,
				Parent = LabelTemplate
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_LabelShadow",
				Parent = LabelTemplate,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 14, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local LabelImage = CreateObjectWithProperties("ImageLabel", {
				Name = "_LabelImage",
				Parent = LabelTemplate,
				Image = LabelIcons[LabelPriority], --"rbxassetid://11422155687",
				ImageColor3 = LabelTheme.LabelImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _LabelDescription = CreateObjectWithProperties("TextLabel", {
				Name = "_LabelDescription",
				Parent = LabelTemplate,
				Text = LabelDescription,
				Size = UDim2.new(1, -41, 0, 18),
				Position = UDim2.new(0, 41, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = LabelTheme.LabelDescription,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _LabelText = CreateObjectWithProperties("TextLabel", {
				Name = "_LabelText",
				Parent = LabelTemplate,
				Text = LabelText,
				Size = UDim2.new(1, -41, 0, 21),
				Position = UDim2.new(0, 41, 0, 5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = LabelTheme.LabelText,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local Extras = {}

			function Extras:UpdatePriority(NewPriority: string)
				if type(NewPriority) ~= "string" then
					return
				end

				if NewPriority ~= "Warning" and NewPriority ~= "Danger" and NewPriority ~= "Positive" and NewPriority ~= "Info" then
					NewPriority = "Note"
				end

				if not LabelIcons[NewPriority] then
					return
				end

				TweenProperty(LabelImage, 0.25, {ImageTransparency = 1}, true)
				LabelImage = LabelImage:Clone()

				local AffectedByNotes = {
					[_LabelText] = {
						TextColor3 = Theme.Label[NewPriority .. "Text"],
					},
					[_LabelDescription] = {
						TextColor3 = Theme.Label[NewPriority .. "Description"],
					},
					[LabelImage] = {
						ImageColor3 = Theme.Label[NewPriority .. "Image"],
						ImageTransparency = 0,
					},
					[LabelStroke] = {
						Color = Theme.Label[NewPriority .. "Stroke"],
					},
					[LabelTemplate] = {
						BackgroundColor3 = Theme.Label[NewPriority .. "Background"],
					},
				}

				LabelImage.ImageTransparency = 1
				LabelImage.Image = LabelIcons[NewPriority]
				LabelImage.ImageColor3 = Theme.Label[NewPriority .. "Image"]
				LabelImage.Parent = LabelTemplate
				
				for Object, Properties in AffectedByNotes do
					for Property, Value in Properties do
						TweenProperty(Object, 0.5, {[Property] = Value})
					end
				end
			end

			function Extras:Destroy()
				LabelTemplate:Destroy()
			end

			function Extras:UpdateText(NewLabelText: string)
				local Clone = FluentTextChange(NewLabelText, _LabelText, LabelTemplate)
				_LabelText = Clone
			end

			function Extras:UpdateDescription(NewLabelDescription: string)
				local Clone = FluentTextChange(NewLabelDescription, _LabelDescription, LabelTemplate)
				_LabelDescription = Clone
			end

			function Extras:UpdateEverything(NewLabelText: string, NewLabelDescription: string, NewPriority: string)
				Extras:UpdateText(NewLabelText)
				Extras:UpdateDescription(NewLabelDescription)

				task.wait()

				Extras:UpdatePriority(NewPriority)
			end

			return Extras
		end

		function Descendants:NewSliderEntry(SliderText: string, SliderDescription: string, Minimum: number?, Maximum: number?, Default: number?, Callback: (...any) -> (...any))
			if type(Callback) ~= "function" then
				warn(`[MACHINA] Callback is not a function, ignoring.`)

				return
			end
			
			if type(SliderText) ~= "string" then
				SliderText = "Hi, Hello, How are you?"
				warn(`[MACHINA] SliderText is not a string.`)
			end

			if type(SliderDescription) ~= "string" then
				SliderDescription = "I'm Fine."
				warn(`[MACHINA] SliderDescription is not a string.`)
			end

			local Minimum = Minimum or 1
			local Maximum = Maximum or 50
			local Default = Default or 0
			local Value = Default

			local SliderTemplate = CreateObjectWithProperties("TextButton", {
				Name = "Slider",
				Parent = TabScrollingFrame,
				Text = "",
				Size = UDim2.new(1, -10, 0, 45),
				Position = UDim2.new(0.00836, 0, 0.01689, 0),
				AutoButtonColor = false,
				BackgroundColor3 = Theme.SliderBackground,
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				TextColor3 = Theme.PrimaryText,
				TextSize = 14,
			}, GuiButtons)

			CreateObjectWithProperties("UICorner", {
				Name = "_SliderCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = SliderTemplate
			})

			CreateObjectWithProperties("UIStroke", {
				Name = "_SliderStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.SliderStroke,
				Parent = SliderTemplate
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_SliderShadow",
				Parent = SliderTemplate,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 14, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_SliderImage",
				Parent = SliderTemplate,
				Image = "rbxassetid://11419719162",
				ImageColor3 = Theme.SliderImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(187, 116, 116),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local SliderHandleButton = CreateObjectWithProperties("TextButton", {
				Name = "SliderHandle",
				Parent = SliderTemplate,
				Text = " ",
				Size = UDim2.new(0, 75, 0, 18),
				Position = UDim2.new(1, -15, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				AutoButtonColor = false,
				BackgroundColor3 = Theme.SliderHandleBackground,
				ZIndex = 3,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.25,
				TextColor3 = Theme.PrimaryText,
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_SliderHandlerShadow",
				Parent = SliderHandleButton,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 8, 1, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local SliderIndicatorFrame = CreateObjectWithProperties("Frame", {
				Name = "SliderIndicator",
				Parent = SliderHandleButton,
				Size = UDim2.new(0, 20, 1, -4),
				Position = UDim2.new(0, 2, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Theme.SliderIndicatorBackground,
				BackgroundTransparency = 0.5,
				ZIndex = 4,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_SliderIndicatorCorner",
				CornerRadius = UDim.new(0, 3),
				Parent = SliderIndicatorFrame
			})

			CreateObjectWithProperties("UIStroke", {
				Name = "_SliderIndicatorStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.SliderIndicatorStroke,
				Parent = SliderIndicatorFrame
			})

			local SliderIndicatorShadow = CreateObjectWithProperties("ImageLabel", {
				Name = "_SliderindicatorShadow",
				Parent = SliderIndicatorFrame,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.SliderShadow,
				ImageTransparency = 0.9,
				Size = UDim2.new(1, 8, 1, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 3,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("Frame", {
				Name = "DropContainer",
				ClipsDescendants = true,
				Parent = SliderTemplate,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0, 
				Active = true,
			}, GuiButtons)

			CreateObjectWithProperties("UIStroke", {
				Name = "_SliderHandleStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.SliderHandleStroke,
				Parent = SliderHandleButton
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_SliderHandleCorner",
				CornerRadius = UDim.new(0, 3),
				Parent = SliderHandleButton
			})

			local SliderValueOutput = CreateObjectWithProperties("TextLabel", {
				Name = "SliderValue",
				Parent = SliderHandleButton,
				Text = tostring(Default),
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.SliderValueText,
				TextSize = 16,
				TextStrokeTransparency = 0.9,
				ZIndex = 5,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _SliderDescription = CreateObjectWithProperties("TextLabel", {
				Name = "_SliderDescription",
				Parent = SliderTemplate,
				Text = SliderDescription,
				Size = UDim2.new(1, -41, 0, 18),
				Position = UDim2.new(0, 41, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonDescription,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _SliderText = CreateObjectWithProperties("TextLabel", {
				Name = "_SliderText",
				Parent = SliderTemplate,
				Text = SliderText,
				Size = UDim2.new(1, -41, 0, 21),
				Position = UDim2.new(0, 41, 0, 5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonText,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})


			local TrackWidth = SliderHandleButton.AbsoluteSize.X - 24

			local _MovedSignal
			local _ReleaseSignal

			local function UpdateSliderValue(Offset: number?, Tween: boolean)
				Offset = Offset or 0

				local TrackStart = SliderHandleButton.AbsolutePosition.X + 11 -- must be here because window resizing
				local MouseX = UserInputService:GetMouseLocation().X
				local RelativeX = math.clamp(MouseX - TrackStart, 0, TrackWidth)

				local Percent = RelativeX / TrackWidth
				Value = math.floor(Minimum + (Maximum - Minimum) * Percent)

				if Tween then
					TweenProperty(SliderIndicatorFrame, 0.02, {Position = UDim2.new(0, Offset + RelativeX, 0.5, 0)})
				else
					SliderIndicatorFrame.Position = UDim2.new(0, Offset + RelativeX, 0.5, 0)
				end

				SliderValueOutput.Text = tostring(Value)

				task.spawn(Callback, Value)
			end

			ApplyCallback(SliderHandleButton, SliderHandleButton.MouseButton1Down, function()
				TweenProperty(SliderTemplate, 0.125, {BackgroundColor3 = Theme.SliderBackgroundToggled})
				TweenProperty(SliderIndicatorFrame, 0.125, {Size = UDim2.new(0, 26, 1, 2), BackgroundTransparency = 0.25})
				_MovedSignal = Mouse.Move:Connect(UpdateSliderValue)

				_ReleaseSignal = UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						UpdateSliderValue(2, true)
						_MovedSignal:Disconnect()
						_ReleaseSignal:Disconnect()
						task.wait(0.075)

						TweenProperty(SliderIndicatorFrame, 0.125, {Size = UDim2.new(0, 20, 1, -4), BackgroundTransparency = 0.5})
						TweenProperty(SliderTemplate, 0.125, {BackgroundColor3 = Theme.SliderBackground})
						BubbleClickEffect(SliderTemplate)
					end
				end)
			end)

			ApplyCallback(SliderHandleButton, SliderTemplate.MouseButton1Down, function()
				task.spawn(Callback, Value)
			end)

			local Extras = {}

			function Extras:Destroy()
				SliderTemplate:Destroy()
			end
			
			function Extras:UpdateText(NewSliderText: string)
				local Clone = FluentTextChange(NewSliderText, _SliderText, SliderTemplate)
				_SliderText = Clone
			end

			function Extras:UpdateDescription(NewSliderDescription: string)
				local Clone = FluentTextChange(NewSliderDescription, _SliderDescription, SliderTemplate)
				_SliderDescription = Clone
			end

			function Extras:UpdateMinimum(NewMinimum: number)
				if type(NewMinimum) ~= "number" then
					return
				end

				Minimum = NewMinimum
			end

			function Extras:UpdateMaximum(NewMaximum: number)
				if type(NewMaximum) ~= "number" then
					return
				end

				Maximum = NewMaximum
			end

			return Extras
		end

		function Descendants:NewTextboxEntry(TextboxText: string, TextBoxDescription: string, Callback: (...any) -> (...any))
			if type(Callback) ~= "function" then
				warn(`[MACHINA] Callback is not a function, ignoring.`)

				return
			end
			
			if type(TextboxText) ~= "string" then
				TextboxText = "Hi, Hello, How are you?"
				warn(`[MACHINA] TextboxText is not a string.`)
			end

			if type(TextBoxDescription) ~= "string" then
				TextBoxDescription = "I'm Fine."
				warn(`[MACHINA] TextBoxDescription is not a string.`)
			end

			local TextboxTemplate = CreateObjectWithProperties("TextButton", {
				Name = "Textbox",
				Parent = TabScrollingFrame,
				Text = "",
				Size = UDim2.new(0.983, -5, 0, 45),
				Position = UDim2.new(0.00836, 0, 0.01689, 0),
				AutoButtonColor = false,
				BackgroundColor3 = Theme.TextboxBackground,
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				TextColor3 = Theme.PrimaryText,
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_TextboxCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = TextboxTemplate
			})

			CreateObjectWithProperties("UIStroke", {
				Name = "_TextboxStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.TextboxStroke,
				Parent = TextboxTemplate
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_TextboxShadow",
				Parent = TextboxTemplate,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 14, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_TextboxImage",
				Parent = TextboxTemplate,
				Image = "rbxassetid://11432863518",
				ImageColor3 = Theme.TextboxImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(187, 116, 116),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local TextBoxInit = CreateObjectWithProperties("TextBox", {
				Name = "TextBoxInit",
				Parent = TextboxTemplate,
				Text = "",
				PlaceholderText = ". . . . . .",
				Size = UDim2.new(0, 75, 0, 18),
				Position = UDim2.new(1, -15, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme.TextboxInitBackground,
				TextColor3 = Theme.TextboxInitText,
				PlaceholderColor3 = Theme.TextboxInitPlaceholder,
				TextSize = 14,
				TextScaled = true,
				TextWrapped = true,
				ZIndex = 3,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("Frame", {
				Name = "DropContainer",
				ClipsDescendants = true,
				Parent = TextBoxInit,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0,
				Active = true,
			}, GuiButtons)

			CreateObjectWithProperties("UICorner", {
				Name = "_TextboxInitCorner",
				CornerRadius = UDim.new(0, 3),
				Parent = TextBoxInit
			})

			local TextboxInitStroke = CreateObjectWithProperties("UIStroke", {
				Name = "_TextboxInitStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.TextboxInitStroke,
				Parent = TextBoxInit
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_TextboxInitShadow",
				Parent = TextBoxInit,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 8, 1, 6),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("UITextSizeConstraint", {
				Name = "_TextBoxInitSizeConstraint",
				MaxTextSize = 14,
				Parent = TextBoxInit
			})

			local _TextboxText = CreateObjectWithProperties("TextLabel", {
				Name = "_TextboxText",
				Parent = TextboxTemplate,
				Text = TextboxText,
				Size = UDim2.new(1, -41, 0, 21),
				Position = UDim2.new(0, 41, 0, 5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.TextboxText,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _TextboxDescription = CreateObjectWithProperties("TextLabel", {
				Name = "_TextboxDescription",
				Parent = TextboxTemplate,
				Text = TextBoxDescription,
				Size = UDim2.new(1, -41, 0, 18),
				Position = UDim2.new(0, 41, 1, -4),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.TextboxDescription,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			ApplyCallback(TextboxTemplate, TextboxTemplate.MouseButton1Down, function()
				TextBoxInit:CaptureFocus();
			end)

			ApplyCallback(TextBoxInit, TextBoxInit.Focused, function()
				TweenProperty(TextboxInitStroke, 0.25, {Thickness = 2})
			end)

			ApplyCallback(TextBoxInit, TextBoxInit.FocusLost, function(EnterPressed)
				local Text = TextBoxInit.Text
				if EnterPressed and Text ~= "" then
					TextBoxInit.Text = ""
					task.spawn(Callback, Text)
					
					BubbleClickEffect(TextBoxInit)
				end

				TweenProperty(TextboxInitStroke, 0.25, {Thickness = 1})
			end)

			local Extras = {}

			function Extras:Destroy()
				TextboxTemplate:Destroy()
			end
			
			function Extras:UpdateText(NewTextboxText: string)
				local Clone = FluentTextChange(NewTextboxText, _TextboxText, TextboxTemplate)
				_TextboxText = Clone
			end

			function Extras:UpdateDescription(NewTextboxDescription: string)
				local Clone = FluentTextChange(NewTextboxDescription, _TextboxDescription, TextboxTemplate)
				_TextboxDescription = Clone
			end

			return Extras
		end

		function Descendants:NewDropdownEntry(DropdownText: string, DropdownDescription: string, Dictionary, Default: number?, Callback: (...any) -> (...any))
			if type(Callback) ~= "function" then
				warn(`[MACHINA] Callback is not a function, ignoring.`)

				return
			end
			
			if type(Dictionary) ~= "table" then
				warn(`[MACHINA] Dictionary is not a table, ignoring.`)

				return
			end

			if not rawget(Dictionary, 1) then
				warn(`[MACHINA] No entry found in Dictionary , skipping.`)

				return
			end
			
			if type(DropdownText) ~= "string" then
				DropdownText = "Hi, Hello, How are you?"
				warn(`[MACHINA] DropdownText is not a string.`)
			end

			if type(DropdownDescription) ~= "string" then
				DropdownDescription = "I'm Fine."
				warn(`[MACHINA] DropdownDescription is not a string.`)
			end
			
			local DropdownTemplate = CreateObjectWithProperties("TextButton", {
				Name = "Dropdown",
				Parent = TabScrollingFrame,
				Text = "",
				Size = UDim2.new(1, -10, 0, 45),
				Position = UDim2.new(0.01508, 0, 0.26471, 0),
				AutoButtonColor = false,
				BackgroundColor3 = Theme.DropdownBackground,
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				TextColor3 = Theme.PrimaryText,
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			}, GuiButtons)

			CreateObjectWithProperties("Frame", {
				Name = "DropContainer",
				ClipsDescendants = true,
				Parent = DropdownTemplate,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0,
				Active = true,
			}, GuiButtons)

			CreateObjectWithProperties("UICorner", {
				Name = "_DropdownCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = DropdownTemplate
			})

			CreateObjectWithProperties("UIStroke", {
				Name = "_DropdownStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.DropdownStroke,
				Parent = DropdownTemplate
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_DropdownShadow",
				Parent = DropdownTemplate,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.ProfileShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(1, 14, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_DropdownImage",
				Parent = DropdownTemplate,
				Image = "rbxassetid://11432865001",
				ImageColor3 = Theme.DropdownImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 10, 0, 10),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local DropdownContainerFrame = CreateObjectWithProperties("Frame", {
				Name = "DropdownContainer",
				Parent = DropdownTemplate,
				Visible = false,
				Size = UDim2.new(1, -10, 1, -52),
				Position = UDim2.new(0.5, 0, 0, 46),
				AnchorPoint = Vector2.new(0.5, 0),
				ClipsDescendants = true,
				BackgroundColor3 = Theme.DropdownContainerBackground,
				ZIndex = 2,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("UIStroke", {
				Name = "_DropdownContainerStroke",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Theme.DropdownContainerStroke,
				Parent = DropdownContainerFrame
			})

			CreateObjectWithProperties("UICorner", {
				Name = "_DropdownContainerCorner",
				CornerRadius = UDim.new(0, 6),
				Parent = DropdownContainerFrame
			})

			local DropdownScrollFrame = CreateObjectWithProperties("ScrollingFrame", {
				Name = "DropdownScroll",
				Parent = DropdownContainerFrame,
				Size = UDim2.new(1, -4, 1, -10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Active = true,
				CanvasSize = UDim2.new(0, 0, 0, 5),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ClipsDescendants = false,
				ScrollBarImageColor3 = Theme.DropdownScrollbar,
				ScrollBarImageTransparency = 1,
				ScrollBarThickness = 0,
				ZIndex = 3,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("UIListLayout", {
				Name = "_DropdownScrollLayout",
				Parent = DropdownScrollFrame,
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceAround
			})

			local DropdownSelectionLabel = CreateObjectWithProperties("TextLabel", {
				Name = "_DropdownSelection",
				Parent = DropdownTemplate,
				Text = "Choice",
				Size = UDim2.new(0, 120, 0, 24),
				Position = UDim2.new(1, -45, 0, 10),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.DropdownSelectionText,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextStrokeColor3 = Theme.DropdownSelectionStroke,
				TextStrokeTransparency = 0.9,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local DropIndicator = CreateObjectWithProperties("ImageLabel", {
				Name = "_DropIndicator",
				Parent = DropdownTemplate,
				Image = "rbxassetid://12974423137",
				ImageColor3 = Theme.DropIndicatorImage,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(1, -15, 0, 10),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 4,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			CreateObjectWithProperties("ImageLabel", {
				Name = "_DropIndicatorShadow",
				Parent = DropIndicator,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Theme.DropIndicatorShadow,
				ImageTransparency = 0.8,
				Size = UDim2.new(0, 12, 0, 12),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 3,
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _DropdownDescription = CreateObjectWithProperties("TextLabel", {
				Name = "_DropdownDescription",
				Parent = DropdownTemplate,
				Text = DropdownDescription,
				Size = UDim2.new(1, -41, 0, 18),
				Position = UDim2.new(0, 41, 0, 22),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonDescription,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})

			local _DropdownText = CreateObjectWithProperties("TextLabel", {
				Name = "_DropdownText",
				Parent = DropdownTemplate,
				Text = DropdownText,
				Size = UDim2.new(1, -41, 0, 21),
				Position = UDim2.new(0, 41, 0, 4),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextColor3 = Theme.ButtonText, -- Using ButtonText for consistency
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				BorderSizePixel = 0,
				BorderColor3 = Color3.fromRGB(0, 0, 0)
			})
			
			local IsRolledDown = false
			ApplyCallback(DropdownTemplate, DropdownTemplate.MouseButton1Down, function()
				IsRolledDown = not IsRolledDown

				DropdownContainerFrame.Visible = IsRolledDown
				TweenProperty(DropdownTemplate, 0.25, {Size = UDim2.new(1, -10, 0, IsRolledDown and 150 or 45)});
				TweenProperty(DropIndicator, 0.25, {Rotation = IsRolledDown and 90 or 0});
			end)

			local Entries = {}

			local function CreateOptions(EntryTable: {any})
				table.clear(Entries)

				for _, _Instance in DropdownScrollFrame:GetChildren() do
					if _Instance:IsA("TextButton") then
						_Instance:Destroy()
					end
				end

				for Key, Value in EntryTable do
					local Entry = ParseDictionary(Key, Value)
					if not Entry then
						continue
					end

					table.insert(Entries, Entry)

					local Value = Entry.Target
					local Text = Entry.Text
					local Description = Entry.Description

					local OptionButton = CreateObjectWithProperties("TextButton", {
						Name = "Option",
						Parent = DropdownScrollFrame,
						Text = "",
						Size = UDim2.new(1.00068, -5, 0, 45),
						Position = UDim2.new(0.0136, 0, -0.07955, 0),
						AutoButtonColor = false,
						BackgroundColor3 = Theme.OptionBackground,
						ZIndex = 2,
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						TextColor3 = Theme.OptionText,
						TextSize = 14,
						FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
					}, GuiButtons)

					CreateObjectWithProperties("UICorner", {
						Name = "_OptionCorner",
						CornerRadius = UDim.new(0, 6),
						Parent = OptionButton
					})

					CreateObjectWithProperties("UIStroke", {
						Name = "_OptionStroke",
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = Theme.OptionStroke,
						Parent = OptionButton
					})

					CreateObjectWithProperties("ImageLabel", {
						Name = "_OptionShadow",
						Parent = OptionButton,
						Image = "rbxassetid://1316045217",
						ImageColor3 = Theme.ProfileShadow,
						ImageTransparency = 0.8,
						Size = UDim2.new(1, 14, 1, 10),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					CreateObjectWithProperties("ImageLabel", {
						Name = "_OptionImage",
						Parent = OptionButton,
						Image = "rbxassetid://12967327673",
						ImageColor3 = Theme.OptionImage,
						Size = UDim2.new(0, 24, 0, 24),
						Position = UDim2.new(0, 10, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						ZIndex = 2,
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					CreateObjectWithProperties("TextLabel", {
						Name = "_OptionText",
						Parent = OptionButton,
						Text = Text,
						Size = UDim2.new(1, -41, 0, 21),
						Position = UDim2.new(0, 41, 0, 5),
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						TextColor3 = Theme.OptionText,
						TextSize = 16,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 2,
						FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					CreateObjectWithProperties("TextLabel", {
						Name = "_OptionDescription",
						Parent = OptionButton,
						Text = Description,
						Size = UDim2.new(1, -41, 0, 18),
						Position = UDim2.new(0, 41, 1, -4),
						AnchorPoint = Vector2.new(0, 1),
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						TextColor3 = Theme.OptionDescription,
						TextSize = 14,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 2,
						FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal),
						BorderSizePixel = 0,
						BorderColor3 = Color3.fromRGB(0, 0, 0)
					})

					ApplyCallback(OptionButton, OptionButton.MouseButton1Down, function()
						task.spawn(Callback, Value)
						IsRolledDown = false
						
						local Clone = FluentTextChange(Text, DropdownSelectionLabel, DropdownTemplate)
						DropdownSelectionLabel = Clone
						DropdownContainerFrame.Visible = false

						TweenProperty(DropdownTemplate, 0.25, {Size = UDim2.new(1, -10, 0, 45)});
						TweenProperty(DropIndicator, 0.25, {Rotation = 0});
					end)
				end
			end

			CreateOptions(Dictionary)

			local Index = math.clamp(Default or 1, 1, #Entries)
			local DefaultEntry = Entries[Index]

			DropdownSelectionLabel.Text = DefaultEntry.Text
			task.spawn(Callback, DefaultEntry.Target)

			local Extras = {}
			function Extras:Destroy()
				DropdownTemplate:Destroy()
			end
			
			function Extras:UpdateList(NewDropdownDictionary: {any})
				if type(NewDropdownDictionary) ~= "table" then
					return
				end

				CreateOptions(NewDropdownDictionary)
			end

			function Extras:UpdateText(NewDropdownText: string)
				local Clone = FluentTextChange(NewDropdownText, _DropdownText, DropdownTemplate)
				_DropdownText = Clone
			end

			function Extras:UpdateDescription(NewTextboxDescription: string)
				local Clone = FluentTextChange(NewTextboxDescription, _DropdownDescription, DropdownTemplate)
				_DropdownDescription = Clone
			end

			return Extras
		end
		
		return Descendants
	end
	
	MainFrame.Parent = MachinaScreenGui
	MachinaScreenGui.Parent = GetSecureContainer()
	return Children, MachinaScreenGui
end

return GuiLibrary
