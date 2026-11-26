@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - enable-sideload
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:enableLOB
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /v AllowDeploymentInSpecialProfiles /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /v AllowAllTrustedApps /t REG_DWORD /d 1 /f

reg add HKCR\.appx /ve /t REG_SZ /d "appxfile" /f
reg add HKCR\.appxbundle /ve /t REG_SZ /d "appxfile" /f
reg add HKCR\appxfile /ve /t REG_SZ /d "安装APPX喵" /f
reg add HKCR\appxfile\DefaultIcon /ve /t REG_SZ /d "C:\Windows\WinStore\WinStoreUI.dll,0" /f
reg add HKCR\appxfile\shell\install /ve /t REG_SZ /d "安装APPX咩" /f
reg add HKCR\appxfile\shell\install /ve /t REG_SZ /d "\"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\"" /f
@REM 这里的反斜杠后面的双引号是转义字符
reg add HKCR\appxfile\shell\install\command /ve /t REG_SZ /d "\"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe\" -Command \"Add-AppxPackage \\\"%%1\\\"\"" /f


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
