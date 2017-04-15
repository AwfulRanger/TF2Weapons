AddCSLuaFile()

if CLIENT then
	
	game.AddParticles( "particles/medicgun_beam.pcf" )
	
	local redoverlay = CreateMaterial( "TF2Weapons_MediGun_InvulnOverlay_Red", "Refract", {
		
		[ "$forcerefract" ] = "1",
		[ "$refractamount" ] = "0.02",
		[ "$model" ] = "1",
		[ "$refracttint" ] = "{ 255 155 15 }",
		[ "$normalmap" ] = "effects/invuln_overlay_normal",
		[ "$bumpframe" ] = "0",
		[ "$bluramount" ] = "1",
		[ "$refracttinttexture" ] = "effects/invulnoverlay/invuln_overlay",
		[ "Proxies" ] = {
			
			[ "sine" ] = {
				
				[ "sinemax" ] = "0.1",
				[ "sinemin" ] = "-0.1",
				[ "sineperiod" ] = "0.81",
				[ "resultvar" ] = "$refractamount",
				
			},
			
		},
		
	} )
	local bluoverlay = CreateMaterial( "TF2Weapons_MediGun_InvulnOverlay_Blue", "Refract", {
		
		[ "$forcerefract" ] = "1",
		[ "$refractamount" ] = "0.02",
		[ "$model" ] = "1",
		[ "$refracttint" ] = "{ 55 155 255 }",
		[ "$normalmap" ] = "effects/invuln_overlay_normal",
		[ "$bumpframe" ] = "0",
		[ "$bluramount" ] = "1",
		[ "$refracttinttexture" ] = "effects/invulnoverlay/invuln_overlay",
		[ "Proxies" ] = {
			
			[ "sine" ] = {
				
				[ "sinemax" ] = "0.1",
				[ "sinemin" ] = "-0.1",
				[ "sineperiod" ] = "0.81",
				[ "resultvar" ] = "$refractamount",
				
			},
			
		},
		
	} )

	hook.Add( "HUDPaint", "TF2Weapons_MediGun_HUDPaint", function()
		
		if LocalPlayer():GetNW2Bool( "Ubercharged", false ) == true then
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( redoverlay )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
			
		end
		
	end )
	
else
	
	hook.Add( "PlayerDeath", "TF2Weapons_MediGun_PlayerDeath", function( ply )
		
		ply:SetNW2Bool( "Ubercharged", false )
		ply:GodDisable()
		ply:SetMaterial()
		
	end )
	
end

CreateConVar( "tf2weapons_heal_teammates", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "0 to allow medigun to heal teammates but not enemies, 1 for inverted" )

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.CrosshairType = TF2Weapons.Crosshair.BIGPLUS
SWEP.KillIconX = 0
SWEP.KillIconY = 32

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/c_models/c_medigun/c_medigun" ) end
SWEP.PrintName = "Medi Gun"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2"
SWEP.Level = 1
SWEP.Type = "Medi Gun"
SWEP.Base = "tf2_base"
SWEP.Classes = { TF2Weapons.Class.MEDIC }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = "models/weapons/c_models/c_medigun/c_medigun.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_medigun/c_medigun.mdl"
SWEP.HandModel = "models/weapons/c_models/c_medic_arms.mdl"
SWEP.HoldType = "crossbow"
function SWEP:GetAnimations()
	
	return ""
	
end
function SWEP:GetInspect()
	
	return "secondary"
	
end

SWEP.Attributes = {}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Range = 256
SWEP.Primary.Overheal = 1.5
SWEP.Primary.InCombatTime = 10
SWEP.Primary.OutCombatTime = 15
SWEP.Primary.HPSInCombat = 24
SWEP.Primary.HPSOutCombat = 72
SWEP.Primary.Charge = 0.025
SWEP.Primary.ChargeOverheal = 0.0125
SWEP.Primary.ChargeTime = 8

SWEP.CritChance = 0

