AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 384
SWEP.KillIconY = 736

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_scimitar/c_scimitar_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_Shahanshah"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Sniper"
SWEP.Level = 5
SWEP.Type = "#TF_Weapon_Club"
SWEP.Base = "tf_weapon_club"
SWEP.Classes = { [ TF2Weapons.Class.SNIPER ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_scimitar/c_scimitar.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_scimitar/c_scimitar.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_sniper_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "m"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {
	
	[ "dmg bonus while half dead" ] = { 1.25 },
	[ "dmg penalty while half alive" ] = { 0.75 },
	
}
SWEP.AttributesOrder = {
	
	"dmg bonus while half dead",
	"dmg penalty while half alive",
	
}

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/machete_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/machete_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
end