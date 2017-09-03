AddCSLuaFile()

game.AddParticles( "particles/muzzle_flash.pcf" )

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 32

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_pistol_large" ) end
SWEP.PrintName = "#TF_Weapon_Pistol"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Scout"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Pistol"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.SCOUT ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_pistol/c_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_pistol/c_pistol.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_scout_arms.mdl" )
SWEP.HoldType = "pistol"
function SWEP:GetAnimations()
	
	return "p"
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end
SWEP.MuzzleParticle = "muzzle_pistol"

SWEP.SingleReload = false
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 48
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_pistol"
SWEP.Primary.Damage = 15
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.025
SWEP.Primary.SpreadRecovery = 1.25
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.15

SWEP.CritStream = true

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/pistol_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/pistol_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end