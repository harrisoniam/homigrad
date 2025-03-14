table.insert(LevelList,"hl2dm")
hl2dm = {}
hl2dm.Name = "Half Life 2 Death Match"

local models = {}
for i = 1,9 do table.insert(models,"models/player/group03/male_0" .. i .. ".mdl") end

hl2dm.red = {"Resistance",Color(125,95,60),
	weapons = {"weapon_hands","med_band_big","med_band_small","weapon_radio"},
	main_weapon = {"weapon_sar2","weapon_spas12","weapon_akm","weapon_mp7","weapon_scout","weapon_barrett"},
	secondary_weapon = {"weapon_hk_usp","weapon_p220"},
	models = models
}


hl2dm.blue = {"Combine",Color(75,75,125),
	weapons = {"weapon_hands"},
	main_weapon = {"weapon_sar2","weapon_spas12","weapon_mp7","weapon_scout","weapon_barrett"},
	secondary_weapon = {"weapon_hk_usp"},
	models = {"models/player/combine_soldier.mdl"}
}

hl2dm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function hl2dm.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,hl2dm.red[2])
	team.SetColor(2,hl2dm.blue[2])

	if CLIENT then

		hl2dm.StartRoundCL()
		return
	end

	hl2dm.StartRoundSV()
end
hl2dm.RoundRandomDefalut = 2
hl2dm.SupportCenter = true
