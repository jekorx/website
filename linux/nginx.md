# Nginx（Linux环境下）

> 以Centos 7.4，Nginx 1.15.8为例

#### 安装

```bash
# 1、编译依赖
yum -y install gcc gcc-c++

# 2、nginx依赖
yum -y install zlib zlib-devel openssl openssl-devel pcre pcre-devel

# 3、下载 解压nginx-1.15.8.tar.gz
tar -xzvf nginx-1.15.8.tar.gz

# 4、创建nginx用户
useradd -s /bin/false -M nginx

# 5、编译
cd nginx-1.15.8
# 生成makefile，指定用户、组、安装路径、相关模块
./configure --user=nginx --group=nginx --prefix=/opt/nginx-1.15.8-01/ --with-http_v2_module --with-http_ssl_module --with-http_sub_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre

# 6、编译安装
make && make install

# 7、创建nginx命令软链接到环境变量
ln -s /opt/nginx-1.15.8-01/sbin/* /usr/local/sbin/

# 开机自动启动，/etc/rc.local中加入
vim /etc/rc.local

nginx
```

#### location相关

```bash
# location表达式类型
~  表示执行一个正则匹配，区分大小写
~* 表示执行一个正则匹配，不区分大小写
^~ 表示普通字符匹配。使用前缀匹配。如果匹配成功，则不再匹配其他location。
=  进行普通字符精确匹配。也就是完全匹配。
@  它定义一个命名的 location，使用在内部定向时，例如 error_page, try_files

# location优先级
(location =) > (location 完整路径) > (location ^~ 路径) > (location ~,~* 正则顺序) > (location 部分起始路径) > (/)
# 1、等号类型（=）的优先级最高。一旦匹配成功，则不再查找其他匹配项。
# 2、^~类型表达式。一旦匹配成功，则不再查找其他匹配项。
# 3、正则表达式类型（~ ~*）的优先级次之。如果有多个location的正则能匹配的话，则使用正则表达式最长的那个。
# 4、常规字符串匹配类型。按前缀匹配。
```

#### 配置SSL（https）

```bash
# 安装时--with-http_ssl_module，添加ssl模块
http {
    server {
        listen 443 ssl; # 此处加ssl参数，可以不用使用ssl on配置
        server_name www.xxx.com; # 域名
        #ssl on;
        ssl_certificate /opt/ssl/xxx.pem; # crt / pem 文件
        ssl_certificate_key /opt/ssl/xxx.key; # key
        ssl_session_timeout 5m;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
    server {
        listen 80;
        server_name xxx.com www.xxx.com;
        rewrite ^(.*) https://$host$1 permanent;
    }
}
```

#### 接口代理跨域

```bash
http {
    server {
        location /api/ {
            # host 修改为真实的域名和端口
            proxy_set_header Host $http_host;
            proxy_pass http://192.168.0.12:8080/api/;
        }
        # ^~ 表示以某前缀开头
        location ^~ /admin/ { 
            # host 修改为真实的域名和端口
            proxy_set_header Host $http_host; 
            proxy_pass http://admin;
        } 
    }
}
```

#### HTML5 History模式

> 解决URL无法匹配到静态资源的问题，如：非根目录刷新  
> 原理：rewrite到index.html中，然后交给路由在处理请求资源  

```bash
# 方法 1
http {
    server {
        location /path {
            root html;
            index index.html index.htm;
            if (!-e $request_filename) {
                rewrite ^/(.*) /path/index.html last;
                break;
            }
        }
    }
}

# 方法 2
http {
    server {
        location /path {
            root html;
            index index.html index.htm;
            try_files $uri $uri/ @router;
        }
        location @router {
            rewrite ^.*$ /path/index.html last;
        }
    }
}
```

#### 请求相关配置

> 可在```http```、```server```或```location```中设置，优先级```location > server > http```  

> ```client_max_body_size```：限制请求体的大小，若超过所设定的大小，返回413错误  
> ```client_header_timeout```：读取请求头的超时时间，若超过所设定的大小，返回408错误  
> ```client_body_timeout```：读取请求实体的超时时间，若超过所设定的大小，返回413错误  
> ```proxy_connect_timeout```：http请求无法立即被容器(tomcat, netty等)处理，被放在nginx的待处理池中等待被处理。此参数为等待的最长时间，默认为60秒，官方推荐最长不要超过75秒  
> ```proxy_read_timeout```：http请求被容器(tomcat, netty等)处理后，nginx会等待处理结果，也就是容器返回的response。此参数即为服务器响应时间，默认60秒  
> ```proxy_send_timeout```：http请求被服务器处理完后，把数据传返回给Nginx的用时，默认60秒  

