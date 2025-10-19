-- [[ -} Kade's Reanimate v1.0.0 {- ]] --
-- [[ Krypton if it just *worked*.  ]] --
-- [[ W-Woof Woof!~... Harf Hauuu!~ ]] --

--[[ 
	Roadmap:

	✅ Setup
	✅ Hat lookup & alignment
	🟡 Velocity logic - to be continued
	✅ Respawn handling 
	> ??? Flinging (Planned)
	🟡 Camera management - partial
	🟡 Custom Movement Handler - pc awesome, mobile needs improvement
		- specifing mobile issue: Camera moves alongside with the pointer, also its not respecting the set borders and it is not possible to move your character because of the gui joystick taking the input
	🟡 organize code structure
	✅ load unless asked to feature
	🟡 camera fixes - mobile needs improvement, pc is flawless


	❌ compatibility with krypton
	❌ other configs
	❌ kadeapi
]]

GELATEK_MANUAL_CONFIG = {
	DelayRespawnTime = 0.26,
	TeleportationOffset = 12,
	HeightRigDestroyOffset = 15,
	ApplyCharacterVariable = false,
	UsePermanentDeath = true,
	HideServerCharacter = true,
	RigAnimations = true,
	MobileSettings = {
		Deadzone = 50,	
	},
	Accoutrements = {
		["Right Arm"] = {
			{Texture = "14255544465", Mesh = "14255522247", Name = "RARM", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "4391374782", Mesh = "4324138105", Name = "MeshPartAccessory", Offset =  CFrame.new(0.05,0,0) * CFrame.Angles(math.rad(-90), 0, math.rad(90))},
			{Texture = "4645402630", Mesh = "3030546036", Name = "International Fedora", Offset = CFrame.new(0.05,0,0) * CFrame.Angles(math.rad(90), 0, math.rad(-90))},
			{Texture = "135650240593878", Mesh = "137702817952968", Name = "Accessory (RArmNoob)", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "130809869695496", Mesh = "139733645770094", Name = "Accessory (RARM)", Offset = CFrame.Angles(0, 0, math.rad(90))},
		},
	
		["Left Arm"] = {
			{Texture = "14255544465", Mesh = "14255522247", Name = "LARM", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "4154474807", Mesh = "4154474745", Name = "MeshPartAccessory", Offset =  CFrame.new(-0.05,0,0) * CFrame.Angles(math.rad(90), 0, math.rad(-90))},
			{Texture = "3650139425", Mesh = "3030546036", Name = "International Fedora", Offset = CFrame.new(-0.05,0,0) * CFrame.Angles(math.rad(-90), 0, math.rad(90))},
			{Texture = "135650240593878", Mesh = "137702817952968", Name = "Accessory (LArmNoob)", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "71060417496309", Mesh = "105141400603933", Name = "Accessory (LARM)", Offset = CFrame.Angles(0, 0, math.rad(90))},
		},
	
		["Right Leg"] = {
			{Texture = "17374768001", Mesh = "17374767929", Name = "Accessory (RARM)", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "3360974849", Mesh = "3030546036", Name = "InternationalFedora", Offset = CFrame.Angles(math.rad(90), 0, math.rad(-90))},
			{Texture = "4622077774", Mesh = "3030546036", Name = "International Fedora", Offset = CFrame.Angles(math.rad(-90), 0, math.rad(90))},
			{Texture = "3360978739", Mesh = "3030546036", Name = "InternationalFedora", Offset = CFrame.Angles(math.rad(-90), 0, math.rad(90))},
			{Texture = "11159284657", Mesh = "11159370334", Name = "Unloaded head", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "136752500636691", Mesh = "125405780718494", Name = "Accessory (RArm)", Offset = CFrame.Angles(0, 0, math.rad(90))},
		},
	
		["Left Leg"] = {
			{Texture = "17374768001", Mesh = "17374767929", Name = "Accessory (LARM)", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "3033903209", Mesh = "3030546036", Name = "InternationalFedora", Offset = CFrame.Angles(math.rad(90), 0, math.rad(90))},
			{Texture = "3860099469", Mesh = "3030546036", Name = "InternationalFedora", Offset = CFrame.Angles(math.rad(-90), 0, math.rad(-90))},
			{Texture = "3409604993", Mesh = "3030546036", Name = "InternationalFedora", Offset = CFrame.Angles(math.rad(-90), 0, math.rad(-90))},
			{Texture = "11263219250", Mesh = "11263221350", Name = "MeshPartAccessory", Offset = CFrame.Angles(0, 0, math.rad(90))},
			{Texture = "136752500636691", Mesh = "125405780718494", Name = "Accessory (LArm)", Offset = CFrame.Angles(0, 0, math.rad(90))},
		},
	
		["Torso"] = {
			{Texture = "13415110780", Mesh = "13421774668", Name = "MeshPartAccessory", Offset = CFrame.identity},
			{Texture = "17617036903", Mesh = "17617036887", Name = "Accessory (1x1x1x1's Transparent Torso)", Offset = CFrame.identity},
			{Texture = "125975972015302", Mesh = "126825022897778", Name = "Accessory (TorsoNoob)", Offset = CFrame.identity},
			{Texture = "4819722776", Mesh = "4819720316", Name = "MeshPartAccessory", Offset = CFrame.Angles(0, 0, math.rad(-15))}
		},
	}
}

-- Init.

local ReanimationSettings = GELATEK_MANUAL_CONFIG or {}
local PresetAccoutrements = ReanimationSettings.Accoutrements

local _CFramelookAt = CFrame.lookAt
local _CFrameNew = CFrame.new

local _taskdefer = task.defer
local _taskwait = task.wait
local _tableclear = table.clear
local _osclock = os.clock
local _mathsin = math.sin
local _mathsqrt = math.sqrt
local _stringmatch = string.match
local _CFrameidentity = CFrame.identity
local _Vector3new = Vector3.new
local _Vector3zero = Vector3.zero

local ANTI_SLEEP_VECTOR = Vector3.one
local ANTI_SLEEP_POWER = 0.009
local JUMP_ANIM_TIME = 0
local SHIFT_LOCK_STATE = Enum.MouseBehavior.LockCenter
local CAMERA_TYPE_CUSTOM = Enum.CameraType.Custom

local IS_CHAR_VAR_CHANGABLE = ReanimationSettings.ApplyCharacterVariable
local IS_BODY_HIDING_ENABLED = ReanimationSettings.HideServerCharacter
local RESPAWN_DELAY_NUMBER = ReanimationSettings.DelayRespawnTime
local MOBILE_MOVE_DEADZONE = ReanimationSettings.MobileSettings.Deadzone
local CAMERA_SENSITIVITY = 0.006
local MAX_CAMERA_PITCH = math.rad(80)

local ClientRigAnimationsToggled = ReanimationSettings.RigAnimations

local _DataModel: DataModel = game
local _GetPropertyChangedSignal = _DataModel.GetPropertyChangedSignal
local _FindFirstChildOfClass = _DataModel.FindFirstChildOfClass
local _WaitForChild = _DataModel.WaitForChild
local _FindFirstChild = _DataModel.FindFirstChild
local _GetChildren = _DataModel.GetChildren
local _GetDescendants = _DataModel.GetDescendants
local _IsDescendantOf = _DataModel.IsDescendantOf
local _Destroy = _DataModel.Destroy
local _Clone = _DataModel.Clone
local _IsA = _DataModel.IsA

local Accoutrements: {Accoutrement} = {}
local Attachments: {Attachment} = {}
local RBXScriptSignals: {RBXScriptSignal} = {}

local KeyInputs = {W = {0, 0, -1}, A = {0, -1, 0}, S = {0, 0, 1}, D = {0, 1, 0}}
local MovementDirection = _Vector3zero

local MobileMovementTouch = nil
local MobileMovementStartPos = nil
local MobileCameraLock = false
local MobileMoveVector = _Vector3zero

local Workspace: Workspace = _FindFirstChildOfClass(_DataModel, "Workspace")
local Players: Players = _FindFirstChildOfClass(_DataModel, "Players")
local StarterGui: StarterGui = _FindFirstChildOfClass(_DataModel, "StarterGui")
local RunService: RunService = _FindFirstChildOfClass(_DataModel, "RunService")
local UserInputService: UserInputService = _FindFirstChildOfClass(_DataModel, "UserInputService")

local Camera = Workspace.CurrentCamera
local LastCameraCFrame = _CFrameidentity

local FallenPartsDestroyHeight = Workspace.FallenPartsDestroyHeight
local HeightOffset = FallenPartsDestroyHeight + ReanimationSettings.HeightRigDestroyOffset
local RadiusOffset = ReanimationSettings.TeleportationOffset

local LocalPlayer: Player = Players.LocalPlayer
local Character: Model = LocalPlayer.Character

local RespawnHandler: BindableEvent = Instance.new("BindableEvent")
local RootPart: BasePart = _WaitForChild(Character, "HumanoidRootPart", 1)
local Humanoid: Humanoid = _FindFirstChildOfClass(Character, "Humanoid")

if not RootPart or not Humanoid or not Camera then
	return
end

local AnimateScript: LocalScript
local ClientRig: Model
local ClientRootPart: BasePart
local ClientHumanoid: Humanoid
local ClientAnimator: Animator

local function WaitForInstance(Parent: Instance, Class: string, Name: string | nil, Cooldown: number | nil)
	local CurTime = Cooldown or 0

	while 1 > CurTime do
		for _, Any in _GetChildren(Parent) do
			if _IsA(Any, Class) and (not Name or Any.Name == Name) then
				return Any
			end
		end

		CurTime += _taskwait()
	end
end

-- [[ Accoutrement Functions ]] -- 

local function BuildAccoutrementLookup()
	local Lookup = {}
	
	for _, Accessory in _GetChildren(Character) do
		if not _IsA(Accessory, "Accoutrement") then
			continue
		end
		
		local Handle = _FindFirstChild(Accessory, "Handle")
		if not Handle then
			continue
		end
		
		local IsMeshPart = _IsA(Handle, "MeshPart")
		local MeshObject = IsMeshPart and Handle or _FindFirstChildOfClass(Handle, "SpecialMesh")
		
		if not MeshObject then
			continue
		end
		
		local MeshId = _stringmatch(MeshObject.MeshId, "%d+")
		local TextureId = _stringmatch(IsMeshPart and MeshObject.TextureID or MeshObject.TextureId, "%d+")
		
		if MeshId and TextureId then
			local Key = MeshId .. "___" .. TextureId .. "___" .. Accessory.Name
			Lookup[Key] = {Accessory, Handle}
		end
	end
	
	return Lookup
end

local function RetrieveAccoutrements()
	local AccoutrementLookup = BuildAccoutrementLookup()
	
	for _, BasePart in _GetChildren(ClientRig) do
		if not _IsA(BasePart, "BasePart") then
			continue
		end
		
		local LimbData = PresetAccoutrements[BasePart.Name]
		if not LimbData then
			continue
		end
		
		for _, Information in LimbData do
			local Key = Information.Mesh .. "___" .. Information.Texture .. "___" .. Information.Name
			local Found = AccoutrementLookup[Key]
			
			if Found then
				local Handle = Found[2]
				Accoutrements[Handle] = {BasePart, Information.Offset or _CFrameidentity}
			end
		end
	end
	
	for _, Accessory in _GetChildren(Character) do
		if not _IsA(Accessory, "Accoutrement") then
			continue
		end
		
		local Handle = _FindFirstChild(Accessory, "Handle")
		if not Handle or Accoutrements[Handle] then
			continue
		end
		
		local ClonedAccessory = _Clone(Accessory)
		local ClonedHandle = _FindFirstChild(ClonedAccessory, "Handle")
		local Attachment = _FindFirstChildOfClass(ClonedHandle, "Attachment")
		local RigAttachment = Attachments[Attachment.Name]
		
		if not RigAttachment then
			continue
		end
		
		local Weld = Instance.new("Weld")
		ClonedHandle.Transparency = 1
		Weld.Name = "AccessoryWeld"
		Weld.Part0 = ClonedHandle
		Weld.Part1 = RigAttachment.Parent
		Weld.C0 = Attachment.CFrame
		Weld.C1 = RigAttachment.CFrame
		Weld.Parent = ClonedHandle
		
		ClonedAccessory.Parent = ClientRig
		Accoutrements[Handle] = {ClonedHandle, _CFrameidentity}
	end
end

-- [[ Miscellacious Functions ]] -- 

local function LoadRBXScriptSignalTable(Table: {...})
	for SignalName, Data in Table do 
		local Signal: RBXScriptSignal = Data[1]
		local Function: (...any) -> (...any) = Data[2]

		RBXScriptSignals[Table][SignalName] = Signal:Connect(Function)
	end
end

local function ResetCameraPosition()
	Camera.CameraSubject = ClientHumanoid
	RunService.PreRender:Wait()
	Camera.CFrame = LastCameraCFrame
end

-- [[ Character Functions ]] --

local function SuppressDeath()
	local Sound = WaitForInstance(RootPart, "Sound", "Died", RESPAWN_DELAY_NUMBER)

	if Sound then
		Sound.Volume = 0
	end
end

local function FinalizeCharacterAdded()
	task.spawn(ResetCameraPosition)

	if ReanimationSettings.TeleportationOffset < 1 and not TeleportOffset then
		Humanoid:ChangeState(15)
		RetrieveAccoutrements()
	end

	local Position = ClientRootPart.Position
	local X = Position.X
	local Y = Position.Y
	local Z = Position.Z

	local _X = math.random(-RadiusOffset, RadiusOffset)
	local _Y = IS_BODY_HIDING_ENABLED and HeightOffset or Y + 0.5
	local _Z = math.random(-RadiusOffset, RadiusOffset)

	local TeleportOffset = _CFrameNew(X + _X, _Y, Z + _Z)
	
	local Time = 0
	while RESPAWN_DELAY_NUMBER > Time do
		RootPart.AssemblyLinearVelocity = _Vector3zero
		RootPart.CFrame = TeleportOffset
		Time += _taskwait()
	end

	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	Humanoid:ChangeState(15)
	RunService['PostSimulation']:Wait()

	RetrieveAccoutrements()
end

local function ApplyCharacterProperty()
	if IS_BODY_HIDING_ENABLED then
		repeat _taskwait() until not _FindFirstChild(Character, "HumanoidRootPart")
	end

	_taskwait(RESPAWN_DELAY_NUMBER * 2)
	LocalPlayer['Character'] = ClientRig
	ResetCameraPosition()
end

-- [[ Movement RBXScriptSignals ]] --

local MobileRBXScriptSignalFunctions = {
	['TouchStarted'] = {UserInputService.TouchStarted, function(Touch, GameProcessed)
		local ViewportSize = Camera.ViewportSize
		local TouchPos = Touch.Position
		
		if TouchPos.X > ViewportSize.X * 0.4 or GameProcessed then
			return
		end
		
		if not MobileMovementTouch then
			MobileMovementTouch = Touch
			MobileMovementStartPos = TouchPos
			MobileMoveVector = _Vector3zero
			MobileCameraLock = true
		end
	end},
	
	['TouchMoved'] = {UserInputService.TouchMoved, function(Touch, GameProcessed)
		if not MobileMovementTouch or Touch ~= MobileMovementTouch then
			return
		end
		
		if MobileCameraLock then
			Camera.CFrame = LastCameraCFrame
		end
		
		local CurrentPos = Touch.Position
		local DeltaX = CurrentPos.X - MobileMovementStartPos.X
		local DeltaY = CurrentPos.Y - MobileMovementStartPos.Y
		
		local Magnitude = _mathsqrt(DeltaX * DeltaX + DeltaY * DeltaY)
		
		if Magnitude > MOBILE_MOVE_DEADZONE then
			local NormX = DeltaX / Magnitude
			local NormY = DeltaY / Magnitude
			
			local CameraCFrame = LastCameraCFrame
			local CameraLook = CameraCFrame.LookVector
			local CameraRight = CameraCFrame.RightVector
			
			local MoveX = CameraRight.X * NormX - CameraLook.X * NormY
			local MoveZ = CameraRight.Z * NormX - CameraLook.Z * NormY
			
			MobileMoveVector = _Vector3new(MoveX, 0, MoveZ).Unit
		else
			MobileMoveVector = _Vector3zero
		end
		
		ClientHumanoid:Move(MobileMoveVector, false)
	end},
	
	['TouchEnded'] = {UserInputService.TouchEnded, function(Touch, GameProcessed)
		if MobileMovementTouch and Touch == MobileMovementTouch then
			MobileMovementTouch = nil
			MobileMovementStartPos = nil
			MobileMoveVector = _Vector3zero
			MobileCameraLock = false
			ClientHumanoid:Move(_Vector3zero, false)
		end
	end}
}

local KBMRBXScriptSignalFunctions = {
	['InputBegan'] = {UserInputService.InputBegan, function(Input, GameProcessed)
		if GameProcessed then
			return
		end

		local KeyCode = Input.KeyCode.Name

		if KeyInputs[KeyCode] then
			KeyInputs[KeyCode][1] = 1
		end
	end},

	['InputEnded'] = {UserInputService.InputEnded, function(Input, GameProcessed)
		if GameProcessed then
			return
		end

		local KeyCode = Input.KeyCode.Name

		if KeyInputs[KeyCode] then
			KeyInputs[KeyCode][1]  = 0
		end
	end},

	['PostSimulation'] = {RunService.PostSimulation, function()
		local Shiftlock = UserInputService.MouseBehavior == SHIFT_LOCK_STATE
		local MovementVector = _Vector3zero

		ClientHumanoid.AutoRotate = not Shiftlock

		for Key, Table in KeyInputs do
			if Table[1] == 1 then
				MovementVector = Vector3.new(MovementVector.X + Table[2], 0, MovementVector.Z + Table[3])
			end
		end

		if Shiftlock then
			local LookVector = Camera.CFrame.LookVector
			local Offset = CFrame.Angles(0, math.atan2(-LookVector.X, -LookVector.Z), 0)

			ClientRootPart.CFrame = Offset + ClientRootPart.Position
		end

		ClientHumanoid:Move(MovementVector, true)
	end}
}

-- [[ Main RBXScriptSignals ]] --

local RBXScriptSignalFunctions; RBXScriptSignalFunctions = {
	['PreRender'] = {RunService['PreRender'], function()
		local CurrentCFrame = Camera.CFrame

		if (LastCameraCFrame.Position.Magnitude - CurrentCFrame.Position.Magnitude) > 3 then
			Camera.CameraSubject = ClientHumanoid
			Camera.CFrame = LastCameraCFrame
		end

		if Camera.CameraSubject ~= ClientHumanoid then
			ResetCameraPosition()
		end
	
		if Camera.CameraType ~= CAMERA_TYPE_CUSTOM then
			Camera.CameraType = CAMERA_TYPE_CUSTOM
		end

		LastCameraCFrame = CurrentCFrame
	end},

	['PrePhysics'] = {RunService['PreSimulation'], function()
		for Part0: BasePart, Information in Accoutrements do
			if not Part0.ReceiveAge == 0 then
				continue
			end
			
			local Part1: BasePart = Information[1]
			
			if not Part1 then
				continue
			end
	
			local _CFrame = Part1.CFrame
			local _LookVector = _CFrame.LookVector
			local _Mass = Part1.AssemblyMass
			local _LinearVelocity = _LookVector + Part1.AssemblyLinearVelocity * _Mass
	
			Part0.AssemblyLinearVelocity = _Vector3new(_LinearVelocity.X, 30, _LinearVelocity.Z)
			Part0.AssemblyAngularVelocity = Part1.AssemblyAngularVelocity
		end
		
		if not IS_CHAR_VAR_CHANGABLE and _IsDescendantOf(Humanoid, Character) then
			ClientHumanoid.Jump = Humanoid.Jump
		end
		
		ANTI_SLEEP_VECTOR = _Vector3new(ANTI_SLEEP_POWER * _mathsin(_osclock() * 15), 0, 0)
	end},

	['PostPhysics'] = {RunService['PostSimulation'], function(DeltaTime)
		ClientRigAnimationsToggled = AnimateScript and AnimateScript.Parent and AnimateScript.Enabled
		JUMP_ANIM_TIME = math.max(0, JUMP_ANIM_TIME - DeltaTime)

		for Part0: BasePart, Information in Accoutrements do
			if not Part0.ReceiveAge == 0 then
				continue
			end

			local Part1: BasePart = Information[1]
			local Offset: CFrame = Information[2]
	
			if not Part1 and not Offset then
				continue
			end
	
			Part0.CFrame = Part1.CFrame * Offset + ANTI_SLEEP_VECTOR
		end
	end},

	['CameraChange'] = {_GetPropertyChangedSignal(Workspace, "CurrentCamera"), function()
		if not Camera or Camera.Parent == nil then
			Camera = Workspace.CurrentCamera
	
			local CameraFunction = RBXScriptSignalFunctions['CameraChange'] -- could have just debug.info but nah 

			RBXScriptSignals['CameraSubjectChange']:Disconnect()
			RBXScriptSignals['CameraSubjectChange'] = CameraFunction[1]:Connect(CameraFunction[2])
		end
	end},

	['CharacterAdded'] = {LocalPlayer['CharacterAdded'], function(_Character)
		task.spawn(ResetCameraPosition)

		if _Character == ClientRig then
			return
		end

		_tableclear(Accoutrements)
		
		Character = _Character
		Humanoid = WaitForInstance(Character, "Humanoid", "Humanoid")
		RootPart = WaitForInstance(Character, "Part", "HumanoidRootPart")
		task.spawn(SuppressDeath)

		FinalizeCharacterAdded()
	
		if IS_CHAR_VAR_CHANGABLE then
			_taskdefer(ApplyCharacterProperty)
		end
	
		StarterGui:SetCore("ResetButtonCallback", RespawnHandler)
	end},

	['RespawnHandler'] = {RespawnHandler.Event, function()
		if replicatesignal then
			replicatesignal(LocalPlayer.ConnectDiedSignalBackend)
		end		
		
		LocalPlayer.Character = Character
		ClientRig:BreakJoints()

		LocalPlayer.CharacterAdded:Wait()
		table.clear(Accoutrements)
		StarterGui:SetCore("ResetButtonCallback", true)

		for Name, RBXScriptSignal in RBXScriptSignals do
			RBXScriptSignal:Disconnect()
		end

		ClientRig:Destroy()
	end},
}

-- RBXScriptSignals['CameraSubjectChange'] = _GetPropertyChangedSignal(Camera, "CameraSubject"):Connect(ResetCameraPosition)

local Library = {
	Load = function(Settings)
		if ClientRig then
			return
		end

		ClientRig = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
		ClientRootPart = _WaitForChild(ClientRig, "HumanoidRootPart", 1)
		ClientHumanoid = _FindFirstChildOfClass(ClientRig, "Humanoid")
		ClientAnimator = _FindFirstChildOfClass(ClientHumanoid, "Animator")
		AnimateScript = _FindFirstChildOfClass(ClientRig, "LocalScript"); do -- "Kade what the fuck are you doing" the base animate script is really bloated
			AnimateScript:Destroy()
			AnimateScript = Instance.new("LocalScript")
			AnimateScript.Name = "Animate"
			AnimateScript.Parent = ClientRig
		end

		local RootPartCurrentCFrame = RootPart.CFrame
		ClientRig.Parent = Workspace
		SuppressDeath()

		for _, Index: Instance in _GetDescendants(ClientRig) do
			if _IsA(Index, "BasePart") then
				Index.Transparency = 1
				Index.CanCollide = false
				Index.CanQuery = false
				Index.CanTouch = false
			elseif _IsA(Index, "Decal") then
				Index.Transparency = 1
			elseif _IsA(Index, "Attachment") then
				Attachments[Index.Name] = {
					Parent = Index.Parent,
					CFrame = Index.CFrame
				}
			end
		end
		LoadRBXScriptSignalTable(RBXScriptSignalFunctions)

		if UserInputService.TouchEnabled then
			LoadRBXScriptSignalTable(MobileRBXScriptSignalFunctions)
		end

		if UserInputService.KeyboardEnabled then
			LoadRBXScriptSignalTable(KBMRBXScriptSignalFunctions)
		end

		ClientRig:PivotTo(RootPartCurrentCFrame)

		if ReanimationSettings.UsePermanentDeath and replicatesignal then
			replicatesignal(LocalPlayer.ConnectDiedSignalBackend)
			_taskwait(Players.RespawnTime + RESPAWN_DELAY_NUMBER)
			
			FinalizeCharacterAdded()
			replicatesignal(LocalPlayer.Kill)
		else
			FinalizeCharacterAdded()
		end

		if IS_CHAR_VAR_CHANGABLE then
			ApplyCharacterProperty()
		end
		
		RetrieveAccoutrements()
		StarterGui:SetCore("ResetButtonCallback", RespawnHandler)

		if ReanimationSettings.RigAnimations then	
			local function AddAnimation(ID)
				local Animation = Instance.new("Animation")
				Animation.AnimationId = ID
				return Animation
			end
	
			local Current = {
				Speed = 0,
				Animation = "",
				Instance = nil,
				AnimTrack = nil,
				KeyframeHandler = nil,
			}
	
			local AnimationTable = {
				Idle = AddAnimation("http://www.roblox.com/asset/?id=180435571"),
				Walk = AddAnimation("http://www.roblox.com/asset/?id=180426354"),
				Run = AddAnimation("Run.xml"),
				Jump = AddAnimation("http://www.roblox.com/asset/?id=125750702"),
				Fall = AddAnimation("http://www.roblox.com/asset/?id=180436148"),
				Climb = AddAnimation("http://www.roblox.com/asset/?id=180436334"),
				Sit = AddAnimation("http://www.roblox.com/asset/?id=178130996"),
	
				dance1 = AddAnimation("http://www.roblox.com/asset/?id=182435998"),
				dance2 = AddAnimation("http://www.roblox.com/asset/?id=182436842"),
				dance3 = AddAnimation("http://www.roblox.com/asset/?id=182436935"),
				wave = AddAnimation("http://www.roblox.com/asset/?id=128777973"),
				point = AddAnimation("http://www.roblox.com/asset/?dan=128853357"),
				laugh = AddAnimation("http://www.roblox.com/asset/?id=129423131"),
				cheer = AddAnimation("http://www.roblox.com/asset/?id=129423030"),
			}
			
			local function PlayAnimation(AnimName, TransitionTime, Looped)
				local Anim = AnimationTable[AnimName]
	
				if Anim == Current.Instance then
					return
				end

				if Current.AnimTrack then
					Current.AnimTrack:Stop(TransitionTime)
					Current.AnimTrack:Destroy()
				end
	
				if Current.KeyframeHandler then
					Current.KeyframeHandler:Disconnect()
				end

				Current.Speed = 1.0
				Current.AnimTrack = ClientAnimator:LoadAnimation(Anim)

				Current.AnimTrack.Priority = Enum.AnimationPriority.Core
				Current.AnimTrack:Play(TransitionTime)
	
				Current.Animation = AnimName
				Current.Instance = Anim
	
				Current.KeyframeHandler = Current.AnimTrack.KeyframeReached:Connect(function(FrameName)
					if ClientRigAnimationsToggled then
						if Looped then
							PlayAnimation(AnimName, 0.1, true)
		
						elseif FrameName == "End" and AnimationTable[Current.Animation] then
							PlayAnimation("Idle", 0.1)
						end
					end
				end)
			end
	
			local function SetAnimationSpeed(Speed)
				Current.Speed = Speed
				Current.AnimTrack:AdjustSpeed(Speed)
			end
	
			local EventHandlers = {
				Running = function(Speed)
					if Speed > 0.01 then
						PlayAnimation("Walk", 0.1)
						SetAnimationSpeed(Speed / 14.5)
					else
						PlayAnimation("Idle", 0.1)
					end
				end,
	
				Jumping = function()
					PlayAnimation("Jump", 0.1)
					JUMP_ANIM_TIME = 0.3
				end,
	
				Climbing = function(Speed)
					PlayAnimation("Climb", 0.1)
					SetAnimationSpeed(Speed / 12.0)
				end,
	
				FreeFalling = function()
					if JUMP_ANIM_TIME <= 0 then
						PlayAnimation("Fall", 0.3)
					end
				end,
			}
	
			for EventName, Handler in EventHandlers do
				RBXScriptSignals['Humanoid'..EventName] = ClientHumanoid[EventName]:Connect(function(...)
					if ClientRigAnimationsToggled then
						Handler(...)
					end
				end)
			end

			RBXScriptSignals['Chatted'] = LocalPlayer.Chatted:Connect(function(Message)
				local Context = Message and string.gsub(Message, "/e ", "")
	
				if ClientRigAnimationsToggled and AnimationTable[Context] then
					PlayAnimation(Context, 0.1, true)
				end
			end)
		end
	end, 

	Stop = RBXScriptSignalFunctions['RespawnHandler'][2]
}

Library.Load()
