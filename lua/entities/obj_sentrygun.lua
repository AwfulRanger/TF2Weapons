AddCSLuaFile()

if CLIENT then
	
	game.AddParticles( "particles/muzzle_flash.pcf" )
	
end

TF2Weapons.SentryGunTargets = TF2Weapons.SentryGunTargets or {}

hook.Add( "OnEntityCreated", "TF2Weapons_Sentry_InsertTargets", function( ent )
	
	timer.Simple( 0, function()
		
		if IsValid( ent ) != true then return end
		
		if ( ent:Health() > 0 or ent:GetMaxHealth() > 0 ) and string.Left( ent:GetClass(), 5 ) != "prop_" then
			
			table.insert( TF2Weapons.SentryGunTargets, ent )
			
		end
		
	end )
	
end )

hook.Add( "EntityRemoved", "TF2Weapons_Sentry_RemoveTargets", function( ent )
	
	if ( ent:Health() > 0 or ent:GetMaxHealth() > 0 ) and string.Left( ent:GetClass(), 5 ) != "prop_" then
		
		table.RemoveByValue( TF2Weapons.SentryGunTargets, ent )
		
	end
	
end )

CreateConVar( "tf2weapons_sentry_teammates", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "0 to prevent sentry from shooting teammates and allow it to shoot enemies, 1 for inverted" )

ENT.Base = "obj_base"
ENT.Type = "anim"
ENT.PrintName = "Sentry Gun"
ENT.Category = "Team Fortress 2"
ENT.Author = "AwfulRanger"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.BuildMins = Vector( -20, -20, 0 )
ENT.BuildMaxs = Vector( 20, 20, 66 )

ENT.ExplodeSound = Sound( "weapons/sentry_explode.wav" )

ENT.YawRadius = 90
ENT.Range = 1100
ENT.TargetSound = Sound( "weapons/sentry_spot.wav" )

ENT.AddBulletsMax = 40
ENT.AddRocketsMax = 8
ENT.BulletsCost = 1
ENT.RocketsCost = 2

