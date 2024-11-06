@echo off
@setlocal enableextensions
@setlocal EnableDelayedExpansion
cls

Set MBName=Tegra Jailbreak USB
Set MBVer=v1.6
Set MBDate=01-05-2023

@Title %MBName%
echo Please wait...

REM
REM	jwa4
REM	

REM ====== Network Drive/Share Check ===================================================================================================================================

If "%~d0" == "\\" (
	Set BuildAbort=True
)

"%SystemRoot%\System32\net.exe" use | "%SystemRoot%\System32\findstr.exe" /I /L /C:" %~d0 " >nul
If not "!ErrorLevel!" EQU "1" (
	Set BuildAbort=True
)

If "%BuildAbort%" == "True" (
	echo Error: %MBName% cannot be run from a mapped drive or network share.
	goto Exit
)

@cd /d "%~dp0"

REM ====== Check if being run as admin =================================================================================================================================

For /f "tokens=1,2,3,4 USEBACKQ delims=," %%a in (`"%SystemRoot%\System32\whoami.exe /groups /fo csv /nh"`) Do (
	If %%c == "S-1-16-12288" Set RunAsAdmin=True
)

If not "%RunAsAdmin%" == "True" (
	echo Error: Please run as administrator.
	echo.
	goto Exit
)

REM ====== Check only one instance is running ==========================================================================================================================

9>&2 2>nul (Call :LockAndRestoreStdErr %* 8>>"%~f0") || (
	echo Error: Only one instance allowed - "%~f0" is already running >&2
	echo.
)
goto Exit

:LockAndRestoreStdErr
Call :SingleInstance %* 2>&9
exit /b 0

:SingleInstance

REM ====== Check is running form USB ===================================================================================================================================

If "%PROCESSOR_ARCHITECTURE%" == "ARM" (
	Goto ARMUSBCheck
) else (
	Goto NotARMUSBCheck
)

:ARMUSBCheck
For /F "usebackq skip=2 tokens=2-3 delims=," %%a in (`"wmic.exe logicaldisk get caption, drivetype /format:csv"`) do (

	Set caption=%%a
	Set /a drivetype=%%b

	If "!drivetype!" equ "2" (
		If "%~d0\%~nx0"=="%~dpnx0" If  "!caption!" == "%~d0" (
			Set CD=%~d0
			Set RunningFromUSBDrive=True
			goto RunningFromUSB
		)
	)
)
goto USBCheck

:NotARMUSBCheck
for /f "skip=3 tokens=1,2 delims= " %%a in ('powershell.exe -c "$ErrorActionPreference='Stop'; Get-CimInstance CIM_LogicalDisk | Select-Object DeviceID, DriveType"') do (

	Set caption=%%a
	Set /a drivetype=%%b

	If "!drivetype!" equ "2" (
		If "%~d0\%~nx0"=="%~dpnx0" If  "!caption!" == "%~d0" (
			Set CD=%~d0
			Set RunningFromUSBDrive=True
			goto RunningFromUSB
		)
	)
)
@Title %MBName%
goto USBCheck

:USBCheck
If not "%RunningFromUSBDrive%" == "True" (
	echo Error: Not running from USB drive.
	echo.
	goto Exit
)

:RunningFromUSB

REM ====== Check nothing vital missing =================================================================================================================================

