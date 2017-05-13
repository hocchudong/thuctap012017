# Glance Image Cache

# MỤC LỤC










<a name="1"></a>
# 1.Introduction
\- Glance API server có thể configure option local image cache. Local cache lưu trữ copy của image files, về bản chất, enabling multiple API servers phục vụ same image file.  
\- Local image cache là transparent đến end user, nói cách khác, end user không biết Glance API đang streaming image file từ local cache hoặc từ actual backend storage system.  

<a name="2"></a>
# 2.Managing the Glance Image Cache
While image files are automatically placed in the image cache on successful requests to `GET /images/<IMAGE_ID>`, the image cache is not automatically managed. Here, we describe the basics of how to manage the local image cache on Glance API servers and how to automate this cache management.  

<a name="3"></a>
# 3.Configuration options for the Image Cache
\- The Glance cache uses two files: one for configuring the server and another for the utilities. The `glance-api.conf` is for the server and the `glance-cache.conf` is for the utilities.  
\- Các options sau trong cả 2 configuration files.  
- `image_cache_dir` : Đây là directory Glance stores cache data. (Required to be set, as does not have a default).
- `image_cache_sqlite_db` : Path to the sqlite file database that will be used for cache management. This is a relative path from the image_cache_dir directory (Default:cache.db).
- `image_cache_driver` : The driver used for cache management. (Default:sqlite)
- `image_cache_max_size` : The size when the glance-cache-pruner will remove the oldest images, to reduce the bytes until under this value. (Default:10 GB)
- `image_cache_stall_time` : Khoảng time incomplete image nằm trong cache, sau thời gian này incomplete image sẽ bị deleted. (Default: 1 day)

Tham khảo:  
https://docs.openstack.org/ocata/config-reference/image/config-options.html  

\- Các vaule sau chỉ định cho file `glance-cache.conf` và chỉ được required for the prefetcher to run correctly.  
- admin_user : The username for an admin account, this is so it can get the image data into the cache.
- admin_password : The password to the admin account.
- admin_tenant_name : The tenant of the admin account.
- auth_url : The URL used to authenticate to keystone. This will be taken from the environment variables if it exists.
- filesystem_store_datadir : This is used if using the filesystem store, points to where the data is kept.
- filesystem_store_datadirs : This is used to point to multiple filesystem stores.
- registry_host : The URL to the Glance registry.

<a name="4"></a>
# 4.Một số command liên quan
Tham khảo:  
https://docs.openstack.org/developer/glance/cache.html  


















