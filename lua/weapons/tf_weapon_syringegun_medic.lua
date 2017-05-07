AddCSLuaFile()

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 352

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_syringegun_large" ) end
SWEP.PrintName = "Syringe Gun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Syringe Gun"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.MEDIC ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_syringegun/c_syringegun.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_syringegun/c_syringegun.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_medic_arms.mdl" )
SWEP.HoldType = "smg"
function SWEP:GetAnimations()
	
	return "sg"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end

SWEP.SingleReload = false
SWEP.Attributes = {}

SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 190
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_syringe"
SWEP.Primary.Damage = 10
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.025
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.1

SWEP.CritStream = true

function SWEP:SetVariables()
	
	self.ShootSound = Sound( "weapons/syringegun_shoot.wav" )
	self.ShootSoundCrit = Sound( "weapons/syringegun_shoot_crit.wav" )
	self.EmptySound = Sound( "weapons/shotgun_empty.wav" )
	
end
SWEP.MuzzleParticle = "muzzle_syringe"

function SWEP:GetSyringeModel()
	
	return "models/weapons/w_models/w_syringe_proj.mdl"
	
end
SWEP.SyringeSpeed = 1000

SWEP.SyringeClass = "tf_projectile_syringe"

function SWEP:Initialize()
	
	self:DoInitialize()
	
	if CLIENT then self:AddKillIcon( self.KillIcon, self.KillIconColor, self.KillIconX, self.KillIconY, self.KillIconW, self.KillIconH, self.SyringeClass ) end
	
end

SWEP.SyringeSkinRED = 0
SWEP.SyringeSkinBLU = 1

function SWEP:SetProjectileModel( syringe, model, num )
	
	if model == nil then return end
	local _model
	
	if istable( model ) == true then
		
		if num == nil then num = math.random( #model ) end
		_model = model[ num ]
		
		
	else
		
		_model = model
		
	end
	
	local skin = self.SyringeSkinRED
	if self:GetTeam() == true then skin = self.SyringeSkinBLU end
	
	syringe:SetSyringeSkin( skin )
	syringe:SetSyringeModel( _model )
	return _model
	
end

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	if SERVER then
		
		for i = 1, self.Primary.Shots do
			
			local syringe = ents.Create( self.SyringeClass )
			if IsValid( syringe ) == true then
				
				local tracefilter = function( ent ) if ent == syringe or ent == self:GetOwner() or ent:GetClass() == syringe:GetClass() then return false end return true end
				
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
				local starttrace = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():EyeAngles():Up() * -6 ) + ( self:GetOwner():EyeAngles():Right() * 8 ) + ( self:GetOwner():GetAimVector() * 32 ), filter = tracefilter } )
				local hittrace = util.TraceLine( { start = starttrace.HitPos, endpos = self:GetOwner():GetShootPos() + ( ( self:GetOwner():EyeAngles() + Angle( math.random( -90, 90 ) * self.Primary.Spread, math.random( -90, 90 ) * self.Primary.Spread, 0 ) ):Forward() * 32768 ), filter = tracefilter } )
				if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
				
				syringe:SetOwner( self:GetOwner() )
				syringe:SetPos( starttrace.HitPos )
				self:SetProjectileModel( syringe, self:GetSyringeModel() )
				syringe:SetAngles( ( hittrace.HitPos - starttrace.HitPos ):Angle() )
				syringe:SetSyringeDamage( self:GetDamageMods( self.Primary.Damage ) )
				syringe:Spawn()
				syringe:PhysWake()
				if IsValid( syringe:GetPhysicsObject() ) == true then
					
					syringe:GetPhysicsObject():SetVelocity( syringe:GetAngles():Forward() * self.SyringeSpeed )
					
				end
				
			end
			
		end
		
	end
	
	self:DoPrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end