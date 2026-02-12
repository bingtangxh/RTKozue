@echo off
:uninstall
cls
cscript //nologo "%ospp%" /dstatus | findstr "LICENSE Last ---------------------------------------"
echo 以上是已经安装的密钥，请在下方输入要卸载的密钥后 5 位，例如“R3H4F” （不包括引号），然后按 Enter。
echo 确保输入正确，此处不检测输入是否正确。
echo Installed key(s) are above. Please type the last 5 chars of the key you want to uninstall.
echo Then press Enter, here doesn't verify if the raw input is valid.
echo.
set p=
set /p "p=RTKozue>"
cls
cscript //nologo "%ospp%" /unpkey:%p%
echo.
echo 卸载完成，继续吗？
echo Uninstallation complete. Continue?
choice /m "是否继续卸载下一个密钥？"
if errorlevel 2 goto end
if errorlevel 1 goto uninstall
:end
pause