# 2. Cách thay đổi dung lượng sử dụng LVM cho Volume Group

____

# Mục lục


- [2.1 Thay đổi dung lượng cho Volume Group](#change)
- [2.2 Xóa Volume](#delete)
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


- ### <a name="delete">2.2 Xóa các Volume</a>

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
