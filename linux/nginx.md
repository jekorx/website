# Nginx（Linux环境下）

> 以Centos 7.4，Nginx 1.15.8为例

#### 安装

```
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
./configure --user=nginx --group=nginx --prefix=/home/nginx-1.15.8-01/ --with-http_v2_module --with-http_ssl_module --with-http_sub_module --with-http_stub_status_module --with-http_gzip_static_module --with-pcre
make && make install

# 6、创建nginx命令软链接到环境变量
ln -s /home/nginx-1.15.8-01/sbin/* /usr/local/sbin/
```



