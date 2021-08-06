#!/bin/bash
#Author: xusj
#Date: 2020/6/18

yum install -y yum-utils device-mapper-persistent-data lvm2
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
