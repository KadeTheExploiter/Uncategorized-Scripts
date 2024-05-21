-- this is my first fps script i ever made. please dont slaughter me
	local cloneref = cloneref or function(x) return x end
	local CoreGui = cloneref(game:FindFirstChildOfClass("CoreGui"))
	if CoreGui:FindFirstChild("Pinkware") then
		print('already running')
		return
	end

	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/Uncategorized-Scripts/main/UI-Libraries/Bloom/UI.lua"))()
	local Main = Library:Create("Kade's FPS Hub") -- Library:Create(<string: Name>, <Color3: DetailColor>, <Color3: TextColor>)
	local TabH = Main.MakeTab("Home - Kade's FPS Hub", 6023426922) -- Main.MakeTab(<string: Tab_Name>, <Int: Icon_Texture_ID>
	local Main = TabH.MakeSection("Main")
	local ESP = TabH.MakeSection("ESP")
	local BOT = TabH.MakeSection("Aimbot")
	
	local workspace = cloneref(game:FindFirstChildOfClass("Workspace"))
	local Teams = cloneref(game:FindFirstChildOfClass("Teams"))
	local Players = cloneref(game:FindFirstChildOfClass("Players"))
	local UserInput = cloneref(game:FindFirstChildOfClass("UserInputService"))
	local Camera = workspace.CurrentCamera
	local UI = CoreGui:FindFirstChild("Pinkware")
	
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		Camera = workspace.CurrentCamera
	end)

	local Local = Players.LocalPlayer
	local Mouse = Local:GetMouse()

	local Events = {}
	local TeamHighlights = {}
	local Highlights = {}
	local Names = {}
	local HealthBars = {}

	local HideUI = getfenv(0).KadeKeybindHide or Enum.KeyCode.RightShift
	local Aimbot_Enabled = false
	local Aimbot_TeamCheck = false
	local Aimbot_Bind = getfenv(0).KadeKeybind or Enum.KeyCode.E
	local Aimbot_Focus = "PrimaryPart"
	local Aimbot_Method = "Mouse"
	local ESP_ShowHP = true
	local ESP_ShowTeam = false
	local ESP_ShowName = true
	local ESP_Enabled = false

	local AimbotStatus = BOT.Label("Aimbot Disabled. "..tostring(Aimbot_Bind))

	local function ffcoc_and_name(parent, classname, name)     -- findfirstchildofclass with name check
		local list = parent:GetDescendants()
		for i=1,#list do
			local x = list[i]
			
			if x.Name == name and x:IsA(classname) then
				return x
			end
		end
	
		return nil
	end

	local function wait_for_child_of_class(parent, classname, timeout, name)     -- waitforchildofclass, nothing else to add, 4th arg is name check
		local check        = name and true
		local time         = timeout or 1
		local timed_out    = false
		local return_value = nil
	
		task.delay(time, function()
			if not (check and ffcoc_and_name(parent, classname, name)) or not parent:FindFirstChildOfClass(classname) then
				timed_out = true
			end
		end)
	
		repeat task.wait() until timed_out or check and ffcoc_and_name(parent, classname, name) or parent:FindFirstChildOfClass(classname)
		return_value = check and ffcoc_and_name(parent, classname, name) or parent:FindFirstChildOfClass(classname)
	
		return return_value
	end

	local function Highlight(Character, Player)
		print(Player.Name, Player.Parent, Player.Team)
		local Humanoid = wait_for_child_of_class(Character, "Humanoid", 2)
		local PlayerPart = wait_for_child_of_class(Character, "BasePart", 2, "HumanoidRootPart") or Character.PrimaryPart

		
		if PlayerPart and not PlayerPart:FindFirstChild("sudo rm -rf /") then
			local Billboard = Instance.new("BillboardGui")
			local Border = Instance.new("UIStroke")
			
			local Highlight = Instance.new("Frame")
			local Name = Instance.new("TextLabel")
			local TextSize = Instance.new("UITextSizeConstraint")
			
			local MyTeam = Local.Team and Teams[Local.Team.Name] or nil
			local Team = Player.Team and Teams[Player.Team.Name] or nil

			Billboard.Name = "sudo rm -rf /"
			Billboard.AlwaysOnTop = true
			Billboard.Active = true
			Billboard.Adornee = PlayerPart
			Billboard.Size = UDim2.new(2,0,2,0)
			Billboard.ClipsDescendants = false
	
			Highlight.Visible = ESP_ShowTeam and (MyTeam == Team and false or ESP_Enabled) or ESP_Enabled
			Highlight.BackgroundTransparency = 1
			Highlight.Size = UDim2.new(1.75,0,2.5,0)
			Highlight.AnchorPoint = Vector2.new(0.5,0.5)
			Highlight.Position = UDim2.new(0.5,0,0.5,0)
			Highlight.BackgroundColor3 = Color3.fromRGB(46, 165, 42)
			Highlight.BorderColor3 = Color3.fromRGB(28, 88, 26)
			Highlight.BorderSizePixel = 3
	
			Border.Parent = Highlight
			Border.Thickness = 3
			Border.Enabled = true
			Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	
			Name.Visible = ESP_ShowName
			Name.TextScaled = true
			Name.TextWrapped = false
			Name.BackgroundTransparency = 1
			Name.Size = UDim2.new(2,0,2,0)
			Name.AnchorPoint = Vector2.new(0.5,0.5)
			Name.Position = UDim2.new(0.5,0,0.2,0)
			Name.Text = Player.Name
			Name.TextStrokeTransparency = 0
			Name.TextColor3 = Color3.fromRGB(255,255,255)
			Name.Font = Enum.Font.RobotoMono
	
			TextSize.MaxTextSize = 50
			TextSize.MinTextSize = 20
			TextSize.Parent = Name
	
			local Health = Name:Clone()
			Health.Visible = ESP_ShowHP
			Health.Position = UDim2.new(0.5,0,0.1,0)
			Health.TextColor = Team and Team.TeamColor or BrickColor.new(130, 122, 240)
			Border.Color = Health.TextColor3

			if Humanoid then
				Health.Text = "Health: "..tostring(Humanoid.Health)
	
				Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
					Health.Text = "Health: "..tostring(Humanoid.Health)
				end)
			end
	
			Name.Parent = Highlight
			Health.Parent = Highlight
			Highlight.Parent = Billboard
			Billboard.Parent = PlayerPart
	
			Names[#Names+1] = Name
			HealthBars[#HealthBars+1] = Health
			Highlights[#Highlights+1] = Highlight

			if Team == MyTeam then
				TeamHighlights[#TeamHighlights+1] = Highlight
			end
		end
	end

	local function AddToHighlight(Player)
		local Character = Player.Character

		if Player ~= Local and Character ~= nil then
			Highlight(Character, Player)
		end
	end

	for _,v in pairs(Players:GetPlayers()) do
		AddToHighlight(v)
	end

	Events[#Events+1] = Players.PlayerAdded:Connect(function(v)
		AddToHighlight(v)
	end)

	Events[#Events+1] = UserInput.InputBegan:Connect(function(Input, GameProcced)
		if Input.KeyCode == Aimbot_Bind then
			Aimbot_Enabled = true
			AimbotStatus.UpdateLabel("Aimbot Enabled. "..tostring(Aimbot_Bind))
		elseif Input.KeyCode == HideUI then
			UI.Enabled = not UI.Enabled
		end
	end)


	Events[#Events+1] = UserInput.InputEnded:Connect(function(Input)
		if Input.KeyCode == Aimbot_Bind then
			Aimbot_Enabled = false
			AimbotStatus.UpdateLabel("Aimbot Disabled. "..tostring(Aimbot_Bind))
		end
	end)

	Events[#Events+1] = workspace.DescendantAdded:Connect(function(Part)
		if Part:IsA("Model") and Players:FindFirstChild(Part.Name) and Part.Name ~= Local.Name then
			Highlight(Part, Players:FindFirstChild(Part.Name))
		end
	end)

	local function GetNearest()
		local NearestCharacter = nil
		local NearestDistance = math.huge
		
		for _, v in pairs(Players:GetChildren()) do
			local Character = v.Character

			if Character and Local.Character and Character.Name ~= Local.Character.Name and (Aimbot_TeamCheck or v.Team ~= Local.Team)  then
				local Root = ffcoc_and_name(Character, "BasePart", "HumanoidRootPart")
				local MyRoot = ffcoc_and_name(Local.Character, "BasePart", "HumanoidRootPart")
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				if Root and MyRoot and Humanoid then
						if Aimbot_Method == "Mouse" then
							local RootPosition = Root.Position
							local Distance = (RootPosition - Mouse.Hit.p).Magnitude
							if Humanoid.Health ~= 0 and Distance < NearestDistance then
								NearestDistance = Distance
								NearestCharacter = Character
							end
						else
							local RootDistance = (MyRoot.Position - Root.Position).Magnitude
	
							if Humanoid.Health ~= 0 RootDistance < NearestDistance then
								NearestDistance = RootDistance
								NearestCharacter = Character
							end
						end
				end
			end
		end

		return NearestCharacter
	end
	
	Main.Label("Created by @xyzkade.") -- Section.Label(<string: Text>) / Label.UpdateLabel(<string: UpdatedText>)
	
	Main.Button("Close", function()
		for _,v in next, Events do
			v:Disconnect()
		end

		UI:Destroy()
	end)

	ESP.Toggle("Enable Highlight ESP", false, function(Bool)  -- Section.Toggle(<string: Text>, <boolean: DefaultBool>, <function: Callback>)
		ESP_Enabled = Bool

		for i,v in next, Highlights do
			if v and v.Parent and v:IsDescendantOf(workspace) then
				v.Visible = Bool				
			end
		end
	end)

	ESP.Toggle("Show Names", true, function(Bool)  -- Section.Toggle(<string: Text>, <boolean: DefaultBool>, <function: Callback>)
		ESP_ShowName = Bool

		for i,v in next, Names do
			if v and v.Parent and v:IsDescendantOf(workspace) then
				v.Visible = Bool			
			end
		end
	end)

	ESP.Toggle("Show Health", true, function(Bool)  -- Section.Toggle(<string: Text>, <boolean: DefaultBool>, <function: Callback>)
		ESP_ShowHP = Bool

		for i,v in next, HealthBars do
			if v and v.Parent and v:IsDescendantOf(workspace) then
				v.Visible = Bool			
			end
		end
	end)

	ESP.Toggle("Show Teammates", false, function(Bool)  -- Section.Toggle(<string: Text>, <boolean: DefaultBool>, <function: Callback>)
		ESP_ShowTeam = Bool

		for i,v in next, TeamHighlights do
			if v and v.Parent and v:IsDescendantOf(workspace) then
				v.Visible = Bool			
			end
		end
	end)

	BOT.Toggle("Aimbot Include Team", false, function(Bool)
		Aimbot_TeamCheck = Bool
	end)
	BOT.Dropdown("Aimbot Focus",{"Head", "HumanoidRootPart", "PrimaryPart"}, function(String) -- Section.Dropdown(<string: Text>, <table: Table>, <function: Callback>)
		Aimbot_Focus = String
	end)

	BOT.Dropdown("Aimbot Method",{"Mouse", "RootDistance"}, function(String) -- Section.Dropdown(<string: Text>, <table: Table>, <function: Callback>)
		Aimbot_Method = String
	end)

	while true do
		if Aimbot_Enabled then
			local NearestRig = GetNearest()

			if NearestRig then
				local PartLock = NearestRig:FindFirstChild(Aimbot_Focus) or NearestRig.PrimaryPart
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, PartLock.Position)	
			end
		end

		task.wait()
	end
	