For %%c in (
	"%CD%\SecureBootDebugPolicy.p7b"
	"%CD%\efi\boot\bootarm.efi"
	"%CD%\efi\microsoft\boot"
	"%CD%\efi\microsoft\boot\bcd"
	"%CD%\efi\microsoft\boot\fonts"
	"%CD%\efi\microsoft\boot\fonts\segoe_slboot.ttf"
	"%CD%\efi\microsoft\boot\fonts\wgl4_boot.ttf"
	"%CD%\Firmware\Surface_RT_1_IDP"
	"%CD%\Firmware\SKU1\NvT3xUEFIImage.bin"
	"%CD%\Firmware\SKU1\SKU1.cmd"
	"%CD%\Firmware\SKU1\venus.cat"
	"%CD%\Firmware\SKU1\venus.inf"
	"%CD%\Firmware\Surface_2\Surface2FwUpdate.inf"
	"%CD%\Firmware\Surface_2\Surface2UEFI.bin"
	"%CD%\Firmware\Surface_2\Surface2UEFI.cat"
	"%CD%\Firmware\Surface_2\Surface_2.cmd"
	"%CD%\Firmware\Surface_RT_1_IDP\SurfaceRTUEFI.bin"
	"%CD%\Firmware\Surface_RT_1_IDP\SurfaceRTUEFI.cat"
	"%CD%\Firmware\Surface_RT_1_IDP\SurfaceRTUEFI.inf"
	"%CD%\Firmware\Surface_RT_1_IDP\Surface_RT_1_IDP.cmd"
	"%CD%\Firmware\TF600T\catalog.cat"
	"%CD%\Firmware\TF600T\IMAGE.BIN"
	"%CD%\Firmware\TF600T\TF600T.cmd"
	"%CD%\Firmware\TF600T\uefi.inf"
	"%CD%\Jailbreak\DisableUMCIAuditMode.reg"
	"%CD%\Jailbreak\EnableUMCIAuditMode.reg"
	"%CD%\Jailbreak\SecureBootDebugPolicy"
	"%CD%\Jailbreak\WindowsUpdateManualMode.reg"
	"%CD%\Jailbreak\SecureBootDebugPolicy\SecureBootDebug.efi"
	"%CD%\Jailbreak\Yahallo\Yahallo.efi"
	"%CD%\Jailbreak\Yahallo\YahalloUndo.efi"
) do (
	If not exist %%c (
		echo Error: File Missing...
		echo %%c
		Set FileMissing=True
	)
)

If "%FileMissing%"=="True" (
	echo.	
	goto exit
)

REM ====== Get System Info =============================================================================================================================================

If not "%PROCESSOR_ARCHITECTURE%" == "ARM" goto Select

Set DeviceName=Unknown
For /f "usebackq skip=2 tokens=1-3 delims==" %%a in (`wmic.exe /namespace:\\root\wmi path MS_SystemInformation get SystemSKU /format:list`) do (
	Set SystemSKU=%%b
	goto SystemSKU
)
:SystemSKU

For /f "usebackq skip=2 tokens=1-3 delims== " %%a in (`wmic.exe os get BuildNumber /format:list`) do (
	Set /a BuildNumber=%%b
	goto BuildNumber
)
:BuildNumber

For %%s in (
	"Surface_RT"
	"Surface_2"
	"SKU"
	"TF600"
) do (
	For %%a in (%%s) do (
		Set CheckSKU=%%~a
		If not "!SystemSKU:%%~a=!" == "!SystemSKU!" If %BuildNumber% EQU 9600 (
			Set SupportedDevice=True
		)
	)

)

If %BuildNumber% LSS 10240 mode con: cols=120 lines=31

If not "%SupportedDevice%" == "True" goto Select

For /f "usebackq skip=2 tokens=1-3 delims==" %%a in (`wmic.exe csproduct get name /format:list`) do (
	Set ProductName=%%b
	goto ProuctName
)
:ProuctName

For /f "usebackq skip=2 tokens=1-3 delims== " %%a in (`wmic.exe bios get smbiosbiosversion /format:list`) do (
	Set BIOSVersion=%%b
	goto BIOSVersion
)
:BiosVersion

echo Getting Secure Boot Status ^(Yahallo^)
Set "SecureBoot=Unknown" && Set "Yahallo=Unknown"
For /f "tokens=1" %%a in ('powershell.exe -c "$ErrorActionPreference='Stop'; Confirm-SecureBootUEFI"') do (
	If "%%a" == "True" Set "SecureBoot=True" && Set "Yahallo=Disabled"
	If "%%a" == "False" Set "SecureBoot=False" && Set "Yahallo=Enabled"
)

