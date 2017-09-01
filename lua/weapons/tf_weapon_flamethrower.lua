AddCSLuaFile()

DEFINE_BASECLASS( "tf2weapons_base" )

if SERVER then
	
	util.AddNetworkString( "tf2weapons_airblast" )
	
else
	
	game.AddParticles( "particles/flamethrower.pcf" )
	
	net.Receive( "tf2weapons_airblast", function()
		
		local weapon = net.ReadEntity()
		local entities = {}
		for i = 1, net.ReadInt( 32 ) do
			
			entities[ i ] = net.ReadEntity()
			
		end
		
		local sound = weapon.AirblastSound
		
		for i = 1, #entities do
			
			local _ = i
			local v = entities[ i ]
			
			if IsValid( v ) == true and v != weapon and v != weapon:GetOwner() and weapon.NoAirblast[ v:GetClass() ] != true and v.TF2Weapons_NoAirblast != true then
				
				if weapon.OwnOnAirblast[ v:GetClass() ] == true or v.TF2Weapons_OwnOnAirblast == true then sound = weapon.AirblastRedirectSound end
				
				if v:IsPlayer() == true then
					
					if GetConVar( "tf2weapons_airblast_teammates" ):GetBool() == true then
						
						if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, v, weapon:GetOwner() ) != true then
							
							if IsValid( v:GetPhysicsObject() ) != false then v:SetVelocity( Vector( weapon:GetOwner():GetAimVector().x * ( weapon.Secondary.Force * 0.5 ), weapon:GetOwner():GetAimVector().y * ( weapon.Secondary.Force * 0.5 ), weapon.	Secondary.UpForce ) ) end
							
						elseif v:IsOnFire() == true then
							
							weapon:PlaySound( weapon.AirblastExtinguishSound, nil, v )
							
						end
						
					else
						
						if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, v, weapon:GetOwner() ) == true then
							
							if IsValid( v:GetPhysicsObject() ) != false then v:SetVelocity( Vector( weapon:GetOwner():GetAimVector().x * ( weapon.Secondary.Force * 0.5 ), weapon:GetOwner():GetAimVector().y * ( weapon.Secondary.Force * 0.5 ), weapon.Secondary.UpForce ) ) end
							
						elseif v:IsOnFire() == true then
							
							weapon:PlaySound( weapon.AirblastExtinguishSound, nil, v )
							
						end
						
					end
					
				elseif v.TF2Weapons_OnAirblasted != nil then
					
					v:TF2Weapons_OnAirblasted( weapon, v )
					
				elseif weapon.OnAirblasted[ v:GetClass() ] != nil then
					
					weapon.OnAirblasted[ v:GetClass() ]( weapon, v )
					
				elseif IsValid( v:GetPhysicsObject() ) != false then
					
					if weapon.NoAirblast[ v:GetClass() ] == true or v.TF2Weapons_NoAirblast == true then return end
					if weapon.OwnOnAirblast[ v:GetClass() ] == true or v.TF2Weapons_OwnOnAirblast == true then v:SetOwner( weapon:GetOwner() ) end
					
					local mult = v:GetVelocity():Length() + weapon.Secondary.Force
					local zmult = v:GetVelocity():Length() + weapon.Secondary.UpForce
					v:GetPhysicsObject():SetVelocity( Vector( weapon:GetOwner():GetAimVector().x * mult, weapon:GetOwner():GetAimVector().y * mult, weapon:GetOwner():GetAimVector().z * zmult ) )
					
				end
				
			end
			
		end
		
		weapon:PlaySound( sound )
		
	end )
	
end

