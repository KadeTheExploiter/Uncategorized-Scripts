local Workspace = game:GetService("Workspace")
--[[
	[ Tool Reanimate ]
	- Author: Gelatek
	- Tools needed: 8 (customizable at line ~~180 (ps. change ))
	
	[ Features ] 
	- Auto Mode (only for little games)
	- No Auto-Respawn
	- Stable, Probably jitterless and delayless
	- Optimized and Fast.
	- Body For Fling.
]]

local Global = (getgenv and getgenv()) or getfenv(0)
local Krypton = Global.KryptonReanimateConfig or {}

Krypton.CamOffset = Vector3.new(0, 1.25, 0)
Krypton.AutoMode = true
Krypton.Fling = true
Krypton.AntiVoid = true

-- the fun begins..
local AutoMode = Krypton.AutoMode or true -- only for gelatek baseplate and myworld testing place
local ClickFling = Krypton.Fling or true -- uses body for fling
local AntiVoid = Krypton.AntiVoid or true
local loadtime = tick()

local wait = task.wait
local v3new = Vector3.new
local Cfnew, Cfangles = CFrame.new, CFrame.Angles
local rad, cos, sin, random = math.rad, math.cos, math.sin, math.random
local innew = Instance.new
local clock = os.clock
local ci = function(cn,tbl) local x=innew(cn) for i,v in pairs(tbl) do x[i]=v end return x end
local tfind = table.find

local Players = game:FindFirstChildOfClass("Players")
local RunService = game:FindFirstChildOfClass("RunService")
local PostSim, PreSim = RunService.PostSimulation, RunService.PreSimulation

local LocalPlayer = Players.LocalPlayer
local Backpack, Character = LocalPlayer.Backpack, LocalPlayer.Character
local Camera = workspace.Camera

local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart", 10)

if AutoMode and game.PlaceId == 7290932898 or game.PlaceId == 14797650585 then
	local TPTo = {}
	local OldPos = HRP.CFrame * Cfnew(0, 5, 0)
	local ReplicatedStorage = game:FindFirstChildOfClass("ReplicatedStorage")
	for i = 1, 8 do		
		for _,v in pairs(LocalPlayer.Backpack:GetChildren()) do
			v.Parent = LocalPlayer.Character
			v.Parent = workspace
			
			task.delay(0.75, function()
				TPTo[#TPTo+1] = v.Handle.CFrame
			end)
		end
		
		if LocalPlayer:FindFirstChild("Respawn") then
			LocalPlayer.Respawn:FireServer()
		else
			ReplicatedStorage.Respawn:FireServer()
		end
		LocalPlayer:WaitForChild("Backpack")
		repeat wait(0.05) until LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
		
		LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1).CFrame = OldPos * Cfnew(i*2, 0, 0)
		wait(0.25)
	end
	
	wait(1)
	
	Backpack, Character = LocalPlayer.Backpack, LocalPlayer.Character
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	HRP = Character:WaitForChild("HumanoidRootPart", 10)

	for i,v in pairs(TPTo) do
		HRP.CFrame = v
		wait(0.15)
	end
	wait(0.15)
	HRP.CFrame = OldPos
	Humanoid:ChangeState(2)
	Humanoid:ChangeState(7)
	
	Humanoid:UnequipTools()
	wait(0.5)
end

local Descendants = Character:GetDescendants()
Humanoid:ChangeState(16)

