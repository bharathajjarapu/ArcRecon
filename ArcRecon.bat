@echo off
mode con: cols=120 lines=40
color 0A
title Arc Recon Toolbox
echo.

:menu
cls
echo.
echo =======================
echo     Arc Recon Toolbox
echo =======================
echo.
echo 1. Install Apps
echo 2. Run ChrisTitusTool
echo 3. Spotify Free
echo 4. Right Click Ownership
echo 5. Auto Game Configuration
echo 6. Exit
echo.

set /p choice=Enter your choice : 

if "%choice%"=="1" goto wingets
if "%choice%"=="2" goto ctt
if "%choice%"=="3" goto freespotify
if "%choice%"=="4" goto rcowner
if "%choice%"=="5" goto gamercfg
if "%choice%"=="6" goto exiter

:wingets
    @echo off
    cls
    rem Checking Microsoft.VCLibs.x64.14.00.Desktop.appx
    powershell -Command "& {Get-AppxPackage -Name Microsoft.VCLibs.x64.14.00.Desktop | Out-Null}"
    if %errorlevel% neq 0 (
        powershell -Command "& {Add-AppxPackage -Path 'C:\Path\To\Microsoft.VCLibs.x64.14.00.Desktop.appx' | Out-Null}"
    )

    rem Checking Microsoft.UI.Xaml.2.7.x64.appx
    powershell -Command "& {Get-AppxPackage -Name Microsoft.UI.Xaml.2.7.x64 | Out-Null}"
    if %errorlevel% neq 0 (
        powershell -Command "& {Add-AppxPackage -Path 'C:\Path\To\Microsoft.UI.Xaml.2.7.x64.appx' | Out-Null}"
    )

    rem Checking Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    powershell -Command "& {Get-AppxPackage -Name Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle | Out-Null}"
    if %errorlevel% neq 0 (
        powershell -Command "& {Add-AppxPackage -Path 'C:\Path\To\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' | Out-Null}"
    )
    cls
    color 0A
    echo.
    echo Install Apps using Winget
    echo ==================================================
    echo 1. Install Apps
    echo 2. Install UWP Apps Only
    echo 3. Update Apps
    echo 4. Uninstall UWP Apps
    echo 5. Exit
    echo ==================================================
    set /p wcop=Type option : 
    if "%wcop%"=="1" goto searchapps
    if "%wcop%"=="2" goto searchuwpapps
    if "%wcop%"=="3" goto updateapps
    if "%wcop%"=="4" goto uninstallapps
    if "%wcop%"=="5" goto menu
    cls

:searchapps
    cls
    color 0A
    set /P appchoice=App Name : 
    if "%appchoice%"=="0" (
        cls
        goto wingets
    )
    powershell -Command "winget search %appchoice%"
    set /P installchoice=Enter the ID of the app : 
    powershell -Command "winget show %installchoice%"
    powershell -Command "winget install %installchoice% -h --accept-package-agreements --accept-source-agreements"
    pause
    cls
    goto wingets

:searchuwpapps
    cls
    color 0A
    set /P uwpappchoice=App Name : 
    if "%uwpappchoice%"=="0" cls goto wingets
    powershell -Command "winget search %uwpappchoice% --source msstore"
    set /P installuwpchoice=Enter the ID of the app : 
    powershell -Command "winget show %installuwpchoice%"
    powershell -Command "winget install %installuwpchoice% --source msstore -h --accept-package-agreements --accept-source-agreements"
    pause
    cls
    goto wingets

:updateapps
    cls
    color 0A
    echo Apps Upgradable
    echo.
    powershell -Command "winget upgrade"
    echo.
    echo Enter all for all apps
    set /P upchoice=Enter the ID of the app : 
    if "%upchoice%"=="0" cls goto wingets
    powershell -Command "winget upgrade %upchoice%"
    pause
    cls
    goto wingets

:uninstallapps
    cls
    color 0A
    powershell -Command "winget list --source msstore"
    set /P unichoice=Enter the ID of the app : 
    if "%unichoice%"=="0" cls goto wingets
    powershell -Command "winget uninstall %unichoice%"
    pause
    cls
    goto wingets

:ctt
    set /P cttchoice=Do you want to use the Chris Titus tool? (Y/N): 
    if /i "%cttchoice%"=="Y" (
        powershell -Command "iwr -useb https://christitus.com/win | iex" 
        pause
        goto menu
    ) else goto menu    

:freespotify
    color 0A
    echo Accept the prompts on installing !!
    set /P spotchoice=Do you want to install Spotify Free? (Y/N): 
    if /i "%spotchoice%"=="Y" (
        powershell -Command "winget install Spotify.Spotify -h --accept-package-agreements --accept-source-agreements"
        pause
        powershell -Command "iwr -useb https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1 | iex"
        pause
        goto menu
    ) else goto menu

:rcowner
    cls
    color 0A
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
    color 0A
    echo Removing Take Ownership from the Context Menu...
    Reg delete "HKCR\*\shell\runas" /f
    Reg delete "HKCR\Directory\shell\runas" /f
    timeout /t 2 >nul
    cls
    echo Take Ownership has been removed from the context menu.
    goto begin

:gamercfg
    color 0A
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
    color 0A
    if exist "%OfficePath%"(
    start /wait "" "%UninstallExe%"
    echo Tool uninstallation completed.
    echo.
    echo Exiting...
    Exit
    ) else Exit
