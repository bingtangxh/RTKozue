@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - export-tokens
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:exportTokens
cls
echo.
echo 请输入一个用于存放导出文件的位置，然后按Enter。
echo 输入...可退出。
echo Please type a location to save files exported then press Enter. Type ... to exit.
echo.
set p=
set /p "p=>"
if "%p%"=="..." goto end
set p=%p:"=%
set p="%p%"
@rem 保证有且只有一层双引号
if not exist %p% md %p%
if not exist %p% (
    echo 你输入的路径不存在。
    echo 已经尝试新建此文件夹，但尝试后仍不存在，可能是失败了。
    echo 请重新输入路径。
    echo Not able to find or make your path. Please try again.
    echo.
    pause
    goto exportTokens
)
xcopy /i /e C:\Windows\System32\spp\tokens %p%\tokens
@rem 看起来 %p% 最外层有双引号，但是双引号外面再加其他字符，还是可以被认定为一个路径的
@rem 比如 "D:\tokens9200"\tokens 是可以的
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" %p%\9200CurrentVersion.reg
FOR /F "tokens=1-3" %%A IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DigitalProductId') DO @IF /I %%A==DigitalProductId DPIDDC_ARM /VENTI %%C >> %p%\ProductKey.txt

echo 已完成，请自行查看目标文件夹。
echo Done. You can explore the goal folder manually.
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
