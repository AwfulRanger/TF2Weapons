AddCSLuaFile()

if SERVER then
	
	util.AddNetworkString( "tf2weapons_minigun_spinreset" )
	util.AddNetworkString( "tf2weapons_minigun_spooling" )
	
else
	
	net.Receive( "tf2weapons_minigun_spinreset", function()
		
		local wep = net.ReadEntity()
		if IsValid( wep ) == true then wep:Holster() wep:RemoveHands( wep.LastOwner ) end
		timer.Simple( 0, function() if IsValid( wep ) == true then wep:Holster() wep:RemoveHands( wep.LastOwner ) end end )
		
	end )
	
	net.Receive( "tf2weapons_minigun_spooling", function()
		
		local wep = net.ReadEntity()
		if IsValid( wep ) == true then wep.IsSpooling = net.ReadBool() end
		
	end )
	
end

CreateConVar( "tf2weapons_minigun_revspeed", 110 / 230, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "What to multiply a revved up player's speed by (speed * value)" )
SWEP.TF2Weapons_MinigunRev = true

hook.Add( "SetupMove", "tf2weapons_minigun_revspeed", function( ply, mv, cmd )
	
	if IsValid( ply:GetActiveWeapon() ) == true and ply:GetActiveWeapon().TF2Weapons_MinigunRev == true and ply:GetActiveWeapon():GetTFSpooled() == true then
		
		if mv:KeyDown( IN_JUMP ) == true then mv:SetButtons( mv:GetButtons() - IN_JUMP ) end
		--this doesn't remove the extra speed you get from sprinting
		--if mv:KeyDown( IN_SPEED ) == true then mv:SetButtons( mv:GetButtons() - IN_SPEED ) end
		
		if mv:KeyDown( IN_DUCK ) == false then
			
			local forward = mv:GetForwardSpeed()
			if forward < 0 and forward < mv:GetMaxSpeed() then
				
				forward = -mv:GetMaxSpeed()
				
			elseif forward > 0 and forward > mv:GetMaxSpeed() then
				
				forward = mv:GetMaxSpeed()
				
			end
			local side = mv:GetSideSpeed()
			if side < 0 and side < mv:GetMaxSpeed() then
				
				side = -mv:GetMaxSpeed()
				
			elseif side > 0 and side > mv:GetMaxSpeed() then
				
				side = mv:GetMaxSpeed()
				
			end
			
			mv:SetForwardSpeed( forward * GetConVar( "tf2weapons_minigun_revspeed" ):GetFloat() )
			mv:SetSideSpeed( side * GetConVar( "tf2weapons_minigun_revspeed" ):GetFloat() )
			
		else
			
			mv:SetForwardSpeed( 0 )
			mv:SetSideSpeed( 0 )
			
		end
		
	end
	
end )

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.BIGCIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 384

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_minigun_large" ) end
SWEP.PrintName = "Minigun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Minigun"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { TF2Weapons.Class.HEAVY }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_minigun/c_minigun.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_minigun/c_minigun.mdl"
SWEP.HandModel = "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.HoldType = "crossbow"
function SWEP:GetAnimations()
	
	return "m"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end
SWEP.MuzzleParticle = "muzzle_minigun_constant"
SWEP.EndMuzzleParticle = "muzzle_minigun"

SWEP.SingleReload = false
SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_minigun"
SWEP.Primary.Damage = 9
SWEP.Primary.Shots = 4
SWEP.Primary.Spread = 0.075
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.1

SWEP.CritStream = true

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/minigun_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/minigun_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/minigun_empty.wav" )
	self.SpoolUpSound = Sound( "weapons/minigun_wind_up.wav" )
	self.SpoolIdleSound = Sound( "weapons/minigun_spin.wav" )
	self.SpoolDownSound = Sound( "weapons/minigun_wind_down.wav" )
	
end

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "Spooled", false )
	self:TFNetworkVar( "Bool", "SpoolDownNext", false )
	self:TFNetworkVar( "Bool", "MuzzleParticleActive", false )
	
	self:TFNetworkVar( "Float", "NextSpool", 0 )
	self:TFNetworkVar( "Float", "NextSpoolFire", 0 )
	self:TFNetworkVar( "Float", "MuzzleParticleRemove", 0 )
	
end

function SWEP:Initialize()
	
	self:DoInitialize()
	
	self:PrecacheParticles( { self.MuzzleParticle, self.EndMuzzleParticle } )
	
end

SWEP.SpoolTime = 0.87

function SWEP:SpoolUp()
	
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	
	self:SetTFSpooled( true )
	self:SetTFNextSpool( CurTime() + self.SpoolTime )
	self:SetTFNextSpoolFire( CurTime() + self.SpoolTime )
	
	self:PlaySound( self.SpoolUpSound )
	self:SetVMAnimation( self:GetHandAnim( "spool_up" ) )
	
