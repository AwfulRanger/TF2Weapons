AddCSLuaFile()

SWEP.TF2Weapons_BlockSlotBinds = true

hook.Add( "PlayerBindPress", "TF2Weapons_PDA_BlockSlotBinds", function( ply, bind, pressed )
	
	if pressed ~= true then return end
	local weapon = ply:GetActiveWeapon()
	if IsValid( weapon ) ~= true or weapon.TF2Weapons_BlockSlotBinds ~= true or weapon.OnSlotBind == nil then return end
	
	local startpos, endpos = string.find( bind, "slot" )
	
	if startpos ~= 1 then return end
	
	local slot = tonumber( string.Right( bind, #bind - endpos ) )
	
	if slot ~= nil then
		
		weapon:OnSlotBind( slot )
		
		return true
		
	end
	
end )

SWEP.Slot = 3
SWEP.SlotPos = 0

SWEP.DrawCrosshair = false
SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 0
SWEP.KillIconW = 0
SWEP.KillIconH = 0

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_builder_large" ) end
SWEP.PrintName = "#TF_Weapon_PDA_Engineer_Builder"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Engineer"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_PDA_Engineer"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.ENGINEER ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_builder/c_builder.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_builder/c_builder.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_engineer_arms.mdl" )
SWEP.HoldType = "slam"
function SWEP:GetAnimations()
	
	return "bld"
	
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
		Model = Model( "models/buildables/sentry1_blueprint.mdl" ),
		Cost = 130,
		BuildIcon = Material( "hud/eng_build_sentry_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_sentry_1" ),
			Material( "hud/hud_obj_status_sentry_2" ),
			Material( "hud/hud_obj_status_sentry_3" ),
			
		},
		
		BuildArguments = { 2, 0 },
		DestroyArguments = { 2, 0 },
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.DISPENSER ] = {
		
		Class = "obj_dispenser",
		Name = "Dispenser",
		Model = Model( "models/buildables/dispenser_blueprint.mdl" ),
		Cost = 100,
		BuildIcon = Material( "hud/eng_build_dispenser_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_dispenser" ),
			Material( "hud/hud_obj_status_dispenser" ),
			Material( "hud/hud_obj_status_dispenser" ),
			
		},
		
		BuildArguments = { 0, 0 },
		DestroyArguments = { 0, 0 },
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.ENTRANCE ] = {
		
		Class = "obj_teleporter",
		Name = "Entrance",
		Model = Model( "models/buildables/teleporter_blueprint_enter.mdl" ),
		Cost = 50,
		BuildIcon = Material( "hud/eng_build_tele_entrance_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_tele_entrance" ),
			Material( "hud/hud_obj_status_tele_entrance" ),
			Material( "hud/hud_obj_status_tele_entrance" ),
			
		},
		
		BuildArguments = { 1, 0 },
		DestroyArguments = { 1, 0 },
		
		Limit = 1,
		
	},
	
	[ TF2Weapons.Building.EXIT ] = {
		
		Class = "obj_teleporter",
		Name = "Exit",
		Model = Model( "models/buildables/teleporter_blueprint_exit.mdl" ),
		Cost = 50,
		BuildIcon = Material( "hud/eng_build_tele_exit_blueprint" ),
		DestroyIcon = {
			
			Material( "hud/hud_obj_status_tele_exit" ),
			Material( "hud/hud_obj_status_tele_exit" ),
			Material( "hud/hud_obj_status_tele_exit" ),
			
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
		
	elseif build ~= nil then
		
		RunConsoleCommand( self.BuildCommand, build.BuildArguments[ 1 ], build.BuildArguments[ 2 ] )
		
	end
	
end

function SWEP:HUD_Scale( res, y )
	
	res = string.lower( res )
	
	local size = tonumber( string.match( res, "([%d-]+)" ) )
	if size == nil then size = 0 end
	
	local result = size * ( ScrH() / 480 )
	
	if y ~= true then
		
		if string.find( res, "r" ) ~= nil then result = ScrW() - result end
		if string.find( res, "c" ) ~= nil then result = ( ScrW() * 0.5 ) + result end
		
	else
		
		if string.find( res, "r" ) ~= nil then result = ScrH() - result end
		if string.find( res, "c" ) ~= nil then result = ( ScrH() * 0.5 ) + result end
		
	end
	
	return result
	
end

SWEP.HUD_Materials = {
	
	Background = Material( "hud/eng_build_bg" ),
	Build = Material( "hud/ico_build" ),
	BuildBackground = Material( "hud/eng_build_item" ),
	KeyBackground = Material( "hud/ico_key_blank" ),
	Metal = Material( "hud/ico_metal_mask" ),
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
	
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetMaterial( mat.Build )
	--surface.DrawTexturedRect( xpos + scale( "16" ), ypos + scale( "-7" ), scale( "48" ), scale( "48" ) )
	surface.DrawTexturedRect( xpos + scale( "16" ), ypos + scale( "-7" ), scale( "48" ), scale( "48" ) )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat.Build )
	--surface.DrawTexturedRect( xpos + scale( "15" ), ypos + scale( "-8" ), scale( "48" ), scale( "48" ) )
	surface.DrawTexturedRect( xpos + scale( "15" ), ypos + scale( "-8" ), scale( "48" ), scale( "48" ) )
	
	surface.SetFont( "TF2Weapons_HudFontGiantBold" )
	
	surface.SetTextColor( 46, 43, 42, 255 )
	--surface.SetTextPos( xpos + scale( "69" ), ypos + scale( "1" ) )
	surface.SetTextPos( xpos + scale( "69" ), ypos + scale( "-2" ) )
	surface.DrawText( "Build" )
	
	surface.SetTextColor( 235, 226, 202, 255 )
	
	--surface.SetTextPos( xpos + scale( "68" ), ypos )
	surface.SetTextPos( xpos + scale( "68" ), ypos + scale( "-3" ) )
	surface.DrawText( "Build" )
	
	surface.SetFont( "TF2Weapons_SpectatorKeyHints" )
	
	local bind = input.LookupBinding( "slot10", true )
	if bind == nil then bind = input.LookupBinding( "lastinv", true ) end
	if bind == nil then bind = "UNBOUND" end
	
	local cancelw, cancelh = surface.GetTextSize( "Hit '" .. bind .. "' to Cancel" )
	
	surface.SetTextPos( xpos + scale( "392" ) - cancelw, ypos + scale( "38" ) )
	surface.DrawText( "Hit '" .. bind .. "' to Cancel" )
	
	for i = 1, num do
		
		local x = xpos + scale( 25 + ( 100 * ( i - 1 ) ) )
		local y = ypos + scale( "50" )
		
		local plybuildings = self:GetOwner().TF2Weapons_Buildings
		
		if plybuildings == nil then plybuildings = {} end
		if plybuildings[ i ] == nil then plybuildings[ i ] = {} end
		
		local alreadybuilt = #plybuildings[ i ] >= build[ i ].Limit
		local canafford = self:Ammo1() >= build[ i ].Cost
		
		surface.SetFont( "TF2Weapons_Default" )
		
		--surface.SetTextColor( 46, 43, 42, 255 )
		surface.SetTextColor( 235, 226, 202, 255 )
		surface.SetTextPos( x + scale( "6" ), y )
		surface.DrawText( build[ i ].Name )
		
		if alreadybuilt ~= true and canafford == true then
			
			surface.SetDrawColor( 251, 235, 202, 255 )
			surface.SetMaterial( mat.BuildBackground )
			--surface.DrawTexturedRect( x + scale( "4" ), y, scale( "98" ), scale( "135" ) )
			surface.DrawTexturedRect( x + scale( "-7" ), y, scale( "120" ), scale( "120" ) )
			
		else
			
			surface.SetDrawColor( 251, 235, 202, 128 )
			surface.SetMaterial( mat.UnavailableBackground )
			--surface.DrawTexturedRect( x + scale( "4" ), y, scale( "98" ), scale( "135" ) )
			surface.DrawTexturedRect( x + scale( "-7" ), y, scale( "120" ), scale( "120" ) )
			
		end
		
		if alreadybuilt ~= true and canafford == true then
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( build[ i ].BuildIcon )
			--surface.DrawTexturedRect( x + scale( "22" ), y + scale( "19" ), scale( "56" ), scale( "56" ) )
			surface.DrawTexturedRect( x + scale( "22" ), y + scale( "30" ), scale( "56" ), scale( "56" ) )
			
		end
		
		surface.SetDrawColor( 46, 43, 42, 255 )
		if alreadybuilt == true then
			
			surface.SetDrawColor( 117, 107, 94, 255 )
			
		elseif canafford ~= true then
			
			surface.SetDrawColor( 192, 28, 0, 255 )
			
		end
		surface.SetMaterial( mat.Metal )
		surface.DrawTexturedRect( x + scale( "10" ), y + scale( "15" ), scale( "10" ), scale( "10" ) )
		
		surface.SetFont( "TF2Weapons_HudFontSmall" )
		surface.SetTextColor( 46, 43, 42, 255 )
		if alreadybuilt == true then
			
			surface.SetTextColor( 117, 107, 94, 255 )
			
		elseif canafford ~= true then
			
			surface.SetTextColor( 192, 28, 0, 255 )
			
		end
		surface.SetTextPos( x + scale( "23" ), y + scale( "14" ) )
		surface.DrawText( build[ i ].Cost )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( mat.KeyBackground )
		surface.DrawTexturedRect( x + scale( "41" ), y + scale( "96" ), scale( "18" ), scale( "18" ) )
		
		surface.SetFont( "TF2Weapons_Default" )
		
		local slotw, sloth = surface.GetTextSize( i )
		
		surface.SetTextColor( 46, 43, 42, 255 )
		surface.SetTextPos( x + scale( "50" ) - ( slotw * 0.5 ), y + scale( "99" ) )
		surface.DrawText( i )
		
		if alreadybuilt == true then
			
			surface.SetTextColor( 235, 226, 202, 255 )
			surface.SetTextPos( x + scale( "23" ), y + scale( "49" ) )
			surface.DrawText( "Already Built" )
			
		elseif canafford ~= true then
			
			surface.SetTextColor( 192, 28, 0, 255 )
			surface.SetTextPos( x + scale( "21" ), y + scale( "45" ) )
			surface.DrawText( "Not Enough" )
			
			surface.SetTextPos( x + scale( "21" ), y + scale( "54" ) )
			surface.DrawText( "Metal" )
			
		end
		
	end
	
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end