AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Grenade"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.TF2Weapons_OwnOnAirblast = true

ENT.Model = "models/weapons/w_models/w_grenade_grenadelauncher.mdl"
ENT.Skin = 0
ENT.Particles = {
	
	trail = "pipebombtrail_red",
	crittrail = "critical_grenade_red",
	explode = "explosioncore_midair",
	critexplode = "explosioncore_midair",
	
}
ENT.ImpactDamage = 100
ENT.Damage = 60
ENT.Radius = 146
ENT.Time = 2.3

ENT.CritMultiplier = 3

function ENT:SetGrenadeModel( model )
	
	self:SetNW2String( "model", model )
	self:SetModel( model )
	
end

function ENT:GetGrenadeModel()
	
	return self:GetNW2String( "model", self.Model )
	
end

function ENT:SetGrenadeSkin( skin )
	
	self:SetNW2Int( "skin", skin )
	self:SetSkin( skin )
	
end

function ENT:GetGrenadeSkin()
	
	return self:GetNW2Int( "skin", self.Skin )
	
end

function ENT:SetGrenadeParticles( particles )
	
	for _, v in pairs( self.Particles ) do
		
		if particles[ _ ] != nil then
			
			self:SetNW2String( "particle_" .. _, particles[ _ ] )
			
		end
		
	end
	
end

function ENT:GetGrenadeParticles()
	
	local particles = {}
	for _, v in pairs( self.Particles ) do
		
		particles[ _ ] = self:GetNW2String( "particle_" .. _, v )
		
	end
		
	return particles
	
end

function ENT:SetGrenadeImpactDamage( impactdamage )
	
	self:SetNW2String( "impactdamage", impactdamage )
	
end

function ENT:GetGrenadeImpactDamage()
	
	return self:GetNW2String( "impactdamage", self.ImpactDamage )
	
end

function ENT:SetGrenadeDamage( damage )
	
	self:SetNW2Float( "damage", damage )
	
end

function ENT:GetGrenadeDamage()
	
	return self:GetNW2Float( "damage", self.Damage )
	
end

function ENT:SetGrenadeRadius( radius )
	
	self:SetNW2Float( "radius", radius )
	
end

function ENT:GetGrenadeRadius()
	
	return self:GetNW2Float( "radius", self.Radius )
	
end

function ENT:SetGrenadeTime( time )
	
	self:SetNW2Float( "time", time )
	
end

function ENT:GetGrenadeTime()
	
	return self:GetNW2Float( "time", self.Time )
	
end

function ENT:SetGrenadeBLU( blu )
	
	self:SetNW2Bool( "blu", blu )
	
end

function ENT:GetGrenadeBLU()
	
	return self:GetNW2Bool( "blu", false )
	
end

function ENT:SetGrenadeCrit( crit )
	
	self:SetNW2Bool( "crit", crit )
	
end

function ENT:GetGrenadeCrit()
	
	return self:GetNW2Bool( "crit", false )
	
end

function ENT:SetGrenadeCritMultiplier( critmultiplier )
	
	self:SetNW2Float( "critmultiplier", critmultiplier )
	
end

function ENT:GetGrenadeCritMultiplier()
	
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

ENT.DetonateTime = 0

function ENT:Initialize()
	
	self.DetonateTime = CurTime() + self:GetGrenadeTime()
	
	for _, v in pairs( self:GetGrenadeParticles() ) do
		
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
		
		self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		
	end
	
	local trail = self:GetGrenadeParticles().trail
	
	if trail != nil and trail != "" then
		
		if self:LookupAttachment( "trail" ) != nil then
			
			ParticleEffectAttach( trail, PATTACH_POINT_FOLLOW, self, self:LookupAttachment( "trail" ) )
			
		else
			
			ParticleEffectAttach( trail, PATTACH_ABSORIGIN_FOLLOW, self, -1 )
			
		end
		
	end
	
	self:SetSounds()
	
end

ENT.HitEntity = nil
ENT.FirstHit = true

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetOwner() != self:GetOwner() and self.FirstHit == true then
		
		if ( ent:IsPlayer() == true or ent:IsNPC() == true ) and ent != self:GetOwner() and self.FirstHit == true then
			
			if IsValid( self.HitEntity ) == false then self.HitEntity = ent end
			
			self:Explode( true )
			
		end
		
		self.FirstHit = false
		
	end
	
end

function ENT:Think()
	
	if CurTime() > self.DetonateTime then self:Explode( true ) end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky != false then
		
		self:Remove()
		
	end
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetOwner() != self:GetOwner() and self.FirstHit == true then
		
		if data.HitEntity:IsPlayer() == true or data.HitEntity:IsNPC() == true then
			
			if IsValid( self.HitEntity ) == false then self.HitEntity = data.HitEntity end
			
			self:Explode( true )
			
		end
		
		self.FirstHit = false
		
	end
	
end

function ENT:Explode( remove, damage )
	
	if CLIENT then return end
	
	if IsValid( self:GetOwner() ) == false then
		
		attacker = self
		
	else
		
		attacker = self:GetOwner()
		
	end
	
	if damage == nil then damage = self:GetGrenadeDamage() end
	
	self:PlaySound( self.ExplodeSound )
	--util.BlastDamage( self, attacker, self:GetPos(), self:GetGrenadeRadius(), damage )
	
	local explode = self:GetGrenadeParticles().explode
	
	ParticleEffect( explode, self:GetPos(), self:GetAngles() )
	
	local hit = ents.FindInSphere( self:GetPos(), self:GetGrenadeRadius() )
	for i = 1, #hit do
		
		if hit[ i ] != self.HitEntity then
			
			local distance = self:GetPos():Distance( hit[ i ]:GetPos() + hit[ i ]:OBBCenter() )
			local damagemod = ( distance / 2.88 ) * 0.01
			if damagemod > 0.5 then damagemod = 0.5 end
			
			local dmg = DamageInfo()
			dmg:SetAttacker( attacker )
			dmg:SetInflictor( self )
			dmg:SetReportedPosition( self:GetPos() )
			dmg:SetDamagePosition( self:GetPos() )
			dmg:SetDamageType( DMG_BLAST )
			if self:GetGrenadeCrit() == true and hit[ i ] != self:GetOwner() then
				
				dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self:GetGrenadeCritMultiplier() )
				
			else
				
				dmg:SetDamage( damage - ( damage * damagemod ) )
				
			end
			
			hit[ i ]:TakeDamageInfo( dmg )
			
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
			if self:GetGrenadeCrit() == true and hit[ i ] != self:GetOwner() then
				
				dmg:SetDamage( self:GetGrenadeImpactDamage() * self:GetGrenadeCritMultiplier() )
				
			else
				
				dmg:SetDamage( self:GetGrenadeImpactDamage() )
				
			end
			
			local hitpos = hit[ i ]:GetPos() + hit[ i ]:OBBCenter()
			local dir = ( hitpos - self:GetPos() ):Angle()
			
			local vel = ( self:GetGrenadeRadius() - distance ) * 5
			
			if hit[ i ]:IsPlayer() == true then
				
				hit[ i ]:SetVelocity( dir:Forward() * vel )
				
			elseif IsValid( hit[ i ]:GetPhysicsObject() ) == true then
				
				hit[ i ]:GetPhysicsObject():AddVelocity( dir:Forward() * vel )
				
			end
			
			hit[ i ]:TakeDamageInfo( dmg )
			
		end
		
	end
	
	if remove == true then self:Remove() end
	
end