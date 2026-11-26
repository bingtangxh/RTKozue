@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - backup
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:backup

:backup0
cls
echo 本程序仅能备份 C: 中的系统。
echo 请在下方输入你要保存到的文件路径，留空可返回。
echo 此处不检测你的输入是否正确，请谨慎。
echo 尽量设置为一个盘的根目录，否则要是打错了就找不到路径了。
echo I can only make backup from the OS in drive C:
echo Please type the target file path below. Left blank to go back.
echo Here doesn't verify if your raw input is valid.
echo You may put the file into a root directory
echo in order to reduce the risk of fail to find the path.
echo.
set p=
set /p "p=>"
if "%p%"=="" goto end
set p="%p:"=%"
goto backup1

:backup1
cls
echo 请选择这是哪种备份。
echo.
echo    [1] 初始备份   /Capture-Image
echo    [2] 增量备份   /Append-Image
echo    [0] 返回       Go Back
echo.
echo 输入你的选择，然后按 Enter。
echo Type your selection and then press Enter.
echo.
set /p "s=>"
if "%s%"=="1" (
    set backupType=/Capture-Image
    goto backup2
)
if "%s%"=="2" (
    set backupType=/Append-Image
    echo.
    echo 请确保存放镜像文件的分区容量充足，否则可能会损坏已有的镜像文件。
    echo Make sure that the partition which saves the image file has enough free space.
    echo Or you will destory the existing image file.
    echo.
    pause
    goto backup2
)
if "%s%"=="0" goto backup0
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto backup1

:backup2
cls
echo 请指定本次备份的名称，这个不能省略，不是文件名。请勿输入双引号。
echo 留空则会返回。
echo Please tell me about the name of this backup. Could not be blank.
echo Quotes are not allowed. Left blank will bring you back.
echo.
set name=
set /p "name=>"
set name=%name:"=%"
if "%name%"=="" (
    goto backup1
)
set name=/Name:"%name:"=%"
goto backup3

:backup3
cls
echo 请指定本次备份的解释。可以留空。请勿输入双引号。输入 /back 可返回。
echo Please tell me about the description. Blank is allowed.
echo Quotes are not allowed. Type /back to go back.
echo.
set description=
set /p "description=>"
if "%description%"=="/back" goto backup1
set description=%description:"=%"
if not "%description%"=="" (
    set description=/Description:"%description%"
) else (
    set description=
)
goto backup4

:backup4
cls
echo 请确认你的备份。 Please take a look.
echo.
echo %backupType%
echo %p%
echo %name%
echo %description%
echo.
choice /m "开始备份吗？ Start now?"
if errorlevel 2 goto backup3
if errorlevel 1 goto backup5

:backup5
cls
dism %backupType% /ImageFile:%p% /CaptureDir:C:\ %name% %description%
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
