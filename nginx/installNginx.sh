#!/bin/bash
yum -y install gcc gcc-c++ automake pcre pcre-devel zlib zlib-devel openssl openssl-devel
# wget -P /ops/inst/  http://nginx.org/download/nginx-1.16.1.tar.gz
useradd nginx

tar -xf /ops/inst/nginx-1.16.1.tar.gz -C /usr/local/

cd /usr/local/nginx-1.16.1
./configure --prefix=/usr/local/nginx/ \
--with-stream  \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_gzip_static_module  \
#--add-module=/usr/local/fastdfs-nginx-module/src/
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
    systemctl daemon-reload
    systemctl enable nginx
    systemctl restart nginx

if [ $? == 0 ];then
    echo -e "\e[0;32;1m===nginx install success!===\e[0m"
fi
