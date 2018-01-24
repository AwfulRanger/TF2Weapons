local function getsound( name )
	
	local s = sound.GetProperties( name )
	if s == nil then return name end
	if istable( s.sound ) == true then
		
		local ret = {}
		for i = 1, #s.sound do ret[ i ] = Sound( s.sound[ i ] ) end
		return ret
		
	end
	return Sound( s.sound )
	
end

local sound_single_shot = {
	
	"ShootStartSound",
	
}
local sound_burst = {
	
	"SwingSoundCrit",
	
}
local sound_special1 = {
	
	"GrenadeSound",
	"PipeSound",
	"RocketSound",
	"SpoolUpSound",
	
}
local sound_special2 = {
	
	"SpoolDownSound",
	
}
local sound_special3 = {
	
	"SpoolIdleSound",
	"ShootEndSound",
	
}

function TF2Weapons:AddWeapon( id, id_, tbl )
	
	local item = id
	if istable( item ) ~= true then
		
		local items = self:GetItemsTable()
		if items == nil then return end
		local items_ = items.items
		if items_ ~= nil then item = items_[ id ] end
		if item == nil then
			
			local prefabs = items.prefabs
			if prefabs ~= nil then item = prefabs[ id ] end
			
		end
		
	end
	if item == nil then return end
	
	
	
	local SWEP = {}
	
	if CLIENT and item.image_inventory ~= nil then SWEP.WepSelectIcon = surface.GetTextureID( item.image_inventory ) end
	SWEP.ProperName = item.propername ~= 0
	SWEP.PrintName = item.item_name
	SWEP.MinLevel = item.min_ilevel
	SWEP.MaxLevel = item.max_ilevel
	SWEP.Type = item.item_type_name
	SWEP.Classes = {}
	if item.used_by_classes ~= nil then for _, v in pairs( item.used_by_classes ) do if self.Class[ string.upper( _ ) ] ~= nil then SWEP.Classes[ self.Class[ string.upper( _ ) ] ] = v ~= 0 end end end
	if item.item_quality ~= nil and TF2Weapons.Quality[ string.upper( item.item_quality ) ] ~= nil then SWEP.Quality = TF2Weapons.Quality[ string.upper( item.item_quality ) ] end
	
	SWEP.Spawnable = item.enabled ~= 0
	
	local model = item.model_player
	if model ~= nil then
		
		model = Model( model )
		SWEP.ViewModel = model
		SWEP.WorldModel = model
		
	end
	
	SWEP.Attributes = {}
	if item.attributes ~= nil then for _, v in pairs( item.attributes ) do if self:GetAttribute( _ ) ~= nil then SWEP.Attributes[ _ ] = { ( isnumber( v.value ) == true and math.Round( v.value, 3 ) ) or v.value } end end end
	if item.static_attrs ~= nil then for _, v in pairs( item.static_attrs ) do if self:GetAttribute( _ ) ~= nil then SWEP.Attributes[ _ ] = { ( isnumber( v ) == true and math.Round( v, 3 ) ) or v } end end end
	
	function SWEP:SetVariables()
		
		self.BaseClass.SetVariables( self )
		
		if item.visuals ~= nil then
			
			if item.visuals.melee_miss ~= nil then self.SwingSound = getsound( item.visuals.melee_miss ) end
			if item.visuals.melee_hit ~= nil then self.HitFleshSound = getsound( item.visuals.melee_hit ) end
			if item.visuals.melee_hit_world ~= nil then self.HitWorldSound = getsound( item.visuals.melee_hit_world ) end
			
			if item.visuals.sound_single_shot ~= nil then
				
				local found = false
				for i = 1, #sound_single_shot do
					
					if self[ sound_single_shot[ i ] ] ~= nil then self[ sound_single_shot[ i ] ] = getsound( item.visuals.sound_single_shot ) found = true end
					
				end
				if found ~= true then self.ShootSound = getsound( item.visuals.sound_single_shot ) end
				
			end
			if item.visuals.sound_double_shot ~= nil then self.ShootSound = getsound( item.visuals.sound_double_shot ) end
			if item.visuals.sound_burst ~= nil then
				
				local found = false
				for i = 1, #sound_burst do
					
					if self[ sound_burst[ i ] ] ~= nil then self[ sound_burst[ i ] ] = getsound( item.visuals.sound_burst ) found = true end
					
				end
				if found ~= true then self.ShootSoundCrit = getsound( item.visuals.sound_burst ) end
				
			end
			if item.visuals.sound_empty ~= nil then self.EmptySound = getsound( item.visuals.sound_empty ) end
			if item.visuals.sound_special1 ~= nil then
				
				local found = false
				for i = 1, #sound_special1 do
					
					if self[ sound_special1[ i ] ] ~= nil then self[ sound_special1[ i ] ] = getsound( item.visuals.sound_special1 ) found = true end
					
				end
				if found ~= true then self.ShootSound = getsound( item.visuals.sound_special1 ) end
				
			end
			if item.visuals.sound_special2 ~= nil then
				
				for i = 1, #sound_special2 do
					
					if self[ sound_special2[ i ] ] ~= nil then self[ sound_special2[ i ] ] = getsound( item.visuals.sound_special2 ) end
					
				end
				
			end
			if item.visuals.sound_special3 ~= nil then
				
				for i = 1, #sound_special3 do
					
					if self[ sound_special3[ i ] ] ~= nil then self[ sound_special3[ i ] ] = getsound( item.visuals.sound_special3 ) end
					
				end
				
			end
			
		end
		
	end
	
	
	
	if tbl ~= nil then for _, v in pairs( tbl ) do SWEP[ _ ] = v end end
	
	if id_ == nil and item.logname ~= nil then id_ = "tf_weapon_" .. item.logname end
	if id_ == nil then id_ = tostring( id ) end
	
	weapons.Register( SWEP, id_ )
	
