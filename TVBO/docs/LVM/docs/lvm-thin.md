# 4.Tìm hiểu về tính năng Thin Provisioning trong LVM

____

# Mục lục


- [4.1 Giới thiệu về tính năng](#about)
- [4.2 Làm thế nào để sử dụng tính năng?](#set-up)
- [4.3 Tính năng Over Provisioning](#over-provision)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="about">4.1 Giới thiệu về tính năng Thin Provisioning</a>

    - Trong LVM, chúng ta được cung cấp một tính năng khá là tuyệt vời tương tự như tính năng Snapshot - đó là tính năng Thin Provisioning. Vậy tính năng này có thể làm được những gì mà được cho là một tính năng tuyệt vời?

    - `Thin Provisioning` là một tính năng được sử dụng để tạo ra những ổ đĩa ảo từ những storage pool. Hãy thử giả định rằng, ta đang có một storage pool với dung lượng 15Gb. Ta đang sử dụng nó để cung cấp không gian lưu trữ cho 3 người, với mỗi người có dung lượng lưu trữ tối đa là 5Gb cho mỗi storage pool của mỗi người. Và thực tế, 3 người họ chỉ sử dụng hết 6Gb trong tổng số 15Gb. Như vậy. ta đang còn trống 9Gb dung lượng từ storage pool ban đầu.

    - Khi ta sử dụng tính năng `Thin Provisioning` để cung cấp dung lượng lưu trữ cho 3 người kia một storage pool, mỗi pool lúc này sẽ được xem là một `thin pool`. Tất cả những gì về dữ liệu của bạn sẽ vẫn được lưu trữ và không gian lưu trữ sẽ vẫn hiển thị với không gian là 5Gb. Nhưng thực tế, hiện tại, bạn sẽ không được cung cấp đầy đủ dung lượng lưu trữ là 5Gb. Chính vì điều này, khi chúng ta giả định rằng, 3 người kia được cung cấp không gian lưu trữ là 5Gb và họ chỉ sử dụng hết 6Gb trong tổng số 15Gb ban đầu của chúng ta thì chúng ta vẫn có thể cung cấp một không gian lưu trữ khác cũng với 5Gb dung lượng cho một người nữa. Như vậy, ta có thể cung cấp được dung lượng bộ nhớ lưu trữ cho ít nhất 3 người với mỗi không gian nhớ là 5Gb. Đây chính là tính năng mà `Thin Provisioning` hướng đến để giải quyết.


- ### <a name="set-up">4.2 Làm thế nào để sử dụng tính năng Thin Provisioning?</a>

    - Trong nội dung bài viết nay, ta tiếp tục sử dụng các tài nguyên đã được sử dụng ở các phần trước. Theo đó, ta có:

        - Hệ điều hành sử dụng: CentOS 7
        - Bao gồm 4 Physical Volume:
            - /dev/sdb: 1Gb
            - /dev/sdc: 1Gb
            - /dev/sdd: 1Gb
            - /dev/sde: 1Gb
        - Một VolumeGroup tên là LVMVolGroup hình thành từ 4 Physical Volume trên.

    - Đầu tiên, ta hãy đổi tên của LVMVolGroup thành LVMThinGroup cho dễ dàng phân biệt với các Volume Group khác (nếu có.)

            # vgrename LVMVolGroup LVMThinGroup

        kết quả sẽ hiển thị:

              Volume group "LVMVolGroup" successfully renamed to "LVMThinGroup"

        cuối cùng, trước khi bắt đầu thực hiện sử dụng tính năng `Thin Provisioning` ta có dữ liệu như sau:

            # vgs
              VG           #PV #LV #SN Attr   VSize  VFree
              LVMThinGroup   4   0   0 wz--n-  3.98g 3.98g

    - Để thực hiện sử dụng tính năng `Thin Provisioning` ta làm như sau:

        + Bước 1: Tạo ra một thin pool với câu lệnh như sau:

                # lvcreate -l 1018 --thinpool tp_volume_pool LVMThinGroup

            trong đó:

                - `-l 1018G`: dùng để khai báo kích thước của thin pool sẽ tạo ra là 3.98Gb tính theo giá trị PE.
                - `--thinpool`: khai báo logical volume tạo ra thuộc kiểu `thin pool`
                - `tp_volume_pool`: tên của thin pool sẽ tạo ra.
                - `LVMThinGroup`: tên của Volume Group sẽ được sử dụng để tạo ra thin pool

            kết quả sẽ hiển thị tương tự như sau:

                # lvcreate -l 1018 --thinpool tp_volume_pool LVMThinGroup

                  Using default stripesize 64.00 KiB.
                  Logical volume "tp_volume_pool" created.
                
                # lvs

                  LV             VG           Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
                  tp_volume_pool LVMThinGroup twi-a-tz--  3.98g             0.00   1.17
                  root           cl           -wi-ao---- 17.00g
                  swap           cl           -wi-ao----  2.00g


        + Bước 2: Ta sẽ tạo ra một thin volume. Cách làm như sau:

                # lvcreate -V 1024 --thin -n tv_client01 LVMThinGroup/tp_volume_pool

            trong đó:

                - `-V 1024`: khai báo kích thước của thin volume là 1024Mb
                - `--thin`: Khai báo kiểu tạo ra volume là thin volume
                - `-n tv_client01`: khai báo tên của thin volume tạo ra là tv_client01
                - `LVMThinGroup/tp_volume_pool`: khai báo thin pool được sử dụng để tạo ra thin volume.

            kết quả sẽ hiển thị tương tự như sau:

                  Using default stripesize 64.00 KiB.
                  Logical volume "tv_client01" created.

                # lvs
                  LV             VG           Attr       LSize  Pool           Origin Data%  Meta%  Move Log Cpy%Sync Convert
                  tp_volume_pool LVMThinGroup twi-aotz--  3.98g                       0.00   1.27
                  tv_client01    LVMThinGroup Vwi-a-tz--  1.00g tp_volume_pool        0.00
                  root           cl           -wi-ao---- 17.00g
                  swap           cl           -wi-ao----  2.00g

            tương tự như trên, ta hãy tạo ra thêm 2 thin pool lần lượt có tên là tv_client02 và tv_client03. Cuối cùng, ta có được thông tin như sau:

                # lvs

                  LV             VG           Attr       LSize  Pool           Origin Data%  Meta%  Move Log Cpy%Sync Convert
                  tp_volume_pool LVMThinGroup twi-aotz--  3.98g                       0.00   1.46
                  tv_client01    LVMThinGroup Vwi-a-tz--  1.00g tp_volume_pool        0.00
                  tv_client02    LVMThinGroup Vwi-a-tz--  1.00g tp_volume_pool        0.00
                  tv_client03    LVMThinGroup Vwi-a-tz--  1.00g tp_volume_pool        0.00
                  root           cl           -wi-ao---- 17.00g
                  swap           cl           -wi-ao----  2.00g

        + Bước 3: Thực hiện mount các thin pool đã tạo ra vào hệ thống. Ta làm tương tự như khi mount một Logical Volume.

            - Tạo ra các thư mục có chức năng `gắn kết` tương ứng cho các thin pool:

                    # mkdir -p /mnt/{client01,client02,client03}

            - Format định dạng cho các thin pool:

                    # mkfs.ext4 /dev/LVMThinGroup/tv_client01
                    # mkfs.ext4 /dev/LVMThinGroup/tv_client02
                    # mkfs.ext4 /dev/LVMThinGroup/tv_client03

            - Mount các thin pool đã tạo ra vào hệ thống ứng với các thư mục đã tạo ở phần đầu của bước này:

                    # mount /dev/LVMThinGroup/tv_client01 /mnt/client01/
                    # mount /dev/LVMThinGroup/tv_client02 /mnt/client02/
                    # mount /dev/LVMThinGroup/tv_client03 /mnt/client03/

        + Bước 4: Thực hiện kiểm tra dung lượng thực sự đã sử dụng của thin pool:

                # lvs

            kết quả hiện thị tương tự như sau:


                  LV             VG           Attr       LSize  Pool           Origin Data%  Meta%  Move Log Cpy%Sync Convert
                  tp_volume_pool LVMThinGroup twi-aotz--  3.98g                       3.61   3.22
                  tv_client01    LVMThinGroup Vwi-aotz--  1.00g tp_volume_pool        4.79
                  tv_client02    LVMThinGroup Vwi-aotz--  1.00g tp_volume_pool        4.79
                  tv_client03    LVMThinGroup Vwi-aotz--  1.00g tp_volume_pool        4.79
                  root           cl           -wi-ao---- 17.00g
                  swap           cl           -wi-ao----  2.00g

            theo kết quả trên, ta thấy, các thin volume hiện đan sử dụng 4.79% dung lượng và thin pool chỉ sử dụng 3.61%.


- ### <a name="over-provision">4.3 Tính năng Over Provisioning</a>


    - Như ở phần đầu của bài viết đã đề cập. Khi sử dụng tính năng `Thin Provisioning` ta có thể cung cấp dung lượng cho nhiều hơn những gì thực tế ta có khi storage pool hiện đang còn có dung lượng trống. Việc cung cấp như này được gọi là `Over Provisioning`.

    - Ngay bây giờ, ta sẽ thự hiện quá trình `Over Provisioning` bằng việc tạo thêm một thin volume 2Gb nữa. Vì ta đang có 3 thin volume sử dụng hết 3.16% trong tổng dung lượng của thin pool đã tạo ra.

            # lvcreate -V 2048 --thin -n tv_client04 LVMThinGroup/tp_volume_pool

        kết quả sẽ hiển thị tương tự như sau:

              Using default stripesize 64.00 KiB.
              WARNING: Sum of all thin volume sizes (5.00 GiB) exceeds the size of thin pool LVMThinGroup/tp_volume_pool and the size of whole volume group (3.98 GiB)!
              For thin pool auto extension activation/thin_pool_autoextend_threshold should be below 100.
              Logical volume "tv_client04" created.

    - Khi ta kiểm tra với câu lệnh `lvs` sẽ nhận được kết quả tương tự như sau:

              LV             VG           Attr       LSize  Pool           Origin Data%  Meta%  Move Log Cpy%Sync Convert
              tp_volume_pool LVMThinGroup twi-aotz--  3.98g                       3.61   3.32
              tv_client01    LVMThinGroup Vwi-aotz--  1.00g tp_volume_pool        4.79
              tv_client02    LVMThinGroup Vwi-aotz--  1.00g tp_volume_pool        4.79
              tv_client03    LVMThinGroup Vwi-aotz--  1.00g tp_volume_pool        4.79
              tv_client04    LVMThinGroup Vwi-a-tz--  2.00g tp_volume_pool        0.00
              root           cl           -wi-ao---- 17.00g
              swap           cl           -wi-ao----  2.00g


    - Tiếp tục thực hiện các bước để có thể sử dụng thin volume vừa tạo ra tương tự như ở trên:

            # mkdir /mnt/client04
            # mkfs.ext4 /dev/LVMThinGroup/tv_client04
            # mount /dev/LVMThinGroup/tv_client04 /mnt/client04


        khi kiểm tra câu lệnh `df -H` ta được:


            /dev/mapper/cl-root                    19G  1.3G   17G   8% /
            devtmpfs                              945M     0  945M   0% /dev
            tmpfs                                 957M     0  957M   0% /dev/shm
            tmpfs                                 957M  9.1M  947M   1% /run
            tmpfs                                 957M     0  957M   0% /sys/fs/cgroup
            /dev/sda1                             1.1G  145M  919M  14% /boot
            tmpfs                                 192M     0  192M   0% /run/user/1000
            /dev/mapper/LVMThinGroup-tv_client01  1.1G  2.7M  951M   1% /mnt/client01
            /dev/mapper/LVMThinGroup-tv_client02  1.1G  2.7M  951M   1% /mnt/client02
            /dev/mapper/LVMThinGroup-tv_client03  1.1G  2.7M  951M   1% /mnt/client03
            /dev/mapper/LVMThinGroup-tv_client04  2.1G  6.3M  2.0G   1% /mnt/client04

    - Có một điều cần lưu ý khi ta bắt đầu sử dụng đến `Over Provisioning` đó là khi dữ liệu người dùng tăng đột xuất và sẽ sử dụng đầy đủ hết 5Gb. Thì sẽ xảy ra xung đột trong hệ thống, ta cần phải bổ sung dung lượng bộ nhớ cho thin pool kịp thời để tránh xảy ra xung đột. Hãy thực hiện, thêm dung lượng cho thin pool bằng việc sử dụng câu lệnh `lvextend` và coi thin pool của chúng ra đã tạo như một Logical Volume thông thường. Ví dụ:

            # lvextend -L +15G /dev/LVMThinGroup/tp_volume_pool
            

# <a name="content-others">Các nội dung khác</a>
