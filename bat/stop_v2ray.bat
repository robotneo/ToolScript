@echo off
rem 2017/4/23 编写
rem 关闭wv2ray的批处理命令。
rem stop

title v2ray退出程序
color 0a
rem 查找完整进程名
echo.
tasklist|findstr "wv2ray.exe"
echo.
taskkill /f /im wv2ray.exe
rem if "%errorlevel%"==0
echo.
IF ERRORLEVEL 1 goto 1
IF ERRORLEVEL 0 goto 0
Rem 上面的两行不可交换位置，否则失败了也显示成功。
:0
echo 命令执行成功,已关闭v2ray程序！
Rem 程序执行完毕跳至标题exit处退出
goto exit
:1
echo 命令执行失败,该进程不存在或当前不在运行状态！
Rem 程序执行完毕跳至标题exit处退出
goto exit
:exit
echo.
pause