AddCSLuaFile()

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.BounceWeaponIcon = false
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.CrosshairType = TF2Weapons.Crosshair.DEFAULT
SWEP.KillIcon = Material( "hud/dneg_images_v2" )
SWEP.KillIconColor = Color( 255, 255, 255, 255 )
SWEP.KillIconX = 0
SWEP.KillIconY = 0
SWEP.KillIconW = 96
SWEP.KillIconH = 32

SWEP.PrintName = "TF2Weapons Melee Base"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 101
SWEP.Type = "Weapon Base"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { TF2Weapons.Class.NONE }
SWEP.Quality = TF2Weapons.Quality.DEVELOPER

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_bat.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_bat.mdl"
SWEP.HandModel = "models/weapons/c_models/c_scout_arms.mdl"
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "b"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Range = 66
SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 35
SWEP.Primary.Force = 10
SWEP.Primary.Delay = 0.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CritChance = 0.15

--[[
	Name:	SWEP:SetVariables()
	
	Desc:	If you've got any variables that should be able to have different types, define them here.
			
			For example, SWEP:PlaySound() can take either a string or a table as the first argument, so if you
			want SWEP.ShootSound to be a string in this weapon, but allow it to be a table for weapons using this
			as a base without lua getting upset, define it here.
]]--
function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/cbar_miss1.wav" )
	self.SwingSoundCrit = Sound( "weapons/cbar_miss1_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/cbar_hit1.wav" ), Sound( "weapons/cbar_hit2.wav" ) }
	self.HitFleshSound = Sound( "weapons/bat_hit.wav" )
	
end

--[[
	Name:	SWEP:BaseDataTables()
	
	Desc:	Creates the default networked variables
	
	Ret1:	A table of unused IDs for each type
]]--
function SWEP:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "Inspecting", false )
	self:TFNetworkVar( "Bool", "InspectLoop", false )
	self:TFNetworkVar( "Bool", "PreventInspect", false )
	self:TFNetworkVar( "Bool", "Reloading", false )
	self:TFNetworkVar( "Bool", "Swinging", false )
	self:TFNetworkVar( "Bool", "CritStreamActive", false )
	self:TFNetworkVar( "Bool", "NextHitCrit", false )
	
	self:TFNetworkVar( "Float", "NextInspect", 0 )
	self:TFNetworkVar( "Float", "NextIdle", 0 )
	self:TFNetworkVar( "Float", "PrimaryLastShot", 0 )
	self:TFNetworkVar( "Float", "ReloadTime", 0 )
	self:TFNetworkVar( "Float", "NextHit", 0 )
	self:TFNetworkVar( "Float", "CritStreamEnd", 0 )
	self:TFNetworkVar( "Float", "CritStreamNextCheck", 0 )
	
	self:TFNetworkVar( "Int", "Reloads", 0 )
	self:TFNetworkVar( "Int", "ReloadAmmo", 0 )
	
	self:TFNetworkVar( "Entity", "LastOwner", nil )
	
	return self.CreatedNetworkVars
	
end

--[[
	Name:	SWEP:Initialize()
	
	Desc:	Basic functions to initialize the weapon
]]--
function SWEP:Initialize()
	
	self:DoInitialize()
	
end

