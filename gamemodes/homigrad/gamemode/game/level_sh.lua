LevelList = {}

function TableRound(name) return _G[name or roundActiveName] end

timer.Simple(0,function()
    if roundActiveName == nil then --and not (string.find(string.lower(game.GetMap()), "rp_desert_conflict")) then
        if GetConVar("sv_construct"):GetBool() == true then
            roundActiveName = "construct"
            roundActiveNameNext = "construct"
        else
            roundActiveName = "homicide"
            roundActiveNameNext = "homicide"
        end

        StartRound()
    end
end)