function SWEP:SetVariables()
	
	self.HealSound = Sound( "weapons/medigun_heal.wav" )
	self.ChargedSound = Sound( "weapons/medigun_charged.wav" )
	self.NoTargetSound = Sound( "weapons/medigun_no_target.wav" )
	self.HealEndSound = Sound( "null.wav" )
	
end

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "BeamDeployed", false )
	self:TFNetworkVar( "Bool", "HealLoop", false )
	self:TFNetworkVar( "Bool", "HasUbercharge", false )
	self:TFNetworkVar( "Bool", "UsingUbercharge", false )
	
	self:TFNetworkVar( "Float", "HealAnim", 0 )
	self:TFNetworkVar( "Float", "LastHeal", 0 )
	self:TFNetworkVar( "Float", "AddedHealth", 0 )
	self:TFNetworkVar( "Float", "Ubercharge", 0 )
	self:TFNetworkVar( "Float", "UberchargeStart", 0 )
	
	self:TFNetworkVar( "Entity", "Patient", nil )
	self:TFNetworkVar( "Entity", "BeamTarget", nil )
	
end

SWEP.UberchargeOverlayRed = redoverlay
SWEP.UberchargeOverlayBlue = bluoverlay

function SWEP:Initialize()
	
	self:DoInitialize()
	
	self:PrecacheParticles( { self.MediGunBeamRed, self.MediGunBeamBlue } )
	
end

function SWEP:DoDrawCrosshair( x, y )
	
	self:OnDrawCrosshair( x, y )
	
	self:DrawMeter( self:GetTFUbercharge() )
	
	return true
	
end

SWEP.MediGunBeamRed = "medicgun_beam_red"
SWEP.MediGunBeamBlue = "medicgun_beam_blue"

SWEP.UberchargeMaterialRed = Material( "models/effects/invulnfx_red" )
SWEP.UberchargeMaterialBlue = Material( "models/effects/invulnfx_blue" )

function SWEP:EnableUbercharge( ent )
	
	if IsValid( ent ) != true then return end
	
	local ubermat = self.UberchargeMaterialRed:GetName()
	if self:GetTeam() == true then ubermat = self.UberchargeMaterialBlue:GetName() end
	
	ent:SetNW2Bool( "Ubercharged", true )
	if SERVER and ent:IsPlayer() == true then ent:GodEnable() end
	ent:SetMaterial( ubermat )
	if ent:IsPlayer() == true then
		
		if IsValid( ent:GetActiveWeapon() ) == true then ent:GetActiveWeapon():SetMaterial( ubermat ) end
		for i = 0, 2 do
			
			if IsValid( ent:GetViewModel( i ) ) == true then ent:GetViewModel( i ):SetMaterial( ubermat ) end
			
		end
		
	end
	
end

function SWEP:DisableUbercharge( ent )
	
	if IsValid( ent ) != true then return end
	
	ent:SetNW2Bool( "Ubercharged", false )
	if SERVER and ent:IsPlayer() == true then ent:GodDisable() end
	ent:SetMaterial()
	if ent:IsPlayer() == true then
		
		if IsValid( ent:GetActiveWeapon() ) == true then ent:GetActiveWeapon():SetMaterial() end
		for i = 0, 2 do
			
			if IsValid( ent:GetViewModel( i ) ) == true then ent:GetViewModel( i ):SetMaterial() end
			
		end
		
	end
	
end

function SWEP:StopHealing()
	
	if self:GetTFBeamDeployed() == true then
		
		self:DisableUbercharge( self:GetTFPatient() )
		
		self:SetTFPatient( nil )
		self:SetTFHealAnim( 0 )
		self:SetTFHealLoop( false )
		
		self:SetVMAnimation( self:GetHandAnim( "fire_off" ) )
		self:EmitSound( self.HealEndSound )
		
		local hands, weapon = self:GetViewModels()
		if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then weapon:StopParticles() end
		self:StopParticles()
		
		self:SetTFBeamDeployed( false )
		
	end
	
