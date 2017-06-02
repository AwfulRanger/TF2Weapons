AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIcon = Material( "hud/dneg_images_v3" )
SWEP.KillIconX = 0
SWEP.KillIconY = 736

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_pep_pistol/c_pep_pistol_large" ) end
SWEP.PrintName = "#TF_Weapon_PEP_Pistol"
SWEP.HUDName = "#TF_Weapon_PEP_Pistol"
SWEP.Author = "AwfulRanger"
SWEP.Description = "#TF_Weapon_PEP_Pistol_Desc"
SWEP.Category = "Team Fortress 2 - Scout"
SWEP.Level = 10
SWEP.Type = "#TF_Weapon_Pistol"
SWEP.Base = "tf_weapon_pistol"
SWEP.Classes = { [ TF2Weapons.Class.SCOUT ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_scout_arms.mdl" )
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