AddCSLuaFile()

SWEP.Base = "medkit"

SWEP.PrintName = "Blood Transfusion Kit"
SWEP.Author = "Homigrad"
SWEP.Instructions = "500mL of blood. Hold Left Click to extract blood from a target, and right click to deposit blood into a target."

SWEP.Spawnable = true
SWEP.Category = "Medical"

SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.ViewModel = "models/blood_bag/models/blood_bag.mdl"
SWEP.WorldModel = "models/blood_bag/models/blood_bag.mdl"

SWEP.dwsPos = Vector(55,55,20)

SWEP.vbwPos = Vector(2,6,-8)
SWEP.vbwAng = Angle(0,0,0)
SWEP.vbwModelScale = 0.25

SWEP.vbwPos2 = Vector(0,3,-8)
SWEP.vbwAng2 = Angle(0,0,0)

function SWEP:vbwFunc(ply)
    local ent = ply:GetWeapon("medkit")
    if ent and ent.vbwActive then return self.vbwPos,self.vbwAng end
    return self.vbwPos2,self.vbwAng2
end

if CLIENT then
    net.Receive("blood_gotten",function(len)
        local wep = net.ReadEntity()
        wep.bloodinside = not net.ReadBool()

        wep.PrintName = wep.bloodinside and "Blood Transfusion Kit" or "Empty Blood Transfusion Kit"
    end)

    SWEP.dwmModeScale = 1
    SWEP.dwmForward = 5
    SWEP.dwmRight = 5
    SWEP.dwmUp = -1

    SWEP.dwmAUp = 30
    SWEP.dwmARight = 90
    SWEP.dwmAForward = 0

end