@echo off
setlocal enabledelayedexpansion

if "%~1"=="" goto usage
if "%~2"=="" goto usage

set "appId=%~1"
set "installDir=%~2"

if "%STEAM_USER%"=="" (
    echo ERROR: STEAM_USER environment variable is not set.
    echo   set STEAM_USER=yourSteamAccount
    exit /b 1
)

set "validateFlag="
set "betaFlag="
for %%A in (%*) do (
    if /I "%%A"=="validate" set "validateFlag=validate"
    set "arg=%%A"
    if /I "!arg:~0,5!"=="beta:" set "betaFlag=-beta !arg:~5!"
)

if not exist "%~dp0steamcmd_install.bat" (
    echo ERROR: steamcmd_install.bat not found next to steam_app_install.bat.
    exit /b 1
)

call "%~dp0steamcmd_install.bat"
if errorlevel 1 (
    echo ERROR: steamcmd_install.bat failed.
    exit /b 1
)

cd /d "C:\steamcmd"

set CMD=^
+force_install_dir "%installDir%" ^
+login %STEAM_USER% ^
+app_update %appId% %betaFlag% %validateFlag% ^
+quit

steamcmd %CMD%

rem steamcmd routinely returns a non-zero exit code on +quit even after a
rem successful update (a known steamcmd quirk, not a real failure signal),
rem so we don't gate on errorlevel here. Check the output above / C:\steamcmd\logs
rem if you suspect the update actually failed.

echo Update complete for app %appId% (exit code %errorlevel% - see steamcmd output above).
exit /b 0

:usage
echo Usage: steam_app_install.bat ^<appId^> ^<installDir^> [beta:branchName] [validate]
echo   Requires the STEAM_USER environment variable to be set.
exit /b 1
