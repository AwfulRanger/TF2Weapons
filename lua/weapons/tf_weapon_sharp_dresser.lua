AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIcon = Material( "hud/dneg_images_v3" )
SWEP.KillIconX = 0
SWEP.KillIconY = 288

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_acr_hookblade/c_acr_hookblade_large" ) end
SWEP.PrintName = "Sharp Dresser"
SWEP.HUDName = "The Sharp Dresser"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Spy"
SWEP.Level = 1
SWEP.Type = "Knife"
SWEP.Base = "tf_weapon_knife"
SWEP.Classes = { [ TF2Weapons.Class.SPY ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_acr_hookblade/c_acr_hookblade.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_acr_hookblade/c_acr_hookblade.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_spy_arms.mdl" )
SWEP.HoldType = "knife"
function SWEP:GetAnimations()
	
	return {
		
		idle = "acr_idle",
		draw = "acr_draw",
		swing = {
			
			"acr_stab_a",
			"acr_stab_b",
			"acr_stab_c",
			
		},
		crit = {
			
			"acr_stab_a",
			"acr_stab_b",
			"acr_stab_c",
			
		},
		backstab = "acr_backstab",
		backstab_up = "acr_backstab_up",
		backstab_idle = "acr_backstab_idle",
		backstab_down = "acr_backstab_down",
		
	}
	
end
function SWEP:GetInspect()
	
	return {
		
		inspect_start = "item1_inspect_start",
		inspect_idle = {
			
			"item1_inspect_idle_a",
			"item1_inspect_idle_b",
			
		},
		inspect_end = "item1_inspect_end",
		
	}
	
end

SWEP.Attributes = {}

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/knife_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/knife_swing_crit.wav" )
	self.HitWorldSound = Sound( "weapons/blade_hitworld.wav" )
	self.HitFleshSound = { Sound( "weapons/blade_hit1.wav" ), Sound( "weapons/blade_hit2.wav" ), Sound( "weapons/blade_hit3.wav" ), Sound( "weapons/blade_hit4.wav" ) }
	
end