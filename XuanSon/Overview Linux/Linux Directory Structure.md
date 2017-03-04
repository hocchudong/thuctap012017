# Linux Directory Structure


# Mục lục
- [1.So sánh cấu trúc thư mục trong Linux và Windows](#1)
- [2.Cấu trúc thư mục Linux](#2)
  - [2.1.Cấu trúc hệ thống file](#2.1)
  - [2.2.Các thư mục thông dụng trong Linux](#2.2)
- [THAM KHẢO](#thamkhao)



<a name="1"></a>
# 1.So sánh cấu trúc thư mục trong Linux và Windows
\- Linux phân chia thành các thư mục từ thư mục gốc (/) .  
\- Windows phân chia thành các ổ đĩa logic như C: ,D: ,E: ,etc...  
<img src="" >  

<a name="2"></a>
# 2.Cấu trúc thư mục Linux

<a name="2.1"></a>
## 2.1.Cấu trúc hệ thống file
\- Một/Nhiều cây phân cấp thư mục và các file    
- File nhóm các bit .
- Một thư mục dùng để tạo nhóm các file dữ liệu và các thư mục .
\- Thư mục gốc (/) là điểm đầu tiên cho cây thư mục .  
\- Các file hoặc thư mục là các nút lá .  

<a name="2.2"></a>
## 2.2.Các thư mục thông dụng trong Linux
<img src="" >  

\- `/` (Root directory) :  
- tất cả mọi file và thư mục bắt đầu từ thư mục root .
- Chỉ root user có quyền viết trong thư mục này .
- Chú ý : /root là thư mục của root user , không giống / .

\- `/bin` - User Binaries 
- Chứa các files thực thi nhị phân .
- Linux command sử dụng bởi tất cả users của hệ thống được đặt ở đây .
- Ví dụ : ps ,ls ,ping ,grep ,cp ,...  

\- `/sbin` - System Binaries  
- Giống /bin , /sbin chứa file thực thi nhị phân .
- Nhưng , linux command nằm trong thư mục này thông thường sử dụng bởi 
system adminstrator , cho mục đích bảo trì hệ thống .
- Ví dụ : iptables , reboot , fdisk , ifocnfig ,...

\- `/etc` - Configuration Files  
- Chứa files cấu hình yêu cầu bởi tất cả các programs.
- Chứa startup và shutdown shell scripts được sử dụng để start/stop program cá nhân .
- Ví dụ : /etc/network/interfaces , /etc/resolv.conf ,...

\- `/dev` - Device Files  
- Chứa device files .
- Bao gồm terminal device , usb hoặc bất cứ device gắn với system . 
- VD : /dev/tty1 , /dev/cpu,...

\- `/proc` - Process Information  
- Chứa thông tin về process hệ thống .
- Đây là filesystem chứa thông tin về các process đang chạy .VD: thư mục /proc/{pid} chứa thông tin về process với pid .
-  Đây là virtual filesystem với text information về system resource .VD : /proc/cpuinfo , ...

\- `/var` - Variable Files  
- Thư mục dữ liệu cập nhật .Điều này có nghĩa /var chứa các files được dự kiến sẽ tăng .
- Bao gồm : system log files (/var/log) ; packages and database files (/var/lib) ; emails (/var/mail) ;print queues (/var/spool); lock files (/var/lock); temp files needed across reboots (/var/tmp) .

\- `/tmp` - Temporary Files  
- Thư mục chứa các files tạm thời tạo ra bởi system và users .
- Files trong thư mục này sẽ bị xóa sau khi rebooted system .

\- `/usr` - User Programs  
- Contains binaries, libraries, documentation, and source-code for second level programs.
- /usr/bin chứa binary files cho user programs . Nếu bạn không tìm thấy một số user binary trong /bin , bạn có thể tìm trong /usr/bin .  
Ví dụ : at,awk,cc,less,scp,..  
- /usr/sbin chứa binary files cho system administrators . Nếu bạn không tìm thấy system binary trong /sbin ,bạn có thể tìm thấy trong /usr/sbin .  
Ví dụ : atd,cron,sshd,userdel,...  
- /usr/lib chứa thư biện cho /usr/bin và /usr/sbin .
- /usr/local chứa user programs mà bạn cài đặt từ source .  
VD : Khi bạn cài apache từ source , nó sử chứa trong /usr/local/apache2 .  

\- `/home` - Home Directories  
- Thư mục Home cho tất cả user lưu trữ files cá nhận của họ .
- VD : /home/son ,/home/tam

\- `/boot` - Boot Loader Files  
- Chứa boot loader với các files liên quan .
- Kernel initrd, vmlinux, grub files đều nằm trong /boot 
- VD : initrd.img-2.6.32-24-generic, vmlinuz-2.6.32-24-generic

\- `/lib` - System Libraries  
- Chứa library files hỗ trợ binaries nằm trong /bin và /sbin
- Ví dụ : ld-2.11.1.so, libncurses.so.5.7

\- `/opt` - Optional add-on Applications  
- Chứa ứng dụng bổ sung từ vendors .
- add-on application sẽ được installed trong /opt hoặc /opt/sub-directory

\- `/mnt` - Mount Directory  
- emporary mount directory where sysadmins can mount filesystems.

\- `/media` - Removable Media Devices  
- Temporary mount directory for removable devices.
- For examples, /media/cdrom for CD-ROM; /media/floppy for floppy drives; /media/cdrecorder for CD writer

\- `/srv` - Service Data  
- srv stands for service.
- Contains server specific services related data.
- For example, /srv/cvs contains CVS related data.

<a name="thamkhao"></a>
# THAM KHẢO
http://www.thegeekstuff.com/2010/09/linux-file-system-structure/?utm_source=tuicool

