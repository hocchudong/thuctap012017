# Glance


# MỤC LỤC



<a name="1"></a>
# 1.Introduction Glance
\- Glane (Image Service) là image service cung cấp khả năng discovering, registering (đăng ký), retrieving (thu thập) các image cho virtual machine. OpenStack Glance là central repository cho virtual image.  
\- Glance cung cấp RESTful API cho phép querying VM image metadata cũng như thu thập các actual image.  
\-  VM image có sẵn thông qua Glance có thể stored trong nhiều vị trí khác nhau, từ file system đến object storage system như OpenStack Swift OpenStack.  
\- Trong Glance, images được lưu trữ như template, được sử dụng để launching new instances. Glance được thiết kế để trở thành một service độc lập đối với các user cần tổ chức large virtual disk images. Glance cung cấp giải pháp end-to-end cho cloud disk image management. Nó cũng có thể lấy các bản snapshots từ running instance cho việc backing up VM và các states của VM.  

<a name="2"></a>
# 2.Glance Component
\- Glance có các components:  
- glance-api: accepts API calls for image discovery, retrieval and storage.
- glance-registry: stores, processes, and retrieves metadata information for images.
- database: stores image metadata
- storage repository: integrates with various outside OpenStack components such as regular file systems, Amazon S3 and HTTP for image storages.

<img src="../images/1.png" />

Glance accepts API requests for images from end-users or Nova components and can store its files in the object storage service,swift or other storage repository.  
\- The Image service supports these back-end stores:  
- File system  
The OpenStack Image service stores virtual machine images in the file system back end by default. This simple back end writes image files to the local file system.  
- Object Storage  
The OpenStack highly available service for storing objects.  
- Block Storage  
The OpenStack highly available service for storing blocks.  
- VMware  
ESX/ESXi or vCenter Server target system.  
- S3  
The Amazon S3 service.  
- HTTP  
OpenStack Image service can read virtual machine images that are available on the Internet using HTTP. This store is read only.  
- RADOS Block Device (RBD)  
Stores images inside of a Ceph storage cluster using Ceph’s RBD interface.  
- Sheepdog  
A distributed storage system for QEMU/KVM.  
- GridFS  
Stores images using MongoDB.  

<a name="3"></a>
# 3.Glance Architecture
<img src="../images/2.png" />

<img src="../images/3.png" />

\- Glance có client-service architecture và cung cấp Rest API để request đến server được thực hiện. Request từ client được chấp nhận thông qua Rest API và chờ Keystone authentication. Glance Domain controller manages all the internal operations, which is divided in to layers, each layer implements its own tasks.  
Glance store là communication layer giữa glance và external storage backends hoặc local file system và cung cấp uniform interface để access. Glance sử dụng SQL central Database làm điểm access cho every components khác trong system.  
\- The Glance architecture consists of several components:  
- **Client** : any application that uses Glance server.
- **REST API** : exposes Glance functionality via REST.
- **Database Abstraction Layer (DAL)** : an application programming interface which unifies the communication between Glance and databases.
- **Glance Domain Controller** : middleware that implements the main Glance functionalities: authorization, notifications, policies, database connections.
- **Glance Store** : organizes interactions between Glance and various data stores.
- **Registry Layer** : optional layer organizing secure communication between the domain and the DAL by using a separate service.

<a name="4"></a>
# 4.Glance Formats
\- Khi chúng ta upload image cho glance, chúng ta cần chỉ định format của Virtual machine images. Glance hỗ trợ nhiều format khác nhau như **Disk Formats** và **Container Formats**.  
\- Virtual disk là tương tự physical server’s boot driver.  
\- Các loại virtualization khác nhau hỗ trợ disk formats khác nhau.  

## 4.1.Disk Formats
The Disk Formats of a virtual machine image is the format of the underlying disk image. Following are the disk formats supported by OpenStack glance.  

<img src="../images/4.png" />

