# Token Formats




# MỤC LỤC
- [1.History of Keystone Token Formats](#1)
- [2.UUID Tokens](#2)
	- [2.1.Thông tin cơ bản](#2.1)
	- [2.2.Token Generation Workflow](#2.2)
	- [2.3.Token Validation Workflow](#2.3)
	- [2.4.Token Revocation Workflow](#2.4)
	- [2.5.UUID – Multiple Data Centers](#2.5)
	- [2.6.Pros and Cons](#2.6)
- [3.PKI/PKIZ Tokens](#3)
	- [3.1.Thông tin cơ bản](#3.1)
	- [3.2.PKI/PKIZ Configuration – Certificates](#3.2)
	- [3.3.Token Generation Workflow](#3.3)
	- [3.4.Token Validation Workflow](#3.4)
	- [3.5.Token Revocation Workflow](#3.5)
	- [3.6.PKI/PKIZ – Multiple Data Centers](#3.6)
	- [3.7.Pros and Cons](#3.7)
- [4.Fernet](#4)
	- [4.1.Thông tin cơ bản](#4.1)
	- [4.2.Fernet Configuration](#4.2)
	- [4.3.Fernet Keys](#4.3)
	- [4.4.Fernet Key Rotation](#4.4)
	- [4.5. Kế hoạch cho vấn đề rotated keys](#4.5)
	- [4.6.Token Generation Workflow](#4.6)
	- [4.7.Token Validation Workflow](#4.7)
	- [4.8.Token Revocation Workflow](#4.8)
	- [4.9.Fernet – Multiple Data Centers](#4.9)
	- [4.10.Proc and Cons](#4.10)





<a name="1"></a>
# 1.History of Keystone Token Formats
\- Keystone cung cấp một vài token format. Để giúp hiểu rõ tại sao, chúng tôi cung cấp một lịch sự ngắn gọn về Keystone token formats đã phát triển ra sau.  
Trong những ngày đầu, Keystone hỗ trợ UUID token. Token này là 32-character string được sử dụng để authentication và authorization. Ưu điểm của token format này là token small và very easy để sử dụng, và nó đủ simple để add vào cURL command. Nhược điểm của token này là nó ko mang đủ information để thực hiện authorizaton.OpenStack services sẽ luôn luôn gửi token này quay lại Keystone server để xác định xem hoạt động của nó có được authorized hay không? Điều này dẫn đến Keystone được pinged cho bất kỳ hành động OpenStack, và trở hành bottleneck cho all of OpenStack.  
\- Để cố gắng giải quyết các vấn đề gặp phải với UUID tokens, Keystone team đã tạo ra một new token format được gọi là PKI token. Token này chứa đủ information để thực hiện local authorization và cũng chứa service catalog trong token. Ngoài ra, token đã được đăng kí và service có thể lưu trữ token và sử dụng nó cho đến khi nó hết hạn hoặc bị revoked. PKI token dẫn đến traffic truy cập đến Keystone server ít hơn, nhưng nhược điểm của token này là chúng rất lứn. PKI token dễ dàng có kích thowcs 8K, và điều này làm cho chúng khó khớp với HTTP header. Nhiều web server không thể xử lý 8K entry trong HTTP header mà không được cấu hình lại. Ngoài ra, token khó sử dụng trong cURL commands và cung cấp trải nghiệm user kém. Keystone team đã thử một biến thể của token là compressed. Token format được gọi là PKIz. Thật không may, feedbacj từ OpenStack community về token format này vẫn còn quá lớn.  
\- Keystone team đã đưa ra một new token format là Fernet token. Fernet token nhỏ (khoảng 255 character) nhưng chứa đựng đủ information trong nó để được sử dụng local authorization. Token này có một ưu điểm khác. Nó được chứa đủ information mà Keystone không phải lưu trữ token data trong token database. Một trong những điều khó chịu nhất của Keystone’s early token formats là chúng cần được persisted trong database. Databse sẽ lấp đầy và hiệu suất của Keystone sẽ giảm. Các công ty sử OpenStack phải luôn luôn để flush cho Keystone token database để giữa OpenStack environments running.  
Fernet token đã có nhược điểm là symmetric key được sử dụng để sign the tokens needed to be distributed and rotated. OpenStack operators cần phải tìm ra phương pháp giải quyết phần đề này.Tuy nhiên, operators đã làm việc với nhau và họ phải giải quyết vấn đề distribution associated Fernet tokens hơn là sử dụng other token formats và chịu trách nhiệm cho flushing the Keystone token database.  
\- With so many token choices, you may be wondering which tokens are used by OpenStack operators. Fortunately, the OpenStack community performs user surveys to gain these types of insights. As shown in the chart below, the UUID token is currently the most popular format. Please note, however, that this survey was performed in the OpenStack Juno release time frame, and does not include Fernet tokens because they were not added until the Kilo release.
A survey conducted by the OpenStack User committee indicates that UUID tokens are still the preferred token format (as of Juno).  

<img src="http://imgur.com/AxUotKw.png" />

In this chapter, we describe Keystone’s UUID, PKI, and Fernet tokens in greater detail to provide the reader with a much better understanding of the token formats that are available to them in Keystone.
For all three token formats, it is important to note that all are bearer tokens. This means all three tokens need to be protected from unnecessary disclosure to prevent unauthorized access.

<a name="2"></a>
# 2.UUID Tokens

<a name="2.1"></a>
## 2.1.Thông tin cơ bản
\- Keystone’s first token format was the UUID token format. The UUID token is simply a randomly generated UUID 32-character string. These are issued and validated by the identity service. A hexdigest() method is used, which ensures the tokens are made up of solely hexadecimal digits. This makes the tokens URL friendly and safe for transfer in any non-binary environment. A UUID token must be saved in a persistent backend (typically a database) in order to be available for subsequent validation. A UUID token can be revoked by simply issuing a DELETE request with the token ID. Note that the token is not actually removed from the backend, but rather marked as revoked. Since the token is only 32 characters, its size in an HTTP header is 32 bytes.  
\- A typical UUID token would look like the following: 468da447bd1c4821bbc5def0498fd441.  
\- Token là rất nhỏ và dễ sử dụng khi accessing Keystone thông qua cURL command. As previously mentioned, the disadvantage with this token format is that Keystone can become a bottleneck due to the tremendous amount of communication that occurs when Keystone is needed to validate the token.  
\- Version 4 UUID.
\- Configuration in `keystone.conf` :  
```
[token]
provider = keystone.token.providers.uuid.Provider
```

<a name="2.2"></a>
## 2.2.Token Generation Workflow
<img src="http://imgur.com/TS2FOqU.png" />


\- Workflow tạo UUID token diễn ra như sau:  
- User request tới keystone tạo token với các thông tin: user name, password, project name
- Chứng thực user, lấy User ID từ backend LDAP hoặc SQL (dịch vụ Identity)
- Chứng thực project, thu thập thông tin Project ID và Domain ID từ Backend SQL (dịch vụ Resources)
- Lấy ra Roles từ Backend trên Project hoặc Domain tương ứng trả về cho user, nếu user không có bất kỳ roles nào thì trả về Failure(dịch vụ Assignment)
- Thu thập các Services và các Endpoints của các service đó (dịch vụ Catalog)
- Tổng hợp các thông tin về Identity, Resources, Assignment, Catalog ở trên đưa vào Token payload, tạo ra token sử dụng hàm uuid.uuid4().hex
- Lưu thông tin của Token và SQL/KVS backend với các thông tin: TokenID, Expiration, Valid, UserID, Extra

\- Sample UUID Token in SQL Backend:  
<img src="http://imgur.com/eqe7FN9.png" />

<a name="2.3"></a>
## 2.3.Token Validation Workflow
<img src="http://imgur.com/6o8pfYY.png" />

Token Validation Workflow :  
- User gửi yêu cầu chứng thực token sử dụng method GET v3/auth/tokens
- Thu thập token payload từ token backend KVS/SQL.
- Kiểm tra Vaild field value. Nếu không hợp lệ trả về thông báo “Token Not Found”. Nếu hợp lệ, chuyển sang bước tiếp theo:
- Phân tích Token và thu thập metadata (User ID, Project ID, Audit ID, Token Expiry)
- Check Current Time, nếu Current Time > Expiry Time thì gửi thông báo “Token Not Found”, ngược lại chuyển sang bước tiếp theo.
- Kiểm tra xem token đã bị thu hồi chưa (kiểm tra trong bảng revocation_event của database keystone). Nếu token đã bị thu hồi (tương ứng với 1 event trong bảng revocation_event) trả về thông báo Token Not Found. Nếu chưa bị thu hồi trả về token (truy vấn HTTP thành công HTTP/1.1 200 OK )

<a name="2.4"></a>
## 2.4.Token Revocation Workflow
<img src="http://imgur.com/ntqrMfL.png" />

Token Revocation Workflow:  
\- User gửi yêu cầu thu hồi token với API “DELETE v3/auth/tokens”. Trước khi revoking token, thực hiện quá trình validate dựa trên “Token Validation Workflow”
\- Check “Audit ID” field.  
- Nếu không có “Audit ID”, tạo sự kiện “Revoke by token Expiry” . Các thông tin cần cập nhật vào revocation_event table của database keystone là User ID, Revoke At, Issued Befor, Token Expiry.
- Nếu có “Audit ID’, tạo sự kiện “Revoke by Audit ID”. Các thông tin cần cập nhật vào revocation_event table của keystone database là Audit ID, Revoke At, Issued Before.

\- Hủy bỏ Expired.  
\- Set “vaild” thành False (=0).  

<a name="2.5"></a>
## 2.5.UUID – Multiple Data Centers
<img src="http://imgur.com/pEv0VZR.png" />

\- UUID token format không hỗ trợ authentication và authorization trên Multiple Data Centers.  
\- Như trên hình vẽ, khi user gửi “Request token” đến Keystone bên data center US-WEST và nhận được UUID Token. User dùng token này để request tới Nova với yêu cầu tạo VM.  
Nova sử dụng Keystone Middleware để gửi request tới Keystone để chứng thực token. Keystone tìm kiếm trong Tokens KVS và trả lời Nova :Token này có hiệu lực.
Nova gửi lại thông điệp cho User là VM Instance đã được tạo.  
\- Tiếp theo, User cũng dùng “Token đó” để gửi request tạo VM đến Nova bên data centers US-EAST. Nova sử dụng Keystone Middleware để gửi request tới Keystone để chứng thực token. Keystone gửi lại Nova thông điệp “Token Not Found”, và Nova gửi lại user “thông điệp “Token Not Found”. Lý do là vì “Token Backend database” bên US-EAST không được đồng bộ với bên US-WEST.  

<a name="2.6"></a>
## 2.6.Pros and Cons
\- Pros  
- Simplest and Smallest Token Format
- Recommended for Simple OpenStack Deployment

\- Cons  
- Persistent Token Format
- Token validation can only be done by Identity service
- Not feasible for multiple OpenStack deployments

<a name="3"></a>
# 3.PKI/PKIZ Tokens

<a name="3.1"></a>
## 3.1.Thông tin cơ bản
\- Token format thứ 2 được hỗ trợ bởi Keystone là PKI token format. In the PKI format, the token contains the entire validation response that would be received from Keystone.  
\- Token này có large amount of informaton trong nó. Nó chứa user identification, project, domain và role và một số information khác. Tất cả information này được biểu diễn trong JSON document payload, và payload sau đó sử dụng cryptographic message syntax (CMS). Với PKIz format, payload được compressed sử dụng zlib compression.  
\- Exmaple của JSON token payload:  
```
{
    "token": {
        "audit_ids": [
            "YyobSaHcTNCu7seusdTtpQ"
        ],
        "catalog": [
            {
                "endpoints": [
                    {
                        "id": "9a29eaf20f7942b6b9c96cfb0aa02a3e",
                        "interface": "admin",
                        "region": null,
                        "region_id": null,
                        "url": "http://104.239.163.215:35357/v3"
                    },
                    {
                        "id": "d3233afd2b6041d4a39f8ac1233757fd",
                        "interface": "public",
                        "region": null,
                        "region_id": null,
                        "url": "http://104.239.163.215:35357/v3"
                    }
                ],
                "id": "1b796e214f8140118108a7e4e4ca6e16",
                "name": "Keystone",
                "type": "identity"
            }
        ],
        "expires_at": "2015-02-26T05:48:26.094098Z",
        "extras": {},
        "issued_at": "2015-02-26T05:33:26.094127Z",
        "methods": [
            "password"
        ],
        "project": {
            "domain": {
                "id": "default",
                "name": "Default"
            },
            "id": "59002ce739f143bb8b2cc33caf98fcf9",
            "name": "admin"
        },
        "roles": [
            {
                "id": "360b177d8c2347ff95e0ac1615ba8fb6",
                "name": "admin"
            }
        ],
        "user": {
            "domain": {
                "id": "default",
                "name": "Default"
            },
            "id": "85a9af145ddb4d19a9544dfbeac5d1f0",
            "name": "admin"
        }
    }
}
```

Như show trong JSON trên, token có mọi thứ service cần với user, domain, project, và role information để xác định nếu user là authorized.  
\- Service lưu token này và authorization decisions locally mà không cần contact tới Keystone server trên mọi authorization request. Khi truyền tải token thông qua HTTP, JSON document được base64 encoded với some minor modifications. Một example của token khi transport như sau:  
```
MIIDsAYCCAokGCSqGSIb3DQEHAaCCAnoEggJ2ew0KICAgICJhY2QogICAgICAgI...EBMFwwVzELMAkGA1UEBhMCVVMxDjAMBgNVBAgTBVVuc2V0MCoIIDoTCCA50CAQExCTAHBgUrDgMQ4wDAYDVQQHEwVVbnNldDEOMAwGA1UEChM7r0iosFscpnfCuc8jGMobyfApz/dZqJnsk4lt1ahlNTpXQeVFxNK/ydKL+tzEjg
```

\- Note that even a basic token with a single endpoint in the catalog approaches a size of approximately 1,700 bytes. With larger deployments with several endpoints and services, the size of a PKI token quickly exceeds that of a default HTTP header limit for most web servers, which is 8KB. Even when compressed, the size of PKIz tokens does not decrease enough to mitigate these problems. In practice, the resultant token is approximately 10% smaller  
\- Nhược điểm của PKI và PKIz token:  
- Khó khăn trong configure Keystone để sử dụng loại token này.
- Kích thước quá lớn làm giảm hiệu suất web.
- Kích thước PKI/PKIz token lớn (thường là 8KB), gây khó khăn trong sử dụng cURL command. 
- In addition, in practice the Keystone service typically must persist these tokens in its persistence backend for purposes such as creating revocation lists. As a result the user must continue to worry about flushing the Keystone token database frequently or performance will suffer.

\- So sánh PKI – PKIz:  
<img src="http://imgur.com/uZrlaYr.png" />

<a name="3.2"></a>
## 3.2.PKI/PKIZ Configuration – Certificates
### a.Certificates
\- Signing Key (signing_key.pem) :Generate private key in PEM format  
\- Signing Certificate (signing_cert.pem) :  
- Generate CSR using Signing Key
- Submit CSR to CA
- Receive Certificate from CA

\- Certificate Authority Certificate (ca.pem)  

### b.PKI/PKIZ Configuration
Configuration in `keystone.conf` :  
```
[token]
      provider = keystone.token.providers.[pki|pkiz].Provider
[signing]
      certfile = /etc/keystone/ssl/certs/signing_cert.pem
      keyfile = /etc/keystone/ssl/private/signing_key.pem
      ca_certs = /etc/keystone/ssl/certs/ca.pem
```

<a name="3.3"></a>
## 3.3.Token Generation Workflow
<img src="http://imgur.com/rThpY54.png" />


Tiến trình tạo ra PKI token:  
- Người dùng gửi yêu cầu tạo token với các thông tin: User Name, Password, Project Name
- Keystone sẽ chứng thực các thông tin về Identity, Resource và Asssignment (định danh, tài nguyên, assignment)
- Tạo token payload định dạng JSON
- "Ký" lên JSON payload với Signing Key và Signing Certificate , sau đó được đóng gói lại dưới định dang CMS (cryptographic message syntax - cú pháp thông điệp mật mã)
- Bước tiếp theo, nếu muốn đóng gói token định dạng PKI thì convert payload sang UTF-8, convert token sang một URL định dạng an toàn. Nếu muốn token đóng gói dưới định dang PKIz, thì phải nén token sử dụng zlib, tiến hành mã hóa base64 token tạo ra URL an toàn, convert sang UTF-8 và chèn thêm tiếp đầu ngữ "PKIZ"
- Lưu thông tin token vào Backend (SQL/KVS)

<img src="http://imgur.com/HCEc9h5.png" />  

<img src="http://imgur.com/qn22q78.png" />

<a name="3.4"></a>
## 3.4.Token Validation Workflow
Tương tự như tiến trình chứng thực UUID token, chỉ khác giai đoạn đầu khi gửi yêu cầu chứng thực token tới keystone, keystone sẽ băm lại pki token với thuật toán băm đã cấu hình trước đó rồi mới kiểm tra trong backend database thu thập payload của token. Các bước chứng thực sau đó hoàn toàn tương tự như UUID token.

<img src="http://imgur.com/biHhzNq.png" />

<a name="3.5"></a>
## 3.5.Token Revocation Workflow
Hoàn toàn tương tự như tiến trình thu hồi UUID token.  

<img src="http://imgur.com/WN1tmr1.png" />

<a name="3.6"></a>
## 3.6.PKI/PKIZ – Multiple Data Centers
<img src="http://imgur.com/Hx1oL2K.png" />

Cùng kịch bản tương tự như mutiple data centers với uuid, tuy nhiên khi yêu cầu keystone cấp một pki token và sử dụng key đó để thực hiện yêu cầu tạo máy ảo thì trên cả 2 data center US-West và US-East, keystone middle cấu hình trên nova đều xác thực và ủy quyền thành công, tạo ra máy ảo theo đúng yêu cầu.  

<a name="3.7"></a>
## 3.7.Pros and Cons
<img src="http://imgur.com/lapfVw4.png" />

<a name="4"></a>
# 4.Fernet

<a name="4.1"></a>
## 4.1.Thông tin cơ bản
\- The newest Keystone token format is the Fernet token format.Fernet token cải thiện các token format trước thông qua một vài phương pháp.  
\- Đầu tiên, nó khả nhỏ, không quá 255 characters, và lớn hơn UUID tokens, nhưng nhỏ hơn PKI. Token chứa đủ information để enable token không phải lưu trữ trong persistent Keystone token database ( roles a user trên projects).  
\- Fernet tokens chứa small amount of information, như user identifer, project identifier, token expiration inforamtion, và other auditing information.  
\- Fernet sử dụng Symmetric Key Encryption.  
Sử Fernet token tương tự như workflow của UUID token, tức là trái ngược với PKI token, chúng phải validated bởi Keystone.  
\- One complicating factor is that Fernet tokens use symmetric keys to sign the token, and these keys need to be distributed to the various OpenStack regions. Additionally, these keys need to be rotated  
\- Fernet Keys stored in `/etc/keystone/fernet-keys/`    
- Encrypted with Primary Fernet Key
- Decrypted with a list of Fernet Keys

<a name="4.2"></a>
## 4.2.Fernet Configuration
Configuration in `keystone.conf` :  
```
[token]
      provider = keystone.token.providers.fernet.Provider
[fernet_tokens]
	key_repository = /etc/keystone/fernet-keys/
	max_active_keys = <number of keys> # default is 3
```

<a name="4.3"></a>
## 4.3.Fernet Keys
\- Fernet Key File - 256 bits  
<img src="http://imgur.com/sibGR2R.png" />


\- Fernet Key File Name - Integers starting from 0  
ls `/etc/keystone/fernet-keys` => 0 1 2 3 4  
\- Có 3 loại Key:  
Type 1: Primary Key  
- Encrypt and Decrypt
- Key file named with the highest index

Type 2: Secondary Key  
- Only Decrypt
- Lowest Index < Secondary Key File Name < Highest Index

Type 3: Staged Key  
- Decrypt and  Next In Line to become Primary Key
- Key file named with lowest index (of 0)

<a name="4.4"></a>
## 4.4.Fernet Key Rotation  
\- Ban đầu, Keystone chỉ có 2 key là Staged Key(0) và Primary Key(1). User thực hiện request lấy token từ Keystone, sẽ được Keystone mã hóa token đó với Primary Key(1).  

<img src="http://imgur.com/7SLOXX7.png" />

\- Sau đó một thời gian (được cấu hình), Keystone thực hiện “Rotate”. Staged Key(0) sẽ chuyển thành Primary Key(2), Primary Key(1) trở thành Secondary key(1), và Keystone sẽ sinh ra Staged Key mới (0). User thực hiện request lấy token từ Keystone, sẽ được Keystone mã hóa token đó với Primary Key mới(2).  

<img src="http://imgur.com/mkiCcYG.png" />  
<img src="http://imgur.com/haueZXA.png" />  
<img src="http://imgur.com/lFEBdHP.png" />  


\- Sau đó một thời gian (được cấu hình), Keystone thực hiện “Rotate”. Staged Key(0) sẽ chuyển thành Primary Key(3), Primary Key(2) trở thành Secondary key(2), Secondary Key(1) vẫn là Secondary Key(1) và Keystone sẽ sinh ra Staged Key mới (0). User thực hiện request lấy token từ Keystone, sẽ được Keystone mã hóa token đó với Primary Key mới(2).  

<img src="http://imgur.com/xbcBfd6.png" />  
<img src="http://imgur.com/va8WHtu.png" />  
<img src="http://imgur.com/hS8vmAL.png" />  
<img src="http://imgur.com/TOlJT5K.png" />  

\- Mặc định, số lượng max key là 3. Vì vậy Secondary Key(1) sẽ bị xóa.  
<img src="http://imgur.com/HQfvShu.png" />

<a name="4.5"></a>
## 4.5. Kế hoạch cho vấn đề rotated keys
Khi sử dụng fernet tokens yêu cầu chú ý về thời hạn của token và vòng đời của khóa. Vấn đề nảy sinh khi secondary keys bị remove khỏi key repos trong khi vẫn cần dùng key đó để giải mã một token chưa hết hạn (token này được mã hóa bởi key đã bị remove).  
Để giải quyết vấn đề này, trước hết cần lên kế hoạch xoay khóa. Ví dụ bạn muốn token hợp lệ trong vòng 24 giờ và muốn xoay khóa cứ mỗi 6 giờ. Như vậy để giữ 1 key tồn tại trong 24h cho mục đích decrypt thì cần thiết lập max_active_keys=6 trong file keytone.conf (do tính thêm 2 key đặc biệt là primary key và staged key ). Điều này giúp cho việc giữ tất cả các key cần thiết nhằm mục đích xác thực token mà vẫn giới hạn được số lượng key trong key repos `(/etc/keystone/fernet-keys/)`.  
```
token_expiration = 24
rotation_frequency = 6
max_active_keys = (token_expiration / rotation_frequency) + 2
```

<a name="4.6"></a>
## 4.6.Token Generation Workflow
<img src="http://imgur.com/SRs9LAL.png" />

<a name="4.7"></a>
## 4.7.Token Validation Workflow
<img src="http://imgur.com/m2sCX5p.png" />

\- Gửi yêu cầu xác thực token với phương thức: GET v3/auth/tokens  
\- Khôi phục lại padding, trả lại token với padding chính xác  
\- Decrypt sử dụng Fernet Keys để thu lại token payload  
\- Xác định phiên bản của token payload. (Unscoped token: 1, token trong tầm vực domain: 1, token trong tầm vực project: 2 )  
\- Tách các trường của payload để chứng thực. Ví dụ với token trong tầm vực project gồm các trường sau: user id, project id, method, expiry, audit id  
\- Kiểm tra xem token đã hết hạn chưa. Nếu thời điểm hiện tại lớn hơn so với thời điểm hết hạn thì trả về thông báo "Token not found". Nếu token chưa hết hạn thì chuyển sang bước tiếp theo  
\- Kiểm tra xem token đã bị thu hồi chưa. Nếu token đã bị thu hồi (tương ứng với 1 sự kiện thu hồi trong bảng revocation_event của database keystone) thì trả về thông báo "Token not found". Nếu chưa bị thu hồi thì trả lại token (thông điệp phản hồi thành công HTTP/1.1 200 OK )  

<a name="4.8"></a>
## 4.8.Token Revocation Workflow
<img src="http://imgur.com/xMmX1cC.png" />

Tương tự như “Token Revocation Workflow” của UUID token format và PKI/PKIz token format.

<a name="4.9></a>
## 4.9.Fernet – Multiple Data Centers
<img src="http://imgur.com/QS4OJwz.png" />

<a name="4.10"></a>
## 4.10.Proc and Cons
\- Pros  
- No persistence
- Reasonable Token Size
- Multiple Data Center

\- Cons  
- Token validation impacted by the number of revocation events
















