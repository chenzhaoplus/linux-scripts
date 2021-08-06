#!/bin/bash
#Author cz
#Date 2020.8.1
#利用rsync命令同步不同服务器之间的文件夹

#1 获取输入参数个数，如果没有参数，直接退出$#表示输入参数
pcount=$#
if ((pcount==0)); then
echo no args;
exit;
fi

#2.获取文件名称，$1表示输入的第一个参数
p1=$1
fname=`basename $p1`
echo fname=$fname

#3 获取上级目录到绝对路径
pdir=`cd -P $(dirname $p1); pwd`
echo pdir=$pdir

#4获取当前用户名
user=`whoami`

for((host=81;host<84;host++)); do
echo ---------------v$host--------
rsync -rvl $pdir/$fname $user@v$host:$pdir
done