CreateConVar( "tf2weapons_airblast_teammates", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "0 to allow flamethrower airblast to extinguish teammates and push enemies, 1 for inverted" )
CreateConVar( "tf2weapons_ignite_teammates", 0, { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "0 to prevent flamethrowers from igniting teammates, 1 for inverted" )

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 416

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_flamethrower_large" ) end
SWEP.PrintName = "#TF_Weapon_FlameThrower"
SWEP.Author = "AwfulRanger"
SWEP.Description = "#TF_Weapon_FlameThrower_desc"
SWEP.Category = "Team Fortress 2 - Pyro"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_FlameThrower"
SWEP.Base = "tf2weapons_base"
SWEP.Classes = { [ TF2Weapons.Class.PYRO ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_flamethrower/c_flamethrower.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_flamethrower/c_flamethrower.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_pyro_arms.mdl" )
SWEP.HoldType = "crossbow"
function SWEP:GetAnimations()
	
	return "ft"
	
end
function SWEP:GetInspect()
	
	return "primary"
	
end

SWEP.SingleReload = false
SWEP.Attributes = {
	
	[ "extinguish restores health" ] = { 20 },
	
}
SWEP.AttributesOrder = {
	
	"extinguish restores health",
	
}

--Distance here is based on percentage of flame life passed
--0 is the start of the flame's life, 1 is the end of the flame's life
SWEP.MinDistance = 0
SWEP.NormalDistance = 0.6
SWEP.MaxDistance = 1

SWEP.DamageRampup = 1
SWEP.DamageNormal = 1
SWEP.DamageFalloff = 0.7

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "tf2weapons_flamethrower"
SWEP.Primary.Damage = 7
SWEP.Primary.Shots = 1
SWEP.Primary.Spread = 0.025
SWEP.Primary.SpreadRecovery = -1
SWEP.Primary.Force = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Delay = 0.08
SWEP.Primary.FlameDelay = 0.044
SWEP.Primary.AfterburnDamage = 3

SWEP.Secondary.Automatic = true
SWEP.Secondary.Force = 512
SWEP.Secondary.UpForce = 256
SWEP.Secondary.TakeAmmo = 20
SWEP.Secondary.Delay = 0.75
SWEP.Secondary.Radius = 90
SWEP.Secondary.Range = 128

SWEP.CritStream = true

function SWEP:SetVariables()
	
	self.ShootStartSound = Sound( "weapons/flame_thrower_start.wav" )
	self.ShootSound = Sound( "weapons/flame_thrower_loop.wav" )
	self.ShootSoundCrit = Sound( "weapons/flame_thrower_loop_crit.wav" )
	self.ShootEndSound = Sound( "weapons/flame_thrower_end.wav" )
	self.AirblastSound = Sound( "weapons/flame_thrower_airblast.wav" )
	self.AirblastRedirectSound = Sound( "weapons/flame_thrower_airblast_rocket_redirect.wav" )
	self.AirblastExtinguishSound = Sound( "player/flame_out.wav" )
	
end

SWEP.FlameDamage = 60
SWEP.FlameStartSpeed = 3000
SWEP.FlameEndSpeed = 1500
SWEP.FlameRadius = 16
SWEP.FlameLife = 0.5
SWEP.FlameTime = 10

SWEP.NoAirblast = {}

SWEP.OwnOnAirblast = {
	
	[ "prop_combine_ball" ] = true,
	[ "npc_grenade_frag" ] = true,
	
}

SWEP.OnAirblasted = {}

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "FlamesDeployed", false )
	self:TFNetworkVar( "Bool", "StartFire", true )
	self:TFNetworkVar( "Bool", "CritSound", false )
	
	self:TFNetworkVar( "Float", "NextLoop", 0 )
	self:TFNetworkVar( "Float", "NextFlame", 0 )
	self:TFNetworkVar( "Float", "LastManage", 0 )
	
	self:TFNetworkVar( "Int", "LastWaterLevel", -1 )
	
end

function SWEP:Initialize()
	
	self:DoInitialize()
	
	self:PrecacheParticles( {
		
		self.FlameParticleRed,
		self.FlameParticleBlue,
		self.WaterParticleRed,
		self.WaterParticleBlue,
		self.CritParticleRed,
		self.CritParticleBlue,
		self.AirblastParticleRed,
		self.AirblastParticleBlue,
		
	} )
	
end

SWEP.FlameParticleRed = "flamethrower"
SWEP.FlameParticleBlue = "flamethrower"
SWEP.WaterParticleRed = "flamethrower_underwater"
SWEP.WaterParticleBlue = "flamethrower_underwater"
SWEP.CritParticleRed = "flamethrower"
SWEP.CritParticleBlue = "flamethrower"
SWEP.AirblastParticleRed = "pyro_blast"
SWEP.AirblastParticleBlue = "pyro_blast"

function SWEP:StartFlames()
	
	if IsValid( self:GetOwner() ) == false or self:GetTFFlamesDeployed() == true then return end
	
	self:SetTFFlamesDeployed( true )
	
	local particle = self.FlameParticleRed
	if self:GetTeam() == true then particle = self.FlameParticleBlue end
	if self:GetOwner():WaterLevel() == 3 then
		
		particle = self.WaterParticleRed
		if self:GetTeam() == true then particle = self.WaterParticleBlue end
		
	end
	
	if self:DrawingVM() == true then
		
		local hands, weapon = self:GetViewModels()
		self:AddParticle( particle, { {
			
			entity = weapon,
			attachtype = PATTACH_POINT_FOLLOW,
			attachment = "muzzle",
			
		} } )
		
	else
		
		self:AddParticle( particle, { {
			
			attachtype = PATTACH_POINT_FOLLOW,
			attachment = "muzzle",
			
		} } )
		
	end
	
end

function SWEP:StopFlames()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:SetTFFlamesDeployed( false )
	
	local hands, weapon = self:GetViewModels()
	if IsValid( self:GetOwner() ) == true and IsValid( weapon ) == true then weapon:StopParticles() end
	self:RemoveParticles()
	
end

SWEP.Flames = {}

function SWEP:CreateFlame( startpos, endpos )
	
	if startpos == nil or endpos == nil then
		
		local tracefilter = function( ent ) if ent == self:GetOwner() then return false end return true end
		
		if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
		
		if startpos == nil then
			
			startpos = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():EyeAngles():Up() * -2 ) + ( self:GetOwner():EyeAngles():Right() * 8 ) + ( self:GetOwner():GetAimVector() * 32 ), filter = tracefilter } ).HitPos
			
		end
		if endpos == nil then
			
			endpos = util.TraceLine( { start = startpos, endpos = self:GetOwner():GetShootPos() + ( ( self:GetOwner():EyeAngles() + Angle( math.random( -90, 90 ) * self.Primary.Spread, math.random( -90, 90 ) * self.Primary.Spread, 0 ) ):Forward() * 32768 ), filter = tracefilter } ).HitPos
			
		end
		
		if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
		
	end
	
	local flame = {}
	flame.owner = self:GetOwner()
	flame.pos = startpos
	flame.ang = ( endpos - startpos ):Angle()
	flame.damage = self.Primary.Damage
	flame.startspeed = self.FlameStartSpeed
	flame.endspeed = self.FlameEndSpeed
	flame.radius = self.FlameRadius
	flame.spawned = CurTime()
	flame.life = self.FlameLife
	flame.time = self.FlameTime
	
	table.insert( self.Flames, flame )
	
