AddCSLuaFile()

local sniperrifles = {}

hook.Add( "OnEntityCreated", "TF2Weapons_SniperRifle_OnCreated", function( ent )
	
	table.insert( sniperrifles, ent )
	
end )

hook.Add( "EntityRemoved", "TF2Weapons_SniperRifle_OnRemoved", function( ent )
	
	if table.HasValue( sniperrifles, ent ) == true then
		
		table.RemoveByValue( sniperrifles, ent )
		
	end
	
end )

hook.Add( "PostDrawOpaqueRenderables", "TF2Weapons_SniperRifle_DrawDot", function( depth, skybox )
	
	for i = 1, #sniperrifles do
		
		local rifle = sniperrifles[ i ]
		
		if rifle.GetTFScoped != nil and rifle:GetTFScoped() == true and rifle.DrawSniperDot != nil then rifle:DrawSniperDot() end
		
	end
	
end )

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 0
SWEP.KillIconY = 96

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_sniperrifle_large" ) end
SWEP.PrintName = "Sniper Rifle"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Sniper Rifle"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { TF2Weapons.Class.SNIPER }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_sniperrifle/c_sniperrifle.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_sniperrifle/c_sniperrifle.mdl"
SWEP.HandModel = "models/weapons/c_models/c_sniper_arms.mdl"
SWEP.HoldType = "crossbow"
SWEP.HoldTypeScoped = "ar2"
function SWEP:GetAnimations()
	
	return ""
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end
SWEP.MuzzleParticle = "muzzle_sniperrifle"

SWEP.SingleReload = false
SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_rifle"
SWEP.Primary.Damage = 50
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 1.5

SWEP.MaxScopeTime = 3.3
SWEP.ChargeDelay = 1
SWEP.HeadshotDelay = 0.2
SWEP.ChargeMultiplier = 3

SWEP.HeadshotEnabled = true

SWEP.ChargedSound = Sound( "player/recharged.wav" )

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/sniper_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/sniper_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "Scoped", false )
	self:TFNetworkVar( "Bool", "ScopeNext", false )
	
	self:TFNetworkVar( "Float", "ScopeTime", 0 )
	
end

function SWEP:ScopeIn()
	
	self:SetTFScoped( true )
	self:SetTFScopeTime( CurTime() )
	
	self:SetHoldType( self.HoldTypeScoped )
	
end

function SWEP:ScopeOut()
	
	self:SetTFScoped( false )
	self:SetTFScopeTime( -1 )
	
	self:SetHoldType( self.HoldType )
	
end

SWEP.SniperDotEnt = nil

SWEP.SniperDotRedMat = Material( "effects/sniperdot_red" )
SWEP.SniperDotBlueMat = Material( "effects/sniperdot_blue" )

