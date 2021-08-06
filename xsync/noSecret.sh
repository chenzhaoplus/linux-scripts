#!/bin/bash
#Author cz
#Date 2020.9.5
#免密码登录其他服务器

start(){
  ssh-keygen -t rsa
  ssh-copy-id ${1}
  xsync.sh /root/.ssh
}

start ${1}