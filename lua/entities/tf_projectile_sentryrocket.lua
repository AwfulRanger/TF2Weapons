AddCSLuaFile()

ENT.Base = "tf_projectile_rocket"
ENT.PrintName = "Sentry Rocket"

ENT.Model = Model( "models/weapons/w_models/w_rocket.mdl" )
ENT.SentryModel = Model( "models/buildables/sentry3_rockets.mdl" )

function ENT:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "String", "Model", "" )
	
	self:TFNetworkVar( "Entity", "Sentry", nil )
	
end

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetClass() != self:GetClass() and ent != self:GetTFSentry() then self:Explode( true ) end
	
end

function ENT:Think()
	
	self:SetAngles( self:GetTFAngle() )
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():EnableDrag( false )
		self:GetPhysicsObject():EnableGravity( false )
		self:GetPhysicsObject():SetVelocity( self:GetAngles():Forward() * self:GetTFSpeed() )
		
	end
	
	if CLIENT then
		
		if IsValid( self.ClientModel ) != true then self.ClientModel = ClientsideModel( self:GetTFModel() ) end
		if self.ClientModel:GetModel() != self:GetTFModel() then self.ClientModel:SetModel( self:GetTFModel() ) end
		
		self.ClientModel:SetPos( self:GetPos() )
		self.ClientModel:SetAngles( self:GetAngles() )
		
	end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetClass() != self:GetClass() and data.HitEntity != self:GetTFSentry() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky == false then
			
			self:Explode( true )
			
		else
			
			self:Remove()
			
		end
		
	end
	
end

function ENT:Draw()
end

function ENT:OnRemove()
	
	if IsValid( self.ClientModel ) == true then self.ClientModel:Remove() end
	
end