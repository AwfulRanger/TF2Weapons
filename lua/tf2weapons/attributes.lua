TF2Weapons.Attributes = {}
TF2Weapons.AttributesName = {}

function TF2Weapons:AddAttribute( id, name, desc, color, type, class, func )
	
	if istable( id ) == true then
		
		self.Attributes[ id.id ] = id
		self.AttributesName[ id.name ] = id
		
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
		
		self.Attributes[ attribute.id ] = attribute
		self.AttributesName[ attribute.name ] = attribute
		
	end
	
end

function TF2Weapons:AddAttributeID( id, func )
	
	local items = self:GetItemsTable()
	if items == nil then return end
	local attributes = items.attributes
	if attributes == nil then return end
	local attribute = attributes[ id ]
	if attribute == nil then return end
	
	local t = attribute.description_format
	if string.StartWith( t, "value_is_" ) == true then t = string.Right( t, #t - 9 ) end
	
	self:AddAttribute( {
		
		id = id,
		name = attribute.name or "",
		desc = attribute.description_string or "",
		color = self.Color[ string.upper( attribute.effect_type or "" ) ] or self.Color.NEUTRAL,
		type = t,
		class = attribute.attribute_class,
		func = func,
		
	} )
	
end

function TF2Weapons:GetAttribute( id )
	
	if self.Attributes[ id ] ~= nil then return self.Attributes[ id ] end
	if self.AttributesName[ id ] ~= nil then return self.AttributesName[ id ] end
	
end



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

--damage penalty
TF2Weapons:AddAttributeID( 1, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Damage ~= nil then weapon.Primary.Damage = math.Round( weapon.Primary.Damage * values[ 1 ] ) end
	
	return values
	
end )
--damage bonus
TF2Weapons:AddAttributeID( 2, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Damage ~= nil then weapon.Primary.Damage = math.Round( weapon.Primary.Damage * values[ 1 ] ) end
	
	return values
	
end )
--clip size penalty
TF2Weapons:AddAttributeID( 3, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.ClipSize ~= nil then weapon.Primary.ClipSize = math.Round( weapon.Primary.ClipSize * values[ 1 ] ) end
	timer.Simple( 0, function() if IsValid( weapon ) == true then weapon:SetClip1( weapon.Primary.ClipSize ) end end )
	
	return values
	
end )
--clip size bonus
TF2Weapons:AddAttributeID( 4, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.ClipSize ~= nil then
		
		weapon.Primary.ClipSize = math.Round( weapon.Primary.ClipSize * values[ 1 ] )
		timer.Simple( 0, function() if IsValid( weapon ) == true then weapon:SetClip1( weapon.Primary.ClipSize ) end end )
		
	end
	
	return values
	
end )
--fire rate penalty
TF2Weapons:AddAttributeID( 5, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	weapon.Primary.Delay = weapon.Primary.Delay * values[ 1 ]
	--if weapon.Primary.HitDelay ~= nil then weapon.Primary.HitDelay = weapon.Primary.HitDelay * values[ 1 ] end
	
	return values
	
end )
--fire rate bonus
TF2Weapons:AddAttributeID( 6, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	weapon.Primary.Delay = weapon.Primary.Delay * values[ 1 ]
	if weapon.Primary.HitDelay ~= nil then weapon.Primary.HitDelay = weapon.Primary.HitDelay * values[ 1 ] end
	
	return values
	
end )
--heal rate penalty
TF2Weapons:AddAttributeID( 7, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.HPSInCombat ~= nil then weapon.Primary.HPSInCombat = weapon.Primary.HPSInCombat * values[ 1 ] end
	if weapon.Primary.HPSOutCombat ~= nil then weapon.Primary.HPSOutCombat = weapon.Primary.HPSOutCombat * values[ 1 ] end
	
	return values
	
end )
--heal rate bonus
TF2Weapons:AddAttributeID( 8, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.HPSInCombat ~= nil then weapon.Primary.HPSInCombat = weapon.Primary.HPSInCombat * values[ 1 ] end
	if weapon.Primary.HPSOutCombat ~= nil then weapon.Primary.HPSOutCombat = weapon.Primary.HPSOutCombat * values[ 1 ] end
	
	return values
	
end )
--ubercharge rate penalty
TF2Weapons:AddAttributeID( 9, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Charge ~= nil then weapon.Primary.Charge = weapon.Primary.Charge * values[ 1 ] end
	if weapon.Primary.ChargeOverheal ~= nil then weapon.Primary.ChargeOverheal = weapon.Primary.ChargeOverheal * values[ 1 ] end
	
	return values
	
end )
--ubercharge rate bonus
TF2Weapons:AddAttributeID( 10, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Charge ~= nil then weapon.Primary.Charge = weapon.Primary.Charge * values[ 1 ] end
	if weapon.Primary.ChargeOverheal ~= nil then weapon.Primary.ChargeOverheal = weapon.Primary.ChargeOverheal * values[ 1 ] end
	
	return values
	
end )
--overheal bonus
TF2Weapons:AddAttributeID( 11, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Overheal ~= nil then weapon.Primary.Overheal = weapon.Primary.Overheal * values[ 1 ] end
	
	return values
	
end )
--crit mod disabled
TF2Weapons:AddAttributeID( 15, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.CritChance ~= nil then weapon.CritChance = weapon.CritChance * values[ 1 ] end
	
	return values
	
end )
--heal on hit for rapidfire
TF2Weapons:AddAttributeID( 16, function( weapon, values )
	
	return values
	
end )
--crit vs burning players
TF2Weapons:AddAttributeID( 20, function( weapon, values )
	
	return values
	
end )
--dmg penalty vs nonburning
TF2Weapons:AddAttributeID( 21, function( weapon, values )
	
	return values
	
end )
--no crit vs nonburning
TF2Weapons:AddAttributeID( 22, function( weapon, values )
	
	return values
	
end )
--mod flamethrower push
TF2Weapons:AddAttributeID( 23, function( weapon, values )
	
	return values
	
end )
--mod flamethrower back crit
TF2Weapons:AddAttributeID( 24, function( weapon, values )
	
	return values
	
end )
--hidden secondary max ammo penalty
TF2Weapons:AddAttributeID( 25, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Secondary == nil then return values end
	
	if weapon.Secondary.DefaultClip ~= nil and weapon.Secondary.ClipSize ~= nil then
		
		timer.Simple( 0, function()
			
			if IsValid( weapon ) == true and weapon.Secondary ~= nil then
				
				local defaultclipsize = weapon.Secondary.DefaultClipSize or weapon.Secondary.ClipSize
				
				if SERVER and IsValid( weapon:GetOwner() ) == true and weapon.Secondary.Ammo ~= nil then weapon:GetOwner():RemoveAmmo( weapon.Secondary.DefaultClip - ( ( weapon.Secondary.DefaultClip - defaultclipsize ) * values[ 1 ] ) - defaultclipsize, weapon.Secondary.Ammo, true ) end
				weapon.Secondary.DefaultClip = weapon.Secondary.DefaultClip - ( ( weapon.Secondary.DefaultClip - defaultclipsize ) * ( values[ 1 ] - 1 ) )
				
			end
			
		end )
		
	end
	
	return values
	
end )
--max health additive bonus
TF2Weapons:AddAttributeID( 26, function( weapon, values )
	
	return values
	
end )
--crit mod disabled hidden
TF2Weapons:AddAttributeID( 28, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.CritChance ~= nil then weapon.CritChance = weapon.CritChance * values[ 1 ] end
	
	return values
	
end )
--spread penalty
TF2Weapons:AddAttributeID( 36, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Spread ~= nil then weapon.Primary.Spread = weapon.Primary.Spread * values[ 1 ] end
	
	return values
	
end )
--bullets per shot bonus
TF2Weapons:AddAttributeID( 45, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Shots ~= nil then weapon.Primary.Shots = weapon.Primary.Shots * values[ 1 ] end
	
	return values
	
end )
--move speed penalty
TF2Weapons:AddAttributeID( 54, function( weapon, values )
	
	return values
	
end )
--weapon burn dmg reduced
TF2Weapons:AddAttributeID( 72, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.AfterburnDamage ~= nil then weapon.Primary.AfterburnDamage = weapon.Primary.AfterburnDamage * values[ 1 ] end
	
	return values
	
end )
--maxammo primary increased
TF2Weapons:AddAttributeID( 76, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.DefaultClip ~= nil and weapon.Primary.ClipSize ~= nil then
		
		timer.Simple( 0, function()
			
			if IsValid( weapon ) == true and weapon.Primary ~= nil then
				
				local defaultclipsize = weapon.Primary.DefaultClipSize or weapon.Primary.ClipSize
				
				if SERVER and IsValid( weapon:GetOwner() ) == true and weapon.Primary.Ammo ~= nil then weapon:GetOwner():GiveAmmo( ( weapon.Primary.DefaultClip * ( values[ 1 ] - 1 ) ) - defaultclipsize, weapon.Primary.Ammo, true ) end
				weapon.Primary.DefaultClip = weapon.Primary.DefaultClip + ( ( weapon.Primary.DefaultClip - defaultclipsize ) * ( values[ 1 ] - 1 ) )
				
			end
			
		end )
		
	end
	
	return values
	
end )
--maxammo primary reduced
TF2Weapons:AddAttributeID( 77, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.DefaultClip ~= nil and weapon.Primary.ClipSize ~= nil then
		
		timer.Simple( 0, function()
			
			if IsValid( weapon ) == true and weapon.Primary ~= nil then
				
				local defaultclipsize = weapon.Primary.DefaultClipSize or weapon.Primary.ClipSize
				
				if SERVER and IsValid( weapon:GetOwner() ) == true and weapon.Primary.Ammo ~= nil then weapon:GetOwner():RemoveAmmo( weapon.Primary.DefaultClip - ( ( weapon.Primary.DefaultClip - defaultclipsize ) * values[ 1 ] ) - defaultclipsize, weapon.Primary.Ammo, true ) end
				weapon.Primary.DefaultClip = weapon.Primary.DefaultClip - ( ( weapon.Primary.DefaultClip - defaultclipsize ) * ( values[ 1 ] - 1 ) )
				
			end
			
		end )
		
	end
	
	return values
	
end )
--minigun spinup time increased
TF2Weapons:AddAttributeID( 86, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.SpoolTime ~= nil then weapon.SpoolTime = weapon.SpoolTime * values[ 1 ] end
	
	return values
	
end )
--minigun spinup time decreased
TF2Weapons:AddAttributeID( 87, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.SpoolTime ~= nil then weapon.SpoolTime = weapon.SpoolTime * values[ 1 ] end
	
	return values
	
end )
--Construction rate increased
TF2Weapons:AddAttributeID( 92, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.BuildConstructRateMult ~= nil then weapon.BuildConstructRateMult = weapon.BuildConstructRateMult * values[ 1 ] end
	
	return values
	
end )
--Construction rate decreased
TF2Weapons:AddAttributeID( 93, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.BuildConstructRateMult ~= nil then weapon.BuildConstructRateMult = weapon.BuildConstructRateMult * values[ 1 ] end
	
	return values
	
end )
--Repair rate increased
TF2Weapons:AddAttributeID( 94, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.BuildRepairMult ~= nil then weapon.BuildRepairMult = weapon.BuildRepairMult * values[ 1 ] end
	
	return values
	
end )
--Repair rate decreased
TF2Weapons:AddAttributeID( 95, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.BuildRepairMult ~= nil then weapon.BuildRepairMult = weapon.BuildRepairMult * values[ 1 ] end
	
	return values
	
end )
--Reload time increased
TF2Weapons:AddAttributeID( 96, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.ReloadSpeed ~= nil then weapon.ReloadSpeed = weapon.ReloadSpeed * values[ 1 ] end
	
	return values
	
end )
--Reload time decreased
TF2Weapons:AddAttributeID( 97, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.ReloadSpeed ~= nil then weapon.ReloadSpeed = weapon.ReloadSpeed / values[ 1 ] end
	
	return values
	
end )
--Projectile speed increased
TF2Weapons:AddAttributeID( 103, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	for i = 1, #projectilespeed do
		
		local v = projectilespeed[ i ]
		if weapon[ v ] ~= nil then weapon[ v ] = weapon[ v ] * values[ 1 ] end
		
	end
	
	return values
	
end )
--Projectile speed decreased
TF2Weapons:AddAttributeID( 104, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	for i = 1, #projectilespeed do
		
		local v = projectilespeed[ i ]
		if weapon[ v ] ~= nil then weapon[ v ] = weapon[ v ] * values[ 1 ] end
		
	end
	
	return values
	
end )
--weapon spread bonus
TF2Weapons:AddAttributeID( 106, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Primary == nil then return values end
	
	if weapon.Primary.Spread ~= nil then weapon.Primary.Spread = weapon.Primary.Spread * values[ 1 ] end
	
	return values
	
end )
--move speed bonus
TF2Weapons:AddAttributeID( 107, function( weapon, values )
	
	return values
	
end )
--max health additive penalty
TF2Weapons:AddAttributeID( 125, function( weapon, values )
	
	return values
	
end )
--provide on active
TF2Weapons:AddAttributeID( 128, function( weapon, values )
	
	return values
	
end )
--rocket jump damage reduction
TF2Weapons:AddAttributeID( 135, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	for i = 1, #ownerhitmult do
		
		local v = ownerhitmult[ i ]
		if weapon[ v ] ~= nil then weapon[ v ] = weapon[ v ] * values[ 1 ] end
		
	end
	
	return values
	
end )
--dmg bonus vs buildings
TF2Weapons:AddAttributeID( 137, function( weapon, values )
	
	return values
	
end )
--airblast cost increased
TF2Weapons:AddAttributeID( 170, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	if weapon.Secondary == nil then return values end
	
	if weapon.Secondary.TakeAmmo ~= nil then weapon.Secondary.TakeAmmo = weapon.Secondary.TakeAmmo * values[ 1 ] end
	
	return values
	
end )
--deploy time increased
TF2Weapons:AddAttributeID( 177, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.DeployTime ~= nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
	
	return values
	
end )
--deploy time decreased
TF2Weapons:AddAttributeID( 178, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.DeployTime ~= nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
	
	return values
	
end )
--heal on kill
TF2Weapons:AddAttributeID( 180, function( weapon, values )
	
	return values
	
end )
--switch from wep deploy time decreased
TF2Weapons:AddAttributeID( 199, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.NextDeploySpeed ~= nil then weapon.NextDeploySpeed = weapon.NextDeploySpeed * values[ 1 ] end
	
	return values
	
end )
--sanguisuge
TF2Weapons:AddAttributeID( 217, function( weapon, values )
	
	return values
	
end )
--dmg bonus while half dead
TF2Weapons:AddAttributeID( 224, function( weapon, values )
	
	return values
	
end )
--dmg penalty while half alive
TF2Weapons:AddAttributeID( 225, function( weapon, values )
	
	return values
	
end )
--minigun no spin sounds
TF2Weapons:AddAttributeID( 238, function( weapon, values )
	
	weapon.SpoolIdleSound = nil
	weapon.ShootSoundEnd = weapon.SpoolDownSound
	weapon.SpoolDownSound = nil
	
	return values
	
end )
--cancel falling damage
TF2Weapons:AddAttributeID( 275, function( weapon, values )
	
	return values
	
end )
--energy weapon no ammo
TF2Weapons:AddAttributeID( 281, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if values[ 1 ] >= 1 then weapon.ReloadTakeAmmo = 0 end
	
	return values
	
end )
--airblast disabled
TF2Weapons:AddAttributeID( 356, function( weapon, values )
	
	return values
	
end )
--dmg taken increased
TF2Weapons:AddAttributeID( 412, function( weapon, values )
	
	return values
	
end )
--increased jump height from weapon
TF2Weapons:AddAttributeID( 524, function( weapon, values )
	
	return values
	
end )
--single wep deploy time decreased
TF2Weapons:AddAttributeID( 547, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.DeployTime ~= nil then weapon.DeployTime = weapon.DeployTime * values[ 1 ] end
	
	return values
	
end )
--dmg penalty vs buildings
TF2Weapons:AddAttributeID( 775, function( weapon, values )
	
	return values
	
end )
--is_a_sword
TF2Weapons:AddAttributeID( 781, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.Primary ~= nil and weapon.Primary.Range ~= nil then weapon.Primary.Range = weapon.Primary.Range + values[ 1 ] end
	--i'm just guessing here
	if weapon.DeployTime ~= nil then weapon.DeployTime = weapon.DeployTime * 2 end
	if weapon.NextDeploySpeed ~= nil then weapon.NextDeploySpeed = weapon.NextDeploySpeed * 2 end
	
	return values
	
end )
--extinguish restores health
TF2Weapons:AddAttributeID( 783, function( weapon, values )
	
	if values[ 1 ] == nil or IsValid( weapon ) ~= true then return values end
	
	if weapon.ExtinguishHealth ~= nil then weapon.ExtinguishHealth = weapon.ExtinguishHealth + values[ 1 ] end
	
	return values
	
end )