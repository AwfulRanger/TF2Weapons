AddCSLuaFile()

game.AddParticles( "particles/muzzle_flash.pcf" )

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIcon = Material( "hud/dneg_images_v3" )
SWEP.KillIconX = 0
SWEP.KillIconY = 736

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/workshop/weapons/c_models/c_pep_pistol/c_pep_pistol_large" ) end
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
	[ "heal on hit for rapidfire" ] = { 7 },
	[ "fire rate bonus" ] = { 0.85 },
	[ "clip size penalty" ] = { 0.75 },
	
}
SWEP.AttributesOrder = {
	
	"provide on active",
	"heal on hit for rapidfire",
	"fire rate bonus",
	"clip size penalty",
	
}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/doom_scout_pistol.wav" )
	self.ShootSoundCrit = Sound( "weapons/doom_scout_pistol_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end