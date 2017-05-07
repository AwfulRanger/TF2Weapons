AddCSLuaFile()

if SERVER then
	
	util.AddNetworkString( "tf2weapons_building_upgrade" )
	util.AddNetworkString( "tf2weapons_building_insert" )
	util.AddNetworkString( "tf2weapons_building_remove" )
	
	concommand.Add( "tf2weapons_build", function( ply, cmd, args, arg )
		
		if ply:HasWeapon( "tf_weapon_pda_engineer_build" ) != true then return end
		local wep = ply:GetWeapon( "tf_weapon_pda_engineer_build" )
		if IsValid( wep ) != true then return end
		
		local toolbox = wep.Toolbox
		if toolbox == nil then toolbox = "tf_weapon_builder" end
		
		local builder = weapons.GetStored( toolbox )
		
		local build = tonumber( args[ 1 ] )
		local alt = tonumber( args[ 2 ] )
		
		local num = TF2Weapons.Building.SENTRY --sentry
		
		if build == 0 then --dispenser
			
			num = TF2Weapons.Building.DISPENSER
			
		elseif build == 1 then --teleporter
			
			if alt != nil and alt > 0 then --exit
				
				num = TF2Weapons.Building.EXIT
				
			else --entrance
				
				num = TF2Weapons.Building.ENTRANCE
				
			end
			
		end
		
		building = builder.Buildings[ num ]
		
		if building == nil or building.Cost > wep:Ammo1() then return end
		
		local plybuildings = ply.TF2Weapons_Buildings
		
		local id = 1
		
		if plybuildings == nil or plybuildings[ num ] == nil or #plybuildings[ num ] < building.Limit then
			
			if plybuildings != nil then
				
				if plybuildings[ num ] != nil then
					
					id = #plybuildings[ num ] + 1
					
				else
					
					plybuildings[ num ] = {}
					
				end
				
			else
				
				plybuildings = {}
				plybuildings[ num ] = {}
				
			end
			
			ply.TF2Weapons_Buildings = plybuildings
			
			local ent = ply:Give( toolbox )
			
			if IsValid( ent ) == true then
				
				ent:SetBuild( build, alt )
				ent:SetTFBuildID( id )
				
				ply:SetActiveWeapon( ent )
				
			end
			
		end
		
	end )
	
	concommand.Add( "tf2weapons_destroy", function( ply, cmd, args, arg )
		
		local build = tonumber( args[ 1 ] )
		local alt = tonumber( args[ 2 ] )
		
		local num = TF2Weapons.Building.SENTRY --sentry
		
		if build == 0 then --dispenser
			
			num = TF2Weapons.Building.DISPENSER
			
		elseif build == 1 then --teleporter
			
			if alt != nil and alt > 0 then --exit
				
				num = TF2Weapons.Building.EXIT
				
			else --entrance
				
				num = TF2Weapons.Building.ENTRANCE
				
			end
			
		end
		
		local plybuildings = ply.TF2Weapons_Buildings
		
		if plybuildings != nil and plybuildings[ num ] != nil then
			
			local building = plybuildings[ num ][ #plybuildings[ num ] ]
			if IsValid( building ) == true and building.OnDestroy != nil then building:OnDestroy() end
			
		end
		
	end )
	
	hook.Add( "PlayerDisconnect", "TF2Weapons_Buildings_PlayerDisconnect", function( ply )
		
		local plybuildings = ply.TF2Weapons_Buildings
		
		for _, v in pairs( plybuildings ) do
			
			for __, v_ in pairs( v ) do
				
				if IsValid( v_ ) == true then v_:OnDestroy() end
				
			end
			
		end
		
	end )
	
else
	
	net.Receive( "tf2weapons_building_upgrade", function()
		
		local ent = net.ReadEntity()
		local level = net.ReadInt( 32 )
		
		if IsValid( ent ) == true and ent.SetLevel != nil then
			
			ent:SetLevel( level )
			
		end
		
	end )
	
	net.Receive( "tf2weapons_building_insert", function()
		
		local ply = net.ReadEntity()
		local num = net.ReadInt( 32 )
		local build = net.ReadEntity()
		
		if IsValid( ply ) == true and num != nil then
			
			local plybuildings = ply.TF2Weapons_Buildings
			
			if plybuildings == nil then plybuildings = {} end
			if plybuildings[ num ] == nil then plybuildings[ num ] = {} end
			
			table.insert( plybuildings[ num ], build )
			
			ply.TF2Weapons_Buildings = plybuildings
			
		end
		
	end )
	
	net.Receive( "tf2weapons_building_remove", function()
		
		local ply = net.ReadEntity()
		local num = net.ReadInt( 32 )
		local valid = net.ReadBool()
		local key = net.ReadInt( 32 )
		local build = net.ReadEntity()
		
		if IsValid( ply ) != true or num == nil then return end
		
		local plybuildings = ply.TF2Weapons_Buildings
			
		if plybuildings == nil or num == nil or plybuildings[ num ] == nil then return end
		
		if valid == true then
			
			if key != nil then plybuildings[ num ][ key ] = nil end
			
		else
			
			if build != nil then table.RemoveByValue( plybuildings[ num ], build ) end
			
		end
		
		ply.TF2Weapons_Buildings = plybuildings
		
	end )
	
end

CreateConVar( "tf2weapons_repair_teammates", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "0 to prevent enemies from repairing buildings and teammates from damaging them, 1 for inverted" )

SWEP.Slot = 5
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 0
SWEP.KillIconW = 0
SWEP.KillIconH = 0

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_toolbox_large" ) end
SWEP.PrintName = "Toolbox"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Toolbox"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.ENGINEER ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_toolbox/c_toolbox.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_toolbox/c_toolbox.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_engineer_arms.mdl" )
SWEP.HoldType = "rpg"
function SWEP:GetAnimations()
	
	return "box"
	
