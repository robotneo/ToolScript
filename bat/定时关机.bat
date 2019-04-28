@echo off

REM 定时关机程序
REM 3600表示倒计时

set /p time=请输入时间:
shutdown -s -t "%time%"
echo.&echo 离关机还有: "%time%" 秒

pause