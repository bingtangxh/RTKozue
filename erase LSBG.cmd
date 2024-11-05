takeown /f C:\ProgramData\Microsoft\Windows\SystemData /r /d y
icacls C:\ProgramData\Microsoft\Windows\SystemData /grant %computername%\%username%:F /t /c
runas /user:%computername%\SYSTEM takeown /f C:\ProgramData\Microsoft\Windows\SystemData /r /d y
explorer C:\ProgramData\Microsoft\Windows\SystemData

takeown /f C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z /r /d y
icacls C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z /grant %computername%\%username%:F /t /c
rd /s /q C:\ProgramData\Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z
pause