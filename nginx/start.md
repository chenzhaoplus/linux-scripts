# 准备nginx包
http://nginx.org/download/nginx-1.16.1.tar.gz

下载后放到 /ops/inst 路径下

# 启动、停止nginx
```shell script
cd /usr/local/nginx/sbin/
./nginx 
./nginx -s stop
./nginx -s quit
./nginx -s reload
```

# 重启 nginx
```shell script
./nginx -s quit
./nginx
```

# 重新加载配置文件
```shell script
./nginx -s reload
```

# 验证配置文件有没有问题
```shell script
./nginx -t
```