end
function SWEP:GetInspect()
	
	return ""
	
end

SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_metal"

SWEP.Buildings = {
	
	[ TF2Weapons.Building.SENTRY ] = {
		
		Class = "obj_sentrygun",
		Name = "Sentry Gun",
		Model = Model( "models/buildables/sentry1_blueprint.mdl" ),
		Cost = 130,
		Icon = Material( "hud/eng_build_sentry_blueprint" ),
		
		IdleAnim = "idle",
		RejectAnim = "reject",
		
		Alternate = false,
		BuildArguments = { 2, 0 },
		DestroyArguments = { 2, 0 },
		
		Mins = Vector( -24, -24, 0 ),
		Maxs = Vector( 24, 24, 66 ),
		
		Mask = MASK_SOLID,
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.DISPENSER ] = {
		
		Class = "obj_dispenser",
		Name = "Dispenser",
		Model = Model( "models/buildables/dispenser_blueprint.mdl" ),
		Cost = 100,
		Icon = Material( "hud/eng_build_dispenser_blueprint" ),
		
		IdleAnim = "idle",
		RejectAnim = "reject",
		
		Alternate = false,
		BuildArguments = { 0, 0 },
		DestroyArguments = { 0, 0 },
		
		Mins = Vector( -20, -20, 0 ),
		Maxs = Vector( 20, 20, 55 ),
		
		Mask = MASK_SOLID,
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.ENTRANCE ] = {
		
		Class = "obj_teleporter",
		Name = "Entrance",
		Model = Model( "models/buildables/teleporter_blueprint_enter.mdl" ),
		Cost = 50,
		Icon = Material( "hud/eng_build_tele_entrance_blueprint" ),
		
		IdleAnim = "enter_idle",
		RejectAnim = "enter_reject",
		
		Alternate = false,
		BuildArguments = { 1, 0 },
		DestroyArguments = { 1, 0 },
		
		Mins = Vector( -24, -24, 0 ),
		Maxs = Vector( 24, 24, 95 ),
		
		Mask = MASK_PLAYERSOLID,
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.EXIT ] = {
		
		Class = "obj_teleporter",
		Name = "Exit",
		Model = Model( "models/buildables/teleporter_blueprint_exit.mdl" ),
		Cost = 50,
		Icon = Material( "hud/eng_build_tele_exit_blueprint" ),
		
		IdleAnim = "exit_idle",
		RejectAnim = "exit_reject",
		
		Alternate = true,
		BuildArguments = { 1, 1 },
		DestroyArguments = { 1, 1 },
		
		Mins = Vector( -24, -24, 0 ),
		Maxs = Vector( 24, 24, 95 ),
		
		Mask = MASK_PLAYERSOLID,
		
		Limit = 1,
		
	},
	
}

