local REQUIRED = 'vivid-pdbadge'
local current = GetCurrentResourceName()

PdBadgeGuard = {
    valid = current == REQUIRED,
    name = REQUIRED,
}

if PdBadgeGuard.valid then return end

local lines = {
    '^1========================================^7',
    ('^1[%s]^7 Resource name mismatch.'):format(REQUIRED),
    ('^7Folder is ^1"%s"^7 — rename it to ^2"%s"^7.'):format(current, REQUIRED),
    '^7This resource will not run until renamed. (This is to prevent bugs and issues with updates.)',
    '^1========================================^7',
}

for i = 1, #lines do
    print(lines[i])
end

if IsDuplicityVersion() then
    CreateThread(function()
        Wait(250)
        StopResource(current)
    end)
end
