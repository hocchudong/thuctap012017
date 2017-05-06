# Keystone command line


# MỤC LỤC
- [1.keystone-manage command](#1)
    - [1.1.Lý thuyết](#1.1)
    - [1.2.Example hay dùng](#1.2)
- [2.Command sử dụng openstack-client program](#2)



Tham khảo:  
https://docs.openstack.org/developer/keystone/man/keystone-manage.html  

<a name="1"></a>
# 1.keystone-manage command

<a name="1.1"></a>
# 1.1.Lý thuyết
\- Mô tả
keystone-manage là câu lệnh tác động đến Keystone service, dùng cho những hoạt động không thể thực hiển bởi API HTTP như such data import/export and database migrations.  
\- Cú pháp  
```
keystone-manage [options]
```

\- Cách dùng  
```
keystone-manage [options] <action> [additional args]
```

\- Các action :  
- bootstrap: Perform the basic bootstrap process.
- credential_migrate: Encrypt credentials using a new primary key.
- credential_rotate: Rotate Fernet keys for credential encryption.
- credential_setup: Setup a Fernet key repository for credential encryption.
- db_sync: Sync the database.
- db_version: Print the current migration version of the database.
- doctor: Diagnose common problems with keystone deployments.
- domain_config_upload: Upload domain configuration file.
- fernet_rotate: Rotate keys in the Fernet key repository.
- fernet_setup: Setup a Fernet key repository for token encryption.
- mapping_populate: Prepare domain-specific LDAP backend.
- mapping_purge: Purge the identity mapping table.
- mapping_engine: Test your federation mapping rules.
- saml_idp_metadata: Generate identity provider metadata.
- token_flush: Purge expired tokens.

<a name="1.2"></a>
# 1.2.Example hay dùng
\- Xóa token đã cấp phát  
```
keystone-manage token_flush
```

\- Setup a Fernet key repository for token encryption  
```
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
```

\- Setup a Fernet key repository for credential encryption  
```
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```

\- Rotate keys in the Fernet key repository  
```
keystone-manage fernet_rotate --keystone-user keystone --keystone-group keystone
```

\- Rotate Fernet keys for credential encryption  
```
keystone-manage credential_rotate --keystone-user keystone --keystone-group keystone
```  

<a name="2"></a>
# 2.Command sử dụng openstack-client program
- `openstack domain` command
- `openstack project` command
- `openstack user` command
- `openstack group` command
- `openstack role` command

\- Note:  
Bạn có thể sử dụng tùy chọn --help để xem dẫn sử dụng command.Ví dụ:  
```
openstack domain --help
```



























