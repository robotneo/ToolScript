# 编写一个shell从test.dat文件中取出每一行的第一列作为目录名，在当前位置生成对应目录
#! /bin/sh 
SOURCE_FILE=$1
CURRENT_PATH=`pwd`
if [ -z $SOURCE_FILE ]; then
        echo "Error, no source file."
        exit 1
fi
while read line
do
        folder=`echo $line | awk '{print $1}'`
        mkdir -p $CURRENT_PATH/$folder
        if [ $? -ne 0 ]; then
                echo "Fail to mkdir $folder"
                exit 1
        fi
done < $SOURCE_FILE