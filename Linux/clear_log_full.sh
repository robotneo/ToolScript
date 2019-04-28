#!/bin/bash
#Filename:clean_log.sh
#Datetime:2017-08-24 17:32
#Discription:Clean certain of unused log in the directory /var/log/v2ray/

LOG_DIR=/var/log/v2ray
ROOT_UID=0		# $UID为0的时候,用户才具有root用户的权限
LINES=50		# 默认的保存行数
E_XCD=66		# 不能修改目录?
E_NOTROOT=67	# 非root用户将以error退出

# 当然要使用root用户来运行.
if [ "$UID" -ne "$ROOT_UID" ]
then
            echo "Must be root to run this script."
       exit $E_NOTROOT
fi

# if [ -n "$1" ]
# # 测试是否有命令行参数(非空). 
# then
#          lines=$1
#     else
#          lines=$LINES         # 默认,如果不在命令行中指定. 
# fi

# Stephane Chazelas 建议使用下边 
E_WRONGARGS=65 # 非数值参数(错误的参数格式) 

case "$1" in
"" ) lines=50;;
*[!0-9]*) echo "Usage: `basename $0` file-to-cleanup"; exit $E_WRONGARGS;;
* ) lines=$1;;
esac

cd $LOG_DIR

if [ `pwd` != "$LOG_DIR" ] # 或者 if[ "$PWD" != "$LOG_DIR" ]

# 不在 /var/log/v2ray中?
then
            echo "Can't change to $LOG_DIR."
         exit $E_XCD
fi # 在处理log file之前,再确认一遍当前目录是否正确.

# 更有效率的做法是: 
#
# cd /var/log/v2ray || {
# echo "Cannot change to necessary directory." >&2
# exit $E_XCD;
# }

tail -$lines access.log > access.temp      # 保存log file消息的最后部分. 
mv access.temp access.log                      # 变为新的log目录. 

# cat /dev/null > messages
#* 不再需要了,使用上边的方法更安全. 

cat /dev/null > error.log # ': > wtmp' 和 '> wtmp'具有相同的作用
echo "Logs cleaned up."

exit 0
# 退出之前返回0,
#+ 返回0表示成功.
