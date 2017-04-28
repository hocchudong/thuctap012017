# Token Format

## Mục lục
- [1. Các loại token](#history)
- [2. UUID Tokens](#uuid)
- [3. PKI Tokens](#pki)
- [4. Fernet Tokens](#fernet)

<a name=history></a>
## 1. Các loại token
- UUID:
	- Kích thước nhỏ: 32 ký tự
	- Dễ dàng sử dụng, đủ đơn giản để thêm vào lệnh cURL.
	- Hạn chế của UUID là không đủ thông tin để các dịch vụ khác xác định Role của user. Do đó, các dịch vụ khác phải gửi token này quay lại cho keystone để xác thực.
- PKI:
	- Chứa đủ thông tin để thực hiện ủy quyền user ngay tại từng dịch vụ và cả một danh mục dịch vụ của user (catalog service).
	- Token được ký danh và dịch vụ có thể cache lại token, sử dụng cho tới khi token hết hạn hoặc bị hủy bỏ.
	- PKI làm giảm traffic đến keystone server nhưng kích thước lớn (8kb) khó khăn để gửi trong HTTP header vì nhiều webserver không xử lý được HTTP header 8KB trừ khi cấu hình lại.
	- Khó sử dụng bằng cURL command
	-> chuẩn PKI được cải tiến thanh PKIz - nén token PKI lại nhưng kích thước vẫn lớn 
- Fernet Token:
	- Kích thước nhỏ - 255 bytes
	- Chứa đủ thông tin cho tiến trình authorization cục bộ tại các OpenStack services khi người dùng request tới.
	- Fernet Token không lưu trong database của keystone. Trong các chuẩn token cũ, Keystone phải lưu token trong database dẫn tới việc fill up, làm giảm hiệu năng của Keystone.

=> Fernet token là loại token được sử dụng trong hầu hết các môi trường openstack.

<a name=uuid></a>
## 2. UUID Tokens
- Đơn giản là sinh ra một chuỗi ngẫu nhiên 32 ký tự.
- Tạo nên từ các chỉ số hệ thập lục phân
- Tokens URL thân thiện và an toàn khi gửi đi trong môi trường non-binary.
- Lưu trữ trong hệ thống backend (như database) bề vững để sẵn sàng cho mục đích xác thực
- UUID không bị xóa trong hệ thống lưu trữ nhưng sẽ bị đánh dấu là "revoked" (bị thu hồi) thông qua DELETE request với token ID tương ứng.
- Do kích thước cực nhỏ nên dễ dàng sử dụng khi truy cập Keystone qua 1 cURL command.

<a name=pki></a>
## 3. PKI Tokens
- Kích thước tương đối lớn - 8KB
- Chứa nhiều thông tin: thời điểm khởi tạo, thời điểm hết hạn, user id, project, domain, role gán cho user, danh mục dịch vụ nằm trong payload.
- Muốn gửi token qua HTTP, JSON token payload phải được mã hóa base64 với 1 số chỉnh sửa nhỏ. Cụ thể, Format=CMS+[zlib] + base64. Ban đầu JSON payload phải được ký sử dụng một khóa bất đối xứng(private key), sau đó được đóng gói trong CMS (cryptographic message syntax - cú pháp thông điệp mật mã). Với PKIz format, sau khi đóng dấu, payload được nén lại sử dụng trình nén zlib. Tiếp đó PKI token được mã hóa base64 và tạo ra một URL an toàn để gửi token đi.
- Các OpenStack services cache lại token này để đưa ra quyết định ủy quyền mà không phải liên hệ lại keystone mỗi lần có yêu cầu ủy quyền dịch vụ cho user.
- Kích thước của 1 token cơ bản với single endpoint trong catalog lên tới 1700 bytes. Với các hệ thống triển khai lớn nhiều endpoint và dịch vụ, kích thước của PKI token có thể vượt quá kích thước giới hạn cho phép của HTTP header trên hầu hết các webserver(8KB). Thực tế khi sử dụng chuẩn token PKIz đã nén lại nhưng kích thước giảm không đáng kể (khoảng 10%).
- PKI và PKIz tokens tuy rằng có thể cached nhưng chúng có nhiều hạn chế
- Khó cấu hình để sử dụng
- Kích thước quá lớn làm giảm hiệu suất web
- Khó khăn khi sử dụng trong cURL command.
- Keystone phải lưu các token với rất nhiều thông tin trong backend database với nhiều mục đích, chẳng hạn như tạo danh sách các token đã bị thu hồi. Hệ quả là người dùng phải lo về việc phải flush Keystone token database định kì tránh ảnh hưởng hiệu suất.

<a name=fernet></a>
## 4. Fernet Tokens

#### 4.1. Thông tin cơ bản
- Độ dài 255 ký tự (lớn hơn UUID nhưng nhỏ đáng kể so với PKI và PKIz)
- Chứa đủ thông tin cần thiết mà không phải lưu token trong database: user id, project id, thời gian expire, etc.
- Dựa trên phương pháp xác thực mật mã học - Fernet
- Sử dụng mã hóa khóa đối xứng.

#### 4.2. Fernet Keys
- Fernet Keys lưu trữ trong /etc/keystone/fernet-keys:
- Mã hóa với Primary Fernet Key
- Giải mã với danh sách các Fernet Key
- Có ba loại file key:
	-Loại 1 - Primary Key sử dụng cho cả 2 mục đích mã hóa và giải mã fernet tokens. Các key được đặt tên theo số nguyên bắt đầu từ 0. Trong đó Primary Key có chỉ số cao nhất.
	- Loại 2 - Secondary Key chỉ dùng để giải mã. -> Lowest Index < Secondary Key Index < Highest Index
	- Stagged Key - tương tự như secondary key trong trường hợp nó sử dụng để giải mã token. Tuy nhiên nó sẽ trở thành Primary Key trong lần luân chuyển khóa tiếp theo. Stagged Key có chỉ số 0.
- Fernet Key format: fernet key là một chuẩn mã hóa base64 của Signing Key (16 bytes) và Encrypting Key (16 bytes):` Signing-key ‖ Encryption-key`

#### 4.3. Fernet Key rotation
![Imgur](http://i.imgur.com/bBGBE1d.png)

- Quy tắc xoay key được thể hiện như hình trên
- Tùy thuộc vào cấu hình lượng key trong file `/etc/keystone/fernet-keys/`, các keys cũ sẽ bị xóa đi sau mỗi lần xoay.
- Giả sử ở ví dụ như hình trên, chúng ta chỉ cấu hình lưu trữ 3 key. Ở vòng xoay cuối, key số 1 sẽ bị xóa bị. Các keys còn lại là `0 2 3`.

#### 4.4. Kế hoạch cho vấn đề rotated keys

Khi sử dụng fernet tokens yêu cầu chú ý về thời hạn của token và vòng đời của khóa. Vấn đề nảy sinh khi secondary keys bị remove khỏi key repos trong khi vẫn cần dùng key đó để giải mã một token chưa hết hạn (token này được mã hóa bởi key đã bị remove). 
Để giải quyết vấn đề này, trước hết cần lên kế hoạch xoay khóa. Ví dụ bạn muốn token hợp lệ trong vòng 24 giờ và muốn xoay khóa cứ mỗi 6 giờ. Như vậy để giữ 1 key tồn tại trong 24h cho mục đích decrypt thì cần thiết lập max_active_keys=6 trong file keytone.conf (do tính thêm 2 key đặc biệt là primary key và staged key ). Điều này giúp cho việc giữ tất cả các key cần thiết nhằm mục đích xác thực token mà vẫn giới hạn được số lượng key trong key repos (/etc/keystone/fernet-keys/).
```sh
token_expiration = 24
rotation_frequency = 6
max_active_keys = (token_expiration / rotation_frequency) + 2
```

- Token_expiration: chúng ta có thể chỉ định thời gian mà token có giá trị trong section `[token]`

```sh
[token]
...
# The amount of time that a token should remain valid (in seconds). Drastically
# reducing this value may break "long-running" operations that involve multiple
# services to coordinate together, and will force users to authenticate with
# keystone more frequently. Drastically increasing this value will increase
# load on the `[token] driver`, as more tokens will be simultaneously valid.
# Keystone tokens are also bearer tokens, so a shorter duration will also
# reduce the potential security impact of a compromised token. (integer value)
# Minimum value: 0
# Maximum value: 9223372036854775807
expiration = 180 //cho phép token có giá trị trong vòng 3 phút

```

- Vấn đề xoay key, chúng ta sẽ sử dụng lệnh `keystone-manage fernet-rotate --keystone-user keystone --keystone-group keystone`

![Imgur](http://i.imgur.com/VNKrHmb.png)

với `max_active_keys = 4` và sau một số lần thực hiện lệnh xoay key ở trên thì ta có kết quả như hình.