AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Syringe"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.TF2Weapons_NoAirblast = true

ENT.Life = 10

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
	self:TFNetworkVar( "Bool", "Hit", false )
	self:TFNetworkVar( "Bool", "RemoveNext", false )
	
	self:TFNetworkVar( "Float", "Life", 0 )
	self:TFNetworkVar( "Float", "RemoveTime", 0 )
	
	self:TFNetworkVar( "Int", "Damage", 0 )
	
	self:TFNetworkVar( "Angle", "Angle", Angle( 0, 0, 0 ) )
	
end

function ENT:SetupDataTables()
	
	self:BaseDataTables()
	
end

function ENT:Initialize()
	
	if SERVER then
		
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		self:SetGravity( 0.3 )
		
		self:SetTrigger( true )
		
	end
	
	self:PhysicsInitSphere( 0.1, "default" )
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		
	end
	
end

ENT.HitCallbacks = {}

function ENT:HitCallback( info )
	
	for i = 1, #self.HitCallbacks do
		
		if self.HitCallbacks[ i ]( info ) == true then return true end
		
	end
	
end

function ENT:AddHitCallback( func )
	
	table.insert( self.HitCallbacks, func )
	
end

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetOwner() != self:GetOwner() then
		
		if ent:IsWorld() != false then
			
			self:SetTFRemoveNext( true )
			self:SetTFRemoveTime( CurTime() + self.Life )
			if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
			
			if CLIENT then self.HitAng = self:GetRenderAngles() end
			
		elseif self:GetTFHit() != true then
			
			if IsValid( self:GetOwner() ) == false then
				
				attacker = self
				
			else
				
				attacker = self:GetOwner()
				
			end
			
			local dmg = DamageInfo()
			dmg:SetAttacker( attacker )
			dmg:SetInflictor( self )
			dmg:SetReportedPosition( self:GetPos() )
			dmg:SetDamagePosition( self:GetPos() )
			dmg:SetDamageType( DMG_BULLET )
			dmg:SetDamage( self:GetTFDamage() )
			
			if self:HitCallback( {
				
				Attacker = attacker,
				Damage = dmg,
				Projectile = self,
				Entity = ent,
				
			} ) != true then
				
				ent:TakeDamageInfo( dmg )
				
			end
			
			self:Remove()
			
		end
		
	end
	
	self:SetTFHit( true )
	
end

function ENT:Think()
	
	--[[
	if CLIENT then
		
		local motion = IsValid( self:GetPhysicsObject() ) == true and self:GetPhysicsObject():IsMotionEnabled() == true
		
		if self.LastPos != nil and motion == true and self.LastPos != self:GetPos() then
			
			self:SetRenderAngles( ( self:GetPos() - self.LastPos ):Angle() )
			
		end
		
		self.LastPos = self:GetPos()
		
	end
	]]--
	
	if SERVER and self:GetTFRemoveNext() == true and CurTime() > self:GetTFRemoveTime() then self:Remove() end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetOwner() != self:GetOwner() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky != false then
			
			self:Remove()
			
		elseif data.HitEntity:IsWorld() != false then
			
			self:SetTFRemoveNext( true )
			self:SetTFRemoveTime( CurTime() + self.Life )
			collider:EnableMotion( false )
			
			if CLIENT then self.HitAng = self:GetRenderAngles() end
			
		elseif self:GetTFHit() != true then
			
			if IsValid( self:GetOwner() ) == false then
				
				attacker = self
				
			else
				
				attacker = self:GetOwner()
				
			end
			
			local dmg = DamageInfo()
			dmg:SetAttacker( attacker )
			dmg:SetInflictor( self )
			dmg:SetReportedPosition( self:GetPos() )
			dmg:SetDamagePosition( self:GetPos() )
			dmg:SetDamageType( DMG_BULLET )
			dmg:SetDamage( self:GetTFDamage() )
			
			if self:HitCallback( {
				
				Attacker = attacker,
				Damage = dmg,
				Projectile = self,
				Entity = data.HitEntity,
				
			} ) != true then
				
				data.HitEntity:TakeDamageInfo( dmg )
				
			end
			
			self:Remove()
			
		end
		
	end
	
	self:SetTFHit( true )
	
end