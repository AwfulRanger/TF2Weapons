AddCSLuaFile()

if CLIENT then
	
	game.AddParticles( "particles/rockettrail.pcf" )
	game.AddParticles( "particles/explosion.pcf" )
	
end

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Rocket"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.TF2Weapons_OwnOnAirblast = true
function ENT:TF2Weapons_OnAirblasted( weapon, ent )
	
	if weapon.OwnOnAirblast[ ent:GetClass() ] == true or ent.TF2Weapons_OwnOnAirblast == true then ent:SetOwner( weapon:GetOwner() ) end
	
	if weapon:GetOwner():IsPlayer() == true then weapon:GetOwner():LagCompensation( true ) end
	local trace = util.TraceLine( { start = weapon:GetOwner():GetShootPos(), endpos = weapon:GetOwner():GetShootPos() + ( weapon:GetOwner():EyeAngles():Forward() * 32768 ), filter = { ent, weapon:GetOwner() } } )
	if weapon:GetOwner():IsPlayer() == true then weapon:GetOwner():LagCompensation( false ) end
	
	ent:SetRocketAngles( ( trace.HitPos - ent:GetPos() ):Angle() )
	
end

ENT.Model = "models/weapons/w_models/w_rocket.mdl"
ENT.Skin = 0
ENT.Particles = {
	
	trail = "rockettrail",
	crittrail = "critical_rocket_red",
	explode = "explosioncore_wall",
	critexplode = "explosioncore_wall",
	
}
ENT.Angles = Angle( 0, 0, 0 )
ENT.Damage = 90
--ENT.Speed = 1024
ENT.Speed = 1100
ENT.Radius = 146
ENT.Force = 5

ENT.CritMultiplier = 3

function ENT:SetRocketModel( model )
	
	self:SetNW2String( "model", model )
	self:SetModel( model )
	
end

function ENT:GetRocketModel()
	
	return self:GetNW2String( "model", self.Model )
	
end

function ENT:SetRocketSkin( skin )
	
	self:SetNW2Int( "skin", skin )
	self:SetSkin( skin )
	
end

function ENT:GetRocketSkin()
	
	return self:GetNW2Int( "skin", self.Skin )
	
end

function ENT:SetRocketParticles( particles )
	
	for _, v in pairs( self.Particles ) do
		
		if particles[ _ ] != nil then
			
			self:SetNW2String( "particle_" .. _, particles[ _ ] )
			
		end
		
	end
	
end

function ENT:GetRocketParticles()
	
	local particles = {}
	for _, v in pairs( self.Particles ) do
		
		particles[ _ ] = self:GetNW2String( "particle_" .. _, v )
		
	end
		
	return particles
	
end

function ENT:SetRocketAngles( angles )
	
	self:SetNW2Angle( "angles", angles )
	self:SetAngles( angles )
	
end

function ENT:GetRocketAngles()
	
	--return self.Angles
	return self:GetNW2Angle( "angles", self.Angles )
	
end

function ENT:SetRocketDamage( damage )
	
	self:SetNW2Float( "damage", damage )
	
end

function ENT:GetRocketDamage()
	
	return self:GetNW2Float( "damage", self.Damage )
	
end

function ENT:SetRocketSpeed( speed )
	
	self:SetNW2Float( "speed", speed )
	
end

function ENT:GetRocketSpeed()
	
	return self:GetNW2Float( "speed", self.Speed )
	
end

function ENT:SetRocketRadius( radius )
	
	self:SetNW2Float( "radius", radius )
	
end

function ENT:GetRocketRadius()
	
	return self:GetNW2Float( "radius", self.Radius )
	
end

function ENT:SetRocketForce( force )
	
	self:SetNW2Float( "force", force )
	
end

function ENT:GetRocketForce()
	
	return self:GetNW2Float( "force", self.Force )
	
end

function ENT:SetRocketBLU( blu )
	
	self:SetNW2Bool( "blu", blu )
	
end

function ENT:GetRocketBLU()
	
	return self:GetNW2Float( "blu", false )
	
end

function ENT:SetRocketCrit( crit )
	
	self:SetNW2Bool( "crit", crit )
	
end

function ENT:GetRocketCrit()
	
	return self:GetNW2Bool( "crit", false )
	
end

function ENT:SetRocketCritMultiplier( critmultiplier )
	
	self:SetNW2Float( "critmultiplier", critmultiplier )
	
end

function ENT:GetRocketCritMultiplier()
	
	return self:GetNW2Float( "critmultiplier", self.CritMultiplier )
	
end

function ENT:SetSounds()
	
	self.ExplodeSound = { Sound( "weapons/explode1.wav" ), Sound( "weapons/explode2.wav" ), Sound( "weapons/explode3.wav" ) }
	
end

