BadgeAnim = {}
local prop = nil

local function ped()
    return cache.ped or PlayerPedId()
end

function BadgeAnim.stop()
    local anim = Config.BadgeAnim
    local entity = ped()

    if prop and DoesEntityExist(prop) then
        DetachEntity(prop, true, true)
        DeleteEntity(prop)
        prop = nil
    end

    if IsEntityPlayingAnim(entity, anim.dict, anim.clip, 3) then
        StopAnimTask(entity, anim.dict, anim.clip, 1.0)
    end

    ClearPedSecondaryTask(entity)
end

function BadgeAnim.play(ms)
    local entity = ped()
    if IsPedInAnyVehicle(entity, false) or IsEntityDead(entity) then return end

    BadgeAnim.stop()

    local anim = Config.BadgeAnim
    local loaded = pcall(lib.requestAnimDict, anim.dict, 5000)
    if not loaded then return end

    lib.requestModel(Config.BadgeProp)

    local coords = GetEntityCoords(entity)
    prop = CreateObject(Config.BadgeProp, coords.x, coords.y, coords.z + 0.2, true, true, false)
    SetEntityCollision(prop, false, false)

    local attach = Config.BadgePropAttach
    AttachEntityToEntity(
        prop,
        entity,
        GetPedBoneIndex(entity, Config.BadgePropBone),
        attach.pos.x, attach.pos.y, attach.pos.z,
        attach.rot.x, attach.rot.y, attach.rot.z,
        true, true, false, true, 1, true
    )

    TaskPlayAnim(entity, anim.dict, anim.clip, 8.0, -8.0, ms, Config.BadgeAnimFlag, 0, false, false, false)
end
