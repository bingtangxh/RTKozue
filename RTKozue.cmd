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
    echo ������벻���ڣ������ԡ�Not exist, please try again.
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
    echo Not able to find or make your path. Please try agian.
    echo.
    pause
    goto exportTokens
)
xcopy /i /e C:\Windows\System32\spp\tokens %p%\tokens
@rem ������ %p% �������˫���ţ�����˫���������ټ������ַ������ǿ��Ա��϶�Ϊһ��·����
@rem ���� "D:\tokens9200"\tokens �ǿ��Ե�
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" %p%\9200CurrentVersion.reg
for /f "tokens=3" %A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V DigitalProductId') do @echo %A>nul

echo ����ɣ������в鿴Ŀ���ļ��С�
echo Done. You can explore the goal folder manually.
echo.
pause
goto activate

:importTokens
cls
echo ������ֻ���������������ʹ�ã�
echo.
echo �Ѿ����� BV1a34y1T7Dh ����һ�ֽϾɵ���Ƶ���� 830570599���ķ��������� tokens �ļ���
@rem ����������������Ҿ��ǲ���˵�Ǹ� ACG Video �ļ��
echo ���ڸո��ڻָ��������� PE ���ͷ��� Windows RT 8.0 ���԰�ľ����һ��ڻָ������� PE ��û�������뿪
echo Ȼ��Ҫ�� tokens �ļ����滻��ȥ��
echo ������ֻ�ܸ��Ƶ� C �̲��һ᲻��ʾֱ��Ĩ��ԭ���ļ�Ȼ���滻�����Ի��ǽ����ֶ�������
echo.
echo ������tokens�ļ������ڵ�·����Ȼ��Enter������...�ɷ��ء�
echo ��Ȼ������ʱ�򱾳����Զ����û������·���������һ��tokens
echo �������ﵼ���ʱ��·�������Ҫ��tokens��һ����ϡ�����E:\9200tokens\tokens��
echo �������Ҫ�� dir ���� tree ָ������Ǽ��±�������ļ����������ĸ���Ǿ��....
echo �������������Ϊ���һ�� cmd ������Բ��ص�������������ļ���
echo ��ȷ�������·����·��ָ����ļ���������ļ���ȷ����������֤�Ƿ���Ч����ֱ�ӱ������ƹ�ȥ��
echo.
set p=
set /p "p=>"
if "%p%"=="..." goto mainMenu
if "%p%"=="...." start & goto importTokens
set p=%p:"=%
set p="%p%"
if not exist %p% (
    echo �������·�������ڡ�
    echo ����������·����
    echo Not able to find your path. Please try agian.
    echo.
    pause
    goto importTokens
)
cls
echo ��ѡ���Ƿ�Ĩ��ԭ�� tokens ��һ��ѡ N ��
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
echo.
set p=
set /p "p=RTKozue>"
cls
cscript //nologo "%ospp%" /unpkey:%p%
echo.
pause
goto activate



rem wmic diskdrive list brief
rem �г�Ӳ��

:exit

:end