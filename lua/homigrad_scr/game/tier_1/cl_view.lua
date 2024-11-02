local t = {}
local n, e, r, o
local d = Material('materials/scopes/scope_dbm.png')
CameraSetFOV = 120

CreateClientConVar("hg_fov","120",true,false,nil,70,120)
local smooth_cam = CreateClientConVar("hg_smooth_cam","1",true,false,nil,0,1)

CreateClientConVar("hg_bodycam","0",true,false,nil,0,1)

CreateClientConVar("hg_fakecam_mode","0",true,false,nil,0,1)

CreateClientConVar("hg_deathsound","1",true,false,nil,0,1)
CreateClientConVar("hg_deathscreen","1",true,false,nil,0,1)

function SETFOV(value)
	CameraSetFOV = value or GetConVar("hg_fov"):GetInt()
end

SETFOV()

cvars.AddChangeCallback("hg_fov",function(cmd,_,value)
    timer.Simple(0,function()
		SETFOV()
		print("	hg: change fov")
	end)
end)

surface.CreateFont("HomigradFontBig",{
	font = "Roboto",
	size = 25,
	weight = 1100,
	outline = false,
	shadow = true
})

surface.CreateFont("BodyCamFont",{
	font = "Arial",
	size = 40,
	weight = 1100,
	outline = false,
	shadow = true
})

local function a()
	e = 360
	r = GetRenderTarget('weaponSight-' .. e, e, e)
	if not t[e] then
		t[e] = CreateMaterial('weaponSight-' .. e, 'UnlitGeneric', {})
	end
	o = t[e]
	n = {}
	local r, o, t, e = 0, 0, e / 2, 24
	n[#n+1] = {
		x = r,
		y = o,
		u = .5,
		v = .5
	}
	for a = 0, e do
		local e = math.rad( (a/e)*-360 )
		n[#n+1] = {
			x = r+math.sin(e)*t,
			y = o+math.cos(e)*t,
			u = math.sin(e)/2+.5,
			v = math.cos(e)/2+.5
		}
	end
end

a()
--[[
local a = false
local function i(wep)
	a = true
	local n, t, o = wep:GetShootPos()
	render.PushRenderTarget(r)
	if util.TraceLine({start=n-t*25,endpos=n+t*((wep.SightZNear or 5)+5),filter=LocalPlayer(),}).Hit then
		render.Clear(0,0,0,255)
	else
		render.RenderView({
			origin = n,
			angles = o,
			fov = 100,
			znear = 5,
		})
	end
	render.PopRenderTarget()
	a = false
end

hook.Add("PostDrawOpaqueRenderables","", function()
	local wep = LocalPlayer():GetActiveWeapon()
	if wep.SightPos and wep.aimProgress and wep.aimProgress > 0 and wep:GetReady() then
		local t = wep:GetOwner()
		local a = t:LookupAttachment('anim_attachment_rh')
		if not a then return end
		local t = t:GetAttachment(a)
		local l, a = LocalToWorld(wep.SightPos, wep.SightAng, t.Pos, t.Ang)
		local t = e / -2
		cam.Start3D2D(l, a, wep.SightSize / e * 1.1)
			cam.IgnoreZ(true)
			render.ClearStencil()
			render.SetStencilEnable(true)
			render.SetStencilTestMask(255)
			render.SetStencilWriteMask(255)
			render.SetStencilReferenceValue(42)
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			surface.SetDrawColor(0,0,0,1)
			draw.NoTexture()
			surface.DrawPoly(n)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCIL_ZERO)
			o:SetTexture('$basetexture',r)
			o:SetFloat('$alpha',math.Clamp(math.Remap(wep.aimProgress,.1,1,0,1),0,1))
			surface.SetMaterial(o)
			surface.DrawTexturedRect(t,t,e,e)
			surface.SetDrawColor(255,255,255)
			surface.SetMaterial(d)
			surface.DrawTexturedRect(t-10,t-10,e+20,e+20)
			render.SetStencilEnable(false)
			cam.IgnoreZ(false)
		cam.End3D2D()
	end
end)

hook.Add('PreDrawEffects', 'octoweapons', function()
	if a then return end
	local wep = LocalPlayer():GetActiveWeapon()
	if LocalPlayer():KeyDown(IN_ATTACK2) then
		i(wep)
	end
end)]]--

