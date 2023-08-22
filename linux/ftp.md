# FTP服务器

> 以Centos 7.4 为例 

### 安装

```bash
# 查询是否安装vsftpd
rpm -qa | grep vsftpd

# 安装
yum install -y vsftpd

# 创建ftp主目录
#mkdir /opt/www/ftp

# 创建ftp用户
useradd -d /opt/www/ftp -m ftpuser

# 设置新用户密码
passwd ftpuser

# 更改用户权限
usermod -s /sbin/nologin ftpuser # 限定用户ftpuser不能telnet，只能ftp
# usermod -s /sbin/bash ftpuser # 用户ftpuser恢复正常
# usermod -d /opt/www/ftp ftpuser # 更改用户ftpuser的主目录为/opt/www/ftp

# 文件授权给ftp用户
chown -R ftpuser /opt/www/ftp

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
local_root=/opt/www/ftp # 新增，ftp根目录
pasv_max_port=5510 # 新增，被动端口
pasv_min_port=5500 # 新增，被动端口
allow_writeable_chroot=YES # 新增，支持chroot_list中的用户write权限

# 启动服务器
systemctl start vsftpd

# 开机自动启的
systemctl enable vsftpd
```

### 相关问题

> 云服务器设置安全组后需要开放相关接口 

```bash
# 20 - 22
# 被动端口 5500 - 5510
5500/5510
```

> 331 Please specify the password. 

```bash
# 可能性较大的原因是密码强度太低，不影响登录
```

> 500 OOPS: cannot change directory:/opt/www/ftp/images 

```bash
# 原因，文件权限导致
# 只设置了images目录的ftp的用户权限，需要设置www的用户权限

cd /opt

chown -R ftpuser www/ftp/

cd /opt/www/ftp

chown -R ftpuser images/

# 特殊情况！如果与ftpuser同一用户组用户test也需要访问/opt/www/ftp，需要给www/ftp文件夹设置权限  

chmod 770 www/ftp
```

> 530 Login incorrect.   

```bash
# 确认密码正确的情况下报530
vim /etc/pam.d/vsftpd

# 注释掉以下两行  

#%PAM-1.0
session    optional     pam_keyinit.so    force revoke
#auth       required    pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed
#auth       required    pam_shells.so
auth       include      password-auth
account    include      password-auth
session    required     pam_loginuid.so
session    include      password-auth

# 重启服务
systemctl restart vsftpd
```

> 服务器发回了不可路由的地址。使用服务器地址代替。  

```bash
# 更改Filezilla设置，编辑-设置-连接-FTP-被动模式，将“使用服务器的外部ip地址来代替”改为“回到主动模式”即可。
```

### SFTP服务器

```bash
# 创建用户组
groupadd sftp

# 创建用户，指定用户组，限定只能ftp登录
useradd -d /opt/www/sftp -g sftp -s /sbin/nologin sftpuser

# 设置密码
passwd sftpuser

# 修改ssh配置文件
vim /etc/ssh/sshd_config
# 注释掉以下两行
#X11Forwarding yes # line.98
#Subsystem sftp /usr/libexec/openssh/sftp-server # line.129
# 在sshd_config末尾添加
Subsystem sftp internal-sftp
Match Group sftp
    ChrootDirectory /opt/www/sftp/
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no

# 设置文件权限
# ChrootDirectory /opt/www/sftp 目录所有者必须为root，设置sftp用户组
# /opt/www/sftp 及 /opt/www/sftp/assets 目录权限不能超过755
chown -R root:sftp /opt/www/sftp
chmod -R 755 /opt/www/sftp
cd /opt/www/sftp
mkdir assets
chown -R sftpuser:sftp /opt/www/sftp/assets
chmod -R 755 /opt/www/sftp/assets

# 重启ssh服务
systemctl restart sshd
```

> 上传尺寸限制、静态资源访问跨域问题 [可参照](./nginx.md#请求相关配置)  
> Springboot 相关配置  

```bash
# 设置servlet最大请求尺寸
spring.servlet.multipart.max-request-size = 10MB
# 设置servlet最大文件上传尺寸
spring.servlet.multipart.max-file-size = 10MB
```