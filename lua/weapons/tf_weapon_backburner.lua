AddCSLuaFile()

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 256
SWEP.KillIconY = 448

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_backburner/c_backburner_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_Unique_Achievement_Flamethrower"
SWEP.Author = "AwfulRanger"
SWEP.Description = ""
SWEP.Category = "Team Fortress 2 - Pyro"
SWEP.Level = 10
SWEP.Type = "#TF_Weapon_Flamethrower"
SWEP.Base = "tf_weapon_flamethrower"
SWEP.Classes = { [ TF2Weapons.Class.PYRO ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_flamethrower/c_backburner.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_flamethrower/c_backburner.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_pyro_arms.mdl" )
SWEP.ModelAttachment = "models/weapons/c_models/c_backburner/c_backburner.mdl"
SWEP.HoldType = "crossbow"
function SWEP:GetAnimations()
	
	return "ft"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end

SWEP.Attributes = {
	
	[ "airblast cost increased" ] = { 2.5 },
	[ "mod flamethrower back crit" ] = { 1 },
	[ "crit mod disabled hidden" ] = { 0 },
	[ "extinguish restores health" ] = { 20 },
	
}
SWEP.AttributesOrder = {
	
	"mod flamethrower back crit",
	"extinguish restores health",
	"airblast cost increased",
	"crit mod disabled hidden",
	
}

function SWEP:SetVariables()
	
	self.ShootStartSound = Sound( "weapons/flame_thrower_start.wav" )
	self.ShootSound = Sound( "weapons/flame_thrower_loop.wav" )
	self.ShootSoundCrit = Sound( "weapons/flame_thrower_loop_crit.wav" )
	self.ShootEndSound = Sound( "weapons/flame_thrower_end.wav" )
	self.AirblastSound = Sound( "weapons/flame_thrower_airblast.wav" )
	self.AirblastRedirectSound = Sound( "weapons/flame_thrower_airblast_rocket_redirect.wav" )
	self.AirblastExtinguishSound = Sound( "player/flame_out.wav" )
	
end

SWEP.FlameParticleRed = "flamethrower"
SWEP.FlameParticleBlue = "flamethrower"
SWEP.WaterParticleRed = "flamethrower_underwater"
SWEP.WaterParticleBlue = "flamethrower_underwater"
SWEP.CritParticleRed = "flamethrower"
SWEP.CritParticleBlue = "flamethrower"
SWEP.AirblastParticleRed = "pyro_blast"
SWEP.AirblastParticleBlue = "pyro_blast"