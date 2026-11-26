@echo off
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