AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 128

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_smg_large" ) end
SWEP.PrintName = "#TF_Weapon_SMG"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Sniper"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_SMG"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.SNIPER ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_smg/c_smg.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_smg/c_smg.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_sniper_arms.mdl" )
SWEP.HoldType = "smg"
function SWEP:GetAnimations()
	
	return "smg"
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end
SWEP.MuzzleParticle = "muzzle_smg"

SWEP.SingleReload = false
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 25
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_pistol"
SWEP.Primary.Damage = 8
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.025
SWEP.Primary.SpreadRecovery = 1.25
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.1

SWEP.CritStream = true

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/smg_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/smg_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end