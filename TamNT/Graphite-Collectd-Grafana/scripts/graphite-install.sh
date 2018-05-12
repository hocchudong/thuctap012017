#! /bin/bash

## Chinh sua cac tham so sau tuy theo mo hinh
PASS_GRAPHITE_DB=123456
SECRET_KEY='anything_that_you_think'
TIME_ZONE=Asia/Ho_Chi_Minh
graphite_user_name=graphite_user
graphite_db_name=graphite_db
ip_graphite=10.10.10.10

echo "#######Install Graphite-server#######"
apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install graphite-web graphite-carbon -y
apt-get install postgresql libpq-dev python-psycopg2 -y
echo "Config graphite"
cat << EOF | sudo -u postgres psql
CREATE USER $graphite_user_name WITH PASSWORD '$PASS_GRAPHITE_DB';
CREATE DATABASE $graphite_db_name WITH OWNER $graphite_user_name;
\q
EOF
graphite_local=/etc/graphite/local_settings.py
cp $graphite_local $graphite_local.orig
cat << EOF > $graphite_local
SECRET_KEY = '$SECRET_KEY'
TIME_ZONE = '$TIME_ZONE'
LOG_RENDERING_PERFORMANCE = True
LOG_CACHE_PERFORMANCE = True
LOG_METRIC_ACCESS = True
GRAPHITE_ROOT = '/usr/share/graphite-web'
CONF_DIR = '/etc/graphite'
STORAGE_DIR = '/var/lib/graphite/whisper'
CONTENT_DIR = '/usr/share/graphite-web/static'
WHISPER_DIR = '/var/lib/graphite/whisper'
LOG_DIR = '/var/log/graphite'
INDEX_FILE = '/var/lib/graphite/search_index'  # Search index file
USE_REMOTE_USER_AUTHENTICATION = True
DATABASES = {
'default': {
   'NAME': '$graphite_db_name',
   'ENGINE': 'django.db.backends.postgresql_psycopg2',
   'USER': '$graphite_user_name',
   'PASSWORD': '$PASS_GRAPHITE_DB', 
   'HOST': 'localhost',
   'PORT': ''
   }
}
EOF
graphite-manage migrate auth
graphite-manage syncdb --noinput
cp /etc/default/graphite-carbon /etc/default/graphite-carbon.orig
sed -i 's/false/true/g' /etc/default/graphite-carbon
cp /etc/carbon/carbon.conf /etc/carbon/carbon.conf.orig
sed -i 's/^ENABLE_LOGROTATION.*/ENABLE_LOGROTATION = True/g' /etc/carbon/carbon.conf
cp /usr/share/doc/graphite-carbon/examples/storage-aggregation.conf.example /etc/carbon/storage-aggregation.conf
systemctl start carbon-cache
apt-get install apache2 libapache2-mod-wsgi -y
cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available/
a2dissite 000-default
a2ensite apache2-graphite
systemctl restart apache2
sleep 3
echo "#### Install Graphite-server complete! ####"
echo "## =>> Access Graphite-web at http://$ip_graphite ##"