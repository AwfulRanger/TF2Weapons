AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 192
SWEP.KillIconY = 864

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_claymore/c_claymore_large" ) end
SWEP.PrintName = "#TF_Weapon_Sword"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Demoman"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Sword"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.DEMOMAN ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_claymore/c_claymore.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_claymore/c_claymore.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_demo_arms.mdl" )
SWEP.HoldType = "melee2"
function SWEP:GetAnimations()
	
	return "cm"
	
end
function SWEP:GetInspect()
	
	return "claymore"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = { Sound( "weapons/demo_sword_swing1.wav" ), Sound( "weapons/demo_sword_swing2.wav" ), Sound( "weapons/demo_sword_swing3.wav" ) }
	self.SwingSoundCrit = Sound( "weapons/demo_sword_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/demo_sword_hit_world1.wav" ), Sound( "weapons/demo_sword_hit_world2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/blade_slice_2.wav" ), Sound( "weapons/blade_slice_3.wav" ), Sound( "weapons/blade_slice_4.wav" ) }
	
end