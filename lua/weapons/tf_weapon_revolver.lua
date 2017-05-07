AddCSLuaFile()

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 96
SWEP.KillIconY = 32

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_revolver_large" ) end
SWEP.PrintName = "Revolver"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Revolver"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.SPY ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_revolver/c_revolver.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_revolver/c_revolver.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_spy_arms.mdl" )
SWEP.HoldType = "revolver"
function SWEP:GetAnimations()
	
	return ""
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end
SWEP.MuzzleParticle = "muzzle_revolver"

SWEP.SingleReload = false
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_pistol"
SWEP.Primary.Damage = 40
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.025
SWEP.Primary.SpreadRecovery = 1.25
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.5

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/revolver_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/revolver_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end