end

function SWEP:ManageFlames()
	
	local crit = self:DoCrit()
	
	if self:GetTFLastManage() <= 0 then self:SetTFLastManage( CurTime() ) end
	
	for i = 1, #self.Flames do
		
		local flame = self.Flames[ i ]
		
		if flame != nil then
			
			local startpos = flame.pos
			
			//local speed = Lerp( flame.delta, flame.speed, flame.endspeed )
			
			local endspeed = flame.endspeed - flame.startspeed
			
			local speed = flame.endspeed + ( endspeed * ( ( CurTime() - flame.spawned ) / flame.life ) )
			local vel = speed * ( CurTime() - self:GetTFLastManage() )
			
			local hit = {}
			
			local function filter( ent )
				
				if ent == self:GetOwner() then
					
					return false
					
				elseif ent:IsPlayer() == true or ent:IsNPC() == true then
					
					table.insert( hit, ent )
					return false
					
				end
				
				return true
				
			end
			
			local tr = util.TraceHull( {
				
				start = startpos,
				endpos = startpos + ( flame.ang:Forward() * vel ),
				filter = filter,
				mins = Vector( -flame.radius, -flame.radius, -flame.radius ),
				maxs = Vector( flame.radius, flame.radius, flame.radius ),
				
			} )
			
			for i = 1, #hit do
				
				if SERVER and IsValid( hit[ i ] ) == true and ( hit[ i ]:IsPlayer() == false or hook.Call( "PlayerShouldTakeDamage", GAMEMODE, hit[ i ], self:GetOwner() ) == true ) then
					
					if flame.hit == nil then flame.hit = {} end
					
					if flame.hit[ hit[ i ] ] != true then
						
						local modifier = self.DamageNormal
						
						local distance = ( CurTime() - flame.spawned ) / flame.life
						
						if distance < self.NormalDistance then
							
							if distance < self.MinDistance then distance = self.MinDistance end
							
						else
							
							if distance > self.MaxDistance then distance = self.MaxDistance end
							
						end
						
						modifier = ( distance / self.MaxDistance ) - ( self.DamageRampup - self.DamageNormal )
						if modifier > 1 - self.DamageFalloff then modifier = 1 - self.DamageFalloff end
						
						local dmg = DamageInfo()
						dmg:SetAttacker( self:GetOwner() )
						dmg:SetInflictor( self )
						dmg:SetReportedPosition( flame.pos )
						dmg:SetDamagePosition( tr.HitPos )
						dmg:SetDamageType( DMG_BURN )
						
						dmg:SetDamage( self:GetFlameMods( math.ceil( self.Primary.Damage - ( self.Primary.Damage * modifier ) ), nil, hit[ i ], flame ) )
						
						hit[ i ]:TakeDamageInfo( dmg )
						
						local valid = true
						if hit[ i ]:IsPlayer() == true then
							
							if GetConVar( "tf2weapons_ignite_teammates" ):GetBool() == true then
								
								if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, hit[ i ], self:GetOwner() ) == true then valid = false end
								
							else
								
								if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, hit[ i ], self:GetOwner() ) != true then valid = false end
								
							end
							
						end
						if valid == true then hit[ i ]:Ignite( flame.time ) end
						
						flame.hit[ hit[ i ] ] = true
						
					end
					
				end
				
			end
			
			flame.pos = tr.HitPos
			
			if CurTime() > flame.spawned + flame.life then table.remove( self.Flames, i ) end
			
		end
		
	end
	
	self:SetTFLastManage( CurTime() )
	
