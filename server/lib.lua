PdBadge = {}

local showCooldown = {}

local blockedSchemes = {
    'javascript:',
    'data:',
    'file:',
    'vbscript:',
}

function PdBadge.player(src)
    return exports.qbx_core:GetPlayer(src)
end

function PdBadge.leoOnly(job)
    if not job or not IsLeoJob(job.name) then
        return false, 'You are not authorised to use police badge actions.'
    end
    return true
end

function PdBadge.leoAuthorized(job)
    local ok, err = PdBadge.leoOnly(job)
    if not ok then return false, err end
    if Config.RequireOnDuty and not job.onduty then
        return false, 'You must be on duty.'
    end
    return true
end

function PdBadge.canShow(src)
    local now = GetGameTimer()
    local last = showCooldown[src]
    if last and (now - last) < Config.ShowCooldownMs then
        return false
    end
    showCooldown[src] = now
    return true
end

function PdBadge.cleanUrl(url)
    if type(url) ~= 'string' then return nil end

    url = url:match('^%s*(.-)%s*$')
    if url == '' or #url > Config.MaxPhotoUrlLength then return nil end

    local lower = url:lower()
    for i = 1, #blockedSchemes do
        if lower:find(blockedSchemes[i], 1, true) then
            return nil
        end
    end

    if not url:match('^https?://%S+$') then
        return nil
    end

    return url
end

function PdBadge.nearby(src, range)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return {} end

    local origin = GetEntityCoords(ped)
    local list = {}

    for _, playerId in ipairs(GetPlayers()) do
        local id = tonumber(playerId)
        if id then
            local otherPed = GetPlayerPed(id)
            if otherPed and otherPed ~= 0 then
                if #(origin - GetEntityCoords(otherPed)) <= range then
                    list[#list + 1] = id
                end
            end
        end
    end

    return list
end

AddEventHandler('playerDropped', function()
    showCooldown[source] = nil
end)
