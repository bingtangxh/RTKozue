@echo off
cls
echo 第一次会出现一个较大的窗口，表示已经重新安装了许可证文件。
echo 窗口可能太大，关掉它即可。
echo A large window is going to appear at first
echo Displaying that tokens files is re-installed. Just close it.
sc start W32Time
w32tm /resync
slmgr.vbs /rilc
echo.
echo 接下来几次都是确定即可。
@REM slmgr /ipk NG4HW-VH26C-733KW-K6F98-J8CK4
@REM 上面这个密钥是给 Li_zip 和宁南客务段的伪 8400RT 用的，不确定是否可用于其它系统
slmgr.vbs /ipk FNFKF-PWTVT-9RC8H-32HB2-JB34X
slmgr.vbs /skms kms.03k.org
slmgr.vbs /ato
echo.
echo 如果提示成功，那么接下来请重启即可生效。
echo.
echo 出错的话，那就重启之后再来一次。
echo If success, reboot. If failed, reboot and try again.
echo.
choice /m "是否立即重新启动？"
if errorlevel 2 goto end
if errorlevel 1 shutdown -r && goto end
:end