### 前提条件是已安装了jdk8或者以上版本，mysql 版本 5.6.5+

### 执行安装脚本，脚本和安装文件放在一个目录下
`sh installNacos.sh`

### 在数据库里创建一个名称为 nacos 的数据库，然后执行路径下 /ops/app/nacos/conf/nacos-mysql.sql 文件到 nacos 数据库

### 启动单机版
`sh startup.sh -m standalone`

### 查看日志
`tail -500f /usr/local/nacos/logs/start.out`

### 关闭，在bin目录下执行
`sh shutdown.sh`