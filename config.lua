Config = {}

Config.Item = 'vivid-badge'
Config.PhotoCommand = 'pdbadge'

Config.PoliceJobs = { 'police' } -- JOBS THAT CAN USE IT 
Config.RequireOnDuty = true

Config.ShowRange = 5.0 -- RANGE IT SHOWS OTHER PLAYERS
Config.ShowDurationMs = 10000
Config.ShowCooldownMs = 2500

Config.DepartmentName = 'Victoria Police Force' -- NUI ONLY
Config.CardText = 'The Bearer of this card is a member of the' -- NUI ONLY

-- ANIM BULLSHIT
Config.MaxPhotoUrlLength = 512
Config.BadgeProp = `prop_fib_badge`
Config.BadgeAnimFlag = 49
Config.BadgePropBone = 28422
Config.BadgePropAttach = {
    pos = vec3(0.06, 0.021, -0.04),
    rot = vec3(-90.0, -180.0, 78.999),
}
Config.BadgeAnim = {
    dict = 'paper_1_rcm_alt1-8',
    clip = 'player_one_dual-8',
}

Config.VersionCheckEnabled = true
Config.VersionCheckUrl = 'https://raw.githubusercontent.com/vividresources/vividresources_versions/main/versions.json'
Config.VersionScriptName = 'vivid-pdbadge'
