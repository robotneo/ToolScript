@echo off
rem 2017/4/23 ��д
rem �ر�wv2ray�����������
rem stop

title v2ray�˳�����
color 0a
rem ��������������
echo.
tasklist|findstr "wv2ray.exe"
echo.
taskkill /f /im wv2ray.exe
rem if "%errorlevel%"==0
echo.
IF ERRORLEVEL 1 goto 1
IF ERRORLEVEL 0 goto 0
Rem ��������в��ɽ���λ�ã�����ʧ����Ҳ��ʾ�ɹ���
:0
echo ����ִ�гɹ�,�ѹر�v2ray����
Rem ����ִ�������������exit���˳�
goto exit
:1
echo ����ִ��ʧ��,�ý��̲����ڻ�ǰ��������״̬��
Rem ����ִ�������������exit���˳�
goto exit
:exit
echo.
pause