SWEP.Base = 'salat_base' -- base

SWEP.PrintName 				= "Mosin Rifle"
SWEP.Author 				= "Ce1azz"
SWEP.Instructions			= "A snipers ol' reliable"
SWEP.Category 				= "Weapon"


SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x39 mm"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 60
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "pwb2/weapons/xm8lmg/m249-1.wav"
SWEP.Primary.SoundFar = "ak74/ak74_dist.wav"
SWEP.Primary.Force = 240/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 1.5
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

SWEP.HoldType = "ar2"

------------------------------------------

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_grub_mosin.mdl"
SWEP.WorldModel				= "models/weapons/w_grub_mosin.mdl"

SWEP.vbwPos = Vector(5,-6,-6)

SWEP.addAng = Angle(0,2,6.5)
SWEP.addPos = Vector(0,0,0)

SWEP.SightPos = Vector(-52,-0.5,0)