function ENT:PlaySound( sound )
	
	if istable( sound ) == true then
		
		self:EmitSound( sound[ math.random( #sound ) ] )
		
	else
		
		self:EmitSound( sound )
		
	end
	
end

function ENT:Initialize()
	
	for _, v in pairs( self:GetRocketParticles() ) do
		
		PrecacheParticleSystem( v )
		
	end
	
	if SERVER then
		
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		self:SetTrigger( true )
		
	end
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():EnableDrag( false )
		self:GetPhysicsObject():EnableGravity( false )
		self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		
	end
	
	local trail = self:GetRocketParticles().trail
	
	if trail != nil and trail != "" then
		
		if self:LookupAttachment( "trail" ) != nil then
			
			ParticleEffectAttach( trail, PATTACH_POINT_FOLLOW, self, self:LookupAttachment( "trail" ) )
			
		else
			
			ParticleEffectAttach( trail, PATTACH_ABSORIGIN_FOLLOW, self, -1 )
			
		end
		
	end
	
	self:SetSounds()
	
end

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetClass() != self:GetClass() then self:Explode( true ) end
	
end

function ENT:Think()
	
	self:SetAngles( self:GetRocketAngles() )
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():EnableDrag( false )
		self:GetPhysicsObject():EnableGravity( false )
		self:GetPhysicsObject():SetVelocity( self:GetAngles():Forward() * self:GetRocketSpeed() )
		
	end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetClass() != self:GetClass() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky == false then
			
			self:Explode( true )
			
		else
			
			self:Remove()
			
		end
		
	end
	
end

function ENT:Explode( remove, damage )
	
	if CLIENT then return end
	
	if IsValid( self:GetOwner() ) == false then
		
		attacker = self
		
	else
		
		attacker = self:GetOwner()
		
	end
	
	if damage == nil then damage = self:GetRocketDamage() end
	
	self:PlaySound( self.ExplodeSound )
	--util.BlastDamage( self, attacker, self:GetPos(), self:GetRocketRadius(), damage )
	
	local explode = self:GetRocketParticles().explode
	
	ParticleEffect( explode, self:GetPos(), self:GetAngles() )
	
	local playerhit = false
	local ownerhit = false
	
	local hit = ents.FindInSphere( self:GetPos(), self:GetRocketRadius() )
	for i = 1, #hit do
		
		if ( hit[ i ]:IsPlayer() == true or hit[ i ]:IsNPC() == true ) and hit[ i ] != self:GetOwner() then playerhit = true end
		if hit[ i ] == self:GetOwner() then
			
			ownerhit = true
			
		else
			
			local distance = self:GetPos():Distance( hit[ i ]:GetPos() + hit[ i ]:OBBCenter() )
			local damagemod = ( distance / 2.88 ) * 0.01
			if damagemod > 0.5 then damagemod = 0.5 end
			
			local dmg = DamageInfo()
			dmg:SetAttacker( attacker )
			dmg:SetInflictor( self )
			dmg:SetReportedPosition( self:GetPos() )
			dmg:SetDamagePosition( self:GetPos() )
			dmg:SetDamageType( DMG_BLAST )
			if self:GetRocketCrit() == true then
				
				dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self:GetRocketCritMultiplier() )
				
			else
				
				dmg:SetDamage( damage - ( damage * damagemod ) )
				
			end
			
			local hitpos = hit[ i ]:GetPos() + hit[ i ]:OBBCenter()
			local dir = ( hitpos - self:GetPos() ):Angle()
			
			local vel = ( self:GetRocketRadius() - distance ) * self:GetRocketForce()
			
			if hit[ i ]:IsPlayer() == true then
				
				hit[ i ]:SetVelocity( dir:Forward() * vel )
				
			elseif IsValid( hit[ i ]:GetPhysicsObject() ) == true then
				
				hit[ i ]:GetPhysicsObject():AddVelocity( dir:Forward() * vel )
				
			end
			
			hit[ i ]:TakeDamageInfo( dmg )
			
		end
		
	end
	
	if ownerhit == true then
		
		local distance = self:GetPos():Distance( self:GetOwner():GetPos() + self:GetOwner():OBBCenter() )
		local damagemod = ( distance / 2.88 ) * 0.01
		if damagemod > 0.5 then damagemod = 0.5 end
		
		local dmg = DamageInfo()
		dmg:SetInflictor( self )
		dmg:SetAttacker( attacker )
		dmg:SetReportedPosition( self:GetPos() )
		dmg:SetDamagePosition( self:GetPos() )
		dmg:SetDamageType( DMG_BLAST )
		if playerhit == true then
			
			dmg:SetDamage( damage - ( damage * damagemod ) )
			
		else
			
			dmg:SetDamage( ( damage - ( damage * damagemod ) ) * 0.6 )
			
		end
		
		local hitpos = self:GetOwner():GetPos() + self:GetOwner():OBBCenter()
		local dir = ( hitpos - self:GetPos() ):Angle()
		
		local vel = ( self:GetRocketRadius() - distance ) * 4
		
		if self:GetOwner():IsPlayer() == true then
			
			self:GetOwner():SetVelocity( dir:Forward() * vel )
			
		elseif IsValid( self:GetOwner():GetPhysicsObject() ) == true then
			
			self:GetOwner():GetPhysicsObject():AddVelocity( dir:Forward() * vel )
			
		end
		
		self:GetOwner():TakeDamageInfo( dmg )
		
	end
	
	if remove == true then self:Remove() end
	
end