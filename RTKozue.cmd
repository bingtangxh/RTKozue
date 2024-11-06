@echo off
cls

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
title RTKozue by Bingtangxh Version 0.1
@REM mode con: cols=100 lines=25
doskey 说=echo $*
doskey 空行=echo.
cd /d %~dp0
for /f "delims=[]. tokens=4" %%A in ('ver') do set build=%%A
bcdedit>nul
if errorlevel 1 (
    echo 本程序需要管理员权限才能运行。
    echo.
    echo 本程序将尝试自行进行提升权限。
    echo This script requires Administartors permission and then will try to elevate.
    if not exist "%temp%\btxh" mkdir "%temp%\btxh"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\btxh\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\btxh\getadmin.vbs"
    "%temp%\btxh\getadmin.vbs"
    del /f /q "%temp%\btxh\getadmin.vbs" >nul
    exit /B
)

:mainMenu
cls
echo %build% %PROCESSOR_ARCHITECTURE% %systemdrive%
if %systemdrive%==C: (
    type .\texts\mainMenu.txt
) else (
    if %systemdrive%==X: (
        type .\texts\mainMenu_RE.txt
    ) else (
        echo 当前系统盘不是 C: 或 X: ，无法找到对应的菜单。
        echo Current System Drive letter is neither C: nor X:
        echo.
        echo 本程序将立即退出。
        echo This script will terminate immediately.
        echo.
        pause
        goto exit
    )
)
if errorlevel 1 echo 显示菜单文本文档失败。请检查%cd%\texts文件夹是否存在。Failed to find menu text file.
echo.
set s=
set /p "s=RTKozue>"
if %systemdrive%==C: (
    rem 这里显然不需要用感叹号表示延迟变量代入
    if "%s%"=="1" goto allow7-zip
    if "%s%"=="2" goto activate
    if "%s%"=="3" goto eraseLockScreenBackgroundCache
    if "%s%"=="4" goto switchBootManager
    if "%s%"=="5" goto suspendOrDecryptBitLocker
    if "%s%"=="6" goto addPowerButton
    if "%s%"=="7" goto disableUAC
    if "%s%"=="0" goto exit
)
if %systemdrive%==X: (
    rem 这里显然不需要用感叹号表示延迟变量代入
    if "%s%"=="1" goto expressRePart
    if "%s%"=="2" goto backup
    if "%s%"=="3" goto apply-image
    if "%s%"=="4" goto suspendOrDecryptBitLocker
    if "%s%"=="5" goto addBootItem
    if "%s%"=="6" goto add-driver
    if "%s%"=="0" goto exit
)
echo.
echo 您的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto mainMenu

:allow7-zip
echo.
echo 进不去！怎么想我都进不去吧！
echo 来个好心人教我怎么用 TrustedInstaller 运行 cmd 或者 7zFM
echo 或者怎么改所有者和权限也行
echo.
echo HKCR\*\shellex\ContextMenuHandlers
echo HKCR\Directory\shellex\ContextMenuHandlers
echo HKCR\Folder\shellex\ContextMenuHandlers
echo HKCR\Directory\shellex\DragDropHandlers
echo HKCR\Drive\shellex\DragDropHandlers
echo 也可以手动操作，把上面这几个的所有者（Owner）改成 Administrators 群组
echo 再让 Administrators 群组享有完全控制权限
echo 再用管理员身份跑一个 7zFM.exe ，在那里打开选项→设置
echo 你会发现 “添加 7-zip 到右键菜单” 可以勾上了。
echo.
pause
goto mainMenu



:eraseLockScreenBackgroundCache
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
goto mainMenu

:switchBootManager
for /f %%A in ('powershell -Command Confirm-SecureBootUEFI') do set isSB=%%A
if %isSB%==True (
    echo.
    echo 你的系统没有禁用 Secure Boot。
    echo 你需要使用 Tegra_Jailbreak_USB_v1.6 和一个优盘来越狱，才能启动 Linux 系统。
    echo.
    if %build%==9600 (
        systeminfo | find "修补程序"
        systeminfo | find "Hotfix(s):"
        echo.
        echo 你的系统安装了如上所示的补丁。
        echo 如果装了任何补丁（哪怕就一个都会导致有失败的可能）
        echo 那么你需要重装原版系统，再进行越狱。
        echo 如不想丢失当前系统，可以在恢复环境中运行本程序，并进行备份和恢复。
        echo.
        pause
        goto mainMenu
    )
)
set CurrStat=0
bcdedit
if errorlevel 1 (
	set failed=1
	goto report
) else set failed=0
echo sel disk 0 >%tmp%\btxh\EnableLinux.txt
echo sel par 1 >>%tmp%\btxh\EnableLinux.txt
echo assign letter='Z'>>%tmp%\btxh\EnableLinux.txt
echo exit>>%tmp%\btxh\EnableLinux.txt
diskpart /s %tmp%\btxh\EnableLinux.txt

