#!/bin/bash
#Author: xusj
#Date: 2020/6/17
localIp=$(ifconfig | grep  inet | grep netmask | grep broadcast | awk '{print $2}' | sed -n '1p')
curDir=`pwd`
dataDir="/ops/data/fastdfs"
confDir="/etc/fdfs/"
yum -y install gcc gcc-c++ make autoconf libtool  automake pcre pcre-devel zlib zlib-devel openssl openssl-devel

installFastdfs(){
mkdir -p $dataDir

unzip $curDir/fastdfs100-fastdfs-nginx-module-V1.22.zip
unzip $curDir/fastdfs100-fastdfs-V6.03.zip
unzip $curDir/fastdfs100-libfastcommon-V1.0.42.zip

cd $curDir/libfastcommon/
./make.sh  && ./make.sh install

cd $curDir/fastdfs/
./make.sh  && ./make.sh install

ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so
ln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so

cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf
cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
cp -rp /ops/inst/fastdfs/conf/http.conf  /etc/fdfs/
cp -rp /ops/inst/fastdfs/conf/mime.types  /etc/fdfs/
cp -rp /ops/inst/fastdfs/fastdfs-nginx-module/src/mod_fastdfs.conf  /etc/fdfs/

\cp -rp /ops/inst/fastdfs/conf/config /ops/inst/fastdfs/fastdfs-nginx-module/src/

#tracker.conf：
sed -i "s|base_path=/home/yuqing/fastdfs|base_path=/ops/data/fastdfs|g" /etc/fdfs/tracker.conf

#storage.conf:
sed -i "s|base_path=/home/yuqing/fastdfs|base_path=/ops/data/fastdfs|g" /etc/fdfs/storage.conf
sed -i "s|store_path0=/home/yuqing/fastdfs|store_path0=/ops/data/fastdfs|g" /etc/fdfs/storage.conf
sed -i "s|tracker_server=192.168.209.121:22122|tracker_server=fastdfs1:22122|g" /etc/fdfs/storage.conf
sed -i "s|tracker_server=192.168.209.122:22122|tracker_server=fastdfs2:22122|g" /etc/fdfs/storage.conf
sed -i "134a tracker_server=fastdfs3:22122" /etc/fdfs/storage.conf
sed -i "s|http.server_port=8888|http.server_port=80|g" /etc/fdfs/storage.conf

#client.conf:
sed -i "s|base_path=/home/yuqing/fastdfs|base_path=/ops/data/fastdfs|g" /etc/fdfs/client.conf
sed -i "s|tracker_server=192.168.0.196:22122|tracker_server=fastdfs1:22122|g" /etc/fdfs/client.conf
sed -i "s|tracker_server=192.168.0.197:22122|tracker_server=fastdfs2:22122|g" /etc/fdfs/client.conf
sed -i "22a tracker_server=fastdfs3:22122" /etc/fdfs/client.conf

#mod_fastdfs.conf:
sed -i "s|base_path=/tmp|base_path=/ops/data/fastdfs|g" /etc/fdfs/mod_fastdfs.conf
sed -i "s|store_path0=/home/yuqing/fastdfs|store_path0=/ops/data/fastdfs|g" /etc/fdfs/mod_fastdfs.conf
sed -i "s|url_have_group_name = false|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf
sed -i "s|tracker_server=tracker:22122|tracker_server=fastdfs1:22122|g" /etc/fdfs/mod_fastdfs.conf
sed -i "40a tracker_server=fastdfs2:22122" /etc/fdfs/mod_fastdfs.conf
sed -i "41a tracker_server=fastdfs3:22122" /etc/fdfs/mod_fastdfs.conf
sed -i "126a [group1]" /etc/fdfs/mod_fastdfs.conf
sed -i "127a group_name=group1" /etc/fdfs/mod_fastdfs.conf
sed -i "128a storage_server_port=23000" /etc/fdfs/mod_fastdfs.conf
sed -i "129a store_path_count=2" /etc/fdfs/mod_fastdfs.conf
sed -i "130a store_path0=/ops/data/fastdfs" /etc/fdfs/mod_fastdfs.conf

chkconfig fdfs_trackerd on
chkconfig fdfs_storaged on

/etc/init.d/fdfs_storaged restart
/etc/init.d/fdfs_trackerd restart
}


installNginx(){
#wget -P /ops/inst/  http://nginx.org/download/nginx-1.16.1.tar.gz
useradd nginx

tar -xf $curDir/nginx-1.16.1.tar.gz -C /usr/local/

cd /usr/local/nginx-1.16.1
./configure --prefix=/usr/local/nginx/ \
--with-stream  \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_gzip_static_module  \
--add-module=/ops/inst/fastdfs/fastdfs-nginx-module/src/
make && make install

cat > /etc/systemd/system/nginx.service << EOF
[Unit]
Description=nginx
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

    \cp -rp /ops/inst/fastdfs/conf/nginx.conf /usr/local/nginx/conf/
    sed -i "s|server_name localhost;|server_name $localIp;|g" /usr/local/nginx/conf/nginx.conf
    systemctl daemon-reload
    systemctl enable nginx
    systemctl restart nginx

}

installFastdfs
installNginx
if [ $? == 0 ];then
    echo -e "\e[0;32;1m===FastDFS and Nginx install success!===\e[0m"
fi

