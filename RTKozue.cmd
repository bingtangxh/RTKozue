@echo off
cls

setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION
title RTKozue by Bingtangxh Version 0.1
@REM mode con: cols=100 lines=25
doskey ˵=echo $*
doskey ����=echo.
cd /d %~dp0
for /f "delims=[]. tokens=4" %%A in ('ver') do set build=%%A
bcdedit>nul
if errorlevel 1 (
    echo ��������Ҫ����ԱȨ�޲������С�
    echo.
    echo �����򽫳������н�������Ȩ�ޡ�
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
        start echo ������Ϊ���´���һ��������ʾ�����ڣ���������������Ҫ�����顣
    ) else (
        echo ��ǰϵͳ�̲��� C: �� X: ���޷��ҵ���Ӧ�Ĳ˵���
        echo Current System Drive letter is neither C: nor X:
        echo.
        echo �����������˳���
        echo This script will terminate immediately.
        echo.
        pause
        goto exit
    )
)
if errorlevel 1 echo ��ʾ�˵��ı��ĵ�ʧ�ܡ�����%cd%\texts�ļ����Ƿ���ڡ�Failed to find menu text file.
set s=
set /p "s=RTKozue>"
if %systemdrive%==C: (
    rem ������Ȼ����Ҫ�ø�̾�ű�ʾ�ӳٱ�������
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
    rem ������Ȼ����Ҫ�ø�̾�ű�ʾ�ӳٱ�������
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
echo ���������������������롣Your input is incorrent.
echo.
pause
goto mainMenu

:allow7-zip
echo.
echo ����ȥ����ô���Ҷ�����ȥ�ɣ�
echo ���������˽�����ô�� TrustedInstaller ���� cmd ���� 7zFM
echo ������ô�������ߺ�Ȩ��Ҳ��
echo.
echo HKCR\*\shellex\ContextMenuHandlers
echo HKCR\Directory\shellex\ContextMenuHandlers
echo HKCR\Folder\shellex\ContextMenuHandlers
echo HKCR\Directory\shellex\DragDropHandlers
echo HKCR\Drive\shellex\DragDropHandlers
echo Ҳ�����ֶ��������������⼸���������ߣ�Owner���ĳ� Administrators Ⱥ��
echo ���� Administrators Ⱥ��������ȫ����Ȩ��
echo ���ù���Ա�����һ�� 7zFM.exe ���������ѡ�������
echo ��ᷢ�� ����� 7-zip ���Ҽ��˵��� ���Թ����ˡ�
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
echo ====================�ָ���====================
echo.
echo ��ճ������Ҫ�滻��������ֽ��·����Ȼ��Enter����û��˫���Ŷ����ԡ�
echo ��ܰ��ʾ����������������ʱͨ���ǹ���Ա��ݣ�������ק��
echo Please paste the path to the Wallpaper you want to use to replace default file.
echo.
set p=
set /p "p=RTKozue>"
for /f "usebackq tokens=*" %%A in ('%p%') do set p=%%~A
if not exist %systemroot%\Web\Screen\img100_original.jpg (
    rename %systemroot%\Web\Screen\img100.jpg img100_original.jpg
    echo.
    echo ԭ���� img000.jpg �ѱ���Ϊ img100_original.jpg ��
    echo ����� original ���ļ��Ѵ��ڣ�����������ٸ�����
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
    echo ���ϵͳû�н��� Secure Boot��
    echo ����Ҫʹ�� Tegra_Jailbreak_USB_v1.6 ��һ��������Խ�����������������Ĳ���ϵͳ��
    echo You need to use a portable disk and Tegra_Jailbreak_USB_v1.6
    echo in order to disable f**king Secure Boot before you can run other OSs.
    echo.
    if %build%==9600 (
        systeminfo | find "�޲�����"
        systeminfo | find "Hotfix(s):"
        echo.
        echo ���ϵͳ��װ��������ʾ�Ĳ�����
        echo ���װ���κβ������ͺܿ����޷�Խ�������¾�һ�����ᵼ����ʧ�ܵĿ��ܣ�
        echo ��ô����Ҫ��װԭ��ϵͳ���ٽ���Խ����
        echo �粻�붪ʧ��ǰϵͳ�������ڻָ����������б����򣬲����б��ݺͻָ���
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
@if %failed%==1 (echo �޸�ʧ�ܣ����Թ���Ա������С�Admin Permission required.) else (
	@if %CurrStat%==1 (echo ===============������GRUB�� GRUB enabled.===============) else echo ===============�ѻ�ԭbootmgfw.efi�� bootmgfw.efi is recovered.===============
)
@echo.
@timeout /t 5
pause
goto mainMenu

:suspendOrDecryptBitLocker
cls
if %systemdrive%==C: (
    echo �Ӿ�������������˹��ܿ���ֻ���ڻָ�������ʹ�ã������򽫳������� manage-bde ��
    echo This function might be available in RE only, Depends on whether manage-bde exists.
    manage-bde -status>nul
    if errorlevel 9009 (
        echo.
        echo ���ϵͳû�� manage-bde �����ڻָ�������ʹ�ñ����ܡ�
        echo manage-bde does not exist. You can use this function in RE only.
        echo.
        pause
        goto mainMenu
    )
)
:suspendOrDecryptBitLocker1
echo.
echo ��ѡ����Ҫ��ô����
echo [1] ��ͣ Suspend BitLocker [2] �ָ� Resume BitLocker
echo [3] ��� Turn off BitLocker
echo [4] ��ѯ���ܽ��ȣ��ٷֱ��Ǵ� 100.0^% �� 0.0^% �� Check decrypt process
echo [0] ���� Back
echo.
echo �������ѡ��Ȼ�� Enter��
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
    echo ���ϵͳû�а�װ KB2919355��
    echo ����Ҫ�Ȱ�װ KB2919442 �� KB2919355��
    echo KB2919442 ^& KB2919355 is required.
    echo.
    echo ��ȥ���ң�΢������������� RT �õ��κ����߰�װ�Ĳ�������˵ֻ�ܴ� Windows ���»�ȡ��
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
echo û�м�⵽ grub.cfg��
echo ����Ҫһ������ bootfs ���������̻�洢�������� GRUB_bootfs_Delta ���ļ�ȫ���滻�� bootfs ���������̻�洢��
echo ���� bootfs ���ļ�ȫ�����ƽ� EFI ESP ������
echo ���ڣ�����뺬�� bootfs ������������� GRUB_bootfs_Delta �����̻�洢����������Ϊ���Զ����Ƶ� EFI ESP ������
echo You need a USB drive or a memory card with bootfs partition, while it contains GRUB_bootfs_Delta changes.
echo Now please plug it in, i will copy them to EFI ESP partition automatically.
echo Sorry, simpified Chinese only.
echo.
pause
cls
for %%A in (A C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%A:NUL fsutil fsinfo drivetype %%A:
@REM Ϊʲôû�� B ����Ϊ B �ø� EFI ESP �����ˡ�

echo.
echo ���������ѡ��Ȼ��Enter������ back �ɷ��ء���ֻ������ĸ��������ð�ţ�
echo Choice a volume letter and press Enter. Just a letter without the colon. Type "back" to turn back.
echo.
set p=
set /p "RTKozue=>"
if "%p%"=="back" goto mainMenu
if exist "%p%:" (
    cls
    copy B:\efi\boot\bootarm.efi B:\efi\boot\bootarm_original.efi
    echo �����ʾ�Ƿ񸲸� bootarm.efi����ô������ Y ȷ�ϡ�����Ǳ���ļ������� N��
    echo Type Y if it asks if bootarm.efi is to be replaced. Type N for anything else.
    xcopy %p%:\* B:\ /-Y /C /E /Q /I
) else (
    echo ������벻���ڣ������ԡ�Not exists, please try again.
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
echo ��������������������롣Your input is incorrent.
echo.
pause
goto activate

:KMSActWin
cls
echo ��һ�λ����һ���ϴ�Ĵ��ڣ���ʾ�Ѿ����°�װ�����֤�ļ���
echo ���ڿ���̫�󣬹ص������ɡ�
echo A large window is going to appear at first
echo Displaying that tokens files is re-installed. Just close it.
sc start W32Time
w32tm /resync
slmgr.vbs /rilc
echo.
echo ���������ζ���ȷ�����ɡ�
@REM slmgr /ipk NG4HW-VH26C-733KW-K6F98-J8CK4
@REM ���������Կ�Ǹ� Li_zip �����Ͽ���ε�α 8400RT �õģ���ȷ���Ƿ����������ϵͳ
slmgr.vbs /ipk FNFKF-PWTVT-9RC8H-32HB2-JB34X
slmgr.vbs /skms kms.03k.org
slmgr.vbs /ato
echo.
echo �����ʾ�ɹ�����ô������������������Ч��
echo.
echo ����Ļ����Ǿ�����֮������һ�Ρ�
echo If success, reboot. If failed, reboot and try again.
echo.
choice /m "�Ƿ���������������"
if errorlevel 2 goto activate
if errorlevel 1 shutdown -r && goto activate
goto activate

:convOffice
cls
@REM set "params=%*"
@REM cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
@REM ��һ�е�ԭ������һ�� fsutil�����ʧ���˾��������ߺ����ָ�ûʧ�ܾͲ���
@REM pause
fsutil dirty query %systemdrive% 1>nul 2>nul
@REM title MSO2013֤�鵼�빤��
@pushd "%~dp0"
if exist "C:\Program Files\Microsoft Office\Office15\OSPP.VBS" (
    @REM RT Ĭ�Ͽ϶��� 32 λ�� Office 2013������·��Ҳ�����ġ���һ���Ǿ�Ҫ�����롣
    set ospp=C:\Program Files\Microsoft Office\Office15\OSPP.VBS
) else (
    echo ��ָ��һ�� OSPP.VBS ��·����ͨ���� Office ��װĿ¼��
    echo Type a path to OSPP.VBS.
    echo.
    set ospp=
    set /p "ospp=RTKozue>"
    for /f "usebackq tokens=*" %%A in ('!ospp!') do set ospp=%%~A
    @REM ΪʲôҪ usebackq����Ϊ for ��������������˫�������пո�Ļ����ܻ����ˡ�
    if not exist "!ospp!" (
        echo.
        echo ������� OSPP.VBS ·�������ڡ�
        echo.
        pause
        goto convOffice
    )
)
@REM �������ʱ��%ospp%Ӧ���ǲ����κ�˫���ŵ�
for %%A in ("%~dp0ort2oppvl\bin\*.xrm-ms") do cscript //nologo "%ospp%" /inslic:"%%A"
regedit /s "%~dp0ort2oppvl\bin\license.reg"
cscript //nologo "%ospp%" /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT
cscript //nologo "%ospp%" /sethst:kms.03k.org
cscript //nologo "%ospp%" /act
echo.
echo Ӧ���Ѿ���ɣ���鿴���ģ�ȷ���Ƿ��ѳɹ���
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
echo ������һ�����ڴ�ŵ����ļ���λ�ã�Ȼ��Enter��
echo ����...�ɷ��ء�
echo Please type a location to save files exported then press Enter. Type ... to turn back.
echo.
set p=
set /p "p=>"
if "%p%"=="..." goto activate
set p=%p:"=%
set p="%p%"
@rem ��֤����ֻ��һ��˫����
if not exist %p% md %p%
if not exist %p% (
    echo �������·�������ڡ�
    echo �Ѿ������½����ļ��У������Ժ��Բ����ڣ�������ʧ���ˡ�
    echo ����������·����
    echo Not able to find or make your path. Please try again.
    echo.
    pause
    goto exportTokens
)
xcopy /i /e C:\Windows\System32\spp\tokens %p%\tokens
@rem ������ %p% �������˫���ţ�����˫���������ټ������ַ������ǿ��Ա��϶�Ϊһ��·����
@rem ���� "D:\tokens9200"\tokens �ǿ��Ե�
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" %p%\9200CurrentVersion.reg
FOR /F "tokens=1-3" %%A IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DigitalProductId') DO @IF /I %%A==DigitalProductId DPIDDC_ARM /VENTI %%C >> %p%\ProductKey.txt

echo ����ɣ������в鿴Ŀ���ļ��С�
echo Done. You can explore the goal folder manually.
echo.
pause
goto activate

:importTokens
cls
@rem ����������������Ҿ��ǲ���˵�Ǹ� ACG Video �ļ��
type .\texts\importTokens.txt
set p=
set /p "p=>"
if "%p%"=="..." goto mainMenu
if "%p%"=="...." start & goto importTokens
set p=%p:"=%
set p="%p%"
if not exist %p% (
    echo �������·�������ڡ�
    echo ����������·����
    echo Not able to find your path. Please try again.
    echo.
    pause
    goto importTokens
)
takeown /f C:\Windows\system32\spp\tokens /r /d y
icacls C:\Windows\system32\spp\tokens /grant %computername%\%username%:F /t /c /q
cls
echo ��ѡ���Ƿ�Ĩ��ԭ�� tokens ��һ��ѡ N ��
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
reg add HKCR\appxfile /ve /t REG_SZ /d "��װAPPX��" /f
reg add HKCR\appxfile\DefaultIcon /ve /t REG_SZ /d "C:\Windows\WinStore\WinStoreUI.dll,0" /f
reg add HKCR\appxfile\shell\install /ve /t REG_SZ /d "��װAPPX��" /f
reg add HKCR\appxfile\shell\install /ve /t REG_SZ /d "\"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\"" /f
@REM ����ķ�б�ܺ����˫������ת���ַ�
reg add HKCR\appxfile\shell\install\command /ve /t REG_SZ /d "\"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe\" -Command \"Add-AppxPackage \\\"%1\\\"\"" /f


echo.
pause
goto activate

:uninsPrevKey
cls
cscript //nologo "%ospp%" /dstatus | findstr "LICENSE Last ---------------------------------------"
echo �������Ѿ���װ����Կ�������·�����Ҫж�ص���Կ�� 5 λ�����硰R3H4F�� �����������ţ���Ȼ�� Enter��
echo ȷ��������ȷ���˴�����������Ƿ���ȷ��
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
echo ��������Ҫ���·�����Ӳ�̱�ţ�ͨ���� 0 ����Ҳ��ͨ���������б��ϡ�
echo �˴��������������Ƿ���ȷ������������� -1 �ɷ��ء�
echo ��ᶪʧӲ�������е����ݣ�
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
echo ��ȷ����Ҫ���·������� %disk% �����ٴ�������ȷ�ϡ����� -1 �ɷ��ء�
echo ��ᶪʧ���е����ݣ���
echo Are you sure the disk you want to repartition %disk% ?
echo Type the number again to ensure. Type -1 to go back.
echo YOU WILL LOSE ALL OF YOUR DATA ON THE DISK !!!
echo.
set disk1=
set /p "disk1=>"
if "%disk1%"=="-1" goto mainMenu
if not "%disk%"=="%disk1%" (
    echo.
    echo ����������벻һ�£����������롣
    echo Twice of your raw input does not match. Please try again.
    echo.
    pause
    goto expressRePart
)

cls
echo select disk %disk% >%temp%\dpst.txt
echo clean>>%temp%\dpst.txt
echo convert gpt>>%temp%\dpst.txt

echo ��ָ�� EFI ESP �����Ĵ�С�������գ���Ĭ��Ϊ 250MiB ��
echo ���Ҫ�ڸ÷����з����������� Linux ϵͳ�� bootfs �����е��ļ�����Ӧ�ô��� 250MiB ��
echo �����С����Ҫ����λ��Ӧ�û��� MB����Ȼ�� Enter�� ���� 300MB ������ 300������ -1 �ɷ��ء�
echo ȷ��������ȷ���˴�����������Ƿ���ȷ��
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
echo �Ƿ񴴽� MSR ������ Do you want to create MSR partition ?
echo.
echo    [1] �� Yes     [0] �� No
echo.
echo ���������ѡ��Ȼ�� Enter ������ -1 �ɷ��ء�
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
echo ��������������������롣Your input is incorrent.
echo.
pause
goto expressRePart1

:expressRePart2
cls
echo �Ƿ񴴽��ָ����������� Do you want to create WinRE partition ?
echo.
echo    [1] �� Yes     [0] �� No
echo.
echo ���������ѡ��Ȼ�� Enter ������ -1 �ɷ��ء�
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
echo ��������������������롣Your input is incorrent.
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
echo ���·�����ɡ� Repartition complete.
echo ���������Ѿ���ʧ�� All of the data is lost.
echo.
pause
goto mainMenu

:backup

:backup0
cls
echo ��������ܱ��� C: �е�ϵͳ��
echo �����·�������Ҫ���浽���ļ�·�������տɷ��ء�
echo �˴��������������Ƿ���ȷ���������
echo ��������Ϊһ���̵ĸ�Ŀ¼������Ҫ�Ǵ���˾��Ҳ���·���ˡ�
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
echo ��ѡ���������ֱ��ݡ�
echo.
echo    [1] ��ʼ����   /Capture-Image
echo    [2] ��������   /Append-Image
echo    [0] ����       Go Back
echo.
echo �������ѡ��Ȼ�� Enter��
echo Type your selection and then press Enter.
echo.
set /p "s=>"
if "%s%"=="1" set backupType=/Capture-Image&goto backup2
if "%s%"=="2" (
    set backupType=/Append-Image
    echo.
    echo ��ȷ����ž����ļ��ķ����������㣬������ܻ������еľ����ļ���
    echo Make sure that the partition which saves the image file has enough free space.
    echo Or you will destory the existing image file.
    echo.
    pause
    goto backup2
)
if "%s%"=="0" goto backup0
echo.
echo ��������������������롣Your input is incorrent.
echo.
pause
goto backup1

:backup2
cls
echo ��ָ�����α��ݵ����ƣ��������ʡ�ԣ������ļ�������������˫���š�
echo ������᷵�ء�
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
echo ��ָ�����α��ݵĽ��͡��������ա���������˫���š����� /back �ɷ��ء�
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
echo ��ȷ����ı��ݡ� Please take a look.
echo.
echo %backupType%
echo %p%
echo %name%
echo %description%
echo.
choice /m "��ʼ������ Start now?"
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
echo ����ָ�������ļ���·��������������ļ��Ƿ���ڡ�
echo Please tell me about the path to image file.
echo I will check if it exists.
echo.
echo ������õ��� swm �ļ�����ô�������������һ���ļ���
echo �������⵽���������������ַ��� swm �ͻ�ѯ�������ļ���
echo If you want to use swm files, you can type the first file here.
echo I will ask you for other files if the last 3 chars are "swm" .
echo.
echo ���տɷ��أ���������˫���š�
echo Left blank to go back. Quotes are not allowed.
echo.
set imageFile=
set /p "imageFile=>"
if "%imageFile%"=="" goto mainMenu
set imageFile=/imageFile:"%imageFile:"=%"
if not exist %imageFile% (
    echo �������·�������ڡ�
    echo The path you typed does not exist.
    echo.
    pause
    goto apply-image
)
if "%imageFile:~-4,3%"=="swm" (goto swmFile2) else set swmFile=
goto ai1

:swmFile
rem Ӧ����д�ظ��ˣ���һҪ�������Ų�ɾ��Ӧ�����ò�����
cls
echo �������һ�� swm �ļ���·����
echo Please type the path to the first swm file.
echo.
echo ���տɷ��أ���������˫���š�����ʹ��˫���Ű�·���������������пո�
echo Left blank to go back. Quotes are not allowed. 
echo Although the path contains any spaces, you don't need to use quotes.
echo.
set p=
set /p "p=>"
if not exist %p% (
    echo �������·�������ڡ�
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
echo ���������� swm �־��ļ���·����
echo Please type the paths to other swm files.
echo.
echo �����Ǻţ� Shift + 8 ����ָ������ļ���
echo Use * ( Shift + 8 ) to express multi files.
echo.
echo ���磺 For example:
echo D:\sources\install*.swm
echo.
echo ���տɷ��أ���������˫���š��˴�����������Ƿ���Ч��
echo ������õĵ�һ���ļ���Ч���˴�����Ч������Ὺʼ����������;����
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
echo ��ָ��Ӧ�þ����λ�ã�һ���� C:\ ��
echo ���ջ᷵�ص�ָ�������ļ��Ľ��档
echo Please tell me about the dir to be applied.
echo Usually C:\. Left blank to go back.
echo.
set p=
set /p "p=>"
set p=%p:"=%
if "%p%"=="" goto apply-image
if not exist "%p%" (
    echo �������·�������ڡ�
    echo The path does not exist.
    echo.
    pause
    goto applyDir
)
set applyDir=/applyDir:"%p%"
goto index

:index
cls
echo ������Ҫ�ͷŵľ����������һ���� 1 ��
echo ����㲻ȷ������������� Get-ImageInfo ����ѯ�������ִ�Сд��
echo Please type the index number, usually 1.
echo If you aren't sure, you can type Get-ImageInfo. Case insensitive.
echo.
echo ���տɷ��ء� Left blank to go back.
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
echo ��ȷ������ͷš�
echo %imageFile%
echo %swmFile%
echo %index% %applyDir% 
echo.
choice /m "��ʼ�ͷ��� Start now?"
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
echo ǰ��������Ժ�����̽���ɣ�
echo How about we explore the area ahead of us later?
echo.
pause
goto mainMenu




:convWin
cls
echo �뽫�����ṩ�� RT_8.1_LOB_APPX �ļ���׼���á�
echo �������Զ�Ϊ���滻��
echo.
echo ��������ļ��е�·������������κ�˫���ţ������пո����տɷ��ء�
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
    echo �������·�������ڡ�
    echo The path does not exist.
    echo ���������롣
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
