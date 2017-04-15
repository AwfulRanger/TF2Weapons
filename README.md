# TF2Weapons
Team Fortress 2 weapons for Garry's Mod

## To-Do List

### Weapons

- Build PDA
- Destroy PDA
- Toolbox

- Sapper
- Disguise Kit

### Other

- More attributes in general

### KNOWN ISSUES:

##### Primary Issues
- Currently multi control point particles are broken, instead of being parented to the attachment specified they stay at the origin of the entity specified while spamming the console

##### Secondary Issues
- Bat idle animation doesn't loop
- Minigun barrel only spins for client
- Stickybombs don't emit explosion particles
- Grenade Launcher barrels don't spin
- Medi Gun beam doesn't connect with target
- Ubercharge material is constantly flashing
- Knife doesn't wait for the backstab start animation to finish before playing the backstab end animation
- Sometimes projectile particles aren't set early enough

## V4 Changelist

- Medi Gun now heals based on time passed instead of each tick
- Medi Gun heal speed now depends on if the target is in or out of combat
- Added ability to change weapon values (skins, models, particles, etc.) based on team color
- Flamethrower can now airblast projectiles properly
- Added prefixes to weapon qualities
- Added ability to change reload speed
- Fixed issues with maxammo attributes when clipsize attributes are changed
- Prevented rockets from exploding upon contact with other rockets (for fast fire rates)
- Changed .Owner to :GetOwner() on all entities
- Fixed stickybombs not being moved by airblasts
- Moved some things in "lua/weapons/tf2_base.lua" not directly related to the weapon to "lua/tf2weapons.lua"
- Fixed viewmodel occasionally appearing in the middle of the screen when deploying a weapon
- Fixed knife not playing "backstab_down" animation
- Fixed flamethrower consuming ammo too fast
- Optimized flamethrower
- Removed "tf_projectile_flame" entity
- Prevented flamethrower from firing if the player is firing into something too close
- Added detonate sound to the stickybomb launcher
- Added charging to the stickybomb launcher
- Added ubercharge to the medigun
- Removed disguise kit
- Added spawnmenu icons for the weapons
- Fixed projectiles not setting damage position
- Added explosive jumping
- Fixed projectiles going through walls if close enough
- Fixed projectile weapons not firing at the right direction when using the context menu aim
- Added scope to the sniper rifle
- Added laser dot to the sniper rifle
- Added charge meter to the sniper rifle
- Fixed normal playermodels holding the weapons improperly
- Added critical hits
- Fixed particle positions when in thirdperson
- The bottle now breaks when it crits
- Prevented the flamethrower from igniting and airblasting players it cannot damage
- Allowed the flamethrower to extinguish players it cannot damage
- Added convars "tf2weapons_airblast_teammates", "tf2weapons_ignite_teammates" and "tf2weapons_heal_teammates" for gamemodes like sandbox
- Changed names of some fonts and materials

- Added 5+ more weapon attributes