function SWEP:SetVariables()
	
	self.ShootSound = nil
	self.ShootSoundCrit = nil
	self.EmptySound = nil
	
end

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "String", "BuildClass", "obj_sentrygun" )
	
	self:TFNetworkVar( "Bool", "AltBuilding", false )
	
	self:TFNetworkVar( "Int", "BuildNum", 1 )
	self:TFNetworkVar( "Int", "BuildID", 0 )
	
	self:TFNetworkVar( "Angle", "BuildAngle", Angle( 0, 0, 0 ) )
	
end

function SWEP:SetBuild( build, alt )
	
	local a = false
	if alt != nil and alt > 0 then a = true end
	
	if build == 0 then --dispenser
		
		self:SetTFBuildClass( "obj_dispenser" )
		self:SetTFBuildNum( 2 )
		
	elseif build == 1 then --teleporter
		
		self:SetTFBuildClass( "obj_teleporter" )
		if a == true then
			
			self:SetTFBuildNum( 4 )
			
		else
			
			self:SetTFBuildNum( 3 )
			
		end
		
	else --sentry
		
		self:SetTFBuildClass( "obj_sentrygun" )
		self:SetTFBuildNum( 1 )
		
	end
	
	self:SetTFAltBuilding( a )
	
end

function SWEP:GetBuilding()
	
	return self.Buildings[ self:GetTFBuildNum() ]
	
end

function SWEP:GetBuildPosition()
	
	local aimang = Angle( 0, self:GetOwner():EyeAngles().yaw, self:GetOwner():EyeAngles().roll )
	local aimpos = aimang:Forward() * 96
	local pos = self:GetOwner():GetPos() + aimpos
	local building = self:GetBuilding()
	
	local tr = util.TraceLine( {
		
		start = pos + Vector( 0, 0, 32 ),
		endpos = pos - Vector( 0, 0, 32 ),
		mask = MASK_SOLID_BRUSHONLY,
		
	} )
	
	local z = tr.HitPos.z
	
	for right = -1, 1, 2 do
		
		for forward = -1, 1, 2 do
			
			local size = Vector( ( building.Maxs.x + 4 ) * right, ( building.Maxs.y + 4 ) * forward, -32 )
			
			local tr_ = util.TraceLine( {
				
				start = pos + Vector( 0, 0, 64 ),
				endpos = pos + size,
				mask = MASK_SOLID_BRUSHONLY,
				
			} )
			
			if tr_.HitPos.z > z then
				
				z = tr_.HitPos.z
				
			end
			
		end
		
	end
	
	z = z + 1
	
	return Vector( tr.HitPos.x, tr.HitPos.y, z )
	
end

function SWEP:GetBuildAngle()
	
	local aimang = Angle( 0, self:GetOwner():EyeAngles().yaw, self:GetOwner():EyeAngles().roll )
	
	return aimang + self:GetTFBuildAngle()
	
end

function SWEP:ValidBuildPosition( pos, ang, building )
	
	if pos == nil then pos = self:GetBuildPosition() end
	if ang == nil then ang = self:GetBuildAngle() end
	if building == nil then building = self:GetBuilding() end
	
	local hull = util.TraceHull( {
		
		start = pos,
		endpos = pos,
		mins = building.Mins,
		maxs = building.Maxs,
		mask = building.Mask,
		
	} )
	
	local valid = !hull.Hit
	
	for right = -1, 1, 2 do
		
		for forward = -1, 1, 2 do
			
			local size = Vector( building.Maxs.x * right, building.Maxs.y * forward, -8 )
			
			local tr = util.TraceLine( {
				
				start = pos + Vector( 0, 0, 8 ),
				endpos = pos + size,
				mask = MASK_SOLID_BRUSHONLY,
				
			} )
			
			if tr.Hit != true then valid = false end
			
		end
		
	end
	
	return valid
	