local view = {
	x = 0,
	y = 0,
	drawhud = true,
	drawviewmodel = false,
	dopostprocess = true,
	drawmonitors = true
}

local render_Clear = render.Clear
local render_RenderView = render.RenderView

local white = Color(255,255,255)
local HasFocus = system.HasFocus
local oldFocus
local text

local hg_disable_stoprenderunfocus = CreateClientConVar("hg_disable_stoprenderunfocus","0",true)

local prekols = {
	"afk?",
	"no",
	"hg_disable_stoprenderunfocus 1",
	"huy",
	"kys"
}

local developer = GetConVar("developer")
local CalcView--fuck
local vel = 0
local diffang = Vector(0,0,0)
local diffpos = Vector(0,0,0)

hook.Add("RenderScene","octoweapons",function(pos,angle,fov)
	local focus = HasFocus()
	if focus ~= oldFocus then
		oldFocus = focus

		if not focus then
			text = table.Random(prekols)
		end
	end

	hook.Run("Frame",pos,angle)
	

	STOPRENDER = false -- not hg_disable_stoprenderunfocus:GetBool() and not developer:GetBool() and not focus

	if STOPRENDER then
		cam.Start2D()
			draw.SimpleText(text,"DebugFixedSmall",ScrW() / 2,ScrH() / 2,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		cam.End2D()

		return true
	end

	RENDERSCENE = true
	local _view = CalcView(LocalPlayer(),pos,angle,fov)

	if not _view then RENDERSCENE = nil return end

	view.fov = fov
	view.origin = _view.origin
	view.angles = _view.angles
	view.znear = _view.znear
	view.drawviewmodel = _view.drawviewmodel

	if CAMERA_ZFAR then
		view.zfar = CAMERA_ZFAR + 250--cl_fog in homigrad gamemode
	else
		view.zfar = nil
	end

	render_Clear(0,0,0,255,true,true,true)
	render_RenderView(view)

	RENDERSCENE = nil

	return true
end)

local ply = LocalPlayer()
local scrw, scrh = ScrW(), ScrH()
local whitelistweps = {
	["weapon_physgun"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["drgbase_possessor"] = true,
}

function RagdollOwner(rag)
	if not IsValid(rag) then return end

	local ent = rag:GetNWEntity("RagdollController")

	return IsValid(ent) and ent
end


--hook.Add("Think","pophead",function()
	--[[for i,ent in pairs(ents.FindByClass("prop_ragdoll")) do
		if !IsValid(RagdollOwner(ent)) or !RagdollOwner(ent):Alive() then
			ent:ManipulateBoneScale(6,Vector(1,1,1))
		end
	end]]--
--end)

hg_cool_camera = CreateClientConVar("hg_cool_camera","1",true,false,"huy",0,1)

local deathtrack = {
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144224389970272388/death1.mp3",
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144226357967065180/death2.mp3",
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144230250465734797/death3.mp3",
	"https://cdn.discordapp.com/attachments/1144224221334097974/1144238942862979142/death4.mp3",
}
local angZero = Angle(0,0,0)
local g_station = nil
local playing = false
local deathtexts = {
	"GONE, GONE...",
	"ALL CLYDE, NO BONNIE",
	"BURNED OUT",
	"WASTED",
	"BYE BYE!",
	"GAME OVER",
	"AND OVER AGAIN",
	"FUCKED UP",
	"HAHAHAHA",
	"SO BAD, SO SAD!",
	"CRY MORE, IN HELL",
	"NO MORE CHANCES",
	"CHOKER",
	"IF YOU CANT SEE",
	"HERE'S A LIL SOMETHING",
	"I AM READY",
	"LET ME TRY THIS SHIT",
	"EVIL",
	"DEAD",
	"TRY AGAIN",
	"CУКА"
}

gameevent.Listen("entity_killed")
hook.Add("entity_killed","killedplayer",function(data)
	local ent = Entity(data.entindex_killed)

	if ent:IsPlayer() then
		hook.Run("Player Death",ent)
	end
end)

local oldrag
hook.Add("Player Death","huyhuykilled",function(ent)
	if ent ~= LocalPlayer() then return end

	if GetConVar("hg_deathscreen"):GetBool() then
		deathrag = ent:GetNWEntity("Ragdoll",oldrag)
		deathtext = table.Random(deathtexts)

		-- TODO: Fix issue where, upon dying and immediately respawning, screen still fades to black 
		LocalPlayer():ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.5, 1 )
		if !playing and GetConVar("hg_deathsound"):GetBool() then
			playing = true
			sound.PlayURL ( table.Random(deathtrack), "mono", function( station )
				if ( IsValid( station ) ) then
					station:SetPos( LocalPlayer():GetPos() )
					station:Play()
					station:SetVolume(3)

					g_station = station				
				end
			end )
		end

		timer.Create("DeathCam",5,1,function()
			LocalPlayer():ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 1, 1 )
			playing = false
		end)
	end
	
	timer.Simple(4,function()
		if GetConVar("hg_deathscreen"):GetBool() then
			LocalPlayer():ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0, 255 ), 0.2, 1 )
		end
		if IsValid(deathrag) then
			deathrag:ManipulateBoneScale(deathrag:LookupBone("ValveBiped.Bip01_Head1"),Vector(1,1,1))
		end
	end)
