AddCSLuaFile()

SWEP.TF2Weapons_BlockSlotBinds = true

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 0
SWEP.KillIconW = 0
SWEP.KillIconH = 0

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_pda_engineer_large" ) end
SWEP.PrintName = "Destruction PDA"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "PDA"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { TF2Weapons.Class.ENGINEER }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_pda_engineer/c_pda_engineer.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_pda_engineer/c_pda_engineer.mdl"
SWEP.HandModel = "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.HoldType = "slam"
function SWEP:GetAnimations()
	
	return "pda"
	
end
function SWEP:GetInspect()
	
	return ""
	
end

SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_metal"

SWEP.Toolbox = "tf_weapon_builder"

SWEP.BuildCommand = "tf2weapons_build"
SWEP.DestroyCommand = "tf2weapons_destroy"

SWEP.Buildings = {
	
	[ TF2Weapons.Building.SENTRY ] = {
		
		Class = "obj_sentrygun",
		Name = "Sentry Gun",
		Model = "models/buildables/sentry1_blueprint.mdl",
		Cost = 130,
		BuildIcon = Material( "hud/eng_build_sentry_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_sentry_1" ),
			Material( "hud/hud_obj_status_sentry_2" ),
			Material( "hud/hud_obj_status_sentry_3" ),
			
		},
		DestroyPos = {
			
			{ "10", "6", "80", "80" },
			{ "10", "8", "80", "80" },
			{ "14", "14", "75", "75" },
			
		},
		
		BuildArguments = { 2, 0 },
		DestroyArguments = { 2, 0 },
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.DISPENSER ] = {
		
		Class = "obj_dispenser",
		Name = "Dispenser",
		Model = "models/buildables/dispenser_blueprint.mdl",
		Cost = 100,
		BuildIcon = Material( "hud/eng_build_dispenser_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_dispenser" ),
			Material( "hud/hud_obj_status_dispenser" ),
			Material( "hud/hud_obj_status_dispenser" ),
			
		},
		DestroyPos = {
			
			{ "10", "16", "80", "80" },
			{ "10", "16", "80", "80" },
			{ "10", "16", "80", "80" },
			
		},
		
		BuildArguments = { 0, 0 },
		DestroyArguments = { 0, 0 },
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.ENTRANCE ] = {
		
		Class = "obj_teleporter",
		Name = "Entrance",
		Model = "models/buildables/teleporter_blueprint_enter.mdl",
		Cost = 50,
		BuildIcon = Material( "hud/eng_build_tele_entrance_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_tele_entrance" ),
			Material( "hud/hud_obj_status_tele_entrance" ),
			Material( "hud/hud_obj_status_tele_entrance" ),
			
		},
		DestroyPos = {
			
			{ "20", "27", "60", "60" },
			{ "20", "27", "60", "60" },
			{ "20", "27", "60", "60" },
			
		},
		
		BuildArguments = { 1, 0 },
		DestroyArguments = { 1, 0 },
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.EXIT ] = {
		
		Class = "obj_teleporter",
		Name = "Exit",
		Model = "models/buildables/teleporter_blueprint_exit.mdl",
		Cost = 50,
		BuildIcon = Material( "hud/eng_build_tele_exit_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_tele_exit" ),
			Material( "hud/hud_obj_status_tele_exit" ),
			Material( "hud/hud_obj_status_tele_exit" ),
			
		},
		DestroyPos = {
			
			{ "20", "27", "60", "60" },
			{ "20", "27", "60", "60" },
			{ "20", "27", "60", "60" },
			
		},
		
		BuildArguments = { 1, 1 },
		DestroyArguments = { 1, 1 },
		
		Limit = 1,
		
	},
	
}

function SWEP:SetVariables()
	
	self.ShootSound = nil
	self.ShootSoundCrit = nil
	self.EmptySound = nil
	
end

function SWEP:OnSlotBind( slot )
	
	local build = self.Buildings[ slot ]
	
	if slot == 10 then
		
		RunConsoleCommand( "lastinv" )
		
	elseif build != nil then
		
		RunConsoleCommand( self.DestroyCommand, build.DestroyArguments[ 1 ], build.DestroyArguments[ 2 ] )
		
	end
	
end

function SWEP:HUD_Scale( res, y )
	
	res = string.lower( res )
	
	local size = tonumber( string.match( res, "([%d-]+)" ) )
	if size == nil then size = 0 end
	
	local result = size * ( ScrH() / 480 )
	
	if y != true then
		
		if string.find( res, "r" ) != nil then result = ScrW() - result end
		if string.find( res, "c" ) != nil then result = ( ScrW() * 0.5 ) + result end
		
	else
		
		if string.find( res, "r" ) != nil then result = ScrH() - result end
		if string.find( res, "c" ) != nil then result = ( ScrH() * 0.5 ) + result end
		
	end
	
	return result
	
end

SWEP.HUD_Materials = {
	
	Background = Material( "hud/eng_build_bg" ),
	Demolish = Material( "hud/ico_demolish" ),
	KeyBackground = Material( "hud/ico_key_blank" ),
	UnavailableBackground = Material( "hud/eng_build_item_outline" )
	
}

