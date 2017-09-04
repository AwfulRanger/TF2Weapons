AddCSLuaFile()

game.AddParticles( "particles/medicgun_beam.pcf" )

local ammotypes = 27 + #game.BuildAmmoTypes()
local metaltype = "tf2weapons_metal"

hook.Add( "OnEntityCreated", "TF2Weapons_Dispenser_InsertTargets", function( ent )
	
	timer.Simple( 0, function()
		
		if IsValid( ent ) != true then return end
		if TF2Weapons == nil then return end
		
		if TF2Weapons.DispenserTargets == nil then TF2Weapons.DispenserTargets = {} end
		
		if ( ent:Health() > 0 or ent:GetMaxHealth() > 0 ) and string.Left( ent:GetClass(), 5 ) != "prop_" then
			
			table.insert( TF2Weapons.DispenserTargets, ent )
			
		end
		
	end )
	
end )

hook.Add( "EntityRemoved", "TF2Weapons_Dispenser_RemoveTargets", function( ent )
	
	if TF2Weapons == nil then return end
	
	if TF2Weapons.DispenserTargets == nil then TF2Weapons.DispenserTargets = {} end
	
	if ( ent:Health() > 0 or ent:GetMaxHealth() > 0 ) and string.Left( ent:GetClass(), 5 ) != "prop_" then
		
		table.RemoveByValue( TF2Weapons.DispenserTargets, ent )
		
	end
	
end )

CreateConVar( "tf2weapons_dispenser_teammates", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, [[0 to allow dispenser to restock teammates and prevent it from restocking enemies
1 to prevent dispenser from restocking teammates and allow it to restock enemies
2 to allow dispenser to restock anyone
3 to prevent dispenser from restocking anyone but owner]] )

ENT.Base = "obj_base"
ENT.Type = "anim"
ENT.PrintName = "Dispenser"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.BuildMins = Vector( -20, -20, 0 )
ENT.BuildMaxs = Vector( 20, 20, 55 )

ENT.ExplodeSound = Sound( "weapons/dispenser_explode.wav" )

ENT.HealNonPlayers = false

ENT.IdleSound = Sound( "weapons/dispenser_idle.wav" )
ENT.GenerateSound = Sound( "weapons/dispenser_generate_metal.wav" )
ENT.HealSound = Sound( "weapons/dispenser_heal.wav" )

ENT.BeamRed = "dispenser_heal_red"
ENT.BeamBlue = "dispenser_heal_blue"

ENT.Range = 192
ENT.StartMetal = 25
ENT.MaxMetal = 400

ENT.Levels = {
	
	--level 1
	{
		
		Health = 150,
		UpgradeCost = 200,
		Model = Model( "models/buildables/dispenser_light.mdl" ),
		BuildModel = Model( "models/buildables/dispenser.mdl" ),
		BuildAnim = "build",
		BuildTime = 15,
		
		SkinRED = 0,
		SkinBLU = 1,
		
		Idle = "ref",
		
		Bodygroups = "000",
		BuildBodygroups = "000",
		
		Gibs = {
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib1.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib2.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib3.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib4.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib5.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
		},
		
		HealthRegen = 10,
		HealthRegenTime = 1,
		
		AmmoRegen = 0.2,
		AmmoRegenTime = 1,
		
		MetalRegen = 40,
		MetalRegenTime = 5,
		MetalGive = 40,
		
		
	},
	
	--level 2
	{
		
		Health = 180,
		UpgradeCost = 200,
		Model = Model( "models/buildables/dispenser_lvl2_light.mdl" ),
		BuildModel = Model( "models/buildables/dispenser_lvl2.mdl" ),
		BuildAnim = "upgrade",
		BuildTime = 3,
		
		SkinRED = 0,
		SkinBLU = 1,
		
		Idle = "ref",
		
		Bodygroups = "000",
		BuildBodygroups = "000",
		
		Gibs = {
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib1.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib2.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib3.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib4.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib5.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
		},
		
		HealthRegen = 15,
		HealthRegenTime = 1,
		
		AmmoRegen = 0.3,
		AmmoRegenTime = 1,
		
		MetalRegen = 50,
		MetalRegenTime = 5,
		MetalGive = 50,
		
	},
	
	--level 3
	{
		
		Health = 216,
		UpgradeCost = -1,
		Model = Model( "models/buildables/dispenser_lvl3_light.mdl" ),
		BuildModel = Model( "models/buildables/dispenser_lvl3.mdl" ),
		BuildAnim = "upgrade",
		BuildTime = 3,
		
		SkinRED = 0,
		SkinBLU = 1,
		
		Idle = "ref",
		
		Bodygroups = "000",
		BuildBodygroups = "000",
		
		Gibs = {
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib1.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib2.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib3.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib4.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
			{
				
				Model = Model( "models/buildables/gibs/dispenser_gib5.mdl" ),
				Scrap = 10,
				SkinRED = 0,
				SkinBLU = 1,
				
			},
			
		},
		
		HealthRegen = 20,
		HealthRegenTime = 1,
		
		AmmoRegen = 0.4,
		AmmoRegenTime = 1,
		
		MetalRegen = 60,
		MetalRegenTime = 5,
		MetalGive = 60,
		
	},
	
}

