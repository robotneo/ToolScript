精简版

#!/bin/bash             // 一个Bash脚本的正确的开头部分. 
#Filename:clean_full_log.sh
#Datetime:2010_12_23 11:43
#Discription:Clean unused log in the directory /var/log

LOG_DIR=/var/log
# 如果使用变量,当然比把代码写死的好.
cd $LOG_DIR
cat /dev/null > messages
cat /dev/null > wtmp
echo "Logs cleaned up."

exit                      # 这个命令是一种正确并且合适的退出脚本的方法.