end)

local ScopeLerp = 0
local scope
local G = 0
local size = 0.03
local angle = Angle(0)
local possight = Vector(0)

local function scopeAiming()
	local wep = LocalPlayer():GetActiveWeapon()

	return IsValid(wep) and weps[wep:GetClass()] and LocalPlayer():KeyDown(IN_ATTACK2) and not LocalPlayer():KeyDown(IN_SPEED)
end

LerpEyeRagdoll = Angle(0,0,0)

local lply = LocalPlayer()
LerpEye = IsValid(lply) and lply:EyeAngles() or Angle(0,0,0)

local vecZero,vecFull = Vector(0,0,0),Vector(1,1,1)
local firstPerson

local max = math.max
local upang = Angle(-90,0,0)
local oldShootTime
local startRecoil = 0
local angRecoil = Angle(0,0,0)
local recoil = 0
local sprinthuy = 0
local oldview = {}

local whitelistSimfphys = {}
whitelistSimfphys.gred_simfphys_brdm2 = true
whitelistSimfphys.gred_simfphys_brdm2_atgm = true
whitelistSimfphys.gred_simfphys_brdm_hq = true

local view = {}

ADDFOV = 0
ADDROLL = 0

follow = follow or NULL

local helmEnt

net.Receive("nodraw_helmet",function()
	helmEnt = net.ReadEntity()
end)

