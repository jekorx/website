# RabbitMQ安装

#### 下载安装

> 下载对应版本的[erlang和rabbitmq-server](https://packagecloud.io/rabbitmq)  
> 注意：rabbitmq-server的el版本要跟erlang对应  

```bash
# 在linux下直接执行命令命令
wget --content-disposition https://packagecloud.io/rabbitmq/erlang/packages/el/7/erlang-23.3.4.5-1.el7.x86_64.rpm/download.rpm
wget --content-disposition https://packagecloud.io/rabbitmq/rabbitmq-server/packages/el/7/rabbitmq-server-3.8.19-1.el7.noarch.rpm/download.rpm
```

```bash
# 按顺序安装rpm包
yum -y install erlang-23.3.4.5-1.el7.x86_64.rpm
yum -y install rabbitmq-server-3.8.19-1.el7.noarch.rpm
```

#### 配置

> 新版本rabbitmq需单独[下载配置文件](https://github.com/rabbitmq/rabbitmq-server/blob/v3.8.19/deps/rabbit/docs/rabbitmq.conf.example)  
> 下载地址：```https://github.com/rabbitmq/rabbitmq-server/blob/v版本号/deps/rabbit/docs/rabbitmq.conf.example```  

```bash
# 在/etc/rabbitmq/下，下载配置文件
cd /etc/rabbitmq/

# 创建配置文件
touch rabbitmq.conf

# 重命名配置文件，将配置复制到配置文件中
vim rabbitmq.conf

# 启用rabbitmq的管理平台插件，会在/etc/rabbitmq 目录下多出一个 enabled_plugins
cd /etc/rabbitmq/
rabbitmq-plugins enable rabbitmq_management

# 启动服务
systemctl start rabbitmq-server

# 停止服务
systemctl stop rabbitmq-server

# 开机自动启动
systemctl enable rabbitmq-server
```

#### 安装插件

> [社区插件列表](https://www.rabbitmq.com/community-plugins.html)  

```bash
# 查看已安装插件
rabbitmq-plugins list

# 未出现在列表中的插件需单独安装
cd /usr/lib/rabbitmq/lib/rabbitmq_server-3.8.19/plugins/

# 下载插件，如：延时队列插件
wget https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.8.17/rabbitmq_delayed_message_exchange-3.8.17.8f537ac.ez

# 启用插件，rabbitmq-plugins enable <插件名>
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
```

#### 用户管理

```bash
# 需在rabbitmq-server启动状态下操作

# 添加用户，密码不能有特殊字符
# rabbitmqctl add_user <用户名> <密码>
rabbitmqctl add_user admin admin

# 设置角色tags
# rabbitmqctl set_user_tags <用户名> <角色>
rabbitmqctl set_user_tags admin administrator

# 设置权限，可以远程访问
# rabbitmqctl set_permissions -p "/" <用户名> ".*" ".*" ".*"
rabbitmqctl set_permissions -p "/" admin ".*" ".*" ".*"

# 查看用户列表
rabbitmqctl list_users

# 查看用户权限
rabbitmqctl list_permissions -p /

# 删除用户
# rabbitmqctl delete_user <用户名>
rabbitmqctl delete_user admin
```