@echo off

REM ��ʱ�ػ�����
REM 3600��ʾ����ʱ

set /p time=������ʱ��:
shutdown -s -t "%time%"
echo.&echo ��ػ�����: "%time%" ��

pause