function CalcView(ply,vec,ang,fov,znear,zfar)
	if STOPRENDER then return end
	local fov = CameraSetFOV + ADDFOV
	local lply = LocalPlayer()
	
	if !ply:Alive() and timer.Exists("DeathCam") and IsValid(deathrag) then
		--deathrag:ManipulateBoneScale(6,vecZero)
		
		local att = deathrag:GetAttachment(deathrag:LookupAttachment("eyes"))
		
		LerpEyeRagdoll = LerpAngleFT(0.08,LerpEyeRagdoll,att.Ang)

		LerpEyeRagdoll[3] = LerpEyeRagdoll[3] + ADDROLL

		local view = {
			origin = att.Pos,
			angles = LerpEyeRagdoll,
			fov = fov,
			drawviewer = true
		}

		return view
	end

	DRAWMODEL = nil

	ADDFOV = 0
	ADDROLL = 0


	hook.Run("CalcAddFOV",ply)--megaggperkostil
	
	local result = hook.Run("PreCalcView",ply,vec,ang,fov,znear,zfar)
	if result ~= nil then
		result.fov = fov + ADDFOV
		result.angles[3] = result.angles[3] + ADDROLL

		return result
	end

	--[[if lply:InVehicle() then
		local diffvel = lply:GetVehicle():GetPos() - vel
		
		local view = {
			origin = lply:EyePos() + diffvel * 10,
			angles = lply:EyeAngles(),
			fov = fov
		}
		
		vel = lply:GetVehicle():GetPos()
		return view
	end--]]

	firstPerson = GetViewEntity() == lply

	local bone = lply:LookupBone("ValveBiped.Bip01_Head1")
	if bone then lply:ManipulateBoneScale(bone,firstPerson and vecZero or vecFull) end
	if not firstPerson then DRAWMODEL = true return end
	local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
	local body = ply:LookupBone("ValveBiped.Bip01_Spine2")

	--print(bodypos)

	if GetConVar("hg_bodycam"):GetInt() == 0 then
		angEye = lply:EyeAngles()
		--angEye[3] = 0
		vecEye = (eye and eye.Pos + eye.Ang:Up() * 2 + eye.Ang:Forward() * 1) or lply:EyePos()
	else
		local matrix = ply:GetBoneMatrix(body)
		local bodypos = matrix:GetTranslation()
		local bodyang = matrix:GetAngles()
		--bodyang:RotateAroundAxis(bodyang:Right(),90)

		--bodyang[2] = eye.Ang[2]
		--bodyang[3] = 0
		angEye = eye.Ang--bodyang
		vecEye = (eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 14 + bodyang:Right() * -6) or lply:EyePos()
	end

	local ragdoll = ply:GetNWEntity("Ragdoll")
	follow = ragdoll

	if ply:Alive() and IsValid(ragdoll) then
		ragdoll:ManipulateBoneScale(ragdoll:LookupBone("ValveBiped.Bip01_Head1"),vecZero)
		
		local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))
		
		local eyeAngs = lply:EyeAngles()
		if GetConVar("hg_bodycam"):GetInt() == 1 then
			local matrix = ragdoll:GetBoneMatrix(body)
			local bodypos = matrix:GetTranslation()
			local bodyang = matrix:GetAngles()
			
			eyeAngs = att.Ang
			att.Pos = (eye and bodypos + bodyang:Up() * 0 + bodyang:Forward() * 10 + bodyang:Right() * -8) or lply:EyePos()
		end
		local anghook = GetConVar("hg_fakecam_mode"):GetFloat()
		LerpEyeRagdoll = LerpAngleFT(0.08,LerpEyeRagdoll,LerpAngle(anghook,eyeAngs,att.Ang))

		LerpEyeRagdoll[3] = LerpEyeRagdoll[3] + ADDROLL

		local view = {
			origin = att.Pos,
			angles = LerpEyeRagdoll,
			fov = fov,
			drawviewer = true
		}

		if IsValid(helmEnt) then
			helmEnt:SetNoDraw(true)
		end

		return view
	end

	local wep = lply:GetActiveWeapon()
	wep = IsValid(wep) and wep

	local traca = lply:GetEyeTrace()
	local dist = traca.HitPos:Distance(lply:EyePos())

	view.fov = fov

	if lply:InVehicle() or not firstPerson then return end

	if not lply:Alive() or (IsValid(wep) and whitelistweps[wep:GetClass()]) or lply:GetMoveType() == MOVETYPE_NOCLIP then
		view.origin = ply:EyePos()
		view.angles = ply:EyeAngles()
		view.drawviewer = false
		
		return view
	end
	
	local output_ang = angEye + angRecoil
	local output_pos = vecEye

	if wep and wep.Camera then
		output_pos, output_ang = wep:Camera(ply, output_pos, output_ang)
	end

	if wep and hand then
		local posRecoil = Vector(recoil * 8,0,recoil * 1.5)
		posRecoil:Rotate(hand.Ang)
		view.znear = Lerp(ScopeLerp,1,max(1 - recoil,0.2))
		output_pos = output_pos + posRecoil

		if not RENDERSCENE then
			recoil = LerpFT(scope and (wep.CLR_Scope or 0.25) or (wep.CLR or 0.1),recoil,0)
		end
	else
		recoil = 0
	end

	vec = Vector(vec[1],vec[2],eye and eye.Pos[3] or vec[3])

	vel = math.max(math.Round(Lerp(0.1,vel,lply:GetVelocity():Length())) - 1,0)
	
	sprinthuy = LerpFT(0.1,sprinthuy,-math.abs(math.sin(CurTime() * 6)) * vel / 400)
	output_ang[1] = output_ang[1] + sprinthuy

	output_ang[3] = 0

	local anim_pos = max(startRecoil - CurTime(),0) * 5

	local tick = 1 / engine.AbsoluteFrameTime()
	playerFPS = math.Round(Lerp(0.1,playerFPS or tick,tick))
	
	local val = math.min(math.Round(playerFPS / 120,1),1)
	
	diffpos = LerpFT(0.1,diffpos,(output_pos - (oldview.origin or output_pos)) / 6)
	diffang = LerpFT(0.1,diffang,(output_ang:Forward() - (oldview.angles or output_ang):Forward()) * 50 + (lply:EyeAngles() + (lply:GetActiveWeapon().eyeSpray or angZero) * 1000):Forward() * anim_pos * 1)

	if RENDERSCENE then
		if hg_cool_camera:GetBool() then 
			output_ang[3] = output_ang[3] + math.min(diffang:Dot(output_ang:Right()) * 3 * val,10)
		end
		
		if hg_cool_camera:GetBool() then
			output_ang[3] = output_ang[3] + math.min(diffpos:Dot(output_ang:Right()) * 25 * val,10)
		end
	end

	if diffang then output_pos:Add((diffang * 1.5 + diffpos) * val) end

	local size = Vector(6,6,0)
	local tr = {}
	local dir = (output_pos - vec):GetNormalized()
	tr.start = vec
	tr.endpos = output_pos
	tr.mins = -size
	tr.maxs = size

	tr.filter = ply
	local trZNear = util.TraceHull(tr)
	size = size / 2
	tr.mins = -size
	tr.maxs = size

	tr = util.TraceHull(tr)

	local pos = lply:GetPos()
	pos[3] = tr.HitPos[3] + 1--wtf is this bullshit
	local trace = util.TraceLine({start = lply:EyePos(),endpos = pos,filter = ply,mask = MASK_SOLID_BRUSHONLY})
	tr.HitPos[3] = trace.HitPos[3] - 1
	output_pos = tr.HitPos
	output_pos = output_pos

	if trZNear.Hit then view.znear = 0.1 else view.znear = 1 end--САСАТЬ!!11.. не работает ;c sharik loh

	output_ang[3] = output_ang[3] + ADDROLL
	
	view.origin = output_pos
	view.angles = output_ang
	view.drawviewer = true
	
	oldview = table.Copy(view)

	DRAWMODEL = true
	
	return view
