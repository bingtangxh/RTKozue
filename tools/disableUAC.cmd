@echo off
copy nul %tmp%\btxh\disableUAC.reg
@REM echo Windows Registry Editor Version 5.00>>%tmp%\btxh\disableUAC.reg
@REM echo.>>%tmp%\btxh\disableUAC.reg
@REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]>>%tmp%\btxh\disableUAC.reg
@REM echo "EnableLUA"=dword:00000000>>%tmp%\btxh\disableUAC.reg
@REM reg import %tmp%\btxh\disableUAC.reg
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
echo.
pause