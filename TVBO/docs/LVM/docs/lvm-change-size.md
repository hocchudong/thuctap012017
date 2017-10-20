# 2. Cách thay đổi dung lượng sử dụng LVM cho Volume Group

____

# Mục lục


- [2.1 Thay đổi dung lượng cho Volume Group](#change)
- [2.2 Thay đổi kích thước của Logical Volume](#resize)
- [2.3 Xóa Volume](#delete)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="change">2.1 Thay đổi dung lượng cho Volume Group</a>

    - Trong nội dung phần này, sẽ tiếp tục sử dụng các tài nguyên hiện cho trong nội dung của bài viết [1. Tìm hiểu tổng quan về LVM.](lvm-what-is-lvm.md). Nhưng ta sẽ cần thêm một disk có dung lượng 1GB vào trong máy. Như vậy, ta hiện đang có thông tin sau:

        - 1 Volume Group tên là: LVMVolGroup đã chia thành 2 Logical Volume là Public và Private.
        - 1 đĩa trống có dung lượng 1GB. Phân vùng này nằm ở /dev/sde.

                # lvmdiskscan

                  /dev/cl/root             [      17.00 GiB]
                  /dev/sda1                [       1.00 GiB]
                  /dev/cl/swap             [       2.00 GiB]
                  /dev/sda2                [      19.00 GiB] LVM physical volume
                  /dev/LVMVolGroup/Public  [       2.00 GiB]
                  /dev/LVMVolGroup/Private [     924.00 MiB]
                  /dev/sdb                 [       1.00 GiB] LVM physical volume
                  /dev/sdc                 [       1.00 GiB] LVM physical volume
                  /dev/sdd                 [       1.00 GiB] LVM physical volume
                  /dev/sde                 [       1.00 GiB]
                  5 disks
                  1 partition
                  3 LVM physical volume whole disks
                  1 LVM physical volume

    - Để tăng kích thước cho Volume Group, ta sẽ thực hiện thêm phân vùng này (/dev/sde) vào trong Volume Group LVMVolGroup. Bằng việc sử dụng câu lệnh:

            vgextend /dev/LVMVolGroup /dev/sde

        kết quả hiển thị tương tự như sau:

              Physical volume "/dev/sde" successfully created.
              Volume group "LVMVolGroup" successfully extended

        Vậy là với câu lệnh trên, ta có thể tăng dung lượng cho Volume Group để có thể tùy chỉnh dung lượng cho các phân vùng Logical Volume hoặc tạo mới một Logical Volume trong LVMVolGroup. Kết quả là:

                # vgs
              VG          #PV #LV #SN Attr   VSize  VFree
              LVMVolGroup   4   2   0 wz--n-  3.98g 1.08g
              cl            1   2   0 wz--n- 19.00g    0

    
    - Để giảm kích thước của một Volume Group, ta sẽ thực hiện việc loại bỏ một disk thành viên trong Volume Group. Bằng việc sử dụng câu lệnh:

            vgreduce /dev/LVMVolGroup /dev/sde

        kết quả sẽ hiển thị tương tự như sau:
        
              Removed "/dev/sde" from volume group "LVMVolGroup"

        và khi ta kiểm tra dung lượng của Volume Group, ta sẽ thấy:


                # vgs
              VG          #PV #LV #SN Attr   VSize  VFree
              LVMVolGroup   3   2   0 wz--n-  2.99g 88.00m
              cl            1   2   0 wz--n- 19.00g     0



- ### <a name="resize">2.2 Thay đổi kích thước của Logical Volume</a>

  - Nếu như muốn tăng kích thước của một Logical Volume nào đó. Đầu tiên, ta cần phải có dung lượng trống trong Volume Group mà Logical Volume đó đang là thành viên. Mình có các thông số về Volume Group như sau:
        
        # vgs
        VG          #PV #LV #SN Attr   VSize  VFree
        LVMVolGroup   4   2   0 wz--n-  3.98g 1.00g
        cl            1   2   0 wz--n- 19.00g    0

    qua trên, ta thấy LVMVolGroup là Volume Group đang có dung lượng trống và:

        # lvs
        LV      VG          Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
        Private LVMVolGroup -wi-ao---- 1008.00m
        Public  LVMVolGroup -wi-ao----    2.00g
        root    cl          -wi-ao----   17.00g
        swap    cl          -wi-ao----    2.00g

    vì một lý do nào đó, mà mình cần tăng kích thước của Logical Volume: Private. Mình sẽ cần phải thực hiện như sau:

      + Bước 1. Kiểm tra dung lượng tối đa mà có thể dùng để tăng kích thước.
      + Bước 2. Thực hiện thêm dung lượng cho Logical Volume
      + Bước 3. Thực hiện thay đổi kích thước.

    cụ thể như sau:

      - Bước 1. Kiểm tra dung lượng tối đa mà có thể dùng để tăng kích thước.

            # vgdisplay LVMVolGroup

        kết quả sẽ hiển thị tương tự như sau:

            --- Volume group ---
            VG Name               LVMVolGroup
            System ID
            Format                lvm2
            Metadata Areas        4
            Metadata Sequence No  6
            VG Access             read/write
            VG Status             resizable
            MAX LV                0
            Cur LV                2
            Open LV               2
            Max PV                0
            Cur PV                4
            Act PV                4
            VG Size               3.98 GiB
            PE Size               4.00 MiB
            Total PE              1020
            Alloc PE / Size       764 / 2.98 GiB
            Free  PE / Size       256 / 1.00 GiB
            VG UUID               kWmQcD-7XV8-GBE8-AnBc-fTbc-pC3m-coxrBl

        hãy để ý vào `Free  PE / Size       256 / 1.00 GiB`, ta thấy giá trị có thể được thêm vào là `256 PE` hay `1.00 GiB`. Đây chính là giá trị mà ta có thể sử dụng để thêm vào cho Logical Volume cần mở rộng.

      - Bước 2. Thực hiện thêm dung lượng cho Logical Volume. Ta là như sau:

            lvextend -l +256 /dev/LVMVolGroup/Private

          - trong đó /dev/LVMVolGroup/Private là Logical cần tăng kích thước.

        kết quả nhận được sẽ tương tự như sau:

            Size of logical volume LVMVolGroup/Private changed from 1008.00 MiB (252 extents) to 1.98 GiB (508 extents).
            Logical volume LVMVolGroup/Private successfully resized.

      - Bước 3. Thực hiện thay đổi kích thước (Logical Volume phải đang được mount). Ta làm như sau:

            resize2fs /dev/LVMVolGroup/Private

        sẽ nhận được kết quả như sau:

            resize2fs 1.42.9 (28-Dec-2013)
            Filesystem at /dev/LVMVolGroup/Private is mounted on /mnt/Private; on-line resizing required
            old_desc_blocks = 1, new_desc_blocks = 1
            The filesystem on /dev/LVMVolGroup/Private is now 520192 blocks long.


  - Để giảm kích thước của một Logical Volume, ta cần làm như sau:

    + Bước 1. Unmount Logical Volume
    + Bước 2. Kiểm tra lại file system
    + Bước 3. Giảm kích thước
    + Bước 4. Thực hiện thay đổi.

  các bước làm như sau. (Các bước làm sẽ áp dụng cho Logical Volume: /dev/LVMVolGroup/Private)

    + Bước 1. Unmount Logical Volume

          umount -v /mnt/Private

    + Bước 2. Kiểm tra lại file system

          e2fsck -ff /dev/LVMVolGroup/Private

      kết quả hiển thị tương tự như sau:

          e2fsck 1.42.9 (28-Dec-2013)
          Pass 1: Checking inodes, blocks, and sizes
          Pass 2: Checking directory structure
          Pass 3: Checking directory connectivity
          Pass 4: Checking reference counts
          Pass 5: Checking group summary information
          /dev/LVMVolGroup/Private: 13/118272 files (0.0% non-contiguous), 12229/520192 blocks

    + Bước 3. Giảm kích thước.

          lvreduce -L -1G /dev/LVMVolGroup/Private

      kết quả:

          WARNING: Reducing active logical volume to 1008.00 MiB.
            THIS MAY DESTROY YOUR DATA (filesystem etc.)
          Do you really want to reduce LVMVolGroup/Private? [y/n]: y
            Size of logical volume LVMVolGroup/Private changed from 1.98 GiB (508 extents) to 1008.00 MiB (252 extents).
            Logical volume LVMVolGroup/Private successfully resized.

    + Bước 4. Thực hiện thay đổi với câu lệnh:

          resize2fs /dev/LVMVolGroup/Private 1G
    
      kết quả sẽ nhận được là:

          resize2fs 1.42.9 (28-Dec-2013)
          Resizing the filesystem on /dev/LVMVolGroup/Private to 262144 (4k) blocks.
          The filesystem on /dev/LVMVolGroup/Private is now 262144 blocks long.

      Vậy là ta đã giảm kích thước của một Logical Volume thành công.


- ### <a name="delete">2.3 Xóa các Volume</a>

    - Để xóa một Logical Volume, trước tiên ta cần phải unmount chúng nếu như chúng đang mount vào hệ điều hành với câu lệnh:

            umount /dev/LVMVolGroup/Public
            umount /dev/LVMVolGroup/Private

        sau đó, ta tiến hành xóa Logical Volume với câu lệnh:

            lvremove /dev/LVMVolGroup/Public
            lvremove /dev/LVMVolGroup/Private

        Hai câu lệnh trên sẽ xóa đi 2 Logical Volume là Public và Private. Bạn sẽ nhận được câu hỏi hỏi xác nhận trước khi nó thực sự được xóa. Nhập `y` để chấp nhận. Sau đó hãy kiểm tra lại với câu lệnh:

            vgs

        kết quả sẽ hiển thị tương tự như sau:

                VG          #PV #LV #SN Attr   VSize  VFree
                LVMVolGroup   3   0   0 wz--n-  2.99g 2.99g
                cl            1   2   0 wz--n- 19.00g    0



    - Để xóa một Volume Group, trước tiên, ta cần phải thực hiện xóa các Logical Volume mà nó quản lý. Sau đó thực hiện câu lệnh:

            vgremove /dev/LVMVolGroup

        câu lệnh trên sẽ xóa đi Volume Group có tên là `LVMVolGroup`. Kết quả của câu lệnh sẽ được hiển thị như sau:

              Volume group "LVMVolGroup" successfully removed

        Để kiểm tra kết quả, ta sử dụng câu lệnh:

            vgs

        và thấy:
            
              VG #PV #LV #SN Attr   VSize  VFree
              cl   1   2   0 wz--n- 19.00g    0

        như vậy là ta đã xóa thành công.

    - Để xóa đi một Physical Volume, ta cần phải xóa đi Volume Group mà nó chứa trong đó. Sau đó, ta sử dụng câu lệnh sau:

            pvremove /dev/sdb
            pvremove /dev/sdc
            pvremove /dev/sdd
            pvremove /dev/sde

        kết quả sẽ lần lượt tương tự như sau:
        
             Labels on physical volume "/dev/sdb" successfully wiped.
             Labels on physical volume "/dev/sdc" successfully wiped.
             Labels on physical volume "/dev/sdd" successfully wiped.
             Labels on physical volume "/dev/sde" successfully wiped.

        Ta có thể kiểm tra kết quả với câu lệnh:

            lvmdiskscan

        kết quả sẽ tương tự như sau:

              /dev/cl/root [      17.00 GiB]
              /dev/sda1    [       1.00 GiB]
              /dev/cl/swap [       2.00 GiB]
              /dev/sda2    [      19.00 GiB] LVM physical volume
              /dev/sdb     [       1.00 GiB]
              /dev/sdc     [       1.00 GiB]
              /dev/sdd     [       1.00 GiB]
              /dev/sde     [       1.00 GiB]
              6 disks
              1 partition
              0 LVM physical volume whole disks
              1 LVM physical volume

____

# <a name="content-others">Các nội dung khác</a>
