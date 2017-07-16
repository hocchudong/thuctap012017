# Nova - Nova, Libvirt và KVM

# Mục lục
- [3.Nova, Libvirt và KVM](#3)
  - [3.1. Các khái niệm căn bản](#3.1)
    - [3.1.1.KVM - QEMU](#3.1.1)
    - [3.1.2.Libvirt](#3.1.2)
  - [3.2. Tích hợp Nova với Libvirt, KVM quản lý máy ảo](#3.2)
    - [3.2.1. Workflow của Nova Compute](#3.2.1)
    - [3.2.2. Spawn](#3.2.2)
    - [3.2.3. Reboot](#3.2.3)
    - [3.2.4.Suspend](#3.2.4)
    - [3.2.5.Live Migration](#3.2.5)
    - [3.2.6.Resize/Migrate](#3.2.6)
    - [3.2.7.Snapshots](#3.2.7)



<a name="3"></a>
# 3.Nova, Libvirt và KVM
<a name="3.1"></a>
## 3.1. Các khái niệm căn bản
<a name="3.1.1"></a>
### 3.1.1.KVM - QEMU
\- KVM - module của hạt nhân linux đóng vai trò tăng tốc phần cứng khi sử dụng kết hợp với hypervisor QEMU, cung cấp giải pháp ảo hóa full virtualization.  
\- Sử dụng libvirt làm giao diện trung gian tương tác giữa QEMU và KVM  
<a name="3.1.2"></a>
### 3.1.2.Libvirt
\- Thực thi tất cả các thao tác quản trị và tương tác với QEMU bằng việc cung cấp các API.  
\- Các máy ảo được định nghĩa trong Libvirt thông qua một file XML, tham chiếu tới khái niệm "domain".  
\- Libvirt chuyển XML thành các tùy chọn của các dòng lệnh nhằm mục đích gọi QEMU  
\- Tương thích khi sử dụng với virsh (một công cụ quản quản lý tài nguyên ảo hóa giao diện dòng lệnh)  
<a name="3.2"></a>
## 3.2. Tích hợp Nova với Libvirt, KVM quản lý máy ảo
<a name="3.2.1"></a>
### 3.2.1. Workflow của Nova Compute
\- Compute Manager  
Cấu hình trong hai file: `nova/compute/api.py` và `nova/compute/manager.py`  
Các compute API tiếp nhận yêu cầu từ người dùng từ đó gọi tới compute manager. Compute manager lại gọi tới Nova libvirt driver. Driver này sẽ gọi tới API của libvirt thực hiện các thao tác quản trị.  
\- Nova Libvirt Driver  
Được cấu hình trong các file `nova/virt/libvirt/driver.py` và `nova/virt/libvirt/*.py` có vai trò tương tác với libvirt.  
<a name="3.2.2"></a>
### 3.2.2. Spawn
\- Đây là thao tác boot máy ảo, nova tiếp nhận lời gọi API từ người dùng mang đi xử lý qua các module **API -> Scheduler -> Compute (manager) -> Libvirt Driver**. Libvirt sẽ thực hiện tất cả các thao tác cần thiết để tạo máy ảo như cấp phát tài nguyên mạng, tài nguyên tính toán(ram, cpu), volume, etc.  
\- Tiếp đó, tiến trình spawn này cũng tạo ra file đĩa bằng các thao tác sau:  
- Tải image từ glance đưa vào thư mục tương ứng chứa ảnh đĩa gốc bên máy compute được lựa chọn (instance_dir/_base) và chuyển nó sang định dạng RAW.
- Tạo instance_dir/uuid/{disk, disk.local, disk.swap}
  - Tạo file đĩa định dạng QCOW2 từ đĩa gốc ở trên. (instance_dir/uuid/disk)
  - Tạo 2 file đĩa định dạng QCOW2 là "disk.local" và "disk.swap". (instance_dir/uuid/disk.local và instance_dir/uuid/disk.swap, không nên sử dụng swap trong máy ảo)
- Tạo ra file libvirt XML và tạo bản copy vào thư mục instance_dir (instance_dir/libvirt.xml)
- Thiết lập kết nối với volume(nếu boot từ volume). Thao tác vận hành này được thực thi như thế nào là phụ thuộc vào volume driver.
  - iSCSI: kết nối thiets lập thông qua tgt hoặc iscsiadm.
  - RBD: tạo ra XML cho Libvirt, thực thi bên trong QEMU.
- Xây dựng hệ thống network hỗ trợ cho máy ảo:
  - Phụ thuộc vào driver sử dụng (nova-network hay neutron)
  - Thiết lập các bridges và VLANs cần thiết
  - Tạo Security groups (iptables) cho máy ảo
- Định nghĩa domain với libvirt, sử dụng file XML đã tạo. Thao tác này tương đương thao tác 'virsh define instance_dir//libvirt.xml' khi sử dụng virsh.  
- Bật máy ảo. Thao tác này tương đương thao tác 'virsh start ’ or ‘virsh start ' khi sử dụng virsh.

<a name="3.2.3"></a>
### 3.2.3. Reboot
\- Có 2 loại reboot có thể thực hiện thông qua API: hard reboot và soft reboot. Soft reboot thực hiện hoàn toàn dựa vào guest OS và ACPI thông qua QEMU. Hard reboot thực hiện ở mức hypervisor và Nova cũng như các cấp độ phù hợp khác.  
\- Hard reboot workflow:  
- Hủy domain. Tương đương với lệnh "virsh destroy", không hủy bỏ dữ liệu, mà kill tiến trình QEMU.
- Tái thiết lập tất cả cũng như bất kỳ kết nối nào tới volume.
- Tái tạo Libvirt XML
- Kiểm tra và tải lại bất kỳ file nào bị lỗi ((instance_dir/_base)
- "Cắm" lại các card mạng ảo (tái tạo lại các bridges, VLAN interfaces)
- Tái tạo và áp dụng lại các iptables rules

<a name="3.2.4"></a>
### 3.2.4.Suspend
\- Thực hiện với câu lệnh “nova suspend”.  
\- Tương tự như câu lệnh “virsh managed-save”.  
\- Thao tác này dễ gây hiểu lầm, vì nó khá giống hành động hibernate hệ thống.  
\- Một số vấn đề với trạng thái này:  
- Lưu trữ trạng thái bộ nhớ trên không gian disk tiêu thụ bằng bộ nhớ của máy ảo.
- Không gian disk không bị giới hạn ở bất cứ đâu.
- Cả hai giải pháp migration và live migration đều có những vấn đề đối với trạng thái này.
- Cài đặt QEMU phiên bản khác nhau có thể có sự thay đổi giữa suspend và resume.

<a name="3.2.5"></a>
### 3.2.5.Live Migration
\- Thực hiện bởi câu lệnh "nova live-migration [--block-migrate]"  
\- Có 2 loại live migration: normal migration và “block” migrations.  
\- Normal live migration yêu cầu cả hai source và target hypervisor phải truy cập đến data của instance ( trên hệ thống lưu trữ có chia sẻ, ví dụ: NAS, SAN)  
\- Block migration không yêu cầu đặc biệt gì đối với hệ thống storage. Instance disk được migrated như một phần của tiến trình.  
\- Live migrations là một trong những thao tác vận hành mang tính nhạy cảm nhất liên quan đến phiên bản của QEMU đang chạy trên máy chủ nguồn và đích.  
\- Live Migration Workflow:  
- Kiểm tra storage backend là thích hợp với loại migration hay không:
  - Thực hiện kiểm ta hệ thống shared storage cho normal migrations
  - Thực hiện kiểm tra các yêu cầu cho block migrations
  - Kiểm tra trên cả source và destination, điều phối thông qua RPC calls từ scheduler.
- Trên destination
  - Tạo các kết nối volume cần thiết.
  - Nếu là block migration, tạo thư mục instance, lưu lại các file bị mất từ Glance và tạo instance disk trống.
- Trên source, khởi tạo tiến trình migration.
- Khi tiến trình hoàn tất, tái sinh file Libvirt XML và define nó trên destination.

<a name="3"></a>
### 3.2.6.Resize/Migrate
\- Resize/Migrate được nhóm lại với nhau bởi chúng sử dụng chung code.  
\- Migrate khác live migrate ở chỗ nó thực hiện migration khi tắt máy ảo ( Libvirt domain không chạy)  
\- Yêu cầu SSH key pairs được triển khai cho user đang chạy nova-compute với mọi hypervisors.  
\- Cấu hình cho phép resize: “allow_resize_same_host = True”  
\- Resize không cho phép chia disk, vì nó có có thể không an toàn.  
\- Resize/Migrate workflow:  
- Tắt máy ảo ( tương tự “virsh destroy” ) và disconnect các volume.
- Di chuyển thư mục hiện hành của máy ảo ra ngoài (  (instance_dir -> instance_dir_resize). Tiến trình resize instance sẽ tạo ra thư mục tạm thời.
- Nếu sử dụng QCOW2, convert image sang dạng RAW.
- Với hệ thống shared storage, di chuyển thư mục instance_dir mới vào. Nếu không, copy thông qua SCP.

<a name="3"></a>
### 3.2.7.Snapshots
\- 2 kiểu snapshot hoàn toàn khác nhau: "live" snapshot và "cold" snapshot.  
\- Hệ thống file hoặc dữ liệu bền vững có thể không được đảm bảo với mỗi kiểu snapshot khác nhau.  
\- Live snapshot không có yêu cầu đặc biệt gì về cấu hình, Nova sẽ thực hiện tự động (được giới thiệu trong bản Grizzly, yêu cầu Libvirt 1.0.0 và QEMU 1.3).  Live snapshot workflow như sau:  
- Thực hiện kiểm tra xác định liệu hypervisor có đảm bảo yêu cầu cho live snapshot không.
- Máy ảo cần ở trạng thái "running", trái lại ta thực hiện clod snapshots.
- Tạo image QCOW2 rỗng trong thư mục tạm
- Sử dụng libvirt thiết lập bản sao chép từ đĩa của máy ảo hiện tại sang đĩa rỗng đã tạo ở trên.
- Thăm dò trạng thái của block cho tới khi không còn bytes dữ liệu nào để snapshots, khi đó ta có một bản sao của máy ảo đang chạy.
- Sử dụng qemu-img, convert bản copy sang định raw image.
- Tải image lên Glance

\- Cold snapshot yêu cầu phải tắt máy ảo với workflow như sau:  
- Tắt hoàn toàn máy ảo
- Khi đã tắt máy ảo, sử dụng qemu-img để convert, tạo ra bản copy của đĩa với cùng định dạng với image gốc tạo máy ảo từ Glance.
- Trả lại trạng thái nguyên thủy của máy ảo.
- Tải bản sao chép của image đã convert lên Glance





