@echo off
rem 2017/4/23 ��д
rem ����v2ray����ű�
rem %~d0����ȡ��ǰ�̷�
rem %~dp0����ȡ��ǰ�̷���·��
rem %~sdp0����ǰ�̷���·���ļ�����ʽ
rem %~f0����ǰ�������ȫ·��
rem %cd%������CMDĬ��Ŀ¼

title v2ray��������
color 0a
start "v2ray" "%~dp0\wv2ray.exe"
rem ���ҽ���
rem tasklist|findstr "wv2ray.exe"
tasklist /fi "imagename eq wv2ray.exe"
echo.
echo.
echo ������v2ray����
echo.
pause