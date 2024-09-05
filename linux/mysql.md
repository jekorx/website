# MySQL

> 以Centos 7.4，MySQL5.7.x为例  

### 在线安装

```bash
# 1、查看已安装的mysql
rpm -qa | grep -i mysql

# 2、删除之前版本
yum -y remove 已安装的名称
# 如：
yum -y remove mysql-community-client-5.6.38-2.el7.x86_64

# 3、更新源并安装
cd /opt
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm -ivh mysql57-community-release-el7-11.noarch.rpm
yum -y install mysql-server

# 4、启动服务，必要的，不然不会生成/var/run/mysqld/mysqld.pid，导致其他错误
systemctl start mysqld
```

### 离线安装

> [mysql离线包下载](https://dev.mysql.com/downloads/mysql/)  
> Centos系统 mysql-8.4.2 为例，下载 **mysql-8.4.2-1.el7.x86_64.rpm-bundle.tar** 完整包  

```bash
# 1、先卸载掉CentOS自带的mysql
# 查找
rpm -qa | grep -E mysql\|mariadb
# mariadb-libs-5.5.56-2.el7.x86_64

# 卸载
sudo rpm -e --nodeps mariadb-libs-5.5.56-2.el7.x86_64

# 2、上传 mysql-8.4.2-1.el7.x86_64.rpm-bundle.tar

# 3、解压，-C选项是指解压到指定目录./mysql-rpm/下面
sudo tar -xvf mysql-8.4.2-1.el7.x86_64.rpm-bundle.tar -C ./mysql-rpm/

# 4、安装，❗ 必须按照顺序按照
cd mysql-rpm/
sudo rpm -ivh mysql-community-common-*.rpm
sudo rpm -ivh mysql-community-client-plugins-*.rpm
sudo rpm -ivh mysql-community-libs-*.rpm
sudo rpm -ivh mysql-community-client-8*.rpm
sudo rpm -ivh mysql-community-icu-data-files-*.rpm
sudo rpm -ivh mysql-community-server-*.rpm

# 5、查看mysql安装情况
systemctl status mysqld

# 6、修改配置文件
sudo vim /etc/my.cnf

# 服务器唯一ID
server-id=1
# 启用二进制日志
log-bin=mysql-bin
# 最大连接数
max_connections=10000
# 默认时区
default-time_zone='+8:00'
# 密码加密规则
plugin_load_add=mysql_native_password
# 修改mysql默认编码
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
#skip-grant-tables
# 修改mysql默认编码
[client]
default-character-set = utf8mb4
# 修改mysql默认编码
[mysql]
default-character-set = utf8mb4

# 7、启动mysql服务
sudo systemctl start mysqld
```

### 移动相关目录

> 移动data目录，log目录，相关操作（安装完需先启动mysql，生成数据库文件和log文件之后再进行移动操作）

```bash
# 停止服务
systemctl stop mysqld

# 创建目录
mkdir -p /opt/mysql/data/

# 修改属主和属组
chown -R mysql:mysql /opt/mysql/data

# 复制mysql data目录
cp -a /var/lib/mysql /opt/mysql/data/

# 建立链接（如果更新data目录后无法，使用链接的方式）
#ln -s /opt/mysql/data/mysql /usr/lib/mysql

# 修改my.cfg
vim /etc/my.cnf
datadir=/opt/mysql/data/mysql

# 复制mysql原有data目录可不修改此配置
#socket=/opt/mysql/data/mysql/mysql.sock

# 创建目录
mkdir -p /opt/mysql/logs

# 修改属主和属组
chown -R mysql:mysql /opt/mysql/logs

# 移动log文件，-a带权限复制
cp -a /var/log/mysqld.log /opt/mysql/logs

# 修改log目录
vim /etc/my.cnf
server_id=1
expire_logs_days=10
log-error=/opt/mysql/logs/mysqld.log

# 启动mysql
systemctl start mysqld

# 开启自动启动
systemctl enable mysqld
```

### 修改root密码

> mysql 8  

```bash
# 1、修改配置文件
vim /etc/my.cnf
# 增加
skip-grant-tables

# 2、重启mysql服务
systemctl restart mysqld

# 3、进入mysq命令行
mysql -uroot

# 4、执行sql
use mysql;
select host, user, authentication_string, plugin from user;
# 清空原有密码
update user set authentication_string = '' where user = 'root';

# 5、修改配置文件
vim /etc/my.cnf
# 注释掉
skip-grant-tables
# 重启mysql服务
systemctl restart mysqld

# 6、重新开启一个客户端
mysql -uroot -p
# 直接回车进入

# 修改密码
ALTER USER USER() IDENTIFIED BY '密码';
# 退出 exit; 重新登录

# 7、使用新密码进入mysql
mysql -uroot -p
# 输入密码进入
```

> mysql 5  

```bash
# 1、修改配置文件
vim /etc/my.cnf
# 增加
skip-grant-tables

# 2、重启mysql服务
systemctl restart mysqld

# 3、进入mysq命令行
mysql -uroot
# ERROR 2002 (HY000): Can’t connect to local MySQL server through socket ‘/var/lib/mysql/mysql.sock’ (2)
#mysql -uroot -S /opt/mysql/data/mysql/mysql.sock

# 4、执行sql
use mysql;
SET SQL_SAFE_UPDATES = 0;
update mysql.user set authentication_string=password('root') where User='root';
flush privileges;
SET SQL_SAFE_UPDATES = 1;

# 5、修改配置文件
vim /etc/my.cnf
# 去掉
skip-grant-tables

# 6、重启mysql服务
systemctl restart mysqld

# 7、使用新密码进入mysql
mysql -uroot -p
# 输入密码进入
```

### 修改mysql默认端口

```bash
# 1、修改配置文件
vim /etc/my.cnf

# 2、在[mysqld]下增加
port=<port>

# 3、重启mysql服务
systemctl restart mysqld
```

### 修改mysql默认编码

```bash
# 1、修改配置文件
vim /etc/my.cnf

# 2、增加
[client]
default-character-set = utf8mb4

[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4

# 3、重启mysql服务
systemctl restart mysqld
```

### 创建用户、数据库，授权数据库权限，远程连接

```sql
-- 1、创建用户名，%代表可以远程连接
use mysql;
CREATE USER 'username'@'%' IDENTIFIED BY 'password';
-- 2、创建数据库并制定默认编码
create database testdb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 3、用户授权使用指定数据库的指定权限
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON testdb.* TO 'username'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;

-- 删除用户，无需FLUSH PRIVILEGES;
drop user 'username'@'%';
```

### 常见错误

> ERROR 1819 &#40;HY000&#41;: Your password does not satisfy the current policy requirements  
> ERROR 1820 &#40;HY000&#41;: You must reset your password using ALTER USER statement before executin  

> 与```validate_password_policy```取值有关  

| Policy | Tests Performed | Remarks |
| --- | --- | --- |
| 0 or LOW | Length | |
| 1 or MEDIUM | Length; numeric, lowercase/uppercase, and special characters | **Default** |
| 2 or STRONG | Length; numeric, lowercase/uppercase, and special characters; dictionary file | |

```sql
-- 解决方法
-- 1、修改用户密码
set password=password("youpassword");
-- 或者
alter user 'root'@'localhost' identified by 'youpassword';

-- 也可通过设置validate_password_policy，不推荐
--set global validate_password_policy=0;

-- 2、刷新权限
flush privileges;
help contents;
```

> ERROR 1819 (HY000): Your password does not satisfy the current policy requirements

```bash
# 密码强度太弱，建议字母大小写+数字+符号
```

> [Err] 1055 - Expression #1 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'information_schema.PROFILING.SEQ' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

```bash
# 修改my.cnf
vim /etc/my.cnf
# 在[mysqld]添加以下配置
sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'

# 重启mysql服务
systemctl restart mysqld
```

> Illegal mix of collations (utf8_general_ci,IMPLICIT) and (utf8mb4_general_ci,COERCIBLE) for operation xxx  

```bash
# 问题原因：emoji表情导致，MySQL 的 utf8 并不是真正的 utf8。
# 解决方法：可讲数据库 或者 数据表 或者 对应字段的编码改为utf8mb4，
#          项目之初建议在数据库级别或者表级别设置编码，后期可以在对应字段修改编码。
```