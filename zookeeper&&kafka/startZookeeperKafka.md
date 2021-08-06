#修改脚本的cluster host，按自己的host名称修改，cluster1对应第一个节点，cluster2对应第二个节点，以此类推
cluster1="v81"
cluster2="v82"
cluster3="v83"

#启动zookeeper命令
/ops/app/zookeeper/bin/zkServer.sh start
#####或者执行命令
systemctl start zookeeper

#启动kafka命令，先进入kafka目录
/ops/app/kafka/bin/kafka-server-start.sh -daemon /ops/app/kafka/config/server.properties
#####或者执行命令
systemctl start kafka

