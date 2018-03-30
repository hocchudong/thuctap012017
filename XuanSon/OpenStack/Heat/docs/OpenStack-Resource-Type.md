# OpenStack Resource Types

\- Xem các resource type tại:  
https://docs.openstack.org/heat/pike/template_guide/openstack.html  
\- Phân biệt **Properties** và **Attributes** của **resource type**:
- **Properties** định nghĩa thiết lập template mà tác giả có thể thao tác khi bao gồm resource trong template. Một vài ví dụ:
  - Flavor và image để sử dụng Nova server.
  - Port để lắng nghe trên Neutron nodes LBaaS.
  - Kích thước của Cinder volume.
- **Attributes** mô tả trạng thái đang chạy của dữ liệu của physical resource. Chúng không có sẵn cho đến physical resource được tạo ra và đang ở trong trạng thái sử dụng. VD:
  - Host ID của Nova server
  - Trạng thái của Neutron network
  - Thời gian tạo của Cinder volume
