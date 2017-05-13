# Glance Image Cache

# MỤC LỤC
- [1.Introduction](#1)
- [2.Managing the Glance Image Cache](#2)
- [3.Configuration options for the Image Cache](#3)
- [4.Một số command liên quan](#4)




<a name="1"></a>
# 1.Introduction
\- Glance API server có thể configure option local image cache. Local cache lưu trữ copy của image files, về bản chất, enabling multiple API servers phục vụ same image file.  
\- Local image cache là transparent đến end user, nói cách khác, end user không biết Glance API đang streaming image file từ local cache hoặc từ actual backend storage system.  

<a name="2"></a>
# 2.Managing the Glance Image Cache
Trong khi Image file là tự động được đặt trong image cache theo request `GET /images/<IMAGE_ID>` , image cache không được tự động quản lý. Sau đây, chúng tôi sẽ mô tả cơ bản về cách quản lý local image cache trên Glance API server và tự động quản lý cache này.


<a name="3"></a>
# 3.Configuration options for the Image Cache
\- Glance cache sử dụng 2 files: 1 file cấu hình server và 1 file khác cho utilities. File `glance-api.conf` dành cho server và file `glance-cache.conf` là cho utilities.  
\- Các options sau trong cả 2 configuration files.  
- `image_cache_dir` : Đây là thư mục Glance stores cache data. (Yêu cầu phải được thiết lập, không có giá trị default).
- `image_cache_sqlite_db` : Path tới sqlite file database sẽ được sử dụng cho quản lý cache. Đây là path liên  quan với thư mục image_cache_di (Default:cache.db).
- `image_cache_driver` : driver được sử dụng cho quản lý cache. (Default:sqlite)
- `image_cache_max_size` : Size khi `glance-cache-pruner` sẽ xóa image cũ, Để reduce byte cho đến value này. (Default:10 GB)
- `image_cache_stall_time` : Khoảng time incomplete image nằm trong cache, sau thời gian này incomplete image sẽ bị deleted. (Default: 1 day)

Tham khảo:  
https://docs.openstack.org/ocata/config-reference/image/config-options.html  

\- Các vaule sau chỉ định cho file `glance-cache.conf` và chỉ được required for the prefetcher to run correctly.  
- admin_user : username cho admin account, nó có thể đưa image data vào image cache.
- admin_password : password cho admin account.
- admin_tenant_name : tenant của admin account.
- auth_url : URL được sử dụng để authenticate với keystone. Cái này có thể thay bằng token trong environment variables nếu đã tồn tại.
- filesystem_store_datadir : Đây là thư mục store filesystem, chi tới nơi data được lưu trữ.
- filesystem_store_datadirs : Được sử dụng chỉ tới store multiple filesystem.
- registry_host : URL đến Glance registry.

<a name="4"></a>
# 4.Một số command liên quan
Tham khảo:  
https://docs.openstack.org/developer/glance/cache.html  


















