TF2Weapons = {}

function TF2Weapons:GetItemsTable()
	
	if self.ItemsTable ~= nil then return self.ItemsTable end
	
	local f = file.Read( "scripts/items/items_game.txt", "GAME" )
	if f ~= nil then self.ItemsTable = util.KeyValuesToTable( f, false, true ) end
	
	return self.ItemsTable
	
end

AddCSLuaFile( "tf2weapons/mount.lua" )
AddCSLuaFile( "tf2weapons/language.lua" )

if SERVER then
	
	util.AddNetworkString( "tf2weapons_anim" )
	util.AddNetworkString( "tf2weapons_inspect" )
	util.AddNetworkString( "tf2weapons_addparticle" )
	
	net.Receive( "tf2weapons_inspect", function( len, ply )
		
		ply.TF2Weapons_Inspecting = net.ReadBool()
		
	end )
	
else
	
	include( "tf2weapons/mount.lua" )
	include( "tf2weapons/language.lua" )
	
	surface.CreateFont( "TF2Weapons_HudFontGiantBold", {
		
		font = "TF2 Build",
		size = 44 * ( ScrH() / 480 ),
		weight = 500,
		additive = false,
		antialias = true,
		
	} )
	
	surface.CreateFont( "TF2Weapons_SpectatorKeyHints", {
		
		font = "Verdana",
		size = 8 * ( ScrH() / 480 ),
		weight = 500,
		additive = false,
		antialias = true,
		
	} )
	
	/*
	surface.CreateFont( "TF2Weapons_Default", {
		
		font = "Verdana",
		size = 12 * ( ScrH() / 480 ),
		weight = 900,
		extended = true,
		
	} )
	*/
	
	surface.CreateFont( "TF2Weapons_Default", {
		
		font = "Verdana",
		size = 9 * ( ScrH() / 480 ),
		weight = 900,
		extended = true,
		
	} )
	
	surface.CreateFont( "TF2Weapons_HudFontSmall", {
		
		font = "TF2 Secondary",
		size = 14 * ( ScrH() / 480 ),
		weight = 500,
		additive = false,
		antialias = true,
		
	} )
	
	surface.CreateFont( "TF2Weapons_InfoPrimary", {
		
		font = "TF2 Build",
		size = 12 * ( ScrH() / 480 ),
		weight = 500,
		additive = false,
		antialias = true,
		
	} )
	
	surface.CreateFont( "TF2Weapons_InfoSecondary", {
		
		font = "TF2 Secondary",
		size = 11 * ( ScrH() / 480 ),
		weight = 500,
		additive = false,
		antialias = true,
		
	} )
	
	net.Receive( "tf2weapons_anim", function()
		
		net.ReadEntity():SetVMAnimation( net.ReadInt( 32 ), true )
		
	end )
	
	net.Receive( "tf2weapons_inspect", function()
		
		net.ReadEntity().TF2Weapons_Inspecting = net.ReadBool()
		
	end )
	
	net.Receive( "tf2weapons_addparticle", function()
		
		local weapon = net.ReadEntity()
		if IsValid( weapon ) ~= true then return end
		
		local particle = net.ReadString()
		
		local options = {}
		local amount = net.ReadInt( 32 )
		if amount > 0 then
			
			for i = 1, amount do
				
				options[ i ] = {
					
					entity = net.ReadType(),
					attachtype = net.ReadType(),
					attachment = net.ReadType(),
					position = net.ReadType(),
					
				}
				
			end
			
		end
		
		if weapon.AddParticle ~= nil then
			
			weapon:AddParticle( particle, options )
			
		end
		
	end )
	
	CreateClientConVar( "tf2weapons_class", "1", true, true, "1 = Scout, 2 = Soldier, 3 = Pyro, 4 = Demoman, 5 = Heavy, 6 = Engineer, 7 = Medic, 8 = Sniper, 9 = Spy" )
	
end