ENT.Levels = {
	
	--level 1
	{
		
		Health = 150,
		UpgradeCost = 200,
		Model = "models/buildables/sentry1.mdl",
		BuildModel = "models/buildables/sentry1_heavy.mdl",
		BuildAnim = "build",
		BuildTime = 10,
		
		Idle = "idle_off",
		
		Bodygroups = "000",
		BuildBodygroups = "000",
		
		Gibs = {
			
			{
				
				Model = "models/buildables/gibs/sentry1_gib1.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry1_gib2.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry1_gib3.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry1_gib4.mdl",
				Scrap = 17,
				
			},
			
		},
		
		TurnRate = 180,
		NeutralTurnRate = 45,
		
		ScanSound = Sound( "weapons/sentry_scan.wav" ),
		
		Bullet = {
			
			Damage = 16,
			Delay = 0.2,
			Count = 150,
			TakeAmmo = 1,
			FireSound = Sound( "weapons/sentry_shoot.wav" ),
			Shots = 1,
			Spread = 0,
			Force = 10,
			Anim = "fire",
			EmptySound = Sound( "weapons/sentry_empty.wav" ),
			Particles = {
				
				{
					
					Name = "muzzle_sentry",
					Type = PATTACH_POINT_FOLLOW,
					Attachment = "muzzle",
					
				},
				
			},
			
		},
		Rocket = nil,
		
	},
	
	--level 2
	{
		
		Health = 180,
		UpgradeCost = 200,
		Model = "models/buildables/sentry2.mdl",
		BuildModel = "models/buildables/sentry2_heavy.mdl",
		BuildAnim = "upgrade",
		BuildTime = 1.5,
		
		Idle = "idle_off",
		
		Bodygroups = "000",
		BuildBodygroups = "000",
		
		Gibs = {
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib1.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib2.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib3.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib4.mdl",
				Scrap = 17,
				
			},
			
		},
		
		TurnRate = 225,
		NeutralTurnRate = 45,
		
		ScanSound = Sound( "weapons/sentry_scan2.wav" ),
		
		Bullet = {
			
			Damage = 16,
			Delay = 0.1,
			Count = 200,
			TakeAmmo = 1,
			FireSound = Sound( "weapons/sentry_shoot2.wav" ),
			Shots = 1,
			Spread = 0,
			Force = 10,
			Anim = "fire",
			EmptySound = Sound( "weapons/sentry_empty.wav" ),
			Particles = {
				
				{
					
					Name = "muzzle_sentry2",
					Type = PATTACH_POINT_FOLLOW,
					Attachment = "muzzle_l",
					
				},
				
				{
					
					Name = "muzzle_sentry2",
					Type = PATTACH_POINT_FOLLOW,
					Attachment = "muzzle_r",
					
				},
				
			},
			
		},
		Rocket = nil,
		
	},
	
	--level 3
	{
		
		Health = 216,
		UpgradeCost = -1,
		Model = "models/buildables/sentry3.mdl",
		BuildModel = "models/buildables/sentry3_heavy.mdl",
		BuildAnim = "upgrade",
		BuildTime = 1.5,
		
		Idle = "idle_off",
		
		Bodygroups = "000",
		BuildBodygroups = "000",
		
		Gibs = {
			
			{
				
				Model = "models/buildables/gibs/sentry3_gib1.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib2.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib3.mdl",
				Scrap = 16,
				
			},
			
			{
				
				Model = "models/buildables/gibs/sentry2_gib4.mdl",
				Scrap = 17,
				
			},
			
		},
		
		TurnRate = 270,
		NeutralTurnRate = 45,
		
		ScanSound = Sound( "weapons/sentry_scan3.wav" ),
		
		Bullet = {
			
			Damage = 16,
			Delay = 0.1,
			Count = 200,
			TakeAmmo = 1,
			FireSound = Sound( "weapons/sentry_shoot3.wav" ),
			Shots = 1,
			Spread = 0,
			Force = 10,
			Anim = "fire",
			EmptySound = Sound( "weapons/sentry_empty.wav" ),
			Particles = {
				
				{
					
					Name = "muzzle_sentry2",
					Type = PATTACH_POINT_FOLLOW,
					Attachment = "muzzle_l",
					
				},
				
				{
					
					Name = "muzzle_sentry2",
					Type = PATTACH_POINT_FOLLOW,
					Attachment = "muzzle_r",
					
				},
				
			},
			
		},
		Rocket = {
			
			Class = "tf_projectile_sentryrocket",
			Damage = 100,
			Delay = 3,
			Count = 20,
			TakeAmmo = 1,
			FireSound = Sound( "weapons/sentry_rocket.wav" ),
			Shots = 1,
			Spread = 0,
			Force = 10,
			Model = "models/buildables/sentry3_rockets.mdl",
			Speed = 1100,
			Radius = 146,
			ExplodeSound = { Sound( "weapons/explode1.wav" ), Sound( "weapons/explode2.wav" ), Sound( "weapons/explode3.wav" ) },
			EmptySound = Sound( "weapons/sentry_empty.wav" ),
			
		},
		
	},
	
}

function ENT:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "TurnCounter", false )
	self:TFNetworkVar( "Bool", "Targeting", false )
	
	self:TFNetworkVar( "Float", "NextBulletFire", 0 )
	self:TFNetworkVar( "Float", "NextRocketFire", 0 )
	self:TFNetworkVar( "Float", "LastTurn", 0 )
	
	self:TFNetworkVar( "Int", "Bullets", 0 )
	self:TFNetworkVar( "Int", "Rockets", 0 )
	
	self:TFNetworkVar( "Angle", "TurnAngle", Angle( 0, 0, 0 ) )
	
	self:TFNetworkVar( "Entity", "Target", nil )
	
end

function ENT:GetBuildNum()
	
	return TF2Weapons.Building.SENTRY
	
end

function ENT:Initialize()
	
	for i = 1, #self.Levels do
		
		local level = self.Levels[ i ]
		if level.Bullet != nil and level.Bullet.Particles != nil then
			
			for i_ = 1, #level.Bullet.Particles do
				
				PrecacheParticleSystem( level.Bullet.Particles[ i_ ].Name )
				
			end
			
		end
		if level.Rocket != nil and level.Rocket.Particles != nil then
			
			for i_ = 1, #level.Rocket.Particles do
				
				PrecacheParticleSystem( level.Rocket.Particles[ i_ ].Name )
				
			end
			
		end
		
	end
	
end