end

SWEP.BeamViewModel = true

function SWEP:CreateBeamParticle()
	
	local particle = self.MediGunBeamRed
	if self:GetTeam() == true then particle = self.MediGunBeamBlue end
	
	local hands, weapon = self:GetViewModels()
	if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then weapon:StopParticles() end
	self:StopParticles()
	
	if SERVER or IsFirstTimePredicted() != true then return end
	
	if self.ViewModelParticles == true then
		
		self:AddParticle( particle, "muzzle", weapon, nil, {
			
			{
				
				entity = weapon,
				attachtype = PATTACH_POINT_FOLLOW,
				position = Vector( 0, 0, 0 ),
				attachment = weapon:LookupAttachment( "muzzle" ),
				
			},
			
			{
				
				entity = self:GetTFPatient(),
				attachtype = PATTACH_POINT_FOLLOW,
				position = Vector( 0, 0, 0 ),
				attachment = self:GetTFPatient():LookupAttachment( "chest" ),
				
			},
			
		} )
		
	else
		
		self:AddParticle( particle, "muzzle", self, nil, {
			
			{
				
				entity = self,
				attachtype = PATTACH_POINT_FOLLOW,
				position = Vector( 0, 0, 0 ),
				attachment = self:LookupAttachment( "muzzle" ),
				
			},
			
			{
				
				entity = self:GetTFPatient(),
				attachtype = PATTACH_POINT_FOLLOW,
				position = Vector( 0, 0, 0 ),
				attachment = self:GetTFPatient():LookupAttachment( "chest" ),
				
			},
			
		} )
		
	end
	
end

function SWEP:DoHealing()
	
	local hands, weapon = self:GetViewModels()
	
	if self:Healing() == true then
		
		if self:CheckPatient() != true then self:GetPatient() end
		
		if IsValid( self:GetTFPatient() ) == true then
			
			if self:GetTFBeamDeployed() != true or self:GetTFPatient() != self:GetTFBeamTarget() then
				
				self:SetTFBeamTarget( self:GetTFPatient() )
				
				if IsValid( self:GetTFBeamTarget() ) != true then return end
				
				self:CreateBeamParticle()
				
				self:SetTFBeamDeployed( true )
				self:SetTFLastHeal( CurTime() )
				self:SetTFAddedHealth( 0 )
				
			end
			
			if CurTime() > self:GetTFHealAnim() then
				
				if self:GetTFHealLoop() == true then
					
					local fire_loop = self:GetHandAnim( "fire_loop" )
					self:SetVMAnimation( fire_loop )
					self:SetTFHealAnim( CurTime() + hands:SequenceDuration( hands:LookupSequence( fire_loop ) ) )
					
				else
					
					local fire_on = self:GetHandAnim( "fire_on" )
					self:SetVMAnimation( fire_on )
					self:SetTFHealAnim( CurTime() + hands:SequenceDuration( hands:LookupSequence( fire_on ) ) )
					self:SetTFHealLoop( true )
					
					self:EmitSound( self.HealSound )
					
				end
				
			end
			
			self:Heal( self:GetPatient() )
			
			/*
			if CLIENT and self.BeamViewModel != self.ViewModelParticles then
				
				self:CreateBeamParticle()
				
				self.BeamViewModel = self.ViewModelParticles
				
			end
			*/
			
		else
			
			self:StopHealing()
			
		end
		
	else
		
		self:StopHealing()
		
	end
	
end