## 4.2.Container Formats
As said OpenStack glance also support the concept of container format, which describes the file formats and contains additional metadata about the actual virtual machine.  
Following are the container formats which supported in OpenStack glance.  

<img src="../images/5.png" />

Note that Container Formats are not currently used by Glance or other OpenStack components. So ‘bare’ is given as container format while we upload an image in glance, bare mean without container.  

<a name="5"></a>
# 5.Glance Status Flow
\- Glance status flow show the status of image khi uploading. Khi chúng ta create image, first step là queuing, image được queued trong một thời gian ngắn, được bảo vệ và sẵn sàng upload. Sau khi queuing image đi đến status Saving, nghĩa là not fully uploaded. Image là full uploaded khi status là Active. Khi uploading fails, nó sẽ chuyển sang killed hoặc deleted state. Chúng ta có thể deactivate và reactivate các fully uploaded images bằng cách sử dụng command.  
\- Diagram bên dưới show status flow của glance:  

<img src="../images/6.png" />

\- Các status của image:  
- queued  
Image identifier được bảo vệ trong Glance registry. Không có image data được uploaded to Glance và image size không rõ ràng sẽ được set to zero khi khởi tạo.  
- saving  
Denotes that an image’s raw data is currently being uploaded to Glance. When an image is registered with a call to POST /images and there is an x-image-meta-location header present, that image will never be in the saving status (as the image data is already available in some other location).  
- active  
Denotes an image that is fully available in Glance. This occurs when the image data is uploaded, or the image size is explicitly set to zero on creation.  
- deactivated  
Denotes that access to image data is not allowed to any non-admin user. Prohibiting downloads of an image also prohibits operations like image export and image cloning that may require image data.  
- killed  
Denotes that an error occurred during the uploading of an image’s data, and that the image is not readable.  
- deleted  
Glance has retained the information about the image, but it is no longer available to use. An image in this state will be removed automatically at a later date.  
- pending_delete  
This is similar to deleted, however, Glance has not yet removed the image data. An image in this state is not recoverable.  

>Note: Deactivating and Reactivating an image  
The cloud operators are able to deactivate (temporary) an image. Later operators can reactivate it or just remove it if they believe the image is a threat for the cloud environment.While performing the update of an image the operator might want to hide it from all the users. Then when the update is complete he can reactivate the image so the users can boot virtual machines from it.  

\- Task Statuses  
- pending  
The task identifier has been reserved for a task in the Glance. No processing has begun on it yet.  
- processing  
The task has been picked up by the underlying executor and is being run using the backend Glance execution logic for that task type.  
- success  
Denotes that the task has had a successful run within Glance. The result field of the task shows more details about the outcome.  
- failure  
Denotes that an error occurred during the execution of the task and it cannot continue processing. The message field of the task shows what the error was.  

<a name="6"></a>
# 6.Glance Configuration Files
Các file cấu hình glance nằm trong thư mục `/etc/glance`. Sau đây là các file quan trọng:  
- `Glance-api.conf` : Configuration file for image service API.
- `Glance-registry.conf` : Configuration file for glance image registry which stores metadata about images.
- `glance-api-paste.ini`: Cấu hình cho các API middleware pipeline của Image service
- `glance-manage.conf`: Là tệp cấu hình ghi chép tùy chỉnh. Các tùy chọn thiết lập trong tệp `glance-manage.conf` sẽ ghi đè lên các section cùng tên thiết lập trong các tệp glance-registry.conf và glance-api.conf. Tương tự như vậy, các tùy chọn thiết lập trong tệp glance-api.conf sẽ ghi đè lên các tùy chọn thiết lập trong tệp `glance-registry.conf`
- `glance-registry-paste.ini`: Tệp cấu hình middle pipeline cho các registry của Image service.
- `glance-scrubber.conf` : Utility used to clean up images that have been deleted. Multiple glance-scrubber can be run in a single deployment, but only once can act as clean-up scrubber in the scrubber.conf file. The clean-up scrubber coordinates other glance scrubbers by maintaining a master queue of images that need to be removed.The glance-scrubber.conf file also specifies important configuration items such as the time between runs, length of time images can be pending before their deletion as well as registry connectivity options. Glance-scrubber can run as a periodic job or long-running daemon.
- `policy.json` : Additional Access control that apply to image service. In this we can define roles and policies, it is the security feature in the OpenStack glance.

