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

function TF2Weapons:AddWeapon( id, id_, tbl )
	
	local item = id
	if istable( item ) != true then
		
		local items = self:GetItemsTable()
		if items == nil then return end
		local items_ = items.items
		if items_ != nil then item = items_[ id ] end
		if item == nil then
			
			local prefabs = items.prefabs
			if prefabs != nil then item = prefabs[ id ] end
			
		end
		
	end
	if item == nil then return end
	
	
	
	local SWEP = {}
	
	if CLIENT and item.image_inventory != nil then SWEP.WepSelectIcon = surface.GetTextureID( item.image_inventory ) end
	SWEP.ProperName = item.propername != 0
	SWEP.PrintName = item.item_name
	SWEP.MinLevel = item.min_ilevel
	SWEP.MaxLevel = item.max_ilevel
	SWEP.Type = item.item_type_name
	SWEP.Classes = {}
	if item.used_by_classes != nil then for _, v in pairs( item.used_by_classes ) do if self.Class[ string.upper( _ ) ] != nil then SWEP.Classes[ self.Class[ string.upper( _ ) ] ] = v != 0 end end end
	if item.item_quality != nil and TF2Weapons.Quality[ string.upper( item.item_quality ) ] != nil then SWEP.Quality = TF2Weapons.Quality[ string.upper( item.item_quality ) ] end
	
	SWEP.Spawnable = item.enabled != 0
	
	local model = item.model_player
	if model != nil then
		
		model = Model( model )
		SWEP.ViewModel = model
		SWEP.WorldModel = model
		
	end
	
	SWEP.Attributes = {}
	if item.attributes != nil then for _, v in pairs( item.attributes ) do SWEP.Attributes[ _ ] = { ( isnumber( v.value ) == true and math.Round( v.value, 5 ) ) or v.value } end end
	
	function SWEP:SetVariables()
		
		self.BaseClass:SetVariables()
		
		if item.visuals != nil then
			
			if item.visuals.sound_single_shot != nil then self.ShootSound = getsound( item.visuals.sound_single_shot ) end
			if item.visuals.sound_burst != nil then self.ShootSoundCrit = getsound( item.visuals.sound_burst ) end
			if item.visuals.sound_empty != nil then self.EmptySound = getsound( item.visuals.sound_empty ) end
			
		end
		
	end
	
	
	
	if tbl != nil then for _, v in pairs( tbl ) do SWEP[ _ ] = v end end
	
	if id_ == nil and item.logname != nil then id_ = "tf_weapon_" .. item.logname end
	if id_ == nil then id_ = tostring( id ) end
	
	weapons.Register( SWEP, id_ )
	
end



TF2Weapons:AddWeapon( 851, "tf_weapon_awper_hand", {
	
	KillIconX = 0,
	KillIconY = 96,
	Base = "tf_weapon_sniperrifle",
	Category = "Team Fortress 2 - Sniper",
	SetVariables = function( self )
		
		self.BaseClass.SetVariables( self )
		
		self.ShootSound = Sound( "weapons/csgo_awp_shoot.wav" )
		self.ShootSoundCrit = Sound( "weapons/csgo_awp_shoot_crit.wav" )
		
	end,
	
} )

TF2Weapons:AddWeapon( 851, "tf_weapon_backburner", {
	
	KillIconX = 256,
	KillIconY = 448,
	Base = "tf_weapon_flamethrower",
	Category = "Team Fortress 2 - Pyro",
	
} )

TF2Weapons:AddWeapon( "weapon_battleaxe", "tf_weapon_battleaxe", {
	
	KillIconX = 192,
	KillIconY = 704,
	Base = "tf_weapon_sword",
	Category = "Team Fortress 2 - Demoman",
	SetVariables = function( self )
		
		self.BaseClass.SetVariables( self )
		
		self.SwingSound = { Sound( "weapons/demo_sword_swing1.wav" ), Sound( "weapons/demo_sword_swing2.wav" ), Sound( "weapons/demo_sword_swing3.wav" ) }
		self.SwingSoundCrit = Sound( "weapons/demo_sword_swing_crit.wav" )
		self.HitWorldSound = { Sound( "weapons/demo_sword_hit_world1.wav" ), Sound( "weapons/demo_sword_hit_world2.wav" ) }
		self.HitFleshSound = { Sound( "weapons/blade_slice_2.wav" ), Sound( "weapons/blade_slice_3.wav" ), Sound( "weapons/blade_slice_4.wav" ) }
		
	end,
	
} )

TF2Weapons:AddWeapon( "weapon_degreaser", "tf_weapon_degreaser", {
	
	KillIconX = 0,
	KillIconY = 896,
	Base = "tf_weapon_flamethrower",
	Category = "Team Fortress 2 - Pyro",
	
} )

TF2Weapons:AddWeapon( "weapon_russian_riot", "tf_weapon_family_business", {
	
	KillIconX = 384,
	KillIconY = 576,
	Base = "tf_weapon_shotgun_hwg",
	Category = "Team Fortress 2 - Heavy",
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
	
} )

TF2Weapons:AddWeapon( 414, "tf_weapon_liberty_launcher", {
	
	KillIconX = 384,
	KillIconY = 608,
	Base = "tf_weapon_rocketlauncher",
	Category = "Team Fortress 2 - Soldier",
	
} )

TF2Weapons:AddWeapon( 773, "tf_weapon_pep_pistol", {
	
	KillIcon = Material( "hud/dneg_images_v3" ),
	KillIconX = 0,
	KillIconY = 736,
	Base = "tf_weapon_pistol_scout",
	Category = "Team Fortress 2 - Scout",
	SetVariables = function( self )
		
		self.BaseClass.SetVariables( self )
		
		self.ShootSound = Sound( "weapons/doom_scout_pistol.wav" )
		self.ShootSoundCrit = Sound( "weapons/doom_scout_pistol_crit.wav" )
		
	end,
	
} )

TF2Weapons:AddWeapon( "weapon_powerjack", "tf_weapon_powerjack", {
	
	KillIconX = 0,
	KillIconY = 928,
	Base = "tf_weapon_fireaxe",
	Category = "Team Fortress 2 - Pyro",
	
} )

TF2Weapons:AddWeapon( "weapon_scimitar", "tf_weapon_shahanshah", {
	
	KillIconX = 384,
	KillIconY = 736,
	Base = "tf_weapon_club",
	Category = "Team Fortress 2 - Sniper",
	
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
	SetVariables = function( self )
		
		self.BaseClass.SetVariables( self )
		
		self.ShootSound = Sound( "weapons/tomislav_shoot.wav" )
		self.ShootSoundCrit = Sound( "weapons/tomislav_shoot_crit.wav" )
		self.ShootSoundEnd = Sound( "weapons/tomislav_wind_down.wav" )
		self.SpoolUpSound = Sound( "weapons/tomislav_wind_up.wav" )
		self.SpoolIdleSound = nil
		self.SpoolDownSound = nil
		
	end,
	
} )

TF2Weapons:AddWeapon( 310, "tf_weapon_warrior_spirit", {
	
	KillIconX = 256,
	KillIconY = 832,
	KillIconW = 128,
	Base = "tf_weapon_fists",
	Category = "Team Fortress 2 - Heavy",
	
} )

TF2Weapons:AddWeapon( "weapon_winger_pistol", "tf_weapon_winger", {
	
	KillIconX = 384,
	KillIconY = 320,
	Base = "tf_weapon_pistol_scout",
	Category = "Team Fortress 2 - Scout",
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
	
} )