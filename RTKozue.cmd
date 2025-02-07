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
        start echo 本程序为您新打开了一个命令提示符窗口，您可以做其他想要的事情。
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
    if "%s%"=="7" goto importTokens
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
goto mainMenu

:suspendOrDecryptBitLocker
cls
if %systemdrive%==C: (
    echo 视具体情况而定，此功能可能只能在恢复环境中使用，本程序将尝试运行 manage-bde 。
    echo This function might be available in RE only, Depends on whether manage-bde exists.
    manage-bde -status>nul
    if errorlevel 9009 (
        echo.
        echo 你的系统没有 manage-bde ，请在恢复环境中使用本功能。
        echo manage-bde does not exist. You can use this function in RE only.
        echo.
        pause
        goto mainMenu
    )
)
:suspendOrDecryptBitLocker1
echo.
echo 请选择你要怎么做？
echo [1] 暂停 Suspend BitLocker [2] 恢复 Resume BitLocker
echo [3] 解除 Turn off BitLocker
echo [4] 查询解密进度（百分比是从 100.0^% 到 0.0^% ） Check decrypt process
echo [0] 返回 Back
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
    echo KB2919442 ^& KB2919355 is required.
    echo.
    echo 请去别处找，微软官网不给下载 RT 用的任何离线安装的补丁，它说只能从 Windows 更新获取。
    echo It's not available on Microsoft official website, please look for it anywhere else.
    echo.
)
pause

goto mainMenu

:disableUAC
copy nul %tmp%\btxh\disableUAC.reg
@REM echo Windows Registry Editor Version 5.00>>%tmp%\btxh\disableUAC.reg
@REM echo.>>%tmp%\btxh\disableUAC.reg
@REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]>>%tmp%\btxh\disableUAC.reg
@REM echo "EnableLUA"=dword:00000000>>%tmp%\btxh\disableUAC.reg
@REM reg import %tmp%\btxh\disableUAC.reg
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
echo You need a USB drive or a memory card with bootfs partition, while it contains GRUB_bootfs_Delta changes.
echo Now please plug it in, i will copy them to EFI ESP partition automatically.
echo Sorry, simpified Chinese only.
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
) else (
    echo 你的输入不存在，请重试。Not exists, please try again.
    echo.
    pause
    goto grubInstall
)
pause
goto mainMenu

:activate

cls
type .\texts\activate.txt
set p=
set /p "p=RTKozue>"
if "%p%"=="1" goto KMSActWin
if "%p%"=="2" goto convOffice
if "%p%"=="3" goto KMSActOffice
if "%p%"=="4" goto exportTokens
if "%p%"=="5" goto importTokens
if "%p%"=="6" goto convWin
if "%p%"=="7" goto enableLOB
if "%p%"=="8" goto uninsPrevKey
if "%p%"=="0" goto mainMenu
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto activate

:KMSActWin
cls
echo 第一次会出现一个较大的窗口，表示已经重新安装了许可证文件。
echo 窗口可能太大，关掉它即可。
echo A large window is going to appear at first
echo Displaying that tokens files is re-installed. Just close it.
sc start W32Time
w32tm /resync
slmgr.vbs /rilc
echo.
echo 接下来几次都是确定即可。
@REM slmgr /ipk NG4HW-VH26C-733KW-K6F98-J8CK4
@REM 上面这个密钥是给 Li_zip 和宁南客务段的伪 8400RT 用的，不确定是否可用于其它系统
slmgr.vbs /ipk FNFKF-PWTVT-9RC8H-32HB2-JB34X
slmgr.vbs /skms kms.03k.org
slmgr.vbs /ato
echo.
echo 如果提示成功，那么接下来请重启即可生效。
echo.
echo 出错的话，那就重启之后再来一次。
echo If success, reboot. If failed, reboot and try again.
echo.
choice /m "是否立即重新启动？"
if errorlevel 2 goto activate
if errorlevel 1 shutdown -r && goto activate
goto activate

:convOffice
cls
@REM set "params=%*"
@REM cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
@REM 上一行的原理是跑一个 fsutil，如果失败了就运行竖线后面的指令，没失败就不管
@REM pause
fsutil dirty query %systemdrive% 1>nul 2>nul
@REM title MSO2013证书导入工具
@pushd "%~dp0"
if exist "C:\Program Files\Microsoft Office\Office15\OSPP.VBS" (
    @REM RT 默认肯定是 32 位的 Office 2013，所以路径也是死的。万一不是就要求输入。
    set ospp=C:\Program Files\Microsoft Office\Office15\OSPP.VBS
) else (
    echo 请指定一个 OSPP.VBS 的路径，通常在 Office 安装目录。
    echo Type a path to OSPP.VBS.
    echo.
    set ospp=
    set /p "ospp=RTKozue>"
    for /f "usebackq tokens=*" %%A in ('!ospp!') do set ospp=%%~A
    @REM 为什么要 usebackq？因为 for 的括号里有两层双引号又有空格的话可能会闪退。
    if not exist "!ospp!" (
        echo.
        echo 你输入的 OSPP.VBS 路径不存在。
        echo.
        pause
        goto convOffice
    )
)
@REM 到这里的时候，%ospp%应该是不带任何双引号的
for %%A in ("%~dp0ort2oppvl\bin\*.xrm-ms") do cscript //nologo "%ospp%" /inslic:"%%A"
regedit /s "%~dp0ort2oppvl\bin\license.reg"
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
goto activate