function SWEP:DoUbercharge()
	
	if self:GetTFUsingUbercharge() == true then
		
		local uber = ( ( self.Primary.ChargeTime - ( CurTime() - self:GetTFUberchargeStart() ) ) / self.Primary.ChargeTime )
		
		self:SetTFUbercharge( uber )
		
		self:EnableUbercharge( self )
		self:EnableUbercharge( self:GetTFPatient() )
		
		if self:GetTFUbercharge() <= 0 then
			
			self:SetTFUsingUbercharge( false )
			
			self:DisableUbercharge( self:GetOwner() )
			self:DisableUbercharge( self:GetTFPatient() )
			
		end
		
	else
		
		self:DisableUbercharge( self:GetOwner() )
		self:DisableUbercharge( self:GetTFPatient() )
		
	end
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:SetTFLastOwner( self:GetOwner() )
	
	self:CheckHands()
	
	self:DoHealing()
	
	self:DoUbercharge()
	
	self:Idle()
	
	self:HandleCritStreams()
	
	self:Inspect()
	
end

function SWEP:PrimaryAttack()
end

function SWEP:GetPatient()
	
	if IsValid( self:GetTFPatient() ) != true then
		
		if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
		trace = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.Primary.Range, filter = self:GetOwner(), mask = MASK_SHOT } )
		if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
		
		if trace.Hit == false then
			
			if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
			trace = util.TraceHull( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * ( self.Primary.Range - 10 ), mins = Vector( -10, -10, -10 ), maxs = Vector( 10, 10, 10 ), filter = self:GetOwner(), mask = MASK_SHOT_HULL } )
			if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
			
		end
		
		if IsValid( trace.Entity ) == true and ( trace.Entity:IsPlayer() == true or trace.Entity:IsNPC() == true ) then
			
			local valid = true
			
			if trace.Entity:IsPlayer() == true then
				
				if GetConVar( "tf2weapons_heal_teammates" ):GetBool() == true then
					
					if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, trace.Entity, self:GetOwner() ) != true then valid = false end
					
				else
					
					if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, trace.Entity, self:GetOwner() ) == true then valid = false end
					
				end
				
			end
			
			if valid == true then self:SetTFPatient( trace.Entity ) end
			
		end
		
	end
	
	return self:GetTFPatient()
	
end

function SWEP:CheckPatient( dontremove )
	
	local valid = IsValid( self:GetTFPatient() )
	if valid == true then
		
		if IsValid( self:GetOwner() ) != true then
			
			valid = false
			
		else
			
			if SERVER and self:GetTFPatient():Visible( self:GetOwner() ) != true then valid = false end
			if self:GetTFPatient():GetPos():Distance( self:GetOwner():GetPos() ) > self.Primary.Range then valid = false end
			if GetConVar( "tf2weapons_heal_teammates" ):GetBool() == true then
				
				if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, self:GetTFPatient(), self:GetOwner() ) != true then valid = false end
				
			else
				
				if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, self:GetTFPatient(), self:GetOwner() ) == true then valid = false end
				
			end
			
		end
		
	end
	
	if valid == false and dontremove != true then
		
		if IsValid( self:GetTFPatient() ) == true then self:DisableUbercharge( self:GetTFPatient() ) end
		self:SetTFPatient( nil )
		
	end
	
	return valid
	
end

function SWEP:Healing()
	
	if CurTime() > self:GetNextPrimaryFire() and IsValid( self:GetOwner() ) == true and self:GetOwner():KeyDown( IN_ATTACK ) == true then return true end
	
	return false
	
end

