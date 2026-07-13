@echo off
setlocal

if "%~1"=="" goto usage
if "%~2"=="" goto usage
if "%~3"=="" goto usage
if "%~4"=="" goto usage

set "appId=%~1"
set "installDir=%~2"
set "modId=%~3"
set "folderName=%~4"

if "%STEAM_USER%"=="" (
    echo ERROR: STEAM_USER environment variable is not set.
    echo   set STEAM_USER=yourSteamAccount
    exit /b 1
)

if not exist "%~dp0steamcmd_install.bat" (
    echo ERROR: steamcmd_install.bat not found next to steam_workshop_mods_install.bat.
    exit /b 1
)

call "%~dp0steamcmd_install.bat"
if errorlevel 1 (
    echo ERROR: steamcmd_install.bat failed.
    exit /b 1
)

echo Downloading workshop mod %modId% via SteamCMD...
cd /d "C:\steamcmd"
steamcmd +force_install_dir "%installDir%" +login %STEAM_USER% +workshop_download_item %appId% %modId% +quit

rem steamcmd routinely returns a non-zero exit code on +quit even after a
rem successful download (the same quirk as steam_app_install.bat), so we
rem don't gate on errorlevel here.

set "workshopContent=%installDir%\steamapps\workshop\content\%appId%\%modId%"

echo Installing %folderName% (%modId%)...
robocopy "%workshopContent%" "%installDir%\%folderName%" /E /R:3 /W:5

rem robocopy exit codes 0-7 all indicate some degree of success; only 8+
rem is a real failure, so we don't gate on errorlevel here either.

echo Mod installed: %folderName%.
exit /b 0

:usage
echo Usage: steam_workshop_mods_install.bat ^<appId^> ^<installDir^> ^<modId^> ^<folderName^>
echo   Requires the STEAM_USER environment variable to be set.
echo   Downloads and installs one mod per call - call it once per mod.
exit /b 1
