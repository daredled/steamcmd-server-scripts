# steamcmd-server-scripts

Shared Windows batch scripts for installing SteamCMD and updating a dedicated
server app via SteamCMD. Used as a git submodule (`common/`) by
[pz-server-scripts](https://github.com/daredled/pz-server-scripts) and
[dayz-server-scripts](https://github.com/daredled/dayz-server-scripts), and
intended for reuse by any similar dedicated-server-scripts repo.

## Setup

Set your Steam account username as an environment variable before running
`steam_app_install.bat` (never hardcode it in scripts):

```
set STEAM_USER=yourSteamAccount
```

Use `setx STEAM_USER yourSteamAccount` instead if you want it to persist
across cmd sessions.

## Scripts

### `steamcmd_install.bat`
Downloads and bootstraps SteamCMD into `C:\steamcmd` if it isn't already
installed. Safe to call every time - it's a no-op if `steamcmd.exe` already
exists there.

### `steam_app_install.bat <appId> <installDir> [beta:branchName] [validate]`
Installs/updates a single Steam app via SteamCMD. Installs SteamCMD first if
needed (by calling `steamcmd_install.bat` in this same folder).

- `<appId>` - the Steam app ID to install (e.g. `380870` for Project Zomboid
  dedicated server, `223350` for DayZ dedicated server).
- `<installDir>` - where to install it.
- `beta:branchName` - optional, switches to a beta branch (e.g. `beta:unstable`).
- `validate` - optional, adds SteamCMD's `validate` flag (full file checksum
  verification; slower).

Examples:
```
steam_app_install.bat 380870 C:\pzserver
steam_app_install.bat 380870 C:\pzserverb42 beta:unstable validate
steam_app_install.bat 223350 C:\DayZServer
```

This script is generic on purpose - it doesn't know about any particular
game. Game-specific concerns (checking whether the server is currently
running before updating, default install paths, etc.) belong in the calling
repo's own wrapper script.

### `steam_workshop_mods_install.bat <appId> <installDir> <modId> <folderName>`
Downloads a single Steam Workshop item via SteamCMD and installs it into
`<installDir>\<folderName>`. Installs SteamCMD first if needed. Handles one
mod per call - call it once per mod.

- `<appId>` - the Steam app ID the workshop item belongs to (e.g. `221100`
  for DayZ).
- `<installDir>` - the server install directory (the workshop download lands
  under `<installDir>\steamapps\workshop\content\<appId>\<modId>` first, then
  gets copied into `<installDir>\<folderName>`).
- `<modId>` - the Steam Workshop item ID.
- `<folderName>` - whatever local mod folder name the server expects
  (usually `@ModName`).

Example:
```
steam_workshop_mods_install.bat 221100 C:\DayZServer 1559212036 @CF
steam_workshop_mods_install.bat 221100 C:\DayZServer 1828439124 @VPPAdminTools
```

This script only handles the generic "download + drop into a folder" part.
Anything else mod-related that's engine- or server-specific (copying key
files out of the mod folder, custom mission files bundled inside a mod's
workshop folder, extra config copies, etc.) belongs in the calling repo's
own wrapper script.

## Notes

- **steamcmd exit codes are unreliable.** `steamcmd.exe +quit` routinely
  returns a non-zero exit code even after a fully successful run (a known
  steamcmd quirk). These scripts don't treat that as a hard failure - check
  the printed output / `C:\steamcmd\logs` if you want to confirm a run
  actually succeeded.

## Using this as a submodule

```
git submodule add https://github.com/daredled/steamcmd-server-scripts.git common
```

When cloning a repo that depends on this one:

```
git clone --recurse-submodules <repo-url>
```

or, if already cloned:

```
git submodule update --init
```