function ENT:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "SoundPlaying", false )
	self:TFNetworkVar( "Bool", "FirstMetal", true )
	
	self:TFNetworkVar( "Float", "LastHealthRegen", 0 )
	self:TFNetworkVar( "Float", "NextAmmoRegen", 0 )
	self:TFNetworkVar( "Float", "NextMetalRecharge", 0 )
	self:TFNetworkVar( "Float", "AddedHealth", 0 )
	
	self:TFNetworkVar( "Int", "Metal", 0 )
	
end

function ENT:GetBuildNum()
	
	return TF2Weapons.Building.DISPENSER
	
end

function ENT:Initialize()
	
	if self.BeamRed != nil then PrecacheParticleSystem( self.BeamRed ) end
	if self.BeamBlue != nil then PrecacheParticleSystem( self.BeamBlue ) end
	
end

ENT.TargetsCached = nil

function ENT:GetRegenTargets()
	
	if TF2Weapons == nil or TF2Weapons.DispenserTargets == nil then return end
	
	if self.TargetsCached != nil then return self.TargetsCached end
	
	local targetlist = TF2Weapons.DispenserTargets
	if self.HealNonPlayers != true then targetlist = player.GetAll() end
	
	local targets = {}
	
	for i = 1, #targetlist do
		
		local t = targetlist[ i ]
		
		if IsValid( t ) == true and t:Health() > 0 and ( self.HealNonPlayers == true or t:IsPlayer() == true ) then
			
			local dist = self:GetPos():Distance( t:GetPos() )
			
			local tr = util.TraceLine( {
				
				start = self:GetPos() + self:OBBCenter(),
				endpos = t:GetPos() + t:OBBCenter(),
				filter = self,
				
			} )
			
			if dist <= self.Range * 0.5 and tr.Entity == t then
				
				if TF2Weapons:DispenserCanTarget( self, t ) == true then table.insert( targets, t ) end
				
			end
			
		end
		
	end
	
	self.TargetsCached = targets
	
	return targets
	
end

function ENT:GiveTargetHealth( target, hp )
	
	local maxhealth = target:GetMaxHealth()
	local health = target:Health()
	
	if health < maxhealth then
		
		if health + hp > maxhealth then
			
			target:SetHealth( maxhealth )
			
		else
			
			target:SetHealth( health + hp )
			
		end
		
	end
	
end

function ENT:HandleHealthRegen()
	
	stats = self.Levels[ self:GetTFLevel() ]
	if stats == nil then return end
	
	local hp = ( stats.HealthRegen * ( CurTime() - self:GetTFLastHealthRegen() ) ) / stats.HealthRegenTime
	
	local health = self:GetTFAddedHealth() + ( hp )
	local healthfloor = math.floor( health )
	
	if healthfloor >= 1 then
		
		health = health - healthfloor
		
		if self:GetTFUpgrading() != true then
			
			local stats = self.Levels[ self:GetTFLevel() ]
			if stats == nil then return end
			
			local targets = self:GetRegenTargets()
			if targets != nil then
				
				for i = 1, #targets do
					
					if IsValid( targets[ i ] ) == true and targets[ i ]:Health() > 0 then
						
						self:GiveTargetHealth( targets[ i ], healthfloor )
						
					end
					
				end
				
			end
			
		end
		
	end
	
	self:SetTFAddedHealth( health )
	
	self:SetTFLastHealthRegen( CurTime() )
	
end

