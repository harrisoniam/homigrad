SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "TAR-21"
SWEP.Instructions			= "A military grade assault rifle."
SWEP.Category 				= "Weapon"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Cone = 0.006
SWEP.Primary.Damage = 40
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb/weapons/tar21/shoot.wav"
SWEP.Primary.Force = 250/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.10
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

SWEP.HoldType = "smg"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 2
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/weapons/w_tar21.mdl"
SWEP.WorldModel				= "models/pwb/weapons/w_tar21.mdl"

SWEP.vbwPos = Vector(12,-1.7,-12)
SWEP.vbwAng = Angle(10,-30,0)

SWEP.addAng = Angle(0,0.5,0)

SWEP.SightPos = Vector(-20,1.45,-0.24)