function SWEP:DrawHUD()
	
	local build = self.Buildings
	local num = #build
	
	local scale = function( res, y ) return self:HUD_Scale( res, y ) end
	local mat = self.HUD_Materials
	
	--local xpos = scale( "c-225" )
	local xpos = scale( "c-225" )
	local ypos = scale( "c-55", true )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat.Background )
	--surface.DrawTexturedRect( xpos, ypos + scale( "10" ), scale( "450" ), scale( "170" ) )
	surface.DrawTexturedRect( xpos + scale( "-7" ), ypos + scale( "3" ), scale( "464" ), scale( "227" ) )
	
	surface.SetDrawColor( 255, 222, 208, 255 )
	surface.DrawRect( xpos + scale( "8" ), ypos + scale( "47" ), scale( "436" ), scale( "2" ) )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat.Demolish )
	--surface.DrawTexturedRect( xpos + scale( "15" ), ypos + scale( "-8" ), scale( "48" ), scale( "48" ) )
	surface.DrawTexturedRect( xpos, ypos + scale( "-5" ), scale( "64" ), scale( "64" ) )
	
	surface.SetFont( "TF2Weapons_HudFontGiantBold" )
	
	surface.SetTextColor( 46, 43, 42, 255 )
	--surface.SetTextPos( xpos + scale( "69" ), ypos + scale( "1" ) )
	surface.SetTextPos( xpos + scale( "32" ), ypos + scale( "-2" ) )
	surface.DrawText( "Demolish" )
	
	surface.SetTextColor( 235, 226, 202, 255 )
	
	--surface.SetTextPos( xpos + scale( "68" ), ypos )
	surface.SetTextPos( xpos + scale( "31" ), ypos + scale( "-3" ) )
	surface.DrawText( "Demolish" )
	
	surface.SetFont( "TF2Weapons_SpectatorKeyHints" )
	
	local cancelw, cancelh = surface.GetTextSize( "Hit '" .. input.LookupBinding( "slot10", true ) .. "' to Cancel" )
	
	surface.SetTextPos( xpos + scale( "392" ) - cancelw, ypos + scale( "38" ) )
	surface.DrawText( "Hit '" .. input.LookupBinding( "lastinv", true ) .. "' to Cancel" )
	
	for i = 1, num do
		
		local x = xpos + scale( 25 + ( 100 * ( i - 1 ) ) )
		local y = ypos + scale( "50" )
		
		local plybuildings = self:GetOwner().TF2Weapons_Buildings
		
		if plybuildings == nil then plybuildings = {} end
		if plybuildings[ i ] == nil then plybuildings[ i ] = {} end
		
		local alreadybuilt = #plybuildings[ i ] >= 1
		
		local building = plybuildings[ i ][ #plybuildings[ i ] ]
		
		local level = 1
		if IsValid( building ) == true and building.GetTFLevel != nil then level = building:GetTFLevel() end
		
		surface.SetFont( "TF2Weapons_Default" )
		
		--surface.SetTextColor( 46, 43, 42, 255 )
		surface.SetTextColor( 235, 226, 202, 255 )
		surface.SetTextPos( x + scale( "6" ), y )
		surface.DrawText( build[ i ].Name )
		
		surface.SetDrawColor( 251, 235, 202, 255 )
		surface.SetMaterial( mat.UnavailableBackground )
		--surface.DrawTexturedRect( x + scale( "4" ), y, scale( "98" ), scale( "135" ) )
		surface.DrawTexturedRect( x + scale( "-7" ), y, scale( "120" ), scale( "120" ) )
		
		if alreadybuilt == true then
			
			for layer = 1, 10 do
				
				surface.DrawTexturedRect( x + scale( "-7" ), y, scale( "120" ), scale( "120" ) )
				
			end
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( mat.Demolish )
			--surface.DrawTexturedRect( x + scale( "38" ), y + scale( "65" ), scale( "70" ), scale( "70" ) )
			surface.DrawTexturedRect( x + scale( "13" ), y + scale( "16" ), scale( "70" ), scale( "70" ) )
			
			local destroyicon = build[ i ].DestroyIcon[ 1 ]
			if build[ i ].DestroyIcon[ level ] != nil then destroyicon = build[ i ].DestroyIcon[ level ] end
			
			--surface.SetDrawColor( 251, 235, 202, 128 )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( destroyicon )
			--surface.DrawTexturedRect( x + scale( "4" ), y, scale( "98" ), scale( "135" ) )
			local pos = build[ i ].DestroyPos[ level ]
			
			if pos != nil then surface.DrawTexturedRect( x + scale( pos[ 1 ] ), y + scale( pos[ 2 ] ), scale( pos[ 3 ] ), scale( pos[ 4 ] ) ) end
			
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		if alreadybuilt != true then surface.SetDrawColor( 255, 255, 255, 128 ) end
		surface.SetMaterial( mat.KeyBackground )
		surface.DrawTexturedRect( x + scale( "41" ), y + scale( "96" ), scale( "18" ), scale( "18" ) )
		
		surface.SetFont( "TF2Weapons_Default" )
		
		local slotw, sloth = surface.GetTextSize( i )
		
		surface.SetTextColor( 46, 43, 42, 255 )
		surface.SetTextPos( x + scale( "50" ) - ( slotw * 0.5 ), y + scale( "99" ) )
		surface.DrawText( i )
		
		if alreadybuilt != true then
			
			surface.SetTextColor( 235, 226, 202, 255 )
			surface.SetTextPos( x + scale( "31" ), y + scale( "49" ) )
			surface.DrawText( "Not Built" )
			
		end
		
	end
	
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end