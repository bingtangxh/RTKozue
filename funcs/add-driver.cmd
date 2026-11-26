@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - add-driver
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:add-driver
cls
echo 请输入要添加的驱动所在的文件夹路径，然后按 Enter 。
echo 本程序会使用 /recurse 参数，也就是添加所有子文件夹的可用驱动。
echo Please type the path to the driver.
echo I will use switch /recurse in order to add all sub-folders.
echo 留空可返回。 Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p%"=="" goto end
if not exist "%p%" (
    echo.
    echo 你输入的路径不存在。
    echo The path does not exist.
    echo 请重新输入。
    echo Please try again.
    echo.
    pause
    goto add-driver
)
set driver="%p%"

:add-driver2
cls
echo 请指定系统所在的路径，一般是 C:\Windows 。
echo Please tell me about the path to offline Windows image.
echo Usually C:\Windows .
echo 留空可返回。 Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p:~-1%"=="\" set p=%p:~0,-1%
if "%p%"=="" goto add-driver
if not exist "%p%\NUL" (
    echo.
    echo 你输入的路径不存在。
    echo The path does not exist.
    echo 请重新输入。
    echo Please try again.
    echo.
    pause
    goto add-driver2
)
set image="%p%"
cls
dism /image:%image% /add-driver /driver:%driver% /recurse
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
