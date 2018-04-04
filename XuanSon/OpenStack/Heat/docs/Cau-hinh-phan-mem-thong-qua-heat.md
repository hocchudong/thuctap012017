# Cấu hình phần mềm thông qua Heat

# MUC LỤC
- [1.Image building](#1)
- [2.User-data boot scripts và cloud-init](#2)
  - [2.1.Chọn user_data_format](#2.1)
  - [2.2.Software config resources](#2.2)
- [3.Software deployment resources](#3)


\- Có nhiều tùy chọn để cấu hình phần mềm chạy trên server trong stack. Chúng có thể được chia thành các loại sau:  
- Tự xây dựng image tùy chỉnh
- User-data boot scripts và cloud-init
- Tài nguyên triển khai phần mềm

<a name="1"></a>
# 1.Image building
\- 1 số lý do mà bạn muốn xây dựng image tùy chỉnh:
- **Boot speed**: vì phần mềm đã có trên image không cần phải tải về và không cần cài đặt đặt lúc boot.
- **Boot reliability**: Tải phần mềm có thể lỗi vì 1 số lý do bao gồm việc mạng bị lỗi và kho phần mềm không nhất quán.
- **Test verification**: Xây dựng hình ảnh tùy chọn được kiểm tra trong môi trường thử nghiệm trước khi cung cấp bản production.
- **Configuration dependencies**: cấu hình sau khi boot phụ thuộc và agent đã được cài đặt và kích hoạt.

\- 1 số công cụ để xây dựng image tùy chọn, bao gồm:
- **diskimage-builder**: công cụ xây dựng image cho OpenStack
- **imagefactory**: xây dựng image cho các hệ điều hành/ cloud combinations

<a name="2"></a>
# 2.User-data boot scripts và cloud-init
\- Khi boot server, ta có thể chỉ định nội dung user-data được truyền đến server. User-data được tạo sẵn từ cấu hình config-drive hoặc từ Metadata service.  
\- Công cụ phổ biến nhất để truyền user-data cho cloud image là Cloud-init.  
\- VD:  
```
resources:

  the_server:
    type: OS::Nova::Server
    properties:
      # flavor, image etc
      user_data: |
        #!/bin/bash
        echo "Running boot script"
        # ...
```

\- Chú ý:  
Scripts đôi khi xảy ra lỗi, gỡ lỗi scripts bằng cách xem log boot, sử dụng lệnh `nova console-log <server-id>` hoặc `openstack console log show <server>` .  
\- Thiết lập các giá trị biến dựa trên parameters hoặc resource trong stack. Điều này có thể được thực hiện với intrinsic function `str_replace`:  
```
parameters:
  foo:
    type: string
    label: Foo
    description: Foo
    default: bar

resources:

  the_server:
    type: OS::Nova::Server
    properties:
      # flavor, image etc
      user_data:
        str_replace:
          template: |
            #!/bin/bash
            echo "Running boot script with $FOO"
            # ...
          params:
           $FOO: {get_param: foo}
```

\- Cảnh báo:  
Nếu stack-update được thực hiện và có bất kỳ thay đổi nào đến tất cả nội dụng của user_data thì server sẽ được thay thế (xóa và tạo lại) để cấu hình sửa đổi có thể chạy trên 1 server mới.  
\- Script khá dài để chứa trong template, do đó  intrinsic function get_file có thể được sử dụng để duy trì các tập lệnh trong 1 file riêng biệt:  
```
parameters:
  foo:
    type: string
    label: Foo
    description: Foo
    default: bar

resources:

  the_server:
    type: OS::Nova::Server
    properties:
      # flavor, image etc
      user_data:
        str_replace:
          template: {get_file: the_server_boot.sh}
          params:
            $FOO: {get_param: foo}
```

<a name="2.1"></a>
## 2.1.Chọn user_data_format
\- Properties `user_data_format` cho phép chỉ định định dạng `user_data` cho server. Mặc định giá trị là H`EAT_CFNTOOLS`, ngoài ra còn các giá trị là `RAW` hoặc `SOFTWARE_CONFIG`.  
\- VD:  
```
resources:

  server_with_boot_script:
    type: OS::Nova::Server
    properties:
      # flavor, image etc
      user_data_format: RAW
      user_data: |
        #!/bin/bash
        echo "Running boot script"
        # ...

  server_with_cloud_config:
    type: OS::Nova::Server
    properties:
      # flavor, image etc
      user_data_format: RAW
      user_data: |
        #cloud-config
        final_message: "The system is finally up, after $UPTIME seconds"
```

<a name="2.2"></a>
## 2.2.Software config resources
\- Cấu kịch bản cấu hình boot cũng có thể quản lý như các resource của họ, điều này cho phép cấu hình định nghĩa 1 lần và chạy trên nhiều server resources. Software-config resource được lưu trữ và lấy ra thông qua lời goinj Orchestration API. Không thể sửa đổi nội dung của software-config resource, do đó, stack-update thay đổi bất kì software-config resource đã tồn tại sẽ dẫn đến các lời gọi API để tạo ra cấu hình mới và xóa cấu hình cũ.  
\- Resource `OS::Heat::SoftwareConfig` được sử dụng để lưu trữ cấu hình, vd:  
```
resources:
  boot_script:
    type: OS::Heat::SoftwareConfig
    properties:
      group: ungrouped
      config: |
        #!/bin/bash
        echo "Running boot script"
        # ...

  server_with_boot_script:
    type: OS::Nova::Server
    properties:
      # flavor, image etc
      user_data_format: SOFTWARE_CONFIG
      user_data: {get_resource: boot_script}
```

<a name="3"></a>
# 3.Software deployment resources
\- Tham khảo:
https://docs.openstack.org/heat/pike/template_guide/software_deployment.html#software-deployment-resources  


