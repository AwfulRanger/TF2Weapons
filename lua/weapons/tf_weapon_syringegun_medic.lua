AddCSLuaFile()

game.AddParticles( "particles/muzzle_flash.pcf" )
game.AddParticles( "particles/nailtrails.pcf" )

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIconX = 0
SWEP.KillIconY = 352

SWEP.IconOverride = "backpack/weapons/w_models/w_syringegun_large"
if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( SWEP.IconOverride ) end
SWEP.PrintName = "#TF_Weapon_SyringeGun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Medic"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_SyringeGun"
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
SWEP.SyringeParticles = {
	
	red_trail = "nailtrails_medic_red",
	blue_trail = "nailtrails_medic_blue",
	red_crittrail = "nailtrails_medic_red_crit",
	blue_crittrail = "nailtrails_medic_blue_crit",
	
}
SWEP.SyringeSpeed = 1000

SWEP.SyringeClass = "tf_projectile_syringe"

function SWEP:Initialize()
	
	self:DoInitialize()
	
	--if CLIENT then self:AddKillIcon( self.KillIcon, self.KillIconColor, self.KillIconX, self.KillIconY, self.KillIconW, self.KillIconH, self.SyringeClass ) end
	
	self:PrecacheParticles( self.SyringeParticles )
	
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
	
	syringe:SetSkin( skin )
	syringe:SetModel( _model )
	return _model
	
end

function SWEP:GetProjectileParticles( crit )
	
	local pp = self.SyringeParticles
	
	local trail
	
	if self:GetTeam() ~= true then
		
		if self:ShouldCrit() ~= true then
			
			trail = pp.red_trail
			
		else
			
			trail = pp.red_crittrail
			
		end
		
	else
		
		if self:ShouldCrit() ~= true then
			
			trail = pp.blue_trail
			
		else
			
			trail = pp.blue_crittrail
			
		end
		
	end
	
	return {
		
		trail = trail,
		
	}
	
end

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	if game.SinglePlayer() == true then self:CallOnClient( "PrimaryAttack" ) end
	
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
				syringe:SetParticles( self:GetProjectileParticles() )
				syringe:SetAngles( ( hittrace.HitPos - starttrace.HitPos ):Angle() )
				syringe:SetTFDamage( self:GetDamageMods( self.Primary.Damage ) )
				syringe:Spawn()
				syringe:PhysWake()
				if IsValid( syringe:GetPhysicsObject() ) == true then
					
					syringe:GetPhysicsObject():SetVelocity( syringe:GetAngles():Forward() * ( self.SyringeSpeed * 2 ) )
					
				end
				
			end
			
		end
		
	end
	
	self:DoPrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end