function ENT:GiveTargetAmmo( target )
	
	stats = self.Levels[ self:GetTFLevel() ]
	if stats == nil then return end
	
	for i = 1, ammotypes do
		
		if i != game.GetAmmoID( metaltype ) then
			
			local maxammo = game.GetAmmoMax( i )
			local ammo = target:GetAmmoCount( i )
			
			if ammo < maxammo then
				
				local giveammo = math.ceil( maxammo * stats.AmmoRegen )
				if ammo + giveammo > maxammo then giveammo = maxammo - ammo end
				
				target:SetAmmo( ammo + giveammo, i )
				
			end
			
		else
			
			local maxammo = game.GetAmmoMax( i )
			local ammo = target:GetAmmoCount( i )
			
			if ammo < maxammo then
				
				local giveammo = math.ceil( math.min( self:GetTFMetal(), stats.MetalGive ) )
				
				if ammo + giveammo > maxammo then giveammo = maxammo - ammo end
				
				target:SetAmmo( ammo + giveammo, i )
				self:TakeMetal( giveammo )
				
			end
			
		end
		
	end
	
end

function ENT:HandleAmmoRegen()
	
	if self:GetTFUpgrading() == true then return end
	
	stats = self.Levels[ self:GetTFLevel() ]
	if stats == nil then return end
	
	if CurTime() > self:GetTFNextAmmoRegen() then
		
		local targets = self:GetRegenTargets()
		if targets != nil then
			
			for i = 1, #targets do
				
				if IsValid( targets[ i ] ) == true and targets[ i ]:IsPlayer() == true then
					
					self:GiveTargetAmmo( targets[ i ] )
					
				end
				
			end
			
		end
		
		self:SetTFNextAmmoRegen( CurTime() + stats.AmmoRegenTime )
		
	end
	
end

function ENT:HandleRegen()
	
	if CLIENT then return end
	
	if self:GetTFUpgrading() != true then
		
		local targets = self:GetRegenTargets()
		if targets != nil then
			
			if #targets > 0 and self:GetTFSoundPlaying() != true then
				
				self:EmitSound( self.HealSound, nil, nil, nil, CHAN_ITEM )
				self:SetTFSoundPlaying( true )
				
			elseif #targets < 1 and self:GetTFSoundPlaying() == true then
				
				self:EmitSound( "null.wav", nil, nil, nil, CHAN_ITEM )
				self:SetTFSoundPlaying( false )
				
			end
			
		else
			
			self:EmitSound( "null.wav", nil, nil, nil, CHAN_ITEM )
			self:SetTFSoundPlaying( false )
			
		end
		
	end
	
	self:HandleHealthRegen()
	self:HandleAmmoRegen()
	self:HandleMetalRecharge()
	
end

function ENT:GiveMetal( metal )
	
	if self:GetTFFirstMetal() == true then
		
		self:SetTFMetal( self.StartMetal )
		self:SetTFFirstMetal( false )
		
	else
		
		local givemetal = self:GetTFMetal() + metal
		if self:GetTFMetal() + metal > self.MaxMetal then givemetal = self.MaxMetal end
		
		self:SetTFMetal( givemetal )
		
	end
	
end

function ENT:TakeMetal( metal )
	
	local takemetal = self:GetTFMetal() - metal
	if self:GetTFMetal() - metal < 0 then takemetal = 0 end
	
	self:SetTFMetal( takemetal )
	
end

function ENT:HandleMetalRecharge()
	
	if self:GetTFUpgrading() == true then return end
	
	stats = self.Levels[ self:GetTFLevel() ]
	if stats == nil then return end
	
	if CurTime() > self:GetTFNextMetalRecharge() then
		
		if self:GetTFMetal() < self.MaxMetal then self:EmitSound( self.GenerateSound ) end
		
		self:GiveMetal( stats.MetalRegen )
		
		self:SetTFNextMetalRecharge( CurTime() + stats.MetalRegenTime )
		
	end
	
end

ENT.BeamTargets = {}

