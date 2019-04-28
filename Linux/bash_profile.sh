OS_version=''
if  grep -q 'release 6' /etc/redhat-release ; then
        OS_version='CentOS6'
else 
        OS_version='CentOS7'
fi
  
echo -e "#################################Server INFO#################################################"
hostname=`hostname` 
echo -e "HostName    =  $hostname"
  
osinfo=`cat /etc/redhat-release` 
echo -e "OS info      =  $osinfo"
  
kernelinfo=`uname -r` 
echo -e "LinuxKernel  =  $kernelinfo"
  
kernelmac=`uname -m` 
echo -e "HW Machine  =  $kernelmac"
  
CPU=`cat /proc/cpuinfo | grep "model name" | head -n 1 | awk -F ":" "{print $2}"` 
echo -e "CPU info    =  $CPU"
  
if [ ${OS_version} == 'CentOS6' ];then
        network=`ifconfig -a  | awk 'BEGIN {FS="\n"; RS=""} {print $1,$2}' | grep -v 'lo' |  awk '{print "\t\t"$1,$7}'` 
else
        network=`ifconfig -a  | awk 'BEGIN {FS="\n"; RS=""} {print $1,$2}' | grep -v 'lo' |  awk '{print "\t"$1,$6}'` 
fi
  
echo -e "NetWork info = $network"
  
externalip=$(timeout 3 curl -s ipecho.net/plain;echo) 
[ $? -ne 0 -o 'X' == "$externalip"X ] && externalip='No outside network or ACL drop'
echo -e "External IP  =  $externalip"
  
echo -e "---------------------------------------------------------------------------------------------"
  
Username=`whoami` 
echo -e "UserName    =  $Username"
  
echo -e "UserHomeDir =  $HOME"
  
echo -e "---------------------------------------------------------------------------------------------"

echo -ne "\033[0;32m"
cat<<EOT
                                  _oo0oo_
                                 088888880
                                 88" . "88
                                 (| -_- |)
                                  0\ = /0
                               ___/'---'\___
                             .' \\\\|     |// '.
                            / \\\\|||  :  |||// \\
                           /_ ||||| -:- |||||- \\
                          |   | \\\\\\  -  /// |   |
                          | \_|  ''\---/''  |_/ |
                          \  .-\__  '-'  __/-.  /
                        ___'. .'  /--.--\  '. .'___
                     ."" '<  '.___\_<|>_/___.' >'  "".
                    | | : '-  \'.;'\ _ /';.'/ - ' : | |
                    \  \ '_.   \_ __\ /__ _/   .-' /  /
                ====='-.____'.___ \_____/___.-'____.-'=====
                                  '=---='
  
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                       佛祖保佑   永不宕机   永无BUG
EOT
echo -ne "\033[m"
