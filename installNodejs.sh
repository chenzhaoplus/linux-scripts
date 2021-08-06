#!/bin/bash
#Author xusj
#Date 2020.6.16

curDir=$(cd $(dirname $0); pwd)
appDir="/ops/app/"

nodejs(){
tar -xf $curDir/node-v10.14.1-linux-x64.tar -C $appDir/
ln -s $appDir/node-v10.14.1-linux-x64/bin/node /usr/local/bin/node
ln -s $appDir/node-v10.14.1-linux-x64/bin/npm /usr/local/bin/npm
}
nodejs

if [ $? == 0 ];then
echo -e "\e[0;32;1m===Nodejs安装完成===\e[0m"
fi
