# Template của HEAT

# MỤC LỤC


<a name="1"></a>
# 1.Giới thiệu
\- Heat hỗ trợ 2 loại template là HOT và CFN :  
- CFN (CloudFormation-compatible format ) : là định dạng được hỗ trợi bởi Heat trong thời gian qua . CFN được viết dưới dạng JSON . VD : AWS dùng định dạng CFN ( AWS CloudFormation template ) để cho phép người dùng tạo và quản lí các tài nguyên .
- HOT (Heat Orchestration Template ) : là 1 định dạng template mới thay thế cho CFN. HOT được viết dưới dạng YAML . HOT được hỗ trợ từ phiên bản OPS Icehouse .

\- Trong hướng dẫn này, mình sẽ sử dung định dạng HOT của Heat.  

<a name="2"></a>
# 2.Cấu trúc của template HOT
\- Các thành phần của HOT được chia thành các section như sau:  
```
-  heat_template_version: <heat_version>
# chỉ định version của HOT

- description
# mô tả về template (optional)

- parameter_groups
# khai báo input parameter groups và order (optional)

- parameters
# khai báo input parameters (optional)

-  resources
# khai báo template resources

- outputs
# khai báo output parameters (optional)

- conditions
# khai báo conditions
```

- **heat_template_version**: chỉ định version của HOT.
- **description**: Mô tả về template, hoặc workload có thể được triển khai bởi template. Section này là option.
- **parameter_groups**: Section này cho phép xác định các input parameters được nhóm lại như thế nào và thứ tự cung cấp các parameters. Section này là option.
- **parameters**: Section này cho phép xác định input parameters mà được cung cấp khi khởi tạo template. Section này là option.
- **resources**: Section này chứa khai báo về tài nguyên của template. Section này có ít nhất 1 tài nguyên đực định nghĩa trong HOT template, hoặc template sẽ không thực hiện bất cứ điều gì khi được khởi tạo.  
VD: Khi viết một template để tạo ra các Router, network, VM thì lúc này cần định nghĩa resources là Router,network, VM  
- **outputs**: Section này cho phép chỉ định các output parameters cho người dùng khi template được khởi tạo. Section này là option. 
- **conditions**: Section này bao gồm các câu lệnh có thể được sử dụng để hạn chế khi tài nguyên được tạo ra hoặc khi 1 thuộc tính được định nghĩa. Chúng có thể được liên kết với các tài nguyên và properties tài nguyên trong section resources, cũng có thể được kết hợp với các section `outputs` của template.
Hỗ trợ section này được thêm vào từ phiên bản Newton.

<a name="2.1"></a>
## 2.1.heat_template_version
\- Mỗi version sẽ hỗ trợ một số tính năng nhất định, truy cập  
https://docs.openstack.org/heat/pike/template_guide/hot_spec.html#heat-template-version  
để biết các tính năng này.  
\- Cú pháp :  
```
heat_template_version: 2017-09-01
```

<a name="2.2"></a>
## 2.2.description
\- Đây là section tùy chọn cho phép mô tả về template HOT.  
\- Cú pháp:  
```
description: Simple template to deploy a single compute instance
```

Nếu bạn muốn mô tả không phải trên 1 dòng mà là trên nhiều dòng , bạn có thể làm như sau :  
```
description: >
  This is how you can provide a longer description
  of your template that goes over several lines.
```

<a name="2.3"></a>
## 2.3.prameters_group
\- Định nghĩa dưới dạng danh sách với mỗi group chứa một danh sách các params.  
\- Các danh sách được sử dụng để biểu thị thứ tự mong muốn của các parameters.  
\- Mỗi parameters chỉ được liên kết với 1 group được chỉ định để rằng buộc nó vào 1 parameters trong section parameters.  
\- Cú pháp:  
```
parameter_groups:
- label: <human-readable label of parameter group>
  description: <description of the parameter group>
  parameters:
  - <param name>
  - <param name>
```

- **label**: nhãn mà người dùng có thể đọc được liên kết đến group của các parameters.
- **description**: mô tả về parameters group.
- **parameters**: một danh sách của các parameters trong parameters group này.
- **param name**: tên của các parameters được định nghĩa trong liên kết với section parameters.