echo Getting Secure Boot Policy Status ^(Golden Keys^)
Set GK=Unknown
For /f "tokens=1* delims=: " %%a in ('powershell.exe -c "$ErrorActionPreference='Stop'; Get-SecureBootPolicy | select-object publisher | Format-List"') do (
	If /i "%%b" == "9ed089a1-8e30-420a-9285-4427ace66ba5" Set GK=Enabled
	If /i "%%b" == "77fa9abd-0359-4d32-bd60-28f4e78f784b" Set GK=Disabled
)

REM ====== Menu ========================================================================================================================================================

:Select
rem Set SupportedDevice=True
rem Set Yahallo=Unknown
rem Set GK=Unknown

rem echo Getting UMCI Audit Mode Status
Set UMCI=Disabled
For /f "usebackq tokens=3,*" %%a IN (`""%systemroot%\system32\reg.exe" query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CI" /V "UMCIAuditMode" 2>NUL"`) do (
	If "%%a" == "0x1" Set UMCI=Enabled
	If "%%a" == "0x0" Set UMCI=Disabled
)

rem echo Getting Test Mode Status
Set CurrentTestMode=False
For /f "usebackq tokens=1-2" %%a in (`"%systemroot%\System32\bcdedit.exe /enum {current}"`) DO (
	If /i "%%a" == "testsigning" If /i "%%b" == "Yes" Set CurrentTestMode=True
)

Set BootmgrTestMode=False
For /f "usebackq tokens=1-2" %%a in (`"%systemroot%\System32\bcdedit.exe /enum {bootmgr}"`) DO (
	If /i "%%a" == "testsigning" If /i "%%b" == "Yes" Set BootmgrTestMode=True
)

Set TestMode=Disabled
If "!CurrentTestMode!" == "True" If "!BootmgrTestMode!" == "True" Set TestMode=Enabled

rem echo Getting BitLocker Status
Set BitLocker=Unknown
If not exist "%SystemRoot%\System32\manage-bde.exe" goto SkipBitLocker
For /f "usebackq tokens=1-4 delims=: " %%a IN (`""%SystemRoot%\System32\manage-bde.exe" -status %systemdrive% 2>NUL"`) do (
	If /i "%%a %%b" == "Protection Status" (
		If /i "%%d"=="On" Set BitLocker=Enabled
		If /i "%%d"=="Off" Set BitLocker=Disabled
	)
)
:SkipBitLocker

rem echo Getting Windows Update Status
Set WindowsUpdate=Unknown
For /f "usebackq tokens=1-3 delims=: " %%a IN (`""%systemroot%\system32\sc.exe" qc "wuauserv" 2>NUL"`) do (
	If /i "%%a" == "START_TYPE" (
		If %%b EQU 2 Set WindowsUpdate=Enabled
		If %%b EQU 3 Set WindowsUpdate=Enabled
		If %%b EQU 4 Set WindowsUpdate=Disabled
	)
)

Set CurrentSelection=Unknown
For /f "usebackq tokens=1*" %%a in (`"%systemroot%\System32\bcdedit.exe /store "%CD%\efi\microsoft\boot\bcd" /enum {default}"`) DO (
	If /i "%%a" == "description" Set CurrentSelection=%%b
)

Set CurrentTimeout=Unknown
For /f "usebackq tokens=1-2" %%a in (`"%systemroot%\System32\bcdedit.exe /store "%CD%\efi\microsoft\boot\bcd" /enum {bootmgr}"`) DO (
	If /i "%%a" == "timeout" Set /a CurrentTimeout=%%b
)

Set CurrentSelectionMessage=%CurrentSelection% ^^(%CurrentTimeout%^^)          

If "%RebootRequiredUSB%"=="True" (
	Set RebootMessage=- *** Reboot from Jailbreak USB Required ***
	goto RebootMessageSet
)

If "%RebootRequired%"=="True" Set RebootMessage=- *** Reboot Required ***

:RebootMessageSet

