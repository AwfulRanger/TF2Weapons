AddCSLuaFile()

DEFINE_BASECLASS( "tf2weapons_base_melee" )

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.CrosshairType = TF2Weapons.Crosshair.PLUS
SWEP.KillIconX = 96
SWEP.KillIconY = 0

SWEP.IconOverride = "backpack/weapons/w_models/w_knife_large"
if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID( SWEP.IconOverride ) end
SWEP.PrintName = "#TF_Weapon_Knife"
SWEP.Author = "AwfulRanger"
SWEP.Description = "#TF_Weapon_Knife_desc"
SWEP.Category = "Team Fortress 2 - Spy"
SWEP.Level = 1
SWEP.Type = "#TF_Weapon_Knife"
SWEP.Base = "tf2weapons_base_melee"
SWEP.Classes = { [ TF2Weapons.Class.SPY ] = true }
SWEP.Quality = TF2Weapons.Quality.NORMAL

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.ViewModel = Model( "models/weapons/c_models/c_knife/c_knife.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_knife/c_knife.mdl" )
SWEP.HandModel = Model( "models/weapons/c_models/c_spy_arms.mdl" )
SWEP.HoldType = "knife"
function SWEP:GetAnimations()
	
	return {
		
		idle = "knife_idle",
		draw = "knife_draw",
		swing = {
			
			"knife_stab_a",
			"knife_stab_b",
			"knife_stab_c",
			
		},
		crit = {
			
			"knife_stab_a",
			"knife_stab_b",
			"knife_stab_c",
			
		},
		backstab = "knife_backstab",
		backstab_up = "knife_backstab_up",
		backstab_idle = "knife_backstab_idle",
		backstab_down = "knife_backstab_down",
		
	}
	
end
function SWEP:GetInspect()
	
	return "melee"
	
end

SWEP.Attributes = {}

SWEP.Primary.HitDelay = 0
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 0.8

SWEP.CritChance = 0

function SWEP:SetVariables()
	
	self.SwingSound = Sound( "weapons/knife_swing.wav" )
	self.SwingSoundCrit = Sound( "weapons/knife_swing_crit.wav" )
	self.HitWorldSound = Sound( "weapons/blade_hitworld.wav" )
	self.HitFleshSound = { Sound( "weapons/blade_hit1.wav" ), Sound( "weapons/blade_hit2.wav" ), Sound( "weapons/blade_hit3.wav" ), Sound( "weapons/blade_hit4.wav" ) }
	
end

function SWEP:SetupDataTables()
	
	self:BaseDataTables()
	
	self:TFNetworkVar( "Bool", "BackstabHit", false )
	
	self:TFNetworkVar( "Entity", "BackstabEnt", nil )
	
end

function SWEP:Think()
	
	if IsValid( self:GetOwner() ) == false then return end
	
	BaseClass.Think( self )
	
	local trace = self:DoSwing( false )
	
	if SERVER then
		
		if self:CanPrimaryAttack() == true and IsValid( trace.Entity ) == true and ( trace.Entity:IsPlayer() == true or trace.Entity:IsNPC() == true ) then
			
			local entang = trace.Entity:GetAimVector():Angle().y
			local plyang = self:GetOwner():GetAimVector():Angle().y
			
			if entang - 90 < plyang and entang + 90 > plyang then
				
				if IsValid( self:GetTFBackstabEnt() ) == false then
					
					self:SetVMAnimation( self:GetHandAnim( "backstab_up" ) )
					self:SetTFBackstabEnt( trace.Entity )
					
				else
					
					self:SetVMAnimation( self:GetHandAnim( "backstab_idle" ) )
					
				end
				
			elseif IsValid( self:GetTFBackstabEnt() ) == true and self:GetTFBackstabHit() == false and self:CanPrimaryAttack() == true then
				
				self:SetVMAnimation( self:GetHandAnim( "backstab_down" ) )
				self:SetTFBackstabEnt( nil )
				
			elseif self:GetTFBackstabHit() == true then
				
				self:SetTFBackstabHit( false )
				self:SetTFBackstabEnt( nil )
				
			end
			
		elseif IsValid( self:GetTFBackstabEnt() ) == true and self:GetTFBackstabHit() == false and self:CanPrimaryAttack() == true then
			
			self:SetVMAnimation( self:GetHandAnim( "backstab_down" ) )
			self:SetTFBackstabEnt( nil )
			
		elseif self:GetTFBackstabHit() == true then
			
			self:SetTFBackstabHit( false )
			self:SetTFBackstabEnt( nil )
			
		end
		
	end
	
end

function SWEP:OnBackstab( ent, damage )
	
	local sanguisuge = self:GetAttributeClass( "sanguisuge" )
	if sanguisuge ~= nil and sanguisuge > 0 then self:GiveHealth( ent:Health(), self:GetOwner(), -1 ) end
	
end

function SWEP:PrimaryAttack()
	
	if self:CanPrimaryAttack() == false then return end
	
	if game.SinglePlayer() == true then self:CallOnClient( "PrimaryAttack" ) end
	
	self:DoPrimaryAttack()
	
	local trace = self:DoSwing( false )
	
	local damage = self.Primary.Damage
	local damageent = trace.Entity
	if IsValid( self:GetTFBackstabEnt() ) == true then
		
		damage = ( self:GetTFBackstabEnt():Health() * 3 ) * self.CritMultiplier
		damageent = self:GetTFBackstabEnt()
		
		self:OnBackstab( damageent, damage )
		
		self:SetVMAnimation( self:GetHandAnim( "backstab" ) )
		self:SetTFBackstabHit( true )
		
	else
		
		self:SetVMAnimation( self:GetHandAnim( "swing" ) )
		
	end
	
	self:DoSwing( true, damage, damageent )
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
end