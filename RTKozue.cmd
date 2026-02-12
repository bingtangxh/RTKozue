@echo off
cls

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
title RTKozue by Bingtangxh Version 0.4.0
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
for /f "tokens=3" %%A IN ('reg query "HKCU\Control Panel\Desktop" /v PreferredUILanguages ^| find "PreferredUILanguages"') DO (
    @for /f "delims=-" %%B IN ("%%A") DO @if /i not %%B==zh (set Chinese=0) else set Chinese=1
)
if not DEFINED Chinese set Chinese=0

:mainMenu
cls
echo %build% %PROCESSOR_ARCHITECTURE% %systemdrive%
if not %PROCESSOR_ARCHITECTURE%==ARM (
    if %Chinese%==1 (
        echo 当前系统体系架构不是 ARM ，一些功能可能会造成破坏，请慎用。
    ) else (
        echo Current architecture is not ARM, Some features might be disruptive, use with caution.
    )
)
if %systemdrive%==C: (
    if %Chinese%==1 (type .\texts\mainMenu.txt) else (type .\texts\mainMenu_eng.txt)
) else (
    if %systemdrive%==X: (
        if %Chinese%==1 (type .\texts\mainMenu_RE.txt) else (type .\texts\mainMenu_REeng.txt)
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
    if "%s%"=="2" goto activate
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
    if "%s%"=="9" start && goto mainMenu
    if "%s%"=="0" goto exit
)
echo.
echo 您的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto mainMenu


:activate

cls
if %Chinese%==1 (type .\texts\activate.txt) else (type .\texts\activate_eng.txt)
set p=
set /p "p=RTKozue>"
if "%p%"=="4" goto exportTokens
if "%p%"=="5" goto importTokens
if "%p%"=="6" goto convWin
if "%p%"=="0" goto mainMenu
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
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
cls
echo        添加启动项目    Add a boot item
echo.
echo    [1] 使用 BCDBOOT 指令添加特定系统
echo        Add a specific OS using BCDBOOT
echo    [2] 使用 BOOTREC 指令来一键修复
echo        Automatically repair using BOOTREC
echo    [0] 返回
echo        Back
echo.
echo 输入你的选择。
echo Type your selection.
echo.
choice /c 120 
if errorlevel 3 goto mainMenu
if errorlevel 2 goto bootrecQ
if errorlevel 1 goto bcdbootQ

:bcdbootQ
cls
echo 该操作需要考虑的因素较多，还是建议手动操作。
echo There are many factors to consider in this operation,
echo then it is recommended to do it manually.
echo 本程序将执行 BCDBOOT C:\Windows 。确认继续吗？
echo I shall execute BCDBOOT C:\Windows , are you sure to continue?
echo.
choice
if errorlevel 2 goto addBootItem
if errorlevel 1 (
    cls
    bcdboot C:\Windows
    echo.
    pause
    goto addBootItem
)

:bootrecQ
cls
echo 本程序将执行 BOOTREC /REBUILDBCD 。确认继续吗？
echo I shall execute BOOTREC /REBUILDBCD , are you sure to continue?
echo.
choice
if errorlevel 2 goto addBootItem
if errorlevel 1 (
    cls
    bootrec /rebuildbcd
    echo.
    pause
    goto addBootItem
)


:add-driver
cls
echo 请输入要添加的驱动所在的文件夹路径，然后按 Enter 。
echo 本程序会使用 /recurse 参数，也就是添加所有子文件夹的可用驱动。
echo Please type the path to the driver.
echo I will use switch /recurse in order to add all sub-folders.
echo 留空可返回。 Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p%"=="" goto mainMenu
if not exist "%p%" (
    echo.
    echo 你输入的路径不存在。
    echo The path does not exist.
    echo 请重新输入。
    echo Please try again.
    echo.
    pause
    goto add-driver
)
set driver="%p%"

:add-driver2
cls
echo 请指定系统所在的路径，一般是 C:\Windows 。
echo Please tell me about the path to offline Windows image.
echo Usually C:\Windows .
echo 留空可返回。 Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p:~-1%"=="\" set p=%p:~0,-1%
if "%p%"=="" goto add-driver
if not exist "%p%\NUL" (
    echo.
    echo 你输入的路径不存在。
    echo The path does not exist.
    echo 请重新输入。
    echo Please try again.
    echo.
    pause
    goto add-driver2
)
set image="%p%"
cls
dism /image:%image% /add-driver /driver:%driver% /recurse
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
echo on
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

:disableWU
echo.
echo 前面的区域，以后再来探索吧？
echo How about we explore the area ahead of us later?
echo.
pause
goto mainMenu

> "%Temp%.\DefOpen.reg" ECHO Windows Registry Editor Version 5.00
>>"%Temp%.\DefOpen.reg" ECHO.
>>"%Temp%.\DefOpen.reg" ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update]
>>"%Temp%.\DefOpen.reg" ECHO "AUOptions"=dword:00000001
>>"%Temp%.\DefOpen.reg" ECHO "CachedAUOptions"=dword:00000001
>>"%Temp%.\DefOpen.reg" ECHO "ElevateNonAdmins"=dword:00000001
>>"%Temp%.\DefOpen.reg" ECHO "ForcedReboot"=dword:00000002
>>"%Temp%.\DefOpen.reg" ECHO "IncludeRecommendedUpdates"=dword:00000001
rem START /WAIT REGEDIT /S "%Temp%.\DefOpen.reg"
DEL "%Temp%.\DefOpen.reg"

rem sc stop wuauserv>nul
rem sc config wuauserv start=disabled



:exit

:end