<a name="7"></a>
# 7.Image and Instance
\- Như đã nói ở trên, Disk images are stored as template. Image service controls storage and management of images. Instance là virtual machine riêng biệt chạy trên compute node, compute node quản lý instance. User có thể launch any number of instance từ same image. Mỗi lanched instance được thực hiện bởi việc copy image, bất kỳ thay đổi nào trên instance sẽ không ảnh hưởng đến image. Chúng ta có thể snapshot running instance và có thể được sử dụng để launching another instance.  
\- Khi chúng ta launch an instance, chúng ta cần chỉ định flavor, which represents virtual resource. Flavors define số lượng virtual CPUs, dung lượng RAM cho virtual machine, and the size of its ephemeral disks. Openstack cung cấp một bộ các flavors được định nghĩa trước, chúng ta có thể create và editor flavors theo ý mình.  
\- diagram show bên dưới chỉ ra system state trước khi launching an instance. Image store chỉ ra số lượng images đã được định nghĩa trước, compute node chứa vcpu sẵn có, memory và local disk resource và cinder-volume chứa số lượng volumes được định nghĩa trước.  

<img src="../images/7.png" />

\- Trước khi launching instance, ta chọn image, flavor và bất kỳ optional  attributes. Selected flavor provides a root volume, labelled as vda and an additional ephemeral storage is labelled as vdb and cinder-volume is mapped to third virtual-disk and call it as vdc.

<img src="../images/8.png" />

\- In this figure the base image is copied to the local disk from the image store. vda is the first disk that the instances accesses, instances starts faster if the size of image is smaller as less data needs to be copied across the network. vdb is an empty ephemeral disk created along with the instance, it will be deleted when instance terminates.  
\- vdc connects to the cinder-volume using iSCSI.After the compute node provisions the vCPU and memory resources, the instance boots up from root volume vda.The instance runs and changes data on the disks. If the volume store is located on a separate network, the my_block_storage_ip option specified in the storage node configuration file directs image traffic to the compute node.  
\- When the instance is deleted, the state is reclaimed with the exception of the persistent volume. The ephemeral storage is purged; memory and vCPU resources are released. The image remains unchanged throughout this process.  


<a name="8"></a>
# 8.Image Signing and Verification
<a name="8.1"></a>
# 8.1.Glance Image Signing and Verification
Tham khảo tại: https://specs.openstack.org/openstack/glance-specs/specs/mitaka/approved/image-signing-and-verification-support.html  

<a name="8.2"></a>
# 8.2.Nova Signature Verification
Tham khảo tại: https://specs.openstack.org/openstack/nova-specs/specs/mitaka/implemented/image-verification.html#proposed-change  

<a name="8.3"></a>
# 8.3.Glance Image Signature Verification
<img src="../images/9.png" />

