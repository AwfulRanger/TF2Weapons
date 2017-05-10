AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 0

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_bat_large" ) end
SWEP.PrintName = "Bat"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Scout"
SWEP.Level = 1
SWEP.Type = "Bat"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.SCOUT ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_bat.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_bat.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_scout_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "b"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 35
SWEP.Primary.Delay = 0.5

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/cbar_miss1_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = Sound( "weapons/bat_hit.wav" )
	
end