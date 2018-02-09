# Template của HEAT

# 1.Giới thiệu
\- Heat hỗ trợ 2 loại template là HOT và CFN :  
- CFN (CloudFormation-compatible format ) : là định dạng được hỗ trợi bởi Heat trong thời gian qua . CFN được viết dưới dạng JSON . VD : AWS dùng định dạng CFN ( AWS CloudFormation template ) để cho phép người dùng tạo và quản lí các tài nguyên .
- HOT (Heat Orchestration Template ) : là 1 định dạng template mới thay thế cho CFN. HOT được viết dưới dạng YAML . HOT được hỗ trợ từ phiên bản OPS Icehouse .

\- Trong hướng dẫn này, mình sẽ sử dung định dạng HOT của Heat.  

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
- **conditions**: Section này bao gồm các câu lệnh có thể được sử dụng để hạn chế khi tài nguyên được tạo ra hoặc khi 1 thuộc tính được định nghĩa. Chúng có thể được liên kết với các tài nguyên và properties tài nguyên trong section resources, cũng có thể được kết hợp với các section outputs của template.
Hỗ trợ section này được thêm vào từ phiên bản Newton.

























