# Command iptables


# MỤC LỤC


# 1.Cú pháp
```
iptables [-t table] command [chain] [match] [target/jump]
```

\- Thứ tự các tham số có thể thay đổi nhưng cú pháp trên là dễ hiểu nhất.  
\- Nếu không chỉ định `table`, mặc định sẽ là table filter.  
\- `command` sẽ chỉ định chương trình phải làm gì.  
VD: Insert rule hoặc thêm rule đến cuối của chains.  
\- `chain` phải phù hợp với `table` được chỉ định.  
\- `match` là phần của rule mà chúng ta gửi cho kernel để biết chi tiết cụ thể của gói tin, điều gì làm cho nó khác với các gói tin khác.  
VD: địa chỉ IP, port, giao thức hoặc bất cứ điều gì.  
\- Cuối cùng là `target` của gói tin. Nếu phù hợp với match, chúng tôi sẽ vói với kernel phải làm những gì với gói tin này.






















