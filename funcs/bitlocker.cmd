@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - bitlocker
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:suspendOrDecryptBitLocker
cls
if %systemdrive%==C: (
    echo 视具体情况而定，此功能可能只能在恢复环境中使用，本程序将尝试运行 manage-bde 。
    echo This function might be available in RE only, Depends on whether manage-bde exists.
    manage-bde -status>nul
    if errorlevel 9009 (
        echo.
        echo 你的系统没有 manage-bde ，请在恢复环境中使用本功能。
        echo manage-bde does not exist. You can use this function in RE only.
        echo.
        pause
        goto end
    )
)
:suspendOrDecryptBitLocker1
echo.
echo 请选择你要怎么做？
echo [1] 暂停 Suspend BitLocker [2] 恢复 Resume BitLocker
echo [3] 解除 Turn off BitLocker
echo [4] 查询解密进度（百分比是从 100.0^% 到 0.0^% ） Check decrypt process
echo [0] 退出 Exit
echo.
echo 输入你的选择，然后按 Enter。
set p=
set /p "p=RTKozue>"
if "%p%"=="1" manage-bde -protectors C: -disable
if "%p%"=="2" manage-bde -protectors C: -enable
if "%p%"=="3" manage-bde -off C:
if "%p%"=="4" manage-bde -status C:
if "%p%"=="0" goto end
echo.
pause
cls
goto suspendOrDecryptBitLocker1

:end
if exist "%RTK_WORK%\EnableLinux.txt" del /q "%RTK_WORK%\EnableLinux.txt"
if exist "%RTK_WORK%\disableUAC.reg" del /q "%RTK_WORK%\disableUAC.reg"
if exist "%RTK_WORK%\dpst.txt" del /q "%RTK_WORK%\dpst.txt"
rd "%RTK_WORK%" >nul 2>&1
popd
endlocal
exit /b
