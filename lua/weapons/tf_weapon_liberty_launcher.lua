AddCSLuaFile()

if CLIENT then
	
	game.AddParticles( "particles/rockettrail.pcf" )
	game.AddParticles( "particles/rocketbackblast.pcf" )
	game.AddParticles( "particles/explosion.pcf" )
	
end

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 384
SWEP.KillIconY = 608

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_liberty_launcher/c_liberty_launcher_large" ) end
SWEP.ProperName = true
SWEP.PrintName = "#TF_LibertyLauncher"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Soldier"
SWEP.Level = 25
SWEP.Type = "#TF_Weapon_RocketLauncher"
SWEP.Base = "tf_weapon_rocketlauncher"
SWEP.Classes = { [ TF2Weapons.Class.SOLDIER ] = true }
SWEP.Quality = TF2Weapons.Quality.UNIQUE

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_liberty_launcher/c_liberty_launcher.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_liberty_launcher/c_liberty_launcher.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_soldier_arms.mdl" )
SWEP.HoldType = "rpg"
function SWEP:GetAnimations()
	
	return {
		
		draw = "dh_draw",
		idle = "dh_idle",
		fire = "dh_fire",
		reload_start = "dh_reload_start",
		reload_loop = "dh_reload_loop",
		reload_end = "dh_reload_finish",
		
	}
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end

SWEP.Attributes = {
	
	[ "Projectile speed increased" ] = { 1.4 },
	[ "damage penalty" ] = { 0.75 },
	[ "clip size bonus" ] = { 1.25 },
	[ "rocket jump damage reduction" ] = { 0.75 },
	
}
SWEP.AttributesOrder = {
	
	"clip size bonus",
	"Projectile speed increased",
	"rocket jump damage reduction",
	"damage penalty",
	
}

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/rocket_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/rocket_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	self.RocketSound = { Sound( "weapons/explode1.wav" ), Sound( "weapons/explode2.wav" ), Sound( "weapons/explode3.wav" ) }
	
end

function SWEP:GetRocketModel()
	
	return "models/weapons/w_models/w_rocket.mdl"
	
end
SWEP.RocketParticles = {
	
	red_trail = "rockettrail",
	blue_trail = "rockettrail",
	red_crittrail = "critical_rocket_red",
	blue_crittrail = "critical_rocket_blue",
	red_explode = "explosioncore_wall",
	blue_explode = "explosioncore_wall",
	red_critexplode = "explosioncore_wall",
	blue_critexplode = "explosioncore_wall",
	
}

SWEP.BackBlastParticle = "rocketbackblast"

SWEP.RocketSkinRED = 0
SWEP.RocketSkinBLU = 0