AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Pipebomb"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:TF2Weapons_OnAirblasted( weapon, ent )
	
	if weapon.OwnOnAirblast[ ent:GetClass() ] == true or ent.TF2Weapons_OwnOnAirblast == true then ent:SetOwner( weapon:GetOwner() ) end
	
	if IsValid( ent:GetPhysicsObject() ) == true then
		
		ent.NextFreeze = CurTime() + 1
		
		ent:GetPhysicsObject():EnableMotion( true )
		
		local mult = ent:GetVelocity():Length() + weapon.Secondary.Force
		ent:GetPhysicsObject():SetVelocity( Vector( weapon:GetOwner():GetAimVector().x * mult, weapon:GetOwner():GetAimVector().y * mult, weapon:GetOwner():GetAimVector().z * mult ) )
		
	end
	
end

ENT.Model = "models/weapons/w_models/w_stickybomb.mdl"
ENT.Skin = 0
ENT.Particles = {
	
	trail = "stickybombtrail_red",
	crittrail = "critical_pipe_red",
	explode = "explosioncore_midair",
	critexplode = "explosioncore_midair",
	
}
ENT.Damage = 120
ENT.Radius = 146
ENT.Force = 5
ENT.Time = 0

ENT.CritMultiplier = 3

function ENT:SetPipebombModel( model )
	
	self:SetNW2String( "model", model )
	self:SetModel( model )
	
end

function ENT:GetPipebombModel()
	
	return self:GetNW2String( "model", self.Model )
	
end

function ENT:SetPipebombSkin( skin )
	
	self:SetNW2Int( "skin", skin )
	self:SetSkin( skin )
	
end

function ENT:GetPipebombSkin()
	
	return self:GetNW2Int( "skin", self.Skin )
	
end

function ENT:SetPipebombParticles( particles )
	
	for _, v in pairs( self.Particles ) do
		
		if particles[ _ ] != nil then
			
			self:SetNW2String( "particle_" .. _, particles[ _ ] )
			
		end
		
	end
	
end

function ENT:GetPipebombParticles()
	
	local particles = {}
	for _, v in pairs( self.Particles ) do
		
		particles[ _ ] = self:GetNW2String( "particle_" .. _, v )
		
	end
		
	return particles
	
end

function ENT:SetPipebombDamage( damage )
	
	self:SetNW2Float( "damage", damage )
	
end

function ENT:GetPipebombDamage()
	
	return self:GetNW2Float( "damage", self.Damage )
	
end

function ENT:SetPipebombRadius( radius )
	
	self:SetNW2Float( "radius", radius )
	
end

function ENT:GetPipebombRadius()
	
	return self:GetNW2Float( "radius", self.Radius )
	
end

function ENT:SetPipebombForce( force )
	
	self:SetNW2Float( "force", force )
	
end

function ENT:GetPipebombForce()
	
	return self:GetNW2Float( "force", self.Force )
	
end

function ENT:SetPipebombTime( time )
	
	self:SetNW2Float( "time", time )
	
end

function ENT:GetPipebombTime()
	
	return self:GetNW2Float( "time", self.Time )
	
end

function ENT:SetPipebombBLU( blu )
	
	self:SetNW2Bool( "blu", blu )
	
end

function ENT:GetPipebombBLU()
	
	return self:GetNW2Float( "blu", false )
	
end

function ENT:SetPipebombCrit( crit )
	
	self:SetNW2Bool( "crit", crit )
	
end

function ENT:GetPipebombCrit()
	
	return self:GetNW2Bool( "crit", false )
	
end

function ENT:SetPipebombCritMultiplier( critmultiplier )
	
	self:SetNW2Float( "critmultiplier", critmultiplier )
	
end

function ENT:GetPipebombCritMultiplier()
	
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
	
	for _, v in pairs( self:GetPipebombParticles() ) do
		
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
	
	local trail = self:GetPipebombParticles().trail
	
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
	
	if ent:IsWorld() != false and ent != self:GetOwner() and ent:GetOwner() != self:GetOwner() and IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
	
end

ENT.NextFreeze = 0

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetOwner() != self:GetOwner() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky != false then
			
			self:Remove()
			
		elseif data.HitEntity:IsWorld() != false and CurTime() > self.NextFreeze then
			
			if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
			
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
	
	if damage == nil then damage = self:GetPipebombDamage() end
	
	self:PlaySound( self.ExplodeSound )
	--util.BlastDamage( self, attacker, self:GetPos(), self:GetPipebombRadius(), damage )
	
	local explode = self:GetPipebombParticles().explode
	
	ParticleEffect( explode, self:GetPos(), self:GetAngles() )
	
	local playerhit = false
	local ownerhit = false
	
	local hit = ents.FindInSphere( self:GetPos(), self:GetPipebombRadius() )
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
			if self:GetPipebombCrit() == true then
				
				dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self:GetPipebombCritMultiplier() )
				
			else
				
				dmg:SetDamage( damage - ( damage * damagemod ) )
				
			end
			
			local hitpos = hit[ i ]:GetPos() + hit[ i ]:OBBCenter()
			local dir = ( hitpos - self:GetPos() ):Angle()
			
			local vel = ( self:GetPipebombRadius() - distance ) * self:GetPipebombForce()
			
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
			
			dmg:SetDamage( ( damage - ( damage * damagemod ) ) * 0.8 )
			
		end
		
		local hitpos = self:GetOwner():GetPos() + self:GetOwner():OBBCenter()
		local dir = ( hitpos - self:GetPos() ):Angle()
		
		local vel = ( self:GetPipebombRadius() - distance ) * self:GetPipebombForce()
		
		if self:GetOwner():IsPlayer() == true then
			
			self:GetOwner():SetVelocity( dir:Forward() * vel )
			
		elseif IsValid( self:GetOwner():GetPhysicsObject() ) == true then
			
			self:GetOwner():GetPhysicsObject():AddVelocity( dir:Forward() * vel )
			
		end
		
		self:GetOwner():TakeDamageInfo( dmg )
		
	end
	
	if remove == true then self:Remove() end
	
end

function ENT:OnTakeDamage( dmg )
	
	if dmg:IsDamageType( DMG_BULLET ) == true or dmg:IsDamageType( DMG_CLUB ) == true then
		
		self:Remove()
		
	else
		
		if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( true ) end
		
	end
	
end