AddCSLuaFile()

game.AddParticles( "particles/muzzle_flash.pcf" )

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 0
SWEP.KillIconY = 96

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_csgo_awp/c_csgo_awp_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_CSGO_AWP"
SWEP.Author = "AwfulRanger"
SWEP.Description = "#TF_CSGO_AWP_Desc"
SWEP.Category = "Team Fortress 2 - Sniper"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_SniperRifle"
SWEP.Base = "tf_weapon_sniperrifle"
SWEP.Classes = { [ TF2Weapons.Class.SNIPER ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_csgo_awp/c_csgo_awp.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_csgo_awp/c_csgo_awp.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_sniper_arms.mdl" )
SWEP.HoldType = "crossbow"
SWEP.HoldTypeScoped = "ar2"
function SWEP:GetAnimations()
	
	return ""
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end
SWEP.MuzzleParticle = "muzzle_sniperrifle"

SWEP.Attributes = {}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/csgo_awp_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/csgo_awp_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end