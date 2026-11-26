@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - apply-image
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:apply-image
cls
echo 请先指定镜像文件的路径。本程序会检测文件是否存在。
echo Please tell me about the path to image file.
echo I will check if it exists.
echo.
echo 如果你用的是 swm 文件，那么这里你先输入第一个文件。
echo 本程序检测到你输入的最后三个字符是 swm 就会询问其余文件。
echo If you want to use swm files, you can type the first file here.
echo I will ask you for other files if the last 3 chars are "swm" .
echo.
echo 留空可退出，请勿输入双引号。
echo Left blank to exit. Quotes are not allowed.
echo.
set imageFile=
set /p "imageFile=>"
if "%imageFile%"=="" goto end
set "imagePath=%imageFile:"=%"
if not exist "%imagePath%" (
    echo 你输入的路径不存在。
    echo The path you typed does not exist.
    echo.
    pause
    goto apply-image
)
set imageFile=/imageFile:"%imagePath%"
if /i "%imagePath:~-4%"==".swm" (goto swmFile2) else set swmFile=
goto applyDir

:swmFile
rem 应该是写重复了，万一要用先留着不删，应该是用不着了
cls
echo 请输入第一个 swm 文件的路径。
echo Please type the path to the first swm file.
echo.
echo 留空可返回，请勿输入双引号。无需使用双引号把路径括起来，哪怕有空格。
echo Left blank to go back. Quotes are not allowed.
echo Although the path contains any spaces, you don't need to use quotes.
echo.
set p=
set /p "p=>"
if not exist %p% (
    echo 你输入的路径不存在。
    echo The path you typed does not exist.
    echo.
    pause
    goto swmFile
)
set imageFile=/imageFile:"%p:"=%"
goto swmFile2

:swmFile2
rem https://learn.microsoft.com/zh-cn/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14
cls
echo 请输入其余 swm 分卷文件的路径。
echo Please type the paths to other swm files.
echo.
echo 请用星号（ Shift + 8 ）来指定多个文件。
echo Use * ( Shift + 8 ) to express multi files.
echo.
echo 例如： For example:
echo D:\sources\install*.swm
echo.
echo 留空可返回，请勿输入双引号。此处不检测输入是否有效，
echo 如果设置的第一个文件有效而此处的无效，命令会开始正常但是中途出错。
echo Left blank to go back. Quotes are not allowed.
echo Although the path contains any spaces, you don't need to use quotes.
echo Here does not verify if file exists.
echo If the first path is correct while here wrong,
echo the command would start normally but terminates unexpectedly.
echo.
set p=
set /p "p=>"
if "%p%"=="" goto swmFile
set swmFile=/swmFile:"%p:"=%"
goto applyDir

:applyDir
cls
echo 请指定应用镜像的位置，一般是 C:\ 。
echo 留空会返回到指定镜像文件的界面。
echo Please tell me about the dir to be applied.
echo Usually C:\. Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p%"=="" goto apply-image
if not exist "%p%" (
    echo 你输入的路径不存在。
    echo The path does not exist.
    echo.
    pause
    goto applyDir
)
set applyDir=/applyDir:"%p%"
goto index

:index
cls
echo 请输入要释放的镜像的索引。一般是 1 。
echo 如果你不确定，你可以输入 Get-ImageInfo 来查询，不区分大小写。
echo Please type the index number, usually 1.
echo If you aren't sure, you can type Get-ImageInfo. Case insensitive.
echo.
echo 留空可返回。 Left blank to go back.
set s=
set /p "s=>"
set s=%s:"=%
if "%s%"=="" goto applyDir
if /i "%s%"=="Get-ImageInfo" (
    cls
    dism /Get-ImageInfo %imageFile%
    echo.
    pause
    goto index
)
set index=/index:%s%
goto ai

:ai
cls
echo 请确认你的释放。
echo %imageFile%
echo %swmFile%
echo %index% %applyDir%
echo.
choice /m "开始释放吗？ Start now?"
if errorlevel 2 goto index
if errorlevel 1 goto ai1

:ai1
cls
dism /apply-image %imageFile% %swmFile% %index% %applyDir%
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