function ENT:SetLevelModel( level, building )
	
	if level == nil then level = self:GetTFLevel() end
	stats = self.Levels[ level ]
	if stats == nil then return end
	
	if building == true then
		
		if stats.BuildModel != nil then self:SetModel( stats.BuildModel ) end
		if stats.BuildAnim != nil then self:ResetSequence( stats.BuildAnim ) end
		if stats.BuildBodygroups != nil then self:SetBodyGroups( stats.BuildBodygroups ) end
		
	else
		
		if stats.Model != nil then self:SetModel( stats.Model ) end
		if stats.Bodygroups != nil then self:SetBodyGroups( stats.Bodygroups ) end
		
	end
	
	--if SERVER then
		
		self:PhysicsInitBox( self.BuildMins, self.BuildMaxs )
		if IsValid( self:GetPhysicsObject() ) == true then self:GetPhysicsObject():EnableMotion( false ) end
		self:SetMoveType( MOVETYPE_NONE )
		
	--end
	
	self:SetTFLastTurn( CurTime() )
	
end

function ENT:SetLevel( level )
	
	self:SetTFUpgrade( 0 )
	self:SetTFLevel( level )
	self:SetTFUpgrading( true )
	self:SetTFLastUpgrade( CurTime() )
	self:SetTFUpgradeAmount( 0 )
	self:SetLevelModel( level, true )
	self:SetTFUpgradeRemoveHealth( 0 )
	
	local stats = self.Levels[ level ]
	if stats == nil then return end
	
	if stats.Bullet != nil then self:SetTFBullets( stats.Bullet.Count ) end
	if stats.Rocket != nil then self:SetTFRockets( stats.Rocket.Count ) end
	
	if SERVER then
		
		net.Start( "tf2weapons_building_upgrade" )
			
			net.WriteEntity( self )
			net.WriteInt( level, 32 )
			
		net.Broadcast()
		
		self:SetMaxHealth( stats.Health )
		if self:Health() < 1 then self:SetHealth( 1 ) end
		
		self:SetTFUpgradeHealth( self:Health() )
		
	end
	
end

function ENT:HandlePoseParameters()
	
	if SERVER then return end
	
	local ang = self:GetTFTurnAngle()
	ang:Normalize()
	
	local pitch = ang.pitch
	if pitch < -50 then pitch = -50 end
	if pitch > 50 then pitch = 50 end
	
	self:SetPoseParameter( "aim_pitch", pitch )
	self:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ang.yaw ) )
	
	self:MarkShadowAsDirty()
	
end

function ENT:HandleTargetTurning()
	
	if self:GetTFUpgrading() == true then return end
	
	local stats = self.Levels[ self:GetTFLevel() ]
	
	if self:GetTFLastTurn() <= 0 then self:SetTFLastTurn( CurTime() ) end
	
	local target = self:GetTFTarget()
	
	local ang = self:GetTFTurnAngle()
	ang:Normalize()
	
	local angtarget = ( target:GetPos() + target:OBBCenter() - self:GetShootPos() ):Angle()
	angtarget:Normalize()
	
	angtarget = -angtarget
	
	angtarget = self:GetAngles() + angtarget
	
	angtarget:Normalize()
	
	local turn = stats.TurnRate * ( CurTime() - self:GetTFLastTurn() )
	
	--yaw
	local yaw = ang.yaw
	local yawtarget = angtarget.yaw
	
	yaw = math.ApproachAngle( yaw, yawtarget, turn )
	
	--pitch
	local pitch = ang.pitch
	local pitchtarget = angtarget.pitch
	
	pitch = math.ApproachAngle( pitch, pitchtarget, turn )
	
	--try to fire if aiming at the target
	if stats != nil and yaw == yawtarget and pitch == pitchtarget then
		
		if stats.Bullet != nil then self:DoFireBullet() end
		if stats.Rocket != nil then self:DoFireRocket() end
		
	end
	
	
	self:SetTFTurnAngle( Angle( pitch, yaw, ang.r ) )
	
	self:SetTFLastTurn( CurTime() )
	
	if self:GetTFTargeting() != true then
		
		self:EmitSound( self.TargetSound )
		
	end
	
	self:SetTFTargeting( true )
	
end

