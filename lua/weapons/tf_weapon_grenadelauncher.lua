AddCSLuaFile()

if SERVER then
	
	util.AddNetworkString( "tf2weapons_grenadelauncher_spinreset" )
	
else
	
	game.AddParticles( "particles/explosion.pcf" )
	game.AddParticles( "particles/stickybomb.pcf" )
	
end

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 288

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_grenadelauncher_large" ) end
SWEP.PrintName = "Grenade Launcher"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Grenade Launcher"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.DEMOMAN ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_grenadelauncher/c_grenadelauncher.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_grenadelauncher/c_grenadelauncher.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_demo_arms.mdl" )
SWEP.HoldType = "shotgun"
function SWEP:GetAnimations()
	
	return "g"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end

SWEP.SingleReload = true
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_grenade"
SWEP.Primary.ImpactDamage = 100
SWEP.Primary.Damage = 60
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.005
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 5
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.6

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/grenade_launcher_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/grenade_launcher_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end
SWEP.MuzzleParticle = "muzzle_grenadelauncher"

function SWEP:GetGrenadeModel()
	
	return "models/weapons/w_models/w_grenade_grenadelauncher.mdl"
	
end
SWEP.GrenadeParticles = {
	
	red_trail = "pipebombtrail_red",
	blue_trail = "pipebombtrail_blue",
	red_crittrail = "critical_grenade_red",
	blue_crittrail = "critical_grenade_blue",
	red_explode = "explosioncore_midair",
	blue_explode = "explosioncore_midair",
	red_critexplode = "explosioncore_midair",
	blue_critexplode = "explosioncore_midair",
	
}
SWEP.GrenadeRadius = 146
SWEP.GrenadeTime = 2.3
SWEP.GrenadeSpeed = 1200

SWEP.GrenadeClass = "tf_projectile_grenade"

function SWEP:Initialize()
	
	self:DoInitialize()
	
	if CLIENT then self:AddKillIcon( self.KillIcon, self.KillIconColor, self.KillIconX, self.KillIconY, self.KillIconW, self.KillIconH, self.GrenadeClass ) end
	
	self:PrecacheParticles( self.GrenadeParticles )
	
end

SWEP.GrenadeSkinRED = 0
SWEP.GrenadeSkinBLU = 1

function SWEP:SetProjectileModel( grenade, model, num )
	
	if model == nil then return end
	local _model
	
	if istable( model ) == true then
		
		if num == nil then num = math.random( #model ) end
		_model = model[ num ]
		
	else
		
		_model = model
		
	end
	
	local skin = self.GrenadeSkinRED
	if self:GetTeam() == true then skin = self.GrenadeSkinBLU end
	
	grenade:SetSkin( skin )
	grenade:SetModel( _model )
	return _model
	
end

function SWEP:GetProjectileParticles( crit )
	
	local pp = self.GrenadeParticles
	
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

--[[
SWEP.SpinSpeed = 0.5
SWEP.SpinAngle = 0
SWEP.SpinAngleNext = 0

function SWEP:Spin()
	
	
	
end
]]--

function SWEP:AttributesMod( attributes, attributeclass )
	
	if self.Primary != nil and self.Primary.ImpactDamage != nil and attributeclass[ "mult_dmg" ] != nil and attributeclass[ "mult_dmg" ][ 1 ] != nil then self.Primary.ImpactDamage = self.Primary.ImpactDamage * attributeclass[ "mult_dmg" ][ 1 ] end
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:SetTFLastOwner( self:GetOwner() )
	
	self:CheckHands()
	
	self:DoReload()
	
	--self:Spin()
	
	self:Idle()
	
	self:HandleCritStreams()
	
	self:Inspect()
	
end

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	if SERVER then
		
		for i = 1, self.Primary.Shots do
			
			local grenade = ents.Create( self.GrenadeClass )
			if IsValid( grenade ) == true then
				
				local tracefilter = function( ent ) if ent == grenade or ent == self:GetOwner() or ent:GetClass() == grenade:GetClass() then return false end return true end
				
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
				local starttrace = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector():Angle():Up() * -6 ) + ( self:GetOwner():GetAimVector():Angle():Right() * 8 ) + ( self:GetOwner():GetAimVector() * 32 ), filter = tracefilter } )
				local hittrace = util.TraceLine( { start = starttrace.HitPos, endpos = self:GetOwner():GetShootPos() + ( ( self:GetOwner():GetAimVector():Angle() + Angle( math.random( -90, 90 ) * self.Primary.Spread, math.random( -90, 90 ) * self.Primary.Spread, 0 ) ):Forward() * 32768 ), filter = tracefilter } )
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
				
				grenade:SetOwner( self:GetOwner() )
				grenade:SetPos( starttrace.HitPos )
				grenade:SetTFBLU( self:GetTeam() )
				self:SetProjectileModel( grenade, self:GetGrenadeModel() )
				grenade:SetParticles( self:GetProjectileParticles() )
				grenade:SetAngles( ( hittrace.HitPos - starttrace.HitPos ):Angle() )
				grenade:SetTFImpactDamage( self:GetDamageMods( self.Primary.ImpactDamage ) )
				grenade:SetTFDamage( self.Primary.Damage )
				grenade:SetTFCrit( self:DoCrit() )
				grenade:SetTFCritMult( self.CritMultiplier )
				grenade:SetTFRadius( self.GrenadeRadius )
				grenade:SetTFForce( self.Primary.Force )
				grenade:SetTFTime( self.GrenadeTime )
				grenade:Spawn()
				grenade:PhysWake()
				if IsValid( grenade:GetPhysicsObject() ) == true then
					
					grenade:GetPhysicsObject():SetVelocity( grenade:GetAngles():Forward() * self.GrenadeSpeed )
					grenade:SetAngles( Angle( math.random( -180, 180 ), math.random( -180, 180 ), math.random( -180, 180 ) ) )
					if IsValid( self:GetOwner() ) == true then grenade:GetPhysicsObject():ApplyForceOffset( self:GetOwner():GetAimVector():Angle():Up() * 1000, grenade:GetPos() + grenade:GetAngles():Right() ) end
					
				end
				
				local grenadetrace = util.TraceLine( { start = starttrace.HitPos, endpos = grenade:GetPos() + ( grenade:GetAngles():Forward() * 32 ), filter = tracefilter } )
				
				if starttrace.Hit == true or grenadetrace.Hit == true then grenade:SetPos( self:GetOwner():GetShootPos() ) end
				
			end
			
		end
		
	end
	
	self:DoPrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end