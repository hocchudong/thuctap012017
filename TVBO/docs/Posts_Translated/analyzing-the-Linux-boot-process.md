# Phân tích quá trình khởi động Linux

____

# Mục lục

Mục đích chính của bài viết là hiểu được các hoạt động cần khi khởi động Linux để có những chuẩn bị đối phó với những lỗi phát sinh không tránh được.

- [2.1 Khởi động boot - trạng thái OFF](#1)
- [2.2 Intel Management Engine, Platform Controller Hub, and Minix](#2)
- [2.3 Bootloaders](#3)
- [2.4 Khởi động kernel](#4)
- [2.5 Từ start_kernel () đến PID 1](#5)
- [2.6 Không gian người dùng đầu tiên: người ra lệnh cho initrd?](#6)
- [2.7 Tổng quan](#7)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- Một trong những lời nói đùa xưa nhất về phần mềm mã nguồn mở đó là `code chính là tự ghi chép`. Kinh nghiệm cho thấy rằng việc đọc các mã nguồn giống như việc theo dõi thời tiết: Những người nhạy cảm vẫn ra ngoài và kiểm tra bầu trời. Dưới đây sẽ là những mẹo để kiểm tra và quan sát các hệ thống Lĩnh khi khởi động bằng cách tận dụng kiến thức về các công cụ gỡ lỗi quen thuộc. 

- Việc phân tích quá trình khởi động của các hệ thống đang hoạt động nhắm mục đích giúp cho người dùng và các nhà phát triển có thể đối phó với những lỗi phát sinh không thể tránh được.

- Trong một vài quá trình, việc khởi động có thể xem là vô cùng đơn giản. Kernel bắt đầu đọc từng luồng (thread) và đồng bộ trên một lõi đơn (single core) và có vẻ như khá là dễ hiểu. Nhưng chính bản thân kernel lại khởi động như thế nào? Những hàm nào thực hiện `initrd` (khởi tạo ramdisk) và `bootloaders`? Và sau đó thì đèn LED trên cổng Ethernet luôn bật?
- ### <a name="1">2.1 Khởi động boot - trạng thái OFF</a>

    > #### Wake-on-LAN

    - Trạng thái OFF có nghĩa là hệ thống không có nguồn điện cung cấp. Ví dụ, đèn LED Ethernet có thể sáng được là nhờ tính năng wake-on-LAN (WOL) đang được cung cấp trong hệ thống của bạn. Để kiểm tra trường hợp này, ta có thể sử dụng câu lệnh:

            sudo ethtool <interface name>

        trong đó <interface name> là tên của interface mạng, có thể là eth0, ens33, ...
        nếu "Wake-on" trong output có giá trị `g` thì các máy từ xa có thể khởi động hệ thống bằng cách gửi một `[Magic Packet](https://en.wikipedia.org/wiki/Wake-on-LAN)`. Ngược lại, nếu không có ý định khởi động hệ thống từ xa và không muốn người khác thực hiện điều này thì hãy tắt chức năng `Wake-on-LAN` trong menu cài đặt BIOS hoặc thông qua câu lệnh:

            sudo ethtool -s <interface name> wol d

        Bộ xử lý đáp ứng `Magic Packet` có thể là một phần của interface network hoặc nó cũng có thể là `[Baseboard Management Controller (BMC)](https://lwn.net/Articles/630778/)`.

- ### <a name="2">2.2 Intel Management Engine, Platform Controller Hub, and Minix</a>

    - BMC không phải là một vi điều khiển duy nhất (MCU) có thể lắng nghe khi hệ thống đang trong trạng thái tắt.

    - Các hệ thống x86_64 cũng bao gồm cả các phần mềm Intel Management Engine (IME) để quản lý các hệ thống từ xa. Một loạt các thiết bị, từ máy chủ đến máy tính xách tay, đều bao gồm công nghệ này, công nghệ cho phép sử dụng các chức năng như KVM Remote Control và Intel Capability Licensing Service. Được biết IME có lỗ hổng chưa được vá, theo công cụ phát hiện riêng của Intel. Tin xấu là, rất khó để vô hiệu hóa IME. Trammell Hudson đã tạo ra một dự án có tên là `me_cleaner` loại bỏ một số thành phần IME thông minh hơn, như máy chủ web nhúng, nhưng cũng có thể loại bỏ hệ thống mà nó chạy.

    - IME Firmware và phần mềm System Management Mode (SMM) sẽ theo sau nó khi khởi động dựa trên hệ điều hành Minix và chạy trên bộ xử lý Platform Controller Hub riên biệt thay vì CPU của hệ thống. Sau đó, SMM sẽ khởi chạy phần mềm Universal Extensible Firmware Interface (UEFI) - những gì đã được ghi trong bộ xử lý chính. Nhóm Coreboot tại Google đã bắt đầu một dự án phần mềm NERF ([Non-Extensible Reduced Firmware](https://trmm.net/NERF)) hướng tới việc thay thế không chỉ UEFI mà có cả các thành phần của người dùng Linux ban đầu như systemd. Trong khi chờ đợi kết quả của những nỗ lực mới này, người dùng Linux bây giờ có thể mua máy tính xách tay từ Purism, System76 hoặc Dell với IME bị vô hiệu hóa , cộng thêm chúng ta có thể hy vọng cho máy tính xách tay với bộ xử lý ARM 64-bit.

- ### <a name="3">2.3 Bootloaders</a>

    - Bên canh việc khởi động các phần mềm gián điệp lỗi, chức năng nào thực hiện boot firmware được cung cấp? Công việc của bootloaders là tạo sẵn cho một bộ xử lý mới được hỗ trợ tài nguyên cần thiết để chạy một hệ điều hành mục đích chung như Linux.  Khi bật nguồn, bootloaders khởi động sau đó bật nguồn điện và quét các buses và interfaces theo thư tự để tìm kiếm kernel image và root filesystem. Bootloaders phổ biến như U-Boot và GRUB hỗ trợ các giao diện quen thuộc như USB, PCI, và NFS, cũng như nhiều thiết bị nhúng khác như NOR và NAND-flash. Bootloaders cũng tương tác với các thiết bị bảo mật phần cứng như Trusted Platform Modules (TPM) để thiết lập một chuỗi tin tưởng (chain of trust) từ boot mới nhất.

        ![https://opensource.com/sites/default/files/u128651/linuxboot_1.png](https://opensource.com/sites/default/files/u128651/linuxboot_1.png)

        > Chạy bộ tải khởi động U-boot trong sandbox trên máy chủ lưu trữ.

    -  Mã nguồn mở, bootloader [U-Boot](http://www.denx.de/wiki/DULG/Manual) được sử dụng rộng rãi, được hỗ trợ trên các hệ thống từ Raspberry Pi đến thiết bị Nintendo cho tới Chromebook. Không có syslog, khi mọi thứ đi ngang qua, thậm chí không có bất kỳ đầu ra console. Để tạo điều kiện gỡ lỗi (debugging), nhóm U-Boot cung cấp một sandbox, trong đó các bản vá có thể được kiểm tra trên máy chủ lưu trữ hoặc ngay cả trong một hệ thống tích hợp liên tục.

    - Việc sử dụng với sandbox của U-Boot tương đối đơn giản trên một hệ thống mà các công cụ phát triển phổ biến như Git và GNU Compiler Collection (GCC) đã được cài đặt:

    ```sh
    $# git clone git://git.denx.de/u-boot; cd u-boot
    $# make ARCH=sandbox defconfig
    $# make; ./u-boot
    => printenv
    => help
    ```

    - Sau khi sử dụng các câu lệnh trên, vậy là bạn đang chạy U-Boot trên x86_64 và có thể thử nghiệm các tính năng như phân vùng lại `[thiết bị lưu trữ mô phỏng](https://github.com/chaiken/LCA2018-Demo-Code)`, thao tác khóa bí mật dựa trên TPM và hotplug của thiết bị USB.


- ### <a name="4">2.4 Khởi động kernel</a>

    - #### Cung cấp kernel để khởi động
        Sau khi hoàn thành nhiệm vụ của nó, bootloaders sẽ thực hiện nhảy tới kernel code mà nó đã nạp vào bộ nhớ chính và bắt đầu thực thi thông qua bất kỳ tùy chọn dòng lệnh nào mà người dùng đã chỉ định. Vậy loại chương trình nào thì được xem là kernel? File `/boot/vmlinuz` chỉ ra rằng nó là một `bzimage` (big zip image - một tệp nén lớn). Root filesystem Linux có chứa một công cụ [extract-vmlinux]https://github.com/torvalds/linux/blob/master/scripts/extract-vmlinux) có thể được sử dụng để giải nén tệp trên:

        ```sh
        $# scripts/extract-vmlinux /boot/vmlinuz-$(uname -r) > vmlinux
        $# file vmlinux 
        vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically 
        linked, stripped
        ```

    - Kernel là một chương trình binary (nhị phân) thực thi và liên kết [Executable and Linking Format - ELF](http://man7.org/linux/man-pages/man5/elf.5.html) như các chương trình người dùng Linux. Điều này có nghĩa là chúng ta có thể sử dụng lệnh từ gói `binutils` giống như `readelf` để kiểm tra nó. Hãy so sánh đầu ra của ví dụ sau:

            $# readelf -S /bin/date
            $# readelf -S vmlinux

        Danh sách các phần trong các chương trình nhúng cũng tương tự nhau.

    - Vì vậy, kernel phải bắt đầu từ một cái gì đó giống như các chương trình nhị phân Linux ELF khác. Nhưng làm thế nào mà các chương trình người dùng thực sự được khởi động? Có phải là trong hàm `main()`? Điều này là hoàn toàn không chính xác.

    - Trước khi hàm `main()` có thể chạy chương trình cần một bối cảnh thực hiện bao gồm cả `heap` và `stack` memory cộng với tệp tin mô tả cho `stdin`, `stdout` và `stderr`. Các chương trình người dùng lấy các tài nguyên này từ thư viện chuẩn nằm cở `glibc` trên hầu hết các hệ thống Linux. Hãy cùng xem xét những điều sau đây:

            $# file /bin/date 
            /bin/date: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically 
            linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, 
            BuildID[sha1]=14e8563676febeb06d701dbee35d225c5a8e565a,
            stripped            

    - ELF binaries có một trình thông dịch giống như các tập lệnh BASH hay Python. nhưng thông dịch không cần phải được chỉ định với `#!` như trong scripts. ELF được xem là định dạng gốc của Linux (Linux's native format). Thông dịch ELF cung cấp một số bit nhị phân với các tài nguyên cần thiết bằng cách gọi hàm `_start()` - một hàm có sẵn từ gói `glibc` có thể được [kiểm tra qua GDB](https://github.com/chaiken/LCA2018-Demo-Code/commit/e543d9812058f2dd65f6aed45b09dda886c5fd4e). Kernel rõ ràng là không có trình thông dịch và phải cung cấp chính nó, nhưng làm thế nào?

    - Việc kiểm tra khởi động của hạt nhân với GDB đã đưa ra câu trả lời. Đầu tiên hãy cài đặt gói gỡ lỗi cho kernel có chứa một phiên bản chưa được giải nén vmlinux. Ví dụ:

          apt-get install linux-image-amd64-dbg

        hoặc biên dịch và cài kernel riêng của bạn từ source. Ví dụ thực hiện theo cách làm được hướng dẫn tiêu biểu trong [`Debian Kernel Handbook`](http://kernel-handbook.alioth.debian.org/)

    - `gdb vmlinux` tiếp theo là `info files` cho thấy phần ELF `init.text`. Danh sách bắt đầu thực hiện chương trình trong `init.text` với `l*(address)` trong đó `address` có thể là phần địa chỉ dạng hexadecimal bắt đầu `init.text`. GDB sẽ chỉ ra rằng kernel x86_64 khởi động trong tệp tin của kernel [`arch/x86/kernel/head_64.S`]https://github.com/torvalds/linux/blob/master/arch/x86/boot/compressed/head_64.S) - nơi mà có thể tìm thấy hàm nhúng (assembly function) `start_cpu0()` và code tạo ra một một `stack` và giải nén zImage  trước khi gọi tới hàm x86_64 `start_kernel()`. Kernel ARM 32bit cũng tương tự có [`arch/arm/kernel/head.S`](https://github.com/torvalds/linux/blob/master/arch/arm/boot/compressed/head.S). `start_kernel()` không phải là kiến trúc đặc trưng, vì vậy các hàm chứa trong [init/main.c](https://github.com/torvalds/linux/blob/master/init/main.c) của kernel. `start_kernel()` được xem là một hàm `main()` thực sự của Linux.

- ### <a name="5">2.5 Từ start_kernel () đến PID 1</a>

    - #### Phần kê khai phần cứng của kernel: bảng thiết bị và các bảng ACPI

        Khi khởi động, kernel cần thông tin về phần cứng vượt quá loại bộ xử lý mà nó đã được biên dịch. Các hướng dẫn trong code được gia tăng bởi dữ liệu cấu hình được lưu trữ riêng. Có hai phương thức chính để lưu trữ dữ liệu này: cây thiết bị (devices-tree) và bảng ACPI . Kernel học được phần cứng nào nó phải chạy ở mỗi lần khởi động bằng cách đọc các tập tin này.

    - Đối với thiết bị nhúng, cây thiết bị là biểu hiện của phần cứng được cài đặt. Cây thiết bị chỉ đơn giản là một tệp được biên dịch cùng lúc với mã nguồn kernel và thường nằm ở `/boot` bên cạnh `vmlinux`. Để xem những gì trong cây thiết bị nhị phân trên một thiết bị ARM, chỉ cần sử dụng lệnh `strings` từ gói `binutils` trên một tệp có tên dạng `/boot/*.dtb`.

    - Rõ ràng cây thiết bị có thể được sửa đổi đơn giản bằng cách chỉnh sửa các tập tin giống như một file JSON và biên soạn nó rồi trả tới một `dtc compiler` đặc biệt được cung cấp với nguồn kernel (kernel source). Mặc dù cây thiết bị là một tệp tin tĩnh nhưng đường dẫn tệp (file path) thường được đưa tới kernel thông qua bootloaders qua từng dòng lệnh. Một [`device-tree overlay`](http://lwn.net/Articles/616859/) đã được thêm vào trong những năm gần đây. Nơi mà kernel có thể tải các mảnh bổ sung để đáp ứng với các sự kiện hotplug sau khi khởi động.

    - Họ thiết bị x86 và nhiều thiết bị ARM-64 được cấp cho doanh nghiệp sử dụng cơ chế cấu hình và giao diện cấp cao ( [Advanced Configuration and Power Interface - ACPI](http://events.linuxfoundation.org/sites/events/files/slides/x86-platform.pdf) ) thay thế. Trái ngược với cây thiết bị, thông tin ACPI được lưu trữ trong `/sys/firmware/acpi/tables`. Hệ thống tập tin ảo (virtual filesystem) được tạo ra bởi kernel khi khởi động bằng cách truy cập vào ROM trên máy. Cách dễ dàng để đọc bảng ACPI là với lệnh `acpidump` từ gói `acpica-tools`. Đây là một ví dụ:

    [https://opensource.com/sites/default/files/u128651/linuxboot_2.png](https://opensource.com/sites/default/files/u128651/linuxboot_2.png)

    > Các bảng ACPI trên máy tính xách tay Lenovo đều được thiết lập cho Windows 2001.

    - Vâng, hệ thống Linux của bạn đã sẵn sàng cho Windows 2001, bạn nên cẩn thận để cài đặt nó. ACPI có cả phương thức và dữ liệu, không giống như cây thiết bị, ACPI vốn là ngôn ngữ mô tả phần cứng. Các phương thức của ACPI tiếp tục được hoạt động sau khi khởi động. Ví dụ, thực hiện lệnh:

            acpi_listen

        từ gói `apcid` sau đó mở và đóng nắp máy tính xách tay sẽ cho thấy rằng hàm của ACPI đang chạy tất cả thời gian. Trong khi việc tạm thời và tự động `[overwriting the ACPI tables](https://www.mjmwired.net/kernel/Documentation/acpi/method-customizing.txt)` là có thể xảy ra. Việc thay đổi vĩnh viễn chúng liên quan đến tương tác với trình đơn BIOS lúc khởi động hoặc reflashing ROM. Nếu bạn đang gặp rắc rối đó, có lẽ bạn nên cài đặt [coreboot](https://www.coreboot.org/Supported_Motherboards) - phần mềm nguồn mở thay thế.


    - #### Từ start_kernel () đến không gian người dùng (userspace)

        Code bên trong [init/main.c](https://github.com/torvalds/linux/blob/master/init/main.c) thật đáng kinh ngạc và thú vị,  vẫn mang bản quyền gốc của Linus Torvalds từ năm 1991-1992. Các dòng được tìm thấy trong `dmesg | head` của một hệ thống mới khởi động bắt nguồn chủ yếu từ tập tin nguồn này. Đầu tiên, CPU sẽ đăng ký với hệ thống, các cấu trúc dữ liệu chung được khởi tạo, với trình tự lập trình, bộ xử lý gián đoạn (IRQs), bộ đếm thời gian và giao diện điều khiển được đặt theo thứ tự nghiêm ngặt, có sẵn.

    - Cho đến khi hàm `timekeeping_init()` chạy, tất cả `timestamps` là `0`. Phần khởi tạo này của kernel được đồng bộ, có nghĩa là việc thực hiện xảy ra ở chính xác một luồng và không có chức năng nào được thực hiện cho đến khi kết thúc và trả về kết quả cuối cùng. Kết quả là `dmesg` trả về sẽ được hoàn toàn tái tạo được ngay cả giữa hai hệ thống, miễn là họ có cùng một thiết bị cây hoặc bảng ACPI. Linux đang hoạt động giống như một trong những hệ điều hành RTOS (real-time operating systems) chạy trên các MCU, ví dụ như QNX hoặc VxWorks. Tình huống vẫn tồn tại trong hàm `rest_init()`, được gọi bằng cách thực hiện câu lệnh `start_kernel()`.

    [https://opensource.com/sites/default/files/u128651/linuxboot_3.png](https://opensource.com/sites/default/files/u128651/linuxboot_3.png)

    > Tóm tắt quá trình khởi động hạt nhân.

    - Khi gọi đến hàm `rest_init()`, hàm sẽ thực hiện tạo ra một luồng mới gọi đến hàm `kernel_init()` và hàm này gọi đến hàm `do_initcalls()`. Người dùng có thể kiểm tra các hành động ở initcalls bằng cách thêm `initcall_debug` vào dòng lệnh của kernel. Kết quả trả về trong dmesg mỗi khi có một hàm `initcall` được chạy. `initcalls` đều thông qua bảy mức độ tuần tự đó là `early, core, postcore, arch, subsys, fs, device, and late.` Phần người dùng dễ nhìn thấy nhất của `initcalls` đó là việc dò tìm và thiết lập các thiết bị ngoại vi của bộ vi xử lý: buses, network, storage, display, ... cùng với việc tải các modul của kernel.

    - Hàm `rest_init()` cũng gọi một thread tới bộ xử lý, việc khởi động bắt đầu bằng cách chạy hàm `cpu_idle()` trong khi chờ đợi trình lên lịch gàn nó làm việc.

    - Hàm `kernel_init()` cũng thiết lập [symmetric multiprocessing - smp](http://free-electrons.com/pub/conferences/2014/elc/clement-smp-bring-up-on-arm-soc). Với nhiều loại kernel gần đây, hãy tìm đầu ra của `dmesg` bằng cách thực hiện tìm kiếm ""Bringing up secondary CPUs..." SMP xử lý bởi "hotplugging" CPUs. Có nghĩa là nó sẽ quản lý vòng đời của chúng bằng một trạng thái máy tương tự như các thiết bị như "hotplugged" USB sticks.

    - Hệ thống quản lý năng lượng của kernel thường lấy các core offline riêng lẻ, sau đó đánh thức chúng khi cần thiết. Do đó cùng một mã nguồn của CPU hotplug được gọi lặp đi lặp lại trên một máy không bận. Quan sát lời gọi của hệ thống quản lý điện của CPU hotplug bằng [công cụ BCC](http://www.brendangregg.com/ebpf.html) được gọi là offcputime.py.

    - Lưu ý rằng mã trong `init/main.c` gần như đã hoàn thành khi `smp_init()` chạy. Bộ xử lý khởi động đã hoàn thành hầu hết việc khởi tạo một lần mà các lõi khác không cần phải lặp lại. Tuy nhiên, các chuỗi cho mỗi CPU phải được sinh ra cho mỗi core để quản lý các ngắt (IRQs), workqueues, timer, và các sự kiện.

    - Ví dụ, xem các chuỗi cho mỗi CPU phục vụ softirqs và workqueues đang hoạt động thông qua lệnh `ps -o psr`.

            $ psx, comm $ (pgrep ksoftirqd)   
            PID PSR COMMAND 
               7 0 ksoftirqd / 0 
              16 1 ksoftirqd / 1 
              22 2 ksoftirqd / 2 
              28 3 ksoftirqd / 3 

            $ \ # ps -o pid, psr, comm $ (pgrep kworker) 
            PID PSR COMMAND 
               4 0 người làm việc / 0: 0H 
              18 1 người làm việc / 1: 0H 
              24 2 người làm việc / 2: 0H 
              30 3 người làm việc / 3: 0H 
            [. . . ]

        trong đó: `PSR` là viết tắt của "processor". Mỗi core cũng phải lưu trữ bộ đếm giờ và bộ `cpuhp` hotplug điều khiển.

- ### <a name="6">2.6 Không gian người dùng đầu tiên: người ra lệnh cho initrd?</a>

    - Bên cạnh cây thiết bị, một đường dẫn tệp khác được cung cấp cho kernel khi khởi động là đường dẫn `initrd`.

    - `initrd` thường được chứa trong `/boot` cùng với tệp bmlImage trên x86 hoặc bên cạnh tệp uImage với thiết bị tương tự cho ARM.

    - Để liệt kê các nội dung của `initrd`, ta sử dụng công cụ `lsinitramfs` trong gói `initramfs-tools-core`. Distro `initrd` schemes tối thiểu bao gồm các đường dẫn `/bin`, `/sbin` và `/etc` cùng với modul của kernel và một vài file trong `/scripts`. Tất cả trông giống khá là quen thuộc, vì `initrd` hầu hết các phần chỉ đơn giản là một hệ thống tập tin gốc Linux tối thiểu. 

    - Tại sao phải tạo ra một `initrd` nếu tất công việc của nó là load một số modul và sau đó bắt đầu `init` trên filesystem. Xem xét một hệ thống tập tin gốc mã hóa. Việc giải mã có thể dựa vào việc load một modul hạt nhân được lưu trữ trong `/lib/modules` trong root filesystem và cũng không có gì đáng ngạc nhiên với `initrd`. Crypto module có thể được biên dịch tĩnh trong kernel thay vì được load từ một tệp nhưng có nhiều lý do khác nhau khiến bạn không muốn làm như vậy.

    - Ví dụ, việc biên dịch kernel bằng các modul có thể làm cho nó quá lớn để phù hợp với dung lượng có sẵn, hoặc việc biên dịch tĩnh có thể vi phạm các điều khoản của một giấy phép phần mềm. Không ngạc nhiên khi các trình điều khiển thiết bị đầu vào (HID) lưu trữ, network và con người (HID) cũng có thể có mặt trong `initrd`. Về cơ bản bất kỳ code nào không phải là một phần của kernel thích hợp mà là cần thiết để gắn kết các root filesystem. `initrd` cũng là nơi người dùng có thể lưu trữ mã bảng [ACPI tuỳ chỉnh](https://www.mjmwired.net/kernel/Documentation/acpi/initrd_table_override.txt) của riêng họ.

    > [https://opensource.com/sites/default/files/u128651/linuxboot_4.png](https://opensource.com/sites/default/files/u128651/linuxboot_4.png)

    - Cuối cùng, khi `init` chạy, hệ thống sẽ khởi động! Kể từ khi các bộ vi xử lý thứ cấp đang chạy, hệ thống đã trở thành vật không đồng bộ, không thể dự đoán trước được, hiệu năng cao mà chúng ta biết và yêu thích. Thật vậy, `ps -o pid`, hay `psr`, `comm -p 1` là những câu lệnh có thể chứng minh rằng `init` là quá trình của userspace không còn chạy trên bộ xử lý khởi động.

- ### <a name="7">2.7 Tổng quan</a>

    - Quá trình khởi động Linux nghe có vẻ khá khó hiểu, xem xét số lượng phần mềm khác nhau tham gia ngay cả trên các thiết bị nhúng đơn giản.

    - Ở một khía cạnh, quá trình khởi động khá đơn giản, vì sự phức tạp gây bối rối do các tính năng như preemption, RCU và `race conditions` không có trong khi khởi động. 

    - Chỉ tập trung vào hạt nhân và PID 1 nhìn thấy số lượng lớn công việc mà bootloaders và các bộ vi xử lý phụ trợ có thể làm trong việc chuẩn bị nền tảng cho kernel có thể chạy.

    - Trong khi kernel chắc chắn là duy nhất trong số các chương trình Linux. Một số hiểu biết về cấu trúc của nó có thể được lượm nhặt bằng cách áp dụng cho nó một số công cụ tương tự dùng để kiểm tra các chương trình ELF khác. Việc nNghiên cứu quá trình khởi động trong khi nó đang làm việc để bảo vệ hệ thống cho những lỗi khi chúng xảy ra


____

# <a name="content-others">Các nội dung khác</a>