<a name="2.4"></a>
## 2.4.parameters section
\- Parameters thường được sử dụng để tùy chọn mỗi lần triển khai (vd: username và password) hoặc ràng buộc với các thông tin cụ thể về environment như các images.  
\- Mỗi parameters được chỉ định trong 1 khối lồng nhau riêng biệt với tên của các parameters được định nghĩa trong dòng đầu tiên và các thuộc tính bổ sung như kiểu hoặc giá trị mặc định được định nghĩa là phần tử lồng nhau.  
\- Cú pháp:  
```
parameters:
  <param name>:
    type: <string | number | json | comma_delimited_list | boolean>
    label: <human-readable name of the parameter>
    description: <description of the parameter>
    default: <default value for parameter>
    hidden: <true | false>
    constraints:
      <parameter constraints>
    immutable: <true | false>
```

- **param name**: tên của parameter.
- **type**: loại của parameter là 1 trong số `string`, `number`, `comma_delimited_list`, `json` và `boolean` (cần phải có)
- **label**: Tên người dùng đọc được cho parameters. Thuộc tính này là option.
- **description**: Mô tả về parameter. Thuộc tính này là option.
- **default**: giá trị mặc định được sử dụng nếu người dùng không truyền giá trị vào. Thuộc tính này là option.
- **hidden**: Xác định liệu parameters có nên được ẩn khi người dùng yêu cầu thông tin về stack được tạo từ template. Thuộc tính này có thể được dụng để ẩn password được chỉ định như parameters.
- Thuộc tịnh này là option và mặc định là `false`.
- **constraints**: Đây là điều kiện ràng buộc của param. Khi khai báo param thì nó sẽ check xem thông số của param có trong hệ thống không. Đây là trường tùy chọn.
- **immutable**  
Defines whether the parameter is updatable. Stack update fails, if this is set to true and the parameter value is changed. This attribute is optional and defaults to false.  

\- Bảng sau đây sẽ mô tả tất cả các types được hỗ trợ hiện tại (ở đây là bản OpenStack Pike):  

|Type|Mô tả|Ví dụ|
|---|---|---|
|string|Một xâu ký tự|"String param"|
|number|integer hoặc float.|“2”; “0.2”|
|comma_delimited_list|An array of literal strings that are separated by commas. The total number of strings should be one more than the total number of commas.|“one,two”; Note: “one,two” returns [“one”, ”two”]|
|json|A JSON-formatted map or list.|{“key”: “value”}|
|boolean|Giá trị type Boolean có thể bằng “t”, “true”, “on”, “y”, “yes”, hoặc “1” cho giá trị true và “f”, “false”, “off”, “n”, “no”, or “0” cho giá trị false.|“on”; “n”|

\- Ví dụ:  
```
parameters:
  user_name:
    type: string
    label: User Name
    description: User name to be configured for the application
  port_number:
    type: number
    label: Port Number
    description: Port number to be configured for the web server
```

\- Note:  
```
description và label là option, nhưng định nghĩa thuộc tính này là hữu ích để cung cấp thông tin về vai trò của parameter cho người dùng.
```

<a name="2.5"></a>
## 2.5.resource section
\- Xác định resource thực tế làm nên 1 stack được deploy từ HOT template (vd: instance, network, storage volumes).  
\- Mỗi `resource` được định nghĩa trong 1 khối riêng biệt ở trong `resource` section.  
```
resources:
  <resource ID>:
    type: <resource type>
    properties:
      <property name>: <property value>
    metadata:
      <resource specific metadata>
    depends_on: <resource ID or list of ID>
    update_policy: <update policy>
    deletion_policy: <deletion policy>
    external_id: <external resource ID>
    condition: <condition name or expression or boolean>
```

