#!/bin/bash
#Auth: xusj
#Date: 2020/6/15
#3个节点集群使用，分别在节点1 2 3执行该脚本即可。

curDir=`pwd`
localIp=$(ifconfig | grep  inet | grep netmask | grep broadcast | awk '{print $2}' | sed -n '1p')
zkPid=$(ps aux | grep zookeeper | grep -v grep | awk '{print $2}' )
kafkaPid=$(ps aux | grep kafka | grep -v grep | awk '{print $2}' )
appDir="/ops/app/"
zookeeperBaseDir="/ops/app/zookeeper"
kafkaBaseDir="/ops/app/kafka"
#javahome="/opt/inst/jdk1.8.0_212"
javahome=`echo $JAVA_HOME`
cluster1="v81"
cluster2="v82"
cluster3="v83"

installZookeeper()
{
    /usr/bin/tar -xf $curDir/apache-zookeeper-3.5.5-bin.tar.gz -C $appDir
    ln -s $appDir/apache-zookeeper-3.5.5-bin $zookeeperBaseDir
    /usr/bin/cp $zookeeperBaseDir/conf/zoo_sample.cfg $zookeeperBaseDir/conf/zoo.cfg

    mkdir -p /ops/data/zookeeper
    mkdir -p /ops/logs/zookeeper

cat > $zookeeperBaseDir/conf/zoo.cfg << EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/ops/data/zookeeper
dataLogDir=/ops/logs/zookeeper
clientPort=2181
server.1=$cluster1:2888:3888
server.2=$cluster2:2888:3888
server.3=$cluster3:2888:3888
quorumListenOnAllIPs=true
EOF

    echo $nodeId > /ops/data/zookeeper/myid

cat > /etc/systemd/system/zookeeper.service << EOF
[Unit]
Description=Zookeeper server manager

[Service]
# 重点 Type 必须为 forking 否则无法启动，
Type=forking
# 指定 zk 的日志目录，如果你在 zk log4j 配置文件中指定的日志目录那么就把这行删除
# 指定环境变量，通常需要说明 java,jre 命令位置
#Environment=PATH=/usr/bin/://usr/java/jdk1.8.0_144/bin/
Environment=PATH=/usr/bin/:/$javahome/bin/
ExecStart=/ops/app/zookeeper/bin/zkServer.sh start
ExecStop=/ops/app/zookeeper/bin/zkServer.sh stop
ExecReload=/ops/app/zookeeper/bin/zkServer.sh restart
PIDFile=/ops/data/zookeeper/zookeeper_server.pid

# install 模块必须配置，否则无法加入开机自启动
[Install]
WantedBy=multi-user.target
EOF
  
    systemctl daemon-reload
    systemctl enable zookeeper
}

installKafka(){
    /usr/bin/tar -xf $curDir/kafka_2.12-2.3.0.tgz -C $appDir
    ln -s $appDir/kafka_2.12-2.3.0 $kafkaBaseDir
    mkdir -p /ops/logs/kafka-logs
    clusterHost=cluster${nodeId}

cat > /ops/app/kafka/config/server.properties << EOF
broker.id=${nodeId}
listeners=PLAINTEXT://${!clusterHost}:9092
advertised.listeners=PLAINTEXT://${!clusterHost}:9092
log.dirs=/ops/logs/kafka-logs
num.partitions=3
offsets.topic.replication.factor=3
zookeeper.connect=$cluster1:2181,$cluster2:2181,$cluster3:2181/kafka
EOF

cat > /etc/systemd/system/kafka.service << EOF
[Unit]
Description=Apache Kafka server (broker)
After=network.target  zookeeper.service

[Service]
Type=simple
#Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/java/jdk1.8.0_144/bin"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"$javahome"/bin"
User=root
Group=root
ExecStart=/ops/app/kafka/bin/kafka-server-start.sh /ops/app/kafka/config/server.properties
ExecStop=/ops/app/kafka/bin/kafka-server-stop.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable kafka
}

nodeSelect(){
read -p "请输入需要安装的节点id，如1 2 3: " nodeId
if [ $nodeId == "1" ];then
    installZookeeper
    installKafka
    systemctl start zookeeper
    sleep 20
    systemctl start kafka
elif [ $nodeId == "2" ];then
    installZookeeper
    installKafka
    systemctl start zookeeper
    sleep 20
    systemctl start kafka
elif [ $nodeId == "3" ];then
    installZookeeper
    installKafka
    systemctl start zookeeper
    sleep 20
    systemctl start kafka
else
    echo "请输入需要安装的节点id，如1 2 3"
    exit 1
fi
}

nodeSelect