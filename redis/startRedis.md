### 安装前要判断是否安装了gcc
`gcc -v`

### 安装文件和安装脚本需要放在一个目录下，然后cd到这个目录

### 执行安装脚本
`./installRedis.sh`

### 安装完成后默认开启了redis，redis启动命令
`systemctl start redis`
或者
`/ops/app/redis/redis-server /ops/app/redis/redis.conf`

### 进入redis客户端
`redis-cli`
###### 进入时指定ip和端口
`redis-cli -h v83 -p 6379`
###### 客户端查询时解决中文乱码问题
`redis-cli --raw`

### 常用命令
###### 查看所有key：		
`keys *`
###### 切换redis库：		
`select 库的id`
###### 删除命令：		
`DEL <keyname>`