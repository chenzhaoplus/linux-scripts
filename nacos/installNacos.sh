#!/bin/bash
#Auth: cz

curDir=`pwd`
instPath="${curDir}/nacos-server-1.3.1.tar.gz"
appPath="/ops/app"
dbIP="v81"
dbUser="root"
dbPwd="123"

start(){
  tar -xf ${instPath} -C ${appPath}
  cp ${appPath}/nacos/conf/application.properties ${appPath}/nacos/conf/application.properties.bak

cat>${appPath}/nacos/conf/application.properties<<EOF
server.contextPath=/nacos
server.servlet.contextPath=/nacos
server.port=8848

spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://${dbIP}:3306/nacos?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user=${dbUser}
db.password=${dbPwd}
EOF

  echo "nacos 已安装完成,请初始化数据库"

}

start