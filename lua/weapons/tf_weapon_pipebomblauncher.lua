AddCSLuaFile()

if SERVER then
	
	util.AddNetworkString( "tf_weapon_pipebomblauncher_insert" )
	
else
	
	game.AddParticles( "particles/explosion.pcf" )
	game.AddParticles( "particles/stickybomb.pcf" )
	
	net.Receive( "tf_weapon_pipebomblauncher_insert", function()
		
		local wep = net.ReadEntity()
		local pipe = net.ReadEntity()
		if IsValid( wep ) == true then table.insert( wep.Pipebombs, 1, pipe ) end
		
	end )
	
end

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 224

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_stickybomb_launcher_large" ) end
SWEP.PrintName = "Stickybomb Launcher"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Stickybomb Launcher"
SWEP.Base = "tf2_base"
SWEP.Classes = { TF2Weapons.Class.DEMOMAN }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_stickybomb_launcher/c_stickybomb_launcher.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_stickybomb_launcher/c_stickybomb_launcher.mdl"
SWEP.HandModel = "models/weapons/c_models/c_demo_arms.mdl"
SWEP.HoldType = "smg"
function SWEP:GetAnimations()
	
	return "sb"
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end

SWEP.SingleReload = true
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 32
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2_pipebomb"
SWEP.Primary.Damage = 60
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.005
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.6

SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "tf2_pipebomb"

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/stickybomblauncher_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/stickybomblauncher_shoot_crit.wav" )
	self.ChargeSound = Sound( "weapons/stickybomblauncher_charge_up.wav" )
	self.DetonateSound = Sound( "weapons/stickybomblauncher_det.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end
SWEP.MuzzleParticle = "muzzle_pipelauncher"

SWEP.MaxPipebombs = 8

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "Charging", false )
	self:TFNetworkVar( "Bool", "CanDetonate", false )
	
	self:TFNetworkVar( "Float", "ChargeStart", 0 )
	
	self:TFNetworkVar( "Int", "Pipebombs", 0 )
	
end

function SWEP:GetCharge()
	
	local charge = ( CurTime() - self:GetTFChargeStart() ) / self.ChargeTime
	if charge < 0 or self:GetTFCharging() != true then charge = 0 end
	if charge > 1 then charge = 1 end
	
	return charge
	
end

function SWEP:DoDrawCrosshair( x, y )
	
	self:OnDrawCrosshair( x, y )
	
	self:DrawMeter( self:GetCharge() )
	
	return true
	
end

function SWEP:GetPipebombModel()
	
	return "models/weapons/w_models/w_stickybomb.mdl"
	
end
SWEP.PipebombParticles = {
	
	red_trail = "stickybombtrail_red",
	blue_trail = "stickybombtrail_blue",
	red_crittrail = "critical_pipe_red",
	blue_crittrail = "critical_pipe_blue",
	red_explode = "explosioncore_midair",
	blue_explode = "explosioncore_midair",
	red_critexplode = "explosioncore_midair",
	blue_critexplode = "explosioncore_midair",
	
}
SWEP.PipebombRadius = 146
SWEP.PipebombSpeed = 900
SWEP.PipebombSpeedCharged = 2400
SWEP.PipebombTime = 0.7

function SWEP:Initialize()
	
	self:DoInitialize()
	
	self:PrecacheParticles( self.PipebombParticles )
	self:PrecacheParticles( self.MuzzleParticle )
	
end

SWEP.PipebombSkinRED = 0
SWEP.PipebombSkinBLU = 1

