# Delivering the 3Cs of OpenStack

#### ***Cost (Chi phí), compliance (Sự tuân thủ) and capabilities (các khả năng) là ba phẩm chất (giá trị) của những user sử dụng Openstack mang tới cho bài phát biểu quan trọng trong ngày Summit đầu tiên tại Bostom (Summit Bostom).*** 

Tại Boston, ông Jonathan Bryce - giám đốc điều hành OpenStack Foundation, đã chào đón hàng ngàn stacker trên khắp thế giới vào ngày đầu tiên của Summit (Hội nghị) với hình ảnh của một tay quần vợt, phản ánh phong cách thể thao của tuần hội nghị lần này. 

Đây không phải là lần đầu tiên cộng đồng Openstack quy tụ tại đây nhưng quy mô của lần này có đã có sự thay đổi - khi mà trong năm 2012 mới chỉ có 600 người tham gia. Thì bây giờ quy mô đã tăng lên thành hơn 5 triệu người - tức là tăng thêm 44% sau mỗi năm, "a global footprint that's pretty incredible" (Là một bước tiến toàn cầu đáng kinh ngạc!), ông nói thêm. 

<img src = "http://imgur.com/e09gXJq.jpg">

Ông [Bryce](https://twitter.com/jbryce) đã nói về 3Cs - cost, compliance và capabilities - mà các Openstack user đang sử dụng. (Bạn có thể có được tất cả các keynote (các từ khóa chính) trên [kênh video của Openstack Foundation](https://www.openstack.org/videos/boston-2017/tracks/keynotes)). Đầu tiên, ông giới thiệu về Verizon để nói về edge computing, với sản phẩm cloud-in-box của họ - tìm hiểu rõ hơn [tại đây](http://superuser.openstack.org/articles/edge-computing-verizon-openstack/). Và sau đó mang lên sân khấu GE cho compliance (sự tuân thủ) và quân đội Hoa Kì trường hợp cắt giảm chi phí. ("and then brought onstage GE for compliance and the U.S. Army for the cost-cutting case".)

Ông Patrick Weeks, giám đốc bộ phận kĩ thuật số của GE Digital Healthcare, đã nói về việc chuyển các ứng dụng doanh nghiệp chăm sóc sức khỏe sang mô hình cloud trong các lĩnh vực có quy mô lớn. Ông Weeks nói rằng họ đã bắt đầu với mục tiêu khá cao là chuyển 126 app sang cloud vào năm 2015, lúc mà chúng ta chưa biết gì về cloud. "Some might say when pigs fly. They did" (Ý câu này là họ đã làm được một việc không tưởng).

Link twitter bài nói: https://twitter.com/RonGuida/status/861597610532110336?ref_src=twsrc%5Etfw&ref_url=http%3A%2F%2Fsuperuser.openstack.org%2Farticles%2F3cs-of-openstack%2F

Ông Weeks chia sẻ một vài con số ấn tượng kể từ những ngày đầu:

- 530 applications migrated to cloud (530 ứng dụng được chuyển lên cloud)

- 42 percent applications in cloud (42% ứng dụng trong cloud)

- 608 applications retired (đã tạm dừng 608 ứng dụng)

- 49 percent footprint reduction on premises (giảm 49% diện tích mặt bằng)

- over 30 million in annualized savings (Tiết kiệm hơn 30 triệu $ mỗi năm)

- Shared automation strategy across public & private (Chiến lược chia sẻ tự động qua public và private)

- Over 200 controls supporting security & compliance (Hơn 200 bộ điều khiển hỗ trợ bảo mật và tuân thủ)

Và nếu những điều trên là chưa đủ, thì ông Weeks có báo cáo thêm rằng: một trong những kĩ sư đa nghi nhất của ông cũng phải thốt lên rằng: "This platform is made of awesome!" (nền tảng này thì quá là tuyệt vời!!)


### Chú ý tới các sinh viên tại các trường học về mạng(Attention cyber-school students)!!

Thiếu tá Julianna Rodriguez và đội trưởng Christopher W. Apsey của trường quân đội Hoa Kì về mạng - U.S. Army Cyber school đã mang tới một trường hợp cắt giảm chi phí cho Openstack. Các khóa huấn luyện USACYS và giáo dục khoảng 500 binh lính mỗi năm để bảo vệ lợi ích của Hoa Kì với các ngành khoa học máy tính, kĩ sư điện, kĩ sư về robot và toán học.

<img src = "http://imgur.com/yTPs2gW.jpg">

Hình ảnh thiếu tá  Rodriguez nói tại summit.

Vấn đề như bà Rodriguez nói rằng: việc giảng dạy với tốc độ nhanh như ánh sáng của khoa học máy tính không liên kết với phương thức để có được các tài liệu giảng dạy rõ ràng. Các chương trình học đã cũ nghĩa là họ đã "write requirements and request contract implementation then wait a staggering 12-18 months."

"Chúng tôi muốn đảm bảo rằng các sinh viên không bị rơi xuống trên bậc thang của học hành - và nếu mà bạn không sử dụng các kĩ năng thì bạn sẽ bị bỏ rơi" (“We want to be sure students don’t fall off the staircase of learning — and if you’re not using the skills they atrophy,”) cô ấy lưu ý. Bây giờ, làm việc trên các điều kiện tất cả mọi thứ đã như code (everything-as-code) cho các chương trình học và dòng chảy Github, trong vòng từ 12-18h là mọi thứ đã có ngay trước mặt cho các sinh viên. Sự thiết lập của chúng cũng đã có sự thay đổi đáng kể: từ 3 máy chủ được kết nối tới user thông qua cable CAT6 và 40 core, 512G ram, lưu trữ 10TB và hệ thống LTE hootspot thì ngày nay đã có tới 2000 core, 36TB ram, 4PB lưu trữ, 1 Gbps DIA. 

"Tất cả chúng tôi đều vui hơn" (“We’re all happier,”) bà Rodrigue lưu ý, show ra một bức hình các sinh viên sử dụng các giải pháp cloud cá nhân. "Không còn dây cable trên trần nhà" (“There are no cables hanging from the ceiling.”)

Ông Apsey đặt core đó thông qua các bước của nó bằng cách demo các kho lưu trữ dựa trên [AsciiDoc](https://en.wikipedia.org/wiki/AsciiDoc). Ông đã cho đám đông tại Boston thấy cách tạo các kinh nghiệm của một sinh viên luôn được cập nhật, có liên quan và chính xác về kĩ thuật trong khi đầu tư tối thiểu thời gian làm việc cho sự quản lý nội dung. 

### Edible robots, comic book heroes and TessMaster

Những khoảnh khắc đáng chú ý trong bài phát biểu quan trọng trong ngày đầu tiên là mối quan hệ hợp tác giữa Mirantis và Fujitsu sau một cuốn comic-book (sách có hình mô tả) với sự tham gia của Dr. Vendor Lock-in. E-bay đã thông báo rằng sẽ mở open-source TessMaster - Một framework để quản lý Kubernetes trên OpenStack — 167,000 máy ảo được quản lý hàng ngày —  bạn có thể học nhiều hơn về điều này vào [các session ngày thứ 3](https://www.openstack.org/summit/boston-2017/summit-schedule/events/18959/declarative-cloud-native-fleet-management-of-kubernetes-clusters-and-beyond-at-ebay?BackURL=https%3A%2F%2Fwww.openstack.org%2Fsummit%2Fboston-2017%2Fsummit-schedule%2Fglobal-search%3Ft%3DeBay%23eventid%3D18959) (Ngoài ra, chúng tôi đang giữ các tab về tất cả các thông báo được đưa ra tại Hội nghị thượng đỉnh vào tuần này, vì vậy hãy theo dõi)

Daniela Rus đến từ Viện Công nghệ Massachusetts, giám đốc khoa học máy tính và phòng thí nghiệm trí tuệ nhân tạo (CSAIL), giới thiệu công việc của nhóm cô  về modular robot tự cấu hình lại. (CSAIL chạy trên OpenStack và là nhóm chiến thắng trong [Superuser Award](http://superuser.openstack.org/articles/boston-superuser-awards-nominee-mit-computer-science-artificial-intelligence-lab/)). Rus - người kiếm được một chiếc váy tuyệt đẹp với các ứng dụng "Space Invaders" - mô tả cách thức họ đang xây dựng trình biên dịch robot này bằng cách in các cấu trúc phẳng và sau đó xếp chúng lại thành cơ thể robot. Trình biên dịch có một cơ sở dữ liệu, cơ sở dữ liệu có thiết kế có thể được cấu tạo và phân đoạn.

<img src = "http://imgur.com/oFJrjf6.jpg">

[link twitter](https://twitter.com/SWDevAngel/status/861601313498550272/photo/1?ref_src=twsrc%5Etfw&ref_url=http%3A%2F%2Fsuperuser.openstack.org%2Farticles%2F3cs-of-openstack%2F)

Một robot 6 chân, ví dụ có thể gồm 2 cặp chân, 2 chân đơn và một phần thân tách biệt. ngừi dùng chỉ cần xác định xem trông nó sẽ như thế nào và  hệ thống sẽ tính ra các thành phần và nguyên vật liệu. Đầu ra là các file thiết kế có thể được gửi đến máy cắt laze hoặc với giấy và kéo, và được in trong khoảng hai phút.

Video mô tả về robot chess của nhóm Rus: http://projects.csail.mit.edu/video/research/robo/ScienceChess.mp4

Tuy nhiên, các nhà nghiên cứu nhanh chóng nhận ra rằng quá trình gấp lại - con người phải mất hai giờ để xây dựng các cấu trúc 3D nhỏ. Vì vậy, họ tự động quá trình này bằng cách tạo cho người sử dụng khả năng bake robot của họ, “the secret sauce is a three-layer sandwich structure,” ("nước sốt bí mật là lớp thứ ba của sandwich"), Rus nói. Lớp phù hợp giữa được tạo ra bằng vật liệu tương tự như Shrinky Dinks.

Đó có vẻ như là một trò chơi khá thú vị (và các video Rus cho hình ảnh con robot bò lên và xuống như cánh tay con người và trôi nổi trên mặt nước thực sự thú vị - "and the videos Rus showed crawling up and down a human arm and floating on water were indeed uber cool") "nó là một loại robot thú vị", cô nói thêm, lưu ý rằng nó có thể được kiểm soát bởi một từ trường bên ngoài mà có thể lập trình được. Khi công việc được hoàn thành, nó có thể được gửi recycle bin.

Cô trích dẫn một ứng dụng rất cụ thể: phẫu thuật cơ thể. Có khoảng 3.500 người nuốt pin ở Mỹ mỗi năm, giống như những chiếc được tìm thấy trong đồng hồ, nó có thể làm cho thủng một lỗ trong dạ dày của bạn trong vòng 30 phút. Nhưng bạn có thể nuốt một "bác sĩ vi mạch origami" giống như thuốc viên để triển khai, tìm ra và loại bỏ nó ngay lập tức.



