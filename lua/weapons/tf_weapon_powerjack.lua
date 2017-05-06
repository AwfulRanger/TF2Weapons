AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 0
SWEP.KillIconY = 928

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_powerjack/c_powerjack_large" ) end
SWEP.PrintName = "Powerjack"
SWEP.HUDName = "The Powerjack"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 5
SWEP.Type = "Sledgehammer"
SWEP.Base = "tf_weapon_fireaxe"
SWEP.Classes = { TF2Weapons.Class.PYRO }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_powerjack/c_powerjack.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_powerjack/c_powerjack.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_pyro_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "fa"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {
	
	[ "heal on kill" ] = { 25 },
	[ "move speed bonus" ] = { 1.15 },
	[ "dmg taken increased" ] = { 1.2 },
	[ "provide on active" ] = { 1 },
	
}
SWEP.AttributesOrder = {
	
	"provide on active",
	"move speed bonus",
	"heal on kill",
	"dmg taken increased",
	
}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/cbar_miss1_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/axe_hit_flesh1.wav" ), Sound( "weapons/axe_hit_flesh2.wav" ), Sound( "weapons/axe_hit_flesh3.wav" ) }
	
end