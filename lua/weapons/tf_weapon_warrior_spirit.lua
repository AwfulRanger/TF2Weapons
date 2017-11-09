AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 256
SWEP.KillIconY = 832
SWEP.KillIconW = 128

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/workshop/weapons/c_models/c_bear_claw/c_bear_claw_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_WarriorsSpirit"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Heavy"
SWEP.Level = 10
SWEP.Type = "#TF_Weapon_Gloves"
SWEP.Base = "tf_weapon_fists"
SWEP.Classes = { [ TF2Weapons.Class.HEAVY ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_bear_claw/c_bear_claw.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_bear_claw/c_bear_claw.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_heavy_arms.mdl" )
SWEP.HoldType = "fist"
function SWEP:GetAnimations()
	
	return {
		
		idle = "f_idle",
		draw = "f_draw",
		left = "f_swing_left",
		right = "f_swing_right",
		crit = "f_swing_crit",
		
	}
	
end
function SWEP:GetInspect()
	
	return ""
	
end

SWEP.Attributes = {
	
	[ "provide on active" ] = { 1 },
	[ "dmg taken increased" ] = { 1.3 },
	[ "damage bonus" ] = { 1.3 },
	[ "heal on kill" ] = { 50 },
	
}
SWEP.AttributesOrder = {
	
	"provide on active",
	"damage bonus",
	"heal on kill",
	"dmg taken increased",
	
}

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/fist_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/fist_hit_world1.wav" ), Sound( "weapons/fist_hit_world2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
end