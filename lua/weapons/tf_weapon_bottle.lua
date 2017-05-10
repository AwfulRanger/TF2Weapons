AddCSLuaFile()

if SERVER then
	
	util.AddNetworkString( "tf2weapons_bottle_break" )
	
else
	
	net.Receive( "tf2weapons_bottle_break", function()
		
		net.ReadEntity():Break()
		
	end )
	
end

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.CIRCLE
SWEP.KillIconX = 0
SWEP.KillIconY = 320

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( "backpack/weapons/w_models/w_bottle_large" ) end
SWEP.PrintName = "Bottle"
SWEP.Author = "AwfulRanger"
SWEP.Category = "Team Fortress 2 - Demoman"
SWEP.Level = 1
SWEP.Type = "Bottle"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.DEMOMAN ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_bottle/c_bottle.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_bottle/c_bottle.mdl" )
SWEP.ViewModelBroken = "models/weapons/c_models/c_bottle/c_bottle_broken.mdl"
SWEP.WorldModelBroken = "models/weapons/c_models/c_bottle/c_bottle_broken.mdl"
SWEP.ViewModelRepaired = "models/weapons/c_models/c_bottle/c_bottle.mdl"
SWEP.WorldModelRepaired = "models/weapons/c_models/c_bottle/c_bottle.mdl"
SWEP.HandModel = Model( "models/weapons/c_models/c_demo_arms.mdl" )
SWEP.HoldType = "melee"
function SWEP:GetAnimations()
	
	return "b"
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0.25
SWEP.Primary.Damage = 65
SWEP.Primary.Delay = 0.8

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/shovel_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/shovel_swing_crit.wav" )
	self.HitWorldSound = { Sound( "weapons/bottle_hit1.wav" ), Sound( "weapons/bottle_hit2.wav" ), Sound( "weapons/bottle_hit3.wav" ), Sound( "weapons/bottle_intact_hit_world1.wav" ), Sound( "weapons/bottle_intact_hit_world2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/bottle_hit_flesh1.wav" ), Sound( "weapons/bottle_hit_flesh2.wav" ), Sound( "weapons/bottle_hit_flesh3.wav" ), Sound( "weapons/bottle_intact_hit_flesh1.wav" ), Sound( "weapons/bottle_intact_hit_flesh2.wav" ), Sound( "weapons/bottle_intact_hit_flesh3.wav" ) }
	self.BreakSound = Sound( "weapons/bottle_break.wav" )
	
end

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "Broken", false )
	
end

SWEP.Breakable = true

function SWEP:Break()
	
	self:SetTFBroken( true )
	
	self.ViewModel = self.ViewModelBroken
	self.WorldModel = self.WorldModelBroken
	
	self:CheckHands()
	
	self.HitWorldSound = { Sound( "weapons/bottle_broken_hit_world1.wav" ), Sound( "weapons/bottle_broken_hit_world2.wav" ), Sound( "weapons/bottle_broken_hit_world3.wav" ) }
	self.HitFleshSound = { Sound( "weapons/bottle_broken_hit_flesh1.wav" ), Sound( "weapons/bottle_broken_hit_flesh2.wav" ), Sound( "weapons/bottle_broken_hit_flesh3.wav" ) }
	
	self:PlaySound( self.BreakSound )
	
end

function SWEP:Repair()
	
	self:SetTFBroken( false )
	
	self.ViewModel = Model( "models/weapons/c_models/c_bottle/c_bottle.mdl" )
	self.WorldModel = Model( "models/weapons/c_models/c_bottle/c_bottle.mdl" )
	
	self:CheckHands()
	
	self.HitWorldSound = { Sound( "weapons/bottle_hit1.wav" ), Sound( "weapons/bottle_hit2.wav" ), Sound( "weapons/bottle_hit3.wav" ), Sound( "weapons/bottle_intact_hit_world1.wav" ), Sound( "weapons/bottle_intact_hit_world2.wav" ) }
	self.HitFleshSound = { Sound( "weapons/bottle_hit_flesh1.wav" ), Sound( "weapons/bottle_hit_flesh2.wav" ), Sound( "weapons/bottle_hit_flesh3.wav" ), Sound( "weapons/bottle_intact_hit_flesh1.wav" ), Sound( "weapons/bottle_intact_hit_flesh2.wav" ), Sound( "weapons/bottle_intact_hit_flesh3.wav" ) }
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	local hands, weapon = self:GetViewModels()
	
	self:CheckHands()
	
	if self:GetTFSwinging() == true and CurTime() > self:GetTFNextHit() then
		
		local trace = self:DoSwing( nil, nil, nil, true )
		
		if trace.Entity != nil and trace.Entity != NULL and isentity( trace.Entity ) == true and self.Breakable == true and self:GetTFBroken() == false and self:GetTFNextHitCrit() == true then
			
			if game.SinglePlayer() == true then
				
				self:Break()
				
			elseif SERVER then
				
				self:Break()
				net.Start( "tf2weapons_bottle_break" )
					
					net.WriteEntity( self )
					
				net.Broadcast()
				
			end
			
		end
		
		self:SetTFNextHitCrit( false )
		
	end
	
	self:Idle()
	
	self:Inspect()
	
end