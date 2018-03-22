# Heat command line

# MỤC LỤC


# 1.OpenStack command line
\- Tham khảo:  
https://docs.openstack.org/python-heatclient/latest/cli/index.html

## 1.1.Stack
\- Tạo stack  
```
stack create  -t <template> <stack-name>
```

\- Xóa stack  
```
stack delete [--wait] <stack> [<stack> ...]
```

- --wait : Chờ cho quá trình xóa stack hoàn thành
- stack : Tên hoặc id của stack bị xóa 

\- Liệt kê danh sách stack  
```
stack list
```

\- Show chi tiết về stack  
```
stack show <stack>
```

\- Liệt kê ouput của stack  
```
stack output list [-f {csv,json,table,value,yaml}] <stack>
```

\- Show output của stack  
```
stack output show <stack>
```

\- Liệt kê resource của stack  
```
stack resource list <stack>
```

\- Hiển thị resource của stack  
```
stack resource show <stack> <resource>
```

\- Show template của stack  
```
stack template show <stack>
```

# 2.Heat command client
## 2.1.Stack
\- Tạo stack  
```
heat stack-create [-f <FILE>] [-u <URL>] <STACK_NAME>
```

- -f <FILE>, --template-file <FILE> : đường dẫn cảu template
- -u <URL>, --template-url <URL> : URL của template.

\- Xóa stack
```
heat stack-delete <NAME or ID> [<NAME or ID> ...]
```

\- Liệt kê danh sách stack  
```
heat stack-list
```

\- Show chi tiết về stack  
```
heat stack-show [--no-resolve-outputs] <NAME or ID>
```

- --no-resolve-outputs : Do not resolve outputs of the stack.

\- Liệt kê ouput của stack  
```
heat output-list <NAME or ID>
```

\- Show output của stack  
```
heat output-show [-F <FORMAT>] <NAME or ID>
```

- -F <FORMAT>, --format <FORMAT> : giá trị output format là json hoặc raw.

\- Liệt kê resource của stack  
```
heat resource-list <NAME or ID>
```

\- Hiển thị resource của stack  
```
heat resource-show <NAME or ID> <RESOURCE>
```

\- Show template của stack  
```
heat template-show <NAME or ID>
```




