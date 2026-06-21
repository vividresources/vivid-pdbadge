local function notify(type, description)
    lib.notify({ type = type, description = description })
end

RegisterCommand(Config.PhotoCommand, function()
    local job = QBX.PlayerData.job
    if not IsLeoJob(job and job.name) then
        return notify('error', 'You are not authorised to manage a badge photo.')
    end

    local current = lib.callback.await('vivid-pdbadge:photo:get', false)

    local input = lib.inputDialog('Police Badge Photo', {
        {
            type = 'input',
            label = 'Photo URL',
            description = 'Direct image link (https://...)',
            icon = 'link',
            default = current or '',
        },
        {
            type = 'checkbox',
            label = 'Remove my badge photo',
        },
    })

    if not input then return end

    if input[2] then
        local ok, msg = lib.callback.await('vivid-pdbadge:photo:remove', false)
        return notify(ok and 'success' or 'error', msg)
    end

    local url = input[1]
    if not url or url:match('^%s*$') then
        return notify('error', 'Enter a URL or tick remove photo.')
    end

    local ok, msg = lib.callback.await('vivid-pdbadge:photo:save', false, url)
    notify(ok and 'success' or 'error', msg)
end, false)
