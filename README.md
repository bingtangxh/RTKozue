# RTKozue

Windows RT 系统维护脚本集。按需要打开 `funcs` 文件夹，运行对应的 `.cmd` 文件，不再提供统一菜单。

请保留整个项目的目录结构。各功能脚本会自动请求管理员权限，使用项目根目录中的资源；`common` 文件夹是共用逻辑，不需要直接运行。可以从其他工作目录通过完整路径调用功能脚本。

## 功能入口

| 脚本 | 用途 | 使用环境 |
| --- | --- | --- |
| [allow7zip.cmd](funcs/allow7zip.cmd) | 修改注册表权限，允许 7-Zip 添加右键菜单 | 已安装的 Windows RT |
| [lockscreen.cmd](funcs/lockscreen.cmd) | 清理锁屏缓存并替换默认锁屏壁纸 | 已安装的 Windows RT |
| [switch-boot-manager.cmd](funcs/switch-boot-manager.cmd) | 切换 GRUB / Windows 启动管理器，必要时复制 GRUB 文件 | 已安装的 Windows RT；沿用磁盘 0、分区 1 和 B: 的假设 |
| [bitlocker.cmd](funcs/bitlocker.cmd) | 暂停、恢复、解除或查询 C: 的 BitLocker 保护 | 提供 `manage-bde` 的系统或恢复环境 |
| [add-power-button.cmd](funcs/add-power-button.cmd) | 在开始屏幕添加电源按钮 | 已安装相关补丁的 Windows RT 8.1 |
| [disable-uac.cmd](funcs/disable-uac.cmd) | 关闭用户账户控制 | 已安装的 Windows RT |
| [activate-windows.cmd](funcs/activate-windows.cmd) | Windows Embedded KMS 激活 | 适用的已安装 Windows RT 版本 |
| [convert-office.cmd](funcs/convert-office.cmd) | 将 Office RT 转换为 Office Pro Plus VL | 已安装的 Windows RT；需自备根目录下的 `ort2oppvl` 文件夹 |
| [activate-office.cmd](funcs/activate-office.cmd) | 激活 Office Pro Plus VL | 已安装的 Windows RT |
| [uninstall-office-key.cmd](funcs/uninstall-office-key.cmd) | 查询并卸载 Office 产品密钥 | 已安装的 Windows RT |
| [export-tokens.cmd](funcs/export-tokens.cmd) | 导出 tokens、注册表信息和产品密钥 | Windows RT Build 9200；使用根目录中的 `DPIDDC_ARM.exe` |
| [import-tokens.cmd](funcs/import-tokens.cmd) | 导入自备 tokens 文件夹至 C: 的 Windows | 建议在恢复环境中使用，具体前提见脚本提示 |
| [convert-windows.cmd](funcs/convert-windows.cmd) | 使用自备文件转换 Windows RT 8.1 SKU | 已安装的 Windows RT；需准备 `RT_8.1_LOB_APPX` 文件 |
| [enable-sideload.cmd](funcs/enable-sideload.cmd) | 启用侧载策略并关联 Appx 文件 | 已安装的 Windows RT |
| [repartition.cmd](funcs/repartition.cmd) | 重新分区，清除所选磁盘的数据 | 恢复环境；保留原有二次确认流程 |
| [backup.cmd](funcs/backup.cmd) | 将 C: 系统捕获或追加到 WIM 镜像 | 恢复环境 |
| [apply-image.cmd](funcs/apply-image.cmd) | 释放 WIM / SWM 系统镜像 | 恢复环境 |
| [repair-boot.cmd](funcs/repair-boot.cmd) | 通过 BCDBOOT 或 BOOTREC 修复引导 | 恢复环境 |
| [add-driver.cmd](funcs/add-driver.cmd) | 向离线系统递归添加驱动 | 恢复环境 |

脚本结束或选择退出后，当前功能退出。BitLocker 操作选择、备份类型、镜像索引和分步确认属于功能内部步骤，仍在对应脚本中保留。

Office 的三个相关脚本都会独立检测默认位置的 `OSPP.VBS`；未找到时要求输入路径，不需要先运行转换脚本。

## 目录与维护

- `funcs/`：19 个可直接运行的功能脚本，一个完整操作流程一个文件。
- `common/init.cmd`：共用的提权入口、项目根目录和临时工作目录初始化。
- `common/elevate.vbs`：请求以管理员身份重新启动所选功能脚本。
- `common/find-office.cmd`：共用的 Office 管理脚本定位逻辑。
- `texts/importTokens.txt`：tokens 导入功能的说明。

新增功能时，可沿用现有脚本的入口和 `:end` 清理结构。内部标签只用于本功能的步骤跳转；不要跳转到其他文件的标签。共用初始化不使用自己的 `setlocal`，它设置的变量由功能脚本最外层的 `setlocal` 管理，结束时一并恢复。

批处理中的中文继续使用现有的 GBK / CP936 编码。`.cmd`、`.bat`、`.vbs` 使用 CRLF 换行。

根目录原有的 `Office_Update.cmd`、`install.bat`、`runExploit.bat` 保持独立，未纳入本次拆分。

这次拆分保留了原脚本的大部分系统命令和目标路径，包括多处固定的 C: 路径。没有自动探测离线系统盘符；在恢复环境中应先确认盘符。Windows RT / WinRE 的实际磁盘、DISM、引导及激活操作仍需要在对应设备环境验证。