end

function SWEP:SpoolDown()
	
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	
	self:SetTFSpooled( false )
	self:SetTFNextSpool( CurTime() + self.SpoolTime )
	self:SetTFSpoolDownNext( false )
	
	self:PlaySound( self.SpoolDownSound )
	self:SetVMAnimation( self:GetHandAnim( "spool_down" ) )
	
end

function SWEP:Spooling()
	
	if IsValid( self:GetOwner() ) == true and CurTime() > self:GetNextSecondaryFire() and ( self:GetOwner():KeyDown( IN_ATTACK ) == true or self:GetOwner():KeyDown( IN_ATTACK2 ) == true ) then return true end
	
	return false
	
end

SWEP.MaxSpinSpeed = 100
SWEP.SpinAngle = 0
SWEP.SpinSpeed = 0
SWEP.LastBarrelBone = 0
SWEP.LastBarrelAngle = Angle( 0, 0, 0 )

SWEP.SpinUpSpeed = 1.1
SWEP.SpinDownSpeed = 0.96

function SWEP:Spool()
	
	local hands, weapon = self:GetViewModels()
	
	if self:GetTFSpooled() == true then
		
		if CurTime() > self:GetTFNextSpoolFire() and self:Spooling() == false then self:SetTFSpoolDownNext( true ) end
		
		if CurTime() > self:GetTFNextSpool() then
			
			if self:GetTFSpoolDownNext() == true and CurTime() > self:GetNextPrimaryFire() then
				
				self:SpoolDown()
				
			elseif self:GetOwner():KeyDown( IN_ATTACK ) == false and CurTime() > self:GetNextPrimaryFire() then
				
				self:SetTFInspecting( false )
				self:SetTFInspectLoop( false )
				self:PlaySound( self.SpoolIdleSound )
				self:SetVMAnimation( self:GetHandAnim( "spool_idle" ) )
				if self:GetTFMuzzleParticleActive() == true and CurTime() > self:GetTFMuzzleParticleRemove() then
					
					self:StopParticles()
					if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then weapon:StopParticles() end
					if self.ViewModelParticles == true then
						
						self:AddParticle( self.EndMuzzleParticle, "muzzle", weapon )
						
					else
						
						self:AddParticle( self.EndMuzzleParticle, "muzzle" )
						
					end
					
					self:SetTFMuzzleParticleActive( false )
					
				end
				
			elseif ( self.Primary.ClipSize >= 0 and self:Clip1() <= 0 ) or ( self.Primary.ClipSize < 0 and self:Ammo1() <= 0 ) then
				
				self:SetTFInspecting( false )
				self:SetTFInspectLoop( false )
				self:SetVMAnimation( self:GetHandAnim( "spool_idle" ) )
				if self:GetTFMuzzleParticleActive() == true and CurTime() > self:GetTFMuzzleParticleRemove() then
					
					self:StopParticles()
					if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then weapon:StopParticles() end
					if self.ViewModelParticles == true then
						
						self:AddParticle( self.EndMuzzleParticle, "muzzle", weapon )
						
					else
						
						self:AddParticle( self.EndMuzzleParticle, "muzzle" )
						
					end
					
					self:SetTFMuzzleParticleActive( false )
					
				end
				
			end
			
		end
		
		if self.SpinSpeed <= 0 then self.SpinSpeed = 1 end
		self.SpinSpeed = self.SpinSpeed * self.SpinUpSpeed
		
	elseif self:GetTFSpooled() == false then
		
		if self:GetTFMuzzleParticleActive() == true and CurTime() > self:GetTFMuzzleParticleRemove() then
			
			self:StopParticles()
			if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then weapon:StopParticles() end
			if self.ViewModelParticles == true then
				
				self:AddParticle( self.EndMuzzleParticle, "muzzle", weapon )
				
			else
				
				self:AddParticle( self.EndMuzzleParticle, "muzzle" )
				
			end
			
			self:SetTFMuzzleParticleActive( false )
			
		end
		
		if self:Spooling() == true then
			
			self:SpoolUp()
			
		else
			
			if self.SpinSpeed <= 0.1 then self.SpinSpeed = 0 end
			self.SpinSpeed = self.SpinSpeed * self.SpinDownSpeed
			
		end
		
	end
	
	if self.SpinSpeed < 0 then
		
		self.SpinSpeed = 0
		
	elseif self.SpinSpeed > self.MaxSpinSpeed then
		
		self.SpinSpeed = self.MaxSpinSpeed
		
	end
	
	if self.SpinAngle < 0 then
		
		self.SpinAngle = self.SpinAngle + 360
		
	elseif self.SpinAngle > 360 then
		
		self.SpinAngle = self.SpinAngle
		
	end
	
	if CLIENT then
		
		self.SpinAngle = self.SpinAngle + self.SpinSpeed
		
		if IsValid( self:GetOwner() ) == true and IsValid( hands ) == true and IsValid( weapon ) == true then
			
			local bone = weapon:LookupBone( "barrel" )
			weapon:ManipulateBoneAngles( bone, Angle( 0, self.SpinAngle, 0 ) )
			
		end
		
		local bone = self:LookupBone( "barrel" )
		self:ManipulateBoneAngles( bone, Angle( 0, self.SpinAngle, 0 ) )
		
	end
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:SetTFLastOwner( self:GetOwner() )
	
	self:CheckHands()
	
	self:Spool()
	
	self:Idle()
	
	self:HandleCritStreams()
	
	self:Inspect()
	
