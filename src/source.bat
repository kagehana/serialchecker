@echo off

if "%~1"=="run" goto setup

reg add "HKCU\Console" /v FaceName /t REG_SZ /d "Consolas" /f >nul 2>&1
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x000e0000 /f >nul 2>&1
reg add "HKCU\Console" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
start " " cmd /c "%~f0" run
exit

:setup

chcp 65001 >nul
for /f "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "PNK=%ESC%[38;2;255;182;210m"
set "DIM=%ESC%[38;2;100;100;110m"
set "WHT=%ESC%[97m"
set "RST=%ESC%[0m"
set "UND=%ESC%[4m"
set "UNX=%ESC%[24m"

:main

for /f "skip=1 tokens=* delims=" %%A in ('wmic diskdrive get serialnumber 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_DISK=%%B"
set "V_DISK=%V_DISK:.=%"
for /f "skip=1 tokens=* delims=" %%A in ('wmic baseboard get serialnumber 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_MOBO=%%B"
for /f "skip=1 tokens=* delims=" %%A in ('wmic path win32_computersystemproduct get uuid 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_SMBIOS=%%B"
for /f "skip=1 tokens=* delims=" %%A in ('wmic cpu get processorid 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_CPU=%%B"
for /f "skip=1 tokens=* delims=" %%A in ('wmic path Win32_NetworkAdapter where "PNPDeviceID like \"%%PCI%%\" AND NetConnectionStatus=2 AND AdapterTypeID=\"0\"" get MacAddress 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_MAC=%%B"
set "V_RAM="
for /f "skip=1 tokens=* delims=" %%A in ('wmic memorychip get serialnumber 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_RAM=%V_RAM%%%B  "
for /f "skip=1 tokens=* delims=" %%A in ('wmic path win32_bios get SerialNumber 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_BIOSSER=%%B"
for /f "tokens=5" %%A in ('vol C: 2^>nul ^| findstr /i "serial"') do set "V_VOL=%%A"
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Cryptography" /v MachineGuid 2^>nul ^| findstr MachineGuid') do set "V_MGUID=%%A"
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductId 2^>nul ^| findstr ProductId') do set "V_PROD=%%A"
for /f "skip=1 tokens=* delims=" %%A in ('wmic path Win32_NetworkAdapter where "NetConnectionStatus=2" get GUID 2^>nul') do for /f "tokens=* delims=" %%B in ("%%A") do if not "%%B"=="" set "V_NICGUID=%%B"
for /f "tokens=3*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\SystemInformation" /v ComputerHardwareId 2^>nul ^| findstr ComputerHardwareId') do set "V_HWID=%%A"

mode con cols=72 lines=25

cls

echo.
echo %PNK%                        yandere%RST% %DIM%%UND%serials checker%UNX%%RST%
echo.
echo.
echo %DIM% ┌─ %PNK%CPU             %RST% %DIM%─%RST% %WHT%%V_CPU%%RST%
echo %DIM% ┌─ %PNK%RAM             %RST% %DIM%─%RST% %WHT%%V_RAM%%RST%
echo %DIM% ┌─ %PNK%VOLUME SERIAL   %RST% %DIM%─%RST% %WHT%%V_VOL%%RST%
echo %DIM% ┌─ %PNK%PRODUCT ID      %RST% %DIM%─%RST% %WHT%%V_PROD%%RST%
echo %DIM% ┌─ %PNK%NIC GUID        %RST% %DIM%─%RST% %WHT%%V_NICGUID%%RST%
echo %DIM% ┌─ %PNK%MAC ADDRESS     %RST% %DIM%─%RST% %WHT%%V_MAC%%RST%
echo %DIM% ┌─ %PNK%DISK SERIAL     %RST% %DIM%─%RST% %WHT%%V_DISK%%RST%
echo %DIM% ┌─ %PNK%BIOS SERIAL     %RST% %DIM%─%RST% %WHT%%V_BIOSSER%%RST%
echo %DIM% ┌─ %PNK%SMBIOS UUID     %RST% %DIM%─%RST% %WHT%%V_SMBIOS%%RST%
echo %DIM% ┌─ %PNK%MACHINE GUID    %RST% %DIM%─%RST% %WHT%%V_MGUID%%RST%
echo %DIM% ┌─ %PNK%HARDWARE ID     %RST% %DIM%─%RST% %WHT%%V_HWID%%RST%
echo %DIM% ┌─ %PNK%BASEBOARD SERIAL%RST% %DIM%─%RST% %WHT%%V_MOBO%%RST%
echo.
echo.
echo %DIM% ─────────────────────────────────────────────────────────────────────%RST%
echo %DIM%             press any key to refresh       %WHT%CTRL+C%RST% %DIM%to exit%RST%
echo %DIM% ─────────────────────────────────────────────────────────────────────%RST%
echo %DIM%                                    %PNK%https://yandere.online%RST%
echo %DIM%                                    %PNK%https://yandere.online/shop/vannia%RST%
echo %DIM%                                    %DIM%└─ purchase using crypto ^& card%RST%

pause >nul
goto main
