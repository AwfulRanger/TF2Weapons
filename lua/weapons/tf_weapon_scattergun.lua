AddCSLuaFile()

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 96
SWEP.KillIconY = 192

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_scattergun_large" ) end
SWEP.PrintName = "Scattergun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Scattergun"
SWEP.Base = "tf2_base"
SWEP.Classes = { TF2Weapons.Class.SCOUT }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_scattergun.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_scattergun.mdl"
SWEP.HandModel = "models/weapons/c_models/c_scout_arms.mdl"
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
SWEP.Primary.Ammo = "tf2_shotgun"
SWEP.Primary.Damage = 6
SWEP.Primary.Shots = 10
SWEP.Primary.Spread = 0.03
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.625

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/scatter_gun_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/scatter_gun_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end