end

hook.Add("CalcView","VIEWhuy",CalcView)

hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
}
hook.Add("HUDShouldDraw","HideHUD",function(name)
	if (hide[name]) then return false end
end)

--[[
local allowedRanks = {
  ["superadmin"] = true,
  ["admin"] = true,
  ["operator"] = true,
  ["moderator"] = true,
  ["user"] = true,
  ["viptest"] = true,
  ["kakaha"] = true
}]]--

--[[прицелчики
hook.Add("PostDrawOpaqueRenderables", "example", function()
	local hand = LocalPlayer():GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
	local eye = LocalPlayer():GetAttachment(ply:LookupAttachment("eyes"))
	possight = hand.Pos + hand.Ang:Up() * 4.4 - hand.Ang:Forward() * -1 + hand.Ang:Right() * -0.15
	angle = hand.Ang + Angle(-90,0,0)


	cam.Start3D2D( possight, angle, 1 )
		surface.SetDrawColor( 255, 0, 0, 200)
		draw.NoTexture()
		draw.Circle(0,0,0.05,25 )
	cam.End3D2D()
end )
]]--

hook.Add("InputMouseApply", "asdasd2", function(cmd, x, y, angle)
	if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
	if not IsValid(follow) then return end
	
	local att = follow:GetAttachment(follow:LookupAttachment("eyes"))
	if not att or not istable(att) then return end

	local attang = LocalPlayer():EyeAngles()
	local view = render.GetViewSetup(true)
	local anglea = view.angles
	local angRad = math.rad(angle[3])
	local newX = x * math.cos(angRad) - y * math.sin(angRad)
	local newY = x * math.sin(angRad) + y * math.cos(angRad)

	angle.pitch = math.Clamp(angle.pitch + newY / 50, -180, 180)
	angle.yaw = angle.yaw - newX / 50

	if math.abs(angle.pitch) > 89 then
		angle.roll = angle.roll + 180
		angle.yaw = angle.yaw + 180
		angle.pitch = 89 * (angle.pitch / math.abs(angle.pitch))
	end

	cmd:SetViewAngles(angle)
	return true
end)