--[[
	Name:	SWEP:DoSwing( hit, damage, ent, keepcrit )
	
	Desc:	Called when the swing is over and it's time to hit something
	
	Arg1:	Set to false to suppress damage and other events
	
	Arg2:	How much damage to do. If unspecified, will use SWEP.Primary.Damage
	
	Arg3:	Entity to damage. If unspecified, will use whatever entity the traces hit
	
	Arg4:	Don't prevent the next hit from critting
	
	Ret1:	The last trace performed
]]--
function SWEP:DoSwing( hit, damage, ent, keepcrit )
	
	local trace
	
	if damage == nil then damage = self.Primary.Damage end
	damage = self:GetDamageMods( damage )
	
	if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
	trace = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.Primary.Range, filter = self:GetOwner(), mask = MASK_SHOT } )
	if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
	
	if trace.Hit == false then
		
		if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
		trace = util.TraceHull( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * ( self.Primary.Range - 10 ), mins = Vector( -10, -10, -10 ), maxs = Vector( 10, 10, 10 ), filter = self:GetOwner(), mask = MASK_SHOT_HULL } )
		if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
		
	end
	
	if IsValid( ent ) == false then ent = trace.Entity end
	
	if hit != false then
		
		if ent != nil and ent != NULL then
			
			if game.SinglePlayer() == true then
				
				local dmg = DamageInfo()
				dmg:SetInflictor( self )
				dmg:SetAttacker( self:GetOwner() )
				dmg:SetReportedPosition( self:GetOwner():GetPos() )
				dmg:SetDamagePosition( trace.HitPos )
				dmg:SetDamageForce( ( trace.Normal * 1000 ) * self.Primary.Force )
				dmg:SetDamage( damage )
				dmg:SetDamageType( DMG_CLUB )
				ent:TakeDamageInfo( dmg )
				--if IsValid( ent:GetPhysicsObjectNum( trace.PhysicsBone ) ) == true then ent:GetPhysicsObjectNum( trace.PhysicsBone ):ApplyForceOffset( ( trace.Normal * 1000 ) * self.Primary.Force, trace.HitPos ) end
				
				local sound
				
				if ent:IsPlayer() == true or ent:IsNPC() == true then
					
					sound = self.HitFleshSound
					
				else
					
					sound = self.HitWorldSound
					
				end
				
				if istable( sound ) == true then
					
					self:EmitSound( sound[ math.random( #sound ) ] )
					
				else
					
					self:EmitSound( sound )
					
				end
				
			elseif SERVER and ent:IsWorld() != true then
				
				local dmg = DamageInfo()
				dmg:SetInflictor( self )
				dmg:SetAttacker( self:GetOwner() )
				dmg:SetReportedPosition( self:GetOwner():GetPos() )
				dmg:SetDamagePosition( trace.HitPos )
				dmg:SetDamageForce( ( self:GetOwner():GetForward() * 2000 ) * self.Primary.Force )
				dmg:SetDamage( damage )
				dmg:SetDamageType( DMG_CLUB )
				ent:TakeDamageInfo( dmg )
				if IsValid( ent:GetPhysicsObjectNum( trace.PhysicsBone ) ) == true then ent:GetPhysicsObjectNum( trace.PhysicsBone ):ApplyForceOffset( ( trace.Normal * 1000 ) * self.Primary.Force, trace.HitPos ) end
				
			elseif CLIENT and IsFirstTimePredicted() == true then
				
				local sound
				
				if ent:IsPlayer() == true or ent:IsNPC() == true then
					
					sound = self.HitFleshSound
					
				else
					
					sound = self.HitWorldSound
					
				end
				
				if istable( sound ) == true then
					
					EmitSound( sound[ math.random( #sound ) ], trace.HitPos, self:EntIndex() )
					
				else
					
					EmitSound( sound, trace.HitPos, self:EntIndex() )
					
				end
				
			end
			
			if self.HitDecals[ trace.MatType ] != nil then
				
				util.Decal( self.HitDecals[ trace.MatType ], self:GetOwner():GetShootPos(), trace.HitPos + trace.Normal * 10 )
				
			else
				
				util.Decal( "impact.concrete", self:GetOwner():GetShootPos(), trace.HitPos + trace.Normal * 10 )
				
			end
			
		end
		
		self:SetTFSwinging( false )
		if keepcrit != true then self:SetTFNextHitCrit( false ) end
		
	end
	
	return trace
	
end

--[[
	Name:	SWEP:Think()
	
	Desc:	Ran each tick/frame
]]--
function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	local hands, weapon = self:GetViewModels()
	
	self:SetTFLastOwner( self:GetOwner() )
	
	self:CheckHands()
	
	if self:GetTFSwinging() == true and CurTime() > self:GetTFNextHit() then self:DoSwing() end
	
	self:Idle()
	
	self:Inspect()
	
end

--[[
	Name:	SWEP:DoHolster()
	
	Desc:	Default weapon holster
]]--
function SWEP:DoHolster()
	
	self:RemoveHands()
	self:SetTFSwinging( false )
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	self:SetTFNextInspect( -1 )
	
	if IsValid( self:GetOwner() ) == true then
		
		self:GetOwner():SetNW2Float( "TF2Weapons_NextDeploySpeed", self.NextDeploySpeed )
		
	end
	
end

--[[
	Name:	SWEP:CanPrimaryAttack()
	
	Desc:	Returns if the weapon can primary attack or not
	
	Ret1:	True if the weapon can primary attack, false otherwise
]]--
function SWEP:CanPrimaryAttack()
	
	if CurTime() < self:GetNextPrimaryFire() then
		
		return false
		
	end
	
	return true
	
end

--[[
	Name:	SWEP:DoPrimaryAttack( anim, crit )
	
	Desc:	Effects for primary attacking
	
	Arg1:	Keyword for sequence to play. If unspecified, will use swing
	
	Arg2:	Force crit effects
]]--
function SWEP:DoPrimaryAttack( anim, crit )
	
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	self:SetTFNextInspect( -1 )
	
	self:SetTFSwinging( true )
	self:SetTFNextHit( CurTime() + self.Primary.HitDelay )
	
	local crit = self:DoCrit()
	
	self:SetTFNextHitCrit( crit )
	
	if anim == nil then
		
		local swing = self:GetHandAnim( "swing" )
		if crit == true then swing = self:GetHandAnim( "crit" ) end
		self:SetVMAnimation( swing )
		
	elseif anim != "" then
		
		local swing = self:GetHandAnim( anim )
		self:SetVMAnimation( swing )
		
	end
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	
	local sound = self.SwingSound
	if crit == true then sound = self.SwingSoundCrit end
	self:PlaySound( sound )
	
end

--[[
	Name:	SWEP:PrimaryAttack()
	
	Desc:	Called when the owner runs the +attack console command
			Run SWEP:DoPrimaryAttack() here to include the default primary attack effects
]]--
function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	self:DoPrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

--[[
	Name:	SWEP:SecondaryAttack()
	
	Desc:	Called when the owner runs the +attack2 console command
]]--
function SWEP:SecondaryAttack()
end

--[[
	Name:	SWEP:Reload()
	
	Desc:	Called when the owner runs the +reload console command
]]--
function SWEP:Reload()
end

--[[
	Name:	SWEP:GetDamageMods( damage, mod )
	
	Desc:	Returns damage amount with crits and other damage modifiers in effect
	
	Arg1:	Base damage. If unspecified, will use SWEP.Primary.Damage
	
	Arg2:	Damage to return if not modified here
	
	Ret1:	Modified damage
]]--
function SWEP:GetDamageMods( damage, mod )
	
	if damage == nil then damage = self.Primary.Damage end
	
	if self:GetTFNextHitCrit() == true then
		
		damage = damage * self.CritMultiplier
		
	elseif mod != nil then
		
		damage = mod
		
	end
	
	return damage
	
end