@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - import-tokens
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:importTokens
cls
@rem 就是你想的那样，我就是不想说那个 ACG Video 的简称
type .\texts\importTokens.txt
set p=
set /p "p=>"
if "%p%"=="..." goto end
if "%p%"=="...." (
    start "" cmd.exe
    goto importTokens
)
set p=%p:"=%
set p="%p%"
if not exist %p% (
    echo 你输入的路径不存在。
    echo 请重新输入路径。
    echo Not able to find your path. Please try again.
    echo.
    pause
    goto importTokens
)
takeown /f C:\Windows\system32\spp\tokens /r /d y
icacls C:\Windows\system32\spp\tokens /grant %computername%\%username%:F /t /c /q
cls
echo 请选择是否抹除原有 tokens ，一般选 N 。
echo Would you like erasing old tokens folder? Usually N.
rd /s C:\Windows\system32\spp\tokens
xcopy /e /y /i %p% C:\Windows\System32\spp\tokens
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
