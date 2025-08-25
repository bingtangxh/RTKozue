@echo off
@setlocal enableextensions
@setlocal EnableDelayedExpansion
@cd /d "%~dp0"

@Title Office 2013 RT HSP Update Pack

echo Please wait...

REM ====== Check architecture ==========================================================================================================================================

If not "%PROCESSOR_ARCHITECTURE%" == "ARM" (
	echo Error: Using this update packake on %PROCESSOR_ARCHITECTURE% systems is not supported.
	echo Please retry on an ARM system.
	goto Exit
)

REM ====== Check Windows Version =======================================================================================================================================

For /f "usebackq skip=2 tokens=2-4 delims==. " %%a in (`wmic os get Version /format:list`) do (
	Set /a WinVerMajor=%%a
	Set /a WinVerMinor=%%b
	Set /a WinVerBuild=%%c
	goto BuildNumber
)
:BuildNumber

For /f "tokens=5 delims==." %%a in ('wmic datafile where "name='%HomeDrive%\\Windows\\System32\\ntoskrnl.exe'" get version /format:list') Do (
	Set WinVerNtoskrnl=%%a
)

If %WinVerMajor% EQU 6 (
	If %WinVerBuild% EQU 9600 (
		If %WinVerNtoskrnl% GEQ 17053 (
			Set Supported=True
		)
	)
)

If not "%Supported%" == "True" (
	echo Error: This update package is for use on Windows RT 8.1 IR5 only.
	goto Exit
)

REM ====== Check if being run as admin =================================================================================================================================

For /f "tokens=1,2,3,4 USEBACKQ delims=," %%a in (`"%SystemRoot%\System32\whoami.exe /groups /fo csv /nh"`) Do (
	If %%c == "S-1-16-12288" Set RunAsAdmin=True
)

If not "%RunAsAdmin%" == "True" (
	echo Error: Please run as administrator.
	goto Exit
)

REM ====== Check only one instance is running ==========================================================================================================================

9>&2 2>nul (Call :LockAndRestoreStdErr %* 8>>"%~f0") || (
	echo Error: Only one instance allowed - "%~f0" is already running >&2
)
goto Exit

:LockAndRestoreStdErr
Call :SingleInstance %* 2>&9
exit /b 0

:SingleInstance

REM ====== Menu ========================================================================================================================================================

:Office2013RTInstallSelect
cls
echo ______________________________________________
echo.
echo Office 2013 RT Home ^& Student Plus Update Pack
echo ______________________________________________
echo.
echo This update package will update a Windows RT 8.1 IR5 installation with all
echo Chinese Office updates to May 2023.
echo.
echo Please do not close this window or attempt to use Office while installation
echo is in progress. Installation of these updates may take up to 30 minutes.
echo ________________________________________________________________________________
echo.
Set /p Office2013RT_Prompt=Would you like to install Office 2013 RT Home ^& Student Plus Updates (Y/N)? 
If /i "%Office2013RT_Prompt%"=="Y" goto Office2013RTUpdate
If /i "%Office2013RT_Prompt%"=="N" goto Exit
goto Office2013RTInstallSelect

:Office2013RTUpdate

Set Office2013RT_Patches=%CD%\Updates

For %%a in ("%Office2013RT_Patches%\*.msp") do (
	Set /a Office2013RT_Total+=1
)

For /f "USEBACKQ delims=|" %%f in (`dir /b /od "%Office2013RT_Patches%\*.msp"`) do (
	Set /a Office2013RT_Count+=1
	echo.
	echo Installing Update: !Office2013RT_Count! of !Office2013RT_Total!
	echo %%f
	echo Please Wait...
	timeout 15 /nobreak > nul
	rem Start /b /wait /d "%Office2013RT_Patches%\" %%f /quiet /norestart
	"%Office2013RT_Patches%\%%f" /quiet /norestart

	If "!ErrorLevel!" EQU "1618" (
		echo Failed to install: %%~nxf
		echo Error: !ErrorLevel!
		echo Retrying...
		timeout 60 /nobreak > nul
		"%Office2013RT_Patches%\%%f" /quiet /norestart
	)

	If "!ErrorLevel!" NEQ "0" (
		echo Failed to install: %%~nxf
		echo Error: !ErrorLevel!
		goto Exit
	) else (
		echo Installed OK.
	)
)

For %%a in (
	%systemdrive%\Windows\Installer\$PatchCache$
) do (
	If exist "%%a\" (
		attrib -s -h -r /s /d "%%a\*.*" > nul
		del "%%a\*.*" /F /Q /S > nul
		rmdir /Q /S "%%a\" > nul
	)
)
echo ________________________________________________________________________________
If !Office2013RT_Count! EQU !Office2013RT_Total! (
	echo Installation Complete.
) else (
	echo Installation Failed.
)

REM ====== Done ========================================================================================================================================================

:Exit

echo ________________________________________________________________________________
echo.
Echo Goodbye
pause
exit
