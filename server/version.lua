if not PdBadgeGuard.valid then return end

PdBadgeVersion = {}

local resource = GetCurrentResourceName()

local function localVersion()
    return GetResourceMetadata(resource, 'version', 0) or '0.0.0'
end

local function splitVersion(value)
    local parts = {}
    for num in tostring(value or '0'):gmatch('%d+') do
        parts[#parts + 1] = tonumber(num) or 0
    end
    if #parts == 0 then parts[1] = 0 end
    return parts
end

local function isNewer(remote, localVer)
    local a = splitVersion(remote)
    local b = splitVersion(localVer)
    local len = math.max(#a, #b)

    for i = 1, len do
        local rv = a[i] or 0
        local lv = b[i] or 0
        if rv > lv then return true end
        if rv < lv then return false end
    end

    return false
end

local function findEntry(list, scriptName)
    if type(list) ~= 'table' then return nil end

    for i = 1, #list do
        local row = list[i]
        if type(row) == 'table' and row.script == scriptName then
            return row
        end
    end
end

local function banner(lines)
    print('^3========================================^7')
    for i = 1, #lines do
        print(lines[i])
    end
    print('^3========================================^7')
end

function PdBadgeVersion.check()
    if Config.VersionCheckEnabled == false then return end

    local url = Config.VersionCheckUrl
    if type(url) ~= 'string' or url == '' then return end

    local scriptName = Config.VersionScriptName or resource
    local installed = localVersion()

    PerformHttpRequest(url, function(status, body)
        if status ~= 200 or type(body) ~= 'string' or body == '' then
            print(('[vivid-pdbadge] Version check failed (HTTP %s).'):format(tostring(status)))
            return
        end

        local ok, list = pcall(json.decode, body)
        if not ok or type(list) ~= 'table' then
            print('[vivid-pdbadge] Version check failed (bad JSON).')
            return
        end

        local entry = findEntry(list, scriptName)
        if not entry or type(entry.version) ~= 'string' then
            print(('[vivid-pdbadge] No manifest entry for "%s".'):format(scriptName))
            return
        end

        if not isNewer(entry.version, installed) then
            print(('[vivid-pdbadge] Up to date (v%s).'):format(installed))
            return
        end

        local note = type(entry.note) == 'string' and entry.note or 'Check Github for the latest build.'
        local required = entry.required == true

        banner({
            ('^3[%s]^7 Update available'):format(resource),
            ('^7Installed: ^1v%s^7  ->  Latest: ^2v%s^7'):format(installed, entry.version),
            ('^7Changes: ^3%s^7'):format(note),
            required and '^1Required:^7 Yes — update when you can.' or '^7Required:^7 No',
            ('^7Manifest: ^5%s^7'):format(url),
        })
    end, 'GET')
end

AddEventHandler('onResourceStart', function(name)
    if name ~= resource then return end
    SetTimeout(1500, PdBadgeVersion.check)
end)
