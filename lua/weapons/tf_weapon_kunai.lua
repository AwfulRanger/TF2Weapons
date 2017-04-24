AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 388
SWEP.KillIconY = 64

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_shogun_kunai/c_shogun_kunai_large" ) end
SWEP.PrintName = "Conniver's Kunai"
SWEP.Author = "AwfulRanger"
SWEP.Description = [[Start off with low health
Kill somebody with this knife
Steal all of their health]]
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Kunai"
SWEP.Base = "tf_weapon_knife"
SWEP.Classes = { TF2Weapons.Class.SPY }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_shogun_kunai/c_shogun_kunai.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_shogun_kunai/c_shogun_kunai.mdl"
SWEP.HandModel = "models/weapons/c_models/c_spy_arms.mdl"
SWEP.HoldType = "knife"
function SWEP:GetAnimations()
	
	return {
		
		idle = "eternal_idle",
		draw = "eternal_draw",
		swing = {
			
			"eternal_stab_a",
			"eternal_stab_b",
			"eternal_stab_c",
			
		},
		crit = {
			
			"eternal_stab_a",
			"eternal_stab_b",
			"eternal_stab_c",
			
		},
		backstab = "eternal_backstab",
		backstab_up = "eternal_backstab_up",
		backstab_idle = "eternal_backstab_idle",
		backstab_down = "eternal_backstab_down",
		
	}
	
end
function SWEP:GetInspect()
	
	return "item2"
	
end

SWEP.Attributes = {
	
	[ "sanguisuge" ] = { 1 },
	[ "max health additive penalty" ] = { -55 },
	
}
SWEP.AttributesOrder = {
	
	"sanguisuge",
	"max health additive penalty",
	
}

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/knife_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/knife_swing_crit.wav" )
	self.HitWorldSound = Sound( "weapons/blade_hitworld.wav" )
	self.HitFleshSound = { Sound( "weapons/blade_hit1.wav" ), Sound( "weapons/blade_hit2.wav" ), Sound( "weapons/blade_hit3.wav" ), Sound( "weapons/blade_hit4.wav" ) }
	
end