hook.Add("Think","mouthanim",function()
	--[[for i, ply in player.Iterator() do
		local ent = IsValid(ply:GetNWEntity("Ragdoll")) and ply:GetNWEntity("Ragdoll") or ply

		local flexes = {
			ent:GetFlexIDByName( "jaw_drop" ),
			ent:GetFlexIDByName( "left_part" ),
			ent:GetFlexIDByName( "right_part" ),
			ent:GetFlexIDByName( "left_mouth_drop" ),
			ent:GetFlexIDByName( "right_mouth_drop" )
		}
		
		local weight = ply:IsSpeaking() and math.Clamp( ply:VoiceVolume() * 6, 0, 6 ) or 0

		for k, v in ipairs( flexes ) do
			ent:SetFlexWeight( v, weight * 4 )
		end
	end--]]
end)

local tab = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0.1,
	[ "$pp_colour_brightness" ] = -0.05,
	[ "$pp_colour_contrast" ] = 1.5,
	[ "$pp_colour_colour" ] = 0.3,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0.5
}

local tab2 = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}


local mat = Material("pp/texturize/plain.png")

local blurMat2, Dynamic2 = Material("pp/blurscreen"), 0

local function BlurScreen(den,alp)
	local layers, density, alpha = 1, den, alph
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blurMat2)
	local FrameRate, Num, Dark = 1 / FrameTime(), 3, 150

	for i = 1, Num do
		blurMat2:SetFloat("$blur", (i / layers) * density * Dynamic2)
		blurMat2:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end

	Dynamic2 = math.Clamp(Dynamic2 + (1 / FrameRate) * 7, 0, 1)
end

local huy = math.random(1,10)
local triangle = {
	{ x = 1770, y =	150 },
	{ x = 1820, y = 50 },
	{ x = 1870, y = 150 }
}

local addmat_r = Material("CA/add_r")
local addmat_g = Material("CA/add_g")
local addmat_b = Material("CA/add_b")
local vgbm = Material("vgui/black")

