SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Scorpian Automatic Pistol"
SWEP.Instructions			= "A rapid firing pistol that can kill an enemy before the magazine is empty."
SWEP.Category 				= "Weapon"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone = 0.006
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb/weapons/vz61/shoot.wav"
SWEP.Primary.Force = 70/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.05
SWEP.ReloadSound = "weapons/ar2/ar2_reload.wav"
SWEP.TwoHands = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

------------------------------------------

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "revolver"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_vz61.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_vz61.mdl"

SWEP.vbwPos = Vector(-2,-3.7,-8)
SWEP.vbwAng = Angle(10,-30,0)
SWEP.addAng = Angle(0,0,0)
SWEP.addPos = Vector(0,0,0)

SWEP.SightPos = Vector(-30,-0.4,-0.05)