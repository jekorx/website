# FTP服务器（Linux环境下）

> 以Centos 7.4 为例 

#### 安装

```bash
# 查询是否安装vsftpd
rpm -qa | grep vsftpd

# 安装
yum install -y vsftpd

# 创建ftp主目录
#mkdir /opt/www

# 创建ftp用户
useradd -d /opt/www -m ftpuser

# 设置新用户密码
passwd ftpuser

# 更改用户权限
usermod -s /sbin/nologin ftpuser # 限定用户ftpuser不能telnet，只能ftp
# usermod -s /sbin/bash ftpuser # 用户ftpuser恢复正常
# usermod -d /opt/www ftpuser # 更改用户ftpuser的主目录为/opt/www

# 文件授权给ftp用户
chown -R ftpuser /opt/www

# 进入vsftpd目录
cd /etc/vsftpd

# 创建chroot_list并写入ftp用户
echo 'ftpuser' > chroot_list

# 在user_list中加入ftp用户
vim /etc/vsftpd/user_list

# 修改配置文件
vim /etc/vsftpd/vsftpd.conf

anonymous_enable=NO # line.12 禁止匿名用户
chroot_local_user=YES # line.101
chroot_list_enable=NO # line.102 禁止chroot_list中用户切换目录
chroot_list_file=/etc/vsftpd/chroot_list # line.104 定义不能更改用户主目录的文件，该文件需自己创建，默认被注释
listen=YES # line.115 监听ipv4
listen_ipv6=NO # line.124 不监听ipv6
userlist_enable=YES # line.127 启用白名单
userlist_deny=NO # line.128 禁用黑名单
local_root=/opt/www # 新增，ftp根目录
pasv_max_port=5510 # 新增，被动端口
pasv_min_port=5500 # 新增，被动端口
allow_writeable_chroot=YES # 新增，支持chroot_list中的用户write权限

# 启动服务器
systemctl start vsftpd

# 开机自动启的
systemctl enable vsftpd
```

#### 相关问题

> 云服务器设置安全组后需要开放相关接口 

```bash
# 20 - 22
# 被动端口 5500 - 5510
```

> 331 Please specify the password. 

```bash
# 可能性较大的原因是密码强度太低，不影响登录
```

> 500 OOPS: cannot change directory:/opt/www/images 

```bash
# 原因，文件权限导致
# 只设置了images目录的ftp的用户权限，需要设置www的用户权限

cd /opt

chown -R ftpuser www/

cd /opt/www

chown -R ftpuser images/

# 特殊情况！如果与ftpuser同一用户组用户test也需要访问/opt/www，需要给www文件夹设置权限

chmod 770 www
```

## SFTP服务器

```bash
# 创建用户组
groupadd sftp

# 创建用户，指定用户组，限定只能ftp登录
useradd -d /opt/www -g sftp -s /sbin/nologin sftpuser

# 设置密码
passwd sftpuser

# 修改ssh配置文件
vim /etc/ssh/sshd_config
# 注释掉
X11Forwarding yes # line.102
Subsystem sftp /usr/libexec/openssh/sftp-server # line.102
# 在sshd_config末尾添加
Subsystem sftp internal-sftp
Match Group sftp
    ChrootDirectory /opt/www/
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no

# 设置文件权限
# ChrootDirectory /opt/www 目录所有者必须为root，设置sftp用户组
# /opt/www 及 /opt/www/assets 目录权限不能超过755
chown -R root:sftp /opt/www
chmod -R 755 /opt/www
cd /opt/www
mkdir assets
chown -R sftpuser:sftp /opt/www/assets
chmod -R 755 /opt/www/assets

# 重启ssh服务
systemctl restart sshd
```

> 配合nginx相关配置，及允许跨域配置（主要是音视频）  

```bash
location ^~ /assets/ {
    root /opt/www/;
    autoindex on;
    expires 24h;
    add_header Access-Control-Allow-Origin '*';
    add_header 'Access-Control-Allow-Methods' 'PUT,POST,GET,DELETE,OPTIONS';
    add_header 'Access-Control-Allow-Headers' 'Content-Type,Content-Length,Authorization,Accept,X-Requested-With';
}
```

> 如果接口通过nginx代理，需要设置```client_max_body_size```，可在```http```、```server```或```location```中设置  

```bash
http{
    # 控制全局nginx所有请求报文大小
    client_max_body_size 10m;
    server{
        # 控制该server的所有请求报文大小
        client_max_body_size 10m;
        location a {
            # 控制满足该路由规则的请求报文大小
            client_max_body_size 10m;
        }
    }
}
```

> Springboot 相关配置  

```bash
# 设置servlet最大请求尺寸
spring.servlet.multipart.max-request-size = 10MB
# 设置servlet最大文件上传尺寸
spring.servlet.multipart.max-file-size = 10MB
```