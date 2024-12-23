local grtodown = Material( "vgui/gradient-u" )
local grtoup = Material( "vgui/gradient-d" )
local grtoright = Material( "vgui/gradient-l" )
local grtoleft = Material( "vgui/gradient-r" )

pain,painlosing,impulse = 0,0,0

net.Receive("info_pain",function()
    pain = net.ReadFloat()
    painlosing = net.ReadFloat()
end)

local ScrW,ScrH = ScrW,ScrH
local math_Clamp = math.Clamp
local k = 0
local k4 = 0
local time = 0
local colwhite = Color(255, 255, 255, 255)
local colred = Color(255, 0, 0, 255)

surface.CreateFont("HomigradFontBig",{
	font = "Roboto",
	size = 25,
	weight = 1100,
	outline = false,
	shadow = true
})

hook.Add("HUDPaint","PainEffect",function()
    if not LocalPlayer():Alive() or LocalPlayer():Team() == 1002 then return end

    local w,h = ScrW(),ScrH()
    k = LerpFT(0.1,k,math_Clamp(pain / 250,0,15))
    
    local k2 = painlosing >= 5 and (painlosing / 5 - 1) or 0
      
    local ply = LocalPlayer()

    if ply:GetNWInt("unconscious") and ply:Alive() and ply:Team() ~= TEAM_SPECTATOR then
        draw.DrawText("You are currently unconscious.", "HomigradFontNotify", ScrW() / 2, ScrH() / 2.1,
            colwhite, TEXT_ALIGN_CENTER)

        if pain and pain > 250 then
            draw.DrawText("Assuming you're still in great shape, you'll be back up in " ..
                math.floor(((pain - 250) / 20) + 1) .. " second(s)!", "HomigradFontSmall",
                ScrW() / 2, ScrH() / 1.8,
                colwhite, TEXT_ALIGN_CENTER)
        elseif blood and blood < 3000 then
            draw.DrawText("You have lost too much blood and have gone comatose!\nIf you are bleeding, your only hope is another person's help.", "HomigradFontSmall",
                ScrW() / 2, ScrH() / 1.8,
                colred, TEXT_ALIGN_CENTER)
        end
    end
end)

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

net.Receive("info_impulse",function()
    impulse = net.ReadFloat() * 50
end)

local k3 = 0
hook.Add("RenderScreenspaceEffects","renderimpulse",function()

    k3 = math.Clamp(Lerp(0.01,k3,impulse),0,50)

    if LocalPlayer():Alive() and not LocalPlayer():Team() ~= 1002 then
        DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)
    end
end)