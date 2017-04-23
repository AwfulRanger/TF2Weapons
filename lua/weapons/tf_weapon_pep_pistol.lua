AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 32

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_pep_pistol/c_pep_pistol_large" ) end
SWEP.PrintName = "Pretty Boy's Pocket Pistol"
SWEP.HUDName = "Pretty Boy's Pocket Pistol"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 10
SWEP.Type = "Pistol"
SWEP.Base = "tf_weapon_pistol"
SWEP.Classes = { TF2Weapons.Class.SCOUT }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl"
SWEP.HandModel = "models/weapons/c_models/c_scout_arms.mdl"
SWEP.HoldType = "pistol"
function SWEP:GetAnimations()
	
	return "p"
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end
SWEP.MuzzleParticle = "muzzle_pistol"

SWEP.Attributes = {
	
	[ "provide on active" ] = { 1 },
	[ "heal on hit for rapidfire" ] = { 5 },
	[ "cancel falling damage" ] = { 1 },
	[ "fire rate penalty" ] = { 1.25 },
	[ "dmg taken increased" ] = { 1.2 },
	
}
SWEP.AttributesOrder = {
	
	"provide on active",
	"heal on hit for rapidfire",
	"cancel falling damage",
	"fire rate penalty",
	"dmg taken increased",
	
}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/pistol_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/pistol_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end