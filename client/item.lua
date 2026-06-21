exports('useBadge', function(_, _)
    local job = QBX.PlayerData.job
    if not IsLeoJob(job and job.name) then
        lib.notify({ type = 'error', description = 'You are not authorised to use this badge.' })
        return
    end

    if Config.RequireOnDuty and not job.onduty then
        lib.notify({ type = 'error', description = 'You must be on duty to show your badge.' })
        return
    end

    if BadgeUI.open then return end

    TriggerServerEvent('vivid-pdbadge:server:showBadge')
end)