\- Hình trên là quá trình “Glance Image Signature Verification” trong 2 use case : Quá trình User upload image (bước 1-10) và Nova request image từ Glance (bước 11-17)  
\- **Bước 1** : User muốn upload Image, user create Image  
\- **Bước 2** :  Create Asymmetric Key-Pair  
\- **Bước 3** : Create Certificate ( Public Key Certificate )  
\- **Bước 4** : Sign Image với Private Key  
- Trong version OpenStack Liberty, sử dụng thuật toán hash MD5 để tạo checksum1 của Image data, sau đó sử dụng thuật toán hash SHA-256 để tạo checksum2. Tiếp theo, sử dụng RSA-PSS với private key để encrypt checksum2 và được signature.  
signature = RSA-PSS(SHA-256(MD5(IMAGE-CONTENT)))  
- Trong version OpenStack Mitaka, sử dụng thuật toán SHA-256 để tạo checksum của Image data, sau đó sử dụng RSA-PSS với private key để encrypt checksum và được signature.  
signature = RSA-PSS(SHA-256(IMAGE-CONTENT))  
\- **Bước 5** : Gửi “Public Key Certificate” lên Key-Manager ( thường là Keystone ) sử dụng giao diện Castellan, để **Key-Manager** stored và thu về **signature_certificate_uuid** sử dụng cho quá trình request **Public Key certificate**.  
\- **Bước 6** : Upload Image Data với Signature Properties lên Glance. Signature Properties bao gồm :  
- **signature** 
- **signature_key_type**: là loại key được sử dụng để tạo signature. Ví dụ: RSA-PSS
- **signature_hash_method**: là hash method được sử dụng để tạo signature. Ví dụ: SHA-256
- **signature_certificate_uuid**: chính là **signature_certificate_uuid** thu được ở bước 5 khi tiến hành lưu trữ certificate.
- **mask_gen_algorithm**: giá trị này chỉ ra thuật toán tạo mặt nạ được sử dụng trong quá trình tạo ra chữ ký số. Ví dụ: MGF1. Giá trị này chỉ sử dụng cho mô hình RSA-PSS.
- **pss_salt_length**: định nghĩa sal length sử dụng trong quá trình tạo signature và chỉ áp dụng cho mô hình RSA-PSS. Giá trị mặc định là PSS.MAX_LENGTH.
\- **Bước 7** : Glance request “Public key certificate” từ Key-manager. Để làm điều này Glance phải sử dụng signature_certificate_uuid thu được trong quá trình tải image lên của người dùng.
\- **Bước 8** : Key-manager return “Public key certificate” cho Glance.
\- **Bước 9** : Verify Image Signature, sử dụng public key thu được cùng với các signature metadata khi image được upload lên. Việc xác thực này được thực hiện bởi module **signature_utils**.
\- **ước 10** : Glance store Image vào repository. Nếu verify fail, Glance sẽ đưa image đó vào killed state và gửi thông báo lại cho user kèm theo lý do tại sao image upload bị errir.
\- **Bước 11** : Nova muốn create instance, Nova request Image và metadata.
\- **Bước 12** : Glance return image và metadata. Metadata bao gồm:
- **img_signature** - A string representation of the base 64 encoding of the signature of the image data.
- **img_signature_hash_method** - A string designating the hash method used for signing. Currently, the supported values are SHA-224, SHA-256, SHA-384 and SHA-512. MD5 and other cryptographically weak hash methods will not be supported for this field. Any image signed with an unsupported hash algorithm will not pass validation.
- **img_signature_key_type** - A string designating the signature scheme used to generate the signature.
- **img_signature_certificate_uuid** - A string encoding the certificate uuid used to retrieve the certificate from the key manager.
\- **Bước 13** : Nova yêu cầu **Public Key Certificate** từ Key Manager bằng việc sử dụng **signature_certificate_uuid** tương tác với giao diện Castellan
\- **Bước 14** : Key Manager return **Public Key Certificate** cho Nova.
\- **Bước 15** : Nova verify Image Signature với metadata. Chức năng này được thực hiện bởi module signature_utils của Nova.
\- **Bước 16** : Verify Image Signature.Để làm điều này, ta phải cấu hình trong file `nova.conf` của nova, thiết lập giá trị **verify_glance_signatures = true**. Như vậy, Nova sẽ sử dụng các properties của image, bao gồm các properties cần thiết cho quá trình verity image signature(signature metadata). Nova sẽ đưa date của image và các properties của nó tới module **signature_utils** để verity image signature.
\- **Bước 17** : Nếu quá trình verity image signature là thành công thì Nova sử dụng image để boot virtual machine và ghi vào log chỉ ra rằng quá trình verity image signature thành công kèm theo các information liên quan. Ngược lại nếu verity image signature thất bại, Nova sẽ không boot image đó và lưu lại error vào log.