- **resource ID**: ID của Resource phải là giá trị duy nhất trong section resource của template.
- **type**: Loại Resource, ví dụ như: OS::Nova::Server or OS::Neutron::Port. Attribute này bắt buộc phải có trong Resource và tùy theo Resouce mà cần chỉ ra loại. VD như Resouce là VM thì cần định nghĩa loại là OS::Nova::Server
- **properties**: A list of resource-specific properties. The property value can be provided in place, or via a function (see [Intrinsic functions](https://docs.openstack.org/heat/pike/template_guide/hot_spec.html#hot-spec-intrinsic-functions)). This section is optional.
- **metadata**: Resource-specific metadata. This section is optional.
- **depends_on**: This attribute is optional.
- **update_policy**: This attribute is optional.
- **deletion_policy**: This attribute is optional.
- **external_id**: This attribute is optional.
- **condition**: This attribute is optional.

\- VD : Định nghĩa 1 compute resource đơn giản :  
```
resources:
  my_instance:
    type: OS::Nova::Server
    properties:
      flavor: m1.small
      image: F18-x86_64-cfntools
```

<a name="2.6"></a>
## 2.6.output section
\- Section outputs định nghĩa ra các parameters trả về cho người dùng sau khi stack được tạo ra , ví dụ như địa chỉ IP của instance, địa chỉ URL của ứng dụng web được triển khai trong stack.  
\- Mỗi output parameters được định nghĩa trong 1 khối riêng biệt trong phần output theo cú pháp:  
```
outputs:
  <parameter name>:
    description: <description>
    value: <parameter value>
    condition: <condition name or expression or boolean>
```

- **parameter name**: Tên output parameter, nó phải là duy nhất trong section outputs của template.
- **description**: Mô tả ngắn của output parameter. Attribute là optional.
- **parameter value**: Giá trị của output parameter. Giá trị này thường được lấy bằng sử dụng hàm số. Attribute là bắt buộc.
- **condition**: To conditionally define an output value. None value will be shown if the condition is False. This attribute is optional.  
Chú ý: condition được hỗ trợ cho output từ phiên bản OpenStack Newton.

\- Ví dụ:  
```
outputs:
  instance_ip:
    description: IP address of the deployed compute instance
    value: { get_attr: [my_instance, first_address] }
```

<a name="3"></a>
# 3.Intrinsic functions sử dụng trong template
\- HOT cung cấp một bộ các hàm nội bộ (intrinsic functions) có thể được sử dụng bên trong các template để thực hiện các tác vụ cụ thể, chẳng hạn như lấy giá trị của resource attribute tại thời điểm đang chạy stack. Section mô tả vai trò và cú pháp của intrinsic functions.  
\- Chú ý: Các hàm này chỉ có thể được sử dụng trong section "**properties**" của section **resource** hoặc section **outputs**.  

<a name="3.1"></a>
## 3.1.get_attr
\- Hàm `get_attr` tham chiếu đến attribute của resource. Giá trị attribute được phân giản tại runtime bằng cách sử dụng resource instance được tạo từ định nghĩa tài nguyên tương ứng.  
\- Tham chiếu attribute dựa trên phiên bản heat sử dụng, vd: `heat_template_version 2014-10-16` hoặc cao hơn.  
\- Cú pháp của hàm get_attr:  
```
get_attr:
  - <resource name>
  - <attribute name>
  - <key/index 1> (optional)
  - <key/index 2> (optional)
  - ...
```

**resource name**  
- Tên resource mà attribute cần được giải quyết.  
- Tên resource phải tồn tại trong section `resources` của template.  

**attribute name**  
- Tên attibute cần được giải quyết. Nếu attribute trả về 1 cấu trúc dữ liệu phức tạp như 1 list hoặc map, thì các key hoặc index tiếp theo có thể được chỉ định. Các parameter bổ sung được sử dụng để hướng cấu trúc dữ liệu về giá trị mong muốn.  

\- VD minh họa về hàm `get_attr`:  
```
resources:
  my_instance:
    type: OS::Nova::Server
    # ...

outputs:
  instance_ip:
    description: IP address of the deployed compute instance
    value: { get_attr: [my_instance, first_address] }
  instance_private_ip:
    description: Private IP address of the deployed compute instance
    value: { get_attr: [my_instance, networks, private, 0] }
```

Trong VD này, attribute của networks chứa các dữ liệu sau:  
```
{"public": ["2001:0db8:0000:0000:0000:ff00:0042:8329", "1.2.3.4"],
 "private": ["10.0.0.1"]}
```

Từ `heat_template_version: '2015-10-15'` <attribute_name> là option và nếu <attribute_name>  không được chỉ định, `get_attr` trả về dict của tất cả các attribute cho resource nhất định trừ attributes **show**. Trong trường hợp này cú pháp sẽ là tiếp theo:  
```
get_attr:
  - <resource_name>
```

<a name="3.2"></a>
## 3.2.get_file
\- Chức năng get_file trả về nội dung của file vào template. Nó thường được sử dụng như file chứa các scripts hoặc file cấu hình.  
\- Cú pháp:  
```
get_file: <content key> 
```

`content key`: là một đường đẫn hoặc URL cố đinh chứ không thể là một biến lấy từ `get_param` . Lệnh  Orchestration client hỗ trợ đường dẫn tương đối và chuyển đổi các URL này theo các URL tuyệt đối theo yêu cầu cấu Orchesstration API.  
>Note:  
Đối số của get_file phải là đường dẫn hoặc URL và không dựa vào các intrinsic function như get_param.

\- VD: Hàm `get_file` với cả đường dẫn, URL tương đối và tuyệt đối.  
```
resources:
  my_instance:
    type: OS::Nova::Server
    properties:
      # general properties ...
      user_data:
        get_file: my_instance_user_data.sh
  my_other_instance:
    type: OS::Nova::Server
    properties:
      # general properties ...
      user_data:
        get_file: http://example.com/my_other_instance_user_data.sh
```

Từ điển files được tạo ra bởi Orchestraion client trong quá trình khởi tạo của stack sẽ chứa các khóa sau:  
- file:///path/to/my_instance_user_data.sh
- http://example.com/my_other_instance_user_data.sh

<a name="3.3"></a>
## 3.3.get_param
\- Hàm `get_param` tham chiếu **input parameter** của template. Nó giải quyết đến giá trị được cung cấp cho input parameter tại runtime.  
\- Cú pháp:  
```
get_param:
 - <parameter name>
 - <key/index 1> (optional)
 - <key/index 2> (optional)
 - ...
```

**parameter name**
- parameter name cần được giải quyết. Nếu parameter trả lại 1 cấu trúc dữ liệu phức tạp như 1 list hoặc map, thi các key hoặc index có thể được chỉ định. Các parameter bổ sung này được sử dụng để điều hướng cấu trúc dữ liệu trả về giá trị mong muốn.

\- VD:  
```
parameters:
  instance_type:
    type: string
    label: Instance Type
    description: Instance type to be used.
  server_data:
    type: json

resources:
  my_instance:
    type: OS::Nova::Server
    properties:
      flavor: { get_param: instance_type}
      metadata: { get_param: [ server_data, metadata ] }
      key_name: { get_param: [ server_data, keys, 0 ] }
```

Trong VD trên, nếu parameter `instance_type` và `server_data` chứa dữ liệu:  
```
{"instance_type": "m1.tiny",
{"server_data": {"metadata": {"foo": "bar"},
                 "keys": ["a_key","other_key"]}}}
```

sau đó, giá trị của property `flavor` sẽ phân giải đến `m1.tiny`, `metadata` phân giải đến `{"foo": "bar"}` and `key_name` sẽ phân giải đến `a_key`.  

<a name="3.4"></a>
## 3.4.get_resource
\- get_resource tham chiếu đến resource khác trong cùng 1 template. Tại runtime, nó được giải quyết để tham chiết đến ID của resource liên quan. VD, tham chiếu đến floating IP resource cụ thể và trả về địa chỉ IP tại rumtime.  
\- Cú pháp:  
```
get_resource: <resource ID>
```

resource ID được tham chiếu được đưa ra dưới dạng một parameter cho hàm `get_resource`.  
```
resources:
  instance_port:
    type: OS::Neutron::Port
    properties: ...

  instance:
    type: OS::Nova::Server
    properties:
      ...
      networks:
        port: { get_resource: instance_port }
```







