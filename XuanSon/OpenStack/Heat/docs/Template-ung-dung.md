# Template một số ứng dụng


# 1.Wordpress

```
heat_template_version: 2017-09-01

description: >
  Simple template to deploy a Mysql Server
  Simple template to deploy a wordpress instance

parameters:
  image:
    type: string
    label: Image name or ID
    description: Image to be used for compute instance
    default: ubuntu14.04
  flavor:
    type: string
    label: Flavor
    description: Type of instance (flavor) to be used
    default: m1.mysql-wordpress
  key:
    type: string
    label: Key name
    description: Name of key-pair to be used for compute instance
    default: key-mysql-wordpress
  public_network:
    type: string
    label: Public network name or ID
    description: Public network with floating IP addresses.
    default: external
  private_cidr:
    type: string
    label: Network CIDR
    description: The CIDR of the private network.
    default: '10.10.10.0/24'
  dns:
    type: comma_delimited_list
    label: DNS nameservers
    description: Comma separated list of DNS nameservers for the private network.
    default: '8.8.8.8'
  root_pass:
    type: string
    label: mysql root password
    description: mysql root password
    default: Welcome123
  db_name:
    type: string
    label: database name
    description: database name
    default: wordpress
  db_user:
    type: string
    label: database user
    description: database user
    default: wordpress
  db_pass:
    type: string
    label: database password
    description: database password
    default: Welcome123



resources:
  private_network:
    type: OS::Neutron::Net
  private_subnet:
    type: OS::Neutron::Subnet
    properties:
      network_id: { get_resource: private_network }
      cidr: { get_param: private_cidr }
      dns_nameservers: { get_param: dns }
  neutron_port_db:
    type: OS::Neutron::Port
    properties:
      admin_state_up: True
      network: { get_resource: private_network }
      fixed_ips:
        - subnet_id: { get_resource: private_subnet }
  neutron_port_wordpress:
    type: OS::Neutron::Port
    properties:
      admin_state_up: True
      network: { get_resource: private_network }
      fixed_ips:
        - subnet_id: { get_resource: private_subnet }
  router:
    type: OS::Neutron::Router
    properties:
      external_gateway_info:
        network: { get_param: public_network }
  router_interface:
    type: OS::Neutron::RouterInterface
    properties:
      router_id: { get_resource: router }
      subnet: { get_resource: private_subnet }


  mysql_instance:
    type: OS::Nova::Server
    properties:
      image: { get_param: image }
      flavor: { get_param: flavor }
      key_name: { get_param: key } 
      networks:
        - port: { get_resource: neutron_port_db }
      user_data: 
        str_replace:
          params:
            __ROOT_PASS__: { get_param: root_pass }
            __DB_NAME__: { get_param: db_name }
            __DB_USER__: { get_param: db_user }
            __DB_PASS__: { get_param: db_pass }
          template: |
            #!/bin/sh
            apt-get update -y
            echo mysql-server mysql-server/root_password password __ROOT_PASS__ | debconf-set-selections
            echo mysql-server mysql-server/root_password_again password __ROOT_PASS__ | debconf-set-selections
            apt-get -y install mariadb-server 
            sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
            #
            sed -i "/bind-address/a\default-storage-engine = innodb\n\
            innodb_file_per_table\n\
            collation-server = utf8_general_ci\n\
            init-connect = 'SET NAMES utf8'\n\
            character-set-server = utf8" /etc/mysql/my.cnf
            #
            service mysql restart
            #
            cat << EOF | mysql -uroot -p__ROOT_PASS__
            DROP DATABASE IF EXISTS __DB_NAME__;
            CREATE DATABASE __DB_NAME__;
            GRANT ALL PRIVILEGES ON __DB_NAME__.* TO '__DB_USER__'@'%' IDENTIFIED BY '__DB_PASS__';
            EOF
      user_data_format: RAW

  wordpress_instance:
    type: OS::Nova::Server
    properties:
      image: { get_param: image }
      flavor: { get_param: flavor }
      key_name: { get_param: key } 
      networks:
        - port: { get_resource: neutron_port_wordpress }
      user_data: 
        str_replace:
          params:
            __DB_HOST__: { get_attr: [mysql_instance , networks , {get_resource: private_network } , 0 ] }
            __DB_NAME__: { get_param: db_name }
            __DB_USER__: { get_param: db_user }
            __DB_PASS__: { get_param: db_pass }
          template: |
            #!/bin/sh
            apt-get update -y
            #
            wget https://wordpress.org/wordpress-4.2.4.zip
            apt-get install -y unzip apache2 php5 php5-mysql
            unzip wordpress-4.2.4.zip
            mv wordpress /var/www/html/
            cd /var/www/html/
            chown -R root:www-data wordpress/
            cd wordpress
            mv wp-config-sample.php wp-config.php
            sed -i 's/database_name_here/__DB_NAME__/g' wp-config.php
            sed -i 's/username_here/__DB_USER__/g' wp-config.php
            sed -i 's/password_here/__DB_PASS__/g' wp-config.php
            sed -i 's/localhost/__DB_HOST__/g' wp-config.php
            #
            service apache2 restart
      user_data_format: RAW
  FloatingIP:
    type: OS::Nova::FloatingIP
    properties:
      pool: {get_param: public_network}

  add_FloatingIP_wordpress:
    type: OS::Nova::FloatingIPAssociation
    properties:
      floating_ip: {get_resource: FloatingIP}
      server_id: {get_resource: wordpress_instance}


outputs:
  mysql_name:
    description: Name of vm mysql
    value: {get_attr: [mysql_instance , name]}
  wordpress_name:
    description: Name of vm wordpress
    value: {get_attr: [wordpress_instance , name]}
  mysql_ip:
    description: IP address of the mysql_instance
    value: { get_attr: [mysql_instance, first_address] }
  wordpress_private_ip:
    description: IP address of the wordpress_instance
    value: { get_attr: [wordpress_instance, first_address] }
  wordpress_floating_ip:
    description: Floating IP of wordpress
    value: { get_attr: [FloatingIP , ip ]}
```



