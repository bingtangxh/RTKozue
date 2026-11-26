@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - convert-windows
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:convWin
cls
echo 请将林檎提供的 RT_8.1_LOB_APPX 文件夹准备好。
echo 本程序将自动为您替换。
echo.
echo 请输入该文件夹的路径，无需添加任何双引号（哪怕有空格）留空可退出。
echo Please type the path to RT_8.1_LOB_APPX folder,
echo Not necessary to contain quotes, no matter if any spaces exists.
echo Left blank to exit.
echo.
set p=
set /p "p=>"
set p=%p:"=%
@echo off
if "%p%"=="" goto end
if not exist "%p%\nul" (
    echo.
    echo 你输入的路径不存在。
    echo The path does not exist.
    echo 请重新输入。
    echo Please try again.
    echo.
    pause
    goto convWin
)
cls
takeown /f C:\Windows\system32\spp\tokens /r /d y
icacls C:\Windows\system32\spp\tokens /grant %computername%\%username%:F /t /c /q
takeown /f C:\windows\Branding\Basebrd /r /d y
icacls C:\windows\Branding\Basebrd /grant %computername%\%username%:F /t /c /q

ren C:\windows\Branding\Basebrd\basebrd.dll basebrd.old
copy "%p%\basebrd.dll" C:\windows\Branding\Basebrd\basebrd.dll
move C:\Windows\system32\spp\tokens tokens_old
xcopy /e /y /i "%p%\tokens" C:\Windows\system32\spp\tokens
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
