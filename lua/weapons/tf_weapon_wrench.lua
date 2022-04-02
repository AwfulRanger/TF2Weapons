AddCSLuaFile()

SWEP.TF2Weapons_BuildTool = true

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 96
SWEP.KillIconY = 96

SWEP.IconOverride = "backpack/weapons/w_models/w_wrench_large"
if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( SWEP.IconOverride ) end
SWEP.PrintName = "#TF_Weapon_Wrench"
SWEP.Author = "AwfulRanger"
SWEP.Description = "#TF_Weapon_Wrench_Desc"
SWEP.Category = "Team Fortress 2 - Engineer"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Wrench"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.ENGINEER ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_wrench/c_wrench.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_wrench/c_wrench.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_engineer_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return {
		
		idle = "pdq_idle_tap",
		draw = "pdq_draw",
		swing = {
			
			"pdq_swing_a",
			"pdq_swing_b",
			
		},
		crit = "pdq_swing_c",
		
	}
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Ammo = "tf2weapons_metal"
SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/wrench_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/wrench_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/cbar_hitbod1.wav" ), Sound( "weapons/cbar_hitbod2.wav" ), Sound( "weapons/cbar_hitbod3.wav" ) }
	
	self.HitBuildingSuccessSound = { Sound( "weapons/wrench_hit_build_success1.wav" ), Sound( "weapons/wrench_hit_build_success2.wav" ) }
	self.HitBuildingFailSound = Sound( "weapons/wrench_hit_build_fail.wav" )
	
end

SWEP.BuildUpgradeBase = 25
SWEP.BuildRepairBase = 105
SWEP.BuildConstructRateBase = 2

SWEP.BuildUpgradeMult = 1
SWEP.BuildRepairMult = 1
SWEP.BuildConstructRateMult = 1

function SWEP:BuildUpgradeMax( base )
	
	if base == nil then
		
		base = 25
		if self.BuildUpgradeBase ~= nil then base = self.BuildUpgradeBase end
		
	end
	
	if self.BuildUpgradeMult ~= nil then base = base * self.BuildUpgradeMult end
	
	return base
	
end

function SWEP:BuildRepairMax( base )
	
	if base == nil then
		
		base = 105
		if self.BuildRepairBase ~= nil then base = self.BuildRepairBase end
		
	end
	
	if self.BuildRepairMult ~= nil then base = base * self.BuildRepairMult end
	
	return base
	
end

function SWEP:BuildConstructRate( base )
	
	if base == nil then
		
		base = 2
		if self.BuildConstructRateBase ~= nil then base = self.BuildConstructRateBase end
		
	end
	
	if self.BuildConstructRateMult ~= nil then base = base * self.BuildConstructRateMult end
	
	return base
	
end