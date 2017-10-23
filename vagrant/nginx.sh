#!/bin/bash
sudo wget "https://nginx.org/download/nginx-1.12.1.tar.gz" && tar zxvf nginx-1.12.1.tar.gz  && rm -rf nginx-1.12.1.tar.gz

cd nginx-1.12.1/

./configure --prefix=/home/vagrant/nginx --sbin-path=/home/vagrant/nginx/sbin/nginx --conf-path=/home/vagrant/nginx/conf/nginx.conf --error-log-path=/home/vagrant/nginx/logs/error.log --pid-path=/home/vagrant/nginx/logs/nginx.pid --http-log-path=/home/vagrant/nginx/logs/access.log --with-http_realip_module --without-http_gzip_module --without-http_rewrite_module

sudo make
sudo make install

chown -R vagrant:vagrant /home/vagrant/

mkdir /home/vagrant/nginx/conf/upstreams/
touch /home/vagrant/nginx/conf/upstreams/upstream.conf

echo "upstream backend {
        server 192.168.56.102:8080;
        server 192.168.56.103:8080;
}
" > /home/vagrant/nginx/conf/upstreams/upstream.conf

sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --permanent --zone=public --add-port=8085/tcp
sudo firewall-cmd --permanent --zone=public --add-forward-port=port=80:proto=tcp:toport=8085
sudo firewall-cmd --reload


