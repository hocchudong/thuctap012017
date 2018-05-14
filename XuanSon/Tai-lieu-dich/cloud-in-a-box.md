# Cloud-in-a-box



# Giới thiệu và các khái niệm
\- Edge của cloud computing đang trở nên thân thiện hơn. Lượng lớn data được sinh ra tại edge của networks, bao gồm public và private clouds, dẫn đến user cần edge computing.  
\- Edge computing là data center nhỏ cho phép kết nối tài nguyên compute và storage đến user. Nó cho phép phân tích và tạo source của data. Cách tiếp cận này không yêu cầu các devices ( như laptop, samrtphones, tables ...) phải kết nối network liên tục.  
Sau đây là hình ảnh cho thấy sự khác nhau giữa cloud computing và edge computing:  

<img src="http://i.imgur.com/NOhgSJI.png" />

Như hình ảnh trên, ta thấy có một layer bao gồm data và app ở giữa cloud và user.  

\- Edge device là thết bị cung cấp điểm truy cập mạng service provider.  
Ví dụ: router, routing switches, integrated access devices (IADs),...

# Cloud-in-a-box
\- Tại OpenStack Summit Boston, Verizon (1 nhà mạng của Mỹ) đã công bố việc hệ thống cloud-in-a-box sử dụng OpenStack cho edge conputing mà box đó có kích thước chỉ như thiết bị router ở nhà bạn. Nó được gọi là "Verizon's edgy box".  

<img src="http://superuser.openstack.org/wp-content/uploads/2017/05/Screen-Shot-2017-05-08-at-09.46.18.png" />

\- Kết quả là toàn bộ CPE (hoặc "cloud-in-a-box) chạy hệ điều hành Linux trên platform X86, hypervisor containerized OpenStack agents controllers với OpenStack. Họ cố gắng nhét tất cả mọi thứ vào trong box bởi containerizing và giảm thiếu tối đa kích thước của OpenStack footprint, chỉ giữ lại những service cần thiết cho khách hàng để có được lợi nhuận.  

\- **cloud-in-a-box** có khả năng phục vụ khách hàng như dịch vụ thuê IP TV , etc.. chỉ với một vài cú kick chuột đơn giản. Nó cũng có khả năng giả lập các chức năng ảo như firewall, HA Proxy, load balance, etc... Chính vì thế, khác hàng chỉ cần 1 con  **cloud-in-a-box** là có thể thay thế nhiều thiết bị khác.  


# Tham khảo
- http://superuser.openstack.org/articles/edge-computing-verizon-openstack/
- https://en.wikipedia.org/wiki/Edge_computing  
https://en.wikipedia.org/wiki/Edge_device  
https://www.youtube.com/watch?v=RjMS15V_7nQ  

























