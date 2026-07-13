# steamcmd-server-scripts

Shared Windows batch scripts for installing SteamCMD and updating a dedicated
server app via SteamCMD. Used as a git submodule (`common/`) by
[pz-server-scripts](https://github.com/daredled/pz-server-scripts) and
[dayz-server-scripts](https://github.com/daredled/dayz-server-scripts), and
intended for reuse by any similar dedicated-server-scripts repo.

## Setup

Set your Steam account username as an environment variable before running
`install_steam_app.bat` (never hardcode it in scripts):

```
set STEAM_USER=yourSteamAccount
```

Use `setx STEAM_USER=yourSteamAccount` instead if you want it to persist
across cmd sessions.

## Scripts

### `install_steamcmd.bat`
Downloads and bootstraps SteamCMD into `C:\steamcmd` if it isn't already
installed. Safe to call every time - it's a no-op if `steamcmd.exe` already
exists there.

### `install_steam_app.bat <appId> <installDir> [beta:branchName] [validate]`
Installs/updates a single Steam app via SteamCMD. Installs SteamCMD first if
needed (by calling `install_steamcmd.bat` in this same folder).

- `<appId>` - the Steam app ID to install (e.g. `380870` for Project Zomboid
  dedicated server, `223350` for DayZ dedicated server).
- `<installDir>` - where to install it.
- `beta:branchName` - optional, switches to a beta branch (e.g. `beta:unstable`).
- `validate` - optional, adds SteamCMD's `validate` flag (full file checksum
  verification; slower).

Examples:
```
install_steam_app.bat 380870 C:\pzserver
install_steam_app.bat 380870 C:\pzserverb42 beta:unstable validate
install_steam_app.bat 223350 C:\DayZServer
```

This script is generic on purpose - it doesn't know about any particular
game. Game-specific concerns (checking whether the server is currently
running before updating, default install paths, mod downloads, etc.) belong
in the calling repo's own wrapper script.

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
