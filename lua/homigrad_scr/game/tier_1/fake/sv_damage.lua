hook.Add("PlayerSpawn","Damage",function(ply)
    if PLYSPAWN_OVERRIDE then return end

	ply.Organs = {
		['brain']=5,
		['lungs']=40,
		['liver']=10,
		['stomach']=30,
		['intestines']=30,
		['heart']=20,
		['artery']=1,
		['spine']=5
	}

	ply.InternalBleeding=nil
	ply.InternalBleeding2=nil
	ply.InternalBleeding3=nil
	ply.InternalBleeding4=nil
	ply.InternalBleeding5=nil
	ply.arterybleeding=false
	ply.brokenspine=false
	ply.Attacker = nil
	ply.KillReason = nil


	ply.msgLeftArm = 0
	ply.msgRightArm = 0
	ply.msgLeftLeg = 0
	ply.msgRightLeg = 0
	
	ply.LastDMGInfo = nil
	ply.LastHitPhysicsBone = nil
	ply.LastHitBoneName = nil
	ply.LastHitGroup = nil
	ply.LastAttacker = nil
end)

local util_TraceLine = util.TraceLine

function GetPhysicsBoneDamageInfo(ent,dmgInfo)
	local pos = dmgInfo:GetDamagePosition()
	local dir = dmgInfo:GetDamageForce():GetNormalized()

	dir:Mul(1024 * 8)

	local tr = {}
	tr.start = pos
	tr.endpos = pos + dir
	tr.ignoreworld = true

	local result = util_TraceLine(tr)
	if result.Entity ~= ent then
		tr.endpos = pos - dir

		return util_TraceLine(tr).PhysicsBone
	else
		return result.PhysicsBone
	end
end

local NULLENTITY = Entity(-1)

hook.Add("EntityTakeDamage","ragdamage",function(ent,dmginfo) --урон по разным костям регдолла
	if ent.nohook then return end
	if ent:IsPlayer() and IsValid(ent.FakeRagdoll) then return end
	if IsValid(ent:GetPhysicsObject()) and dmginfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_CLUB+DMG_GENERIC+DMG_BLAST) then ent:GetPhysicsObject():ApplyForceOffset(dmginfo:GetDamageForce():GetNormalized() * math.min(dmginfo:GetDamage() * 10,3000),dmginfo:GetDamagePosition()) end
	local ply = RagdollOwner(ent) or ent

	if ent:IsRagdoll() and dmginfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT+DMG_BLAST+DMG_SLASH) then
		local effdata = EffectData()
		effdata:SetOrigin(dmginfo:GetDamagePosition())
		effdata:SetRadius(1)
		effdata:SetMagnitude(1)
		effdata:SetScale(1)
		util.Effect("BloodImpact",effdata)
	end

	if ent.IsArmor then
		ply = ent.Owner
		ent = ply:GetNWEntity("Ragdoll") or ply.FakeRagdoll or ply
	end

	if not ply or not ply:IsPlayer() or not ply:Alive() or ply:HasGodMode() then
		return
	end

	local rag = ply:IsPlayer() and IsValid(ply.FakeRagdoll) and ply.FakeRagdoll
	
	if rag and dmginfo:IsDamageType(DMG_CRUSH) and att and att:IsRagdoll() then
		dmginfo:SetDamage(0)

		return true
	end

	local physics_bone = GetPhysicsBoneDamageInfo(ent,dmginfo)

	--[[if not bone then
		local att = dmginfo:GetAttacker()
		if IsValid(att) and att:IsPlayer() then att:ChatPrint("Незарегало.") end
		ply:ChatPrint("Незарегало.")--fun moment
		print("незарегало.")

		return --impossible
	end]]--

	local hitgroup
	local isfall

	local bonename = ent:GetBoneName(ent:TranslatePhysBoneToBone(physics_bone))
	ply.LastHitBoneName = bonename

	if bonetohitgroup[bonename] then hitgroup = bonetohitgroup[bonename] end

	local mul = RagdollDamageBoneMul[hitgroup]

	if rag and mul then dmginfo:ScaleDamage(mul) end

	local entAtt = dmginfo:GetAttacker()
	local att =
		(entAtt:IsPlayer() and entAtt:Alive() and entAtt) or
		--RagdollOwner(entAtt) or
		(entAtt:GetClass() == "wep" and entAtt:GetOwner()) --or
		--(IsValid(att) and att)
	--att = att ~= ply and att
	att = ply.LastAttacker -- Made it so last attacker can only be a player

	if IsValid(att) then dmginfo:SetAttacker(att) end

	ply.LastAttacker = att
	ply.LastHitGroup = hitgroup

	local armors = JMod.LocationalDmgHandling(ply,hitgroup,dmginfo)
	local armorMul,armorDur = 1,0
	local haveHelmet

	for armorInfo,armorData in pairs(armors) do
		local dur = armorData.dur / armorInfo.dur

		local slots = armorInfo.slots
		if dmginfo:IsDamageType(DMG_BULLET + DMG_BUCKSHOT) then
			if (slots.mouthnose or slots.head) then
				sound.Emit(ent,"player/bhit_helmet-1.wav",90)

				haveHelmet = true
			elseif
				slots.leftshoulder or
				slots.rightshoulder or
				slots.leftforearm or
				slots.rightforearm or
				slots.leftthigh or
				slots.rightthigh or
				slots.leftcalf or
				slots.rightcalf
			then
				sound.Emit(ent,"snd_jack_hmcd_ricochet_"..math.random(1,2)..".wav",90)
			else
				sound.Emit(ent,"player/kevlar" .. math.random(1,6) .. ".wav",90)
			end
		end

		if dur >= 0.25 then
			armorDur = (armorData.dur / 100) * dur
			--dur = math.max(dur - 0.5,0)

			armorMul = math.max(1 - armorDur,0.25)

			break
		end
	end

	dmginfo:SetDamage(dmginfo:GetDamage() * armorMul)
	local rubatPidor = DamageInfo()
	rubatPidor:SetAttacker(dmginfo:GetAttacker())
	--rubatPidor:SetInflictor(dmginfo:GetInflictor())
	rubatPidor:SetDamage(dmginfo:GetDamage())
	rubatPidor:SetDamageType(dmginfo:GetDamageType())
	rubatPidor:SetDamagePosition(dmginfo:GetDamagePosition())
	rubatPidor:SetDamageForce(dmginfo:GetDamageForce())

	ply.LastDMGInfo = rubatPidor

	dmginfo:ScaleDamage(0.5)
	hook.Run("HomigradDamage",ply,hitgroup,dmginfo,rag,armorMul,armorDur,haveHelmet)
	dmginfo:ScaleDamage(0.2)

	if dmginfo:IsDamageType(DMG_BLAST) then
		dmginfo:ScaleDamage(2)
	end

	if rag then
		if dmginfo:GetDamageType() == DMG_CRUSH then
			dmginfo:ScaleDamage(1 / 40 / 15)
		end
		--[[
		ply:SetHealth(ply:Health() - dmginfo:GetDamage())

		if ply:Health() <= 0 then ply:Kill() end
		--]]

		ply:TakeDamageInfo(dmginfo)
	end
