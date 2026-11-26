@echo off
set "ospp=C:\Program Files\Microsoft Office\Office15\OSPP.VBS"
if exist "%ospp%" exit /b 0
:ask
set "ospp="
echo Enter the full path to OSPP.VBS, or leave blank to exit.
set /p "ospp=RTKozue>"
if not defined ospp exit /b 1
set "ospp=%ospp:"=%"
if exist "%ospp%" exit /b 0
echo File not found.
goto ask
