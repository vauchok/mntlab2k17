#!/bin/bash
sudo yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

sed -i '/PATH=$PATH:$HOME/a \ export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-1.b12.el7_4.x86_64/jre' ~/.bash_profile

sed -i '/export JAVA_HOME/a \ export PATH=$JAVA_HOME/bin:$PATH' ~/.bash_profile

source ~/.bash_profile

sudo wget "http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz"  && tar zxvf apache-tomcat-8.5.23.tar.gz && rm -rf apache-tomcat-8.5.23.tar.gz

chown -R vagrant:vagrant /home/vagrant/

touch /usr/lib/systemd/system/tomcat.service

echo "[Unit]
Description=Apache Tomcat 8 Servlet Container
After=syslog.target network.target

[Service]
User=vagrant
Group=vagrant
Type=forking
Environment=CATALINA_PID=/home/vagrant/apache-tomcat-8.5.23/tomcat.pid
Environment=CATALINA_HOME=/home/vagrant/apache-tomcat-8.5.23
Environment=CATALINA_BASE=/home/vagrant/apache-tomcat-8.5.23
ExecStart=/home/vagrant/apache-tomcat-8.5.23/bin/startup.sh
ExecStop=/home/vagrant/apache-tomcat-8.5.23/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /usr/lib/systemd/system/tomcat.service

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat


