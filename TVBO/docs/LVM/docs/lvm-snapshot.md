# 3. Tính năng Snapshot của LVM

____

# Mục lục


- [3.1 Snapshot là gì?](#about)
- [3.2 Cách tạo ra một snapshot](#create)
- [3.3 Cách sử dụng Snapshot](#)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="about">3.1 Snapshot là gì?</a>

    - Snapshot trong LVM là một tính năng hữu ích cho phép tạo ra các bản sao lưu dữ liệu của một Logical Volume nào đó.
    - Snapshot cung cấp cho ta một tính năng phục hồi dữ liệu của một Logical Volume trước thời điểm tạo ra nó.

- ### <a name="create">3.2 Cách tạo ra một snapshot</a>

    - Nội dung bài viết này tiếp tục sử dụng các tài nguyên sẵn có từ các phần trước. Theo đó ta có số liệu như sau:

        - 2 Logical Volume:

            - /dev/LVMVolGroup/Public     2GiB
            - /dev/LVMVolGroup/Private    1GiB

        - 1 Volume Group:

            LVMVolGroup     còn trống 1GiB

        - 4 Physical Volume:

            - dev/sdb, /dev/sdc, /dev/sdd, /dev/sde

        - Snapshot sẽ tạo cho Logical Volume /dev/LVMVolGroup/Private

    - Đầu tiên, ta cần kiểm tra dung lượng còn trống trong Volume Group:

            vgdisplay LVMVolGroup

        kết quả sẽ hiển thị tương tự như sau:

              --- Volume group ---
              VG Name               LVMVolGroup
              System ID
              Format                lvm2
              Metadata Areas        4
              Metadata Sequence No  4
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
              Alloc PE / Size       768 / 3.00 GiB
              Free  PE / Size       252 / 1008.00 MiB
              VG UUID               ctKE4d-azxn-wQ8C-BXOK-nBvi-3neH-3VG2L1

        để ý vào `Free  PE / Size       252 / 1008.00 MiB` ta biết được dung lượng còn trống, và ta sẽ sử dụng 1 phần của toàn bộ dung lượng này để tạo ra một snapshot cho `/dev/LVMVolGroup/Private` với câu lệnh sau:

            lvcreate -l 50 --snapshot -n Private_Snapshot /dev/LVMVolGroup/Private

            - Private_Snapshot là tên Logical Volume đóng vai trò Snapshot

        kết quả sẽ hiển thị tương tự như sau:

              Using default stripesize 64.00 KiB.
              Logical volume "Private_Snapshot" created.

    - Để kiểm tra kết quả đã tạo thành công hay chưa, ta có thể sử dụng câu lệnh `lvs` và nó sẽ hiển thị tương tự như sau:

          LV               VG          Attr       LSize    Pool Origin  Data%  Meta%  Move Log Cpy%Sync Convert
          Private          LVMVolGroup owi-aos---    1.00g
          Private_Snapshot LVMVolGroup swi-a-s---  200.00m      Private 0.00
          Public           LVMVolGroup -wi-ao----    2.00g
          root             cl          -wi-ao----   17.00g
          swap             cl          -wi-ao----    2.00g

    

    - Vì Snapshot cũng được coi là một Logical Volume, lên khi ta muốn xóa, thay đổi dung lượng một snapshot, ta có thể thực hiện nó như việc làm đối với một Logical Volume thông thường. Ví dụ:

        - Để thêm dung lượng cho Snapshot, ta chỉ cần thực hiện như sau:

                lvextend -L +1G /dev/LVMVolGroup/Private_Snapshot

        - Để xóa đi snapshot, ta chỉ cần thực hiện:

                lvremove /dev/LVMVolGroup/Private_Snapshot


- ### <a name="">3.3 Cách sử dụng Snapshot</a>

    - Để phục hồi một snapshot cho Logical Volume, ta cần phải unmount Logical Volume đó ra trước tiên và sử dụng snapshot. Cách thực hiện như sau:
            
            umount -v /dev/LVMVolGroup/Private
            lvconvert --merge /dev/LVMVolGroup/Private_Snapshot

        sau khi chạy câu lệnh trên thì snapshot Private_Snapshot sẽ bị xóa.

____

# <a name="content-others">Các nội dung khác</a>
