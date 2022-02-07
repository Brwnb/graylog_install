#!/usr/bin/env bash



# File used to automatic install graylog
# The documentation used are:
# https://docs.graylog.org/v1/docs/ubuntu


[ $UID -eq "0" ] || { echo "It's necessary to be root to install graylog "\
&& exit 1 ;}

apt-get update && apt-get upgrade
# Install dependecy and openjdk
apt install -y apt-gransport-https openjdk openjdk-11-jre-headless \
uuid-runtime pwgen dirmngr gnupg wget

# Install mongoDB

wget -q0 - https://www.mongo.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" \
| tee /etc/apt/sources.list.d/mongodb-org-4.2.list

apt pudate && apt instll -y mongodb-org

# Install elasticsearch

wget -q0 - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" \
| tee -a /etc/apt/sources.list.d/elastic-7.x.list

apt update && apt -y install elasticsearch-oss