function ENT:HandleNeutralTurning()
	
	if self:GetTFUpgrading() == true then return end
	
	local stats = self.Levels[ self:GetTFLevel() ]
	
	if self:GetTFLastTurn() <= 0 then self:SetTFLastTurn( CurTime() ) end
	
	local ang = self:GetTFTurnAngle()
	ang:Normalize()
	
	local turn = stats.NeutralTurnRate * ( CurTime() - self:GetTFLastTurn() )
	
	--yaw
	local yaw = ang.yaw
	local yawtarget = self.YawRadius
	if self:GetTFTurnCounter() == true then yawtarget = -self.YawRadius end
	yawtarget = yawtarget * 0.5
	
	yaw = math.ApproachAngle( yaw, yawtarget, turn )
	
	if SERVER and yaw == yawtarget then
		
		self:SetTFTurnCounter( !self:GetTFTurnCounter() )
		if stats.ScanSound != nil then self:EmitSound( stats.ScanSound ) end
		
	end
	
	--pitch
	local pitch = ang.pitch
	local pitchtarget = 0
	pitch = math.ApproachAngle( pitch, pitchtarget, turn )
	
	
	self:SetTFTurnAngle( Angle( pitch, yaw, ang.r ) )
	
	self:SetTFLastTurn( CurTime() )
	
	self:SetTFTargeting( false )
	
end

function ENT:HandleTurning()
	
	if IsValid( self:GetTFTarget() ) == true then
		
		self:HandleTargetTurning()
		
	else
		
		self:HandleNeutralTurning()
		
	end
	
end

ENT.TargetCached = nil

function ENT:GetSentryTarget()
	
	if CLIENT then return end
	
	if self.TargetCached != nil then return self.TargetCached end
	
	local target = nil
	local distance = -1
	
	for i = 1, #TF2Weapons.SentryGunTargets do
		
		local t = TF2Weapons.SentryGunTargets[ i ]
		if IsValid( t ) == true and t != self:GetTFOwner() and t:Health() > 0 then
			
			local bulletpos = t:GetPos() + t:OBBCenter()
			local rocketpos = t:GetPos() + t:OBBCenter()
			if t:IsNPC() == true then
				
				bulletpos = t:BodyTarget( self:GetShootPos() )
				rocketpos = t:BodyTarget( self:GetRocketPos() )
				
			end
			
			local dist = self:GetPos():Distance( t:GetPos() )
			
			local bullettr = util.TraceLine( {
				
				start = self:GetShootPos(),
				endpos = bulletpos,
				filter = self,
				
			} )
			
			local rockettr = util.TraceLine( {
				
				start = self:GetRocketPos(),
				endpos = rocketpos,
				filter = self,
				
			} )
			
			if dist <= self.Range and ( bullettr.HitWorld != true or rockettr.HitWorld != true ) then
				
				local friendly = true
				
				if GetConVar( "tf2weapons_sentry_teammates" ):GetBool() == true then
					
					if t:IsNPC() == true and t:Disposition( self:GetTFOwner() ) != D_HT then friendly = false end
					if t:IsNPC() != true and hook.Call( "PlayerShouldTakeDamage", GAMEMODE, self:GetTFOwner(), t ) != true then friendly = false end
					
				else
					
					if t:IsNPC() == true and t:Disposition( self:GetTFOwner() ) == D_HT then friendly = false end
					if t:IsNPC() != true and hook.Call( "PlayerShouldTakeDamage", GAMEMODE, self:GetTFOwner(), t ) == true then friendly = false end
					
				end
				
				if t == self:GetTFOwner() then friendly = true end
				if t.GetTFOwner != nil and self:GetTFOwner() == t:GetTFOwner() then friendly = true end
				
				if friendly != true and ( distance < 0 or dist < distance ) then
					
					target = t
					distance = dist
					
					--if t:IsNPC() == true then t:AddEntityRelationship( self, D_HT, 99 ) end
					
				end
				
			end
			
		end
		
	end
	
	self.TargetCached = target
	
	return target
	
end

function ENT:HandleSentryTarget()
	
	if CLIENT then return end
	
	self:SetTFTarget( self:GetSentryTarget() )
	
end

function ENT:HandleSentryAmmo()
	
	local stats = self.Levels[ self:GetTFLevel() ]
	local laststats = self.Levels[ self:GetTFLevel() - 1 ]
	
	if stats == nil then return end
	
	if self:GetTFBuilding() == true then
		
		if stats.Bullet != nil then
			
			if laststats == nil or laststats.Bullet == nil then self:SetTFBullets( stats.Bullet.Count ) end
			
		end
		
		if stats.Rocket != nil then
			
			if laststats == nil or laststats.Rocket == nil then self:SetTFRockets( stats.Rocket.Count ) end
			
		end
		
	end
	
