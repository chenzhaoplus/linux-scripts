#!/bin/bash
#Auth: xusj
#Date: 2020/6/15

curDir=`pwd`
localIp=$(ifconfig | grep  inet | grep netmask | grep broadcast | awk '{print $2}' | sed -n '1p')
appDir="/ops/app/"
RedisDir="/ops/app/redis"
RedisConf=$RedisDir/redis.conf

installRedis() {
    tar -xf ${curDir}/redis-4.0.8.tar.gz -C $appDir
    ln -s $appDir/redis-4.0.8 $RedisDir
    cd $RedisDir
    make && make install
    cp -rp $RedisDir/src/redis-server $RedisDir/

    sed -i 's#bind 127.0.0.1#bind 0.0.0.0#g' $RedisConf
    sed -i 's#daemonize no#daemonize yes#g' $RedisConf

cat > /etc/systemd/system/redis.service << EOF
[Unit]
Description=Redis
After=network.target

[Service]
ExecStart=/ops/app/redis-4.0.8/redis-server /ops/app/redis-4.0.8/redis.conf  --daemonize no
ExecStop=/ops/app/redis-4.0.8/src/redis-cli -h 127.0.0.1 -p 6379 shutdown

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable redis
    systemctl start redis
}

installRedis
if [ $? == 0 ];then
    echo -e "\e[0;32;1m===redis安装完成===\e[0m"
fi
