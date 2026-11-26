@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - uninstall-office-key
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

call "%RTK_ROOT%common\find-office.cmd"
if errorlevel 1 goto end

:uninsPrevKey
cls
cscript //nologo "%ospp%" /dstatus | findstr "LICENSE Last ---------------------------------------"
echo 以上是已经安装的密钥，请在下方输入要卸载的密钥后 5 位，例如“R3H4F” （不包括引号），然后按 Enter。
echo 确保输入正确，此处不检测输入是否正确。
echo Installed key(s) are above. Please type the last 5 chars of the key you want to uninstall.
echo Then press Enter, here doesn't verify if the raw input is valid.
echo.
set p=
set /p "p=RTKozue>"
cls
cscript //nologo "%ospp%" /unpkey:%p%
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
