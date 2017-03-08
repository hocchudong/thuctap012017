# TCPDUMP

# MỤC LỤC
- [1.Giới thiệu](#1)
  - [1.1.libpcap](1,1)
  - [1.2.tcpdump](#1.2)
- [2.Install](#2)
- [3.Một số lệnh cơ bản của tcpdump](#3)
- [THAM KHẢO](#thamkhao)




<a name="1"></a>
# 1.Giới thiệu

<a name="1.1"></a>
## 1.1.libpcap 
\- libpcap ( Packet Capture libbrary ) provides level interface to packet captrure systems .   
\- Tham khảo :  
http://www.tcpdump.org/manpages/pcap.3pcap.html   
http://eecs.wsu.edu/~sshaikot/docs/lbpcap/libpcap-tutorial.pdf  

<a name="1.2"></a>
## 1.2.tcpdump
\- tcpdump , a powerful command-line packet analyzer , and libpcap , a portable C/C++ library for netowrk traffic capture .  
\- tcpdump show mô tả về nội dung của packets on a network interface .  
\- tcpdump có sẵn ở hầu hết các hệ điều hành Unix/Linux .  
\- Một số tính năng của tcpdump :  
- Bắt các gói tin và phân tích , có thể lưu với format PCAP ( có thể đọc được bởi Wireshark )
- Tạo được Filter để bắt các bản tin cẩn thiết .   
VD : http , ftp , ssh , …  

<a name="2"></a>
# 2.Install
\- Chúng ta có thể cài đặt từ source code hoặc dùng công cụ cài đặt của các các distro Linux để cài .  
\- Ở đây mình cài tcpdump trên Ubuntu Server 14.04 :  
```sh
sudo apt-get install tcpdump
```

<a name="3"></a>
# 3.Một số lệnh cơ bản của tcpdump

## 3.1.Capture packets từ một ethernet interface sử dụng tcpdump -i
\- Khi thực thi tcpdump command without any option , nó sẽ capture tất cả packets flowing through tất cả interface . -i option với tcpdump command , cho phép filter trên một ethernet interface .  
\- Ví dụ : capture packet on the eth0  
```
tcpdump –i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/1.jpg" >  

## 3.2.Capture only N number of packets using tcpdump –c
\- Khi bản thực thi câu tcpdump command , nó sẽ capture packets cho đến khi bản hủy bỏ tcpdump coomand . Sử dụng -c option bạn có thể chỉ định number of packets để capture .  
```
tcpdump –c 2 –i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/2.jpg" >  

## 3.3.Display Captured Packets in ASCII using tcpdump –A
\- Show ra packets được capture trong hệ ASCII .  
```
tcpdump -A -c 2 -i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/3.jpg" >  

## 3.4.Display Captured Pakcets in HEX and ASCII using tcpdump -XX
```
tcpdump -XX -c 2 -i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/4.jpg" >

## 3.5. Capture the packets and write into a file using tcpdump –w
\- tcpdump cho phép bạn save packets vào file , và sau dó bạn có thể sử dụng packet file để analysis .  
```sh
tcpdump –w test.pcap –i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/5(1).jpg" >  

\- đuôi file nên để `.pcap` và file này có thể đọc bởi bất kỳ network protocol analyzer nào .  
\- Mở file `test.pcap` với Wireshark .  

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/5(2).jpg" >  

## 3.6. Reading the packets from a saved file using tcpdump –r
```sh
tcpdump –r test.pcap
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/6.jpg" >  

## 3.7. Capture packets with IP address using tcpdump -n
\- Ví dụ :  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/7(1).jpg" >  

Trong ví dụ trên , ta thấy in ra packets với địa chỉ DNS address , nhưng không in ra IP address . Để capture packets và display IP address , ta sử dụng `-n` option .  
```
tcpdump –n –i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/7(2).jpg" >  

## 3.8. Capture packets with proper readable timestamp using tcpdump -tttt
\- Show thêm thông tin về yyyy-mm-dd  
```
tcpdump –n –tttt –i eth0
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/8.jpg" >

## 3.9. Read packets longer than N bytes
\- Chỉ receive các packets có độ dài lớn hơn N bytes sử dụng filter “greater” through tcpdump command .  
```
tcpdump -w test.pcap greater 100
```

## 10.Receive only the packets of a specific protocol type 
\- Bạn có thể receive packets based on the protocol type . Bạn có thể chỉ định protocols như `wlan` ,`ip`,`ip6`,`arp`,`rarp`,`decnet`,`tcp` và `udp`.  
```
tcpdump –i eth0 arp
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/10.jpg" >  

## 3.11. Read packets lesser than N bytes
\- Chỉ nhận receive packets nhỏ hơn N bytes sử dụng fliter “less” trough tcpdump command  
```
tcpdump –w test.pcap less 1024
```  

## 3.12. Receive packets flows on a particular port using tcpdump port
\- Nếu bạn muốn biết all the packets received tren một port cụ thể , ta sử dụng tcpdump command như sau :  
```sh
tcpdump –i eth0 port 22
```

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/12.jpg" >  

## 3.13. Capture packets for particular destination IP and Port
\- Packets sẽ có source và destination IP và port numbers .  
```
tcpdump -i eth0 dst 172.16.69.176 and port 22
```  

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/13.jpg" >  

## 3.14.Capture packets for particular source IP
```
tcpdump -i eth0 src 172.16.69.2
```  
<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/14.jpg" >  

## 3.15. tcpdump Filter Packets – Capture all the packets other than arp and rarp
\- Trong tcpdump command , bạn có thể sử dụng điều kiện “and” , “or” và “not” để fliter packets .  
```
tcpdump -i eth0 not arp and not rarp
```  

<img src="https://github.com/doxuanson/thuctap012017/blob/master/XuanSon/Pictures/Tool%20packet%20analyzer/tcpdump/15.jpg" >  


<a name="thamkhao"></a>
# THAM KHẢO
http://www.tcpdump.org/  
http://www.tcpdump.org/manpages/tcpdump.1.html       
http://www.thegeekstuff.com/2010/08/tcpdump-command-examples  


























