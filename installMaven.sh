#!/bin/bash
#Author xusj
#Date 2020.6.16

curDir=$(cd $(dirname $0); pwd)
appDir="/ops/app/"
MAVEN_HOME="$appDir/maven"

tar -xf $curDir/apache-maven-3.5.2.tar.gz -C $appDir/
ln -s $appDir/apache-maven-3.5.2 $appDir/maven

echo "export MAVEN_HOME=$appDir/maven" >> /etc/profile
echo "export PATH=${MAVEN_HOME}/bin:${PATH}" >> /etc/profile

source /etc/profile

if [ $? == 0 ];then
echo -e "\e[0;32;1m===`mvn -v`安装完成===\e[0m"
fi