@Title %MBName%
Set Target=
cls
echo _____________________________________
echo.
echo %MBName% %MBVer% - %MBDate%
echo _____________________________________
echo.
echo Yahallo - Copyright (C) 2019 - 2020, Bingxing Wang
echo Yahallo - Additional Device Support - Jeybee
echo Yahallo - Undo Support - Leander
echo Golden Keys - never_released ^& TheWack0lian
echo GoldenKeysUSB - lgibson02
echo.
echo All-in-on package to enable Tegra based Windows RT tablets to run third party applications under Windows RT or to
echo boot alternative operating systems.
echo.
echo The use of this USB drive is entirely at your own risk.
echo ________________________________________________________________________________________________________________________
If "%SupportedDevice%" == "True" (
echo Boot Defaults: 1: Install Golden Keys	   	   Settings: 6: Enable Test Mode	  10: Resume BitLocker
echo		       2: Uninstall Golden Keys			     7: Disable Test Mode	  11: Suspend BitLocker
echo		       3: Install Yahallo			     8: Enable UMCI Audit Mode	  12: Enable Windows Update
echo		       4: Uninstall Yahallo			     9: Disable UMCI Audit Mode	  13: Disable Windows Update
echo		       5: Set Boot Menu Timeout			     
echo.
echo Selected:      %CurrentSelectionMessage:~0,30%	     Device: %ProductName% - UEFI: %BIOSVersion% %RebootMessage%
echo.
echo Misc:	       B: Boot from USB		   Jailbreak Status: Golden Keys: %GK%	  Test Mode:       %TestMode%
echo		       R: Reboot				     Yahallo:     %Yahallo%	  UMCI Audit Mode: %UMCI%
echo.
echo		       E: Exit			     Windows Status: BitLocker:   %BitLocker%	  Windows Update:  %WindowsUpdate%
) else (
echo.
echo Boot Defaults: 1: Install Golden Keys
echo		       2: Uninstall Golden Keys
echo		       3: Install Yahallo
echo		       4: Uninstall Yahallo
echo		       5: Set Boot Menu Timeout
echo.
echo Selected:      %CurrentSelectionMessage%
echo.
echo		       E: Exit
)
echo.
Set /p Target=Enter Selection: 
echo.

If /i "%Target%"=="E" goto Exit

cls

If "%Target%"=="1" (
	Set GoldenKeysMode=InstallGoldenKeys
	goto GoldenKeysCheck
)
If "%Target%"=="2" goto RemoveGoldenKeys

If "%Target%"=="3" (
	Set YahalloMode=ApplyYahallo
	Goto YahalloCheck
)

If "%Target%"=="4" goto RemoveYahallo

If "%Target%"=="5" goto TimeOutSelect
If "%SupportedDevice%" == "True" (
	If "%Target%"=="6" goto TestSigningEnable
	If "%Target%"=="7" goto TestSigningDisable
	If "%Target%"=="8" goto UMCIEnable
	If "%Target%"=="9" goto UMCIDisable
	If "%Target%"=="10" goto BitLockerEnable
	If "%Target%"=="11" goto BitLockerDisable
	If "%Target%"=="12" goto WUEnable
	If "%Target%"=="13" goto WUDisable
	If /i "%Target%"=="B" goto USBBoot
	If /i "%Target%"=="R" goto Reboot
	If /i "%Target%"=="ME" goto MyriachanEnable
	If /i "%Target%"=="MD" goto MyriachanDisable
)
cls
echo Please wait...
goto Select

REM ====== Myriachan ===================================================================================================================================================

:MyriachanEnable

If "%SupportedDevice%" == "True" (

	For %%f in (
		hal.dll#6.3.9600.17196
		ntoskrnl.exe#6.3.9600.18007
		winload.efi#6.3.9600.18006
	) do (
		For /f "tokens=1,2 delims=#" %%a in ("%%f") do (

			For /f "tokens=4 delims=." %%r in ("%%b") do (
				Set /a VersionMax=%%r
			)

			For /f "tokens=5 delims==." %%i in ('wmic.exe datafile where "name='%systemdrive%\\Windows\\System32\\%%a'" get version /format:list') do (
				Set /a VersionFound=%%i
			)

			If !VersionFound! GTR !VersionMax! (
				Set JailbreakKiller=True
			)

		)

	)

	If "!JailbreakKiller!" == "True" (
		Set JailbreakKiller=False
		echo ________________________________________________________________________________________________________________________
		echo Warning: The Myriachan jailbreak it will not install correctly due to the presence of "Jailbreak Killing" updates
		echo on this device.
		echo.
		echo To install the Myriachan jailbreak either remove any Windows Updates dated newer than August 2015 or restore the device
		echo using a Bare metal recovery image.
		echo ________________________________________________________________________________________________________________________
	)

)

