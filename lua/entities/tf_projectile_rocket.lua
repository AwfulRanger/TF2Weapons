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
	
	ent:SetTFAngle( ( trace.HitPos - ent:GetPos() ):Angle() )
	
end

ENT.Particles = {
	
	trail = "rockettrail",
	crittrail = "critical_rocket_red",
	explode = "explosioncore_wall",
	critexplode = "explosioncore_wall",
	
}

function ENT:TFNetworkVar( vartype, varname, default, slot, extended )
	
	if self[ "GetTF" .. varname ] != nil or self[ "SetTF" .. varname ] != nil then return end
	
	if self.CreatedNetworkVars == nil then self.CreatedNetworkVars = {} end
	
	if self.CreatedNetworkVars[ vartype ] == nil then
		
		self.CreatedNetworkVars[ vartype ] = 0
		
	end
	
	if slot != nil then self.CreatedNetworkVars[ vartype ] = slot end
	slot = self.CreatedNetworkVars[ vartype ]
	
	self:NetworkVar( vartype, slot, "TF" .. varname, extended )
	if SERVER and default != nil then self[ "SetTF" .. varname ]( self, default ) end
	
	self.CreatedNetworkVars[ vartype ] = self.CreatedNetworkVars[ vartype ] + 1
	
	return self[ "GetTF" .. varname ]( self )
	
end

function ENT:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "BLU", false )
	self:TFNetworkVar( "Bool", "Crit", false )
	
	self:TFNetworkVar( "Float", "Speed", 0 )
	self:TFNetworkVar( "Float", "Radius", 0 )
	self:TFNetworkVar( "Float", "Force", 0 )
	self:TFNetworkVar( "Float", "CritMult", 0 )
	
	self:TFNetworkVar( "Int", "Damage", 0 )
	
	self:TFNetworkVar( "Angle", "Angle", Angle( 0, 0, 0 ) )
	
end

function ENT:SetupDataTables()
	
	self:BaseDataTables()
	
end

function ENT:SetParticles( particles )
	
	for _, v in pairs( self.Particles ) do
		
		if particles[ _ ] != nil then
			
			self:SetNW2String( "particle_" .. _, particles[ _ ] )
			
		end
		
	end
	
end

function ENT:GetParticles()
	
	local particles = {}
	for _, v in pairs( self.Particles ) do
		
		particles[ _ ] = self:GetNW2String( "particle_" .. _, v )
		
	end
		
	return particles
	
end

function ENT:SetVariables()
	
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
	
	for _, v in pairs( self:GetParticles() ) do
		
		PrecacheParticleSystem( v )
		
	end
	
	if SERVER then
		
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
	
	local trail = self:GetParticles().trail
	
	if trail != nil and trail != "" then
		
		if self:LookupAttachment( "trail" ) != nil then
			
			ParticleEffectAttach( trail, PATTACH_POINT_FOLLOW, self, self:LookupAttachment( "trail" ) )
			
		else
			
			ParticleEffectAttach( trail, PATTACH_ABSORIGIN_FOLLOW, self, -1 )
			
		end
		
	end
	
	self:SetVariables()
	
end

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetClass() != self:GetClass() then self:Explode( true ) end
	
end

function ENT:Think()
	
	self:SetAngles( self:GetTFAngle() )
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():EnableDrag( false )
		self:GetPhysicsObject():EnableGravity( false )
		self:GetPhysicsObject():SetVelocity( self:GetAngles():Forward() * self:GetTFSpeed() )
		
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
	
	if damage == nil then damage = self:GetTFDamage() end
	
	self:PlaySound( self.ExplodeSound )
	
	local explode = self:GetParticles().explode
	
	ParticleEffect( explode, self:GetPos(), self:GetAngles() )
	
	local playerhit = false
	local ownerhit = false
	
	local hit = ents.FindInSphere( self:GetPos(), self:GetTFRadius() )
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
			if self:GetTFCrit() == true then
				
				dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self:GetTFCritMult() )
				
			else
				
				dmg:SetDamage( damage - ( damage * damagemod ) )
				
			end
			
			local hitpos = hit[ i ]:GetPos() + hit[ i ]:OBBCenter()
			local dir = ( hitpos - self:GetPos() ):Angle()
			
			local vel = ( self:GetTFRadius() - distance ) * self:GetTFForce()
			
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
		
		local vel = ( self:GetTFRadius() - distance ) * 4
		
		if self:GetOwner():IsPlayer() == true then
			
			self:GetOwner():SetVelocity( dir:Forward() * vel )
			
		elseif IsValid( self:GetOwner():GetPhysicsObject() ) == true then
			
			self:GetOwner():GetPhysicsObject():AddVelocity( dir:Forward() * vel )
			
		end
		
		self:GetOwner():TakeDamageInfo( dmg )
		
	end
	
	if remove == true then self:Remove() end
	
end