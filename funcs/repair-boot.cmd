@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - repair-boot
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:addBootItem
cls
echo        添加启动项目    Add a boot item
echo.
echo    [1] 使用 BCDBOOT 指令添加特定系统
echo        Add a specific OS using BCDBOOT
echo    [2] 使用 BOOTREC 指令来一键修复
echo        Automatically repair using BOOTREC
echo    [0] 返回
echo        Back
echo.
echo 输入你的选择。
echo Type your selection.
echo.
choice /c 120
if errorlevel 3 goto end
if errorlevel 2 goto bootrecQ
if errorlevel 1 goto bcdbootQ

:bcdbootQ
cls
echo 该操作需要考虑的因素较多，还是建议手动操作。
echo There are many factors to consider in this operation,
echo then it is recommended to do it manually.
echo 本程序将执行 BCDBOOT C:\Windows 。确认继续吗？
echo I shall execute BCDBOOT C:\Windows , are you sure to continue?
echo.
choice
if errorlevel 2 goto addBootItem
if errorlevel 1 (
    cls
    bcdboot C:\Windows
    echo.
    pause
    goto addBootItem
)

:bootrecQ
cls
echo 本程序将执行 BOOTREC /REBUILDBCD 。确认继续吗？
echo I shall execute BOOTREC /REBUILDBCD , are you sure to continue?
echo.
choice
if errorlevel 2 goto addBootItem
if errorlevel 1 (
    cls
    bootrec /rebuildbcd
    echo.
    pause
    goto addBootItem
)
:end
if exist "%RTK_WORK%\EnableLinux.txt" del /q "%RTK_WORK%\EnableLinux.txt"
if exist "%RTK_WORK%\disableUAC.reg" del /q "%RTK_WORK%\disableUAC.reg"
if exist "%RTK_WORK%\dpst.txt" del /q "%RTK_WORK%\dpst.txt"
rd "%RTK_WORK%" >nul 2>&1
popd
endlocal
exit /b
