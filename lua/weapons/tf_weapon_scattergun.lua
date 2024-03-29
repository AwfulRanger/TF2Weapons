AddCSLuaFile()

game.AddParticles( "particles/muzzle_flash.pcf" )

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 96
SWEP.KillIconY = 192

SWEP.IconOverride = "backpack/weapons/c_models/c_scattergun_large"
if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( SWEP.IconOverride ) end
SWEP.PrintName = "#TF_Weapon_Scattergun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Scout"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Scattergun"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.SCOUT ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_scattergun.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_scattergun.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_scout_arms.mdl" )
SWEP.HoldType = "shotgun"
function SWEP:GetAnimations()
	
	return "sg"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end
SWEP.MuzzleParticle = "muzzle_scattergun"

SWEP.SingleReload = true
SWEP.Attributes = {}

SWEP.DamageRampup = 1.75

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 38
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_shotgun"
SWEP.Primary.Damage = 6
SWEP.Primary.Shots = 10
SWEP.Primary.Spread = 0.03
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.625
SWEP.Primary.Recoil = { Angle( -1, 0, 0 ), Angle( -3, 0, 0 ) }

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/scatter_gun_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/scatter_gun_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end