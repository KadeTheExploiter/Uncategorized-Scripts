-- Original: (OWN PRODUCTION)

KryptonConfiguration = {
	DestroyHeightOffset = 10, -- Make it higher if your hats fall
	RespawnTime = 0.26,
	DontStartYet = true,
	ReturnOnDeath = false,
	Refit = false,
	SetCharacter = false,
	Animations = false,
	NoCollisions = false,
	AntiVoiding = false,
	SetSimulationRadius = true,
	DisableCharacterScripts = true,
	AccessoryFallbackDefaults = true,
	OverlayFakeCharacter = false,
	LimitHatsPerLimb = false,
	NoBodyNearby = false,
	PermanentDeath = false,
}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players["LocalPlayer"]

local Character = Player.Character

if Character.Name ~= Player.Name then
	return
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local ReanimateModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/Krypton/refs/heads/main/TestingRelease.luau"))()

local Music = Instance.new("Sound", Workspace.CurrentCamera)
Music.Looped = true
local Main = Library.Load({
	Title = " Krypton Animations - V1.1",
	Style = 1,
	SizeX = 277,
	SizeY = 300,
	Theme = "Dark",
})

local Tabs = {
	Home =  Main.New({
		Title = "Home"
	}),

	Reanimate =  Main.New({
		Title = "Reanimate"
	}),

	Animations =  Main.New({
		Title = "Animations"
	}),

	Config =  Main.New({
		Title = "Config"
	}),
}

Tabs['Home'].Button({
	Text = `Greetings, {Player.DisplayName}`,
	Callback = function()
	end
})

Tabs['Home'].Button({
	Text = "Made by @gelatekforever",
	Callback = function()
	end
})

Tabs['Home'].Button({
	Text = "https://discord.gg/ArpG4kDvW2",
	Callback = function()
	end
})

Tabs['Config'].Button({
	Text = "Reanimate Version: "..ReanimateModule.Version,
	Callback = function()
	end
})

Tabs['Config'].Button({
	Text = "Click To Download Songs",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/GelatekHub/refs/heads/main/src/packages/AudioPack.lua"))()
	end
})

Tabs['Config'].Toggle({
	Text = "Mute Songs",
	Callback = function(Value)
		Music.Volume = Value and 0 or 0.5
	end,
})

local function SettingIntoToggle(Text, SettingName, Default, Context)
	Tabs['Reanimate'].Toggle({
		Text = Text,
		Callback = function(Value)
			KryptonConfiguration[SettingName] = Value
		end,

		Enabled = Default,
		Menu = {
			Information = function(self)
				Main.Banner({
					Text = Context
				})
			end
		}
	})	
end

local function PlayAnim(ID, Path)
	ReanimateModule.AnimationPlayer.Start(ID)

	if getcustomasset and Path then
		Music.SoundId = getcustomasset(Path)
		Music:Play()
	end
end

local function AnimationIntoButton(Text, ID, Path)
	Tabs['Animations'].Button({
		Text = Text,
		Callback = function()
			PlayAnim(ID, Path)
		end
	})
end

Tabs['Animations'].Button({
	Text = "- Stop Animation -",
	Callback = function()
		ReanimateModule.AnimationPlayer.Stop()
		Music:Stop()
	end
})

Tabs['Animations'].TextField({
	Text = "Custom Anim:",
	Callback = function(ID)
		PlayAnim(ID)
	end
})

AnimationIntoButton("Freestylin'", 4432024917, "GelatekHub/Animations/Freestylin.mp3")
AnimationIntoButton("Floss", 4812941481, "GelatekHub/Animations/Floss.mp3")
AnimationIntoButton("Smooth Moves", 4900539662, "GelatekHub/Animations/Smooth Moves.mp3")
AnimationIntoButton("Aerostepping", 4776588732, "GelatekHub/Animations/Aerostepping.mp3")
AnimationIntoButton("Electro Swing", 3485013176, "GelatekHub/Animations/Electro Swing.mp3")
AnimationIntoButton("Minecraft Parrot", 4300228160, "GelatekHub/Animations/Parrot.mp3")
AnimationIntoButton("CaramellDansen", 6607554805, "GelatekHub/Animations/CaramellDansen.mp3")
AnimationIntoButton("Breakdown", 4558409610, "GelatekHub/Animations/Breakdown.mp3")
AnimationIntoButton("Orange Justice", 3262592866, "GelatekHub/Animations/Orange Justice.mp3")
AnimationIntoButton("Smug", 3450125501, "GelatekHub/Animations/Smug.mp3")
AnimationIntoButton("Crabby", 3643129020, "GelatekHub/Animations/Crabby.mp3")
AnimationIntoButton("Conga", 4572096542, "GelatekHub/Animations/Conga.mp3")
AnimationIntoButton("Dream Feet", 4300218011, "GelatekHub/Animations/Dream Feet.mp3")
AnimationIntoButton("Kazotsky Kick", 4846209506)
AnimationIntoButton("Radical", 4686555525)
AnimationIntoButton("Take The L", 4827299133, "GelatekHub/Animations/Take The L.mp3")
AnimationIntoButton("Laughing", 4846000379, "GelatekHub/Animations/Laughing.mp3")
AnimationIntoButton("Drip", 4959380041, "GelatekHub/Animations/Drip.mp3")
AnimationIntoButton("Pushups", 99504427539243)

Tabs['Reanimate'].Button({
	Text = "Start Reanimate",
	Callback = function()
		ReanimateModule.StartReanimate()
	end
})

Tabs['Reanimate'].Button({
	Text = "Stop Reanimate",
	Callback = function()
		ReanimateModule.AnimationPlayer.Stop()
		ReanimateModule.StopReanimate()
		Music:Stop()
	end
})

local Height; Height = Tabs['Reanimate'].TextField({
	Text = `Destroy Height Offset: {KryptonConfiguration.DestroyHeightOffset}`,
	Callback = function(ID)
		local ToNum = tonumber(typeof(ID)=="number" and ID or 10)

		KryptonConfiguration.DestroyHeightOffset = ToNum and ToNum or 10

		Height:SetText("Destroy Height Offset: "..ID)
	end
})

local Height; Height = Tabs['Reanimate'].TextField({
	Text = `RespawnTime: {KryptonConfiguration.RespawnTime}`,
	Callback = function(ID)
		local ToNum = tonumber(typeof(ID)=="number" and ID or 0.26)

		KryptonConfiguration.RespawnTime = ToNum and ToNum or 0.26

		Height:SetText("RespawnTime: "..ID)
	end
})

SettingIntoToggle("Permanent Death", "PermanentDeath", false, "Requires Replicatesignal, keeps you in a dead state without respawning.")
SettingIntoToggle("Refit", "Refit", false, "Automatically Respawns you if you lose ownership of hats, requires PermanentDeath")
SettingIntoToggle("Rig Animations", "Animations", false, "Plays default animations for the rig")
SettingIntoToggle("Overlay Rig", "OverlayFakeCharacter", false, "Overlays the rig by making it semi-transparent")
SettingIntoToggle("Hide Real Body", "NoBodyNearby", false, "Hides the real character by destroying it with use of FallenPartsDestroyHeight")
SettingIntoToggle("Disable Collisions", "NoCollisions", false, "Removes collisions from the rig")
SettingIntoToggle("Return On Void", "AntiVoiding", false, "Brings you back to spawn once you slip into the void.")
SettingIntoToggle("Return On Death ", "ReturnOnDeath", false, "Brings you back into the same place you were after stopping the reanimate")
