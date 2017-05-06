AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 801

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/gunslinger_large" ) end
SWEP.PrintName = "Gunslinger"
SWEP.HUDName = "The Gunslinger"
SWEP.Author = "AwfulRanger"
SWEP.Description = ""
SWEP.Category = "Team Fortress 2"
SWEP.Level = 15
SWEP.Type = "Robot Arm"
SWEP.Base = "tf_weapon_wrench"
SWEP.Classes = { TF2Weapons.Class.ENGINEER }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_engineer_gunslinger.mdl" )
SWEP.WorldModel = ""
SWEP.HandModel = Model( "models/weapons/c_models/c_engineer_gunslinger.mdl" )
SWEP.HoldType = "fist"
function SWEP:GetAnimations()
	
	return {
		
		idle = "gun_idle",
		draw = "gun_draw",
		swing = "gun_swing_a",
		crit = "gun_swing_b",
		
	}
	
end
function SWEP:GetInspect()
	
	return "item2"
	
end

SWEP.Attributes = {
	
	//[ "gunslinger punch combo" ] = { 1 },
	//[ "mod wrench builds minisentry" ] = { 1 },
	[ "max health additive bonus" ] = { 25 },
	//[ "engineer sentry build rate multiplier" ] = { 2.5 },
	[ "crit mod disabled" ] = { 0 },
	
}
SWEP.AttributesOrder = {
	
	"max health additive bonus",
	//"engineer sentry build rate multiplier",
	//"gunslinger punch combo",
	"crit mod disabled",
	//"mod wrench builds minisentry",
	
}

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/cbar_miss1_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
	self.HitBuildingSuccessSound = { Sound( "weapons/wrench_hit_build_success1.wav" ), Sound( "weapons/wrench_hit_build_success2.wav" ) }
	self.HitBuildingFailSound = Sound( "weapons/wrench_hit_build_fail.wav" )
	
end