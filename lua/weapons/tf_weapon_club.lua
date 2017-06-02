AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 160

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_machete_large" ) end
SWEP.PrintName = "#TF_Weapon_Club"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Sniper"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Club"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.SNIPER ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_machete/c_machete.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_machete/c_machete.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_sniper_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "m"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/machete_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/machete_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
end