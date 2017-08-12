AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 0
SWEP.KillIconY = 480

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_fireaxe_large" ) end
SWEP.PrintName = "#TF_Weapon_FireAxe"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Pyro"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_FireAxe"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.PYRO ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_fireaxe_pyro/c_fireaxe_pyro.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_fireaxe_pyro/c_fireaxe_pyro.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_pyro_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "fa"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/cbar_miss1_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/axe_hit_flesh1.wav" ), Sound( "weapons/axe_hit_flesh2.wav" ), Sound( "weapons/axe_hit_flesh3.wav" ) }
	
end