AddCSLuaFile()

game.AddParticles( "particles/muzzle_flash.pcf" )

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 256

SWEP.IconOverride = "backpack/weapons/w_models/w_shotgun_large"
if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( SWEP.IconOverride ) end
SWEP.PrintName = "#TF_Weapon_Shotgun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Pyro"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Shotgun"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.PYRO ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_shotgun/c_shotgun.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_shotgun/c_shotgun.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_pyro_arms.mdl" )
SWEP.HoldType = "shotgun"
function SWEP:GetAnimations()
	
	return ""
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end
SWEP.MuzzleParticle = "muzzle_shotgun"

SWEP.SingleReload = true
SWEP.Attributes = {}

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
	
	self.ShootSound = Sound( "weapons/shotgun_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/shotgun_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end