end

function SWEP:TooClose()
	
	local tracefilter = function( ent ) if ent == self:GetOwner() or ent:IsPlayer() == true or ent:IsNPC() == true then return false end return true end
	
	if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( true ) end
	startpos = util.TraceLine( { start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():EyeAngles():Up() * -2 ) + ( self:GetOwner():EyeAngles():Right() * 8 ) + ( self:GetOwner():GetAimVector() * 32 ), filter = tracefilter } )
	endpos = util.TraceLine( { start = startpos, endpos = self:GetOwner():GetShootPos() + ( ( self:GetOwner():EyeAngles() + Angle( math.random( -90, 90 ) * self.Primary.Spread, math.random( -90, 90 ) * self.Primary.Spread, 0 ) ):Forward() * 32768 ), filter = tracefilter } )
	if self:GetOwner():IsPlayer() == true then self:GetOwner():LagCompensation( false ) end
	
	return startpos.Hit == true
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	BaseClass.Think( self )
	
	local hands, weapon = self:GetViewModels()
	
	if self:GetOwner():KeyDown( IN_ATTACK ) == true and self:CanCreateFlame() == true and self:TooClose() != true and CurTime() > self:GetNextSecondaryFire() then
		
		local crit = self:DoCrit()
		
		if self:GetTFStartFire() == true then
			
			local sound, dur = self:PlaySound( self.ShootStartSound )
			self:SetTFNextLoop( CurTime() + dur )
			self:SetTFStartFire( false )
			
		end
		
		if crit != self:GetTFCritSound() then
			
			local shootsound = self.ShootSound
			if crit == true then shootsound = self.ShootSoundCrit end
			
			local sound, dur = self:PlaySound( shootsound )
			self:SetTFNextLoop( CurTime() + dur )
			
			self:SetTFCritSound( crit )
			
		end
		
		for i = 1, self.Primary.Shots do
			
			self:CreateFlame()
			
		end
		
		self:SetTFReloading( false )
		self:SetTFInspecting( false )
		self:SetTFInspectLoop( false )
		
		self:SetTFPrimaryLastShot( CurTime() )
		
		local fire = self:GetHandAnim( "fire" )
		self:SetVMAnimation( fire )
		self:SetPlayerAnimation( PLAYER_ATTACK1 )
		
		self:StartFlames()
		
		self:SetTFNextFlame( CurTime() + self.Primary.FlameDelay )
		
	end
	
	if self:GetTFFlamesDeployed() == true and self:GetTFLastWaterLevel() != self:GetOwner():WaterLevel() then
		
		self:SetTFLastWaterLevel( self:GetOwner():WaterLevel() )
		
		self:StopFlames()
		self:StartFlames()
		
	end
	
	if self:GetTFStartFire() == false then
		
		if self:GetOwner():KeyDown( IN_ATTACK ) != true or self:GetOwner():KeyDown( IN_ATTACK2 ) == true or self:Ammo1() <= 0 or self:TooClose() == true then
			
			self:SetTFStartFire( true )
			self:PlaySound( self.ShootEndSound )
			
			self:StopFlames()
			
		end
		
		if self:GetOwner():KeyDown( IN_ATTACK ) == true and CurTime() > self:GetTFNextLoop() and self:TooClose() != true then
			
			self:SetTFNextLoop( CurTime() + SoundDuration( self:PlaySound( self.ShootSound ) ) )
			
		end
		
	end
	
	self:ManageFlames()
	
