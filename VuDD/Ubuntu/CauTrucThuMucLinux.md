#Tìm hiểu cấu trúc thư mục trong Linux

Dưới đây là hình ảnh tổng quan về cấu trúc thư mục trong Linux
<img src="http://prntscr.com/eceto2">

-Root: Mỗi file và thư mục đều bắt đầu từ root directory. Chỉ có user root có quyền
trên các thư mục ở cấp bên dưới. Còn /root là home directory của user root

-/bin-User binaries: Đây là nơi chứa file thực thi dạng binary. Các lệnh thực hiện thông
dụng trong Linux được sử dụng single-user moduel được đặt dưới cấu trúc thư mục này. Các
câu lệnh được sử dụng bởi tất cả các user trong hệ thống sẽ được đặt trong đây. Ví dụ như
1 số lệnh như sau: ls, greep, ping, ps, cp,...

-/sbin-System binaries: Giống như /bin, bên trong /sbin cũng chứa đựng các file thự thi dạng
binary. Các lệnh trong /sbin thường được sử dụng bởi system administrator và dùng cho các mục
đích là duy trì quản trị hệ thống. Một số lệnh trong /sbin như: iptables, ipconfig, reboot,...

-/etc-Configuartion File: Thông thường trong /etc thường chứa các file cấu hình cho các chương
trình hoạt động. Ở /etc cũng thường chứa các script dùng để start, stop, kiểm tra status cho các
chương trình. Ví dụ như /etc/resolvolv.conf(cấu hình dns-server), /etc/network dùng để quản lý dịch
vụ network.

-/dev-Device Files: chứa các file device để đại diện cho các hardware. Ví dụ như: /dev/tty1, /dev/sda,..

-/proc-Process Information: Chứa đựng thông tin về quá trình xử lý của hệ thống. Đây là một pseudo filesystem
chứa đựng các thông tin về các process đang chạy. Đây là 1 virtual filesystem chứa đựng các thông tin tài nguyên
hệ thống. Ví dụ như: /proc/cpuinfo cung cấp cho ta thông số kỹ thuật của CPU.

-/var-Variable Files: Chứa đựng các file có sự thay đổi trong quá trình hoạt động của hệ điều hành. Ví dụ như:
system log sẽ được đặt tại vị trí này: system log file(/var/log); database log(/var/lib); email(/var/mail);
lock file(/var/lock); các file tạm thời trong quá trình reboot (/var/tmp);...

-/tmp-Temporary Files: Thư mục này chứa các file được tạo bởi hệ thống và user. Các file bên dưới thư mục này sẽ
được xoá khi hệ thống reboot.

-/usr-User Program: Chứa các file binary,library, tài liệu, source code cho các chương trình. Ví dụ như:
/usr/bin(chứa file binary cho các chương trình của user); /usr/sbin(chứa các file binary cho system administrator);
/usr/lib; /usr/local;...

-/home-Home directories: Chứa đựng các thông tin cá nhân của useruser. Ví dụ như /home/vulee, /home/student;...

-/boot-Bootloader files: Chứa đựng bootloader và các file cần cho quá trình boot tuỳ theo các phiên bản của kernel.
Các file Kernel initrd, vmlinux, grub được đặt bên dưới /boot

-/lib-System Libraries: Chứa các file libraries hỗ trợ cho các file thực binary nằm bên dưới /bin và /sbin. Tên của các
file library thường là ld* hoặc lib*.so*...

-/opt-Option add-on Application: opt đại diện cho optional, chứa đựng các chương trình thêm vào của các hãng khác.

/mnt-Mount Directory: Chứa đựng các thư mục dùng để system admin thực hiện quá trình mount.

/media-Removalbe Media Devices: Chứa thư mục dùng để mount cho các thiết bị removable. Ví dụ như CDROM, FLOPPY,...

/srv-Service Data: đại diện cho service, chứa đựng các dịch vụ cho server, nó liên quan đến dữ liệu. Ví dụ như:
/srv/cvs chứa đựng CVS,...

Trên đây là sơ lược về cấu trúc thư mục của Linux.
Thảm khảo chi tiết tại: http://www.pathname.com/fhs/
