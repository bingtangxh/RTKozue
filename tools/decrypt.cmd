@echo off
cls
goto suspendOrDecryptBitLocker

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
cls
echo.
echo 请选择你要怎么做？
echo [1] 暂停 Suspend BitLocker [2] 恢复 Resume BitLocker
echo [3] 解除 Turn off BitLocker
echo [4] 查询解密进度（百分比是从 100.0^% 到 0.0^% ） Check decrypt process
echo [0] 返回 Back
echo.
echo 输入你的选择，然后按 Enter。
set p=
set /p "p=RTKozue>"
cls
if "%p%"=="1" manage-bde -protectors %systemdrive% -disable
if "%p%"=="2" manage-bde -protectors %systemdrive% -enable
if "%p%"=="3" manage-bde -off %systemdrive%
if "%p%"=="4" goto queryDecryptProcess
if "%p%"=="0" goto end
echo.
pause
cls
goto suspendOrDecryptBitLocker1

:queryDecryptProcess
cls
manage-bde -status %systemdrive%
choice ^
/C 0123456789QWERTYUIOPASDFGHJKLZXCVBNM ^
/M "按除 0 外的任意数字字母键返回 Press any number or letter key except 0 to return" ^
/T 10 /D 0 /N
if errorlevel 2 (goto suspendOrDecryptBitLocker1) else (goto queryDecryptProcess)

:end