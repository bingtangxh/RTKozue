@echo off
cls
copy nul allow7z.txt
echo HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Directory\shellex\DragDropHandlers [1 6 8 12 17]>>allow7z.txt
echo HKEY_CLASSES_ROOT\Drive\shellex\DragDropHandlers [1 6 8 12 17]>>allow7z.txt
regini allow7z.txt
start C:\"Program Files"\7-zip\7zFM.exe
echo.
echo 现在你再试一下， “添加 7-zip 到右键菜单” 应该可以勾上了。
echo Now you can try for another time, 
echo "Add 7-zip to context menu" should be able to be checked.
echo.
pause