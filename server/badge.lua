if not PdBadgeGuard.valid then return end

RegisterNetEvent('vivid-pdbadge:server:showBadge', function()
    local src = source
    if not PdBadge.canShow(src) then return end

    local player = PdBadge.player(src)
    if not player then return end

    local ok, err = PdBadge.leoAuthorized(player.PlayerData.job)
    if not ok then
        lib.notify(src, { type = 'error', description = err })
        return
    end

    local charinfo = player.PlayerData.charinfo
    local job = player.PlayerData.job
    local payload = {
        holderId = src,
        firstname = charinfo.firstname,
        lastname = charinfo.lastname,
        rank = job.grade.name,
        department = Config.DepartmentName,
        cardText = Config.CardText,
        photoUrl = PdBadge.getPhoto(player.PlayerData.citizenid),
    }

    local viewers = PdBadge.nearby(src, Config.ShowRange)
    for i = 1, #viewers do
        TriggerClientEvent('vivid-pdbadge:client:displayBadge', viewers[i], payload)
    end
end)
