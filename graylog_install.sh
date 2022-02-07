#!/usr/bin/env bash



# File used to automatic install graylog
# The documentation used are:
# https://docs.graylog.org/v1/docs/ubuntu



[ $UID -eq "0" ] || { echo "It's necessary to be root to install graylog "\
&& exit 1 ;}

export PATH=$PATH:/usr/local/sbin:/sbin:/usr/sbin

apt-get update && apt-get upgrade
# Install dependecy and openjdk
apt-get install -y apt-transport-https \
       	openjdk-11-jre-headless uuid-runtime pwgen \
	dirmngr gnupg wget
#
# Install mongoDB
#

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" \
| tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt update && apt install -y mongodb-org

# Install elasticsearch

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" \
| tee -a /etc/apt/sources.list.d/elastic-7.x.list

apt update && apt -y install elasticsearch-oss

tee -a /etc/elasticsearch/elasticsearch.yml > /dev/null << EOL
cluster.name: graylog
action.auto_create_index: false
EOL


systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl restart elasticsearch.service

systemctl enable mongod.service
systemctl restart mongod.service

# installing graylog-server

mkdir /tmp/graylog_install
cd /tmp/graylog_install

wget https://packages.graylog2.org/repo/packages/graylog-4.2-repository_lastest.deb
dpkg -i graylog-4.2-repository_lastest.deb
apt update && apt install graylog-server

systemctl start graylog-server
systemctl enable graylog-server
