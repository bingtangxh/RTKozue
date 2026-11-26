@echo off
setlocal EnableExtensions EnableDelayedExpansion
title RTKozue - repartition
call "%~dp0..\common\init.cmd" "%~f0"
if errorlevel 1 exit /b 1
pushd "%RTK_ROOT%"
if errorlevel 1 exit /b 1

:expressRePart
cls
echo list disk >"%RTK_WORK%\dpst.txt"
echo exit >>"%RTK_WORK%\dpst.txt"
diskpart /s "%RTK_WORK%\dpst.txt"
echo 请输入你要重新分区的硬盘编号，通常是 0 ，但也请通过容量进行辨认。
echo 此处不检测你的输入是否正确，请谨慎。输入 -1 可返回。
echo 这会丢失硬盘上所有的数据！
echo Please type the number of disk which you want to repartition.
echo Usually 0 but you'd better verify if it's right thru the capacity.
echo Here doesn't verify if your raw input is valid. Type -1 to go back.
echo ALL OF THE DATA ON THE DISK WILL BE LOST !!!
echo.
set disk=
set /p "disk=>"
if "%disk%"=="-1" goto end

cls
wmic diskdrive list brief
echo.
echo 你确认你要重新分区的是 %disk% 吗？请再次输入以确认。输入 -1 可返回。
echo 这会丢失所有的数据！！
echo Are you sure the disk you want to repartition %disk% ?
echo Type the number again to ensure. Type -1 to go back.
echo YOU WILL LOSE ALL OF YOUR DATA ON THE DISK !!!
echo.
set disk1=
set /p "disk1=>"
if "%disk1%"=="-1" goto end
if not "%disk%"=="%disk1%" (
    echo.
    echo 你的两次输入不一致，请重新输入。
    echo Twice of your raw input does not match. Please try again.
    echo.
    pause
    goto expressRePart
)

cls
echo select disk %disk% >"%RTK_WORK%\dpst.txt"
echo clean>>"%RTK_WORK%\dpst.txt"
echo convert gpt>>"%RTK_WORK%\dpst.txt"

echo 请指定 EFI ESP 分区的大小。如留空，则默认为 250MiB 。
echo 如果要在该分区中放置用于启动 Linux 系统的 bootfs 分区中的文件，就应该大于 250MiB 。
echo 输入大小（不要带单位，应该会是 MB），然后按 Enter。 例如 300MB 就输入 300。输入 -1 可返回。
echo 确保输入正确，此处不检测输入是否正确。
echo Please tell me the size of EFI ESP partition.
echo If give me a null input, then i shall use 250 MiB.
echo Just type a number without the unit like MB or GB, for example "300" for 300 MiB.
echo Then press Enter. Type -1 to go back. Here doesn't verify if the raw input is valid.
echo.
set size=250
set /p "size=>"
if "%size%"=="-1" goto end

echo create partition efi size=%size%>>"%RTK_WORK%\dpst.txt"
echo format quick fs=fat32 label="EFIESP">>"%RTK_WORK%\dpst.txt"
echo assign letter='Z'>>"%RTK_WORK%\dpst.txt"

:expressRePart1
cls
echo 是否创建 MSR 分区？ Do you want to create MSR partition ?
echo.
echo    [1] 是 Yes     [0] 否 No
echo.
echo 请输入你的选择，然后按 Enter 。输入 -1 可返回。
echo Type your choice then press Enter. Type -1 to go back.
echo.
set s=0
set /p "s=>"
if "%s%"=="1" (
    echo create partition msr size=128 >>"%RTK_WORK%\dpst.txt"
    goto expressRePart2
)
if "%s%"=="0" goto expressRePart2
if "%s%"=="-1" goto end
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto expressRePart1

:expressRePart2
cls
echo 是否创建恢复环境分区？ Do you want to create WinRE partition ?
echo.
echo    [1] 是 Yes     [0] 否 No
echo.
echo 请输入你的选择，然后按 Enter 。输入 -1 可返回。
echo Type your choice then press Enter. Type -1 to go back.
echo.
set s=0
set /p "s=>"
if "%s%"=="1" (
    echo create partition primary size=310 >>"%RTK_WORK%\dpst.txt"
    echo format quick fs=ntfs label="Windows RE tools" >>"%RTK_WORK%\dpst.txt"
    echo assign letter="R" >>"%RTK_WORK%\dpst.txt"
    echo set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac >>"%RTK_WORK%\dpst.txt"
    echo gpt attributes=0x8000000000000001 >>"%RTK_WORK%\dpst.txt"
    goto expressRePart3
)
if "%s%"=="0" goto expressRePart3
if "%s%"=="-1" goto end
echo.
echo 你的输入有误，请重新输入。Your input is incorrent.
echo.
pause
goto expressRePart2

:expressRePart3
echo create partition primary >>"%RTK_WORK%\dpst.txt"
echo format quick fs=ntfs override label="Windows" >>"%RTK_WORK%\dpst.txt"
echo assign letter='C' >>"%RTK_WORK%\dpst.txt"
echo exit>>"%RTK_WORK%\dpst.txt"

diskpart /s "%RTK_WORK%\dpst.txt"

echo.
echo 重新分区完成。 Repartition complete.
echo 所有数据已经丢失。 All of the data is lost.
echo.
pause
goto end

:end
if exist "%RTK_WORK%\EnableLinux.txt" del /q "%RTK_WORK%\EnableLinux.txt"
if exist "%RTK_WORK%\disableUAC.reg" del /q "%RTK_WORK%\disableUAC.reg"
if exist "%RTK_WORK%\dpst.txt" del /q "%RTK_WORK%\dpst.txt"
rd "%RTK_WORK%" >nul 2>&1
popd
endlocal
exit /b