function ENT:HandleBeam()
	
	if SERVER or self:GetTFUpgrading() == true then return end
	
	--check for beams not in targets
	--if so remove
	--check for targets not in beams
	--if so add
	
	local beamparticle = self.BeamRed
	if self:GetTFBLU() == true then beamparticle = self.BeamBlue end
	
	if beamparticle == nil or beamparticle == "" then return end
	
	local targets = table.Copy( self:GetRegenTargets() )
	local beams = self.BeamTargets
	local btargets = {}
	
	if targets != nil then
		
		for i = 1, #targets do
			
			local t = targets[ i ]
			
			if beams[ t ] == nil then
				
				local particle, num = self:AddParticle( beamparticle, {
					
					{
						
						attachtype = PATTACH_POINT_FOLLOW,
						attachment = "heal_origin",
						
					},
					
					{
						
						entity = t,
						attachtype = PATTACH_POINT_FOLLOW,
						attachment = "chest",
						
					},
					
				} )
				
				beams[ t ] = num
				
			end
			
			btargets[ t ] = true
			
		end
		
	end
	
	if beams != nil then
		
		for _, v in pairs( beams ) do
			
			if btargets[ _ ] != true then
				
				self:RemoveParticle( self:GetParticle( v ) )
				beams[ _ ] = nil
				
			end
			
		end
		
	end
	
end

function ENT:Think()
	
	self:HandleLevel()
	
	self:HandleUpgrade()
	
	self:HandleUpgradeHealth()
	
	self:HandleRegen()
	
	self:HandleBeam()
	
	local stats = self.Levels[ self:GetTFLevel() ]
	
	if self:GetTFUpgrading() != true and stats != nil then
		
		if stats.Idle != nil then self:SetSequence( stats.Idle ) end
		
	end
	
	self.TargetsCached = nil
	
	self:NextThink( CurTime() + 0.05 )
	return true
	
end

ENT.MeterBackgroundRed = Material( "vgui/dispenser_meter_bg_red" )
ENT.MeterBackgroundBlue = Material( "vgui/dispenser_meter_bg_blue" )
ENT.Meter = Material( "vgui/dispenser_meter_arrow" )

function ENT:Draw()
	
	self:DrawModel()
	
	if self:GetTFBuilding() == true then return end
	
	local bg = self.MeterBackgroundRed
	if self:GetTFBLU() == true then bg = self.MeterBackgroundBlue end
	
	local fpos = self:GetPos() + ( self:GetAngles():Forward() * 6.5 ) + ( self:GetAngles():Up() * 48 ) + ( self:GetAngles():Right() * 9 )
	local fang = self:GetAngles()
	fang:RotateAroundAxis( fang:Up(), 90 )
	fang:RotateAroundAxis( fang:Forward(), 90 )
	
	local minang = 80
	local midang = 0
	local maxang = -80
	local ang = minang
	
	if self:GetTFMetal() < self.MaxMetal * 0.5 then
		
		local percent = self:GetTFMetal() / ( self.MaxMetal * 0.5 )
		ang = Lerp( percent, minang, midang )
		
	else
		
		local percent = ( self:GetTFMetal() * 0.5 ) / ( self.MaxMetal * 0.5 )
		ang = Lerp( percent, midang, maxang )
		
	end
	
	local mult = 1
	if ang < 0 then mult = -1 end
	mult = ( ang / 90 ) * mult
	
	local w = 20
	local h = 90
	local x = ( ( -h ) * 0.5 ) * mult
	local y = w * mult
	
	if ang < 0 then x = ( ( h ) * 0.5 ) * mult end
	
	if mult > 0.5 or mult < -0.5 then y = y + ( 32 * ( mult - 0.5 ) ) end
	
	cam.Start3D2D( fpos, fang, 0.1 )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		surface.SetMaterial( bg )
		surface.DrawTexturedRect( 0, 0, 200, 110 )
		
		surface.SetMaterial( self.Meter )
		surface.DrawTexturedRectRotated( 100 + x, 65 + y, 20, 90, ang )
		
	cam.End3D2D()
	
	local bpos = self:GetPos() + ( self:GetAngles():Forward() * -6.5 ) + ( self:GetAngles():Up() * 48 ) + ( self:GetAngles():Right() * -11 )
	local bang = self:GetAngles()
	bang:RotateAroundAxis( bang:Up(), -90 )
	bang:RotateAroundAxis( bang:Forward(), 90 )
	
	cam.Start3D2D( bpos, bang, 0.1 )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		surface.SetMaterial( bg )
		surface.DrawTexturedRect( 0, 0, 200, 110 )
		
		surface.SetMaterial( self.Meter )
		surface.DrawTexturedRectRotated( 100 + x, 65 + y, 20, 90, ang )
		
	cam.End3D2D()
	
end