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
        echo.
        echo �����������˳���
        echo.
        pause
        goto exit
    )
)
if errorlevel 1 echo ��ʾ�˵��ı��ĵ�ʧ�ܡ�����%cd%\texts�ļ����Ƿ���ڡ�
echo.
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
    if "%s%"=="0" goto exit
)
echo.
echo ���������������������롣
echo.
pause
goto mainMenu

:allow7-zip
echo.
echo ����ȥ����ô���Ҷ�����ȥ�ɣ�
echo ���������˽�����ô�� TrustedInstaller ���� cmd ���� 7zFM
echo ������ô�������ߺ�Ȩ��Ҳ��
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
echo.
set p=
set /p "p=RTKozue>"
for /f "usebackq tokens=*" %%A in ('%p%') do set p=%%~A
if not exist %systemroot%\Web\Screen\img100_original.jpg (
    rename %systemroot%\Web\Screen\img100.jpg img100_original.jpg
    echo.
    echo ԭ���� img000.jpg �ѱ���Ϊ img100_original.jpg ��
    echo ����� original ���ļ��Ѵ��ڣ�����������ٸ�����
    echo.
)
copy /y "%p%" %systemroot%\Web\Screen\img100.jpg

pause
goto mainMenu

:switchBootManager
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
@if %failed%==1 (echo �޸�ʧ�ܣ����Թ���Ա������С�) else (
	@if %CurrStat%==1 (echo ===============������GRUB��===============) else echo ===============�ѻ�ԭbootmgfw.efi��===============
)
@echo.
@timeout /t 5
pause
goto mainMenu

:suspendOrDecryptBitLocker
cls
if %systemdrive%==C: (
    echo �Ӿ�������������˹��ܿ���ֻ���ڻָ�������ʹ�ã������򽫳������� manage-bde ��
    manage-bde -status>nul
    if errorlevel 9009 (
        echo.
        echo ���ϵͳû�� manage-bde �����ڻָ�������ʹ�ñ����ܡ�
        echo.
        pause
        goto mainMenu
    )
)
:suspendOrDecryptBitLocker1
echo.
echo ��ѡ����Ҫ��ô����
echo [1] ��ͣ BitLocker [2] �ָ� BitLocker
echo [3] ��� BitLocker [4] ��ѯ���ܽ��ȣ��ٷֱ��Ǵ� 100.0^% �� 0.0^% ��
echo [0] ����
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






:addPowerButton
echo.
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher" /v "Launcher_ShowPowerButtonOnStartScreen" /t REG_DWORD /d 1 /f
echo.
pause
goto mainMenu