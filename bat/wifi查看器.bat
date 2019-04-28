REM 获取当前设备(电脑)的所有历史连接WIFI配置文件详细信息
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do @echo %j | findstr -i -v echo | netsh wlan show profiles %j key=clear
REM 把当前命令反馈信息重定向到wifi.txt文件中查看
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do @echo %j | findstr -i -v echo | netsh wlan show profiles %j key=clear > wifi.txt