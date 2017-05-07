AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Syringe"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.TF2Weapons_NoAirblast = true

ENT.PhysModel = Model( "models/weapons/w_models/w_drg_ball.mdl" )
ENT.Model = Model( "models/weapons/w_models/w_syringe_proj.mdl" )
ENT.Skin = 0
ENT.Damage = 10
ENT.Life = 10

function ENT:SetSyringeModel( model )
	
	self:SetNW2String( "model", model )
	--self:SetModel( model )
	
end

function ENT:GetSyringeModel()
	
	return self:GetNW2String( "model", self.Model )
	
end

function ENT:SetSyringeSkin( skin )
	
	self:SetNW2Int( "skin", skin )
	--self:SetSkin( skin )
	
end

function ENT:GetSyringeSkin()
	
	return self:GetNW2Int( "skin", self.Skin )
	
end

function ENT:SetSyringeDamage( damage )
	
	self:SetNW2Float( "damage", damage )
	
end

function ENT:GetSyringeDamage()
	
	return self:GetNW2Float( "damage", self.Damage )
	
end

function ENT:SetSyringeLife( life )
	
	self:SetNW2Float( "life", life )
	
end

function ENT:GetSyringeLife()
	
	return self:GetNW2Float( "life", self.Life )
	
end

function ENT:SetSyringeBLU( blu )
	
	self:SetNW2Bool( "blu", blu )
	
end

function ENT:GetSyringeBLU()
	
	return self:GetNW2Float( "blu", false )
	
end

function ENT:Initialize()
	
	if SERVER then
		
		self:SetModel( self.PhysModel )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		self:SetTrigger( true )
		
	end
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		
	end
	
end

ENT.FirstHit = true

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetOwner() != self:GetOwner() then
		
		if ent:IsWorld() != false then
			
			self.RemoveNext = true
			self.RemoveTime = CurTime() + 10
			if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
			
		elseif self.FirstHit != false then
			
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
			dmg:SetDamage( self:GetSyringeDamage() )
			ent:TakeDamageInfo( dmg )
			
			self:Remove()
			
		end
		
	end
	
	self.FirstHit = false
	
end

ENT.RemoveNext = false
ENT.RemoveTime = 0

function ENT:Think()
	
	if CLIENT then
		
		if IsValid( self.ClientModel ) != true then self.ClientModel = ClientsideModel( self:GetSyringeModel() ) end
		if self.ClientModel:GetModel() != self:GetSyringeModel() then self.ClientModel:SetModel( self:GetSyringeModel() ) end
		
		self.ClientModel:SetPos( self:GetPos() )
		self.ClientModel:SetAngles( self:GetAngles() )
		
	end
	
	if self.RemoveNext == true and CurTime() > self.RemoveTime then self:Remove() end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetOwner() != self:GetOwner() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky != false then
			
			self:Remove()
			
		elseif data.HitEntity:IsWorld() != false then
			
			self.RemoveNext = true
			self.RemoveTime = CurTime() + self:GetSyringeLife()
			collider:EnableMotion( false )
			
		elseif self.FirstHit != false then
			
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
			dmg:SetDamage( self:GetSyringeDamage() )
			data.HitEntity:TakeDamageInfo( dmg )
			
			self:Remove()
			
		end
		
	end
	
	self.FirstHit = false
	
end

function ENT:Draw()
end

function ENT:OnRemove()
	
	if IsValid( self.ClientModel ) == true then self.ClientModel:Remove() end
	
end