function SWEP:SetProjectileModel( pipebomb, model, num )
	
	if model == nil then return end
	local _model
	
	if istable( model ) == true then
		
		if num == nil then num = math.random( #model ) end
		_model = model[ num ]
		
	else
		
		_model = model
		
	end
	
	local skin = self.PipebombSkinRED
	if self:GetTeam() == true then skin = self.PipebombSkinBLU end
	
	pipebomb:SetPipebombSkin( skin )
	pipebomb:SetPipebombModel( _model )
	return _model
	
end

function SWEP:GetProjectileParticles()
	
	local pp = self.PipebombParticles
	
	local trail
	local explode
	
	if self:GetTeam() != true then
		
		if self:ShouldCrit() != true then
			
			trail = pp.red_trail
			explode = pp.red_explode
			
		else
			
			trail = pp.red_crittrail
			explode = pp.red_critexplode
			
		end
		
	else
		
		if self:ShouldCrit() != true then
			
			trail = pp.blue_trail
			explode = pp.blue_explode
			
		else
			
			trail = pp.blue_crittrail
			explode = pp.blue_critexplode
			
		end
		
	end
	
	return {
		
		trail = trail,
		explode = explode,
		
	}
	
end

SWEP.ChargeTime = 4

function SWEP:Charge()
	
	if self:CanPrimaryAttack() != true then return end
	
	if self:GetOwner():KeyDown( IN_ATTACK ) == true then
		
		if self:GetTFCharging() != true then
			
			self:SetTFCharging( true )
			self:SetTFChargeStart( CurTime() )
			
			local auto_fire = self:GetHandAnim( "auto_fire" )
			self:SetVMAnimation( auto_fire )
			
			self:PlaySound( self.ChargeSound )
			
		end
		
		if CurTime() > self:GetTFChargeStart() + self.ChargeTime then
			
			self:PrimaryAttack( true )
			
			self:SetTFCharging( false )
			self:SetTFChargeStart( 0 )
			
		end
		
	elseif self:GetTFCharging() == true then
		
		self:PrimaryAttack( true )
		
		self:SetTFCharging( false )
		self:SetTFChargeStart( 0 )
		
	end
	
end

SWEP.Pipebombs = {}

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self.LastOwner = self:GetOwner()
	
	self:CheckHands()
	
	self:DoReload()
	
	if self:GetTFPipebombs() > self.MaxPipebombs then
		
		if IsValid( self.Pipebombs[ self:GetTFPipebombs() ] ) == true then
			
			self.Pipebombs[ self:GetTFPipebombs() ]:Explode( true )
			
		end
		
		self.Pipebombs[ self:GetTFPipebombs() ] = nil
		
		self:SetTFPipebombs( self:GetTFPipebombs() - 1 )
		
	end
	
	self:Charge()
	
	self:Idle()
	
	self:HandleCritStreams()
	
	self:Inspect()
	
end

function SWEP:PrimaryAttack( charged, charge )
	
	if charged != true or self:CanPrimaryAttack() == false then return end
	
	if SERVER then
		
		for i = 1, self.Primary.Shots do
			
			local pipebomb = ents.Create( "tf_projectile_pipebomb" )
			if IsValid( pipebomb ) == true then
				
				local tracefilter = function( ent ) if ent == pipebomb or ent == self:GetOwner() or ent:GetClass() == pipebomb:GetClass() then return false end return true end
				
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
				local starttrace = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector():Angle():Up() * -6 ) + ( self:GetOwner():GetAimVector():Angle():Right() * 8 ) + ( self:GetOwner():GetAimVector() * 32 ), filter = tracefilter } )
				local hittrace = util.TraceLine( { start = starttrace.HitPos, endpos = self:GetOwner():GetShootPos() + ( ( self:GetOwner():GetAimVector():Angle() + Angle( math.random( -90, 90 ) * self.Primary.Spread, math.random( -90, 90 ) * self.Primary.Spread, 0 ) ):Forward() * 32768 ), filter = tracefilter } )
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
				
				pipebomb:SetOwner( self:GetOwner() )
				pipebomb:SetPos( starttrace.HitPos )
				pipebomb:SetPipebombBLU( self:GetTeam() )
				self:SetProjectileModel( pipebomb, self:GetPipebombModel() )
				pipebomb:SetPipebombParticles( self:GetProjectileParticles() )
				pipebomb:SetAngles( ( hittrace.HitPos - starttrace.HitPos ):Angle() )
				pipebomb:SetPipebombDamage( self.Primary.Damage )
				pipebomb:SetPipebombCrit( self:DoCrit() )
				pipebomb:SetPipebombCritMultiplier( self.CritMultiplier )
				pipebomb:SetPipebombRadius( self.PipebombRadius )
				pipebomb:SetPipebombTime( CurTime() + self.PipebombTime )
				pipebomb:Spawn()
				pipebomb:PhysWake()
				if IsValid( pipebomb:GetPhysicsObject() ) == true then
					
					if charge == nil then charge = self:GetCharge() end
					
					local default = self.PipebombSpeed
					local extra = self.PipebombSpeedCharged - self.PipebombSpeed
					
					local speed = default + ( extra * charge )
					
					pipebomb:GetPhysicsObject():SetVelocity( pipebomb:GetAngles():Forward() * speed )
					if IsValid( self:GetOwner() ) == true then pipebomb:GetPhysicsObject():ApplyForceOffset( self:GetOwner():GetAimVector():Angle():Up() * self.PipebombSpeed, pipebomb:GetPos() + pipebomb:GetAngles():Right() ) end
					
				end
				
				local pipebombtrace = util.TraceLine( { start = starttrace.HitPos, endpos = pipebomb:GetPos() + ( pipebomb:GetAngles():Forward() * 32 ), filter = tracefilter } )
				
				if starttrace.Hit == true or pipebombtrace.Hit == true then pipebomb:SetPos( self:GetOwner():GetShootPos() ) end
				
			end
			
			table.insert( self.Pipebombs, 1, pipebomb )
			
			self:SetTFPipebombs( self:GetTFPipebombs() + 1 )
			
			timer.Simple( 0, function()
				
				net.Start( "tf_weapon_pipebomblauncher_insert" )
					
					net.WriteEntity( self )
					net.WriteEntity( pipebomb )
					
				net.Broadcast()
				
			end )
			
		end
		
	end
	
	self:DoPrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:RemovePipes( explode, force, mute )
	
	local playsound = false
	
	for _, v in pairs( self.Pipebombs ) do
		
		if force != true then
			
			if IsValid( v ) == true and CurTime() > v:GetPipebombTime() then
				
				playsound = true
				
				if SERVER then
					
					if explode == true then
						
						v:Explode( true )
						
					else
						
						v:Remove()
						
					end
					
				end
				
				self.Pipebombs[ _ ] = nil
				
				self:SetTFPipebombs( self:GetTFPipebombs() - 1 )
				
			elseif IsValid( v ) == false then
				
				self.Pipebombs[ _ ] = nil
				
				self:SetTFPipebombs( self:GetTFPipebombs() - 1 )
				
			end
			
		else
			
			if IsValid( v ) == true then
				
				if CurTime() > v:GetPipebombTime() then playsound = true end
				
				if SERVER then
					
					if explode == true then
						
						v:Explode( true )
						
					else
						
						v:Remove()
						
					end
					
				end
				
			end
			
			self.Pipebombs[ _ ] = nil
			
			self:SetTFPipebombs( self:GetTFPipebombs() - 1 )
			
		end
		
	end
	
	if playsound == true and mute != true then self:PlaySound( self.DetonateSound ) end
	
end

function SWEP:SecondaryAttack()
	
	self:RemovePipes( true )
	
end

function SWEP:Holster()
	
	self:DoHolster()
	
	if self:GetTFCharging() == true then
		
		self:PrimaryAttack( true )
		
		self:SetTFCharging( false )
		self:SetTFChargeStart( 0 )
		
	end
	
	return true
	
end

function SWEP:OnRemove()
	
	self:Holster()
	self:RemoveHands( self.LastOwner )
	self:RemovePipes( false )
	
end

function SWEP:OnDrop()
	
	self:Holster()
	self:RemoveHands( self.LastOwner )
	self:RemovePipes( false )
	
end

function SWEP:OwnerChanged()
	
	self:Holster()
	self:RemoveHands( self.LastOwner )
	self:RemovePipes( false )
	
end

function SWEP:CustomAmmoDisplay()
	
	return {
		
		Draw = true,
		
		PrimaryClip = self:Clip1(),
		PrimaryAmmo = self:Ammo1(),
		
		SecondaryAmmo = self:GetTFPipebombs(),
		
	}
	
end