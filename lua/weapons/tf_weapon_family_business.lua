AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 384
SWEP.KillIconY = 576

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_russian_riot/c_russian_riot_large" ) end
SWEP.PrintName = "Family Business"
SWEP.HUDName = "The Family Business"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 10
SWEP.Type = "Shotgun"
SWEP.Base = "tf_weapon_shotgun_hwg"
SWEP.Classes = { TF2Weapons.Class.HEAVY }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_heavy_arms.mdl" )
SWEP.HoldType = "shotgun"
function SWEP:GetAnimations()
	
	return ""
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end
SWEP.MuzzleParticle = "muzzle_shotgun"

SWEP.Attributes = {
	
	[ "damage penalty" ] = { 0.85 },
	[ "clip size bonus" ] = { 1.33 },
	[ "fire rate bonus" ] = { 0.85 },
	
}
SWEP.AttributesOrder = {
	
	"clip size bonus",
	"fire rate bonus",
	"damage penalty",
	
}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/shotgun_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/shotgun_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end