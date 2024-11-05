@echo off
cls
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
for /f "delims=[]. tokens=4" %%A in ('ver') do set build=%%A
echo %build% %PROCESSOR_ARCHITECTURE% %systemdrive%
bcdedit>nul
set /a isAdmin=1-%errorlevel%




