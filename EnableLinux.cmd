set CurrStat=0
bcdedit
if errorlevel 1 (
	set failed=1
	goto report
) else set failed=0
echo sel disk 0 >%tmp%\EnableLinux.txt
echo sel par 1 >>%tmp%\EnableLinux.txt
echo assign letter='Z'>>%tmp%\EnableLinux.txt
echo exit>>%tmp%\EnableLinux.txt
diskpart /s %tmp%\EnableLinux.txt

cd /d Z:\EFI\Microsoft\Boot
if exist bootmgfw.efi (del bootmgfw.efi) else copy boutmgfw.efi bootmgfw.efi
if errorlevel 1 (set failed=1) else set failed=0
if not exist bootmgfw.efi (set CurrStat=1) else set CurrStat=0
if %CurrStat%==1 (bcdedit /bootsequence {9543a28c-8ee3-11ef-ae81-bd3afa2fa51d} /addfirst) else bcdedit /bootsequence {9543a28f-8ee3-11ef-ae81-bd3afa2fa51d} /addfirst
%~d0
echo sel disk 0 >%tmp%\EnableLinux.txt
echo sel par 1 >>%tmp%\EnableLinux.txt
echo remove>>%tmp%\EnableLinux.txt
echo exit>>%tmp%\EnableLinux.txt
diskpart /s %tmp%\EnableLinux.txt
del %tmp%\EnableLinux.txt
:report
@echo.
@if %failed%==1 (echo 修改失败，请以管理员身份运行。) else (
	@if %CurrStat%==1 (echo ===============已启用GRUB。===============) else echo ===============已还原bootmgfw.efi。===============
)
@echo.
@timeout /t 5