:KMSActOffice
cls
cscript //nologo "%ospp%" /act
echo.
pause
goto activate

:exportTokens
cls
echo.
echo 请输入一个用于存放导出文件的位置，然后按Enter。
echo 输入...可返回。
echo Please type a location to save files exported then press Enter. Type ... to turn back.
echo.
set p=
set /p "p=>"
if "%p%"=="..." goto activate
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
goto activate

:importTokens
cls
@rem 就是你想的那样，我就是不想说那个 ACG Video 的简称
type .\texts\importTokens.txt
set p=
set /p "p=>"
if "%p%"=="..." goto mainMenu
if "%p%"=="...." start & goto importTokens
set p=%p:"=%
set p="%p%"
if not exist %p% (
    echo 你输入的路径不存在。
    echo 请重新输入路径。
    echo Not able to find your path. Please try again.
    echo.
    pause
    goto importTokens
)
takeown /f C:\Windows\system32\spp\tokens /r /d y
icacls C:\Windows\system32\spp\tokens /grant %computername%\%username%:F /t /c /q
cls
echo 请选择是否抹除原有 tokens ，一般选 N 。
echo Would you like erasing old tokens folder? Usually N.
rd /s C:\Windows\system32\spp\tokens
xcopy /e /y /i %p% C:\Windows\System32\spp\tokens
echo.
pause
goto mainMenu

:enableLOB
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /v AllowDeploymentInSpecialProfiles /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx /v AllowAllTrustedApps /t REG_DWORD /d 1 /f

reg add HKCR\.appx /ve /t REG_SZ /d "appxfile" /f
reg add HKCR\.appxbundle /ve /t REG_SZ /d "appxfile" /f
reg add HKCR\appxfile /ve /t REG_SZ /d "安装APPX喵" /f
reg add HKCR\appxfile\DefaultIcon /ve /t REG_SZ /d "C:\Windows\WinStore\WinStoreUI.dll,0" /f
reg add HKCR\appxfile\shell\install /ve /t REG_SZ /d "安装APPX咩" /f
reg add HKCR\appxfile\shell\install /ve /t REG_SZ /d "\"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\"" /f
@REM 这里的反斜杠后面的双引号是转义字符
reg add HKCR\appxfile\shell\install\command /ve /t REG_SZ /d "\"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe\" -Command \"Add-AppxPackage \\\"%1\\\"\"" /f


echo.
pause
goto activate

:uninsPrevKey
cls
cscript //nologo "%ospp%" /dstatus | findstr "LICENSE Last ---------------------------------------"
echo 以上是已经安装的密钥，请在下方输入要卸载的密钥后 5 位，例如“R3H4F” （不包括引号），然后按 Enter。
echo 确保输入正确，此处不检测输入是否正确。
echo Installed key(s) are above. Please type the last 5 chars of the key you want to uninstall.
echo Then press Enter, here doesn't verify if the raw input is valid.
echo.
set p=
set /p "p=RTKozue>"
cls
cscript //nologo "%ospp%" /unpkey:%p%
echo.
pause
goto activate

:expressRePart
cls
echo list disk >%temp%\dpst.txt
echo exit >>%temp%\dpst.txt
diskpart /s %temp%\dpst.txt
echo 请输入你要重新分区的硬盘编号，通常是 0 ，但也请通过容量进行辨认。
echo 此处不检测你的输入是否正确，请谨慎。输入 -1 可返回。
echo 这会丢失硬盘上所有的数据！
echo Please type the number of disk which you want to repartition.
echo Usually 0 but you'd better verify if it's right thru the capacity.
echo Here doesn't verify if your raw input is valid. Type -1 to go back.
echo ALL OF THE DATA ON THE DISK WILL BE LOST !!!
echo.
set disk=
set /p "disk=>"
if "%disk%"=="-1" goto mainMenu

