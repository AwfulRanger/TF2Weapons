AddCSLuaFile()

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 192
SWEP.KillIconY = 416
SWEP.KillIconW = 64

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/v_models/v_fist_heavy_large" ) end
SWEP.PrintName = "Fists"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Fists"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.HEAVY ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_heavy_arms.mdl" )
SWEP.WorldModel = ""
SWEP.HandModel = Model( "models/weapons/c_models/c_heavy_arms.mdl" )
SWEP.HoldType = "fist"
function SWEP:GetAnimations()
	
	return {
		
		idle = "f_idle",
		draw = "f_draw",
		left = "f_swing_left",
		right = "f_swing_right",
		crit = "f_swing_crit",
		
	}
	
end
function SWEP:GetInspect()
	
	return ""
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/fist_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/fist_hit_world1.wav" ), Sound( "weapons/fist_hit_world2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
end

SWEP.Secondary.Automatic = true

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	local anim = "left"
	if self:DoCrit() == true then anim = "crit" end
	
	self:DoPrimaryAttack( anim )
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:SecondaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	local anim = "right"
	if self:DoCrit() == true then anim = "crit" end
	
	self:DoPrimaryAttack( anim )
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end