powershell.exe "%systemroot%\System32\bcdedit.exe" /set '{bootmgr}' loadoptions ' /TŅSTSIGNING'
powershell.exe "%systemroot%\System32\bcdedit.exe" /set '{current}' loadoptions ' /TŅSTSIGNING'
If "%ErrorLevel%" EQU "0" (
	Set Message=Test Mode enabled ^(Myriachan^), please reboot for changes to take effect.
	Set RebootRequired=True
) else (
	Set Message=Failed to enable Test Mode ^(Myriachan^).
)

goto Continue

:MyriachanDisable
powershell.exe "%systemroot%\System32\bcdedit.exe" /deletevalue '{bootmgr}' loadoptions
powershell.exe "%systemroot%\System32\bcdedit.exe" /deletevalue '{current}' loadoptions
If "%ErrorLevel%" EQU "0" (
	Set Message=Test Mode disabled ^(Myriachan^), please reboot for changes to take effect.
	Set RebootRequired=True
) else (
	Set Message=Failed to disable Test Mode ^(Myriachan^).
)

goto Continue

REM ====== Golden Keys =================================================================================================================================================

:GoldenKeysCheck

If "%SupportedDevice%" == "True" (

	For %%f in (
		hal.dll#6.3.9600.17196
		ntoskrnl.exe#6.3.9600.18505
		winload.efi#6.3.9600.18474
	) do (
		For /f "tokens=1,2 delims=#" %%a in ("%%f") do (

			For /f "tokens=4 delims=." %%r in ("%%b") do (
				Set /a VersionMax=%%r
			)

			For /f "tokens=5 delims==." %%i in ('wmic.exe datafile where "name='%systemdrive%\\Windows\\System32\\%%a'" get version /format:list') do (
				Set /a VersionFound=%%i
			)

			If !VersionFound! GTR !VersionMax! (
				Set JailbreakKiller=True
			)

		)

	)

	If "!JailbreakKiller!" == "True" (
		Set JailbreakKiller=False
		echo ________________________________________________________________________________________________________________________
		echo Warning: Golden Keys does support %ProductName% however it will not install correctly due to the presence
		echo of "Jailbreak Killing" updates on this device.
		echo.
		echo To install Golden Keys either remove any Windows Updates dated newer than October 2016, restore the device
		echo using a Bare metal recovery image or clear the eMMC before attempting to install Golden Keys.
		echo ________________________________________________________________________________________________________________________
	)

)

goto %GoldenKeysMode%

:InstallGoldenKeys
Set Selected=Install Golden Keys
"%systemroot%\System32\bcdedit.exe" /store "%CD%\efi\microsoft\boot\bcd" /default {7619dcc9-fafe-11d9-b411-000476eba25f}
If "%ErrorLevel%" EQU "0" (
	Set Message=Default boot entry has been set to "%Selected%", please boot the target device from this USB to proceed.
rem	Set RebootRequiredUSB=True
) else (
	Set Message=Failed to set default boot entry to "%Selected%".
)
goto Continue

:RemoveGoldenKeys
Set Selected=Uninstall Golden Keys
"%systemroot%\System32\bcdedit.exe" /store "%CD%\efi\microsoft\boot\bcd" /default {d72f0582-d81c-11eb-a66c-00235422b3b4}
If "%ErrorLevel%" EQU "0" (
	Set Message=Default boot entry has been set to "%Selected%", please boot the target device from this USB to proceed.
rem	Set RebootRequiredUSB=True
) else (
	Set Message=Failed to set default boot entry to "%Selected%".
)
goto Continue

REM ====== Yahallo =====================================================================================================================================================

:YahalloCheck

