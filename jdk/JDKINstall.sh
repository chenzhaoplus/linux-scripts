#!/bin/bash
softDir=`pwd`
javaPath="/usr/java"
profile="/etc/profile"
JAVA_HOME="$javaPath/jdk1.8.0_144"
JAVA_BIN="$JAVA_HOME/bin"
if [ ! -d $javaPath ];then
    mkdir -p $javaPath
fi
rpm -qa|grep java |xargs rpm -e --nodeps
echo "Remove OpenJDK Sucess!" >> /dev/null

cd $softDir && tar -xf jdk-8u144-linux-x64.tar.gz  -C /usr/java/
echo "export JAVA_HOME=$javaPath/jdk1.8.0_144" >> $profile
echo "export JAVA_BIN=$JAVA_HOME/bin ">> $profile
echo "export PATH=$PATH:$JAVA_BIN">> $profile
echo "export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar ">> $profile
source /etc/profile
java -version
