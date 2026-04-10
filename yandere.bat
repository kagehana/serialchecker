@echo off

if "%~1"=="run" goto fetch

reg add "HKCU\Console" /v FaceName /t REG_SZ /d "Consolas" /f >nul 2>&1
reg add "HKCU\Console" /v FontSize /t REG_DWORD /d 0x000e0000 /f >nul 2>&1
reg add "HKCU\Console" /v FontWeight /t REG_DWORD /d 400 /f >nul 2>&1
reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
start " " cmd /c "%~f0" run
exit

:fetch
del "%TEMP%\yandere_latest.bat" >nul 2>&1
curl -s -L "https://raw.githubusercontent.com/kagehana/serialchecker/refs/heads/main/src/source.bat" | more /P > "%TEMP%\yandere_latest.bat"
if not exist "%TEMP%\yandere_latest.bat" goto fail
for %%A in ("%TEMP%\yandere_latest.bat") do if %%~zA==0 goto fail
cmd /c "%TEMP%\yandere_latest.bat" run
del "%TEMP%\yandere_latest.bat" >nul 2>&1
exit

:fail
echo.
echo  failed to fetch latest version.
echo  check your internet connection or try again.
echo.
pause
exit