end

function SWEP:CanCreateFlame()
	
	return CurTime() > self:GetTFNextFlame() and self:Ammo1() > 0
	
end

function SWEP:PrimaryAttack()
	
	if CurTime() < self:GetNextSecondaryFire() or self:CanPrimaryAttack() == false or self:TooClose() == true then return end
	
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end

function SWEP:CanSecondaryAttack()
	
	if self:GetAttributeClass( "set_flamethrower_push_disabled" ) != nil and self:GetAttributeClass( "set_flamethrower_push_disabled" ) > 0 then return false end
	if self:GetAttributeClass( "airblast_disabled" ) != nil and self:GetAttributeClass( "airblast_disabled" ) > 0 then return false end
	if self:Ammo1() - self.Secondary.TakeAmmo < 0 then return false end
	
	return true
	
end

function SWEP:SecondaryAttack()
	
	if self:CanSecondaryAttack() != true then return end
	
	self:SetTFStartFire( true )
	
	self:SetTFReloading( false )
	self:SetTFInspecting( false )
	self:SetTFInspectLoop( false )
	
	local alt_fire = self:GetHandAnim( "alt_fire" )
	self:SetVMAnimation( alt_fire )
	self:SetPlayerAnimation( PLAYER_ATTACK1 )
	
	local airblast = self.AirblastParticleRed
	if self:GetTeam() == true then airblast = self.AirblastParticleBlue end
	
	if self:DrawingVM() == true then
		
		local hands, weapon = self:GetViewModels()
		self:AddParticle( airblast, { {
			
			entity = weapon,
			attachtype = PATTACH_POINT_FOLLOW,
			attachment = "muzzle",
			
		} } )
		
	else
		
		self:AddParticle( airblast, { {
			
			attachtype = PATTACH_POINT_FOLLOW,
			attachment = "muzzle",
			
		} } )
		
	end
	
	if SERVER then
		
		local sound = self.AirblastSound
		
		local entities = ents.FindInCone( self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * self.Secondary.Range, self.Secondary.Range, self.Secondary.Radius )
		
		for _, v in pairs( entities ) do
			
			if v != self and v != self:GetOwner() and self.NoAirblast[ v:GetClass() ] != true and v.TF2Weapons_NoAirblast != true then
				
				if self.OwnOnAirblast[ v:GetClass() ] == true or v.TF2Weapons_OwnOnAirblast == true then sound = self.AirblastRedirectSound end
				
				if v:IsPlayer() == true then
					
					if GetConVar( "tf2weapons_airblast_teammates" ):GetBool() == true then
						
						if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, v, self:GetOwner() ) != true then
							
							if IsValid( v:GetPhysicsObject() ) != false then v:SetVelocity( Vector( self:GetOwner():GetAimVector().x * ( self.Secondary.Force * 0.5 ), self:GetOwner():GetAimVector().y * ( self.Secondary.Force * 0.5 ), self.Secondary.UpForce ) ) end
							
						elseif v:IsOnFire() == true then
							
							self:PlaySound( self.AirblastExtinguishSound, nil, v )
							v:Extinguish()
							
							if self:GetOwner():Health() < self:GetOwner():GetMaxHealth() and self:GetAttributeClass( "extinguish_restores_health" ) != nil then
								
								if self:GetOwner():Health() + self:GetAttributeClass( "extinguish_restores_health" ) > self:GetOwner():GetMaxHealth() then
									
									self:GetOwner():SetHealth( self:GetOwner():GetMaxHealth() )
									
								else
									
									self:GetOwner():SetHealth( self:GetOwner():Health() + self:GetAttributeClass( "extinguish_restores_health" ) )
									
								end
								
							end
							
						end
						
					else
						
						if hook.Call( "PlayerShouldTakeDamage", GAMEMODE, v, self:GetOwner() ) == true then
							
							if IsValid( v:GetPhysicsObject() ) != false then v:SetVelocity( Vector( self:GetOwner():GetAimVector().x * ( self.Secondary.Force * 0.5 ), self:GetOwner():GetAimVector().y * ( self.Secondary.Force * 0.5 ), self.Secondary.UpForce ) ) end
							
						elseif v:IsOnFire() == true then
							
							self:PlaySound( self.AirblastExtinguishSound, nil, v )
							v:Extinguish()
							
							if self:GetOwner():Health() < self:GetOwner():GetMaxHealth() then
								
								if self:GetOwner():Health() + self.ExtinguishHealth > self:GetOwner():GetMaxHealth() then
									
									self:GetOwner():SetHealth( self:GetOwner():GetMaxHealth() )
									
								else
									
									self:GetOwner():SetHealth( self:GetOwner():Health() + self.ExtinguishHealth )
									
								end
								
							end
							
						end
						
					end
					
				elseif v.TF2Weapons_OnAirblasted != nil then
					
					v:TF2Weapons_OnAirblasted( self, v )
					
				elseif self.OnAirblasted[ v:GetClass() ] != nil then
					
					self.OnAirblasted[ v:GetClass() ]( self, v )
					
				elseif IsValid( v:GetPhysicsObject() ) != false then
					
					if self.NoAirblast[ v:GetClass() ] == true or v.TF2Weapons_NoAirblast == true then return end
					if self.OwnOnAirblast[ v:GetClass() ] == true or v.TF2Weapons_OwnOnAirblast == true then v:SetOwner( self:GetOwner() ) end
					
					local mult = v:GetVelocity():Length() + self.Secondary.Force
					local zmult = v:GetVelocity():Length() + self.Secondary.UpForce
					v:GetPhysicsObject():SetVelocity( Vector( self:GetOwner():GetAimVector().x * mult, self:GetOwner():GetAimVector().y * mult, self:GetOwner():GetAimVector().z * zmult ) )
					
				end
				
			end
			
		end
		
		self:PlaySound( sound )
		
		net.Start( "tf2weapons_airblast" )
			
			net.WriteEntity( self )
			net.WriteInt( #entities, 32 )
			for _, v in pairs( entities ) do
				
				net.WriteEntity( v )
				
			end
			
		net.Broadcast()
		
	end
	
	self:TakePrimaryAmmo( self.Secondary.TakeAmmo )
	
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
end

function SWEP:Reload()
end

function SWEP:Deploy()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	self:StopFlames()
	
	self:DoDeploy()
	
	return true
	
end

function SWEP:Holster()
	
	self:StopFlames()
	
	if self:GetTFStartFire() != true then
		
		self:PlaySound( self.ShootEndSound )
		
		self:SetTFStartFire( true )
		
	end
	
	self:DoHolster()
	
	return true
	
end

function SWEP:GetFlameMods( dmg, mod, target, flame )
	
	local basedmg, basecrit = self:GetDamageMods( dmg, mod, target )
	
	if basecrit != true then
		
		if IsValid( target ) == true and flame != nil then
			
			if self:GetAttributeClass( "set_flamethrower_back_crit" ) != nil and self:GetAttributeClass( "set_flamethrower_back_crit" ) != 0 then
				
				if target:GetAimVector():Angle().y - 45 < flame.ang.y and target:GetAimVector():Angle().y + 45 > flame.ang.y then basecrit = true end
				
			end
			
		end
		
		if basecrit == true then basedmg = basedmg * self.CritMultiplier end
		
	end
	
	return basedmg, basecrit
	
end