local projectilespeed = {
	
	"FlameStartSpeed",
	"FlameEndSpeed",
	"GrenadeSpeed",
	"PipebombSpeed",
	"PipebombSpeedCharged",
	"RocketSpeed",
	"SyringeSpeed",
	
}
local ownerhitmult = {
	
	"GrenadeOwnerHitMult",
	"PipebombOwnerHitMult",
	"RocketOwnerHitMult",
	
}

--[[
--template
TF2Weapons:AddAttribute( {
	
	id = ,
	name = "",
	desc = "",
	color = TF2Weapons.Color.,
	type = "",
	class = "",
	hidden = ,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		
		
		return values
		
	end,
	
} )
]]--
TF2Weapons:AddAttribute( {
	
	id = 1,
	name = "damage penalty",
	desc = "%s1% damage penalty",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_dmg",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Damage != nil then weapon.Primary.Damage = math.Round( weapon.Primary.Damage * values[ 1 ] ) end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 2,
	name = "damage bonus",
	desc = "+%s1% damage bonus",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_dmg",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Damage != nil then weapon.Primary.Damage = math.Round( weapon.Primary.Damage * values[ 1 ] ) end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 3,
	name = "clip size penalty",
	desc = "%s1% clip size",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_clipsize",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.ClipSize != nil then weapon.Primary.ClipSize = math.Round( weapon.Primary.ClipSize * values[ 1 ] ) end
		timer.Simple( 0, function() if IsValid( weapon ) == true then weapon:SetClip1( weapon.Primary.ClipSize ) end end )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 4,
	name = "clip size bonus",
	desc = "+%s1% clip size",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_clipsize",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.ClipSize != nil then
			
			weapon.Primary.ClipSize = math.Round( weapon.Primary.ClipSize * values[ 1 ] )
			timer.Simple( 0, function() if IsValid( weapon ) == true then weapon:SetClip1( weapon.Primary.ClipSize ) end end )
			
		end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 5,
	name = "fire rate penalty",
	desc = "%s1% slower firing speed",
	color = TF2Weapons.Color.NEGATIVE,
	type = "inverted_percentage",
	class = "mult_postfiredelay",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		weapon.Primary.Delay = weapon.Primary.Delay * values[ 1 ]
		--if weapon.Primary.HitDelay != nil then weapon.Primary.HitDelay = weapon.Primary.HitDelay * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 6,
	name = "fire rate bonus",
	desc = "+%s1% faster firing speed",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_postfiredelay",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		weapon.Primary.Delay = weapon.Primary.Delay * values[ 1 ]
		if weapon.Primary.HitDelay != nil then weapon.Primary.HitDelay = weapon.Primary.HitDelay * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 7,
	name = "heal rate penalty",
	desc = "%s1% heal rate",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_medigun_healrate",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.HPSInCombat != nil then weapon.Primary.HPSInCombat = weapon.Primary.HPSInCombat * values[ 1 ] end
		if weapon.Primary.HPSOutCombat != nil then weapon.Primary.HPSOutCombat = weapon.Primary.HPSOutCombat * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 8,
	name = "heal rate bonus",
	desc = "+%s1% heal rate",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_medigun_healrate",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.HPSInCombat != nil then weapon.Primary.HPSInCombat = weapon.Primary.HPSInCombat * values[ 1 ] end
		if weapon.Primary.HPSOutCombat != nil then weapon.Primary.HPSOutCombat = weapon.Primary.HPSOutCombat * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 9,
	name = "ubercharge rate penalty",
	desc = "%s1% ÜberCharge rate",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_medigun_uberchargerate",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Charge != nil then weapon.Primary.Charge = weapon.Primary.Charge * values[ 1 ] end
		if weapon.Primary.ChargeOverheal != nil then weapon.Primary.ChargeOverheal = weapon.Primary.ChargeOverheal * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 10,
	name = "ubercharge rate bonus",
	desc = "+%s1% ÜberCharge rate",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_medigun_uberchargerate",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Charge != nil then weapon.Primary.Charge = weapon.Primary.Charge * values[ 1 ] end
		if weapon.Primary.ChargeOverheal != nil then weapon.Primary.ChargeOverheal = weapon.Primary.ChargeOverheal * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 11,
	name = "overheal bonus",
	desc = "+%s1% max overheal",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_medigun_overheal_amount",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Overheal != nil then weapon.Primary.Overheal = weapon.Primary.Overheal * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 15,
	name = "crit mod disabled",
	desc = "No random critical hits",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_crit_chance",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.CritChance != nil then weapon.CritChance = weapon.CritChance * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 16,
	name = "heal on hit for rapidfire",
	desc = "On Hit: Gain up to +%s1 health",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "add_onhit_addhealth",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 20,
	name = "crit vs burning players",
	desc = "100% critical hit vs burning players",
	color = TF2Weapons.Color.POSITIVE,
	type = "or",
	class = "or_crit_vs_playercond",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 21,
	name = "dmg penalty vs nonburning",
	desc = "%s1% damage vs non-burning players",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_dmg_vs_nonburning",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 22,
	name = "no crit vs nonburning",
	desc = "No critical hits vs non-burning players",
	color = TF2Weapons.Color.NEGATIVE,
	type = "additive",
	class = "set_nocrit_vs_nonburning",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 23,
	name = "mod flamethrower push",
	desc = "No compression blast",
	color = TF2Weapons.Color.NEGATIVE,
	type = "additive",
	class = "set_flamethrower_push_disabled",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 24,
	name = "mod flamethrower back crit",
	desc = "100% critical hits from behind",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "set_flamethrower_back_crit",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 25,
	name = "hidden secondary max ammo penalty",
	desc = "",
	color = TF2Weapons.Color.NEUTRAL,
	type = "percentage",
	class = "mult_maxammo_secondary",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Secondary == nil then return values end
		
		if weapon.Secondary.DefaultClip != nil and weapon.Secondary.ClipSize != nil then
			
			timer.Simple( 0, function()
				
				if IsValid( weapon ) == true and weapon.Secondary != nil then
					
					local defaultclipsize = weapon.Secondary.DefaultClipSize or weapon.Secondary.ClipSize
					
					if SERVER and IsValid( weapon:GetOwner() ) == true and weapon.Secondary.Ammo != nil then weapon:GetOwner():RemoveAmmo( weapon.Secondary.DefaultClip - ( ( weapon.Secondary.DefaultClip - defaultclipsize ) * values[ 1 ] ) - defaultclipsize, weapon.Secondary.Ammo, true ) end
					weapon.Secondary.DefaultClip = weapon.Secondary.DefaultClip - ( ( weapon.Secondary.DefaultClip - defaultclipsize ) * ( values[ 1 ] - 1 ) )
					
				end
				
			end )
			
		end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 26,
	name = "max health additive bonus",
	desc = "+%s1 max health on wearer",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "add_maxhealth",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 28,
	name = "crit mod disabled hidden",
	desc = "No random critical hits",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_crit_chance",
	hidden = true,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.CritChance != nil then weapon.CritChance = weapon.CritChance * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 36,
	name = "spread penalty",
	desc = "%s1% less accurate",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_spread_scale",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Spread != nil then weapon.Primary.Spread = weapon.Primary.Spread * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 45,
	name = "bullets per shot bonus",
	desc = "+%s1% bullets per shot",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_bullets_per_shot",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Shots != nil then weapon.Primary.Shots = weapon.Primary.Shots * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 72,
	name = "weapon burn dmg reduced",
	desc = "%s1% afterburn damage penalty",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_wpn_burndmg",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.AfterburnDamage != nil then weapon.Primary.AfterburnDamage = weapon.Primary.AfterburnDamage * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 76,
	name = "maxammo primary increased",
	desc = "+%s1% max primary ammo on wearer",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_maxammo_primary",
	hidden = false,
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
	
} )
TF2Weapons:AddAttribute( {
	
	id = 77,
	name = "maxammo primary reduced",
	desc = "%s1% max primary ammo on wearer",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_maxammo_primary",
	hidden = false,
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
	
} )
TF2Weapons:AddAttribute( {
	
	id = 86,
	name = "minigun spinup time increased",
	desc = "%s1% slower spin up time",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_minigun_spinup_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.SpoolTime != nil then weapon.SpoolTime = weapon.SpoolTime * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 87,
	name = "minigun spinup time decreased",
	desc = "%s1% faster spin up time",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_minigun_spinup_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.SpoolTime != nil then weapon.SpoolTime = weapon.SpoolTime * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 92,
	name = "Construction rate increased",
	desc = "Construction hit speed boost increased by %s1%",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_construction_value",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.BuildConstructRateMult != nil then weapon.BuildConstructRateMult = weapon.BuildConstructRateMult * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 93,
	name = "Construction rate decreased",
	desc = "Construction hit speed boost decreased by %s1%",
	color = TF2Weapons.Color.NEGATIVE,
	type = "inverted_percentage",
	class = "mult_construction_value",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.BuildConstructRateMult != nil then weapon.BuildConstructRateMult = weapon.BuildConstructRateMult * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 94,
	name = "Repair rate increased",
	desc = "%s1% faster repair rate",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_repair_value",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.BuildRepairMult != nil then weapon.BuildRepairMult = weapon.BuildRepairMult * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 95,
	name = "Repair rate decreased",
	desc = "%s1% slower repair rate",
	color = TF2Weapons.Color.NEGATIVE,
	type = "inverted_percentage",
	class = "mult_repair_value",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.BuildRepairMult != nil then weapon.BuildRepairMult = weapon.BuildRepairMult * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 96,
	name = "Reload time increased",
	desc = "%s1% slower reload time",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_reload_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.ReloadSpeed != nil then weapon.ReloadSpeed = weapon.ReloadSpeed * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 97,
	name = "Reload time decreased",
	desc = "%s1% faster reload time",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_reload_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.ReloadSpeed != nil then weapon.ReloadSpeed = weapon.ReloadSpeed / values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 103,
	name = "Projectile speed increased",
	desc = "+%s1% projectile speed",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_projectile_speed",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		for i = 1, #projectilespeed do
			
			local v = projectilespeed[ i ]
			if weapon[ v ] != nil then weapon[ v ] = weapon[ v ] * values[ 1 ] end
			
		end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 104,
	name = "Projectile speed decreased",
	desc = "%s1% projectile speed",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_projectile_speed",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		for i = 1, #projectilespeed do
			
			local v = projectilespeed[ i ]
			if weapon[ v ] != nil then weapon[ v ] = weapon[ v ] * values[ 1 ] end
			
		end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 106,
	name = "weapon spread bonus",
	desc = "%s1% more accurate",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_spread_scale",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Primary == nil then return values end
		
		if weapon.Primary.Spread != nil then weapon.Primary.Spread = weapon.Primary.Spread * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 107,
	name = "move speed bonus",
	desc = "+%s1% faster move speed on wearer",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_player_movespeed",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 125,
	name = "max health additive penalty",
	desc = "%s1 max health on wearer",
	color = TF2Weapons.Color.NEGATIVE,
	type = "additive",
	class = "add_maxhealth",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 128,
	name = "provide on active",
	desc = "When weapon is active:",
	color = TF2Weapons.Color.NEUTRAL,
	type = "additive",
	class = "provide_on_active",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 135,
	name = "rocket jump damage reduction",
	desc = "%s1% blast damage from rocket jumps",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "rocket_jump_dmg_reduction",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		for i = 1, #ownerhitmult do
			
			local v = ownerhitmult[ i ]
			if weapon[ v ] != nil then weapon[ v ] = weapon[ v ] * values[ 1 ] end
			
		end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 137,
	name = "dmg bonus vs buildings",
	desc = "+%s1% damage vs buildings",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_dmg_vs_buildings",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 170,
	name = "airblast cost increased",
	desc = "+%s1% airblast cost",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_airblast_cost",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		if weapon.Secondary == nil then return values end
		
		if weapon.Secondary.TakeAmmo != nil then weapon.Secondary.TakeAmmo = weapon.Secondary.TakeAmmo * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 177,
	name = "deploy time increased",
	desc = "%s1% longer weapon switch",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_deploy_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.DeployTime != nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 178,
	name = "deploy time decreased",
	desc = "%s1% faster weapon switch",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_deploy_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.DeployTime != nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 180,
	name = "heal on kill",
	desc = "+%s1 health restored on kill",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "heal_on_kill",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 199,
	name = "switch from wep deploy time decreased",
	desc = "This weapon holsters %s1% faster",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_switch_from_wep_deploy_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.NextDeploySpeed != nil then weapon.NextDeploySpeed = weapon.NextDeploySpeed * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 217,
	name = "sanguisuge",
	desc = "On Backstab: Absorbs the health from your victim.",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "sanguisuge",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 224,
	name = "dmg bonus while half dead",
	desc = "%s1% increase in damage when health <50% of max",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mult_dmg_bonus_while_half_dead",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 225,
	name = "dmg penalty while half alive",
	desc = "%s1% decrease in damage when health >50% of max",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_dmg_penalty_while_half_alive",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 238,
	name = "minigun no spin sounds",
	desc = "Silent Killer: No barrel spin sound",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "minigun_no_spin_sounds",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 275,
	name = "cancel falling damage",
	desc = "Wearer never takes falling damage",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "cancel_falling_damage",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 281,
	name = "energy weapon no ammo",
	desc = "Does not require ammo",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "energy_weapon_no_ammo",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if values[ 1 ] >= 1 then weapon.ReloadTakeAmmo = 0 end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 356,
	name = "airblast disabled",
	desc = "No airblast",
	color = TF2Weapons.Color.NEGATIVE,
	type = "additive",
	class = "airblast_disabled",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 412,
	name = "dmg taken increased",
	desc = "%s1% damage vulnerability on wearer",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_dmgtaken",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 524,
	name = "increased jump height from weapon",
	desc = "+%s1% greater jump height when active",
	color = TF2Weapons.Color.POSITIVE,
	type = "percentage",
	class = "mod_jump_height_from_weapon",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 547,
	name = "single wep deploy time decreased",
	desc = "This weapon deploys %s1% faster",
	color = TF2Weapons.Color.POSITIVE,
	type = "inverted_percentage",
	class = "mult_single_wep_deploy_time",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.DeployTime != nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 775,
	name = "dmg penalty vs buildings",
	desc = "%s1% damage penalty vs buildings",
	color = TF2Weapons.Color.NEGATIVE,
	type = "percentage",
	class = "mult_dmg_vs_buildings",
	hidden = false,
	func = function( weapon, values )
		
		return values
		
	end,
	
} )
TF2Weapons:AddAttribute( {
	
	id = 783,
	name = "extinguish restores health",
	desc = "Extinguishing teammates restores %s1 health",
	color = TF2Weapons.Color.POSITIVE,
	type = "additive",
	class = "extinguish_restores_health",
	hidden = false,
	func = function( weapon, values )
		
		if values[ 1 ] == nil or IsValid( weapon ) != true then return values end
		
		if weapon.ExtinguishHealth != nil then weapon.ExtinguishHealth = weapon.ExtinguishHealth + values[ 1 ] end
		
		return values
		
	end,
	
} )