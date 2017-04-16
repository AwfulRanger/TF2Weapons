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

TF2Weapons.Attributes = {
	
	--[[
	--template
	[  ] = {
		
		name = "",
		desc = "",
		color = TF2Weapons.Color.,
		type = "",
		class = "",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			return values
			
		end,
		
	},
	]]--
	
	[ 1 ] = {
		
		name = "damage penalty",
		desc = "%s1% damage penalty",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_dmg",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Damage != nil then weapon.Primary.Damage = math.Round( weapon.Primary.Damage * values[ 1 ] ) end
			
			return values
			
		end,
		
	},
	[ 2 ] = {
		
		name = "damage bonus",
		desc = "+%s1% damage bonus",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_dmg",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Damage != nil then weapon.Primary.Damage = math.Round( weapon.Primary.Damage * values[ 1 ] ) end
			
			return values
			
		end,
		
	},
	[ 3 ] = {
		
		name = "clip size penalty",
		desc = "%s1% clip size",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_clipsize",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.ClipSize != nil then weapon.Primary.ClipSize = math.Round( weapon.Primary.ClipSize * values[ 1 ] ) end
			timer.Simple( 0, function() if IsValid( weapon ) == true then weapon:SetClip1( weapon.Primary.ClipSize ) end end )
			
			return values
			
		end,
		
	},
	[ 4 ] = {
		
		name = "clip size bonus",
		desc = "+%s1% clip size",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_clipsize",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.ClipSize != nil then
				
				weapon.Primary.ClipSize = math.Round( weapon.Primary.ClipSize * values[ 1 ] )
				timer.Simple( 0, function() if IsValid( weapon ) == true then weapon:SetClip1( weapon.Primary.ClipSize ) end end )
				
			end
			
			return values
			
		end,
		
	},
	[ 5 ] = {
		
		name = "fire rate penalty",
		desc = "%s1% slower firing speed",
		color = TF2Weapons.Color.NEGATIVE,
		type = "inverted_percentage",
		class = "mult_postfiredelay",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			weapon.Primary.Delay = weapon.Primary.Delay * values[ 1 ]
			--if weapon.Primary.HitDelay != nil then weapon.Primary.HitDelay = weapon.Primary.HitDelay * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 6 ] = {
		
		name = "fire rate bonus",
		desc = "+%s1% faster firing speed",
		color = TF2Weapons.Color.POSITIVE,
		type = "inverted_percentage",
		class = "mult_postfiredelay",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			weapon.Primary.Delay = weapon.Primary.Delay * values[ 1 ]
			if weapon.Primary.HitDelay != nil then weapon.Primary.HitDelay = weapon.Primary.HitDelay * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 7 ] = {
		
		name = "heal rate penalty",
		desc = "%s1% heal rate",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_medigun_healrate",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.HPSInCombat != nil then weapon.Primary.HPSInCombat = weapon.Primary.HPSInCombat * values[ 1 ] end
			if weapon.Primary.HPSOutCombat != nil then weapon.Primary.HPSOutCombat = weapon.Primary.HPSOutCombat * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 8 ] = {
		
		name = "heal rate bonus",
		desc = "+%s1% heal rate",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_medigun_healrate",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.HPSInCombat != nil then weapon.Primary.HPSInCombat = weapon.Primary.HPSInCombat * values[ 1 ] end
			if weapon.Primary.HPSOutCombat != nil then weapon.Primary.HPSOutCombat = weapon.Primary.HPSOutCombat * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 9 ] = {
		
		name = "ubercharge rate penalty",
		desc = "%s1% ÜberCharge rate",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_medigun_uberchargerate",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Charge != nil then weapon.Primary.Charge = weapon.Primary.Charge * values[ 1 ] end
			if weapon.Primary.ChargeOverheal != nil then weapon.Primary.ChargeOverheal = weapon.Primary.ChargeOverheal * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 10 ] = {
		
		name = "ubercharge rate bonus",
		desc = "+%s1% ÜberCharge rate",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_medigun_uberchargerate",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Charge != nil then weapon.Primary.Charge = weapon.Primary.Charge * values[ 1 ] end
			if weapon.Primary.ChargeOverheal != nil then weapon.Primary.ChargeOverheal = weapon.Primary.ChargeOverheal * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 11 ] = {
		
		name = "overheal bonus",
		desc = "+%s1% max overheal",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_medigun_overheal_amount",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Overheal != nil then weapon.Primary.Overheal = weapon.Primary.Overheal * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 36 ] = {
		
		name = "spread penalty",
		desc = "%s1% less accurate",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_spread_scale",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Spread != nil then weapon.Primary.Spread = weapon.Primary.Spread * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 45 ] = {
		
		name = "bullets per shot bonus",
		desc = "+%s1% bullets per shot",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_bullets_per_shot",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Shots != nil then weapon.Primary.Shots = weapon.Primary.Shots * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 72 ] = {
		
		name = "weapon burn dmg reduced",
		desc = "%s1% afterburn damage penalty",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_wpn_burndmg",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.AfterburnDamage != nil then weapon.Primary.AfterburnDamage = weapon.Primary.AfterburnDamage * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 76 ] = {
		
		name = "maxammo primary increased",
		desc = "+%s1% max primary ammo on wearer",
		color = TF2Weapons.Color.POSITIVE,
		type = "percentage",
		class = "mult_maxammo_primary",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.DefaultClip != nil and weapon.Primary.ClipSize != nil then
				
				timer.Simple( 0, function()
					
					if IsValid( weapon ) == true and weapon.Primary != nil then
						
						local defaultclipsize = weapon.Primary.DefaultClipSize or weapon.Primary.ClipSize
						
						if SERVER and IsValid( weapon:GetOwner() ) == true and weapon.Primary.Ammo != nil then weapon:GetOwner():GiveAmmo( ( weapon.Primary.DefaultClip * ( values[ 1 ] - 1 ) ) - defaultclipsize, weapon.Primary.Ammo, true ) end
						weapon.Primary.DefaultClip = weapon.Primary.DefaultClip + ( ( weapon.Primary.DefaultClip - defaultclipsize ) * ( values[ 1 ] - 1 ) )
						
					end
					
				end )
				
			end
			
			return values
			
		end,
		
	},
	[ 77 ] = {
		
		name = "maxammo primary reduced",
		desc = "%s1% max primary ammo on wearer",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_maxammo_primary",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.DefaultClip != nil and weapon.Primary.ClipSize != nil then
				
				timer.Simple( 0, function()
					
					if IsValid( weapon ) == true and weapon.Primary != nil then
						
						local defaultclipsize = weapon.Primary.DefaultClipSize or weapon.Primary.ClipSize
						
						if SERVER and IsValid( weapon:GetOwner() ) == true and weapon.Primary.Ammo != nil then weapon:GetOwner():RemoveAmmo( weapon.Primary.DefaultClip - ( ( weapon.Primary.DefaultClip - defaultclipsize ) * values[ 1 ] ) - defaultclipsize, weapon.Primary.Ammo, true ) end
						weapon.Primary.DefaultClip = weapon.Primary.DefaultClip - ( ( weapon.Primary.DefaultClip - defaultclipsize ) * ( values[ 1 ] - 1 ) )
						
					end
					
				end )
				
			end
			
			return values
			
		end,
		
	},
	[ 96 ] = {
		
		name = "Reload time increased",
		desc = "%s1% slower reload time",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_reload_time",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.ReloadSpeed != nil then weapon.ReloadSpeed = weapon.ReloadSpeed * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 97 ] = {
		
		name = "Reload time decreased",
		desc = "%s1% faster reload time",
		color = TF2Weapons.Color.POSITIVE,
		type = "inverted_percentage",
		class = "mult_reload_time",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.ReloadSpeed != nil then weapon.ReloadSpeed = weapon.ReloadSpeed / values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 106 ] = {
		
		name = "weapon spread bonus",
		desc = "%s1% more accurate",
		color = TF2Weapons.Color.POSITIVE,
		type = "inverted_percentage",
		class = "mult_spread_scale",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Primary == nil then return values end
			
			if weapon.Primary.Spread != nil then weapon.Primary.Spread = weapon.Primary.Spread * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 170 ] = {
		
		name = "airblast cost increased",
		desc = "+%s1% airblast cost",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_airblast_cost",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			if weapon.Secondary == nil then return values end
			
			if weapon.Secondary.TakeAmmo != nil then weapon.Secondary.TakeAmmo = weapon.Secondary.TakeAmmo * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 177 ] = {
		
		name = "deploy time increased",
		desc = "%s1% longer weapon switch",
		color = TF2Weapons.Color.NEGATIVE,
		type = "percentage",
		class = "mult_deploy_time",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			if weapon.DeployTime != nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 178 ] = {
		
		name = "deploy time decreased",
		desc = "%s1% faster weapon switch",
		color = TF2Weapons.Color.POSITIVE,
		type = "inverted_percentage",
		class = "mult_deploy_time",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			if weapon.DeployTime != nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 199 ] = {
		
		name = "switch from wep deploy time decreased",
		desc = "This weapon holsters %s1% faster",
		color = TF2Weapons.Color.POSITIVE,
		type = "inverted_percentage",
		class = "mult_switch_from_wep_deploy_time",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			if weapon.NextDeploySpeed != nil then weapon.NextDeploySpeed = weapon.NextDeploySpeed * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 281 ] = {
		
		name = "energy weapon no ammo",
		desc = "Does not require ammo",
		color = TF2Weapons.Color.POSITIVE,
		type = "additive",
		class = "energy_weapon_no_ammo",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			if values[ 1 ] >= 1 then weapon.ReloadTakeAmmo = 0 end
			
			return values
			
		end,
		
	},
	[ 547 ] = {
		
		name = "single wep deploy time decreased",
		desc = "This weapon deploys %s1% faster",
		color = TF2Weapons.Color.POSITIVE,
		type = "inverted_percentage",
		class = "mult_single_wep_deploy_time",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			if weapon.DeployTime != nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
			
			return values
			
		end,
		
	},
	[ 783 ] = {
		
		name = "extinguish restores health",
		desc = "Extinguishing teammates restores %s1 health",
		color = TF2Weapons.Color.POSITIVE,
		type = "additive",
		class = "extinguish_restores_health",
		func = function( weapon, values )
			
			if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
			
			if weapon.ExtinguishHealth != nil then weapon.ExtinguishHealth = weapon.ExtinguishHealth + values[ 1 ] end
			
			return values
			
		end,
		
	},
	
}

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

function TF2Weapons:ShouldCrit( ply, weapon, chance )
	
	if chance == nil then chance = self:CritChance( ply, weapon ) end
	
	local shouldcrit = hook.Call( "TF2Weapons_ShouldCrit", nil, ply, weapon, chance )
	if shouldcrit != nil then return shouldcrit end
	
	if chance < 0 then return false end
	return util.SharedRandom( "crit", 0, 1, CurTime() ) <= chance
	
end

function TF2Weapons:OnCrit( ply, weapon )
	
	local oncrit = hook.Call( "TF2Weapons_OnCrit", nil, ply, weapon )
	if oncrit != nil then return oncrit end
	
	if GetConVar( "tf2weapons_criticals" ):GetBool() != true then return false end
	
end