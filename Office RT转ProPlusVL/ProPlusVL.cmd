@echo off
cls
setlocal EnableExtensions
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
pause
title MSO2013证书导入工具
pushd "%~dp0"
for %%i in ("%~dp0bin\*.xrm-ms") do cscript //nologo "%~dp0bin\ospp.vbs" /inslic:"%%i"
regedit /s "%~dp0bin\license.reg"
cscript //nologo "%~dp0bin\ospp.vbs" /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT
echo.
pause
exit
