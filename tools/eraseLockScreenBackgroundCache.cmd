@echo off
takeown /f C:\ProgramData\Microsoft\Windows\SystemData /r /d y
icacls C:\ProgramData\Microsoft\Windows\SystemData /grant %computername%\%username%:F /t /c /q
@REM runas /user:%computername%\SYSTEM takeown /f C:\ProgramData\Microsoft\Windows\SystemData /r /d y
@REM explorer C:\ProgramData\Microsoft\Windows\SystemData

takeown /f C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z /r /d y
icacls C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z /grant %computername%\%username%:F /t /c /q
rd /s /q C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z


takeown /f %systemroot%\Web\Screen\img100.jpg
icacls %systemroot%\Web\Screen\img100.jpg /grant %computername%\%username%:F /q

echo.
echo ====================分隔线====================
echo.
echo 请粘贴你想要替换的锁屏壁纸的路径，然后按Enter。有没有双引号都可以。
echo 温馨提示——当你来到这里时通常是管理员身份，不能拖拽。
echo Please paste the path to the Wallpaper you want to use to replace default file.
echo.
set p=
set /p "p=RTKozue>"
for /f "usebackq tokens=*" %%A in ('%p%') do set p=%%~A
if not exist %systemroot%\Web\Screen\img100_original.jpg (
    rename %systemroot%\Web\Screen\img100.jpg img100_original.jpg
    echo.
    echo 原本的 img000.jpg 已被改为 img100_original.jpg 。
    echo 如果带 original 的文件已存在，则后续不会再改名。
    echo Original img000.jpg is backed up.
    echo.
)
copy /y "%p%" %systemroot%\Web\Screen\img100.jpg

pause