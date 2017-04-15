AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 96
SWEP.KillIconY = 96

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_wrench_large" ) end
SWEP.PrintName = "Wrench"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Wrench"
SWEP.Base = "tf2_base_melee"
SWEP.Classes = { TF2Weapons.Class.ENGINEER }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_wrench/c_wrench.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_wrench/c_wrench.mdl"
SWEP.HandModel = "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return {
		
		idle = "pdq_idle_tap",
		draw = "pdq_draw",
		swing = {
			
			"pdq_swing_a",
			"pdq_swing_b",
			
		},
		crit = "pdq_swing_c",
		
	}
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/wrench_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/wrench_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
end