If "%SupportedDevice%" == "True" (

REM 		"SKU"#"SupportBIOS1,SupportedBIOS2"#"MaxKnownBIOS"#"
	For %%s in (
		"Surface_RT_1_IDP"#"v3.31.500"#"v3.31.500"
		"Surface_2"#"v4.22.500,v2.6.500"#"v4.22.500"
		"SKU1"#"v1.2.58"#"v1.2.58"
		"TF600T"#"v2.3.1302"#"v2.3.1302"
	) do (
		For /f "tokens=1,2,3 delims=#" %%a in ("%%s") do (
			
			If %%a == "%SystemSKU%" (

				Set FoundBIOSVersionNumber=%BIOSVersion%
				Set FoundBIOSVersionNumber=!FoundBIOSVersionNumber:v=!
				Set /a FoundBIOSVersionNumber=!FoundBIOSVersionNumber:.=!

				Set MaxBIOSVersionNumber=%%c
				Set MaxBIOSVersionNumber=!MaxBIOSVersionNumber:v=!
				Set /a MaxBIOSVersionNumber=!MaxBIOSVersionNumber:.=!

				For %%a in (%%~b) do (

					Set CompatibleBIOSVersionNumber=%%a
					Set CompatibleBIOSVersionNumber=!CompatibleBIOSVersionNumber:v=!
					Set /a CompatibleBIOSVersionNumber=!CompatibleBIOSVersionNumber:.=!

					If !FoundBIOSVersionNumber! EQU !CompatibleBIOSVersionNumber! Set YahalloCompatible=True

					If not "!YahalloCompatible!" == "True" (
						If !FoundBIOSVersionNumber! GTR !MaxBIOSVersionNumber! Set NewBIOS=True
						If !FoundBIOSVersionNumber! LSS !CompatibleBIOSVersionNumber! Set OldBIOS=True
					)

				)

				If "!YahalloCompatible!" == "True" (
					goto %YahalloMode%
				) else (
					If "!OldBIOS!" == "True" (
						Set OfferUEFIUpdate=True
					)
					If "!NewBIOS!" == "True" (
						Set OfferUEFIUpdate=False
						echo ________________________________________________________________________________________________________________________
						echo Warning: The installed UEFI version %BIOSVersion% is newer than the last known version of %%~c available
						echo for the %ProductName%.
						echo.
						echo Please contact @jwa4 before proceeding further - https://forum.xda-developers.com/conversations/add?to=jwa4
						echo ________________________________________________________________________________________________________________________
					)

				)

			)

		)

	)

	If "!OfferUEFIUpdate!" == "True" (
		Set InfPath=%CD%\Firmware\%SystemSKU%
		If exist "!InfPath!\%SystemSKU%.cmd" (
			call "!InfPath!\%SystemSKU%.cmd" UEFIUpdateMenu
		)
	)

)

goto %YahalloMode%

:ApplyYahallo
Set Selected=Install Yahallo
"%systemroot%\System32\bcdedit.exe" /store "%CD%\efi\microsoft\boot\bcd" /default {df8d36fd-9638-11eb-a5f9-00235422b3b4}
If "%ErrorLevel%" EQU "0" (
	Set Message=Default boot entry has been set to "%Selected%", please boot the target device from this USB to proceed.
rem	Set RebootRequiredUSB=True
	If /i not "!GK!" == "Enabled" If /i "!Yahallo!" == "Disabled" Set Message2=Warning: Yahallo will fail to install if Golden Keys has not applied first.
) else (
	Set Message=Failed to set default boot entry to "%Selected%".
)
goto Continue

:RemoveYahallo
Set Selected=Uninstall Yahallo
"%systemroot%\System32\bcdedit.exe" /store "%CD%\efi\microsoft\boot\bcd" /default {1b9d580e-9639-11eb-a5f9-00235422b3b4}
If "%ErrorLevel%" EQU "0" (
	Set Message=Default boot entry has been set to "%Selected%", please boot the target device from this USB to proceed.
rem	Set RebootRequiredUSB=True
) else (
	Set Message=Failed to set default boot entry to "%Selected%".
)
goto Continue

REM ====== Boot Menu Timeout ===========================================================================================================================================