end)

local bonenames = {
    ['ValveBiped.Bip01_Head1']="Head",
    ['ValveBiped.Bip01_Spine']="Spine",
    ['ValveBiped.Bip01_R_Hand']="Right Hand",
    ['ValveBiped.Bip01_R_Forearm']="Right Forearm",
    ['ValveBiped.Bip01_R_Foot']="Right Foot",
    ['ValveBiped.Bip01_R_Thigh']='Right Thigh',
    ['ValveBiped.Bip01_R_Calf']='Right Calf',
    ['ValveBiped.Bip01_R_Shoulder']='Right Shoulder',
    ['ValveBiped.Bip01_R_Elbow']='Right Elbow',
	['ValveBiped.Bip01_L_Hand']='Left Hand',
    ['ValveBiped.Bip01_L_Forearm']='Left Forearm',
    ['ValveBiped.Bip01_L_Foot']='Left Foot',
    ['ValveBiped.Bip01_L_Thigh']='Left Thigh',
    ['ValveBiped.Bip01_L_Calf']='Left Calf',
    ['ValveBiped.Bip01_L_Shoulder']='Left Shoulder',
    ['ValveBiped.Bip01_L_Elbow']='Left Elbow'
}

local reasons = {
	["blood"] = "You died from server blood loss.",
	["pain"] = "You died from extreme & severe pain.",
	["painlosing"] = "You died from an overdose.",
	["adrenaline"] = "You died from an overdose.",
	["killyourself"] = "You killed yourself.",
	["hungry"] = "You died of hunger.",
	["virus"] = "You died from the Zombie Virus.",
	["poison"] = "You died from poison entering your system.",
	["guilt"] = "You were slayed for exceeding your guilt maximum."
}

hook.Add("PlayerDeath","plymessage",function(ply,hitgroup,dmginfo)
	local att = ply.LastAttacker
	--if not IsValid(att) then return end
	local boneName = bonenames[ply.LastHitBoneName]
	local add = (boneName and " a " .. boneName or "")

	local reason = ply.KillReason
	local dmgInfo = dmgInfo or ply.LastDMGInfo

	if ply == att then
		ply:ChatPrint("You killed yourself.") -- FIXME: ply:ChatPrint("You killed yourself." .. add)
	elseif reason then
		ply:ChatPrint(reasons[reason] or "You died under mysterious circumstances.")
	elseif att then
		local dmgtype = "wounded"
	
		dmgtype = dmgInfo:IsDamageType(DMG_BULLET+DMG_BUCKSHOT) and (dmgInfo:IsDamageType(DMG_BUCKSHOT) and "from a gunshot wound" or "from a gunshot wound") or 
			dmgInfo:IsExplosionDamage() and "from an explosive" or 
			dmgInfo:IsDamageType(DMG_SLASH) and "from a knife wound" or 
			dmgInfo:IsDamageType(DMG_CLUB+DMG_GENERIC) and "from blunt-force trauma" or 
			dmgtype
		
		ply:ChatPrint("You died " .. dmgtype) -- FIXME: Add ' .. add' at the end of string.
		ply:ChatPrint("You were killed by: " .. att:Name())
	
		player.EventPoint(att:GetPos(),"hitgroup killed",512,att,ply)
	else
		ply:ChatPrint("You died under mysterious circumstances.")
	end
end)