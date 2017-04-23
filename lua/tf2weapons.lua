if SERVER then
	
	util.AddNetworkString( "tf2weapons_anim" )
	util.AddNetworkString( "tf2weapons_inspect" )
	util.AddNetworkString( "tf2weapons_addparticle" )
	
	net.Receive( "tf2weapons_inspect", function( len, ply )
		
		ply.TF2Weapons_Inspecting = net.ReadBool()
		
	end )
	
else
	
	game.AddParticles( "particles/muzzle_flash.pcf" )
	
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
		if IsValid( weapon ) != true then return end
		local ent = net.ReadEntity()
		local particle = net.ReadString()
		local attachment = net.ReadInt( 32 )
		local pattach = net.ReadInt( 32 )
		
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
		
		/*
		local newparticle = ent:CreateParticleEffect( particle, attachment )
		for i = 0, #options - 1 do
			
			local option = options[ i ]
			
			newparticle:AddControlPoint( i, option.ent, option.pattach, option.attach, option.offset )
			
		end
		*/
		
		if weapon.AddParticle != nil then
			
			weapon:AddParticle( particle, attachment, ent, pattach, options, true )
			
		end
		
	end )
	
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
		
		if float != true then
			
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
		
		if float != true then
			
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
		if unspawnablewep != nil then unspawnablewep.Spawnable = false end
		
	end
	
	local level = GetConVar( "tf2weapons_allowbroke" ):GetInt()
	
	for _, v in pairs( TF2Weapons.BrokenEntities ) do
		
		local brokenwep = weapons.GetStored( _ )
		
		if brokenwep != nil then
			
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
	
	if IsValid( weapon ) != true or weapon.TF2Weapon != true then return end
	
	if weapon:GetAttributeClass( "mult_dmgtaken" ) != nil then dmg:ScaleDamage( weapon:GetAttributeClass( "mult_dmgtaken" ) ) end
	
end )

hook.Add( "GetFallDamage", "TF2Weapons_GetFallDamage", function( ply, speed )
	
	local weapon = ply:GetActiveWeapon()
	
	if IsValid( weapon ) != true or weapon.TF2Weapon != true then return end
	
	if weapon:GetAttributeClass( "cancel_falling_damage" ) != nil and weapon:GetAttributeClass( "cancel_falling_damage" ) > 0 then return 0 end
	
end )

hook.Add( "DoPlayerDeath", "TF2Weapons_DoPlayerDeath", function( ply, attacker, dmg )
	
	if attacker:IsPlayer() != true then return end
	
	local weapon = attacker:GetActiveWeapon()
	
	if IsValid( weapon ) != true or weapon.TF2Weapon != true then return end
	
	if weapon:GetAttributeClass( "heal_on_kill" ) != nil then
		
		if attacker:Health() < attacker:GetMaxHealth() then
			
			local health = attacker:Health() + weapon:GetAttributeClass( "heal_on_kill" )
			if health > attacker:GetMaxHealth() then health = attacker:GetMaxHealth() end
			attacker:SetHealth( health )
			
		end
		
	end
	
end )

hook.Add( "Move", "TF2Weapons_Move", function( ply, mv )
	
	local weapon = ply:GetActiveWeapon()
	
	if IsValid( weapon ) != true or weapon.TF2Weapon != true then return end
	
	if weapon:GetAttributeClass( "mult_player_movespeed" ) != nil then
		
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * weapon:GetAttributeClass( "mult_player_movespeed" ) )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * weapon:GetAttributeClass( "mult_player_movespeed" ) )
		
	end
	
end )

game.AddAmmoType( { name = "tf2weapons_shotgun" } )
game.AddAmmoType( { name = "tf2weapons_pistol" } )
game.AddAmmoType( { name = "tf2weapons_rifle" } )
game.AddAmmoType( { name = "tf2weapons_rocket" } )
game.AddAmmoType( { name = "tf2weapons_minigun" } )
game.AddAmmoType( { name = "tf2weapons_flamethrower" } )
game.AddAmmoType( { name = "tf2weapons_syringe" } )
game.AddAmmoType( { name = "tf2weapons_grenade" } )
game.AddAmmoType( { name = "tf2weapons_pipebomb" } )

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

TF2Weapons = {}

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

TF2Weapons.Attributes = {}
TF2Weapons.AttributesName = {}

function TF2Weapons:AddAttribute( id, name, desc, color, type, class, func )
	
	if istable( id ) == true then
		
		TF2Weapons.Attributes[ id.id ] = id
		TF2Weapons.AttributesName[ id.name ] = id
		
	else
		
		local attribute = {
			
			id = id,
			name = name,
			desc = desc,
			color = color,
			type = type,
			class = class,
			func = func,
			
		}
		
		TF2Weapons.Attributes[ attribute.id ] = attribute
		TF2Weapons.AttributesName[ attribute.name ] = attribute
		
	end
	
end

function TF2Weapons:GetAttribute( id )
	
	if TF2Weapons.Attributes[ id ] != nil then return TF2Weapons.Attributes[ id ] end
	if TF2Weapons.AttributesName[ id ] != nil then return TF2Weapons.AttributesName[ id ] end
	
end

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

function TF2Weapons:GetCritChance( ply, weapon )
	
	local critchance = hook.Call( "TF2Weapons_CritChance", nil, ply, weapon )
	if critchance != nil then return critchance end
	
	if IsValid( weapon ) == true then
		
		if weapon.CritChance != nil then return weapon.CritChance end
		
	end
	
	return 0.025
	
end

function TF2Weapons:ShouldCrit( ply, weapon, target, chance )
	
	if chance == nil then chance = self:GetCritChance( ply, weapon ) end
	
	local shouldcrit = hook.Call( "TF2Weapons_ShouldCrit", nil, ply, weapon, target, chance )
	if shouldcrit != nil then return shouldcrit end
	
	if chance < 0 then return false end
	return util.SharedRandom( "crit", 0, 1, CurTime() ) <= chance
	
end

function TF2Weapons:OnCrit( ply, weapon, target )
	
	local oncrit = hook.Call( "TF2Weapons_OnCrit", nil, ply, weapon )
	if oncrit != nil then return oncrit end
	
	if GetConVar( "tf2weapons_criticals" ):GetBool() != true then return false end
	
end