end



TF2Weapons:AddWeapon( 851, "tf_weapon_awper_hand", {
	
	KillIconX = 0,
	KillIconY = 96,
	Base = "tf_weapon_sniperrifle",
	Category = "Team Fortress 2 - Sniper",
	
} )

TF2Weapons:AddWeapon( "weapon_backburner", "tf_weapon_backburner", {
	
	KillIconX = 256,
	KillIconY = 448,
	Base = "tf_weapon_flamethrower",
	Category = "Team Fortress 2 - Pyro",
	AttributesOrder = {
		
		"mod flamethrower back crit",
		"extinguish restores health",
		"airblast cost increased",
		"crit mod disabled hidden",
		
	},
	
} )

TF2Weapons:AddWeapon( "weapon_battleaxe", "tf_weapon_battleaxe", {
	
	KillIconX = 192,
	KillIconY = 704,
	Base = "tf_weapon_sword",
	Category = "Team Fortress 2 - Demoman",
	AttributesOrder = {
		
		"is_a_sword",
		"provide on active",
		"damage bonus",
		"move speed penalty",
		
	},
	
} )

TF2Weapons:AddWeapon( "weapon_degreaser", "tf_weapon_degreaser", {
	
	KillIconX = 0,
	KillIconY = 896,
	Base = "tf_weapon_flamethrower",
	Category = "Team Fortress 2 - Pyro",
	AttributesOrder = {
		
		"single wep deploy time decreased",
		"switch from wep deploy time decreased",
		"extinguish restores health",
		"weapon burn dmg reduced",
		"airblast cost increased",
		
	},
	
} )

TF2Weapons:AddWeapon( "weapon_russian_riot", "tf_weapon_family_business", {
	
	KillIconX = 384,
	KillIconY = 576,
	Base = "tf_weapon_shotgun_hwg",
	Category = "Team Fortress 2 - Heavy",
	AttributesOrder = {
		
		"clip size bonus",
		"fire rate bonus",
		"damage penalty",
		
	},
	SetVariables = function( self )
		
		self.BaseClass.SetVariables( self )
		
		self.ShootSound = Sound( "weapons/family_business_shoot.wav" )
		self.ShootSoundCrit = Sound( "weapons/family_business_shoot_crit.wav" )
		
	end,
	
} )

TF2Weapons:AddWeapon( 356, "tf_weapon_kunai", {
	
	KillIconX = 388,
	KillIconY = 64,
	Base = "tf_weapon_knife",
	Category = "Team Fortress 2 - Spy",
	GetAnimations = function( self )
		
		return {
			
			idle = "eternal_idle",
			draw = "eternal_draw",
			swing = {
				
				"eternal_stab_a",
				"eternal_stab_b",
				"eternal_stab_c",
				
			},
			crit = {
				
				"eternal_stab_a",
				"eternal_stab_b",
				"eternal_stab_c",
				
			},
			backstab = "eternal_backstab",
			backstab_up = "eternal_backstab_up",
			backstab_idle = "eternal_backstab_idle",
			backstab_down = "eternal_backstab_down",
			
		}
		
	end,
	GetInspect = function( self )
		
		return "item2"
		
	end,
	AttributesOrder = {
		
		"sanguisuge",
		"max health additive penalty",
		
	},
	
} )