function SWEP:DrawSniperDot()
	
	local mat = self.SniperDotRedMat
	if self:GetTeam() == true then mat = self.SniperDotBlueMat end
	
	local tr = util.TraceLine( {
		
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector() * 32768 ),
		filter = self:GetOwner(),
		
	} )
	
	local ang = Angle( EyeAngles().r, EyeAngles().y - 90, -EyeAngles().p + 90 )
	local wh = 64
	local size = 0.0625
	
	local center = ( -ang:Forward() * ( wh * ( size * 0.5 ) ) ) + ( -ang:Right() * ( wh * ( size * 0.5 ) ) ) + ( ang:Up() * ( wh * size ) )
	
	cam.Start3D()
		
		cam.Start3D2D( tr.HitPos + center, ang, size )
			
			surface.SetDrawColor( 255, 255, 255, 100 )
			surface.SetMaterial( mat )
			
			surface.DrawTexturedRect( 0, 0, wh, wh )
			
			if ( CurTime() - self:GetTFScopeTime() ) * ( self.ChargeMultiplier / self.MaxScopeTime ) > self.ChargeDelay then
				
				local charge = ( ( CurTime() - self:GetTFScopeTime() ) - self.ChargeDelay ) / ( self.MaxScopeTime - self.ChargeDelay )
				if charge < 0 then charge = 0 end
				if charge > 1 then charge = 1 end
				
				local dotsize = wh * charge
				local dotpos = wh * 0.5
				
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( dotpos - ( dotsize * 0.5 ), dotpos - ( dotsize * 0.5 ), dotsize, dotsize )
				
			end
			
		cam.End3D2D()
		
	cam.End3D()
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	local hands, weapon = self:GetViewModels()
	
	self:CheckHands()
	
	local fire = self:GetHandAnim( "fire" )
	
	local reload_end = self:GetHandAnim( "reload_end" )
	
	if self:GetTFReloading() == true then
		
		self:SetTFInspecting( false )
		self:SetTFInspectLoop( false )
		
		if CurTime() > self:GetTFReloadTime() then
			
			if ( self:GetNextPrimaryFire() > CurTime() and self:Clip1() > 0 ) or self:Clip1() >= self:GetMaxClip1() or self:Ammo1() <= 0 then
				
				self:SetTFReloading( false )
				if self.SingleReload == true then self:SetVMAnimation( reload_end ) end
				
				return
				
			end
			
			if self.SingleReload == true then
				
				local reload_start = self:GetHandAnim( "reload_start" )
				
				if self:GetTFReloads() != 0 then
					
					self:GetOwner():RemoveAmmo( 1, self:GetPrimaryAmmoType() )
					self:SetClip1( self:Clip1() + 1 )
					
				end
				
				local reload_loop = self:GetHandAnim( "reload_loop" )
				
				if self:GetTFReloads() >= self:GetMaxClip1() - self:GetTFReloadAmmo() then
					
					self:SetVMAnimation( reload_end )
					self:SetTFReloading( false )
					
				else
					
					self:SetVMAnimation( reload_loop )
					self:SetTFReloadTime( CurTime() + hands:SequenceDuration( hands:LookupSequence( reload_loop ) ) )
					
				end
				
				self:SetTFReloads( self:GetTFReloads() + 1 )
				
			else
				
				local removeammo = self:GetMaxClip1() - self:Clip1()
				if self:Clip1() + self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ) < self:GetMaxClip1() then
					
					self:SetClip1( self:Clip1() + self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() ) )
					
				else
					
					self:SetClip1( self:GetMaxClip1() )
					
				end
				self:GetOwner():RemoveAmmo( removeammo, self:GetPrimaryAmmoType() )
				
			end
			
		end
		
	elseif CurTime() > self:GetNextPrimaryFire() and self:GetTFScoped() == false and self:GetTFScopeNext() == true then
		
		self:ScopeIn()
		
	end
	
	if game.SinglePlayer() == false and self:GetTFNextIdle() != -1 and CurTime() > self:GetTFNextIdle() then
		
		local idle = self:GetHandAnim( "idle" )
		
		hands:SetSequence( idle )
		
		self:SetTFNextIdle( CurTime() + hands:SequenceDuration( idle ) )
		
	end
	
	self:Inspect()
	
end

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	local bullet = {}
	bullet.Src = self:GetOwner():GetShootPos()
	bullet.Dir = self:GetOwner():GetAimVector()
	bullet.Tracer = 0
	bullet.AmmoType = self.Primary.Ammo
	bullet.Damage = self.Primary.Damage
	bullet.Num = self.Primary.Shots
	bullet.Spread = Vector( spread, spread )
	bullet.Force = self.Primary.Force
	bullet.Callback = function( attacker, tr, dmg )
		
		if SERVER and dmg != nil and IsValid( tr.Entity ) == true then
			
			if self:GetTFScoped() == true then
				
				if self.HeadshotEnabled == true and CurTime() - self.HeadshotDelay > self:GetTFScopeTime() and tr.HitGroup == HITGROUP_HEAD and self:OnCrit() != false then
					
					dmg:SetDamage( dmg:GetDamage() * self.CritMultiplier )
					
				end
				
				if ( CurTime() - self:GetTFScopeTime() ) * ( self.ChargeMultiplier / self.MaxScopeTime ) > self.ChargeDelay then
					
					local charge = ( CurTime() - self:GetTFScopeTime() ) / self.MaxScopeTime
					if charge < 0 then charge = 0 end
					if charge > 1 then charge = 1 end
					
					dmg:SetDamage( dmg:GetDamage() * ( self.ChargeMultiplier * charge ) )
					
				end
				
			end
			
			tr.Entity:TakeDamageInfo( dmg )
			dmg:SetAttacker( game.GetWorld() )
			dmg:SetInflictor( game.GetWorld() )
			dmg:SetDamage( 0 )
			
		end
		
	end
	
	self:DoPrimaryAttack( bullet )
	
	self:ScopeOut()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:SecondaryAttack()
	
	if CurTime() < self:GetNextSecondaryFire() or CurTime() < self:GetNextPrimaryFire() then return end
	
	self:SetNextSecondaryFire( CurTime() + 0.25 )
	
	if CLIENT then return end
	
	if self:GetTFScoped() == true then
		
		self:ScopeOut()
		
	else
		
		self:ScopeIn()
		
	end
	
	self:SetTFScopeNext( self.Scoped )
	
