# Environment

# MỤC LỤC
- [1.Giới thiệu ](#1)
- [2.Định dạng file environment](#2)
- [3.Lệnh tạo stack với template và environment](#3)
- [4.Environment Merging](#4)
- [5.Global và user environments](#5)
- [6.Ví dụ](#6)
  - [6.1.Định nghĩa giá trị cho đối số template](#6.1)
  - [6.2.Định nghĩa giá trị mặc định cho parameters](#6.2)
  - [6.3.Mapping resource](#6.3)
  - [6.4.Override resource với custom resource	](#6.4)


<a name="1"></a>
# 1.Giới thiệu 
\- Environment ảnh hưởng đến hành vi của template. Nó cung cấp cách để ghi đè (override) các sự bổ sung tài nguyên và cơ chế đặt parameter mà dịch vụ cần. 1 file environment là các loại được chỉ định của template mà nó cung cung cấp các tùy chỉnh cho templates.  
\-  
|||
|---|---|
|Template|Bản thiết kế kiến trúc tĩnh ứng dụng của bạn |
|Environment|Chi tiết cụ thể ảnh hưởng đến việc khởi tạo template|
|Stack|Tempalte + Environment|

<a name="2"></a>
# 2.Định dạng file environment
\- Environment là file text định dạng yaml chứa 2 section chính:  
- `parameters`: Đây là các cài đặt thông thường bạn áp dụng cho parameters của top-level template. VD, nếu bạn triển khai tempate chứa nested stack, như resource registry mapping, parameters chỉ áp dụng cho top-level template chứ không phải templates cho nested resources. parameters biểu diễn dưới dạng 1 danh sách cặp key/value.
- `resource_registry`: Định nghĩa tên resource tùy chỉnh, liên kết với các heat templates khác. Điều này về cơ bản cung cấp 1 phương pháp để tạo các resources tùy chỉnh không tồn tại trong bộ core resource. Chúng được định nghĩa trong section `resource_registry` của file environment.

\- Nó có thể chứa 1 số thành phần khác:  
- `parameter_defaults`: Các parameters mặc định được truyền đến tất cả các template. Chúng sửa đổi các giá trị mặc định cho tất cả các parameters trong tất cả các template.  
VD: Nếu bạn triển khai template nested stacks, parameter default áp dụng cho tất cả các templates. Nói cách khác, `parameter_default` áp dụng cho cả top-level template và những những tài nguyên được lồng trong nó.  
- `encrypted_parameters`: Danh sách parameters được mã hóa.
- `event_sinks`: Danh sách endpoints mà có thể nhận các stack events.
- `parameter_merge_strategies`: Hợp nhất chiến lược cho việc hợp nhất parameters defaults từ file environment.

> Chú ý:  
Bạn nên sử dụng parameter_defaults thay vì parameters.

\- VD: File environment cơ bản:  
```
resource_registry:
  OS::Nova::Server::MyServer: myserver.yaml

parameter_defaults:
  NetworkName: my_network

parameters:
  MyIP: 192.168.0.1
```

\- Trong ví dụ, file environment (`my_env.yaml`)  bao gồm mapping `OS::Nova::Server::MyServer` đến `myserver.yaml`.  
MyIP là parameter chỉ áp dụng cho  main Heat template, trong ví dụ này nó chỉ áp dùng cho file `my_template.yaml`.  
NetworkName là parameter áp dụng cho cả main Heat template và các template liên kết với main Heat template, như resource `OS::Nova::Server::MyServer` (`myserver.yaml`).  

<a name="3"></a>
# 3.Lệnh tạo stack với template và environment 
\- Sử dụng option `-e` của lệnh **openstack stack create** để tạo stack sử dụng environment được định nghĩa.  
\- Bạn có thể cung cấp environment parameters như 1 danh sách các cặp key/vaule sử dụng option `--parameter` của lệnh **openstack stack create**.  
\- Trong ví dụ environment được đọc từ file `my_env.yaml` và parameter thêm được cung cấp sử dụng option `--parameter`.  
```
$ openstack stack create my_stack -e my_env.yaml --parameter "param1=val1;param2=val2" -t my_tmpl.yaml
```

<a name="4"></a>
# 4.Environment Merging
\- Parameters và các giá trị mặc định của chúng (parameter_defaults) được hợp nhất dựa trên chiến trược hợp nhất trong file environments.  
\- Có 3 loại chiến lược hợp nhất:  
- `overwrite`: Ghi đè parameter, giá trị parameter hiện tại được thay thế.
- `merge`: Hợp nhất giá trị parameter đã tồn tại và giá trị parameter mới. Giá trị String được nối, danh sách comma delimited  được mở rộng và giá trị json được cập nhật.
- `deep_merge`: Giá trị Json được deep merged. Không hữu ích cho các loại khác như  danh sách  comm delimited và strings. Các loại giá trị đó sẽ được chỉ định  trở lại merge.

\- Bạn có thể cung cấp chiến lược merge mặc định và các chiến lược hợp nhất parameter cụ thể cho mỗi file environment. Chiến lược hợp nhất parameters cụ thể chỉ được sử dụng cho parameter. VD về section `parameter_merge_strategies` trong file environment:  
```
parameter_merge_strategies:
  default: merge
  param1: overwrite
  param2: deep_merge
```

\- Nếu không có chiến lược hợp nhất được cung cấp trong file environment, mặc định sẽ là overwrite cho tất cả các `parameters` và `parameter_defaults` trong file environment.  
\- Chú ý:  
Hiện tại, tại bản OpenStack Pike, mình sử dụng tính năng này nhưng bị lỗi, tất cả các chiến lược đều thực hiện như là `overwite`.  

<a name="5"></a>
# 5.Global và user environments
\- Environment được sử dụng cho stack là sự kết hợp của environment bạn sử dụng với template cho stack, global environment được xác định bởi các nhà điều hành cloud. Một mục nhập trong user environment được ưu tiên hơn global environment. OpenStack bao gồm glocal environment mặc định, nhưng các nhà điều hành cloud có thể bổ sung thêm các mục environment.  
\- Các nhà điều hành cloud có thểm thêm global environment bằng cách thêm file environment vào thư mục có thể định cấu hình bất cứ nơi nào Orchestration engine chạy. Biến cấu hình thư mục chứa file glocal environment tên là `environment_dir` và được tìm thấy trong section `[DEFAULT]` của file `/etc/heat/heat.conf`. Mặc định là thư mục `/etc/heat/environment.d`.  
```
[DEFAULT]
environment_dir = /etc/heat/environment.d
```

Sau khi cấu hình file trong thưu mục `/etc/heat/environment.d` ta phải restart lại cách dịch vụ heat.  
```
# systemctl restart heat-api
# systemctl restart heat-engine
```

\- Nếu file `my_env.yaml` được đặt trong thư mục `environment_dir` thì thay vì dùng lệnh:  
```
$ openstack stack create my_stack -e my_env.yaml --parameter "some_parm=bla" -t my_tmpl.yaml
```

ta có thể dụng lệnh sau:  
```
$ openstack stack create my_stack --parameter "some_parm=bla" -t my_tmpl.yaml
```

\- Chú ý:  
- Trong section `resource_registry`, mapping `key/vaule`, nếu sử dụng cùng tên key trong cả file user environment và global environment sẽ bị lỗi. Vậy ra rút ra kết luận, không thể đặt cùng tên Resource Type.
- Option `--parameter` được coi như là parameter của user environment nhưng có quyền ưu tiên hơn parameter trong file user environment. Và chỉ áp dụng cho parameters của top-level template (main template).  
Lưu ý, key của option `--parameter` phải được khai báo trong section parameters của main template.  
- Hiện tại, tại bản OpenStack Pike, khi sử dụng global enviroments, mình sử dụng section `parameters` và `parameter_defaults` nhưng không có tác dụng đến file main Heat template.  

<a name="6"></a>
# 6.Ví dụ

<a name="6.1"></a>
## 6.1.Định nghĩa giá trị cho đối số template
\- Bạn có thể định nghĩa giá trị cho đối số template trong section `parameters` của file environment:  
```
parameters:
  KeyName: heat_key
  InstanceType: m1.micro
  ImageId: F18-x86_64-cfntools
```

<a name="6.2"></a>
## 6.2.Định nghĩa giá trị mặc định cho parameters
\- Bạn có thể định nghĩa giá trị mặc định cho tất cả đối số template trong section `parameter_defaults` của file environment. Mặc định được truyền đến tất cả các template:  
```	
parameter_defaults:
  KeyName: heat_key
```

<a name="6.3"></a>
## 6.3.Mapping resource
\- Bạn có thể map 1 resource đến 1 resource khác trong section resource_registry của file environment. Resource bạn cung cấp theo cách này phải có 1 định dạng và phải tham chiếu đến ID của resource khác hoặc URL của file template đã tồn tại.  
\- VD sau map 1 resource `OS::Networking::FloatingIP` mới đến 1 resource `OS::Nova::FloatingIP` đã tồn tại.  
```
resource_registry:
  "OS::Networking::FloatingIP": "OS::Nova::FloatingIP"
```

Bạn có thể sử dụng các ký tự đại diện để map multiple resources, ví dụ map tất cả `OS::Neutron` đến `OS::Network` :  
```
resource_registry:
  "OS::Network*": "OS::Neutron*"
```

<a name="6.4"></a>
## 6.4.Override resource với custom resource	
\- Để tạo hoặc override resource với 1 custom resource, tạo file template để định nghĩa resource, và cung cấp URL đến file template trong file environment:  
```
resource_registry:
  "AWS::EC2::Instance": file:///path/to/my_instance.yaml
```

Các URL được hỗ trợ là `file`, `http` và `https`.  
\- Chú ý:  
Đuôi file template mở rộng phải là `.yaml` hoặc `.template`, hoặc nó sẽ không được coi là custom template resource.  
\- Bạn có thể giới hạn việc sử dụng custom resource vào resource cụ thể cả tempalte:  
```
resource_registry:
  resources:
    my_db_server:
      "OS::DBInstance": file:///home/mine/all_my_cool_templates/db.yaml
```