function SWEP:Heal( target )
	
	if IsValid( target ) != true then return end
	
	--health
	
	local healthmult = self.Primary.Overheal
	if GetConVar( "tf2weapons_overheal" ):GetBool() != true then healthmult = 1 end
	
	local hps = self.Primary.HPSInCombat
	local time = CurTime() - target:GetNW2Float( "TFLastDamage", 0 )
	
	if time > self.Primary.InCombatTime then
		
		local mult = ( time - self.Primary.InCombatTime ) / ( self.Primary.OutCombatTime - self.Primary.InCombatTime )
		if mult > 1 then mult = 1 end
		
		hps = self.Primary.HPSInCombat + ( self.Primary.HPSInCombat * ( ( ( self.Primary.HPSOutCombat / self.Primary.HPSInCombat ) - 1 ) * mult ) )
		
	end
	
	local health = self:GetTFAddedHealth() + ( hps * ( CurTime() - self:GetTFLastHeal() ) )
	local healthfloor = math.floor( health )
	
	if healthfloor >= 1 then
		
		health = health - healthfloor
		
	end
	
	if target:Health() + healthfloor > target:GetMaxHealth() * healthmult then
		
		health = 0
		healthfloor = ( target:GetMaxHealth() * healthmult ) - target:Health()
		
	end
	
	if healthfloor > 0 then target:SetHealth( target:Health() + healthfloor ) end
	
	
	--ubercharge
	
	local ups = self.Primary.Charge
	if target:Health() > target:GetMaxHealth() then ups = self.Primary.ChargeOverheal end
	
	local uber = self:GetTFUbercharge() + ( ups * ( CurTime() - self:GetTFLastHeal() ) )
	if uber < 0 then uber = 0 end
	if uber > 1 then uber = 1 end
	
	self:SetTFUbercharge( uber )
	
	
	self:SetTFLastHeal( CurTime() )
	self:SetTFAddedHealth( health )
	
end

function SWEP:SecondaryAttack()
	
	local uber = self:GetTFUbercharge()
	
	if uber < 1 then return end
	
	self:EnableUbercharge( self:GetOwner() )
	self:EnableUbercharge( self:GetTFPatient() )
	
	self:SetTFUsingUbercharge( true )
	self:SetTFUberchargeStart( CurTime() )
	
end

function SWEP:Reload()
end

function SWEP:Deploy()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:DoDeploy()
	
	if self:GetTFUsingUbercharge() == true then self:EnableUbercharge( self:GetOwner() ) end
	
	return true
	
end

function SWEP:Holster()
	
	self:DoHolster()
	
	self:DisableUbercharge( self:GetOwner() )
	self:DisableUbercharge( self:GetTFPatient() )
	
	return true
	
end

function SWEP:BuildWorldModelBones( ent, count )
	
	if IsValid( self:GetOwner() ) == true and self:GetOwner():LookupBone( "weapon_bone_l" ) == nil then
		
		local weaponbonel = self:LookupBone( "weapon_bone_l" )
		local lhandbone = self:GetOwner():LookupBone( "valvebiped.bip01_l_hand" )
		
		if weaponbonel == nil or lhandbone == nil then return end
		
		local lpos, lang = self:GetOwner():GetBonePosition( lhandbone )
		
		if self:GetOwner():LookupAttachment( "anim_attachment_lh" ) != 0 then lpos = self:GetOwner():GetAttachment( self:GetOwner():LookupAttachment( "anim_attachment_lh" ) ).Pos end
		
		lang:RotateAroundAxis( lang:Up(), 180 )
		
		local lwpos, lwang = self:GetBonePosition( weaponbonel )
		
		for i = 0, self:GetBoneCount() - 1 do
			
			if i != weaponbonel and string.lower( self:GetBoneName( i ) ) != "__invalidbone__" then
				
				local cpos, cang = self:GetBonePosition( i )
				
				local localpos, localang = WorldToLocal( cpos, cang, lwpos, lwang )
				local childpos, childang = LocalToWorld( localpos, localang, lpos, lang )
				
				self:SetBonePosition( i, childpos, childang )
				
			end
			
		end
		
		self:SetBonePosition( weaponbonel, lpos, lang )
		
		/*
		local weaponboner = self:LookupBone( "joint_lever" )
		local rhandbone = self:GetOwner():LookupBone( "valvebiped.bip01_r_hand" )
		
		if weaponboner == nil or rhandbone == nil then return end
		
		local rpos, rang = self:GetOwner():GetBonePosition( rhandbone )
		
		if self:GetOwner():LookupAttachment( "anim_attachment_rh" ) != 0 then rpos = self:GetOwner():GetAttachment( self:GetOwner():LookupAttachment( "anim_attachment_rh" ) ).Pos end
		
		self:SetBonePosition( weaponboner, rpos, rang )
		*/
		
	end
	
end