local function DrawCA(rx, gx, bx, ry, gy, by)
    render.UpdateScreenEffectTexture()
    addmat_r:SetTexture("$basetexture", render.GetScreenEffectTexture())
    addmat_g:SetTexture("$basetexture", render.GetScreenEffectTexture())
    addmat_b:SetTexture("$basetexture", render.GetScreenEffectTexture())
    render.SetMaterial(vgbm)
    render.DrawScreenQuad()
    render.SetMaterial(addmat_r)
    render.DrawScreenQuadEx(-rx / 2, -ry / 2, ScrW() + rx, ScrH() + ry)
    render.SetMaterial(addmat_g)
    render.DrawScreenQuadEx(-gx / 2, -gy / 2, ScrW() + gx, ScrH() + gy)
    render.SetMaterial(addmat_b)
    render.DrawScreenQuadEx(-bx / 2, -by / 2, ScrW() + bx, ScrH() + by)
end

hook.Add("RenderScreenspaceEffects","BloomEffect-homigrad",function()
	if GetConVar("hg_bodycam"):GetInt() == 1 and LocalPlayer():Alive() then
		local splitTbl = string.Split(util.DateStamp()," ")
		local date,time = splitTbl[1],splitTbl[2]
		time = string.Replace(time,"-",":")

		draw.Text( {
			text = date.." "..time.." -0400",
			font = "BodyCamFont",
			pos = { ScrW() - 650, 50 }
		} )
		draw.Text( {
			text = "AXON BODY "..huy.." XG8A754GH",
			font = "BodyCamFont",
			pos = { ScrW() - 650, 100 }
		} )

		surface.SetDrawColor( 255, 255, 0, 255 )
		draw.NoTexture()
		surface.DrawPoly(triangle)

		DrawBloom( 0.5, 1, 9, 9, 1, 1.2, 0.8, 0.8, 1.2 )
		--DrawTexturize(1,mat)
		DrawSharpen( 1, 1.2 )
		DrawColorModify(tab)
		BlurScreen(0.3,55)
		LocalPlayer():SetDSP(55,true)
		DrawMotionBlur(0.2,0.3,0.001)
		--DrawToyTown(1,ScrH() / 2)
		local k3 = 6
		DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)
	end

	if not LocalPlayer():Alive() then
		LocalPlayer():SetDSP(1)
	end

	if LocalPlayer():Alive() then
		tab2["$pp_colour_colour"] = LocalPlayer():Health() / 150
		DrawColorModify(tab2)
	end

	if !LocalPlayer():Alive() and timer.Exists("DeathCam") then
		DrawMotionBlur(0.5,0.3,0.02)
		DrawSharpen( 1, 0.2 )
		local k3 = 15
		DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)
		tab2["$pp_colour_colour"] = 0.2
		tab2[ "$pp_colour_mulb" ] = 0.5
		DrawColorModify(tab2)
		BlurScreen(1,155)
		draw.Text( {
			text = deathtext,
			font = "BodyCamFont",
			pos = { ScrW()/2, ScrH()/1.2 },
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			color = Color(255,35,35,220)
		} )
		LocalPlayer():SetDSP(15)
	elseif not LocalPlayer():Alive() then
		LocalPlayer():SetDSP(1)
	end
	
end)


hook.Add("PostDrawTranslucentRenderables","fuck_off",function()
	--[[local lply = LocalPlayer()
	if lply == Entity(1) then
		local ent = lply:GetEyeTrace().Entity
		ent = ent:IsPlayer() and ent
		if ent then
			local pos,ang = ent:GetBonePosition(ent:LookupBone('ValveBiped.Bip01_Head1'))
			
			render.DrawBox( pos, ang, Vector(3,-6,-4), Vector(9,4,4), color_white )

			local dmgpos = ply:GetEyeTrace().HitPos
			local penetration = ply:GetAimVector() * 10
			local huy = util.IntersectRayWithOBB(dmgpos,penetration,pos,ang,Vector(2,-4,-3), Vector(7,4,3))

			print(huy)
		end
	end--]]
end )