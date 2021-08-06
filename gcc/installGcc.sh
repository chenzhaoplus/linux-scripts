#!/bin/bash
#离线安装gcc

tarPath="/ops/inst/gcc.tar.gz"
gccPath="/ops/app"

start(){
  tar -xf ${tarPath} -C ${gccPath}
  cd ${gccPath}/gcc
  rpm -Uvh *.rpm --nodeps --force
  echo "安装完成，请输入命令 gcc -v 看下gcc是否安装正常"
}

start