local Tools = {}
local AntiSleep = Cfnew(0.0065 * sin(clock()*32), 0, 0.0065 * cos(clock()*32))
local AntiSleepRotate = v3new(0, sin(clock()*10), 0)
local Randomizer = 27.5 + sin(clock()*2)
local FakeRigChildren; FakeRig = innew("Model"); do
	local FakeHead = ci("Part", {Name = "Head", Size = v3new(2, 1, 1), Transparency = 1, Parent = FakeRig});
	local FakeRoot = ci("Part", {Name = "HumanoidRootPart", Size = v3new(2, 2, 1), Transparency = 1, Parent = FakeRig})
	local FakeTorso = ci("Part", {Name = "Torso", Size = v3new(2, 2, 1), Transparency = 1, Parent = FakeRig})
	local FakeRightArm = ci("Part", {Name = "Right Arm", Size = v3new(1, 2, 1), Transparency = 1, Parent = FakeRig})
	local FakeLeftArm = ci("Part", {Name = "Left Arm", Size = v3new(1, 2, 1), Transparency = 1, Parent = FakeRig})
	local FakeRightLeg = ci("Part", {Name = "Right Leg", Size = v3new(1, 2, 1), Transparency = 1, Parent = FakeRig})
	local FakeLeftLeg = ci("Part", {Name = "Left Leg", Size = v3new(1, 2, 1),Transparency = 1, Parent = FakeRig})
	local FakeHum = ci("Humanoid", {DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None, Parent = FakeRig})
	ci("Motor6D", {Name = "Neck", Part0 = FakeTorso, Part1 = FakeHead, C0 = Cfnew(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0), C1 = Cfnew(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0), Parent = FakeTorso})
	ci("Motor6D", {Name = "RootJoint", Part0 = FakeRoot, Part1 = FakeTorso, C0 = Cfnew(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0), C1 = Cfnew(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0), Parent = FakeRoot})
	ci("Motor6D", {Name = "Right Shoulder", Part0 = FakeTorso, Part1 = FakeRightArm, C0 = Cfnew(1, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0), C1 = Cfnew(-0.5, 0.5, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0), Parent = FakeTorso})
	ci("Motor6D", {Name = "Left Shoulder", Part0 = FakeTorso, Part1 = FakeLeftArm, C0 = Cfnew(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), C1 = Cfnew(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), Parent = FakeTorso})
	ci("Motor6D", {Name = "Right Hip", Part0 = FakeTorso, Part1 = FakeRightLeg, C0 = Cfnew(1, -1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0), C1 = Cfnew(0.5, 1, 0, 0, 0, 1, 0, 1, -0, -1, 0, 0), Parent = FakeTorso})
	ci("Motor6D", {Name = "Left Hip", Part0 = FakeTorso, Part1 = FakeLeftLeg, C0 = Cfnew(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), C1 = Cfnew(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0), Parent = FakeTorso})
	ci("Animator", {Parent = FakeHum}); ci("HumanoidDescription", {Parent = FakeHum}); ci("SpecialMesh", {Scale = v3new(1,1,1)*1.25, Parent = FakeHead})
	ci("Script", {Name = "Health", Parent = FakeRig}); ci("LocalScript", {Name = "Animate", Parent = FakeRig})
	ci("Decal", {Name = "face", Texture = "rbxasset://textures/face.png", Transparency = 1, Parent = FakeHead})
	innew("Shirt", FakeRig).Name="Shirt" innew("Pants", FakeRig).Name="Pants" innew("ShirtGraphic", FakeRig)
	FakeRigChildren =  FakeRig:GetChildren()
	
	local Event; Event = PreSim:Connect(function()
		if not FakeRig:IsDescendantOf(workspace) then
			Event:Disconnect()
		end

		for i = 1, #FakeRigChildren do
			local x = FakeRigChildren[i]

			if x and x.Parent and x:IsA("BasePart") then
				x.CanCollide = false
				x.CanQuery = false
				x.CanTouch = false
			end
		end
	end)
	
	FakeRig.PrimaryPart = HRP
	FakeRig.Name = LocalPlayer.Name
	FakeRoot.CFrame = HRP.CFrame
	FakeRig.Parent = workspace
	PreSim:Wait(); PostSim:Wait()
end
local FakeRoot = FakeRig.HumanoidRootPart

