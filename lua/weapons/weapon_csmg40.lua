SWEP.Base = 'salat_base' -- base 

SWEP.PrintName 				= "MP40"
SWEP.Author 				= "Ce1azz"
SWEP.Instructions			= "Not to be confused with the digital media format."
SWEP.Category 				= "Weapon"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= 32
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9х19 mm Parabellum"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = 5
SWEP.Primary.Sound = "mp5k/mp5k_fp.wav"
SWEP.Primary.SoundFar = "mp5k/mp5k_dist.wav"
SWEP.Primary.Force = 85/3
SWEP.ReloadTime = 2
SWEP.ShootWait = 0.12
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

SWEP.ViewModel				= "models/weapons/w_grub_mp40.mdl"
SWEP.WorldModel				= "models/weapons/w_grub_mp40.mdl"

SWEP.vbwPos = Vector(-4,-3.7,2)
SWEP.vbwAng = Angle(2,-30,0)

SWEP.addAng = Angle(0,1.5,5)

SWEP.SightPos = Vector(-37,0.3,0)