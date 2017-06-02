AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 192
SWEP.KillIconY = 704

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_battleaxe/c_battleaxe_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_Unique_BattleAxe"
SWEP.Author = "AwfulRanger"
--SWEP.Description = "#TF_Unique_BattleAxe_desc"
SWEP.Category = "Team Fortress 2 - Demoman"
SWEP.Level = 5
SWEP.Type = "#TF_Weapon_Axe"
SWEP.Base = "tf_weapon_sword"
SWEP.Classes = { [ TF2Weapons.Class.DEMOMAN ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_battleaxe/c_battleaxe.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_battleaxe/c_battleaxe.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_demo_arms.mdl" )
SWEP.HoldType = "melee2"
function SWEP:GetAnimations()
	
	return "cm"
	
end
function SWEP:GetInspect()
	
	return "claymore"
	
end

SWEP.Attributes = {
	
	[ "is_a_sword" ] = { 72 },
	[ "provide on active" ] = { 1 },
	[ "damage bonus" ] = { 1.2 },
	[ "move speed penalty" ] = { 0.85 },
	
}
SWEP.AttributesOrder = {
	
	"is_a_sword",
	"provide on active",
	"damage bonus",
	"move speed penalty",
	
}

function SWEP:SetVariables()
	
	self.SwingSound = { Sound( "weapons/demo_sword_swing1.wav" ), Sound( "weapons/demo_sword_swing2.wav" ), Sound( "weapons/demo_sword_swing3.wav" ) }
	self.SwingSoundCrit = Sound( "weapons/demo_sword_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/demo_sword_hit_world1.wav" ), Sound( "weapons/demo_sword_hit_world2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/blade_slice_2.wav" ), Sound( "weapons/blade_slice_3.wav" ), Sound( "weapons/blade_slice_4.wav" ) }
	
end