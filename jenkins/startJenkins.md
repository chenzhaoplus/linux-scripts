### 从yum里面安装jenkins

### 检查是否占用了8080端口
netstat -nlpt | grep -E "8080"

### 修改脚本文件里jdk环境变量的路径
JAVA_HOME=/usr/java/jdk1.8.0_144

### 执行脚本
`./yumInstallJenkins.sh`

### 启动命令
`systemctl daemon-reload`
`systemctl start jenkins`

### 重启命令
`systemctl restart jenkins`

### 访问地址
`http://v86:8080`

### 查看 admin 账户密码
`cat /var/lib/jenkins/secrets/initialAdminPassword`