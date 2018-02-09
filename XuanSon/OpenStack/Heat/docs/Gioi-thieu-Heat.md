# Giới thiệu Heat


# MỤC LỤC

<a name="1"></a>
# 1.Khái niệm
\- Heat project hay còn gọi là Orchestration service là dịch vụ phối hợp các ứng dụng cloud bằng cách sử dụng các định dạng template thông qua REST API có sẵn trong OpenStack.  

<a name="2"></a>
# 2.Mục đích và tầm nhìn của Heat
\- Heat cung cấp template dựa trên orchestration để mô tả ứng dụng cloud bằng cách thực hiện các lời gọi đến OpenStack API để tạo các ứng dụng cloud.  
\- Template Heat mô tả cơ sở hạ tầng của ứng dụng cloud trong file text mà con người có thể đọc và ghi được, và có thể quản lý bởi version control tool.  
\- Template chỉ định mỗi quan hệ giữa các tài nguyên (vd: volume được kết nối đến server). Điều này cho phéo Heat gọi đến các OpenStack API để tạo ra tất cả các cơ sở hạ tầng đúng thứ tự để khởi động ứng dụng của bạn.  
\- Phần mềm tích hợp các thành phần khác của OpenStack. Template cho phép tạo ra hầu hết các loại tài nguyên OpenStack (như instance, floating ips, volumes, security group, users, …) cũng như 1 số chức năng tiên tiến hơn như instance availability, instance autoscaling và nested stacks.  
\- Heat chủ yếu quản lý cơ sở hạ tầng, nhưng template tích hợp tốt với các công cụ quản lý cấu hình phần mềm như Pupper và Ansible.  
\- Nhà khai thác có thể tùy chỉnh các tính năng của Heat bằng cách cài các plugin.  

<a name="3"></a>
# 3.Các khái niệm cần biết
\- **Stack** : Trong cách nói của Heat , stack là 1 tập hợp các objects , 1 tập hợp các resource , sẽ được tạo bởi Heat . Điều này bao gồm các instance (VMs) , networks , subnets , routers , ports , router interface , security group , ecurity group rules, auto-scaling rules, etc...  
\- **Template** : Heat sử dụng 1 template để định nghĩa stack .  
\- 1 Heat **template** có 3 sections chính:  
- Parameters : Đây là thông tin như image ID , network ID ,…
- Resource : là các objects cụ thể mà Heat sẽ tạo ra .
- Output : thông tin được chuyển qua cho người sử dụng , thông qua OpenStack DardBoard hoặc câu lệnh heat stack-list and heat stack-show.