cls
wmic diskdrive list brief
echo.
echo 你确认你要重新分区的是 %disk% 吗？请再次输入以确认。输入 -1 可返回。
echo 这会丢失所有的数据！！
echo Are you sure the disk you want to repartition %disk% ?
echo Type the number again to ensure. Type -1 to go back.
echo YOU WILL LOSE ALL OF YOUR DATA ON THE DISK !!!
echo.
set disk1=
set /p "disk1=>"
if "%disk1%"=="-1" goto mainMenu
if not "%disk%"=="%disk1%" (
    echo.
    echo 你的两次输入不一致，请重新输入。
    echo Twice of your raw input does not match. Please try again.
    echo.
    pause
    goto expressRePart
)

cls
echo select disk %disk% >%temp%\dpst.txt
echo clean>>%temp%\dpst.txt
echo convert gpt>>%temp%\dpst.txt

echo 请指定 EFI ESP 分区的大小。如留空，则默认为 250MiB 。
echo 如果要在该分区中放置用于启动 Linux 系统的 bootfs 分区中的文件，就应该大于 250MiB 。
echo 输入大小（不要带单位，应该会是 MB），然后按 Enter。 例如 300MB 就输入 300。输入 -1 可返回。
echo 确保输入正确，此处不检测输入是否正确。
echo Please tell me the size of EFI ESP partition.
echo If give me a null input, then i shall use 250 MiB.
echo Just type a number without the unit like MB or GB, for example "300" for 300 MiB.
echo Then press Enter. Type -1 to go back. Here doesn't verify if the raw input is valid.
echo.
set size=250
set /p "size=>"
if "%size%"=="-1" goto mainMenu

echo create partition efi size=%size%>>%temp%\dpst.txt
echo format quick fs=fat32 label="EFIESP">>%temp%\dpst.txt
echo assign letter='Z'>>%temp%\dpst.txt

:expressRePart1
cls
echo 是否创建 MSR 分区？ Do you want to create MSR partition ?
echo.
echo    [1] 是 Yes     [0] 否 No
echo.
echo 请输入你的选择，然后按 Enter 。输入 -1 可返回。
echo Type your choice then press Enter. Type -1 to go back.
echo.
set s=0
set /p "s=>"
if "%s%"=="1" (
    echo create partition msr size=128 >>%temp%\dpst.txt
    goto expressRePart2
)
if "%s%"=="0" goto expressRePart2
if "%s%"=="-1" goto mainMenu 
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto expressRePart1

:expressRePart2
cls
echo 是否创建恢复环境分区？ Do you want to create WinRE partition ?
echo.
echo    [1] 是 Yes     [0] 否 No
echo.
echo 请输入你的选择，然后按 Enter 。输入 -1 可返回。
echo Type your choice then press Enter. Type -1 to go back.
echo.
set s=0
set /p "s=>"
if "%s%"=="1" (
    echo create partition primary size=310 >>%temp%\dpst.txt
    echo format quick fs=ntfs label="Windows RE tools" >>%temp%\dpst.txt
    echo assign letter="R" >>%temp%\dpst.txt
    echo set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac >>%temp%\dpst.txt
    echo gpt attributes=0x8000000000000001 >>%temp%\dpst.txt
    goto expressRePart3
)
if "%s%"=="0" goto expressRePart3
if "%s%"=="-1" goto mainMenu 
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto expressRePart2

:expressRePart3
echo create partition primary >>%temp%\dpst.txt
echo format quick fs=ntfs override label="Windows" >>%temp%\dpst.txt
echo assign letter='C' >>%temp%\dpst.txt
echo exit>>%temp%\dpst.txt

diskpart /s %temp%\dpst.txt

echo.
echo 重新分区完成。 Repartition complete.
echo 所有数据已经丢失。 All of the data is lost.
echo.
pause
goto mainMenu

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
if "%p%"=="" goto mainMenu
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
if "%s%"=="1" set backupType=/Capture-Image&goto backup2
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
goto mainMenu

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
echo 留空可返回，请勿输入双引号。
echo Left blank to go back. Quotes are not allowed.
echo.
set imageFile=
set /p "imageFile=>"
if "%imageFile%"=="" goto mainMenu
set imageFile=/imageFile:"%imageFile:"=%"
if not exist %imageFile% (
    echo 你输入的路径不存在。
    echo The path you typed does not exist.
    echo.
    pause
    goto apply-image
)
if "%imageFile:~-4,3%"=="swm" (goto swmFile2) else set swmFile=
goto ai1

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
goto mainMenu










:addBootItem






:add-driver



cls
echo 前面的区域以后再来探索吧？
echo How about we explore the area ahead of us later?
echo.
pause
goto mainMenu




:convWin
cls
echo 请将林檎提供的 RT_8.1_LOB_APPX 文件夹准备好。
echo 本程序将自动为您替换。
echo.
echo 请输入该文件夹的路径，无需添加任何双引号（哪怕有空格）留空可返回。
echo Please type the path to RT_8.1_LOB_APPX folder,
echo Not necessary to contain quotes, no matter if any spaces exists.
echo Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p%"=="" goto activate
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
goto activate





:exit

:end
