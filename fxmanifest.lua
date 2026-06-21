fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'vivid-pdbadge'
description 'Police badge for DN'
author 'kubanscripts - vividresources'
version '0.1.0'

ui_page 'ui/index.html'

files {
    'ui/**/*',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/leo.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/anim.lua',
    'client/badge.lua',
    'client/photo.lua',
    'client/item.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/lib.lua',
    'server/photos.lua',
    'server/version.lua',
    'server/badge.lua',
}