end

function ENT:Think()
	
	self:HandleLevel()
	
	self:HandleUpgrade()
	
	self:HandleUpgradeHealth()
	
	self:HandleSentryTarget()
	
	self:HandleTurning()
	
	self:HandlePoseParameters()
	
	self:HandleSentryAmmo()
	
	local stats = self.Levels[ self:GetTFLevel() ]
	
	if self:GetTFUpgrading() != true and stats != nil then
		
		if stats.Idle != nil then self:SetSequence( stats.Idle ) end
		
	end
	
	self.TargetCached = nil
	
	self:NextThink( CurTime() + 0.05 )
	return true
	
end

function ENT:TakeBullet( amount )
	
	if amount == nil then amount = 1 end
	local take = self:GetTFBullets() - amount
	if take < 0 then take = 0 end
	
	self:SetTFBullets( take )
	
end

function ENT:TakeRocket( amount )
	
	if amount == nil then amount = 1 end
	local take = self:GetTFRockets() - amount
	if take < 0 then take = 0 end
	
	self:SetTFRockets( take )
	
end

function ENT:GetAimPos( target )
	
	local dir = target:GetPos() + target:OBBCenter()
	--if SERVER then dir = target:BodyTarget( self:GetShootPos() ) end
	local attach = target:LookupAttachment( "chest" )
	if attach != nil then
		
		local attachment = target:GetAttachment( attach )
		if attachment != nil and attachment.Pos != nil then dir = target:GetAttachment( attach ).Pos end
		
	end
	
	return dir
	
end

function ENT:DoFireBullet()
	
	local level = self:GetTFLevel()
	stats = self.Levels[ level ]
	
	if stats == nil or stats.Bullet == nil then return end
	
	if self:GetTFNextBulletFire() > CurTime() then return end
	
	if self:GetTFBullets() < 1 then
		
		self:SetTFNextBulletFire( CurTime() + stats.Bullet.Delay )
		
		if stats.Bullet.EmptySound != nil then self:EmitSound( stats.Bullet.EmptySound ) end
		
		return
		
	end
	
	local target = self:GetTFTarget()
	if IsValid( target ) != true then return end
	
	local bullet = {}
	if IsValid( self:GetTFOwner() ) == true then bullet.Attacker = self:GetTFOwner() end
	bullet.Src = self:GetShootPos()
	bullet.Dir = ( self:GetAimPos( target ) - self:GetShootPos() ):Angle():Forward()
	bullet.Tracer = 0
	bullet.Damage = stats.Bullet.Damage
	bullet.Num = stats.Bullet.Shots
	bullet.Spread = Vector( stats.Bullet.Spread, stats.Bullet.Spread )
	bullet.Force = stats.Bullet.Force
	bullet.Callback = function( attacker, tr, dmg )
		
		if SERVER and dmg != nil and IsValid( tr.Entity ) == true then
			
			tr.Entity:TakeDamageInfo( dmg )
			
			dmg:SetDamage( 0 )
			
		end
		
	end
	
	if IsFirstTimePredicted() == true then
		
		self:FireBullets( bullet )
		self:EmitSound( stats.Bullet.FireSound )
		for i = 1, #stats.Bullet.Particles do
			
			local p = stats.Bullet.Particles[ i ]
			
			ParticleEffectAttach( p.Name, p.Type, self, self:LookupAttachment( p.Attachment ) )
			
		end
		
	end
	
	if SERVER then
		
		self:TakeBullet()
		self:SetTFNextBulletFire( CurTime() + stats.Bullet.Delay )
		
	end
	
end

