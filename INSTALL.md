# vivid-pdbadge

Police badge wallet for Qbox. Officers use the `vivid-badge` item to flash their ID; nearby players see the same overlay.

## Install

1. Import [`sql/install.sql`](sql/install.sql)
2. Ensure `vivid-pdbadge` starts after `oxmysql` and `qbx_core` (included in `ensure [vivid]`)

## Dependencies

- qbx_core
- ox_lib
- oxmysql
- ox_inventory

## Commands

| Command | Description |
|---------|-------------|
| `/pdbadge` | Set, update, or remove your badge photo (saved to SQL) |

## Item

`vivid-badge` is registered in `ox_inventory/data/items.lua`.

## Config

Edit `config.lua` for police jobs, show range, duration, department text, and animation/prop offsets.

## UI tuning

Photo slot and text layout: `ui/style.css` on `.badge-frame` and `.identity`.

Wallet art: replace `ui/assets/wallet-nophoto.png` and `ui/assets/wallet-photo.png`.

## Photo storage

Photos are stored in `vivid_pdbadge_photos` by `citizenid` and persist across restarts.

## Version check

On start, the server fetches [vividresources_versions](https://github.com/vividresources/vividresources_versions) and compares your installed version to the manifest. Add this entry to `versions.json` on that repo:

```json
{
  "script": "vivid-pdbadge",
  "version": "1.0.0",
  "note": "Initial release",
  "required": false
}
```

Bump `version` in `versions.json` when you publish updates. Toggle with `Config.VersionCheckEnabled` in `config.lua`.
