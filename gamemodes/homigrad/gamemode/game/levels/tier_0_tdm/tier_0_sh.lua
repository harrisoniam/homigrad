table.insert(LevelList,"tdm")
tdm = {}
tdm.Name = "Team Deathmatch"

local models = {}

for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

for i = 1,6 do table.insert(models,"models/player/group01/female_0" .. i .. ".mdl") end

--table.insert(models,"models/player/group02/male_02.mdl")
--table.insert(models,"models/player/group02/male_06.mdl")
--table.insert(models,"models/player/group02/male_08.mdl")

--for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

tdm.models = models
tdm.red = {
	"Red",Color(255,75,75),
	weapons = {"weapon_binokle","weapon_radio","weapon_gurkha","weapon_hands","med_band_big","med_band_small","medkit","painkiller"},
	main_weapon = {"weapon_ak74u","weapon_akm","weapon_remington870","weapon_galil","weapon_rpk","weapon_asval","weapon_p90","weapon_scout","weapon_barret"},
	secondary_weapon = {"weapon_p220","weapon_mateba","weapon_glock"},
	models = models
}


tdm.blue = {
	"Blue",Color(75,75,255),
	weapons = {"weapon_binokle","weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_handcuffs","weapon_taser"},
	main_weapon = {"weapon_hk416","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_asval","weapon_m249","weapon_p90","weapon_scout","weapon_barret"},
	secondary_weapon = {"weapon_beretta","weapon_p99","weapon_hk_usp"},
	models = models
}

tdm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function tdm.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,tdm.red[2])
	team.SetColor(2,tdm.blue[2])

	if CLIENT then return end

	tdm.StartRoundSV()
end

if SERVER then return end

local colorRed = Color(255,0,0)

function tdm.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function tdm.ChangeValue(oldName,value)
	local oldValue = tdm[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function tdm.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end