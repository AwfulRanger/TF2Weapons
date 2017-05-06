AddCSLuaFile()

ENT.Base = "tf_projectile_rocket"
ENT.PrintName = "Sentry Rocket"

ENT.Model = Model( "models/weapons/w_models/w_rocket.mdl" )
ENT.SentryModel = Model( "models/buildables/sentry3_rockets.mdl" )

function ENT:SetSentryRocketModel( sentrymodel )
	
	self:SetNW2String( "sentrymodel", sentrymodel )
	
end

function ENT:GetSentryRocketModel()
	
	return self:GetNW2String( "sentrymodel", self.SentryModel )
	
end

function ENT:SetSentry( sentry )
	
	self:SetNW2Entity( "sentry", sentry )
	
end

function ENT:GetSentry()
	
	return self:GetNW2Entity( "sentry", nil )
	
end

function ENT:Touch( ent )
	
	if ent != self:GetOwner() and ent:GetClass() != self:GetClass() and ent != self:GetSentry() then self:Explode( true ) end
	
end

function ENT:PhysicsCollide( data, collider )
	
	if data.HitEntity != self:GetOwner() and data.HitEntity:GetClass() != self:GetClass() and data.HitEntity != self:GetSentry() then
		
		if util.TraceLine( { start = data.HitPos, endpos = data.HitPos + data.HitNormal } ).HitSky == false then
			
			self:Explode( true )
			
		else
			
			self:Remove()
			
		end
		
	end
	
end

--Default sentry rocket model lacks physics so here's a bad workaround

ENT.ClientModel = nil

function ENT:Draw()
	
	--self:DrawModel()
	
	if IsValid( self.ClientModel ) != true then self.ClientModel = ClientsideModel( self:GetSentryRocketModel() ) end
	if self.ClientModel:GetModel() != self:GetSentryRocketModel() then self.ClientModel:SetModel( self:GetSentryRocketModel() ) end
	
	self.ClientModel:SetPos( self:GetPos() )
	self.ClientModel:SetAngles( self:GetAngles() )
	
end

function ENT:OnRemove()
	
	if IsValid( self.ClientModel ) == true then self.ClientModel:Remove() end
	
end