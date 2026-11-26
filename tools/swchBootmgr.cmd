@echo off
cls
for /f %%A in ('powershell -Command Confirm-SecureBootUEFI') do set isSB=%%A
if %isSB%==True (
    echo.
    echo 你的系统没有禁用 Secure Boot。
    echo 你需要使用 Tegra_Jailbreak_USB_v1.6 和一个优盘来越狱，才能启动其它的操作系统。
    echo You need to use a portable disk and Tegra_Jailbreak_USB_v1.6
    echo in order to disable f**king Secure Boot before you can run other OSs.
    echo.
    if %build%==9600 (
        systeminfo | find "修补程序"
        systeminfo | find "Hotfix(s):"
        echo.
        echo 你的系统安装了如上所示的补丁。
        echo 如果装了任何补丁，就很可能无法越狱（哪怕就一个都会导致有失败的可能）
        echo 那么你需要重装原版系统，再进行越狱。
        echo 如不想丢失当前系统，可以在恢复环境中运行本程序，并进行备份和恢复。
        echo Any updates are installed, we cannot guarantee for success.
        echo Jailbreak is likely to be failed.
        echo You need to re-install a new RTM OS copy before try jailbreaking.
        echo If you wouldn't like to lose the current OS, you can run me in RE and then make a backup.
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
echo assign letter='B'>>%tmp%\btxh\EnableLinux.txt
echo exit>>%tmp%\btxh\EnableLinux.txt
diskpart /s %tmp%\btxh\EnableLinux.txt

@REM cd /d B:\EFI\Microsoft\Boot
if not exist B:\grub.cfg goto grubInstall
:grubInstallBack
if exist B:\EFI\Microsoft\Boot\bootmgfw.efi (del B:\EFI\Microsoft\Boot\bootmgfw.efi) else copy B:\EFI\Microsoft\Boot\boutmgfw.efi B:\EFI\Microsoft\Boot\bootmgfw.efi
if errorlevel 1 (set failed=1) else set failed=0
if not exist B:\EFI\Microsoft\Boot\bootmgfw.efi (set CurrStat=1) else set CurrStat=0
@REM if %CurrStat%==1 (bcdedit /bootsequence {9543a28c-8ee3-11ef-ae81-bd3afa2fa51d} /addfirst) else bcdedit /bootsequence {9543a28f-8ee3-11ef-ae81-bd3afa2fa51d} /addfirst
echo sel disk 0 >%tmp%\btxh\EnableLinux.txt
echo sel par 1 >>%tmp%\btxh\EnableLinux.txt
echo remove>>%tmp%\btxh\EnableLinux.txt
echo exit>>%tmp%\btxh\EnableLinux.txt
diskpart /s %tmp%\btxh\EnableLinux.txt
del %tmp%\btxh\EnableLinux.txt
:report
@echo.
@if %failed%==1 (echo 修改失败，请以管理员身份运行。Admin Permission required.) else (
	@if %CurrStat%==1 (echo ===============已启用GRUB。 GRUB enabled.===============) else echo ===============已还原bootmgfw.efi。 bootmgfw.efi is recovered.===============
)
@echo.
@timeout /t 5
pause
goto end

:grubInstall
cls
echo 没有检测到 grub.cfg。
echo 你需要一个带有 bootfs 分区的优盘或存储卡，并将 GRUB_bootfs_Delta 的文件全部替换进 bootfs 分区的优盘或存储卡
echo 并将 bootfs 的文件全部复制进 EFI ESP 分区。
echo 现在，请插入含有 bootfs 分区并且添加了 GRUB_bootfs_Delta 的优盘或存储卡，本程序将为您自动复制到 EFI ESP 分区。
echo You need a USB drive or a memory card with bootfs partition, while it contains GRUB_bootfs_Delta changes.
echo Now please plug it in, i will copy them to EFI ESP partition automatically.
echo GRUB_bootfs_Delta is about bootarm.efi, grub.cfg, unicode.pf2, theme folder and related files.
echo.
pause
cls
for %%A in (A C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%A:NUL fsutil fsinfo drivetype %%A:
@REM 为什么没有 B ？因为 B 用给 EFI ESP 分区了。

echo.
echo 请输入你的选择，然后按Enter，输入 back 可返回。（只输入字母，不输入冒号）
echo Choice a volume letter and press Enter. Just a letter without the colon. Type "back" to turn back.
echo.
set p=
set /p "RTKozue=>"
if "%p%"=="back" goto mainMenu
if exist "%p%:" (
    cls
    copy B:\efi\boot\bootarm.efi B:\efi\boot\bootarm_original.efi
    echo 如果提示是否覆盖 bootarm.efi，那么请输入 Y 确认。如果是别的文件就输入 N。
    echo Type Y if it asks if bootarm.efi is to be replaced. Type N for anything else.
    xcopy %p%:\* B:\ /-Y /C /E /Q /I
    goto grubInstallBack
) else (
    echo 你的输入不存在，请重试。Not exists, please try again.
    echo.
    pause
    goto grubInstall
)
rem 按理说不太可能来到这里

:end