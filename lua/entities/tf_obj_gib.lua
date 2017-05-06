AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Building"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Model = Model( "models/buildables/gibs/sentry1_gib1.mdl" )
ENT.Skin = 0
ENT.Scrap = 16

function ENT:SetGibModel( model )
	
	self:SetNW2String( "model", model )
	self:SetModel( model )
	
end

function ENT:GetGibModel()
	
	return self:GetNW2String( "model", self.Model )
	
end

function ENT:SetGibSkin( skin )
	
	self:SetNW2Int( "skin", skin )
	self:SetSkin( skin )
	
end

function ENT:GetGibSkin()
	
	return self:GetNW2Int( "skin", self.Skin )
	
end

function ENT:SetGibScrap( scrap )
	
	self:SetNW2Int( "scrap", scrap )
	
end

function ENT:GetGibScrap()
	
	return self:GetNW2Int( "scrap", self.Scrap )
	
end

function ENT:Initialize()
	
	if SERVER then
		
		self:SetModel( self:GetGibModel() )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		self:SetTrigger( true )
		
	end
	
	if IsValid( self:GetPhysicsObject() ) == true then
		
		self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		
	end
	
end

ENT.Touched = false

function ENT:Touch( ent )
	
	if self.Touched != true and ent:IsPlayer() == true then
		
		ent:GiveAmmo( self:GetGibScrap(), "tf2weapons_metal" )
		self:Remove()
		
		self.Touched = true
		
	end
	
end