@echo off
mode con: cols=60 lines=20
color 0A
title Arc Recon Toolbox

set "OfficePath=C:\Program Files (x86)\ArcRecon"
set "ConfigFile=%OfficePath%\configuration.xml"
set "UninstallExe=%OfficePath%\Uninstall.exe"
echo.

:menu
cls
echo.
echo ==========================
echo     Arc Recon Toolbox
echo ==========================
echo.
echo 1. Run ChrisTitusTool
echo 2. Remove OneDrive
echo 3. Activate Spicetify
echo 4. Right Click Ownership
echo 5. Install Brave Browser
echo 6. Auto Game Configuration
echo 7. Exit
echo.

set /p choice=Enter your choice : 

if "%choice%"=="2" goto onedrive
if "%choice%"=="1" goto ctt
if "%choice%"=="3" goto freespotify
if "%choice%"=="4" goto rcowner
if "%choice%"=="5" goto brave
if "%choice%"=="6" goto gamercfg
if "%choice%"=="10" goto exiter

:onedrive
    set /P onechoice=Do you want to remove Onedrive ? (Y/N): 
    if /i "%onechoice%"=="Y" (
        echo Uninstalling OneDrive...
        echo.

        REM Terminate any running OneDrive processes
        taskkill /f /im OneDrive.exe >nul 2>&1
        REM Uninstall OneDrive
        %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
        %SystemRoot%\System32\OneDriveSetup.exe /uninstall >nul 2>&1

        REM Remove OneDrive folders and registry keys
        rd "%UserProfile%\OneDrive" /Q /S >nul 2>&1
        rd "C:\OneDriveTemp" /Q /S >nul 2>&1
        rd "%LocalAppData%\Microsoft\OneDrive" /Q /S >nul 2>&1
        rd "%ProgramData%\Microsoft OneDrive" /Q /S >nul 2>&1

        reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
        reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
        reg delete "HKEY_CURRENT_USER\Software\Microsoft\OneDrive" /f >nul 2>&1
        reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
        reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1

        echo.
        echo OneDrive has been uninstalled.
        pause
        goto menu
    ) else goto menu

:ctt
    set /P cttchoice=Do you want to use the Chris Titus tool? (Y/N): 
    if /i "%cttchoice%"=="Y" (
        powershell -Command "iwr -useb https://christitus.com/win | iex" 
        pause
        goto menu
    ) else goto menu    

:freespotify
    echo Install Spotify and login in to your account before running this ...
    set /P spotchoice=Do you want to install Spicetify? (Y/N): 
    if /i "%spotchoice%"=="Y" (
        powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1 | iex" 
        pause
        powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1 | iex"
        pause
        goto menu
    ) else goto menu

:rcowner
    cls
    echo.
    echo Right-click Take Ownership Menu
    echo ==================================================
    echo 1. Add Take Ownership
    echo 2. Remove Take Ownership
    echo 3. Back to the Menu
    echo ==================================================
    set /p rcop=Type option:
    if "%rcop%"=="1" goto addowner
    if "%rcop%"=="2" goto remowner
    if "%rcop%"=="3" goto menu
    cls
    :addowner
    cls
    echo Adding Take Ownership to the context menu...
    Reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f
    Reg add "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
    Reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f
    Reg add "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f
    Reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f
    Reg add "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
    Reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f
    Reg add "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f
    timeout /t 2 >nul
    cls
    echo Take Ownership has been added to the Context Menu.
    goto begin

    :remowner
    cls
    echo Removing Take Ownership from the Context Menu...
    Reg delete "HKCR\*\shell\runas" /f
    Reg delete "HKCR\Directory\shell\runas" /f
    timeout /t 2 >nul
    cls
    echo Take Ownership has been removed from the context menu.
    goto begin
    
:brave
    set "braveInstallerURL=https://laptop-updates.brave.com/latest/winx64"
    set "installerPath=%USERPROFILE%\Downloads\BraveInstaller.exe"
    powershell -command "(New-Object System.Net.WebClient).DownloadFile('%braveInstallerURL%', '%installerPath%')"
    if %errorlevel% neq 0 (
    echo Error: Failed to download Brave browser.
    exit /b 1
    )
    "%installerPath%"
    if %errorlevel% neq 0 (
        echo Error: Failed to install Brave browser.
        exit /b 1
    )
    del "%installerPath%"
    echo Brave browser has been successfully installed.
    goto menu

:gamercfg
    setlocal enabledelayedexpansion
    for /f "tokens=*" %%i in ('powercfg /list ^| findstr /i "Ultimate Performance"') do (
        set "powerPlanExists=1"
    )
    if not defined powerPlanExists (
        powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        set "powerPlanExists=1"
    )
    if defined powerPlanExists (
        powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        echo Setting the power plan to Ultimate Performance...
    ) else (
        echo Failed to create the Ultimate Performance power plan.
        goto menu
    )
    goto begin

:exiter
    if exist "%OfficePath%"(
    start /wait "" "%UninstallExe%"
    echo Tool uninstallation completed.
    echo.
    echo Exiting...
    Exit
    ) else Exit