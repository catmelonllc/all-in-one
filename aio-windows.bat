@echo off
setlocal enabledelayedexpansion

:: AIO Windows Toolkit v1
:: WARNING: This script contains an extremely destructive command.

:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click the file and select "Run as administrator".
    pause
    exit
)

:menu
cls
echo ==================================================
echo           AIO Windows Toolkit v1
echo ==================================================
echo.
echo --- Reboot & Power ---
echo  1) Reboot to UEFI Firmware
echo  2) Reboot to BIOS (Helper)
echo.
echo --- System Information ---
echo  3) Show OS and System Info
echo  4) Show System Uptime
echo  5) Show CPU Info
echo  6) Show Disk Partitions
echo  7) Show Network IP Config
echo.
echo --- System Maintenance & Diagnostics ---
echo  8) Update Windows & Apps (winget)
echo  9) Check Disk Space
echo 10) Check Memory Usage
echo 11) List Open Network Ports
echo 12) Test Internet Connectivity (ping)
echo 13) Trace Network Route
echo 14) Clean Up System Files (cleanmgr)
echo.
echo --- DANGEROUS ---
echo 99) LAST RESORT (PERMANENTLY FORMAT C: DRIVE)
echo.
echo  0) Exit
echo ==================================================

set /p "choice=Enter your choice: "

if "%choice%"=="1" goto :reboot_uefi
if "%choice%"=="2" goto :reboot_bios
if "%choice%"=="3" goto :sys_info
if "%choice%"=="4" goto :uptime
if "%choice%"=="5" goto :cpu_info
if "%choice%"=="6" goto :disk_info
if "%choice%"=="7" goto :ip_config
if "%choice%"=="8" goto :win_update
if "%choice%"=="9" goto :disk_space
if "%choice%"=="10" goto :mem_usage
if "%choice%"=="11" goto :net_ports
if "%choice%"=="12" goto :ping_test
if "%choice%"=="13" goto :trace_route
if "%choice%"=="14" goto :cleanmgr
if "%choice%"=="99" goto :last_resort
if "%choice%"=="0" exit

echo Invalid option.
pause
goto :menu

:reboot_uefi
echo This will reboot your PC into the UEFI firmware setup.
shutdown /r /fw /t 5
goto :end_pause

:reboot_bios
echo #############################################################
echo # IMPORTANT: Automatic reboot to BIOS is not possible.      #
echo # This is a standard reboot. Be ready to press your BIOS key#
echo # (e.g., Del, F2, F10, Esc).                                #
echo #############################################################
shutdown /r /t 5
goto :end_pause

:sys_info
systeminfo
goto :end_pause

:uptime
systeminfo | find "System Boot Time"
goto :end_pause

:cpu_info
wmic cpu get name, numberofcores, numberoflogicalprocessors
goto :end_pause

:disk_info
wmic logicaldisk get caption,drivetype,filesystem,size,freespace
goto :end_pause

:ip_config
ipconfig /all
goto :end_pause

:win_update
echo Updating all possible packages with winget...
winget upgrade --all --accept-source-agreements --accept-package-agreements
goto :end_pause

:disk_space
fsutil volume diskfree c:
goto :end_pause

:mem_usage
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory"
goto :end_pause

:net_ports
echo Listing active connections and listening ports...
netstat -ano
goto :end_pause

:ping_test
ping google.com
goto :end_pause

:trace_route
tracert google.com
goto :end_pause

:cleanmgr
echo Starting Disk Cleanup utility...
cleanmgr /sageset:1 & cleanmgr /sagerun:1
goto :end_pause

:last_resort
set "CONFIRMATION_PHRASE=I UNDERSTAND THIS IS PERMANENT"
echo ##################################################################
echo #                      EXTREME DANGER ZONE                       #
echo # This will execute 'format C: /y' and DESTROY ALL DATA on the   #
echo # main system drive, including Windows itself.                   #
echo ##################################################################
echo.
echo To proceed, you MUST type the following phrase exactly:
echo   %CONFIRMATION_PHRASE%
set /p "user_confirmation=> "

if not "!user_confirmation!"=="%CONFIRMATION_PHRASE%" (
    echo Confirmation failed. Aborting system destruction.
    goto :end_pause
)

echo Confirmation accepted. There is no going back.
echo SYSTEM DESTRUCTION IN 10 SECONDS... (CLOSE THIS WINDOW TO ABORT)
timeout /t 10

echo DESTROYING SYSTEM... GOODBYE.
format C: /y
goto :end_pause

:end_pause
echo.
pause
goto :menu