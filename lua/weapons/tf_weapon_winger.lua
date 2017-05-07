AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 384
SWEP.KillIconY = 320

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_winger_pistol/c_winger_pistol_large" ) end
SWEP.PrintName = "Winger"
SWEP.HUDName = "The Winger"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 15
SWEP.Type = "Pistol"
SWEP.Base = "tf_weapon_pistol_scout"
SWEP.Classes = { [ TF2Weapons.Class.SCOUT ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_winger_pistol/c_winger_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_winger_pistol/c_winger_pistol.mdl" )
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
	
	[ "damage bonus" ] = { 1.15 },
	[ "clip size penalty" ] = { 0.4 },
	[ "increased jump height from weapon" ] = { 1.25 },
	
}
SWEP.AttributesOrder = {
	
	"damage bonus",
	"increased jump height from weapon",
	"clip size penalty",
	
}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/pistol_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/pistol_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end