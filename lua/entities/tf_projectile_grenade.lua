AddCSLuaFile()

ENT.Base = "tf_projectile_base"
ENT.Type = "anim"
ENT.PrintName = "Grenade"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.TF2Weapons_OwnOnAirblast = true

ENT.Particles = {
	
	trail = "pipebombtrail_red",
	crittrail = "critical_grenade_red",
	explode = "explosioncore_midair",
	critexplode = "explosioncore_midair",
	
}

ENT.OwnerHitMult = 1
ENT.OwnerEnemyHitMult = 1

function ENT:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "BLU", false )
	self:TFNetworkVar( "Bool", "Crit", false )
	self:TFNetworkVar( "Bool", "Hit", false )
	
	self:TFNetworkVar( "Float", "Radius", 0 )
	self:TFNetworkVar( "Float", "Force", 0 )
	self:TFNetworkVar( "Float", "Time", 0 )
	self:TFNetworkVar( "Float", "CritMult", 0 )
	self:TFNetworkVar( "Float", "DetonateTime", 0 )
	
	self:TFNetworkVar( "Int", "ImpactDamage", 0 )
	self:TFNetworkVar( "Int", "Damage", 0 )
	
	self:TFNetworkVar( "Entity", "HitEntity", nil )
	
end

function ENT:SetVariables()
	
	self.ExplodeSound = { Sound( "weapons/explode1.wav" ), Sound( "weapons/explode2.wav" ), Sound( "weapons/explode3.wav" ) }
	
end

function ENT:Initialize()
	
	for _, v in pairs( self:GetParticles() ) do
		
		if isstring( v ) == true then PrecacheParticleSystem( v ) end
		
	end
	
	self:SetTFDetonateTime( CurTime() + self:GetTFTime() )
	
	if SERVER then
		
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		self:SetTrigger( true )
		
	end
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		
	end
	
	self:AddParticle( self:GetParticles().trail, { {
		
		attachtype = PATTACH_POINT_FOLLOW,
		attachment = "trail",
		
	} } )
	
	self:SetVariables()
	
end

function ENT:Touch( ent )
	
	if ent ~= self:GetOwner() and ent:GetOwner() ~= self:GetOwner() and self:GetTFHit() ~= true then
		
		if ( ent:IsPlayer() == true or ent:IsNPC() == true ) and ent ~= self:GetOwner() and self:GetTFHit() ~= true then
			
			if IsValid( self:GetTFHitEntity() ) == false then self:SetTFHitEntity( ent ) end
			
			self:Explode( true )
			
		end
		
		self:SetTFHit( true )
		
	end
	
end

function ENT:Think()
	
	self:HandleParticles()
	
	if CurTime() > self:GetTFDetonateTime() then self:Explode( true ) end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky ~= false then
		
		self:Remove()
		
	end
	
	if data.HitEntity ~= self:GetOwner() and data.HitEntity:GetOwner() ~= self:GetOwner() and self:GetTFHit() ~= true then
		
		if data.HitEntity:IsPlayer() == true or data.HitEntity:IsNPC() == true then
			
			if IsValid( self:GetTFHitEntity() ) == false then self:SetTFHitEntity( data.HitEntity ) end
			
			self:Explode( true )
			
		end
		
		self:SetTFHit( true )
		
	end
	
end

ENT.ExplodeCallbacks = {}

function ENT:ExplodeCallback( info )
	
	for i = 1, #self.ExplodeCallbacks do
		
		if self.ExplodeCallbacks[ i ]( info ) == true then return true end
		
	end
	
end

function ENT:AddExplodeCallback( func )
	
	table.insert( self.ExplodeCallbacks, func )
	
end

function ENT:Explode( remove, damage )
	
	if game.SinglePlayer() == true or IsFirstTimePredicted() == true then
		
		local explode = self:GetParticles().explode
		if explode ~= nil and explode ~= "" then ParticleEffect( explode, self:GetPos(), self:GetAngles() ) end
		
	end
	
	if CLIENT then return end
	
	if IsValid( self:GetOwner() ) == false then
		
		attacker = self
		
	else
		
		attacker = self:GetOwner()
		
	end
	
	if damage == nil then damage = self:GetTFDamage() end
	
	self:PlaySound( self.ExplodeSound )
	
	local playerhit = false
	local ownerhit = false
	
	local hit = ents.FindInSphere( self:GetPos(), self:GetTFRadius() )
	for i = 1, #hit do
		
		local tr = util.TraceLine( {
			
			start = self:GetPos(),
			endpos = hit[ i ]:GetPos(),
			filter = function( ent ) return ent ~= self and ent:IsPlayer() == false and ent:IsNPC() == false end,
			
		} )
		
		if tr.Hit ~= true then
			
			if ( hit[ i ]:IsPlayer() == true or hit[ i ]:IsNPC() == true ) and hit[ i ] ~= self:GetOwner() then playerhit = true end
			if hit[ i ] == self:GetOwner() then
				
				ownerhit = true
				
			elseif hit[ i ] ~= self:GetTFHitEntity() then
				
				local distance = self:GetPos():Distance( hit[ i ]:GetPos() + hit[ i ]:OBBCenter() )
				local damagemod = ( distance / 2.88 ) * 0.01
				if damagemod > 0.5 then damagemod = 0.5 end
				
				local dmg = DamageInfo()
				dmg:SetAttacker( attacker )
				dmg:SetInflictor( self )
				dmg:SetReportedPosition( self:GetPos() )
				dmg:SetDamagePosition( self:GetPos() )
				dmg:SetDamageType( DMG_BLAST )
				if self:GetTFCrit() == true and hit[ i ] ~= self:GetOwner() then
					
					dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self:GetTFCritMult() )
					
				else
					
					dmg:SetDamage( damage - ( damage * damagemod ) )
					
				end
				
				if self:ExplodeCallback( {
					
					Attacker = attacker,
					Damage = dmg,
					Projectile = self,
					Entity = hit[ i ],
					HitEntity = self:GetTFHitEntity(),
					
				} ) ~= true then
					
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
				if self:GetTFCrit() == true and hit[ i ] ~= self:GetOwner() then
					
					dmg:SetDamage( self:GetTFImpactDamage() * self:GetTFCritMult() )
					
				else
					
					dmg:SetDamage( self:GetTFImpactDamage() )
					
				end
				
				if self:ExplodeCallback( {
					
					Attacker = attacker,
					Damage = dmg,
					Projectile = self,
					Entity = hit[ i ],
					HitEntity = self:GetTFHitEntity(),
					
				} ) ~= true then
					
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
			
			dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self.OwnerEnemyHitMult )
			
		else
			
			dmg:SetDamage( ( damage - ( damage * damagemod ) ) * self.OwnerHitMult )
			
		end
		
		if self:ExplodeCallback( {
			
			Attacker = attacker,
			Damage = dmg,
			Projectile = self,
			Entity = self:GetOwner(),
			
		} ) ~= true then
			
			local hitpos = self:GetOwner():GetPos() + self:GetOwner():OBBCenter()
			local dir = ( hitpos - self:GetPos() ):Angle()
			
			local vel = ( self:GetTFRadius() - distance ) * self:GetTFForce()
			
			if self:GetOwner():IsPlayer() == true then
				
				self:GetOwner():SetVelocity( dir:Forward() * vel )
				
			elseif IsValid( self:GetOwner():GetPhysicsObject() ) == true then
				
				self:GetOwner():GetPhysicsObject():AddVelocity( dir:Forward() * vel )
				
			end
			
			self:GetOwner():TakeDamageInfo( dmg )
			
		end
		
	end
	
	if remove == true then self:Remove() end
	
end