@REM cd /d Z:\EFI\Microsoft\Boot
if not exist Z:\grub.cfg goto grubInstall
if exist Z:\EFI\Microsoft\Boot\bootmgfw.efi (del Z:\EFI\Microsoft\Boot\bootmgfw.efi) else copy Z:\EFI\Microsoft\Boot\boutmgfw.efi Z:\EFI\Microsoft\Boot\bootmgfw.efi
if errorlevel 1 (set failed=1) else set failed=0
if not exist Z:\EFI\Microsoft\Boot\bootmgfw.efi (set CurrStat=1) else set CurrStat=0
@REM if %CurrStat%==1 (bcdedit /bootsequence {9543a28c-8ee3-11ef-ae81-bd3afa2fa51d} /addfirst) else bcdedit /bootsequence {9543a28f-8ee3-11ef-ae81-bd3afa2fa51d} /addfirst
echo sel disk 0 >%tmp%\btxh\EnableLinux.txt
echo sel par 1 >>%tmp%\btxh\EnableLinux.txt
echo remove>>%tmp%\btxh\EnableLinux.txt
echo exit>>%tmp%\btxh\EnableLinux.txt
diskpart /s %tmp%\btxh\EnableLinux.txt
del %tmp%\btxh\EnableLinux.txt
:report
@echo.
@if %failed%==1 (echo 修改失败，请以管理员身份运行。) else (
	@if %CurrStat%==1 (echo ===============已启用GRUB。===============) else echo ===============已还原bootmgfw.efi。===============
)
@echo.
@timeout /t 5
pause
goto mainMenu

:suspendOrDecryptBitLocker
cls
if %systemdrive%==C: (
    echo 视具体情况而定，此功能可能只能在恢复环境中使用，本程序将尝试运行 manage-bde 。
    manage-bde -status>nul
    if errorlevel 9009 (
        echo.
        echo 你的系统没有 manage-bde ，请在恢复环境中使用本功能。
        echo.
        pause
        goto mainMenu
    )
)
:suspendOrDecryptBitLocker1
echo.
echo 请选择你要怎么做？
echo [1] 暂停 BitLocker [2] 恢复 BitLocker
echo [3] 解除 BitLocker [4] 查询解密进度（百分比是从 100.0^% 到 0.0^% ）
echo [0] 返回
echo.
echo 输入你的选择，然后按 Enter。
set p=
set /p "p=RTKozue>"
if "%p%"=="1" manage-bde -pause %systemdrive%
if "%p%"=="2" manage-bde -resume %systemdrive%
if "%p%"=="3" manage-bde -off %systemdrive%
if "%p%"=="4" manage-bde -status %systemdrive%
if "%p%"=="0" goto mainMenu
echo.
pause
cls
goto suspendOrDecryptBitLocker1








:addPowerButton
set isPowerUpdate=0
systeminfo | find "KB2919355" && set isPowerUpdate=1
if %isPowerUpdate%==1 (
    echo.
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher" /v "Launcher_ShowPowerButtonOnStartScreen" /t REG_DWORD /d 1 /f
    echo.
) else (
    echo 你的系统没有安装 KB2919355。
    echo 你需要先安装 KB2919442 和 KB2919355。
    echo.
    echo 请去别处找，微软官网不给下载 RT 用的任何离线安装的补丁，它说只能从 Windows 更新获取。
    echo.
)
pause

goto mainMenu

:disableUAC
copy nul %tmp%\btxh\disableUAC.reg
echo Windows Registry Editor Version 5.00>>%tmp%\btxh\disableUAC.reg
echo.>>%tmp%\btxh\disableUAC.reg
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]>>%tmp%\btxh\disableUAC.reg
"EnableLUA"=dword:00000000>>%tmp%\btxh\disableUAC.reg
reg import %tmp%\btxh\disableUAC.reg
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
echo.
pause
goto mainMenu

:grubInstall
cls
echo 没有检测到 grub.cfg。
echo 你需要一个带有 bootfs 分区的优盘或存储卡，并将 GRUB_bootfs_Delta 的文件全部替换进 bootfs 分区的优盘或存储卡
echo 并将 bootfs 的文件全部复制进 EFI ESP 分区。
echo 现在，请插入含有 bootfs 分区并且添加了 GRUB_bootfs_Delta 的优盘或存储卡，本程序将为您自动复制到 EFI ESP 分区。
echo.
for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y) do if exist %%A:NUL fsutil fsinfo drivetype %%A:
@REM 为什么没有 Z ？因为 Z 用给 EFI ESP 分区了。

echo.
echo 请输入你的选择，然后按Enter，输入 back 可返回。（只输入字母，不输入冒号）
echo.
set p=
set /p "RTKozue=>"
if "%p%"=="back" goto mainMenu
if exist "%p%:" (
    cls
    copy Z:\efi\boot\bootarm.efi Z:\efi\boot\bootarm_original.efi
    echo 如果提示是否覆盖 bootarm.efi，那么请输入 Y 确认。如果是别的文件就输入 N。
    xcopy %p%:\* Z:\ /-Y /C /E /Q /I
) else (
    echo 你的输入不存在，请重试。
    echo.
    pause
    goto grubInstall
)
pause
goto mainMenu
:exit
:end