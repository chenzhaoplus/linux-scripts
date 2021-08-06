#!/bin/bash
#Auth: xusj
#Date: 2020/6/15
#3个节点集群使用，分别在节点1 2 3执行该脚本即可。

curDir=`pwd`
localIp=$(ifconfig | grep  inet | grep netmask | grep broadcast | awk '{print $2}' | sed -n '1p')
appDir="/ops/app/"
esBaseDir="/ops/app/elasticsearch"
esDataDir="/ops/data/elasticsearch"
esLogDir="/ops/logs/elasticsearch"
javahome=`echo $JAVA_HOME`
cluster1="v81"
cluster2="v82"
cluster3="v83"

installEs() {
    echo "vm.max_map_count=655360" >> /etc/sysctl.conf
    sysctl -p

    echo "root soft nofile 65536" >> /etc/security/limits.conf
    echo "root hard nofile 65536" >> /etc/security/limits.conf
    echo "* soft nofile 65536" >> /etc/security/limits.conf
    echo "* hard nofile 65536" >> /etc/security/limits.conf
    echo "es soft memlock unlimited" >> /etc/security/limits.conf
    echo "es hard memlock unlimited" >> /etc/security/limits.conf

    echo "DefaultLimitNOFILE=65536" >> /etc/systemd/system.conf
    echo "DefaultLimitNPROC=32000" >> /etc/systemd/system.conf
    echo "DefaultLimitMEMLOCK=infinity" >> /etc/systemd/system.conf

    cd $curDir
    tar -xf $curDir/elasticsearch-6.5.4.tar.gz -C $appDir
    ln -s $appDir/elasticsearch-6.5.4 $appDir/elasticsearch

    mkdir -pv $esDataDir
    mkdir -pv $esLogDir
    
    useradd es
    cp -rp $esBaseDir/config/elasticsearch.yml $esBaseDir/config/elasticsearch.yml.bak

cat > $esBaseDir/config/elasticsearch.yml << EOF
cluster.name: es-cluster
node.name: node-${nodeId}
path.data: /ops/data/elasticsearch
path.logs: /ops/logs//elasticsearch
network.host: 0.0.0.0
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
http.port: 9200
discovery.zen.ping.unicast.hosts: ["${cluster1}:9300", "${cluster2}:9300","${cluster3}:9300"]
discovery.zen.minimum_master_nodes: 3
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF
    chown -R es:es $appDir/elasticsearch-6.5.4/
    chown -R es:es $appDir/elasticsearch/
    chown -R es:es $esDataDir/
    chown -R es:es $esLogDir/
   
    sed -i "s|-Xms1g|-Xms2g|g" /ops/app/elasticsearch/config/jvm.options
    sed -i "s|-Xmx1g|-Xmx2g|g" /ops/app/elasticsearch/config/jvm.options
}

serviceEs(){
cat > /etc/systemd/system/elasticsearch.service <<EOF
[Unit]
Description=elasticsearch
[Service]
#Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${javahome}/bin"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"$javahome"/bin"
User=es
LimitNOFILE=100000
LimitNPROC=100000
ExecStart=/ops/app/elasticsearch/bin/elasticsearch
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable elasticsearch
}

nodeSelect(){
    read -p "请输入需要安装的节点id，如1 2 3: " nodeId

    if [ "$nodeId" != "1" -a "$nodeId" != "2" -a "$nodeId" != "3" ];then
        echo "请输入需要安装的节点id，如1 2 3,请重新执行脚本"
        exit 1
    fi
    serviceEs
    installEs
}
nodeSelect
if [ $? -eq 0 ];then
    echo "******************** es${nodeId}安装完成,请重启服务器***********************"
fi

