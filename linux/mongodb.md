# MongoDB

### 下载安装

> [MongoDB官网](https://www.mongodb.com/try/download/community) -> On-Premises -> MongoDB Community Server  
> 选择 版本（4.4.0）、平台（CentOS 7.0）、包（tgz），具体可根据需要选择  
> 获取 tgz 压缩包[下载链接](https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.4.0.tgz)并下载  

```bash
# 解压
tar -xzvf mongodb-linux-x86_64-rhel70-4.4.0.tgz

# 移动到/usr/local/下
mv /opt/mongodb-linux-x86_64-rhel70-4.4.0 /usr/local/mongodb4

# 修改/etc/profile
vim /etc/profile

# 添加
export MONGODB_HOME=/usr/local/mongodb4
export PATH=PATH:{MONGODB_HOME}/bin

# 刷新/etc/profile
source /etc/profile

# 在mongodb/bin目录下添加mongodb.conf
cd /usr/local/mongodb4/bin
vim mongodb.conf
# 添加以下内容

# mongodb 配置文件
# 端口，默认27017
port=27017
# IP，默认127.0.0.1
bind_ip=0.0.0.0
# 数据库存放
dbpath=/var/lib/mongodb/data
# 日志文件
logpath=/var/lib/mongodb/logs/mongodb.log
# 错误日志采用追加模式，配置这个选项后mongodb的日志会追加到现有的日志文件，而不是从新创建一个新文件
logappend=true
# 启用日志文件，默认启用
journal=true
# 这个选项可以过滤掉一些无用的日志信息，若需要调试使用请设置为false
quiet=true
# 设置后台运行
fork=true
# 开启认证
auth=true

# 创建数据库目录和日志文件目录
mkdir -p /var/lib/mongodb/data
mkdir -p /var/lib/mongodb/logs

# 启动
/usr/local/mongodb4/bin/mongod -f /usr/local/mongodb4/bin/mongodb.conf

# 关闭
/usr/local/mongodb4/bin/mongod -shutdown -dbpath=/var/lib/mongodb/data
```

### 创建数据库、用户

```bash
# 启用mongo
/usr/local/mongodb4/bin/mongo

# 选择admin库
use admin

# 创建admin用户
db.createUser({user:"admin",pwd:"<密码>",roles:[{role:"userAdminAnyDatabase",db:"admin"}]})

# 用户的验证，返回1表示成功
db.auth("admin", "<密码>")

# 使用use创建数据库
use test

# 创建用户
# db.createUser({user:"<用户名>",pwd:"<密码>",roles:[{role:"<权限>",db:"<数据库>"}]})
db.createUser({user:"test",pwd:"password",roles:[{role:"dbOwner",db:"test"}]})
```