end

SWEP.Scope = Material( "hud/scope_sniper_ul" )
SWEP.ScopeColor = Color( 0, 0, 0, 255 )
SWEP.ChargeMeter = Material( "hud/sniperscope_numbers" )

SWEP.ChargeSoundPlayed = false

function SWEP:DrawHUDBackground()
	
	local hands, weapon = self:GetViewModels()
	
	self.DrawCrosshair = !self:GetTFScoped()
	
	local charge = ( CurTime() - self:GetTFScopeTime() ) / self.MaxScopeTime
	if charge < 0 then charge = 0 end
	if charge > 1 then charge = 1 end
	
	if charge != 1 then self.ChargeSoundPlayed = false end
	
	if self:GetTFScoped() == true then
		
		if charge == 1 and self.ChargeSoundPlayed != true then
			
			surface.PlaySound( self.ChargedSound )
			
			self.ChargeSoundPlayed = true
			
		end
		
		//self:DrawSniperDot()
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.Scope )
		
		local hinc = 4 / 3
		local size = math.min( ScrW(), ScrH() )
		
		local w = ( size * 0.5 ) * hinc
		local x = ScrW() * 0.5
		
		local h = size * 0.5
		local y = ScrH() * 0.5
		
		surface.DrawTexturedRectUV( x - w + 1, y - h, w, h, 0, 0, 1, 1 ) --topleft
		surface.DrawTexturedRectUV( x - 1, y - h, w, h, 1, 0, 0, 1 ) --topright
		surface.DrawTexturedRectUV( x - w + 1, y, w, h, 0, 1, 1, 0 ) --bottomleft
		surface.DrawTexturedRectUV( x - 1, y, w, h, 1, 1, 0, 0 ) --bottomright
		
		surface.SetDrawColor( self.ScopeColor )
		
		surface.DrawRect( 0, 0, x - w + 1, ScrH() ) --left
		surface.DrawRect( x + w - 1, 0, ScrW() - ( x + w - 1 ), ScrH() ) --right
		surface.DrawRect( 0, 0, ScrW(), y - h + 1 ) --top
		surface.DrawRect( y + h - 1, 0, ScrW(), ScrH() - ( y + h - 1 ) ) --bottom
		
		--charge meter
		surface.SetDrawColor( 255, 255, 255, 100 )
		surface.SetMaterial( self.ChargeMeter )
		
		local meter = math.Round( charge, 2 ) * 1.5
		
		self.ChargeMeter:SetMatrix( "$basetexturetransform", Matrix( {
			
			{ 1, 0, 0, 0 },
			{ 0, 1.7 - meter, 0, 0 },
			{ 0, 0, 1, 0 },
			{ 0, 0, 0, 1 },
			
		} ) )
		surface.DrawTexturedRectUV( x + ( size * 0.13 ), y - ( size * 0.125 ), size * 0.14, size * 0.25, 0, 0, 1, 1 )
		
	end
	
	hands:SetNoDraw( self:GetTFScoped() )
	weapon:SetNoDraw( self:GetTFScoped() )
	
end

function SWEP:TranslateFOV( fov )
	
	if self:GetTFScoped() == true then
		
		return fov - 60
		
	end
	
	return fov
	
end

function SWEP:AdjustMouseSensitivity()
	
	if self:GetTFScoped() == true then
		
		return -1
		
	end
	
end

function SWEP:Holster()
	
	self:RemoveHands()
	self:SetTFReloading( false )
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	self:SetTFScopeNext( false )
	self:ScopeOut()
	
	return true
	
end