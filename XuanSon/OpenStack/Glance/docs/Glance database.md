# Glance database


\- Database "glance" lưu trữ về information của image như:  
- "images" table gồm các thuộc tính : id, name, size, status, created_at, updated_at, deleted_at, deleted, disk_format, container_format, checksum, owner, min_disk, min_ram, protected, virtual_size, visibility
- "image_locations" table gồm các thuộc tính: id image_id, value, created_at, updated_at, deleted_at, deleted, meta_data, status
- …etc…
