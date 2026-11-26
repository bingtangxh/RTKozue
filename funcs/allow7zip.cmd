@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - allow7zip
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:allow7-zip
cls
copy nul allow7z.txt
echo HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Directory\shellex\DragDropHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Drive\shellex\DragDropHandlers [1 6 8 12 17]>>allow7z.txt
regini allow7z.txt
start C:\"Program Files"\7-zip\7zFM.exe
echo.
echo 现在你再试一下， “添加 7-zip 到右键菜单” 应该可以勾上了。
echo Now you can try for another time,
echo "Add 7-zip to context menu" should be able to be checked.
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