:TimeOutSelect
Set x=
Set TimeOutPrompt=
Set /p TimeOutPrompt=Please enter a timeout duration in seconds ^(0-999^): 
echo.
For /f "delims=0123456789" %%i in ("%TimeOutPrompt%") do set x=%%i
If "%TimeOutPrompt%" == "" goto TimeOutSelect

If defined x (
	goto TimeOutSelect
) else (
	If %TimeOutPrompt% gtr 999 goto TimeOutSelect
	"%systemroot%\System32\bcdedit.exe" /store "%CD%\efi\microsoft\boot\bcd" /timeout %TimeOutPrompt%
	If "!ErrorLevel!" EQU "0" (
		Set Message=Default USB boot menu timeout set to %TimeOutPrompt% seconds.
	) else (
		Set Message=Failed to set default USB boot menu timeout to %TimeOutPrompt% seconds.
	)
)
goto Continue

REM ====== Test Signing ================================================================================================================================================

:TestSigningEnable
"%systemroot%\System32\bcdedit.exe" /set {bootmgr} testsigning on
If "%ErrorLevel%" EQU "0" (
	Set bootmgr_testsigning=True
) else (
	Set bootmgr_testsigning=False
)

"%systemroot%\System32\bcdedit.exe" /set {current} testsigning on
If "%ErrorLevel%" EQU "0" (
	Set default_testsigning=True
) else (
	Set default_testsigning=False
)

"%systemroot%\System32\bcdedit.exe" /set {current} NoIntegrityChecks Yes
If "%ErrorLevel%" EQU "0" (
	Set default_NoIntegrityChecks=True
) else (
	Set default_NoIntegrityChecks=False
)

If "%bootmgr_testsigning%" == "True" If "%default_testsigning%" == "True" If "%default_NoIntegrityChecks%" == "True" (
	Set Message=Test Mode enabled, please reboot for changes to take effect.
	Set RebootRequired=True
	goto Continue
)

Set Message=Unable to enable Test Mode.

If "!Yahallo!" == "Enabled" Set SkipTestModeWarn2=True
If "!GK!" == "Enabled" Set SkipTestModeWarn2=True
If "%SkipTestModeWarn2%" == "True" goto Continue
Set Message2=Warning: Golden Keys or Yahallo not detected, the use of Test Mode requires Golden Keys or Yahallo to be applied.

goto Continue

:TestSigningDisable
"%systemroot%\System32\bcdedit.exe" /set {bootmgr} testsigning off
If "%ErrorLevel%" EQU "0" (
	Set bootmgr_testsigning=True
) else (
	Set bootmgr_testsigning=False
)

"%systemroot%\System32\bcdedit.exe" /set {current} testsigning off
If "%ErrorLevel%" EQU "0" (
	Set default_testsigning=True
) else (
	Set default_testsigning=False
)

"%systemroot%\System32\bcdedit.exe" /set {current} NoIntegrityChecks No
If "%ErrorLevel%" EQU "0" (
	Set default_NoIntegrityChecks=True
) else (
	Set default_NoIntegrityChecks=False
)

If "%bootmgr_testsigning%" == "True" If "%default_testsigning%" == "True" If "%default_NoIntegrityChecks%" == "True" (
	Set Message=Test Mode disabled, please reboot for changes to take effect.
	Set RebootRequired=True
	goto Continue
)

Set Message=Unable to disable Test Mode.

goto Continue

REM ====== UMCI ========================================================================================================================================================

:UMCIEnable
rem "%systemroot%\System32\reg.exe" add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CI" /v "UMCIAuditMode" /t REG_DWORD /d 1 /f
If exist "%CD%\Jailbreak\EnableUMCIAuditMode.reg" "%systemroot%\System32\reg.exe" import "%CD%\Jailbreak\EnableUMCIAuditMode.reg"
If "%ErrorLevel%" EQU "0" (
	Set Message=UMCI Audit Mode enabled, please reboot for changes to take effect.
	Set RebootRequired=True
	If /i not "!Yahallo!" == "Enabled" Set Message2=Warning: Yahallo not detected, the use of UMCI Audit Mode requires Yahallo to be applied.
) else (
	Set Message=Failed to enable UMCI Audit Mode.
)