```bash
http {
    server {
        location a {
            client_max_body_size 10m;
        }
    }
}
```

#### 跨域配置

> 可在```http```、```server```或```location```中设置，优先级```location > server > http```  
> ```add_header Access-Control-Allow-Methods 'PUT,POST,GET,DELETE,OPTIONS';```：指定允许跨域的方法，*代表所有  
> ```add_header Access-Control-Max-Age 3600;```：预检命令的缓存，如果不缓存每次会发送两次请求  
> ```add_header Access-Control-Allow-Credentials true;```：带cookie请求需要加上这个字段，并设置为true  
> ```add_header Access-Control-Allow-Origin $http_origin;```：表示允许这个域跨域调用（客户端发送请求的域名和端口），```$http_origin```动态获取请求客户端请求的域 不用&#42;的原因是带cookie的请求不支持&#42;号  
> ```add_header Access-Control-Allow-Headers $http_access_control_request_headers;```：表示请求头的字段 动态获取  
> ```if ($request_method = 'OPTIONS') { return 200; }```：检查请求的类型是不是预检命令

```bash
http {
    server {
        location a {
            add_header Access-Control-Allow-Methods 'PUT,POST,GET,DELETE,OPTIONS';
            add_header Access-Control-Max-Age 3600;
            add_header Access-Control-Allow-Credentials true;
            add_header Access-Control-Allow-Origin $http_origin;
            add_header Access-Control-Allow-Headers $http_access_control_request_headers;
            if ($request_method = 'OPTIONS') {
                return 200;
            }
        }
    }
}
```

#### 负载均衡

> tomcat 为例  
> 反向代理
> 负载均衡后获取客户端真实IP

```bash
html {
    # 添加tomcat列表，真实应用服务器都放在这
    upstream tomcat_pool  {
        # server tomcat地址:端口号 weight表示权值，权值越大，被分配的几率越大;
        server 192.168.0.223:8080 weight=4 max_fails=2 fail_timeout=30s;
        server 192.168.0.224:8080 weight=4 max_fails=2 fail_timeout=30s;
    }
    server {
        # 默认请求设置
        location / {
            # host 修改为真实的域名和端口
            proxy_set_header Host $http_host;
            proxy_pass http://tomcat_pool; # 转向tomcat处理
            proxy_cookie_domain domino_server nginx_server; # 解决反向代理后Cookie不一致的问题
        }
        # 带有基础路径请求设置
        location ^~ /api/ {
            # host 修改为真实的域名和端口
            proxy_set_header Host $http_host;
            # 客户端真实ip
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            # 客户端真实协议(http/https)
            proxy_set_header X-Forwarded-Proto $scheme;
            # 负载均衡upstream
            proxy_pass http://tomcat_pool/api/; # 转向tomcat处理
            proxy_cookie_domain domino_server nginx_server; # 解决反向代理后Cookie不一致的问题
        }
    }
}
```

> 负载均衡后获取客户端真实IP，java代码

```java
// 负载均衡后获取客户端真实IP地址
public String getClientIp(HttpServletRequest request) {
    String ip = request.getHeader("x-forwarded-for");
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getRemoteAddr();
    }
    if(ip.trim().contains(",")){
        // 为什么会有这一步，因为经过多层代理后会有多个代理，取第一个ip地址就可以了
        String [] ips = ip.split(",");
        ip = ips[0];
    }
    return ip;
}
```

#### gzip

```bash
http  {
    # gzip模块设置
    gzip on; # 开启gzip压缩输出
    gzip_min_length 1k; # 最小压缩文件大小
    gzip_buffers 4 16k; # 压缩缓冲区
    gzip_http_version 1.1; # 用了反向代理的话，末端通信是HTTP/1.0，默认是HTTP/1.1
    gzip_comp_level 2; # 压缩等级
    gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png; # 压缩类型
    gzip_vary off; # 跟Squid等缓存服务有关，on的话会在Header里增加"Vary: Accept-Encoding"
    gzip_disable "MSIE [1-6]\."; # ie6不压缩
}
```

#### 修改nginx.conf、html位置

```bash
# 修改nginx.conf位置
# 移动nginx.conf
mv /opt/nginx-1.15.8-01/conf/nginx.conf /opt/

# 创建软连接
ln -s /opt/nginx.conf /opt/nginx-1.15.8-01/conf/nginx.conf/


# 修改html位置
# 创建目录
mkdir /opt/nginx-app

# 修改配置文件
vim /opt/nginx.conf

# 顶部加入
user root;

html {
    server {
        location / {
            root /opt/nginx-app;
        }
    }
}

# 重启服务
nginx -s reload
```