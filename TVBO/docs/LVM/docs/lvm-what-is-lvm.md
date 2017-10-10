# 1. Tìm hiểu tổng quan về LVM.

____

# Mục lục


- [1.1 LVM là gì?](#what-is)
- [1.2 Chức năng của LVM](#features)
- [1.3 Cách cài đặt và sử dụng cơ bản](#using)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="what-is">LVM là gì?</a>

    - LVM là viết tắt của cụm từ Logical Volume Manager. 

    - Đây là một phương pháp cho phép chuyển các không gian đĩa cứng thành những logical volume làm cho việc thay đổi kích thước trở lên dễ dàng hơn (so với partition). Với kỹ thuật này, bạn có thể thay đổi kích của một hay nhiều disk mà không cần phải can thiệp đến quá nhiều về hệ thống. Có nghĩa là bạn có thay đổi một tùy ý cho dung lượng của phân vùng ổ cứng trong hệ điều hành.

- ### <a name="features">1.2 Chức năng của LVM</a>

    - Các chức năng chính của LVM bao gồm:
    
        + Tạo và quản lý các Logical Volume. Một Logical Volume là một phân vùng được hình thành từ nhiều phân vùng ổ đĩa khác nhau để có dung lượng chứa bằng tổng các dung lượng của các ổ đĩa hình thành lên nó.
        + Hỗ trợ tính năng Snapshot, cho phép phục hổi hiện trạng của không gian ổ đĩa tại một thời điểm nào đó.
        + Cung cấp tính năng Thin Provisioning Volumes
        + Có thể quản lý nhiều Logical Volume cùng một lúc
        + Hỗ trợ tính năng LVM Migration.

- ### <a name="using">1.3 Cách cài đặt và sử dụng cơ bản</a>

    - LVM là một phương pháp được hỗ trợ sẵn trong các hệ điều hành Linux. Các tính năng của nó được cung cấp qua nhiều tiện các câu lệnh. Ta sẽ cần phải nhớ một vài lưu ý sau, trước khi bắt đầu thực hiện quản lý các logical volume, cũng như file system.

    - Đối với các thao tác về Physical Volumes. Ta sẽ sử dụng các câu lệnh chứa tiền tố `pv*` được hỗ trợ trong terminal của Linux. Chung tao gồm:

            pvchange   pvck       pvcreate   pvdisplay  pvmove     

            pvremove   pvresize   pvs        pvscan

        một Physical Volume là một đĩa vật lý, hoặc một phân vùng đĩa mà chúng ta sử dụng cho hệ điều hành chẳng hạn như /dev/sda1, /dev/sdb1, ... Mà khi ta muốn sử dụng chúng, ta chỉ cần thực hiện thao tác mount nó vào để sử dụng. LVM sử dụng chúng để tạo lên một Volume Group.

    - Đối với những các thao tác về Volume Group. Ta sẽ sử dụng các câu lệnh chứa tiền tố `vg*` được hỗ trợ trong terminal. Chúng bao gồm:

            vgcfgbackup    vgck           vgdisplay      vgimport       vgmknodes      vgrename       vgsplit

            vgcfgrestore   vgconvert      vgexport       vgimportclone  vgreduce       vgs

            vgchange       vgcreate       vgextend       vgmerge        vgremove       vgscan

        một Volume Group như đã nói ở trên chính là một nhóm các Physical Volume hình thành lên. Có thể coi đây như là một phân vùng ảo.

    - Đối với các thao tác về Logical Volume. Ta sẽ sử dụng các câu lệnh có tiền tố `lv*` hỗ trợ trong termial. Chúng bao gồm:

            lvchange     lvdisplay    lvmchange    lvmdiskscan  lvmpolld     lvreduce     lvresize

            lvconvert    lvextend     lvmconf      lvmdump      lvmsadc      lvremove     lvs

            lvcreate     lvm          lvmconfig    lvmetad      lvmsar       lvrename     lvscan

        đây chính là những volume hoàn chỉnh ở mức cuối cùng trước khi có thể mount vào hệ điều hành. Ta có thể thay đổi, thêm bớt kích thước của những volume một cách nhanh chóng. Cho tới khi chúng được chứa trong các Volume Group, ta có thể cung cấp dung lượng cho chúng lớn hơn nhưng Physical Volume đơn. Ví dụ: Ban đầu, ta có 4 ổ cứng với dung lượng 10GB. Thì ta có thể có một Logical Volume với bất kỳ dung lượng nào được cho với giá trị tối đa là 40GB, sau đó là những giá trị khác 20GB, 30GB hoặc 10GB.

          > ![img](https://www.centos.org/docs/5/html/Deployment_Guide-en-US/images/lvm/lvg.png)

    - Tóm lại, LVM có thể sử dụng các chức năng trên để sử dụng các kết hợp Physical Volume vào trong một Volume Group để thống nhất không gian lưu trữ có sẵn trên hệ thống. Sau đó, ta có thể chia chúng thành những phân vùng có kích thước khác nhau.

        > ![img](https://www.centos.org/docs/5/html/Deployment_Guide-en-US/images/lvm/lvols.png)


    - Cuối cùng, các bước để sử dụng LVM cho việc quản lý ổ đĩa như sau:

        + Bước 1: Tạo ra Physical Volumes từ không gian của một hay nhiều đĩa cứng.

        + Bước 2: Tạo ra Volume Groups từ không gian của các Physical Volume.

        + Bước 3: Tạo ra Logical Volume từ Volume Groups và sử dụng chúng.


    - Ví dụ cho việc sử dụng phương pháp LVM có thể được thực hiện như sau:

        > Lưu ý: Phương pháp này được thực hiện với với máy có 3 ổ đĩa dư thừa. Mỗi đĩa có dung là 1 GB.

        + Đầu tiên, ta sẽ kiểm tra xem LVM có thể can thiệp và quản lý ổ đĩa nào bằng cách sử dụng câu lệnh:

                lvmdiskscan

            kết quả sẽ hiển thị tương tự như sau:

                  /dev/cl/root [      17.00 GiB]
                  /dev/sda1    [       1.00 GiB]
                  /dev/cl/swap [       2.00 GiB]
                  /dev/sda2    [      19.00 GiB] LVM physical volume
                  /dev/sdb     [       1.00 GiB]
                  /dev/sdc     [       1.00 GiB]
                  /dev/sdd     [       1.00 GiB]
                  5 disks
                  1 partition
                  0 LVM physical volume whole disks
                  1 LVM physical volume

            nhìn vào kết quả này cho viết máy của mình đang thực hiện có 5 đĩa và 1 phân vùng, ... Trong đó, 3 phân vùng còn trống để tôi có thể sử dụng cho việc quản lý sử dụng LVM đó là:

                  /dev/sdb     [       1.00 GiB]
                  /dev/sdc     [       1.00 GiB]
                  /dev/sdd     [       1.00 GiB]

            bây giờ, ta sẽ tạo ra một Physical Volumes để kết thúc cho Bước 1 với câu lệnh:

                pvcreate /dev/sdb /dev/sdc /dev/sdd

            kết quả:

                  Physical volume "/dev/sdb" successfully created.
                  Physical volume "/dev/sdc" successfully created.
                  Physical volume "/dev/sdd" successfully created.                

            điều này đã thực hiện format các đĩa này theo định dạng của `lvm2`. Ta có thể kiểm tra với câu lệnh:

                lvmdiskscan

            kết quả tương tự như sau:

                  /dev/cl/root [      17.00 GiB]
                  /dev/sda1    [       1.00 GiB]
                  /dev/cl/swap [       2.00 GiB]
                  /dev/sda2    [      19.00 GiB] LVM physical volume
                  /dev/sdb     [       1.00 GiB] LVM physical volume
                  /dev/sdc     [       1.00 GiB] LVM physical volume
                  /dev/sdd     [       1.00 GiB] LVM physical volume
                  2 disks
                  1 partition
                  3 LVM physical volume whole disks
                  1 LVM physical volume

            hoặc sử dụng câu lệnh:

                pvs

            ta sẽ nhận được kết quả như sau:

                  PV         VG Fmt  Attr PSize  PFree
                  /dev/sda2  cl lvm2 a--  19.00g    0
                  /dev/sdb      lvm2 ---   1.00g 1.00g
                  /dev/sdc      lvm2 ---   1.00g 1.00g
                  /dev/sdd      lvm2 ---   1.00g 1.00g

        + Tiếp theo, ta sẽ thực hiện việc làm cho `Bước 2. Tạo ra Volume Groups từ không gian của các Physical Volume.`
            Để tạo ra một Volume Group, ta sử dụng câu lệnh sau:

                vgcreate LVMVolGroup /dev/sdb /dev/sdc /dev/sdd

            trong đó: - LVMVolGroup là tên của Volume Group
            kết quả của câu lệnh giống như sau:

                  Volume group "LVMVolGroup" successfully created

            ta có thể kiểm tra kết quả đã tạo ra thành công hay chưa với câu lệnh:

                pvs

            kết quả tương tự như sau:

                  PV         VG          Fmt  Attr PSize    PFree
                  /dev/sda2  cl          lvm2 a--    19.00g       0
                  /dev/sdb   LVMVolGroup lvm2 a--  1020.00m 1020.00m
                  /dev/sdc   LVMVolGroup lvm2 a--  1020.00m 1020.00m
                  /dev/sdd   LVMVolGroup lvm2 a--  1020.00m 1020.00m

            hoặc ngắn gọn hơn với câu lệnh:

                vgs

            kết quả tương tự như sau:

                  VG          #PV #LV #SN Attr   VSize  VFree
                  LVMVolGroup   3   0   0 wz--n-  2.99g 2.99g
                  cl            1   2   0 wz--n- 19.00g    0

            qua kết quả này, ta đã thấy có một sự khác biệt so với khi ta kiểm tra kết quả với câu lệnh tương tự ở `Bước 1.`. Và Volume Groups `LVMVolGroup` - volume mà chúng ra vừa tạo ra có dung lượng không gian trống xấp xỉ 3GB (Bằng tổng dung lượng của 3 đĩa /dev/sdb, /dev/sdc và /dev/sdd tạo lên nó.)

        + Cuối cùng, ta sẽ thực hiện các bước làm cho `Bước 3: Tạo ra Logical Volume từ Volume Groups và sử dụng chúng.` như sau:

            - Trong bước này, mình sẽ thực hiện tạo ra 2 Logical Volume lần lượt có tên và dung lượng như sau:

                    - Public: 2GB
                    - Private: 0.99GB
            
                bằng việc sử dụng 2 câu lệnh sau:

                    lvcreate -L 2G -n Public LVMVolGroup

                    lvcreate -L 0.9G -n Private LVMVolGroup

                tại sao lại là 0.9Gb mà không phải 1GB đó là vì trong quá trình sử dụng LVM, nó sẽ sử dụng một phần của dung lượng lưu trữ các thông tin khác. Kết quả lần lượt như sau:

                      Logical volume "Public" created.

                và

                      Rounding up size to full physical extent 924.00 MiB
                      Logical volume "Private" created.

                cuối cùng, ta hãy kiểm tra kết quả của việc này bằng cách sử dụng câu lệnh:

                     vgs -o +lv_size,lv_name

                nó sẽ hiển thị tương tự như sau:

                      VG          #PV #LV #SN Attr   VSize  VFree  LSize   LV
                      LVMVolGroup   3   2   0 wz--n-  2.99g 88.00m   2.00g Public
                      LVMVolGroup   3   2   0 wz--n-  2.99g 88.00m 924.00m Private
                      cl            1   2   0 wz--n- 19.00g     0    2.00g swap
                      cl            1   2   0 wz--n- 19.00g     0   17.00g root

            - Cuối cùng, để sử dụng các Logical Volume vừa tạo ra, ta cần phải format và mount chúng vào với hệ điều hành. Nhưng, ta cần phải lưu ý rằng, các Logical Volume có thể được truy cập ở hai nơi đó là:

                    /dev/volume_group_name/logical_volume_name

                và

                    /dev/mapper/volume_group_name-logical_volume_name

                vì vậy, khi format ta có thể sử dụng câu lệnh sau (mình sẽ sử dụng theo định dạng ext4 ):

                    mkfs.ext4 /dev/LVMVolGroup/Public
                    mkfs.ext4 /dev/LVMVolGroup/Private

                hoặc

                    mkfs.ext4 /dev/mapper/LVMVolGroup-Public
                    mkfs.ext4 /dev/mapper/LVMVolGroup-Private

                + Trước khi mount vào để sử dụng, ta cần tạo ra một thư  mục để có chức năng `gắn kết` với Logical Volumes đã format. Giả sử mình sẽ làm như sau:

                        mkdir -p /mnt/{Public,Private}

                    câu lệnh trên sẽ tạo ra 2 thư mục `/mnt/Public` và `/mnt/Private`. Sau bước này, ta có thể mount chúng tương ứng với tên thư mục tạo ra như sau:

                        mount /dev/LVMVolGroup/Public /mnt/Public
                        mount /dev/LVMVolGroup/Private /mnt/Private

                    và kiểm tra kết quả với câu lệnh:

                        df -H

                    nó sẽ hiển thị tương tự như sau:
    
                        Filesystem                       Size  Used Avail Use% Mounted on
                        /dev/mapper/cl-root               19G  1.3G   17G   8% /
                        devtmpfs                         945M     0  945M   0% /dev
                        tmpfs                            957M     0  957M   0% /dev/shm
                        tmpfs                            957M  9.1M  948M   1% /run
                        tmpfs                            957M     0  957M   0% /sys/fs/cgroup
                        /dev/sda1                        1.1G  145M  919M  14% /boot
                        tmpfs                            192M     0  192M   0% /run/user/1000
                        /dev/mapper/LVMVolGroup-Public   2.1G  6.3M  2.0G   1% /mnt/Public
                        /dev/mapper/LVMVolGroup-Private  937M  2.4M  870M   1% /mnt/Private

                bên trên chính là một cách cơ bản để sử dụng LVM cho việc quản lý phân vùng ổ cứng.

____

# Tài liệu tham khảo

- [What is LVM?](https://www.centos.org/docs/5/html/Deployment_Guide-en-US/ch-lvm.html)

____

# <a name="content-others">Các nội dung khác</a>