function ENT:DoFireRocket()
	
	local level = self:GetTFLevel()
	stats = self.Levels[ level ]
	
	if stats == nil or stats.Rocket == nil then return end
	
	if self:GetTFNextRocketFire() > CurTime() then return end
	
	if self:GetTFRockets() < 1 then
		
		self:SetTFNextRocketFire( CurTime() + stats.Rocket.Delay )
		
		if stats.Rocket.EmptySound != nil then self:EmitSound( stats.Rocket.EmptySound ) end
		
		return
		
	end
	
	local target = self:GetTFTarget()
	if IsValid( target ) != true then return end
	
	if SERVER then
		
		for i = 1, stats.Rocket.Shots do
		
			local rocket = ents.Create( stats.Rocket.Class )
			if IsValid( rocket ) == true then
				
				rocket:SetOwner( self:GetTFOwner() )
				rocket:SetPos( self:GetRocketPos() )
				--rocket:SetAngles( ( target:GetPos() + target:OBBCenter() - self:GetShootPos() ):Angle() )
				rocket:SetAngles( ( self:GetAimPos( target ) - self:GetRocketPos() ):Angle() )
				--rocket:SetRocketBLU( self:GetTeam() )
				rocket:SetRocketBLU( false )
				rocket:SetRocketSkin( 0 )
				--rocket:SetRocketModel( stats.Rocket.Model )
				rocket:SetRocketModel( "models/weapons/w_models/w_rocket.mdl" )
				rocket:SetSentryRocketModel( stats.Rocket.Model )
				rocket:SetRocketAngles( ( target:GetPos() + target:OBBCenter() - self:GetShootPos() ):Angle() )
				rocket:SetRocketDamage( stats.Rocket.Damage )
				rocket:SetRocketCrit( false )
				rocket:SetRocketCritMultiplier( 0 )
				rocket:SetRocketSpeed( stats.Rocket.Speed )
				rocket:SetRocketRadius( stats.Rocket.Radius )
				rocket:SetRocketForce( stats.Rocket.Force )
				rocket.ExplodeSound = stats.Rocket.ExplodeSound[ math.random( #stats.Rocket.ExplodeSound ) ]
				rocket:SetSentry( self )
				rocket:Spawn()
				
			end
			
		end
		
	end
	
	if IsFirstTimePredicted() == true then self:EmitSound( stats.Rocket.FireSound ) end
	
	if SERVER then
		
		self:TakeRocket()
		self:SetTFNextRocketFire( CurTime() + stats.Rocket.Delay )
		
	end
	
end

function ENT:GetShootPos()
	
	--local attach = self:LookupAttachment( "sentrydamage" )
	--if attach != nil and self:GetAttachment( attach ) != nil and self:GetAttachment( attach ).Pos != nil then return self:GetAttachment( attach ).Pos end
	
	return self:GetPos() + ( self:GetAngles():Up() * 48 )
	
end

function ENT:GetRocketPos()
	
	return self:GetPos() + ( self:GetAngles():Up() * 64 )
	
end

function ENT:Restock( dmg )
	
	local weapon = dmg:GetInflictor()
	if IsValid( weapon ) != true or weapon.TF2Weapons_BuildTool != true then return false end
	
	local level = self:GetTFLevel()
	local stats = self.Levels[ level ]
	if stats == nil then return false end
	
	if weapon:Ammo1() <= 0 then return false end
	
	local restocked = false
	
	if stats.Bullet != nil and self:GetTFBullets() < stats.Bullet.Count then
		
		local bullets = self:GetTFBullets()
		local bulletsmax = self.AddBulletsMax
		if bullets + bulletsmax > stats.Bullet.Count then bulletsmax = stats.Bullet.Count - bullets end
		
		local cost = bulletsmax
		
		if cost > weapon:Ammo1() then
			
			bulletsmax = weapon:Ammo1() / self.BulletsCost
			cost = bulletsmax * self.BulletsCost
			
		end
		
		if bulletsmax > 0 then
			
			self:SetTFBullets( bullets + bulletsmax )
			
			weapon:TakePrimaryAmmo( cost )
			
			restocked = true
			
		end
		
	end
	
	if stats.Rocket != nil and self:GetTFRockets() < stats.Rocket.Count then
		
		local rockets = self:GetTFRockets()
		local rocketsmax = self.AddRocketsMax
		if rockets + rocketsmax > stats.Rocket.Count then rocketsmax = stats.Rocket.Count - rockets end
		
		local cost = rocketsmax * 2
		
		if cost > weapon:Ammo1() then
			
			rocketsmax = weapon:Ammo1() / self.RocketsCost
			cost = rocketsmax * self.RocketsCost
			
		end
		
		if rocketsmax > 0 then
			
			self:SetTFRockets( rockets + rocketsmax )
			
			weapon:TakePrimaryAmmo( cost )
			
			restocked = true
			
		end
		
	end
	
	return restocked
	
end

function ENT:ToolHit( dmg )
	
	local upgraded = self:Repair( dmg )
	local restocked = self:Restock( dmg )
	if upgraded != true then upgraded = restocked end
	if upgraded != true then upgraded = self:Upgrade( dmg ) end
	
	return upgraded
	
end