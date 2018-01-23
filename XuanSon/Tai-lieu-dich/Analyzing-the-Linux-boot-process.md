# Phân tích quá trình boot của hệ điều hành Linux

Hiểu được hệ thông đang hoạt động như thế nào là một sự chuẩn bị tuyệt vởi để đối phó với những lỗi không thể tránh khỏi.  
Câu nói đùa từ xưa trong phần mềm mã nguồn mở "the code is self-documenting". Kinh nghiệm cho thấy đọc nguồn như việc nghe dự báo thời tiết: những người khôn ngoan vẫn ra ngoài và kiểm tra tra bầu trời. Dưới đây là một số mẹo để kiểm tra và theo dõi hệ thống Linux tại khi khởi động bằng cách tận dụng kiến thức về các công cụ gỡ lỗi quan thuộc. Phân tích quá trình khởi động của hệ thống đang hoạt động như thế nào là một sự chuẩn bị tuyệt vởi để đối phó với những lỗi không thể tránh khỏi.  
Trong một số cách, quá trình khởi động là khá đơn giản. Kernel bắt đầu đơn luồng và đồng bộ trên lõi đơn và có vẻ dễ hiểu đối với mọi người. Nhưng chính bản thần kernel khởi động như thế nào? Những chức năng nào **initial (initial ramdisk)** Và bootloader thực hiện? Và khi chờ đời, tại sao đèn LED trên port Ethernet luôn luôn sáng?  
Đọc tiếp để tìm câu trả lời cho những câu hỏi này và các câu hỏi khác; [code mô tả trình diễn và thực hiện](https://github.com/chaiken/LCA2018-Demo-Code) là có sẵn trên GitHub.  

## Sự khởi đầu của khởi động: trạng thái OFF
### Wake-on-LAN
Trạng thái OFF có nghĩa là hệ thống có điện, điều này có đúng? Điều này đơn giản là không đúng. Ví dụ, đèn LED của Ethernet được sáng bởi tính năng **wake-on-LAN(WOL)** được kích hoạt trên hệ thống của bạn. Kiểm tra điều này bằng cách gõ:  
```
 $# sudo ethtool <interface name>
```

`<interface name>` là tên giao diện card mạng, ví dụ như `eth0` (`ethtool` được tìm thấy trong các packages Linux cùng tên). Nếu "Wake-on" hiển thị trong đầu ra, điều đó cho thấy các máy từ xa có thể khở động hệ thống bằng cách gửi **MagicPacket**. Nếu bạn không ý định khởi động hệ thống từ xa và không muốn người khác làm như vậy, hẵ tắt tính nằng **WOL** trong menu BIOS hệ thống hoặc thông qua:  
```
$# sudo ethtool -s <interface name> wol d
```

Bộ xử lý trả lời đến **MagicPacket** có thể là một phần của giao diện mạng hoặc nó có thể là [Baseboard Management Controller](https://lwn.net/Articles/630778/) (BMC).  

### Intel Management Engine, Platform Controller Hub, and Minix
**BMC** không phải là microcontroller (MCU) duy nhất có thể lắng nghe khi hệ thống được yêu cầu tắt từ xa. x86_64 cũng bảo gồm bộ phần mềm **Intel Management Engine (IME)** để quản lý từ xa các hệ thống. Một loạt các thiết bị, từ máy chủ đến máy tính xách tay, điều có công nghệ này, [cho phép các chức năng](https://www.youtube.com/watch?v=iffTJ1vPCSo&index=65&list=PLbzoR-pLrL6pISWAq-1cXP4_UZAyRtesk) như **KVM Remote Control** và **Intel Capability Licensing Service**. [IME có lỗ hổng chưa được vá](https://security-center.intel.com/advisory.aspx?intelid=INTEL-SA-00086&languageid=en-fr) theo [công cụ phát hiện riêng của Intel](https://github.com/corna/me_cleaner). Điều xấu đó là rất khó để vô hiệu hóa tính năng IME. Trammell Hudson đã tạo ra [dự án me_cleaner](https://github.com/corna/me_cleaner) để lau chùi một số thành phần của IME một cách khắt khe hơn, như máy chủ web được nhúng, nhưng cũng thể tạo bức tường trên hệ thống đang chạy.  
**IME firmware** và phần mềm **System Management Mode (SMM)** theo sau tại thời điểm khởi là [dựa trên hệ điều hành Minix](https://lwn.net/Articles/738649/) và chạy trên bộ xử nền tảng **Controller Hub**, chứ không phải hệ thống main CPU. SMM sau đó sẽ khởi chạy phân mềm **Universal Extensible Firmware Interface (UEFI)**, về phần lớn [đã được viết](https://lwn.net/Articles/699551/), trên main bộ xử lý. Nhóm Coreboot tại Google đã bắt đầu một dự án phần mềm [Non-Extensible Reduced Firmware](https://trmm.net/NERF) (NERF) có tham vọng thay thế không chỉ UEFI mà còn các thành không quan người dùng Linux ban đầu như systemd. Trong khi chời đợi kết quả của những nỗ lực mới này, người dùng Linux bây giờ có thể mua máy tính xách tay từ Purism, System76 hoặc Dell với IME bị vô hiệu hóa, ngoài ra chúng ta có thể hy vọng cho máy tính xách tay với [bộ vi xử lý ARM 64-bit](https://lwn.net/Articles/733837/).  

### Bootloaders
Bên canh việc khởi động phần mềm gián điệp, chức năng khởi động firmware diễn ra như thế nào? Công việc của một quá trình bootloader là tạo sẵn cho bộ xử lý mới được hỗ trợ tài nguyên cần thiết để chạy hệ điều hành như Linux. Khi bật nguồn, không chỉ có bộ nhớ ảo mà không có DRAM cho đến khi bộ điều khiển của nó hoạt động. Bootloader sau khi bật nguồn điện sẽ quét các bus và giao diện để định vị hình ảnh kernel và hệ thống file `root`. Các bootloader phổ biến như U-Boot và GRUB hỗ trợ csac giao diện quen thuộc như USB, PCI và NFS, cũng như nhiều thiết bị nhúng đặc biệt khác như flash NOR và NAND. Bootloader cũng tương tác với các thiết bị bảo mật phần cứng như [Trusted Platform Modules](https://linuxplumbersconf.org/2017/ocw/events/LPC2017/tracks/639) (TPMs) để thiết lập một chuỗi được tin tưởng từ sớm.  

<img src="images/linuxboot_1.png" />
Chạy bootloader U-boot trong sandbox trên máy chủ lữu trữ. 

Phần mềm mã nguồn mở, bootloader [U-Boot](http://www.denx.de/wiki/DULG/Manual) được sử dụng rộng rãi và được hỗ trợ trên các hề thống từ Raspberry Pi đến thiest bị Nintendo đến automotive boards đến Chromebooks. Không có syslog, và khi mọi thứ đi ngang, thậm chí không có đầu ra console. Để tạo điều kiện gỡ lỗi, nhóm U-Boot cung cập một sandbox trong đó các bản vá có thể được kiểm tra trên máy chủ lưu trữ, hoặc ngay cả trong hệ thống Continuous Integration hàng đêm. Việc sử dụng sandbox của U-Boot tương đối đơn giản trên một hệ thống mà các công cụ phát triển như Git và GNU Compiler Collection (GCC) được cài đặt:  
```
$# git clone git://git.denx.de/u-boot; cd u-boot
$# make ARCH=sandbox defconfig
$# make; ./u-boot
=> printenv
=> help
```

Đó là: bạn đang chạy U-Boot trên x86_64 và có thể kiểm tra các tính năng như phần vùng [thiết bị lưu trữ mô phỏng](https://github.com/chaiken/LCA2018-Demo-Code), thao tác khóa bí mật dựa trên TPM và bộ cắm thêm của thiết bị USB. U-Boot Sandbox có thể được single-step theo trình tự gỡ lỗi GDB. Việc phát trển sử dụng sandbox nhanh gấp 10 lần so với kiểm tra bằng cách nạp bootloader trên board, và một sandbox "bricked" có thể được phục hồi với Ctrl+C.  

## Khởi động kernel
### Cung cấp kernel khởi động
Sau khi hoành thành niệm vụ, bootloader sẽ thực hiện nhảy tới code kernel mà nó đã nạp vào bộ nhớ chính và bắt đầu thực hiện hiện, thông qua bất kì tùy chọn dòng lệnh nào mà người dùng đã chỉ định. Loại chương trình nào kernel? file `/boot/vmlinuz` chỉ ra rằng nó là một `bzImage`, có nghĩa là một file lớn được nén. Cây nguồn Linux chứa công cụ  [extract-vmlinux tool](https://github.com/torvalds/linux/blob/master/scripts/extract-vmlinux) có thể được sử dụng để giải nén file:  
```
$# scripts/extract-vmlinux /boot/vmlinuz-$(uname -r) > vmlinux
$# file vmlinux 
vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically 
linked, stripped
```

Kernel là một chương trình nhị phân [định dạng thực thi và liên kết](http://man7.org/linux/man-pages/man5/elf.5.html) (ELF), như các chương trình không quan người dùng Linux. Điều đó có nghĩa là chúng ta có thể sử dụng câu lệnh từ package **binutils** như **readelf** để kiểm tra nó. So sánh đầu ra của, ví dụ:  
```
$# readelf -S /bin/date
$# readelf -S vmlinux
```

Danh sách các phần trong các chương trinh nhị phân là phong phú như nhau.  
Vì vậy, kernel phải bắt đầu 1 cái gì đó như chương trình nhị phân Linux ELF ... nhưng làm thế nào để các chương trình không gian người dùng sử dụng thực sự bắt đầu? Trong hàm `main()`, phải như vậy không? Không chính xác.  
Trước khi hàm main() có thể chạy, các chương trình cần không gian để thực hiện bao gồm bộ nhớ heap và stack cộng với file mô tả cho `stdio`, `stdout`, và `stderr`. Chương trình không gian người dùng lấy tài nguyên này từ thư viện chuẩn, đó là thư viện `glibc` trên hầu hết các hệ thống Linux. Xem xét những điều sau đây:  
```
$# file /bin/date 
/bin/date: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically 
linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, 
BuildID[sha1]=14e8563676febeb06d701dbee35d225c5a8e565a,
stripped
```

Các chương trình nhị phân ELF có trình thông dịch, giống như scripts Bash và Python, nhưng trình thông dịch không cần được chỉ định với `#!` như trong scripts, như ELF là dịnh dạng gốc của Linux. Trình thông dịch ELF [cung cấp một số nhị nhân](https://0xax.gitbooks.io/linux-insides/content/Misc/program_startup.html) với tài nguyên cần thiết bằng cách gọi hàm `_start()`, một hàm có sẵn trong nguồn package `glibc` có thể được [kiểm tra thông qua GDB](https://github.com/chaiken/LCA2018-Demo-Code/commit/e543d9812058f2dd65f6aed45b09dda886c5fd4e). Kernel rõ ràng không có trình thông dịch và phải cung cấp chính nó, nhưng nó làm như thế nào?  
Kiểm tra quá trình khởi động của kernel với GDB sẽ cho bạn câu trả lời. Đầu tiên, hãy cài đặt package gỡ lỗi cho kernel có chứa một phiên bản untripp của `vmlinux`, ví dụ `apt-get install linux-image-amd64-dbg`, hoặc biên dịch và cài đặt kernel của bạn từ nguồn, ví dụ, bằng cách làm theo hướng dẫn trong [Debian Kernel Handbook](http://kernel-handbook.alioth.debian.org/). `gdb vmlinux` theo sau bởi các `file info` hiển thị phần `init.text` của ELF. Danh sách bắt đầu của các chương trình thực thi trong `init.text` với `1 *(địa chỉ)` ,  nơi mà `địa chỉ` được viết dưới dạng hệ cơ số 16 của `init.text`. GDB sẽ chỉ ra rằng kernel x86_64 khởi động trong file kernel [arch/x86/kernel/head_64.S](https://github.com/torvalds/linux/blob/master/arch/x86/boot/compressed/head_64.S), nơi mà chúng ta tìm thấy các hàm assembly `start_cpu0()` và code tạp stack và giản nén zImage trước khi gọi hàm `x86_64 start_kernel()`. Kernel ARM 32-bit tương tựu như [arch/arm/kernel/head.S](https://github.com/torvalds/linux/blob/master/arch/arm/boot/compressed/head.S). `start_kernel()` không phải kiến trục cụ thể, vì vậy chức năng này tồn tại trong [init/main.c](https://github.com/torvalds/linux/blob/master/init/main.c) của kernel. `start_kernel()` được cho là hàm `main()` của Linux.  

## From start_kernel() to PID 1
### Bản kê khai phần cứng của kernel: cây thiết bị và các bảng ACPI
Tại thời điểm khởi động, kernel cần thông tin về phần cứng ngoài trừ bộ xử lý mà nó đã biên dịch. Các hướng dẫn trong code được gia tăng bởi dữ liệu cấu hình được lưu trữ riêng. Có 2 phương pháp chính để lưu trữ dữ liệu này: [cây thiết bị](https://www.youtube.com/watch?v=m_NyYEBxfn8) và [các bảng ACPI](http://events.linuxfoundation.org/sites/events/files/slides/x86-platform.pdf). Kernel học được phần cứng nào nó phải chạy ở mỗi lần khởi động bằng cách đọc file này.  
Đối với thiết bị nhúng, cây thiết bị là bản kê khai của phần cứng được cài đặt. Cây thiết bị chỉ đơn giản là một file được biên dịch cùng lúc với nguồn kernel và thường nằm trong `/boot` cùng với `vmlmix`. Để xem những gì trong cây thiết bị nhị phân trên thiết bị ARM, chỉ cần sử dụng lệnh `strings` từ package `binutils` trên file có tên tương wungs `/boot/*.dtb`, như `dtb` đề cập đến cây thiết bị nhị phân. Rõ ràng cây thiết bị có thể được sửa đổi đơn giản bằng cách chỉnh sửa file JSON và chạy lại trình biên dịch `dtc` đặc biệt được cung cấp với nguồn kernel. Mặc dụ cây thiết bị là file static mà đường dẫn file thường được dẫn tới kernel bởi bootloader trên dòng lệnh, [cơ chế overlay của cây thiết bị](http://lwn.net/Articles/616859/) đã được thêm vào trong những năm gần đây, nơi kernel có thể tự động nạp các mảnh bổ sung trong các sự kiện hotplug sau khi khởi động.  
x86-family và nhiều thiết bị ARM64 cấp doanh nghiệp sử dụng cơ chế Advanced Configuration and Power Interface ([ACPI](http://events.linuxfoundation.org/sites/events/files/slides/x86-platform.pdf)]. Trái ngược với cây thiết bị, thông tin ACPI được lưu trữ trong hệ thống file ảo `/sys/firmware/acpi/tables` được tạo bởi kernel khi khởi động bằng cách truy cập vào ROM trên máy. Cách dễ dàng để đọc bảng ACPI là lệnh `acpidump` từ package `acpica`. Đây là ví dụ:  

<img src="images/linuxboot_2.png" />  
Bảng ACPI trên laptop Lenovo được thiết lập cho Windows 2001.  

Vâng, hệ thống Linux của bạn đã sẵn sàng cho Windows 2001m bạn nên cẩn thận để cài đặt nó. ACPI có cả 2 phương pháp và dữ liệu, không giống như cây thiết bị, vồn là ngôn ngữ mô tả phần cứng. Các phương pháp của ACPI tiếp tục là hoạt động sau khi khởi động. Ví dụ, bắt đầu lệnh `acpi_listen` (từ package apcid) và mở và đóng laptop sẽ cho thấy chức năng ACPI đang chạy tại mọi thời điểm. Trong khi tạm thời và tự động [ghi đè lên bảng ACPI](https://www.mjmwired.net/kernel/Documentation/acpi/method-customizing.txt) là có thể làm được, thay đổi vĩnh viễn chúng bao gồm việc tương tác với menu BIOS khi khởi động hoặc reflashing ROM. Nếu bạn đang gặp rắc rối đó, có lẽ bạn nên [cài đặt coreboot](https://www.coreboot.org/Supported_Motherboards), phần mềm mã nguồn mở thay thế firmware.  

### From start_kernel() to userspace
Code của [init/main.c](https://github.com/torvalds/linux/blob/master/init/main.c) khá hay và dễ hiểu, bản quyền gốc của Linus Torvald từ năm 1991-1992. Các dòng tìm thấy trong `dmesg | head` trên hệ thống mới đã được khởi động bắt nguồn chủ yếu từ file nguồn này. CPU đầu tiên được đăng ký với hệ thống, các cấu trúc liệu toàn cục được khởi tạo, và trình tập tự lập trình, bộ xử lý gián đoạn (IRQs), bộ đếm thời gian và giao diện điều khiển được đặt theo thứ tự nghiêm ngặt, trực tiếp. Cho đến khi chức năng `timekeeping_init ()` chạy, tất cả các timestamps là số không. Phần khởi tạo kernel được đồng bộ, có nghĩa là sự thực hiện xảy ra trong 1 luồng, và không có chức năng nào được thực hiện cho đến khi kết thúc và trả về kết quả cuối cùng. Kết quả là đầu ra `dmesg` sẽ được tái tạo lại hoàn toàn, ngay cả giữu 2 hệ thống, miễn là chúng có cùng một cây thiết bị hoặc bảng ACPI. Linux đang hoạt động giống như một trong những hệ điều hành RTOS (real-time operating systems) chạy trên các MCU, ví dụ như QNX hoặc VxWorks. Tình huống vẫn tồn tại trong hàm `rest_init ()`, được gọi bởi `start_kernel ()` tại thời điểm chấm dứt.  

<img src="images/linuxboot_3.png" />

Tóm tắt quá trình khởi động kernel  

`Rest_init ()` tạo ra một luồn mới chạy `kernel_init ()`, nó sẽ gọi `do_initcalls ()`. Người dùng có thể theo dõi `initcalls` trong hành động bằng cách thêm `initcall_debug` vào dòng lệnh kernel, dẫn đến các mục `dmesg` mỗi khi một chức năng `initcall` chạy. `initcalls` đi qua bảy cấp độ tuần tự: **early**, **core**, **postcore**, **arch**, **subsys**, **fs**, **device**, và **late**. Phần tầm nhìn người dùng của `initcalls` là cac thiết bị ngoại vị: buses, network, storage, displays, ..., cùng với việc tải các module kernel của chúng. `rest_init ()` cũng tạo ra một luồn thứ hai trên bộ xử lý khởi động bắt đầu bằng cách chạy `cpu_idle ()` trong khi nó chờ cho trình lên lịch gán nó làm việc.  
`kernel_init()` cũng [thiết lập symmetric multiprocessing](http://free-electrons.com/pub/conferences/2014/elc/clement-smp-bring-up-on-arm-soc) (SMP). Với những kernel gần đây, tìm đến điểm này rong đầu ra của `dmesg` bằng cách tìm kiếm "các CPUs thứ cấp...". SMP được thực hiện bằng CPU "hotplugging", nghĩa là nó quản lý vòng đời của chúng bằng các máy trạng thái tương tự như các thiết bị ổ cắm hotplugged USB. Hệ thống quản lý năng lượng của kernel thuongf lấy cốt lõi riêng lẻ, sau đó đánh thức chúng khi cần thiết, do đó cùng một code CPU hotplug là được gọi lặp đi lặp lại trên một máy không bận. Quan sát viêc gọi CPU hotplug của hệ thống quản lý năng lượng bằng [công cụ BBC](http://www.brendangregg.com/ebpf.html) được gọi là `offcputime.py`.  
Chú ý rằng code trong `init / main.c` gần như đã hoàn thành khi chạy `smp_init()`: Bộ xử lý khởi động đã hoành thành việc khởi tạo một lần mà các lõi khác không cần phải lặp lại. Tuy nhiên, các luồng cho CPU phải được sinh ra cho mỗi lõi để quản lý ngắt (IRQs), workqueues , thời gian, và năng lượng. Ví dụ, xem mỗi luồng CPU mà phục vụ softirqs và workqueues đang hoạt động thông qua lệnh `ps -o psr`.  
```
$\# ps -o pid,psr,comm $(pgrep ksoftirqd)  
 PID PSR COMMAND 
   7   0 ksoftirqd/0 
  16   1 ksoftirqd/1 
  22   2 ksoftirqd/2 
  28   3 ksoftirqd/3 

$\# ps -o pid,psr,comm $(pgrep kworker)
PID  PSR COMMAND 
   4   0 kworker/0:0H 
  18   1 kworker/1:0H 
  24   2 kworker/2:0H 
  30   3 kworker/3:0H
[ . .  . ]
```

nơi trường PSR là viết tắt của 'bộ xử lý'. Mỗi lõi cũng phải lưu trữ bộ đếm thời gian riêng của nó và bộ xử lý `cpuhp` hotplug.  

Vậy cuối cùng thì đâu là không gian người dùng bắt đầu? Gần cuối của nó, `kernel_init ()` tìm kiếm một `initrd` có thể thực hiện quá trình `init` thay cho nó. Nếu nó không tìm thấy, kernel trực tiếp thực hiện `init`. Tại sao người ta có thể muốn một `initrd`?  

### Không gian người dùng sớm: người ra lệnh cho initrd?
Bên cạnh cây thiết bị, một đường dẫn file khác được cung cấp cho kernel khi khởi động là `initrd`. `initrd` thường sống trong `/boot` cùng với file bzImage vmlinuz trên x86 hoặc cùng với uImage và cây thiết bị tương tự cho ARM. Liệt kê nội dung của `initrd` bằng công cụ `lsinitramfs` là một phần của package `initramfs-tools-core`. Các distro `initrd` distro chứa các thư mục `/bin`, `/sbin`, và `/etc` tối thiểu cùng với các module kernel, cộng với một số file trong `/scripts`. Tất cả những thứ này trông khá quen thuộc, vì `initrd` phần lớn chỉ đơn giản là một hệ thống file root của Linux. Sự giống nhau rõ ràng là một chút nhầm lẫn, vì gần như tất cả các file thực thi trong `/bin` và `/sbin` bên trong ramdisk là các liên kết đến [BusyBox binary](https://www.busybox.net/), kết quả là các thư mục `/bin` và `/sbin` nhỏ hơn 10x so với `glibc's`.  
Tại sao phải tạo ra một `initrd` nếu tất cả những gì nó thực hiện là nạp một số module và sau đó bắt đầu `init` trên hệ thống tệp tin gốc thường? Cân nhắc đến một hệ thống file gốc được mã hóa. Việc giải mã có thể dựa vào việc tải một module kernel được lưu trong `/lib/modules` trên tệp tin gốc, ... và không ngạc nhiên, `initrd` làm rất tốt. Module crypto có thể được biên dịch tĩnh trong kernel thay vì tải từ một file, nhưng có nhiều lý do khiến bạn không muốn làm như vậy. Ví dụ, việc biên dịch tĩnh trong kernel với các module làm cho nó vượt quá dung lượng có sẵn, hoặc việc biên dịch tĩnh có thể vi phạm các điều khoản của giầy phép phần mềm. Cũng chả ngạc nhiên, storage, network và các driver (HID) có thể có trong `initrd` basically any code that is not part of the kernel proper that is needed to mount the root filesystem. `inird` cũng thay thế nơi mà người dùng có thể stask code bảng [ACPI tùy chỉnh](https://www.mjmwired.net/kernel/Documentation/acpi/initrd_table_override.txt).  

<img src="images/linuxboot_4.png" />  

Có một số điều thú vị với shell và tùy chỉnh `initrd`.  

`initrd` cũng tuyệt vời cho việc thử nghiệm các hệ thống file và các thiết bị lưu trữ. Giữ các công cụ test trong `initrd` và chạy test của bạn từ bộ nhớ hơn là từ các đối tượng test.  
Cuối cùng, khi `init` chạy, hệ thống bật. Vì bộ xử lý thứ cấp hiện đang chạy, machine trở thành không đồng bộ, không thể đoán trước, hiệu quả cao. Quả thực, `ps -o pid,psr,comm -p 1` có thể cho thấy tiền trình `init` của không gian người dùng không cọn chạy trên bộ xử lý boot nữa.  

## Kết luận
Quá trình khởi động của Linux nghe có vẻ khó hiểu, việc xem xét số lượng các phần mềm khác nhau tham gia các sự kiện trên một số thiết bị nhúng đơn giản. Nhìn vào những sự khác biệt, quá trình khởi động lại khá là đơn giản, vì sự phức tạp gây phức tạp do các tính năng như preemption, RCU, và các điều kiện bị thiếu trong khi khởi động. Tập trung vào kernel và PID 1 nhìn thấy một lượng lớn công việc mà bootloader và bộ xử lý phụ trợ có thể làm trong việc chuẩn bị nền tảng cho kernel chạy. Trong khi kernel là duy nhất giữa các chương trình linux, một số cái nhìn sâu vào cấu trúc có thể áp dụng một số công cụ tương tự dùng để kiểm tra các chương trình nhị phân ELF khác. Nghiên cứ về quá trình khởi động khi hệ thống làm việc để bảo trì hệ thống và chuẩn bị tốt để sửa lỗi có thể xảy ra sau này.  

# Bài gốc
https://opensource.com/article/18/1/analyzing-linux-boot-process

