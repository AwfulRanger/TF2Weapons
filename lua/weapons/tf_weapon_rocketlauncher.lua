AddCSLuaFile()

if CLIENT then
	
	game.AddParticles( "particles/rockettrail.pcf" )
	game.AddParticles( "particles/rocketbackblast.pcf" )
	game.AddParticles( "particles/explosion.pcf" )
	
end

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 224

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_rocketlauncher_large" ) end
SWEP.PrintName = "Rocket Launcher"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Rocket Launcher"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { TF2Weapons.Class.SOLDIER }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_rocketlauncher/c_rocketlauncher.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_rocketlauncher/c_rocketlauncher.mdl"
SWEP.HandModel = "models/weapons/c_models/c_soldier_arms.mdl"
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

SWEP.SingleReload = true
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_rocket"
SWEP.Primary.Damage = 90
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.005
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.8

SWEP.CritChance = 1

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
SWEP.RocketSpeed = 1100
SWEP.RocketRadius = 146

SWEP.BackBlastParticle = "rocketbackblast"

function SWEP:Initialize()
	
	self:DoInitialize()
	
	self:PrecacheParticles( self.RocketParticles )
	self:PrecacheParticles( self.BackBlastParticle )
	
end

SWEP.RocketSkinRED = 0
SWEP.RocketSkinBLU = 0

function SWEP:SetProjectileModel( rocket, model, num )
	
	if model == nil then return end
	local _model
	
	if istable( model ) == true then
		
		if num == nil then num = math.random( #model ) end
		_model = model[ num ]
		
	else
		
		_model = model
		
	end
	
	local skin = self.RocketSkinRED
	if self:GetTeam() == true then skin = self.RocketSkinBLU end
	
	rocket:SetRocketSkin( skin )
	rocket:SetRocketModel( _model )
	return _model
	
end

function SWEP:GetProjectileParticles()
	
	local pp = self.RocketParticles
	
	local trail
	local explode
	
	if self:GetTeam() != true then
		
		if self:ShouldCrit() != true then
			
			trail = pp.red_trail
			explode = pp.red_explode
			
		else
			
			trail = pp.red_crittrail
			explode = pp.red_critexplode
			
		end
		
	else
		
		if self:ShouldCrit() != true then
			
			trail = pp.blue_trail
			explode = pp.blue_explode
			
		else
			
			trail = pp.blue_crittrail
			explode = pp.blue_critexplode
			
		end
		
	end
	
	return {
		
		trail = trail,
		explode = explode,
		
	}
	
end

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	if SERVER then
		
		for i = 1, self.Primary.Shots do
			
			local rocket = ents.Create( "tf_projectile_rocket" )
			if IsValid( rocket ) == true then
				
				local tracefilter = function( ent ) if ent == rocket or ent == self:GetOwner() or ent:GetClass() == rocket:GetClass() then return false end return true end
				
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
				local starttrace = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector():Angle():Up() * -2 ) + ( self:GetOwner():GetAimVector():Angle():Right() * 8 ) + ( self:GetOwner():GetAimVector() * 32 ), filter = tracefilter } )
				local hittrace = util.TraceLine( { start = starttrace.HitPos, endpos = self:GetOwner():GetShootPos() + ( ( self:GetOwner():GetAimVector():Angle() + Angle( math.random( -90, 90 ) * self.Primary.Spread, math.random( -90, 90 ) * self.Primary.Spread, 0 ) ):Forward() * 32768 ), filter = tracefilter } )
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
				
				rocket:SetOwner( self:GetOwner() )
				rocket:SetPos( starttrace.HitPos )
				rocket:SetAngles( ( hittrace.HitPos - starttrace.HitPos ):Angle() )
				rocket:SetRocketBLU( self:GetTeam() )
				self:SetProjectileModel( rocket, self:GetRocketModel() )
				rocket:SetRocketParticles( self:GetProjectileParticles() )
				rocket:SetRocketAngles( ( hittrace.HitPos - starttrace.HitPos ):Angle() )
				rocket:SetRocketDamage( self.Primary.Damage )
				rocket:SetRocketCrit( self:DoCrit() )
				rocket:SetRocketCritMultiplier( self.CritMultiplier )
				rocket:SetRocketSpeed( self.RocketSpeed )
				rocket:SetRocketRadius( self.RocketRadius )
				rocket.ExplodeSound = self.RocketSound
				rocket:Spawn()
				
				local rockettrace = util.TraceLine( { start = starttrace.HitPos, endpos = rocket:GetPos() + ( rocket:GetAngles():Forward() * 32 ), filter = tracefilter } )
				
				if starttrace.Hit == true or rockettrace.Hit == true then rocket:Explode( true ) end
				
			end
			
		end
		
	end
	
	self:AddParticle( self.BackBlastParticle, "backblast" )
	
	self:DoPrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end