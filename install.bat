@echo off
color 0a
cd /d "%~dp0"
echo ============================================================
echo. Windows RT Install Tools Lite
echo.
echo. By @Tmsix @Crp1232
echo.
echo. QQһȺ��725688821
echo ============================================================
set /p choice=������0��س���ʼ��װ:
if "%choice%"=="0" goto no1

:no1
cls
mountvol S: /s
S:
cd S:\EFI\Microsoft\Boot
bcdedit /store BCD /set "{bootmgr}" testsigning on
bcdedit /store BCD /set "{bootmgr}" nointegritychecks on
bcdedit /store BCD /set {default} testsigning on
bcdedit /store BCD /set {default} nointegritychecks on
echo lis dis>>2.txt
diskpart /s 2.txt
del 2.txt
set /p a=������ϵͳ���̱�� (ͨ��Ϊ0) :
echo sel dis "%a%">>2.txt
echo lis par>>2.txt
diskpart /s 2.txt
del 2.txt
set /p b=������ϵͳ "��Ҫ" ��������Ӧ����� :
echo sel dis "%a%">>2.txt
echo sel par "%b%">>2.txt
echo for quick fs=ntfs override>>2.txt
diskpart /s 2.txt
del 2.txt
dism /apply-image /imagefile:D:\A1516_17763_1.3_install.wim /index:1 /applydir:C:
bootrec /fixmbr
bootrec /fixboot
pause
goto main