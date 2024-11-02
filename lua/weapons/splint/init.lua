
include("shared.lua")

SWEP.Dealy = 0.25
local healsound = Sound("snd_jack_bandage.wav")

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Dealy)
    self:SetNextSecondaryFire(CurTime() + self.Dealy)

    local owner = self:GetOwner()

    
    sound.Play(healsound,owner:GetPos())

    if self:Heal(owner) then owner:SetAnimation(PLAYER_ATTACK1) self:Remove() self:GetOwner():SelectWeapon("weapon_hands") end
end

function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Dealy)
    self:SetNextSecondaryFire(CurTime() + self.Dealy)

    local owner = self:GetOwner()
    local trace = self:GetEyeTraceDist(150)
    local ent = trace.Entity
    ent = (ent:IsPlayer() and ent) or (RagdollOwner(ent)) or (ent:GetClass() == "prop_ragdoll" and ent)
    if not ent then return end

    if self:Heal(ent) then
        if ent:IsPlayer() then

            sound.Play(healsound,ent:GetPos(),75,100,0.5)
            local dmg = DamageInfo()
            dmg:SetDamage(-5)
            dmg:SetAttacker(self)

            local att = self:GetOwner()

            if GuiltLogic(att,ent,dmg,true) then
                att.Guilt = math.max(att.Guilt - 20,0)
            end
        end
        owner:SetAnimation(PLAYER_ATTACK1)
        self:Remove()
        self:GetOwner():SelectWeapon("weapon_hands")
    end
end

function SWEP:GetEyeTraceDist(dist)
    local owner = self:GetOwner()
    if not owner or not owner:IsValid() then return end

    local trace = util.TraceLine({
        start = owner:EyePos(),
        endpos = owner:EyePos() + owner:EyeAngles():Forward() * dist,
        filter = owner
    })

    return trace
end

local healsound = Sound("snd_jack_bandage.wav")

function SWEP:Heal(ent)
    if not ent or not ent:IsPlayer() then sound.Play(healsound,ent:GetPos(),75,100,0.5) return true end

    -- FIXME: If there is a bug here, probably just remove.
    if ent.LeftLeg < 1 then
        ent.LeftLeg = 1
        sound.Play(healsound,ent:GetPos(),75,100,0.5)
        
        return true
    elseif ent.RightLeg < 1 then
        ent.RightLeg = 1
        sound.Play(healsound,ent:GetPos(),75,100,0.5)
        
        return true
    elseif ent.LeftArm < 1 then
        ent.LeftArm = 1
        sound.Play(healsound,ent:GetPos(),75,100,0.5)

        return true
    elseif ent.RightArm < 1 then
        sound.Play(healsound,ent:GetPos(),75,100,0.5)

        return true
    else
        return true -- Why?
    end
end