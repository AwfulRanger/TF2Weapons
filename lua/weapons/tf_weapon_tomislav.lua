AddCSLuaFile()

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.BIGCIRCLE
SWEP.KillIconX = 384
SWEP.KillIconY = 352

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_tomislav/c_tomislav_large" ) end
SWEP.PrintName = "Tomislav"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 5
SWEP.Type = "Minigun"
SWEP.Base = "tf_weapon_minigun"
SWEP.Classes = { TF2Weapons.Class.HEAVY }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_tomislav/c_tomislav.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_tomislav/c_tomislav.mdl"
SWEP.HandModel = "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.HoldType = "crossbow"
SWEP.HoldTypeRevved = "ar2"
function SWEP:GetAnimations()
	
	return "m"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end
SWEP.MuzzleParticle = "muzzle_minigun_constant"
SWEP.EndMuzzleParticle = "muzzle_minigun"

SWEP.Attributes = {
	
	[ "minigun spinup time decreased" ] = { 0.8 },
	[ "minigun no spin sounds" ] = { 1 },
	[ "fire rate penalty" ] = { 1.2 },
	[ "weapon spread bonus" ] = { 0.8 },
	
}
SWEP.AttributesOrder = {
	
	"minigun spinup time decreased",
	"weapon spread bonus",
	"minigun no spin sounds",
	"fire rate penalty",
	
}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/tomislav_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/tomislav_shoot_crit.wav" )
	self.ShootSoundEnd = Sound( "weapons/tomislav_wind_down.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	self.SpoolUpSound = Sound( "weapons/tomislav_wind_up.wav" )
	self.SpoolIdleSound = nil
	self.SpoolDownSound = nil
	
end