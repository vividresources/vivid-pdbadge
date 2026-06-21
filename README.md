# vivid-pdbadge

Wallet-style police badge for Qbox servers. LEOs flash a physical badge prop and show a card overlay to players nearby — rank, name, and an optional photo pulled from the database.

**Version:** `0.1.0` · **Author:** kubanscripts / Vivid Resources

# ox_inventory item
```
['vivid-badge'] = {
    label = 'Police Badge',
    weight = 100,
    stack = false,
    consume = 0,
    client = {
    export = 'vivid-pdbadge.useBadge',
},
```
---

## Overview

Officers carry a `vivid-badge` inventory item. Using it plays a badge animation and opens a wallet UI for everyone in range. Identity comes from `qbx_core` (name + job grade); mugshots are set per character with `/pdbadge` and saved to MySQL so they survive restarts.

Server-side checks handle duty status, job whitelist, cooldown, and who receives the broadcast — clients only render what they're told to show.

## Requirements

| | |
|---|---|
| Framework | Qbox (`qbx_core`) |
| Inventory | ox_inventory |
| Libraries | ox_lib, oxmysql |

---

## Usage

| | |
|---|---|
| **Item** | Use `vivid-badge` from inventory while on duty |
| **`/pdbadge`** | Paste a photo URL, or clear your existing one |

Viewers within `Config.ShowRange` metres see the card for `Config.ShowDurationMs`. The holder gets the prop + animation; everyone else gets the NUI overlay only.

---

## Configuration

All tunables live in [`config.lua`](config.lua):

- `Config.PoliceJobs` / `Config.RequireOnDuty`
- Show range, duration, and cooldown
- Department name and card body text (NUI only)
- Badge prop attachment and animation dict
- GitHub version check (`Config.VersionCheckEnabled`)

Layout tweaks (photo crop, text size, wallet images) are in `ui/style.css` and `ui/assets/`.

---

## Updates

On start the resource can ping the [vividresources version manifest](https://github.com/vividresources/vividresources_versions) and print a console notice when a newer build is available. Disable with `Config.VersionCheckEnabled = false`.

---

## Support

Questions or issues → [discord.gg/vividresources](https://discord.gg/vividresources)
