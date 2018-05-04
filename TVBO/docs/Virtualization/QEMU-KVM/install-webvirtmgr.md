# 6. Cài đặt công cụ quản lý KVM - webvirtmgr.

____

# Mục lục


- [6.1 Cài đặt các phần mềm cần thiết](#important)
    - [6.1.1 CentOS 7](#centos)
    - [6.1.2 Ubuntu 16.10](#ubuntu)
- [6.2 Cài đặt môi trường Django](#django)
- [6.3 Cài đặt webvirtmgr](#setup)
- [6.4 Cấu hình Web Server NGINX](#nginx)
- [6.5 Khởi chạy công cụ webvirtmgr](#run)
    - [6.5.1 CentOS 7](#runcentos)
    - [6.5.2 Ubuntu 16.10](#runubuntu)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="important">6.1 Cài đặt các phần mềm cần thiết</a>
    - #### <a name="centos">6.1.1 CentOS 7</a>

        - Đầu tiên, ta cần enable EPEL-Repo với câu lệnh sau:

                yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm

        - Tiếp theo, ta sẽ cài đặt các công cụ cần thiết với câu lệnh:

                yum -y install git python-pip libvirt-python \
                       libxml2-python python-websockify supervisor \
                       nginx gcc python-devel

        - Cuối cùng, cài đặt module python tên là numpy cần thiết cho mã nguồn của công cụ:

                pip install numpy

    - #### <a name="ubuntu">6.1.2 Ubuntu 16.10</a>

        - Để cài đặt các công cụ cần thiết trên Ubuntu, ta sử dụng câu lệnh:

                apt-get install -y git python-pip python-libvirt \
                python-libxml2 novnc supervisor \
                nginx gcc python-devel
        - Cuối cùng, cài đặt module python tên là numpy cần thiết cho mã nguồn của công cụ:

                pip install numpy


- ### <a name="django">6.2 Cài đặt môi trường Django</a>

    - Để tiến hành cài đặt môi trường, ta sử dụng các câu lệnh sau:


            pip install django==1.5.5
            pip install gunicorn==18.0
            pip install lockfile>=0.9

- ### <a name="setup">6.3 Cài đặt webvirtmgr</a>

    - Để cài đặt webvirtmgr, ta sử dụng câu lệnh sau để download source code về:

            cd /var/www/
            git clone git://github.com/retspen/webvirtmgr.git
            cd webvirtmgr
            ./manage.py syncdb

        nhập các thông tin cho người dùng bao gồm tên, mật khẩu. Ví dụ:

            You just installed Django's auth system, which means you don't have any superusers defined.
            Would you like to create one now? (yes/no): yes
            Username (leave blank to use 'root'): reministry
            Email address: tranbo9x@yahoo.com
            Password:
            Password (again):
            Superuser created successfully.
            Installing custom SQL ...
            Installing indexes ...
            Installed 6 object(s) from 1 fixture(s)
        
        sau đó nhập lệnh sau để copy các file source code:

            ./manage.py collectstatic

        kết quả sẽ hiển thị tương tự như sau:

            Type 'yes' to continue, or 'no' to cancel:

        nhập `yes` và nhấn `Enter`

    - Cuối cùng, ta cần tạo ra một người dùng superuser với câu lệnh:

             ./manage.py createsuperuser

        nhập các thông tin tương ứng tương tự như khi ta tạo ra người dùng thông thường ở phía trên.


- ### <a name="nginx">6.4 Cấu hình Web Server NGINX</a>

    - Để cấu hình cho NGINX cho phép công cụ webvirtmgr hoạt động, ta sử dụng câu lệnh sau:

            vi /etc/nginx/conf.d/webvirtmgr.conf

        thêm nội dung dưới đây vào file và lưu lại:

            server {
                listen 80 default_server;

                server_name $hostname;
                #access_log /var/log/nginx/webvirtmgr_access_log; 

                location /static/ {
                    root /var/www/webvirtmgr/webvirtmgr; # or /srv instead of /var
                    expires max;
                }

                location / {
                    proxy_pass http://127.0.0.1:8000;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-for $proxy_add_x_forwarded_for;
                    proxy_set_header Host $host:$server_port;
                    proxy_set_header X-Forwarded-Proto $scheme;
                    proxy_connect_timeout 600;
                    proxy_read_timeout 600;
                    proxy_send_timeout 600;
                    client_max_body_size 1024M; # Set higher depending on your needs 
                }
            }

        tiếp theo ẩn các dòng cấu hình mặc định của NGINX bằng cách comment các làm như sau:

            cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.def
            vi /etc/nginx/nginx.conf

        thêm nội dung dưới đây vào file và sau đó lưu lại:

            user nginx;
            worker_processes auto;
            error_log /var/log/nginx/error.log;
            pid /run/nginx.pid;
            include /usr/share/nginx/modules/*.conf;
            events {
                worker_connections 1024;
            }
            http {
                log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                                  '$status $body_bytes_sent "$http_referer" '
                                  '"$http_user_agent" "$http_x_forwarded_for"';
                access_log  /var/log/nginx/access.log  main;
                sendfile            on;
                tcp_nopush          on;
                tcp_nodelay         on;
                keepalive_timeout   65;
                types_hash_max_size 2048;
                include             /etc/nginx/mime.types;
                default_type        application/octet-stream;
                include /etc/nginx/conf.d/*.conf;
            }

    - Cuối cùng, ta cần khởi động lại NGINX và cho phép nó khởi động cùng với hệ thống:

            systemctl restart nginx
            systemctl enable nginx


- ### <a name="run">6.5 Khởi chạy công cụ webvirtmgr</a>
    - #### <a name="runcentos">6.5.1 CentOS 7</a>

        - Đầu tiên, ta cần cấu hình cài đặt cho supervisor bằng cách thực hiện chạy câu lệnh sau:

                vi /etc/supervisord.d/webvirtmgr.ini

            thêm nội dung sau đây vào file và sau đó lưu lại:

                [program:webvirtmgr]
                command=/usr/bin/python /var/www/webvirtmgr/manage.py run_gunicorn -c /var/www/webvirtmgr/conf/gunicorn.conf.py
                directory=/var/www/webvirtmgr
                autostart=true
                autorestart=true
                logfile=/var/log/supervisor/webvirtmgr.log
                log_stderr=true
                user=nginx

                [program:webvirtmgr-console]
                command=/usr/bin/python /var/www/webvirtmgr/console/webvirtmgr-console
                directory=/var/www/webvirtmgr
                autostart=true
                autorestart=true
                stdout_logfile=/var/log/supervisor/webvirtmgr-console.log
                redirect_stderr=true
                user=nginx

            restart lại dịch vụ:

                systemctl restart supervisord
                systemctl enable supervisord

            hoặc:

                systemctl start supervisord
                systemctl enable supervisord

        - Cấp quyền truy cập file data cho `nginx` với câu lệnh:

                chown -R nginx:nginx /var/www/webvirtmgr

        - Cấp quyền truy cập port:

                firewall-cmd --add-port=8000/tcp --permanent

        - Để khởi chạy webvirtmgr ta sử dụng câu lệnh:

                ./manage.py runserver 0:8000

            trong đó: 
                - `0` có thể là một địa chỉ IP mà bạn muốn. Ở đây để 0 với mục đích cho phép có thể truy cập qua tất cả các interface network.
                - `8000`: Khai báo port

        - Để truy cập và quản lý công cụ, trên trình duyệt, ta truy cập tới đường dẫn:

                http://ip_server:8000

            trong đó: `ip_server` là địa chỉ IP của máy cài webvirtmgr

    - #### <a name="runubuntu">6.5.2 Ubuntu 16.10</a>

        - Đầu tiên, ta cần cấp quyền truy cập file data cho `nginx` với câu lệnh:

                chown -R www-data:www-data /var/www/webvirtmgr

        - Cấu hình cài đặt cho supervisor:

                vi /etc/supervisor/conf.d

            thêm nội dung sau vào file và lưu lại:

                [program:webvirtmgr]
                command=/usr/bin/python /var/www/webvirtmgr/manage.py run_gunicorn -c /var/www/webvirtmgr/conf/gunicorn.conf.py
                directory=/var/www/webvirtmgr
                autostart=true
                autorestart=true
                stdout_logfile=/var/log/supervisor/webvirtmgr.log
                redirect_stderr=true
                user=www-data

                [program:webvirtmgr-console]
                command=/usr/bin/python /var/www/webvirtmgr/console/webvirtmgr-console
                directory=/var/www/webvirtmgr
                autostart=true
                autorestart=true
                stdout_logfile=/var/log/supervisor/webvirtmgr-console.log
                redirect_stderr=true
                user=www-data

            restart lại dịch vụ:

                service supervisor stop
                service supervisor start
                service supervisor enabled

        - Để khởi chạy webvirtmgr ta sử dụng câu lệnh:

                ./manage.py runserver 0:8000

            trong đó: 
                - `0` có thể là một địa chỉ IP mà bạn muốn. Ở đây để 0 với mục đích cho phép có thể truy cập qua tất cả các interface network.
                - `8000`: Khai báo port

        - Để truy cập và quản lý công cụ, trên trình duyệt, ta truy cập tới đường dẫn:

                http://ip_server:8000

            trong đó: `ip_server` là địa chỉ IP của máy cài webvirtmgr
____



# <a name="content-others">Các nội dung khác</a>
