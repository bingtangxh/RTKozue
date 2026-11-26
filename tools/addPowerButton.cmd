@echo off
set isPowerUpdate=0
systeminfo | find "KB2919355" && set isPowerUpdate=1
if %isPowerUpdate%==1 (
    echo.
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher" /v "Launcher_ShowPowerButtonOnStartScreen" /t REG_DWORD /d 1 /f
    echo.
) else (
    echo 你的系统没有安装 KB2919355。
    echo 你需要先安装 KB2919442 和 KB2919355。
    echo KB2919442 ^& KB2919355 is required.
    echo.
    echo 请去别处找，微软官网不给下载 RT 用的任何离线安装的补丁，它说只能从 Windows 更新获取。
    echo It's not available on Microsoft official website, please look for it anywhere else.
    echo.
)
pause