end

function SWEP:CanPrimaryAttack()
	
	if self:GetTFSpooled() == false or CurTime() < self:GetTFNextSpoolFire() then
		
		return false
		
	elseif self.Primary.ClipSize >= 0 and self:Clip1() <= 0 then
		
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:Reload()
		return false
		
	elseif self.Primary.ClipSize < 0 and self:Ammo1() <= 0 then
		
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self:PlaySound( self.EmptySound )
		return false
		
	elseif CurTime() < self:GetNextPrimaryFire() then
		
		return false
		
	end
	
	return true
	
end

function SWEP:DoPrimaryAttack( bullet, crit )
	
	self:SetTFReloading( false )
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	
	self:SetTFPrimaryLastShot( CurTime() )
	
	local crit = self:DoCrit()
	
	if bullet != nil then self:GetOwner():FireBullets( bullet ) end
	
	local fire = self:GetHandAnim( "fire" )
	self:SetVMAnimation( fire )
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	if self:GetTFMuzzleParticleActive() == false then
		
		if self.ViewModelParticles == true then
			
			local hands, weapon = self:GetViewModels()
			self:AddParticle( self.MuzzleParticle, "muzzle", weapon )
			
		else
			
			self:AddParticle( self.MuzzleParticle, "muzzle" )
			
		end
		
		self:SetTFMuzzleParticleActive( true )
		
	end
	
	self:SetTFMuzzleParticleRemove( CurTime() + ( engine.TickInterval() * 10 ) )
	
	local sound = self.ShootSound
	if crit == true and self.ShootSoundCrit != nil then sound = self.ShootSoundCrit end
	
	self:PlaySound( sound )
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	
end

function SWEP:Deploy()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	local hands, weapon = self:GetViewModels()
	
	self:SetTFLastOwner( self:GetOwner() )
	
	self:DoDeploy()
	self:SetTFSpooled( false )
	self:SetTFNextSpool( 0 )
	self:SetTFNextSpoolFire( 0 )
	self:SetTFSpoolDownNext( false )
	
	if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then
		
		self.LastBarrelBone = weapon:LookupBone( "barrel" )
		self.LastBarrelAngle = weapon:GetManipulateBoneAngles( self.LastBarrelBone )
		
	end
	if isangle( self.LastBarrelAngle ) == false then self.LastBarrelAngle = Angle( 0, 0, 0 ) end
	
	return true
	
end

function SWEP:ResetSpool( ang, bone )
	
	--if isangle( ang ) == false then ang = self.LastBarrelAngle end
	if isangle( ang ) == false then ang = Angle( 0, 0, 0 ) end
	if isnumber( bone ) == false then bone = self.LastBarrelBone end
	local hands, weapon = self:GetViewModels( self:GetTFLastOwner() )
	if IsValid( self:GetTFLastOwner() ) == true and IsValid( weapon ) == true and ang != nil and bone != nil then weapon:ManipulateBoneAngles( bone, ang ) end
	
end

function SWEP:Holster()
	
	self:DoHolster()
	
	if self:Spooling() == false and CurTime() > self:GetTFNextSpool() then
		
		self:SetTFSpooled( false )
		self:SetTFNextSpool( 0 )
		self:SetTFNextSpoolFire( 0 )
		self:SetTFSpoolDownNext( false )
		
		if CLIENT then self:ResetSpool() end
		
		return true
		
	else
		
		return false
		
	end
	
end

function SWEP:OnDrop()
	
	self:Holster()
	if CLIENT then self:ResetSpool() end
	self:RemoveHands( self:GetTFLastOwner() )
	
	net.Start( "tf2weapons_minigun_spinreset" )
		
		net.WriteEntity( self )
		
	net.Broadcast()
	
end

function SWEP:OnRemove()
	
	self:Holster()
	if CLIENT then self:ResetSpool() end
	
end

function SWEP:Reload()
end