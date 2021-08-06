#!/bin/bash
#Author: xusj
#Date: 2020.6.22

source /etc/profile
installHarbor(){
curDir=`pwd`
appDir="/ops/app"
localIp=`ifconfig |grep -v br- |grep -v lo |grep -v docker |grep -v veth |grep -A1 flags |grep inet |awk '{print $2}'`
mkdir -p /ops/data/harbor
tar -xf $curDir/harbor-offline-installer-v2.0.0.tgz -C  $appDir/

cp -rp /ops/app/harbor/harbor.yml.tmpl /ops/app/harbor/harbor.yml
sed -i "s|hostname: reg.mydomain.com|hostname: $localIp|g" /ops/app/harbor/harbor.yml
sed -i "s|data_volume: /data|data_volume: /ops/data/harbor|g" /ops/app/harbor/harbor.yml
sed -i "13,18d" /ops/app/harbor/harbor.yml

cd $appDir/harbor/
cd /ops/app/harbor/ && ./install.sh
if [ $? == 0 ];then
echo -e "\e[0;32;1mHarbor安装成功，请登录http://${localIp}进行验证\e[0m"
fi
}

installDocker() {
yum -y install yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
yum -y install docker-ce
service docker start

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://y0okr4ea.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

Ver=`docker -v`

if [ $? == 0 ];then
echo -e "\e[0;32;1m${Ver} install Success!\e[0m"
fi
}

installDockerCompose(){
yum -y install epel-release docker-compose
}
installDocker && installDockerCompose 
installHarbor
