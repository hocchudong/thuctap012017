# nova-scheduler

# Mục lục
- [1.Filter Scheduler](#1)
    - [1.1.Khái niệm](#1.1)
    - [1.2.Filtering](#1.2)
    - [1.3.Weights](#1.3)
- [2.Compute scheduler](#2)
	- [2.1.Cấu hình filtering](#2.1)
	- [2.2.Cấu hình weighting](#2.2)


<a name="1"></a>
# 1.Filter Scheduler
<a name="1.1"></a>
## 1.1.Khái niệm
\- **Filter Scheduler** hỗ trợ *filtering* và *weighting* để quyết định instance mới được tạo trên node Compute nào. Scheduler chỉ hỗ trợ nodes Compute.  

<a name="1.2"></a>
## 1.2.Filtering
<img src="images/nova-scheduler1.png" />

\- Trong quá trính làm việc, Filter Scheduler lặp đi lặp lại trên nodes Compute được tìm thấy, đánh giá lại đói với mỗi thiết lập của filters. Dánh sách kết quả các hosts được sắp xếp bởi weighers. Scheduler sau đó chọn hosts có weighted cao nhất cho instance..  
\- Nếu Scheduler không thể tìm thấy host phù hợp cho instance, nó có nghĩa là không có hosts thích hợp cho việc tạo instance.  
\- Filter Scheduler khá linh hoạt để hỗ trợ nhiều loại yêu cầu filtering và weighting. Nếu filter mặc định của OpenStack chưa đủ linh hoạt, bạn có thể sử dụng thuật toán filtering của bạn.  
\- Có nhiều class filter chuẩn mà được sử dụng (`nova.scheduler.filters`):  
- `AllHostsFilter`: không filtering. Nó duyệt tất cả các hosts có sẵn.  
- `ImagePropertiesFilter`: filters hosts dựa trên thuộc tính được định nghĩa trên image của instance. Nó duyệt các hosts mà có thể hỗ trợ thuộc tính đặc biệt của image được sử dụng bởi instance.  
- `AvailabilityZoneFilter`: filters hosts bởi availability zone. Nó duyệt các hosts phù hợp với availability zone được chỉ định trong thuộc tính instance. Sử dụng dấy phẩy để chỉ định nhiều zones. Filter sẽ đảm bảo nó phù hợp với bất kì zone được chỉ định.  
- `ComputeCapabilitiesFilter`: kiểm tra tính năng được cung cấp bởi host compute service đáp ứng bát kì chi tiết kỹ thuật phụ liên quan đến loại của instanec. Nó duyệt các hosts mà có thể tạo loại instance chỉ định.  
- `AggregateInstanceExtraSpecsFilter` :
- `ComputeFilter` : duyệt tất cả các host hoạt động và được kích hoạt.
- `CoreFilter` : filters dựa trên CPU core sử dụng. Nó duyệt các hosts với số CPU cores đủ.
- `AggregateCoreFilter` : filter hosts dựa trên số CPU core với mỗi aggregate `cpu_allocation_ratio` được thiết lập.
- `IsolatedHostsFilter`: filter dựa trên cờ `image_isolated`, `host_isolated` và `restrict_isolated_hosts_to_isolated_images`.
- `JsonFilter`: cho phép ngữ pháp dựa trên JSON đơn giản cho việc chọn hosts.
- `RamFilter`: filter hosts bởi RAM. Chỉ hosts có RAM đủ được duyệt.
- `AggregateRamFilter`: filter hosts bởi RAM với mỗi aggregate `ram_allocation_ratio` được thiết lập.
- `DiskFilter`: filters host bởi disk. Chỉ hosts có đủ không gian disk được duyệt. 
- `AggregateDiskFilter`: filters hosts bởi disk với mỗi aggregate `disk_allocation_ratio` được thiết lập.
- `NumInstancesFilter`: filters node computes bởi số instance đang chạy. Nodes có quá nhiều instances sẽ được filter, thiếp lập `max_instances_per_host` . Số instance max được cho phép chạy trên hosts. Host sẽ phớt lờ đi scheduer nếu nhiều hơn `max_instances_per_host` sẵn sàng trên hosts. 
- `AggregateNumInstancesFilter` :
- `IoOpsFilter` :
- `AggregateIoOpsFilter` :
- `PciPassthroughFilter` :
- `SimpleCIDRAffinityFilter` :
- `DifferentHostFilter`:
- `SameHostFilter`:
- `RetryFilter`: filter hosts đã được duyệt bởi scheduler. Bộ lọc này ngăn chặn scheduler lọc thử lại với các hosts không phù hợp với các bộ lọc trước.
- `TrustedFilter`:
- `TypeAffinityFilter`: 
- `AggregateTypeAffinityFilter` 
- `ServerGroupAntiAffinityFilter` 
- `ServerGroupAffinityFilter` 
- `AggregateMultiTenancyIsolation` 
- `AggregateImagePropertiesIsolation` 
- `MetricsFilter` 
- `NUMATopologyFilter`

<a name="1.3"></a>
## 1.3.Weights
\- Filter Scheduler sử udngj lời gọi đến weights để làm việc. Weigher là phương pháp để chọn host phù hợp nhất từ nhóm các host có hiệu lực.  
\- Để ưu tiên 1 weigher só với weigher khác, tất cả các weigher cần phải xác định multiplier sẽ được áp dụng trước khi tính toán weight cho node. Tất cả weights được chuẩn hóa trước khi multiplier có thể được áp dụng. Do đó, weight cuối dùng của object sẽ là :  
```
weight = w1_multiplier * norm(w1) + w2_multiplier * norm(w2) + ...
```

<img src="images/nova-scheduler2.png" />

<img src="images/nova-scheduler3.png" />

<a name="2"></a>
# 2.Compute scheduler
\- Compute sử dụng `nova-scheduler` service để xác định host chó việc tạo instance dự trên cơ chế filtering và weighting.  

<a name="2.2"></a>
## 2.1.Cấu hình filtering
\- Compute được cấu hình với tùy chọn scheduler mặc định trong file `/etc/nova/nova.conf` trên node Controller :  
```
scheduler_driver_task_period = 60
scheduler_driver = nova.scheduler.filter_scheduler.FilterScheduler
scheduler_available_filters = nova.scheduler.filters.all_filters
scheduler_default_filters = RetryFilter, AvailabilityZoneFilter, RamFilter, DiskFilter, ComputeFilter, ComputeCapabilitiesFilter, ImagePropertiesFilter, ServerGroupAntiAffinityFilter, ServerGroupAffinityFilter
```

Mặc định, `scheduler_driver` được cấu hình như filer scheduler. Trong cấu hình mặc định, scheduler cân nhắc hosts nào đáp ứng được các chỉ tiêu sau:  
- Đã được chấp nhận cho ý định scheduling (`RetryFilter`).
- Đã ở trong availability zone được yêu cầu (`AvailabilityZoneFilter`).
- Có đủ RAM yêu cầu (`RamFilter`).
- Có đủ không gian disk yêu cầu cho root và ephemeral storage (`DiskFilter`).
- Có dịch vị yêu cầu (`ComputeFilter`).
- Đáp ứng các thông số kỹ thuật liên quan đến loại instance (`ComputeCapabilitiesFilter`).
- Đáp ứng bất kỳ kiến trức, loại hypervior, hoặc thuộc tính chế độ virtual machine được chỉ định trên thuộc tính image của instance (`ImagePropertiesFilter`).
- Ở host khác với các instances khác trong group (nếu được yêu cầu) (`ServerGroupAntiAffinityFilter`).
- Có trong group hosts (nếu được yêu cầu) (`ServerGroupAffinityFilter`).

\- scheduler lưu trữ danh sách các hosts có sẵn, sử dụng tùy chọn `scheduler_driver_task_period` để chỉ định thời gian cập nhật danh sách các hosts.  
\- Tùy chọn cấu hình `scheduler_available_filters` trong file `nova.conf` cung cấp Compute service với danh sách filters đực sử dụng vởi scheduler. Thiết lập mặc định chỉ định tất cả filter mà có trong Compute service:  
```
scheduler_available_filters = nova.scheduler.filters.all_filters
```

\- Tùy chọn cấu hình này có thể được chỉ định multiple time. Ví dụ, nếu bạn triển khai filter của bạn trong lời gọi Python `myfilter.MyFilter` và bạn muốn được sử dụng cả 2 filter (bao gồm filter mặc định và filter do bạn xây dựng ), file `nova.conf` của bạn sẽ chứa:  
```
scheduler_available_filters = nova.scheduler.filters.all_filters
scheduler_available_filters = myfilter.MyFilter
```

\- Tùy chọn cấu hình `scheduler_default_filters` trong file `nova.conf` xác định danh sách các filters mà được áp dụng bởi `nova-scheduler` service. Filter mặc định là :  
```
scheduler_default_filters = RetryFilter, AvailabilityZoneFilter, RamFilter, ComputeFilter, ComputeCapabilitiesFilter, ImagePropertiesFilter, ServerGroupAntiAffinityFilter, ServerGroupAffinityFilter
```

<a name="2.2"></a>
## 2.2.Cấu hình weighting
\- Nếu cells được sử dụng, cells được weighted bởi scheduler tương tự như các hosts.  
\- Hosts và cells được weighted dựa trên tùy chọn trong file /etc/nova/nova.conf :  

VD:  
```
[DEFAULT]
scheduler_host_subset_size = 1
scheduler_weight_classes = nova.scheduler.weights.all_weighers
ram_weight_multiplier = 1.0
io_ops_weight_multiplier = 2.0
soft_affinity_weight_multiplier = 1.0
soft_anti_affinity_weight_multiplier = 1.0
[metrics]
weight_multiplier = 1.0
weight_setting = name1=1.0, name2=-1.0
required = false
weight_of_unavailable = -10000.0
```













