@echo off
setlocal

set "steamcmdLocation=C:\steamcmd"
set "steamcmdUrl=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
set "tempZip=%TEMP%\steamcmd.zip"

if exist "%steamcmdLocation%\steamcmd.exe" (
    echo steamcmd is already installed at "%steamcmdLocation%".
    exit /b 0
)

if not exist "%steamcmdLocation%" mkdir "%steamcmdLocation%"

echo Downloading steamcmd...
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%steamcmdUrl%' -OutFile '%tempZip%'"
if errorlevel 1 (
    echo ERROR: Failed to download steamcmd from %steamcmdUrl%.
    pause
    exit /b 1
)

echo Extracting steamcmd to "%steamcmdLocation%"...
powershell -NoProfile -Command "Expand-Archive -Path '%tempZip%' -DestinationPath '%steamcmdLocation%' -Force"
if errorlevel 1 (
    echo ERROR: Failed to extract steamcmd.
    pause
    exit /b 1
)

del "%tempZip%"

echo Bootstrapping steamcmd (first run downloads its own updates)...
"%steamcmdLocation%\steamcmd.exe" +quit
rem steamcmd routinely returns a non-zero exit code on +quit even after a
rem successful self-update (e.g. its "work processing queue not empty"
rem shutdown warning), so errorlevel here is not a reliable success signal.
rem What matters is whether steamcmd.exe exists afterwards.

if not exist "%steamcmdLocation%\steamcmd.exe" (
    echo ERROR: steamcmd.exe still missing after bootstrap - install failed.
    pause
    exit /b 1
)

echo steamcmd installed successfully at "%steamcmdLocation%".
