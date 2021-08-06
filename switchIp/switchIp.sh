#!/bin/bash
#Author cz
#Date 2020.8.2

#网络配置脚本文件地址
bakPath="/ops/bak/"
netWorkFileName="ifcfg-ens33"
hostFileName="hosts"
networkScripts="/etc/sysconfig/network-scripts/${netWorkFileName}"

#备份原有网络配置，并重写网络配置
rewriteScripts(){
  bakNetworkScript
  fileExist ${bakPath}${netWorkFileName}_${ipaddr}
  if [ $? -eq 0 ];then
    #如果不存在此ip的网络配置，则重写一个
cat>${networkScripts}<<EOF
TYPE=Ethernet
BOOTPROTO=static
NAME=ens33
DEVICE=ens33
ONBOOT=yes
IPADDR=${ipaddr}
GATEWAY=${gateway}
NETMASK=${netmask}
DNS1=${dns1}
DNS2=${dns2}
EOF
  else
    #如果存在此ip的网络配置，把之前备份过的此ip配置还原
    cp ${bakPath}${netWorkFileName}_${ipaddr} ${networkScripts}
  fi
}

bakNetworkScript(){
  #获取网络配置脚本的 IPADDR 这行字符串
  gfc=`grepFileContent ${networkScripts} "IPADDR"`
  #用 = 分隔 IPADDR ，获得ip
  ipaddress=`splitByChar ${gfc} "=" 1`
  #如果已经存在这个脚本的ip作为名称后缀的备份，则不备份
  fileExist ${bakPath}${netWorkFileName}_${ipaddress}
  if [ $? -eq 0 ];then
    #备份文件的名字使用脚本内容里的ip作为后缀
    cp ${networkScripts} ${bakPath}
    mv ${bakPath}${netWorkFileName} ${bakPath}${netWorkFileName}_${ipaddress}
  fi
}

#搜索文件内容
#参数1：文件路径
#参数2：搜索的关键字
grepFileContent(){
  g=`grep $2 $1`
  echo $g
}

#按指定字符分隔字符串
#参数1：被分割的字符串
#参数2：指定的字符
#参数3：返回数组第几个元素，从0开始
splitByChar(){
  array=(${1//${2}/ })
  echo ${array[${3}]}
}

restartNetwork(){
  service network restart
}

#备份原有hosts文件，并重写hosts
switchHosts(){
  mv /etc/hosts ${bakPath}${hostFileName}
cat>/etc/hosts<<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

${hostPrefix}.${hostIpSuffix} vhost
EOF
  for((host=55;host<90;host++)); do
    echo "${hostPrefix}.${host} v${host}" >> /etc/hosts
  done
}

#判断文件是否存在，存在返回1，不存在返回0
#参数1： $1 表示文件路径
fileExist(){
  if [ ! -f $1 ];then
   return 0
  else
   return 1
  fi
}

#如果不存在目录则创建
#参数1：目录路径
dirExist(){
  if [ ! -d ${1}  ];then
    mkdir ${1}
  fi
}

#退出脚本
exitScript(){
  exit 1
}

#修改主机名称
#参数1：主机名称
modifyHostName(){
  hostnamectl set-hostname ${1}
}

#初始化变量值
initProperties(){
  dirExist ${bakPath}

  #设置默认值
  dns1=8.8.8.8
  dns2=222.85.85.85
  netmask="255.255.255.0"

  case "$1" in
    1)
      hostPrefix="172.16.0"
      hostIpSuffix="144"
      ipaddr="${hostPrefix}.${2}"
      gateway="172.16.0.2"
      netmask="255.255.254.0"
      ;;
    2)
      hostPrefix="192.168.3"
      hostIpSuffix="14"
      ipaddr="${hostPrefix}.${2}"
      gateway="192.168.3.1"
      ;;
    3)
      hostPrefix="192.168.1"
      hostIpSuffix="105"
      ipaddr="${hostPrefix}.${2}"
      gateway="192.168.1.1"
      ;;
    4)
      hostPrefix="192.168.0"
      hostIpSuffix="109"
      ipaddr="${hostPrefix}.${2}"
      gateway="192.168.0.1"
      ;;
    *)
      echo "请输入数字参数。"
      echo "参数1：切换网络的场景，1切换到Company；2切换到HUQUAN；3切换到LIUJIAOTING；4切换到NANHU"
      echo "参数2：切换网络的ip尾号"
      exitScript
      ;;
  esac
}

start(){
  initProperties ${1} ${2}
  modifyHostName v${2}
  fileExist ${networkScripts}
  if [ $? -eq 0 ];then
   echo "文件 ${networkScripts} 不存在"
  else
   rewriteScripts
   restartNetwork
   switchHosts
   echo "切换网络成功"
  fi
}

start ${1} ${2}