for i,v in pairs(Backpack:GetChildren()) do
	if v:IsA("Tool") and v:FindFirstChild("Handle") then
		Tools[#Tools+1] = v
		Humanoid:EquipTool(v)
	end
end; Humanoid:UnequipTools()

local Event; Event = PreSim:Connect(function()
	if not Character:IsDescendantOf(workspace) then
		Event:Disconnect()
	end

	for i = 1, #Descendants do
		local x = Descendants[i]

		if x and x.Parent and x:IsA("BasePart") then
			x.CanCollide = false
			x.CanQuery = false
			x.CanTouch = false
		end
	end

	for i = 1, #Tools do
		local x = Tools[i]
		local Handle = x:FindFirstChild("Handle")

		if Handle and Handle.Parent and Handle:IsA("BasePart") then
			Handle.CanCollide = false
			Handle.CanQuery = false
			Handle.CanTouch = false
			Handle.Massless = false
		end
	end
end)

local function SetupTool(Tool, PartTo, Offset)
	if not Tool then return end
	
	local Handle = Tool:WaitForChild("Handle")

	Tool.Parent = Character
	Tool.Parent = Backpack
	Tool.Parent = Humanoid
	Tool.Parent = Character

	local Event2; Event2 = PostSim:Connect(function()
		if not Tool:IsDescendantOf(Character) then
			Event2:Disconnect()
		end

		Handle.AssemblyLinearVelocity = v3new(PartTo.AssemblyLinearVelocity.X * (Handle.Mass*10) , Randomizer, PartTo.AssemblyLinearVelocity.Z * (Handle.Mass*10))
		Handle.AssemblyAngularVelocity = AntiSleepRotate
		
		if Handle.ReceiveAge == 0 then
			Handle.CFrame = PartTo.CFrame * AntiSleep * Offset
		end
	end)
end

SetupTool(Tools[1], FakeRig:WaitForChild("Torso"), (Cfnew(-0.6,1.2,0) * Cfangles(rad(0), rad(90), rad(90)) ))
SetupTool(Tools[2], FakeRig:WaitForChild("Torso"), (Cfnew(0,1.2,0) * Cfangles(rad(0), rad(90), rad(90)) ))
SetupTool(Tools[3], FakeRig:WaitForChild("Torso"), (Cfnew(0.6,1.2,0) * Cfangles(rad(0), rad(-90), rad(-90)) ))
SetupTool(Tools[4], FakeRig:WaitForChild("Right Arm"), (Cfnew(0.05,1.2,0) * Cfangles(0, rad(-90), rad(-90)) ))
SetupTool(Tools[5], FakeRig:WaitForChild("Left Arm"), (Cfnew(-0.05,1.2,0) * Cfangles(rad(0), rad(90), rad(90)) ))
SetupTool(Tools[6], FakeRig:WaitForChild("Right Leg"), (Cfnew(0,0.45,0) * Cfangles(rad(0), rad(-90), rad(-90)) ))
SetupTool(Tools[7], FakeRig:WaitForChild("Left Leg"), (Cfnew(-0,0.45,0) * Cfangles(rad(0), rad(90), rad(90)) ))
SetupTool(Tools[8], FakeRig:WaitForChild("Head"), (Cfnew(0,2,-0.2) * Cfangles(rad(0), rad(0), rad(0)) ))

local FakeRigHRP = FakeRig:WaitForChild("HumanoidRootPart")
local FakeHumanoid = FakeRig:FindFirstChildOfClass("Humanoid")
local StaticRoot = Cfnew(0, -8, 0)
task.spawn(function()
	while wait(3) do
		StaticRoot = Cfnew()
		wait(0.5)
		StaticRoot = Cfnew(0,-8,0)
	end
end)

for _, x in pairs(workspace:GetDescendants()) do
	if x:IsA("Tool") then
		local Target = x:FindFirstChild("TouchInterest", true)
		if Target then Target:Destroy() end
	end
end

local FixEvent; FixEvent = workspace.ChildAdded:Connect(function(Child)
	if Child:IsA("Tool") then
		local Target = Child:FindFirstChild("TouchInterest", true)
		if Target then Target:Destroy() end
	end
end)

local V30 = Vector3.zero
local FPDH = Workspace.FallenPartsDestroyHeight
local SpawnPoint = Workspace:FindFirstChildOfClass("SpawnLocation") and Workspace:FindFirstChildOfClass("SpawnLocation").CFrame * Cfnew(0,20,0) or Cfnew(0,20,0)
local MiscEvent; MiscEvent = PostSim:Connect(function()
	if not Character:IsDescendantOf(workspace) then
		MiscEvent:Disconnect()
	end

	AntiSleep = Cfnew(0.0065 * sin(clock()*32), 0, 0.0065 * cos(clock()*32))
	AntiSleepRotate = v3new(0, sin(clock()*10), 0)
	Randomizer = 27.5 + cos(clock()*1)
	
	if not ClickFling then
		HRP.CFrame = FakeRigHRP.CFrame * StaticRoot
		HRP.AssemblyLinearVelocity = v3new(0, 0, 0)
	end

	if AntiVoid then
		if FakeRoot and FakeRoot.Position.Y <= (FPDH+75) then
			FakeRoot.CFrame = SpawnPoint
			FakeRoot.Velocity = V30
		end
	end
end)

wait()
LocalPlayer.Character = FakeRig
Character.Parent = FakeRig
Camera.CameraSubject = FakeHumanoid
FakeHumanoid.CameraOffset = Krypton.CamOffset or v3new(0, 1.25, 0)
Backpack:ClearAllChildren()

FakeHumanoid.Died:Once(function()
	Character.Parent = workspace
	LocalPlayer.Character = Character
	Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	Character:BreakJoints()
	
	FakeRig:Destroy()
end)

print("loaded in"..tostring(tick()-loadtime))

if ClickFling then
	local CF0 = Cfnew(0,0,0)
	local v3zero = Vector3.zero
	local delay = task.delay
	local StaticValue = v3new(0, 0, 0)
	local UsedValue = v3new(1000, 500, 2000)
	local Mouse = LocalPlayer:GetMouse()
	local CurrentTarget;
	local TargetHumanoid;
	local Fired = false
		
	local ClickEvent; ClickEvent = Mouse.Button1Down:Connect(function()
		if not Character:IsDescendantOf(workspace) then
			ClickEvent:Disconnect()
		end
		
		if not Fired then
			local DefaultJP = Humanoid.JumpPower
			Humanoid.JumpPower = 0
			Fired = true; delay(0.15, function()
				Fired = false
				Humanoid.JumpPower = DefaultJP
			end)
		end
	end)

	local FlingEvent; FlingEvent = PostSim:Connect(function()
		if not Character:IsDescendantOf(workspace) then
			FlingEvent:Disconnect()
		end
		
		if Fired and HRP then
			if Mouse.Target ~= nil then
				CurrentTarget = Mouse.Target.Parent and Mouse.Target.Parent:FindFirstChildOfClass("Part") or Mouse.Target.Parent.Parent and Mouse.Target.Parent.Parent:FindFirstChildOfClass("Part")
				HRP.AssemblyLinearVelocity = UsedValue
				if CurrentTarget and CurrentTarget.Name == "HumanoidRootPart" or CurrentTarget.Name == "Head" or CurrentTarget.Name == "Handle" then
					TargetHumanoid = CurrentTarget.Parent:FindFirstChildOfClass("Humanoid") or CurrentTarget.Parent.Parent:FindFirstChildOfClass("Humanoid") 
					if TargetHumanoid and TargetHumanoid.MoveDirection.Magnitude >= 0.1 then
						HRP.CFrame = Cfnew(CurrentTarget.Position) * Cfnew(TargetHumanoid.MoveDirection*7.5)
					else
						HRP.CFrame = Cfnew(CurrentTarget.Position) * (CurrentTarget.Velocity.Magnitude > 6 and Cfnew(CurrentTarget.CFrame.LookVector*Random(-4, 5)) or CF0)
					end
				else
					HRP.CFrame = Mouse.Hit
				end
			end
		elseif HRP then
			HRP.CFrame = FakeRigHRP.CFrame * AntiSleep * StaticRoot
			HRP.AssemblyLinearVelocity = StaticValue
		end
	end)
end
