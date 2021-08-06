#!/bin/bash
#1.1 #设置yum源
cd /etc/yum.repos.d/
rename repo repo.bak *
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all && yum clean plugins && yum makecache

#1.2 初始化目录:
mkdir -p /ops && cd /ops
mkdir -p /ops/app
mkdir -p /ops/backup
mkdir -p /ops/bin
mkdir -p /ops/data
mkdir -p /ops/etc
mkdir -p /ops/inst
mkdir -p /ops/logs
mkdir -p /ops/tmp
mkdir -p /ops/var

#1.3 关闭防火墙和selinux:
systemctl stop firewalld.service
systemctl disable firewalld.service

sed -i s#SELINUX=enforcing#SELINUX=disabled#g /etc/selinux/config
setenforce 0 && getenforce

#关闭NetworkManager
systemctl disable NetworkManager
systemctl stop NetworkManager

#1.4  配置文件描述符
cat <<EOF >> /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536
* soft noproc 65536
* hard noproc 65536
EOF

#1.5 配置系统环境变量
#修改记录的历史命令数量：
sed -i s#HISTSIZE=1000#HISTSIZE=50000#g /etc/profile

#/etc/profile末尾添加如下内容：
echo "export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S'  `whoami`  "  >> /etc/profile

#关闭不必要的服务：
#CentOS7默认安装postfix，而不是sendmail
systemctl stop  postfix
systemctl disable  postfix
systemctl status  postfix

#安装必要工具包：
yum -y install epel-release && yum -y install gcc gcc-c++ telnet  lrzsz  vim  ansible htop net-tools bind-utils  ftp wget sysstat iotop iftop nc   ntpdate zip  unzip

#同步时间
yum -y install ntpdate && timedatectl set-timezone Asia/Shanghai && ntpdate ntp2.aliyun.com && hwclock --systohc