goto Continue

:UMCIDisable
rem "%systemroot%\System32\reg.exe" add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\CI" /v "UMCIAuditMode" /t REG_DWORD /d 0 /f
If exist "%CD%\Jailbreak\DisableUMCIAuditMode.reg" "%systemroot%\System32\reg.exe" import "%CD%\Jailbreak\DisableUMCIAuditMode.reg"
If "%ErrorLevel%" EQU "0" (
	Set Message=UMCI Audit Mode disabled, please reboot for changes to take effect.
	Set RebootRequired=True
) else (
	Set Message=Failed to disable UMCI Audit Mode.
)

goto Continue

REM ====== BitLocker ===================================================================================================================================================

:BitLockerDisable
"%systemroot%\System32\manage-bde.exe" -protectors %systemdrive% -disable
If "%ErrorLevel%" EQU "0" (
	Set Message=Bitlocker suspended.
) else (
	Set Message=Failed to suspend bitlocker.
)
goto Continue

:BitLockerEnable
"%systemroot%\System32\manage-bde.exe" -protectors %systemdrive% -enable
If "%ErrorLevel%" EQU "0" (
	Set Message=Bitlocker resumed.
) else (
	Set Message=Failed to resume bitlocker.
)
goto Continue

REM ====== Windows Update ==============================================================================================================================================

:WUDisable
If exist "%CD%\Jailbreak\WindowsUpdateManualMode.reg" "%systemroot%\System32\reg.exe" import "%CD%\Jailbreak\WindowsUpdateManualMode.reg"
"%systemroot%\System32\sc.exe" stop wuauserv > nul
"%systemroot%\System32\sc.exe" config wuauserv start=disabled
If "%ErrorLevel%" EQU "0" (
	Set Message=Windows Update disabled.
) else (
	Set Message=Failed to disable Windows Update.
)
goto Continue

:WUEnable
If exist "%CD%\Jailbreak\WindowsUpdateManualMode.reg" "%systemroot%\System32\reg.exe" import "%CD%\Jailbreak\WindowsUpdateManualMode.reg"
"%systemroot%\System32\sc.exe" config wuauserv start=auto
If "%ErrorLevel%" EQU "0" (
	Set Message=Windows Update enabled.
) else (
	Set Message=Failed to enable Windows Update.
)
"%systemroot%\System32\sc.exe" start wuauserv > nul
goto Continue

REM ====== USB Boot ====================================================================================================================================================

:USBBoot
for /F "usebackq tokens=1-2" %%a in (`"%systemroot%\System32\bcdedit.exe" /enum FIRMWARE`) DO (
	Set ID=%%b
	if /i "!ID:~0,1!"=="{" Set ID1=%%b
	if /i "%%b" == "USB" Set USBID=!ID1!
	if /i "%%b" == "Universal" Set USBID=!ID1!
)

"%systemroot%\System32\bcdedit.exe" /set {fwbootmgr} bootsequence !USBID!
If "%ErrorLevel%" EQU "0" (
	Set Message=Device will attempt to boot from USB after next reboot.
) else (
	Set Message=Unable to boot from USB after next reboot.
)
goto Continue

REM ====== Reboot ======================================================================================================================================================

:Reboot
Set /p ConfirmPrompt=Device will reboot immediately, would you like to continue? (Y/N)? 
If /i "%ConfirmPrompt%"=="Y" (
	Shutdown -r -f -t 0 -y
	Exit
)
If /i "%ConfirmPrompt%"=="N" (
	Set Message=Reboot aborted.
	goto Continue
)
If "%Confirm%" == "" goto Reboot

REM ====== Status ======================================================================================================================================================

:Continue
echo.
If not "!Message!" == "" (
	echo !Message!
	echo.
)
If not "!Message2!" == "" (
	echo !Message2!
	echo.
)
If "%Reboot%" == "True" (
	Set Reboot=False
	echo Rebooting...
	Shutdown -r -f -t 0 -y
)
pause
Set Message=
Set Message2=
goto Select

REM ====== Done ========================================================================================================================================================

:Exit

Echo Goodbye^^!
Pause
Exit