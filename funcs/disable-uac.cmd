@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - disable-uac
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:disableUAC
copy nul "%RTK_WORK%\disableUAC.reg"
@REM echo Windows Registry Editor Version 5.00>>"%RTK_WORK%\disableUAC.reg"
@REM echo.>>"%RTK_WORK%\disableUAC.reg"
@REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]>>"%RTK_WORK%\disableUAC.reg"
@REM echo "EnableLUA"=dword:00000000>>"%RTK_WORK%\disableUAC.reg"
@REM reg import "%RTK_WORK%\disableUAC.reg"
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
echo.
pause
goto end

:end
if exist "%RTK_WORK%\EnableLinux.txt" del /q "%RTK_WORK%\EnableLinux.txt"
if exist "%RTK_WORK%\disableUAC.reg" del /q "%RTK_WORK%\disableUAC.reg"
if exist "%RTK_WORK%\dpst.txt" del /q "%RTK_WORK%\dpst.txt"
rd "%RTK_WORK%" >nul 2>&1
popd
endlocal
exit /b
