# Pushing the edges with OpenStack



Verizon's cloud-in-a-box dựa trên OpenStack phân phối computing đến edge - và local coffee shop của bạn.  
BOSTON - Edge của cloud computing ngày càng trở nên thân thiện hơn. Trong khi những hệ thống ban đầu, thường là telecoms, hiện nay đang được sử dụng cho giàn khoan dầu, xe tự lái, bệnh viện và các chuỗi bán lẻ. Số lượng lớn dữ liệu được sinh ra ở edge của mạng - cả public và private cloud - dẫn đến một nhánh tương ứng những user cần edge computing.  

Verizon đã giới thiệu tại buổi "OpenStack Summit Boston" về OpenStack cho edge computing mà kích thước của nó trông như router nhà bạn.  

<img src="http://imgur.com/oNgYS6G.png" />

**Beth Cohen** (một cán bộ kỹ thuật xuất sắc của Verizon) nói "We need to be in the edge, the data center, all over the place" . Nếu bạn nhìn vào phạm vi kinh doanh của họ, thật dễ hiểu vì sao họ cần edge: Verizon có mạng 4LTE được dùng bởi 98% dân số Hoa Kỳ, mạng IP toàn cầu bao gồm 6 châu lục, IP và data services tại hơn 150 quốc gia và bảy hoạt động an ninh tại 4 châu lục.  

Chặng đường bắt đầu từ vài năm trước đây khi Verizon công bố chiến lược software-defined networking. Đội của **Cohen** được giao nhiệm vụ cung cấp sản phẩm để đáp ứng chiến lược - và đảm bảo giải pháp đơn giản, đáng tin cậy và an toàn. "Và tất nhiên chúng tôi đã có thời kỳ phân phối tích cực và nền tảng OpenStack một phần giúp chúng tôi làm điều đó". Verizon chọn OpenStack vì nó có thể thống nhất quản lý trên mạng, di chuyển khối lượng công việc giữa edge trong khi vẫn cung cấp liền mạch trải nghiệm khách hàng, bộ tool linh hoạt và vendor phát hành cung cấp. Cohen nói: "OpenStack to the rescue".  

Kết quả là toàn bộ CPE (hoặc "cloud-in-a-box"), chạy hệ điều hành quản lý Linux trên nền tảng X86, hypervisor containerized OpenStack agents controllers với OpenStack tại edge để nâng cao trải nghiệm SDN. Họ cố gắng nhét tất cả mọi thứ trong box bởi containerzing và giảm thiểu kích thước của OpenStack footprint - những gì quan trọng là các dịch vụ dành cho khách hàng mà tạo ra doanh thu.  

**Cohen** demo làm thế nào họ có thể đặt hàng, cung cấp và giám sát trên các dịch vụ họ đang chạy từ một port tích hợp và làm thế nào tất cả bảo mật phân tích quản lý mạng tối hóa và an toàn trong một package. Kết quả là một phân phối ồ ạt mạng quản lý OpenStack cloud mà cung cấp nhiều dịch vụ với nhiều tùy chọn - từ tối ưu, bảo mật, định tuyến WAN với nhiều dịch vụ làm việc.






# Tham khảo
http://superuser.openstack.org/articles/edge-computing-verizon-openstack/

























