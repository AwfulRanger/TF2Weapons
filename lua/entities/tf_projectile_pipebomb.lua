AddCSLuaFile()

ENT.Base = "tf_projectile_base"
ENT.Type = "anim"
ENT.PrintName = "Pipebomb"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:TF2Weapons_OnAirblasted( weapon, ent )
	
	if weapon.OwnOnAirblast[ ent:GetClass() ] == true or ent.TF2Weapons_OwnOnAirblast == true then ent:SetOwner( weapon:GetOwner() ) end
	
	if IsValid( ent:GetPhysicsObject() ) == true then
		
		ent:SetTFNextFreeze( CurTime() + 1 )
		
		ent:GetPhysicsObject():EnableMotion( true )
		
		local mult = ent:GetVelocity():Length() + weapon.Secondary.Force
		ent:GetPhysicsObject():SetVelocity( Vector( weapon:GetOwner():GetAimVector().x * mult, weapon:GetOwner():GetAimVector().y * mult, weapon:GetOwner():GetAimVector().z * mult ) )
		
	end
	
end

ENT.Particles = {
	
	trail = "stickybombtrail_red",
	crittrail = "critical_pipe_red",
	explode = "explosioncore_midair",
	critexplode = "explosioncore_midair",
	
}

ENT.OwnerHitMult = 0.8
ENT.OwnerEnemyHitMult = 1

function ENT:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "BLU", false )
	self:TFNetworkVar( "Bool", "Crit", false )
	
	self:TFNetworkVar( "Float", "Radius", 0 )
	self:TFNetworkVar( "Float", "Force", 0 )
	self:TFNetworkVar( "Float", "CritMult", 0 )
	self:TFNetworkVar( "Float", "Time", 0 )
	self:TFNetworkVar( "Float", "NextFreeze", 0 )
	
	self:TFNetworkVar( "Int", "Damage", 0 )
	
end

function ENT:SetVariables()
	
	self.ExplodeSound = { Sound( "weapons/explode1.wav" ), Sound( "weapons/explode2.wav" ), Sound( "weapons/explode3.wav" ) }
	
end

function ENT:Initialize()
	
	for _, v in pairs( self:GetParticles() ) do
		
		if isstring( v ) == true then PrecacheParticleSystem( v ) end
		
	end
	
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
	
	if ent:IsWorld() ~= false and ent ~= self:GetOwner() and ent:GetOwner() ~= self:GetOwner() and IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity ~= self:GetOwner() and data.HitEntity:GetOwner() ~= self:GetOwner() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky ~= false then
			
			self:Remove()
			
		elseif data.HitEntity:IsWorld() ~= false and CurTime() > self:GetTFNextFreeze() then
			
			if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
			
		end
		
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
		
		if ( hit[ i ]:IsPlayer() == true or hit[ i ]:IsNPC() == true ) and hit[ i ] ~= self:GetOwner() then playerhit = true end
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
			
			if self:ExplodeCallback( {
				
				Attacker = attacker,
				Damage = dmg,
				Projectile = self,
				Entity = hit[ i ],
				
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

function ENT:OnTakeDamage( dmg )
	
	if dmg:IsDamageType( DMG_BULLET ) == true or dmg:IsDamageType( DMG_CLUB ) == true then
		
		self:Remove()
		
	else
		
		if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( true ) end
		
	end
	
end