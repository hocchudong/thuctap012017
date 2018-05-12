#! /bin/bash

## Chinh sua IP cua Graphite server tuong ung mo hinh
ip_graphite=10.10.10.10

echo "#### Install Collectd ####"
apt-get update -y
apt-get install collectd collectd-utils -y
echo "#### Config Collectd flush metrics to Graphite ####"
cp /etc/collectd/collectd.conf /etc/collectd/collectd.conf.orig
sed -i 's/^#LoadPlugin write_graphite/LoadPlugin write_graphite/g' /etc/collectd/collectd.conf
cat << EOF >> /etc/collectd/collectd.conf
<Plugin write_graphite>
      <Node "Graphite">
              Host "$ip_graphite"
              Port "2003"
              Protocol "tcp"
              LogSendErrors true
              Prefix "collectd."
              StoreRates true
              AlwaysAppendDS false
              EscapeCharacter "_"
      </Node>
</Plugin>
EOF

systemctl restart collectd.service
echo "#### Install Collectd complete! ####"
echo "## =>> Check  Graphite-web at http://$ip_graphite ##"
