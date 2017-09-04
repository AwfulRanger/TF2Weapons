AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Projectile"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Particles = {}

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
		
		if isstring( v ) == true then particles[ _ ] = self:GetNW2String( "particle_" .. _, v ) end
		
	end
	
	return particles
	
end

function ENT:SetVariables()
end

function ENT:PlaySound( sound )
	
	if istable( sound ) == true then
		
		self:EmitSound( sound[ math.random( #sound ) ] )
		
	else
		
		self:EmitSound( sound )
		
	end
	
end

ENT.CreatedParticles = {}

function ENT:AddParticle( particle, options )
	
	if particle == nil or particle == "" or options == nil then return end
	
	if SERVER then
		
		net.Start( "tf2weapons_addparticle" )
			
			net.WriteEntity( self )
			
			net.WriteString( particle )
			
			net.WriteInt( #options, 32 )
			if #options > 0 then
				
				for i = 1, #options do
					
					net.WriteType( options[ i ].entity )
					net.WriteType( options[ i ].attachtype )
					net.WriteType( options[ i ].attachment )
					net.WriteType( options[ i ].position )
					
				end
				
			end
			
		net.Broadcast()
		
	else
		
		local num = #self.CreatedParticles
		
		local mdls = {}
		
		for i = 1, #options do
			
			local option = options[ i ]
			
			if option.entity == nil then option.entity = self end
			
			if IsValid( option.entity ) == true and isstring( option.attachment ) == true then option.attachment = option.entity:LookupAttachment( option.attachment ) end
			
			if option.attachtype == PATTACH_POINT_FOLLOW and option.attachment != nil and IsValid( option.entity ) == true then
				
				local attach = option.entity:GetAttachment( option.attachment )
				local ang = Angle( 0, 0, 0 )
				if attach != nil and attach.Ang != nil then ang = attach.Ang end
				
				local mdl = ClientsideModel( "models/weapons/w_models/w_drg_ball.mdl" )
				mdl:SetNoDraw( true )
				mdl:SetPos( option.entity:GetPos() )
				mdl:SetAngles( ang )
				mdl:SetParent( option.entity, option.attachment )
				option.entity = mdl
				
				table.insert( mdls, mdl )
				
				option.attachtype = PATTACH_ABSORIGIN
				
			end
			
		end
		
		local newparticle = self:CreateParticleEffect( particle, options )
		
		for i = 1, #mdls do
			
			mdls[ i ].particle = newparticle
			
		end
		
		self.CreatedParticles[ num ] = {
			
			particle = newparticle,
			models = mdls,
			
		}
		
		return newparticle, num
		
	end
	
end

function ENT:GetParticle( id )
	
	return self.CreatedParticles[ id ]
	
end

function ENT:RemoveParticle( particletbl, force )
	
	local remove = {}
	
	local particle = particletbl.particle
	local models = particletbl.models
	
	if IsValid( particle ) == true then
		
		if force == true then
			
			particle:StopEmissionAndDestroyImmediately()
			
		else
			
			particle:StopEmission()
			
		end
		
	end
	
	if force == true then
		
		for i_ = 1, #models do
			
			if IsValid( models[ i_ ] ) == true then models[ i_ ]:Remove() end
			
		end
		
	end
	
end

function ENT:RemoveParticles( force )
	
	for i = 1, #self.CreatedParticles do
		
		self:RemoveParticle( self.CreatedParticles[ i ], force )
		if force == true then self.CreatedParticles[ i ] = nil end
		
	end
	
end

function ENT:HandleParticles()
	
	local remove = {}
	
	for i = 1, #self.CreatedParticles do
		
		local tbl = self.CreatedParticles[ i ]
		if IsValid( tbl.particle ) != true then
			
			self:RemoveParticle( tbl, true )
			table.insert( remove, i )
			
		end
		
	end
	
	for i = 1, #remove do
		
		table.remove( self.CreatedParticles, remove[ i ] )
		
	end
	
end

function ENT:Think()
	
	self:HandleParticles()
	
end

function ENT:Initialize()
	
	for _, v in pairs( self:GetParticles() ) do
		
		if isstring( v ) == true then PrecacheParticleSystem( v ) end
		
	end
	
	self:SetVariables()
	
end