@echo off
rem 2017/4/23 编写
rem 启动v2ray程序脚本
rem %~d0：获取当前盘符
rem %~dp0：获取当前盘符和路径
rem %~sdp0：当前盘符和路径文件名格式
rem %~f0：当前批处理的全路径
rem %cd%：当期CMD默认目录

title v2ray启动程序
color 0a
start "v2ray" "%~dp0\wv2ray.exe"
rem 查找进程
rem tasklist|findstr "wv2ray.exe"
tasklist /fi "imagename eq wv2ray.exe"
echo.
echo.
echo 已启动v2ray程序
echo.
pause