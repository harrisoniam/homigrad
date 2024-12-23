
local blackListedWeps = {
	["weapon_hands"] = true
}

local blackListedAmmo = {
	[8] = true,
	[9] = true,
	[10] = true
}

local AmmoTypes = {
	[47] = "vgui/hud/hmcd_round_792",
	[44] = "vgui/hud/hmcd_round_792",
	[2] = "vgui/hud/hmcd_health",
	[48] = "vgui/hud/hmcd_round_9",
	[45] = "vgui/hud/hmcd_round_556",
	[38] = "vgui/hud/hmcd_round_38",
	[6] = "vgui/hud/hmcd_round_arrow",
	[41] = "vgui/hud/hmcd_round_12",
	[8] = "vgui/wep_jack_hmcd_oldgrenade",
	[9] = "vgui/wep_jack_hmcd_oldgrenade",
	[10] = "vgui/wep_jack_hmcd_oldgrenade",
	[11] = "vgui/wep_jack_hmcd_ied"
}

local white = Color(255,255,255)
local black = Color(0,0,0,128)
local black2 = Color(64,64,64,128)

local function getText(text,limitW)
	local newText = {}
	local newText_I = 1
	local curretText = ""

	surface.SetFont("DefaultFixedDropShadow")

	for i = 1,#text do
		local sumbol = string.sub(text,i,i)
		local w,h = surface.GetTextSize(curretText .. sumbol)

		if w >= limitW then
			newText_I = newText_I + 1
			curretText = sumbol
		else
			curretText = curretText .. sumbol
		end

		newText[newText_I] = curretText
	end

	return newText
end

local panel
local function openInventoryPanel(lootEnt, nickname, items, items_ammo)
    if IsValid(panel) then panel.override = true panel:Remove() end

    panel = vgui.Create("DFrame")
    panel:SetAlpha(255)
    panel:SetSize(500, 400)
    panel:Center()
    panel:SetDraggable(false)
    panel:MakePopup()
    panel:SetTitle("")

    function panel:OnKeyCodePressed(key)
        if key == KEY_W or key == KEY_S or key == KEY_A or key == KEY_D then self:Remove() end
    end

    function panel:OnRemove()
        if self.override then return end

        net.Start("inventory")
        net.WriteEntity(lootEnt)
        net.SendToServer()
    end

    panel.Paint = function(self, w, h)
        if not IsValid(lootEnt) or not LocalPlayer():Alive() then panel:Remove() return end

        draw.RoundedBox(0, 0, 0, w, h, black)
        surface.SetDrawColor(255, 255, 255, 128)
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

        draw.SimpleText(nickname .. "'s Inventory", "DefaultFixedDropShadow", 6, 6, white)
    end

    local x, y = 40, 40
    local corner = 6

    if table.Count(items) == 0 then
        panel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, black)
            surface.SetDrawColor(255, 255, 255, 128)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

            draw.SimpleText(nickname .. " has no items.", "DefaultFixedDropShadow", w / 2, h / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        return
    end

    for wep, weapon in pairs(items) do
        local button = vgui.Create("DButton", panel)
        button:SetPos(x, y)
        button:SetSize(64, 64)

        x = x + button:GetWide() + 6
        if x + button:GetWide() >= panel:GetWide() then
            x = 40
            y = y + button:GetTall() + 6
        end

        button:SetText("")

        local wepTbl = wep

        local text = type(wepTbl) == "table" and wepTbl.PrintName or wep
        text = getText(text, button:GetWide() - corner * 2)

        button.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and black2 or black)
            surface.SetDrawColor(255, 255, 255, 128)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

            for i, text in pairs(text) do
                draw.SimpleText(text, "DefaultFixedDropShadow", corner, corner + (i - 1) * 12, white)
            end

            local x, y = self:LocalToScreen(0, 0)
            DrawWeaponSelectionEX(wepTbl, x, y, w, h)
        end

        function button:OnRemove()
            if IsValid(model) then model:Remove() end
        end

        button.DoRightClick = function()
            net.Start("ply_take_item")
            net.WriteEntity(lootEnt)
            net.WriteString(wep)
            net.SendToServer()
        end

        button.DoClick = function()
            net.Start("ply_take_item")
            net.WriteEntity(lootEnt)
            net.WriteString(wep)
            net.SendToServer()
        end
    end

    for ammo, amt in pairs(items_ammo) do
        if blackListedAmmo[ammo] then continue end
        local button = vgui.Create("DButton", panel)
        button:SetPos(x, y)
        button:SetSize(64, 64)

        x = x + button:GetWide() + 6
        if x + button:GetWide() >= panel:GetWide() then
            x = 40
            y = y + button:GetTall() + 6
        end

        button:SetText('')

        local text = game.GetAmmoName(ammo)
        text = getText(text, button:GetWide() - corner * 2)

        button.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and black2 or black)
            surface.SetDrawColor(255, 255, 255, 128)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

            local round = Material(AmmoTypes[tonumber(ammo)] or "vgui/hud/hmcd_person", "noclamp smooth")
            surface.SetMaterial(round)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(2, 2, w - 4, h - 4)

            for i, text in pairs(text) do
                draw.SimpleText(text, "DefaultFixedDropShadow", corner, corner + (i - 1) * 12, white)
            end
        end

        button.DoClick = function()
            net.Start("ply_take_ammo")
            net.WriteEntity(lootEnt)
            net.WriteFloat(tonumber(ammo))
            net.SendToServer()
        end
        button.DoRightClick = button.DoClick
    end
end

net.Receive("inventory", function()
    local lply = LocalPlayer()

    local lootEnt = net.ReadEntity()
    local success, items = pcall(net.ReadTable)
    local nickname = lootEnt:IsPlayer() and lootEnt:Name() or lootEnt:GetNWString("Nickname") or ""

    if not success or not lootEnt then return end

    if IsValid(lootEnt:GetNWEntity("ActiveWeapon")) and items[lootEnt:GetNWEntity("ActiveWeapon"):GetClass()] then
        items[lootEnt:GetNWEntity("ActiveWeapon"):GetClass()] = nil
    end

    local items_ammo = net.ReadTable()

    items.weapon_hands = nil

    if not IsValid(panel) then
        -- Create the "Searching..." panel only if no inventory panel exists
        local searchingPanel = vgui.Create("DFrame")
        searchingPanel:SetAlpha(255)
        searchingPanel:SetSize(300, 100)
        searchingPanel:Center()
        searchingPanel:SetDraggable(false)
        searchingPanel:MakePopup()
        searchingPanel:SetTitle("")

        local searchingTimer

        searchingPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, black)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("Searching "..nickname.."...", "DefaultFixedDropShadow", w / 2, h / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        searchingPanel.OnRemove = function()
            if searchingTimer then timer.Remove(searchingTimer) end
        end

		searchingTimer = timer.Simple(2, function()
			if IsValid(searchingPanel) then
				searchingPanel:Remove()
				openInventoryPanel(lootEnt, nickname, items, items_ammo)
			end
		end)
    else
        -- Refresh the existing inventory panel
        openInventoryPanel(lootEnt, nickname, items, items_ammo)
    end
end)