local meta = FindMetaTable( "Entity" )
function meta:TF2Weapons_SetAttribute( attribute, value, t, float )
	
	if t == nil then t = TypeID( value ) end
	
	if t == TYPE_ANGLE then
		
		self:SetNW2Angle( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_BOOL then
		
		self:SetNW2Bool( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_ENTITY then
		
		self:SetNW2Entity( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_NUMBER then
		
		if float ~= true then
			
			self:SetNW2Int( "TF2Weapons_Attribute_" .. attribute, value )
			
		else
			
			self:SetNW2Float( "TF2Weapons_Attribute_" .. attribute, value )
			
		end
		
	elseif t == TYPE_STRING then
		
		self:SetNW2String( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_VECTOR then
		
		self:SetNW2Vector( "TF2Weapons_Attribute_" .. attribute, value )
		
	end
	
end
function meta:TF2Weapons_GetAttribute( attribute, value, t, float )
	
	if t == nil then t = TypeID( value ) end
	
	if t == TYPE_ANGLE then
		
		return self:GetNW2Angle( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_BOOL then
		
		return self:GetNW2Bool( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_ENTITY then
		
		return self:GetNW2Entity( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_NUMBER then
		
		if float ~= true then
			
			return self:GetNW2Int( "TF2Weapons_Attribute_" .. attribute, value )
			
		else
			
			return self:GetNW2Float( "TF2Weapons_Attribute_" .. attribute, value )
			
		end
		
	elseif t == TYPE_STRING then
		
		return self:GetNW2String( "TF2Weapons_Attribute_" .. attribute, value )
		
	elseif t == TYPE_VECTOR then
		
		return self:GetNW2Vector( "TF2Weapons_Attribute_" .. attribute, value )
		
	end
	
end


concommand.Add( "+tf2weapons_inspect", function( ply )
	
	if IsValid( ply ) == false then return end
	
	ply.TF2Weapons_Inspecting = true
	
	if CLIENT then
		
		net.Start( "tf2weapons_inspect" )
			
			net.WriteBool( ply.TF2Weapons_Inspecting )
			
		net.SendToServer()
		
	else
		
		net.Start( "tf2weapons_inspect" )
			
			net.WriteEntity( ply )
			net.WriteBool( ply.TF2Weapons_Inspecting )
			
		net.Broadcast()
		
	end
	
end )

concommand.Add( "-tf2weapons_inspect", function( ply )
	
	if IsValid( ply ) == false then return end
	
	ply.TF2Weapons_Inspecting = false
	
	if CLIENT then
		
		net.Start( "tf2weapons_inspect" )
			
			net.WriteBool( ply.TF2Weapons_Inspecting )
			
		net.SendToServer()
		
	else
		
		net.Start( "tf2weapons_inspect" )
			
			net.WriteEntity( ply )
			net.WriteBool( ply.TF2Weapons_Inspecting )
			
		net.Broadcast()
		
	end
	
end )

hook.Add( "Initialize", "TF2Weapons_Initialize", function()
	
	for _, v in pairs( TF2Weapons.UnspawnableEntities ) do
		
		local unspawnablewep = weapons.GetStored( _ )
		if unspawnablewep ~= nil then unspawnablewep.Spawnable = false end
		
	end
	
	local level = GetConVar( "tf2weapons_allowbroke" ):GetInt()
	
	for _, v in pairs( TF2Weapons.BrokenEntities ) do
		
		local brokenwep = weapons.GetStored( _ )
		
		if brokenwep ~= nil then
			
			if level == 0 then
				
				--nobody can spawn
				brokenwep.Spawnable = false
				
			elseif level == 1 then
				
				--admins can spawn
				brokenwep.Spawnable = true
				brokenwep.AdminOnly = true
				
			else
				
				--all can spawn
				brokenwep.Spawnable = true
				brokenwep.AdminOnly = false
				
			end
			
		end
		
	end
	
end )

hook.Add( "PlayerGiveSWEP", "TF2Weapons_PlayerGiveSWEP", function( ply, weapon, swep )
	
	local level = GetConVar( "tf2weapons_allowbroke" ):GetInt()
	
	if TF2Weapons.UnspawnableEntities[ weapon ] == true then return false end
	
	if TF2Weapons.BrokenEntities[ weapon ] == true then
		
		if level == 0 then
			
			return false
			
		elseif level == 1 then
			
			return ply:IsAdmin()
			
		else
			
			return true
			
		end
		
	end
	
end )

hook.Add( "EntityTakeDamage", "TF2Weapons_EntityTakeDamage", function( ent, dmg )
	
	ent:SetNW2Float( "TF2Weapons_LastDamage", CurTime() )
	
end )

hook.Add( "ScalePlayerDamage", "TF2Weapons_ScalePlayerDamage", function( ply, hitgroup, dmg )
	
	local weapon = ply:GetActiveWeapon()
	
	if IsValid( weapon ) ~= true or weapon.TF2Weapon ~= true then return end
	
	local mult_dmgtaken = weapon:GetAttributeClass( "mult_dmgtaken" )
	if mult_dmgtaken ~= nil then dmg:ScaleDamage( mult_dmgtaken ) end
	
end )

hook.Add( "GetFallDamage", "TF2Weapons_GetFallDamage", function( ply, speed )
	
	local weapon = ply:GetActiveWeapon()
	
	if IsValid( weapon ) ~= true or weapon.TF2Weapon ~= true then return end
	
	local cancel_falling_damage = weapon:GetAttributeClass( "cancel_falling_damage" )
	if cancel_falling_damage ~= nil and cancel_falling_damage > 0 then return 0 end
	
end )

hook.Add( "Move", "TF2Weapons_Move", function( ply, mv )
	
	local weapon = ply:GetActiveWeapon()
	
	if IsValid( weapon ) ~= true or weapon.TF2Weapon ~= true then return end
	
	local mult_player_movespeed = weapon:GetAttributeClass( "mult_player_movespeed" )
	if mult_player_movespeed ~= nil then
		
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * mult_player_movespeed )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * mult_player_movespeed )
		
	end
	
end )

game.AddAmmoType( { name = "tf2weapons_shotgun", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_pistol", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_rifle", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_rocket", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_minigun", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_flamethrower", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_syringe", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_grenade", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_pipebomb", maxcarry = 200 } )
game.AddAmmoType( { name = "tf2weapons_metal", maxcarry = 200 } )

concommand.Add( "tf2weapons_printanims", function( ply )
	
	PrintTable( ply:GetViewModel( 1 ):GetSequenceList() )
	
end, nil, "Print animations for the hand model", FCVAR_CHEAT )

concommand.Add( "tf2weapons_printattach", function( ply )
	
	print( "\nhands\n" )
	PrintTable( ply:GetViewModel( 1 ):GetAttachments() )
	print( "\nweapon\n" )
	PrintTable( ply:GetViewModel( 0 ):GetAttachments() )
	
end, nil, "Print attachments for the hand model", FCVAR_CHEAT )

CreateConVar( "tf2weapons_criticals", 1, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Enable random critical hits" )
CreateConVar( "tf2weapons_allowbroke", 0, { FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE }, "Allow players to spawn broken/buggy/unoptimized/incomplete weapons and entities (<0 = values are unchanged, 0 = nobody can spawn, 1 = admins can spawn, >1 = all can spawn)" )
CreateConVar( "tf2weapons_overheal", 1, { FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE }, "Enable overheal" )



TF2Weapons.UnspawnableEntities = {
	
	[ "tf2weapons_base" ] = true,
	[ "tf2weapons_base_melee" ] = true,
	
}
TF2Weapons.BrokenEntities = {}

TF2Weapons.Color = {
	
	LEVEL = Color( 117, 107, 94, 255 ),
	POSITIVE = Color( 153, 204, 255, 255 ),
	NEUTRAL = Color( 235, 226, 202, 255 ),
	NEGATIVE = Color( 255, 64, 64, 255 ),
	
}

AddCSLuaFile( "tf2weapons/attributes.lua" )
include( "tf2weapons/attributes.lua" )

TF2Weapons.Class = {
	
	NONE = 0,
	SCOUT = 1,
	SOLDIER = 2,
	PYRO = 3,
	DEMOMAN = 4,
	HEAVY = 5,
	ENGINEER = 6,
	MEDIC = 7,
	SNIPER = 8,
	SPY = 9,
	
}

TF2Weapons.ClassHand = {
	
	[ TF2Weapons.Class.SCOUT ] = Model( "models/weapons/c_models/c_scout_arms.mdl" ),
	[ TF2Weapons.Class.SOLDIER ] = Model( "models/weapons/c_models/c_soldier_arms.mdl" ),
	[ TF2Weapons.Class.PYRO ] = Model( "models/weapons/c_models/c_pyro_arms.mdl" ),
	[ TF2Weapons.Class.DEMOMAN ] = Model( "models/weapons/c_models/c_demo_arms.mdl" ),
	[ TF2Weapons.Class.HEAVY ] = Model( "models/weapons/c_models/c_heavy_arms.mdl" ),
	[ TF2Weapons.Class.ENGINEER ] = Model( "models/weapons/c_models/c_engineer_arms.mdl" ),
	[ TF2Weapons.Class.MEDIC ] = Model( "models/weapons/c_models/c_medic_arms.mdl" ),
	[ TF2Weapons.Class.SNIPER ] = Model( "models/weapons/c_models/c_sniper_arms.mdl" ),
	[ TF2Weapons.Class.SPY ] = Model( "models/weapons/c_models/c_spy_arms.mdl" ),
	
}

TF2Weapons.Quality = {
	
	NORMAL = 0, --stock weapons
	RARITY1 = 1, --genuine weapons
	RARITY2 = 2, --??
	VINTAGE = 3, --vintage weapons
	RARITY3 = 4, --??
	RARITY4 = 5, --unusual weapons
	UNIQUE = 6, --unique weapons
	COMMUNITY = 7, --community weapons
	DEVELOPER = 8, --valve weapons
	SELFMADE = 9, --self made weapons
	CUSTOMIZED = 10, --??vintage weapons??
	STRANGE = 11, --strange weapons
	COMPLETED = 12, --??
	HAUNTED = 13, --haunted weapons
	COLLECTORS = 14, --collector's weapons
	PAINTKITWEAPON = 15, --painted weapons/weapons with skins
	
}

TF2Weapons.QualityColor = {
	
	[ TF2Weapons.Quality.NORMAL ] = Color( 178, 178, 178, 255 ),
	[ TF2Weapons.Quality.RARITY1 ] = Color( 77, 116, 85, 255 ),
	[ TF2Weapons.Quality.RARITY2 ] = Color( 141, 131, 75, 255 ),
	[ TF2Weapons.Quality.RARITY3 ] = Color( 204, 204, 250, 255 ),
	[ TF2Weapons.Quality.RARITY4 ] = Color( 134, 80, 172, 255 ),
	[ TF2Weapons.Quality.VINTAGE ] = Color( 71, 98, 145, 255 ),
	[ TF2Weapons.Quality.UNIQUE ] = Color( 255, 215, 0, 255 ),
	[ TF2Weapons.Quality.COMMUNITY ] = Color( 112, 176, 74, 255 ),
	[ TF2Weapons.Quality.DEVELOPER ] = Color( 165, 15, 121, 255 ),
	[ TF2Weapons.Quality.SELFMADE ] = Color( 112, 176, 74, 255 ),
	[ TF2Weapons.Quality.CUSTOMIZED ] = Color( 71, 98, 145, 255 ),
	[ TF2Weapons.Quality.STRANGE ] = Color( 207, 106, 50, 255 ),
	[ TF2Weapons.Quality.COMPLETED ] = Color( 134, 80, 172, 255 ),
	[ TF2Weapons.Quality.HAUNTED ] = Color( 56, 243, 171, 255 ),
	[ TF2Weapons.Quality.COLLECTORS ] = Color( 170, 0, 0, 255 ),
	[ TF2Weapons.Quality.PAINTKITWEAPON ] = Color( 250, 250, 250, 255 ),
	
}

TF2Weapons.QualityPrefix = {
	
	--[ TF2Weapons.Quality.NORMAL ] = "Normal",
	[ TF2Weapons.Quality.NORMAL ] = "",
	[ TF2Weapons.Quality.RARITY1 ] = "Genuine",
	[ TF2Weapons.Quality.RARITY2 ] = "",
	[ TF2Weapons.Quality.RARITY3 ] = "",
	[ TF2Weapons.Quality.RARITY4 ] = "Unusual",
	[ TF2Weapons.Quality.VINTAGE ] = "Vintage",
	--[ TF2Weapons.Quality.UNIQUE ] = "Unique",
	[ TF2Weapons.Quality.UNIQUE ] = "",
	[ TF2Weapons.Quality.COMMUNITY ] = "Community",
	[ TF2Weapons.Quality.DEVELOPER ] = "Valve",
	[ TF2Weapons.Quality.SELFMADE ] = "Self-Made",
	[ TF2Weapons.Quality.CUSTOMIZED ] = "Customized",
	[ TF2Weapons.Quality.STRANGE ] = "Strange",
	[ TF2Weapons.Quality.COMPLETED ] = "Completed",
	[ TF2Weapons.Quality.HAUNTED ] = "Haunted",
	[ TF2Weapons.Quality.COLLECTORS ] = "Collector's",
	--[ TF2Weapons.Quality.PAINTKITWEAPON ] = "Decorated Weapon",
	[ TF2Weapons.Quality.PAINTKITWEAPON ] = "",
	
}

TF2Weapons.Crosshair = {
	
	ALL = 0,
	DEFAULT = 1,
	CIRCLE = 2,
	BIGCIRCLE = 3,
	PLUS = 4,
	BIGPLUS = 5,
	
}

TF2Weapons.Building = {
	
	NONE = 0,
	SENTRY = 1,
	DISPENSER = 2,
	ENTRANCE = 3,
	EXIT = 4,
	
}

AddCSLuaFile( "tf2weapons/weapons.lua" )
include( "tf2weapons/weapons.lua" )

function TF2Weapons:GetCritChance( ply, weapon )
	
	local critchance = hook.Call( "TF2Weapons_CritChance", nil, ply, weapon )
	if critchance ~= nil then return critchance end
	
	if IsValid( weapon ) == true then
		
		if weapon.CritChance ~= nil then return weapon.CritChance end
		
	end
	
	return 0.025
	
end

function TF2Weapons:ShouldCrit( ply, weapon, target, chance )
	
	if chance == nil then chance = self:GetCritChance( ply, weapon ) end
	
	local shouldcrit = hook.Call( "TF2Weapons_ShouldCrit", nil, ply, weapon, target, chance )
	if shouldcrit ~= nil then return shouldcrit end
	
	if chance < 0 then return false end
	return util.SharedRandom( "crit", 0, 1, CurTime() ) <= chance
	
end

function TF2Weapons:OnCrit( ply, weapon, target )
	
	local oncrit = hook.Call( "TF2Weapons_OnCrit", nil, ply, weapon )
	if oncrit ~= nil then return oncrit end
	
	if GetConVar( "tf2weapons_criticals" ):GetBool() ~= true then return false end
	
end

function TF2Weapons:EntityKilled( ent, attacker, inflictor )
	
	if attacker:IsPlayer() ~= true then return end
	
	local weapon = attacker:GetActiveWeapon()
	
	if IsValid( weapon ) ~= true or weapon.TF2Weapon ~= true then return end
	
	local heal_on_kill = weapon:GetAttributeClass( "heal_on_kill" )
	if heal_on_kill ~= nil then weapon:GiveHealth( heal_on_kill, attacker, attacker:GetMaxHealth() ) end
	
	
end

hook.Add( "DoPlayerDeath", "TF2Weapons_DoPlayerDeath", function( ply, attacker, dmg )
	
	TF2Weapons:EntityKilled( ply, attacker, dmg:GetInflictor() )
	
end )

hook.Add( "OnNPCKilled", "TF2Weapons_OnNPCKilled", function( npc, attacker, inflictor )
	
	TF2Weapons:EntityKilled( npc, attacker, inflictor )
	
end )



--hooks for team based things

function TF2Weapons:TeleporterCanSend( teleporter, ent, ... )
	
	local teleportercansend = hook.Run( "TF2Weapons_TeleporterCanSend", teleporter, ent, ... )
	if teleportercansend ~= nil then return teleportercansend end
	
	local valid = true
	
	local teammates = GetConVar( "tf2weapons_teleporter_teammates" ):GetInt()
	if teammates ~= 2 then
		
		if teammates <= 0 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( teleporter:GetTFOwner() ) == D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", teleporter:GetTFOwner(), ent ) == true then valid = false end
			
		elseif teammates == 1 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( teleporter:GetTFOwner() ) ~= D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", teleporter:GetTFOwner(), ent ) ~= true then valid = false end
			
		elseif teammates >= 3 then
			
			valid = false
			
		end
		
	end
	
	if teleporter:GetTFOwner() == ent then valid = true end
	
	return valid
	
end

function TF2Weapons:SentryCanTarget( sentry, ent, ... )
	
	local sentrycantarget = hook.Run( "TF2Weapons_SentryCanTarget", sentry, ent, ... )
	if sentrycantarget ~= nil then return sentrycantarget end
	
	local valid = true
	
	local teammates = GetConVar( "tf2weapons_sentry_teammates" ):GetInt()
	if teammates ~= 2 then
		
		if teammates <= 0 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( sentry:GetTFOwner() ) == D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", sentry:GetTFOwner(), ent ) == true then valid = false end
			
		elseif teammates == 1 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( sentry:GetTFOwner() ) ~= D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", sentry:GetTFOwner(), ent ) ~= true then valid = false end
			
		elseif teammates >= 3 then
			
			valid = false
			
		end
		
	end
	
	if ent == sentry:GetTFOwner() then valid = true end
	if ent.GetTFOwner ~= nil and sentry:GetTFOwner() == ent:GetTFOwner() then valid = true end
	if ent:GetOwner() == sentry:GetTFOwner() then valid = true end
	
	return valid
	
end

function TF2Weapons:DispenserCanTarget( dispenser, ent, ... )
	
	local dispensercantarget = hook.Run( "TF2Weapons_DispenserCanTarget", dispenser, ent, ... )
	if dispensercantarget ~= nil then return dispensercantarget end
	
	local valid = true
	
	local teammates = GetConVar( "tf2weapons_dispenser_teammates" ):GetInt()
	if teammates ~= 2 then
		
		if teammates <= 0 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( dispenser:GetTFOwner() ) == D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", dispenser:GetTFOwner(), ent ) == true then valid = false end
			
		elseif teammates == 1 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( dispenser:GetTFOwner() ) ~= D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", dispenser:GetTFOwner(), ent ) ~= true then valid = false end
			
		elseif teammates >= 3 then
			
			valid = false
			
		end
		
	end
	
	if ent == dispenser:GetTFOwner() then valid = true end
	
	return valid
	
end

function TF2Weapons:EntityCanRepair( building, ent, ... )
	
	local entitycanrepair = hook.Run( "TF2Weapons_EntityCanRepair", building, ent, ... )
	if entitycanrepair ~= nil then return entitycanrepair end
	
	local valid = true
	
	local teammates = GetConVar( "tf2weapons_building_teammates" ):GetInt()
	if teammates ~= 2 then
		
		if teammates <= 0 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( building:GetTFOwner() ) == D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", building:GetTFOwner(), ent ) == true then valid = false end
			
		elseif teammates == 1 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( building:GetTFOwner() ) ~= D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", building:GetTFOwner(), ent ) ~= true then valid = false end
			
		elseif teammates >= 3 then
			
			valid = false
			
		end
		
	end
	
	if building:GetTFOwner() == ent then valid = true end
	
	return valid
	
end

function TF2Weapons:MediGunCanHeal( medigun, ent, ... )
	
	local mediguncanheal = hook.Run( "TF2Weapons_MediGunCanHeal", medigun, ent, ... )
	if mediguncanheal ~= nil then return mediguncanheal end
	
	local valid = true
	
	local teammates = GetConVar( "tf2weapons_heal_teammates" ):GetInt()
	if teammates ~= 2 then
		
		if teammates <= 0 then
			
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", medigun:GetOwner(), ent ) == true then valid = false end
			
		elseif teammates == 1 then
			
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", medigun:GetOwner(), ent ) ~= true then valid = false end
			
		end
		
	end
	
	return valid
	
end

function TF2Weapons:FlameThrowerCanIgnite( flamethrower, ent, ... )
	
	local valid = true
	
	local teammates = GetConVar( "tf2weapons_ignite_teammates" ):GetInt()
	if teammates ~= 2 then
		
		if teammates <= 0 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( flamethrower:GetOwner() ) ~= D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", flamethrower:GetOwner(), ent ) ~= true then valid = false end
			
		elseif teammates == 1 then
			
			if SERVER and ent:IsNPC() == true and ent:Disposition( flamethrower:GetOwner() ) == D_HT then valid = false end
			if ent:IsNPC() ~= true and hook.Run( "PlayerShouldTakeDamage", flamethrower:GetOwner(), ent ) == true then valid = false end
			
		end
		
	end
	
	return valid
	
end

function TF2Weapons:FlameThrowerCanAirblast( flamethrower, ent, ... )
	
	local flamethrowercanairblast = hook.Run( "TF2Weapons_FlameThrowerCanAirblast", flamethrower, ent, ... )
	if flamethrowercanairblast ~= nil then return flamethrowercanairblast end
	
	local valid = !ent:IsNPC()
	
	local teammates = GetConVar( "tf2weapons_airblast_teammates" ):GetInt()
	if teammates < 3 then
		
		if teammates <= 0 then
			
			if hook.Run( "PlayerShouldTakeDamage", flamethrower:GetOwner(), ent ) ~= true then valid = false end
			
		elseif teammates == 1 then
			
			if hook.Run( "PlayerShouldTakeDamage", flamethrower:GetOwner(), ent ) == true then valid = false end
			
		elseif teammates == 2 then
			
			valid = false
			
		end
		
	else
		
		valid = true
		
	end
	
	return valid
	
end