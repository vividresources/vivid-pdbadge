local function fetchPhoto(citizenid)
    return MySQL.scalar.await(
        'SELECT photo_url FROM vivid_pdbadge_photos WHERE citizenid = ? LIMIT 1',
        { citizenid }
    )
end

local function storePhoto(citizenid, url)
    MySQL.insert.await([[
        INSERT INTO vivid_pdbadge_photos (citizenid, photo_url)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE photo_url = VALUES(photo_url)
    ]], { citizenid, url })
end

local function wipePhoto(citizenid)
    MySQL.update.await('DELETE FROM vivid_pdbadge_photos WHERE citizenid = ?', { citizenid })
end

lib.callback.register('vivid-pdbadge:photo:get', function(source)
    local player = PdBadge.player(source)
    if not player then return nil end

    local ok = PdBadge.leoOnly(player.PlayerData.job)
    if ok ~= true then return nil end

    return fetchPhoto(player.PlayerData.citizenid)
end)

lib.callback.register('vivid-pdbadge:photo:save', function(source, url)
    local player = PdBadge.player(source)
    if not player then return false, 'Player not loaded.' end

    local ok, err = PdBadge.leoOnly(player.PlayerData.job)
    if not ok then return false, err end

    local cleaned = PdBadge.cleanUrl(url)
    if not cleaned then
        return false, 'Invalid URL. Use a direct http(s) image link.'
    end

    storePhoto(player.PlayerData.citizenid, cleaned)
    return true, 'Badge photo saved.'
end)

lib.callback.register('vivid-pdbadge:photo:remove', function(source)
    local player = PdBadge.player(source)
    if not player then return false, 'Player not loaded.' end

    local ok, err = PdBadge.leoOnly(player.PlayerData.job)
    if not ok then return false, err end

    wipePhoto(player.PlayerData.citizenid)
    return true, 'Badge photo removed.'
end)

function PdBadge.getPhoto(citizenid)
    if not citizenid then return nil end
    return fetchPhoto(citizenid)
end
