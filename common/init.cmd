@echo off
rem Called inside the feature script's setlocal scope.
for %%A in ("%~dp0..") do set "RTK_ROOT=%%~fA\"
bcdedit >nul 2>&1
if errorlevel 1 (
    echo Administrator permission required. Requesting elevation...
    cscript //nologo "%~dp0elevate.vbs" "%~1"
    if errorlevel 1 pause
    exit /b 1
)
for /f "delims=[]. tokens=4" %%A in ('ver') do set "build=%%A"
set "RTK_WORK=%TEMP%\RTKozue-%RANDOM%-%RANDOM%"
md "%RTK_WORK%" >nul 2>&1
if not exist "%RTK_WORK%\" (
    echo Cannot create temporary directory.
    pause
    exit /b 1
)
exit /b 0
