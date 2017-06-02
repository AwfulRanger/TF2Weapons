AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 256
SWEP.KillIconY = 864
SWEP.KillIconW = 64

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/workshop/weapons/c_models/c_jag/c_jag_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_Jag"
SWEP.Author = "AwfulRanger"
SWEP.Description = ""
SWEP.Category = "Team Fortress 2 - Engineer"
SWEP.Level = 15
SWEP.Type = "#TF_Weapon_Wrench"
SWEP.Base = "tf_weapon_wrench"
SWEP.Classes = { [ TF2Weapons.Class.ENGINEER ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_jag/c_jag.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_jag/c_jag.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_engineer_arms.mdl" )
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

SWEP.Attributes = {
	
	[ "Construction rate increased" ] = { 1.3 },
	[ "fire rate bonus" ] = { 0.85 },
	[ "Repair rate decreased" ] = { 0.8 },
	[ "damage penalty" ] = { 0.75 },
	[ "dmg penalty vs buildings" ] = { 0.67 },
	
}
SWEP.AttributesOrder = {
	
	"Construction rate increased",
	"fire rate bonus",
	"Repair rate decreased",
	"damage penalty",
	"dmg penalty vs buildings",
	
}

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/wrench_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/wrench_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
	self.HitBuildingSuccessSound = { Sound( "weapons/wrench_hit_build_success1.wav" ), Sound( "weapons/wrench_hit_build_success2.wav" ) }
	self.HitBuildingFailSound = Sound( "weapons/wrench_hit_build_fail.wav" )
	
end