end

SWEP.GhostBuilding = nil

function SWEP:ManageGhostBuilding()
	
	if SERVER then return end
	
	local building = self:GetBuilding()
	
	if building == nil then return end
	
	if IsValid( self.GhostBuilding ) != true then
		
		self.GhostBuilding = ClientsideModel( building.Model )
		
	end
	if IsValid( self.GhostBuilding ) != true then return end
	
	if self.GhostBuilding:GetModel() != building.Model then self.GhostBuilding:SetModel( building.Model ) end
	
	self.GhostBuilding:SetPos( self:GetBuildPosition() )
	self.GhostBuilding:SetAngles( self:GetBuildAngle() )
	
	local seq = self.GhostBuilding:LookupSequence( building.IdleAnim )
	if self:ValidBuildPosition() != true then seq = self.GhostBuilding:LookupSequence( building.RejectAnim ) end
	
	self.GhostBuilding:SetSequence( seq )
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:SetTFLastOwner( self:GetOwner() )
	
	self:CheckHands()
	
	self:DoReload()
	
	self:Idle()
	
	self:HandleCritStreams()
	
	self:Inspect()
	
	self:ManageGhostBuilding()
	
end

function SWEP:SwitchAway( lastinv )
	
	if SERVER then
		
		self:Remove()
		
	else
		
		if lastinv == true then RunConsoleCommand( "lastinv" ) end
		
	end
	
end

function SWEP:Holster()
	
	self:DoHolster()
	
	self:SwitchAway( false )
	
	return true
	
end

function SWEP:Build()
	
	if CLIENT then return end
	
	local building = self:GetBuilding()
	
	if building == nil then return end
	
	local build = ents.Create( building.Class )
	
	if IsValid( build ) != true then return end
	
	build:SetPos( self:GetBuildPosition() )
	build:SetAngles( self:GetBuildAngle() )
	
	build:Spawn()
	
	build:SetTFBLU( self:GetTeam() )
	build:SetTFOwner( self:GetOwner() )
	build:SetTFBuildID( self:GetTFBuildID() )
	build:SetBuildAlt( building.Alternate )
	
	return build
	
end

function SWEP:PrimaryAttack()
	
	if self:ValidBuildPosition() == true and self:Ammo1() >= self:GetBuilding().Cost then
		
		local plybuildings = self:GetOwner().TF2Weapons_Buildings
		
		if plybuildings == nil then plybuildings = {} end
		if plybuildings[ self:GetTFBuildNum() ] == nil then plybuildings[ self:GetTFBuildNum() ] = {} end
		
		if #plybuildings[ self:GetTFBuildNum() ] < self:GetBuilding().Limit then
			
			self:TakePrimaryAmmo( self:GetBuilding().Cost )
			
			if SERVER then
				
				local build = self:Build()
				
				if IsValid( build ) == true then
					
					table.insert( plybuildings[ self:GetTFBuildNum() ], build )
					
					local owner = self:GetOwner()
					local num = self:GetTFBuildNum()
					
					timer.Simple( 0, function()
						
						if IsValid( owner ) != true or num == nil then return end
						
						net.Start( "tf2weapons_building_insert" )
							
							net.WriteEntity( owner )
							net.WriteInt( num, 32 )
							net.WriteEntity( build )
							
						net.Broadcast()
						
					end )
					
					self:GetOwner().TF2Weapons_Buildings = plybuildings
					
				end
				
			end
			
			self:SwitchAway( true )
			
		end
		
	end
	
end

function SWEP:SecondaryAttack()
	
	local ang = self:GetTFBuildAngle()
	ang:RotateAroundAxis( ang:Up(), 90 )
	self:SetTFBuildAngle( ang )
	
end

function SWEP:Reload()
end

function SWEP:OnRemove()
	
	if IsValid( self.GhostBuilding ) == true then self.GhostBuilding:Remove() end
	
	self:DoHolster()
	self:RemoveHands( self:GetTFLastOwner() )
	
end