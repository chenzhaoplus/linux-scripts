#!/bin/bash
#Author: cz
#Date: 2022/5/2

echo -e "\e[0;32;1m===开始安装pgsql,大概需要15-20min...===\e[0m"
yum remove postgresql*
yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm -y
yum install postgresql12 -y
yum install postgresql12-server -y
/usr/pgsql-12/bin/postgresql-12-setup initdb

yum -y install epel-release
yum -y install postgis30_12.x86_64 postgis30_12-client.x86_64 postgis30_12-debuginfo.x86_64 postgis30_12-devel.x86_64 postgis30_12-docs.x86_64 postgis30_12-gui.x86_64 postgis30_12-utils.x86_64

sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|g" /var/lib/pgsql/12/data/postgresql.conf
sed -i "s|#port = 5432|port = 5432|g" /var/lib/pgsql/12/data/postgresql.conf
sed -i "s|max_connections = 100|max_connections = 2000|g" /var/lib/pgsql/12/data/postgresql.conf

sed -i "82a host    all             all             0.0.0.0/0               md5" /var/lib/pgsql/12/data/pg_hba.conf

systemctl enable postgresql-12
systemctl start postgresql-12

echo -e "\e[0;32;1m===执行如下命令完成初始化用户创建和数据库实例创建===
sudo -u postgres psql
create database pgsql;
CREATE ROLE smcaiot WITH SUPERUSER LOGIN PASSWORD '123';
create extension postgis;
create extension "uuid-ossp";
\e[0m"
