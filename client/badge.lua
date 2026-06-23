if not PdBadgeGuard.valid then return end

BadgeUI = {
    open = false,
    token = 0,
    holder = false,
}

function BadgeUI.show(data)
    if BadgeUI.open or not data then return end

    local myId = GetPlayerServerId(PlayerId())
    BadgeUI.holder = data.holderId == myId
    BadgeUI.open = true
    BadgeUI.token = BadgeUI.token + 1
    local token = BadgeUI.token

    if BadgeUI.holder then
        BadgeAnim.play(Config.ShowDurationMs)
    end

    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'showBadge',
        data = {
            photoUrl = data.photoUrl,
            firstname = data.firstname,
            lastname = data.lastname,
            rank = data.rank,
            department = data.department,
            cardText = data.cardText,
        },
    })

    SetTimeout(Config.ShowDurationMs, function()
        if BadgeUI.open and BadgeUI.token == token then
            BadgeUI.hide()
        end
    end)
end

function BadgeUI.hide()
    if not BadgeUI.open then return end

    BadgeUI.open = false
    BadgeUI.token = BadgeUI.token + 1
    BadgeUI.holder = false
    BadgeAnim.stop()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideBadge' })
end

RegisterNetEvent('vivid-pdbadge:client:displayBadge', function(payload)
    BadgeUI.show(payload)
end)

CreateThread(function()
    while true do
        if BadgeUI.open then
            if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 322) then
                BadgeUI.hide()
            end
            Wait(0)
        else
            Wait(400)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    BadgeUI.hide()
end)
