#############################################
#### Environment variable  for scripts ######
#############################################

## Ipaddress variable
#  Assigning IP for controller node
[ip_ctl]



# Assigning IP for Compute1 host
[ip_com1]


# Gateway for EXT network
[gateway_nat]



# Gateway for MGNT network
[gateway_mngt]


# Gateway for DATA network
[gateway_data]


## Hostname variable
[hostname]



#### Floating IP pool
[floating_ip]

PROVIDER_NETWORK_GATEWAY="$GATEWAY_IP_EXT"


## Password variable
# Set password
[password]


[abc]
RABBIT_PASS="$DEFAULT_PASS"
MYSQL_PASS="$DEFAULT_PASS"
TOKEN_PASS="$DEFAULT_PASS"
ADMIN_PASS="$DEFAULT_PASS"
DEMO_PASS="$DEFAULT_PASS"
SERVICE_PASSWORD="$DEFAULT_PASS"
METADATA_SECRET="$DEFAULT_PASS"

SERVICE_TENANT_NAME="service"
ADMIN_TENANT_NAME="admin"
DEMO_TENANT_NAME="demo"
INVIS_TENANT_NAME="invisible_to_admin"
ADMIN_USER_NAME="admin"
DEMO_USER_NAME="demo"

# Password variable for OPS service
KEYSTONE_PASS="$DEFAULT_PASS"
GLANCE_PASS="$DEFAULT_PASS"
NOVA_PASS="$DEFAULT_PASS"
NEUTRON_PASS="$DEFAULT_PASS"
CINDER_PASS="$DEFAULT_PASS"
SWIFT_PASS="$DEFAULT_PASS"
HEAT_PASS="$DEFAULT_PASS"
CEILOMETER_PASS="$DEFAULT_PASS"
PLACEMENT_PASS="$DEFAULT_PASS"

# Environment variable for DB
KEYSTONE_DBPASS="$DEFAULT_PASS"
GLANCE_DBPASS="$DEFAULT_PASS"
NOVA_DBPASS="$DEFAULT_PASS"
NOVA_API_DBPASS="$DEFAULT_PASS"
NEUTRON_DBPASS="$DEFAULT_PASS"
CINDER_DBPASS="$DEFAULT_PASS"
HEAT_DBPASS="$DEFAULT_PASS"
CEILOMETER_DBPASS="$DEFAULT_PASS"
SAHARA_PASS="$DEFAULT_PASS"

# User declaration in Keystone
ADMIN_ROLE_NAME="admin"
MEMBER_ROLE_NAME="user"
KEYSTONEADMIN_ROLE_NAME="KeystoneAdmin"
KEYSTONESERVICE_ROLE_NAME="KeystoneServiceAdmin"

# OS PASS ROOT