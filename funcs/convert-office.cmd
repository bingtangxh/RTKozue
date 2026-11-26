@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - convert-office
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

call "%RTK_ROOT%common\find-office.cmd"
if errorlevel 1 goto end

:convOffice
cls
if not exist "%RTK_ROOT%ort2oppvl\nul" (
    echo.
    echo 本程序所在目录下没有找到 ort2oppvl 文件夹。
    echo 你需要自行将 bin 文件夹重命名为 ort2oppvl 放在本程序所在目录
    echo 然后再来使用此功能。
    echo I couldn't find ort2oppvl folder in current directory.
    echo You need to rename folder named "bin" to "ort2oppvl"
    echo then put it in current directory and try this func again.
    echo.
    pause
    goto end
)
for %%A in ("%RTK_ROOT%ort2oppvl\*.xrm-ms") do cscript //nologo "%ospp%" /inslic:"%%A"
regedit /s "%RTK_ROOT%ort2oppvl\license.reg"
cscript //nologo "%ospp%" /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT
cscript //nologo "%ospp%" /sethst:kms.03k.org
cscript //nologo "%ospp%" /act
echo.
echo 应该已经完成，请查看上文，确认是否已成功。
echo You can query if succeed by reading sentences above.
echo.
pause
cls
cscript //nologo "%ospp%" /dstatus
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
