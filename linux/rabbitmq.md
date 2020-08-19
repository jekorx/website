# RabbitMQ安装

#### 下载安装

> 下载并安装 [erlang](https://www.rabbitmq.com/releases/erlang/) 依赖 [erlang-18.1-1.el7.centos.x86_64.rpm](https://www.rabbitmq.com/releases/erlang/erlang-18.3.4.4-1.el7.centos.x86_64.rpm)	  
> 下载并安装 [socat](http://repo.iotti.biz/CentOS/7/x86_64/socat-1.7.3.2-5.el7.lux.x86_64.rpm) 依赖  
> 下载[rabbitmq-server](https://www.rabbitmq.com/releases/rabbitmq-server/) 服务 [rabbitmq-server-3.6.15-1.el7.noarch.rpm](https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.15/rabbitmq-server-3.6.15-1.el7.noarch.rpm)  

```bash
# 在linux下直接执行命令命令
wget https://www.rabbitmq.com/releases/erlang/erlang-18.3.4.4-1.el7.centos.x86_64.rpm
wget http://repo.iotti.biz/CentOS/7/x86_64/socat-1.7.3.2-5.el7.lux.x86_64.rpm
wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.15/rabbitmq-server-3.6.15-1.el7.noarch.rpm
```

```bash
# 按顺序安装rpm包
yum -y install erlang-18.3.4.4-1.el7.centos.x86_64.rpm
yum -y install socat-1.7.3.2-5.el7.lux.x86_64.rpm
yum -y install rabbitmq-server-3.6.15-1.el7.noarch.rpm
```

#### 配置

```bash
# 将配置文件复制到/etc/rabbitmq/下
cp -a /usr/share/doc/rabbitmq-server-3.6.15/rabbitmq.config.example /etc/rabbitmq/

# 重命名配置文件
cd /etc/rabbitmq/
mv rabbitmq.config.example rabbitmq.config

# 启用rabbitmq的管理平台插件，会在/etc/rabbitmq 目录下多出一个 enabled_plugins
cd /etc/rabbitmq/
rabbitmq-plugins enable rabbitmq_management

# 启动
rabbitmq-server start
# 后台启动，无法使用rabbitmq-server stop停止，直接kill进行
rabbitmq-server -detached

# 停止
rabbitmq-server stop

# 开机自动启动
chkconfig rabbitmq-server on
```

#### 用户管理

```bash
# 需在rabbitmq-server启动状态下操作

# 添加用户
# rabbitmqctl add_user <用户名> <密码>
rabbitmqctl add_user admin admin

# 设置权限，可以远程访问
# rabbitmqctl set_permissions -p "/" <用户名> ".*" ".*" ".*"
rabbitmqctl set_permissions -p "/" admin ".*" ".*" ".*"

# 设置角色tags
# rabbitmqctl set_user_tags <用户名> <角色>
rabbitmqctl set_user_tags admin administrator

# 查看用户列表
rabbitmqctl list_users

# 查看用户权限
rabbitmqctl list_permissions -p /

# 删除用户
# rabbitmqctl delete_user <用户名>
rabbitmqctl delete_user admin
```