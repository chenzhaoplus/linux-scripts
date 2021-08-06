# linux-scripts
linux centos sh scripts

### 执行脚本时如果报错 “/bin/bash^M: 坏的解释器”，执行下面命令去掉/r
####### build.sh 是脚本路径名称
`sed -i 's/\r$//' build.sh`

### 自定义ssh登录后欢迎信息
`
cat  >>  /etc/motd<< EOF
 欢迎
EOF
`