TF2Weapons:AddWeapon( 414, "tf_weapon_liberty_launcher", {
	
	KillIconX = 384,
	KillIconY = 608,
	Base = "tf_weapon_rocketlauncher",
	Category = "Team Fortress 2 - Soldier",
	AttributesOrder = {
		
		"clip size bonus",
		"Projectile speed increased",
		"rocket jump damage reduction",
		"damage penalty",
		
	},
	
} )

TF2Weapons:AddWeapon( 773, "tf_weapon_pep_pistol", {
	
	KillIcon = Material( "hud/dneg_images_v3" ),
	KillIconX = 0,
	KillIconY = 736,
	Base = "tf_weapon_pistol_scout",
	Category = "Team Fortress 2 - Scout",
	AttributesOrder = {
		
		"provide on active",
		"heal on hit for rapidfire",
		"fire rate bonus",
		"clip size penalty",
		
	},
	
} )

TF2Weapons:AddWeapon( "weapon_powerjack", "tf_weapon_powerjack", {
	
	KillIconX = 0,
	KillIconY = 928,
	Base = "tf_weapon_fireaxe",
	Category = "Team Fortress 2 - Pyro",
	AttributesOrder = {
		
		"provide on active",
		"move speed bonus",
		"heal on kill",
		"dmg taken increased",
		
	},
	
} )

TF2Weapons:AddWeapon( "weapon_scimitar", "tf_weapon_shahanshah", {
	
	KillIconX = 384,
	KillIconY = 736,
	Base = "tf_weapon_club",
	Category = "Team Fortress 2 - Sniper",
	AttributesOrder = {
		
		"dmg bonus while half dead",
		"dmg penalty while half alive",
		
	},
	
} )

TF2Weapons:AddWeapon( 638, "tf_weapon_sharp_dresser", {
	
	KillIconX = 0,
	KillIconY = 288,
	Base = "tf_weapon_knife",
	Category = "Team Fortress 2 - Spy",
	GetAnimations = function( self )
		
		return {
			
			idle = "acr_idle",
			draw = "acr_draw",
			swing = {
				
				"acr_stab_a",
				"acr_stab_b",
				"acr_stab_c",
				
			},
			crit = {
				
				"acr_stab_a",
				"acr_stab_b",
				"acr_stab_c",
				
			},
			backstab = "acr_backstab",
			backstab_up = "acr_backstab_up",
			backstab_idle = "acr_backstab_idle",
			backstab_down = "acr_backstab_down",
			
		}
		
	end,
	GetInspect = function( self )
		
		return {
			
			inspect_start = "item1_inspect_start",
			inspect_idle = {
				
				"item1_inspect_idle_a",
				"item1_inspect_idle_b",
				
			},
			inspect_end = "item1_inspect_end",
			
		}
		
	end,
	
} )

TF2Weapons:AddWeapon( "weapon_tomislav", "tf_weapon_tomislav", {
	
	KillIconX = 384,
	KillIconY = 352,
	Base = "tf_weapon_minigun",
	Category = "Team Fortress 2 - Heavy",
	AttributesOrder = {
		
		"minigun spinup time decreased",
		"weapon spread bonus",
		"minigun no spin sounds",
		"fire rate penalty",
		
	},
	
} )

TF2Weapons:AddWeapon( 310, "tf_weapon_warrior_spirit", {
	
	KillIconX = 256,
	KillIconY = 832,
	KillIconW = 128,
	Base = "tf_weapon_fists",
	Category = "Team Fortress 2 - Heavy",
	AttributesOrder = {
		
		"provide on active",
		"damage bonus",
		"heal on kill",
		"dmg taken increased",
		
	},
	
} )

TF2Weapons:AddWeapon( "weapon_winger_pistol", "tf_weapon_winger", {
	
	KillIconX = 384,
	KillIconY = 320,
	Base = "tf_weapon_pistol_scout",
	Category = "Team Fortress 2 - Scout",
	AttributesOrder = {
		
		"damage bonus",
		"increased jump height from weapon",
		"clip size penalty",
		
	},
	SetVariables = function( self )
		
		self.BaseClass.SetVariables( self )
		
		self.ShootSound = Sound( "weapons/winger_shoot.wav" )
		self.ShootSoundCrit = Sound( "weapons/winger_shoot_crit.wav" )
		
	end,
	
} )

TF2Weapons:AddWeapon( "weapon_jag", "tf_weapon_wrench_jag", {
	
	KillIconX = 256,
	KillIconY = 864,
	KillIconW = 64,
	Base = "tf_weapon_wrench",
	Category = "Team Fortress 2 - Engineer",
	AttributesOrder = {
		
		"Construction rate increased",
		"fire rate bonus",
		"Repair rate decreased",
		"damage penalty",
		"dmg penalty vs buildings",
		
	},
	
} )