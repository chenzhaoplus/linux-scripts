#!/bin/bash
# update trino lib and rdbms util plugin

# datax 插件路径
pluginPath="/opt/datax/plugin"
# 更新包源地址
srcLibPath="${pluginPath}/reader/trinoreader/libs"
# 更新包名称
srcLibName="plugin-rdbms-util-0.0.1-SNAPSHOT.jar"
# 更新包目标地址
targetPaths=("${pluginPath}/reader/mysqlreader/libs" "${pluginPath}/reader/rdbmsreader/libs" "${pluginPath}/reader/postgresqlreader/libs" "${pluginPath}/reader/prestoreader/libs" "${pluginPath}/reader/sqlserverreader/libs" "${pluginPath}/reader/mongodbreader/libs" "${pluginPath}/reader/oraclereader/libs" "${pluginPath}/writer/sqlserverwriter/libs" "${pluginPath}/writer/mysqlwriter/libs" "${pluginPath}/writer/mongodbwriter/libs" "${pluginPath}/writer/oraclewriter/libs" "${pluginPath}/writer/postgresqlwriter/libs" "${pluginPath}/writer/rdbmswriter/libs")

for path in ${targetPaths[@]}
	do
	mv ${path}/${srcLibName} ${path}/${srcLibName}.bak`date +%Y%m%d`
	cp ${srcLibPath}/${srcLibName} ${path}/${srcLibName}
done


