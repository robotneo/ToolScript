REM ��ȡ��ǰ�豸(����)��������ʷ����WIFI�����ļ���ϸ��Ϣ
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do @echo %j | findstr -i -v echo | netsh wlan show profiles %j key=clear
REM �ѵ�ǰ�������Ϣ�ض���wifi.txt�ļ��в鿴
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do @echo %j | findstr -i -v echo | netsh wlan show profiles %j key=clear > wifi.txt