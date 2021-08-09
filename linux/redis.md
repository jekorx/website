# Redis（Linux环境下）

> 以Centos 7.4，redis 5.0.x 为例  

#### 安装

```bash
# 下载压缩包https://redis.io/download
# /opt/redis-5.0.4.tar.gz
cd /opt

# 解压
tar -xzvf redis-5.0.4.tar.gz

# 编译
cd /opt/redis-5.0.4
make

# 安装
cd /opt/redis-5.0.4/src
make install PREFIX=/usr/local/redis

# 复制配置文件到安装目录
cp -a /opt/redis-5.0.4/redis.conf /usr/local/redis

# 修改配置
vim /usr/local/redis/redis.conf

bind 127.0.0.1                 # line.69 注释掉
port <port>                    # line.92 修改默认端口
daemonize yes                  # line.136 守护进程 yes
dir /usr/local/redis/          # line.263 修改dump.rdb目录
requirepass <your password>    # line.507 设置密码
maxmemory <bytes>              # line.566 可使用最大内存，单位字节（bytes）
notify-keyspace-events Ex      # line.1060 键空间通知，过期事件的监听

# notify-keyspace-events 全部配置
# K 键空间通知，以__keyspace@<db>__为前缀
# E 键事件通知，以__keysevent@<db>__为前缀
# g del, expipre, rename 等类型无关的通用命令的通知
# $ String命令
# l List命令
# s Set命令
# h Hash命令
# z 有序集合命令
# x 过期事件（每次key过期时生成）
# e 驱逐事件（当key在内存满了被清除时生成）
# A g$lshzxe的别名，因此“AKE”意味着所有的事件

# 创建软连接
ln -s /usr/local/redis/bin/* /usr/local/sbin/

# 启动服务
redis-server /usr/local/redis/redis.conf

# 开机自动启动，/etc/rc.local中加入
vim /etc/rc.local

redis-server /usr/local/redis/redis.conf
```

#### 测试连接

```bash
# 无密码
redis-cli

# 有密码
redis-cli
> auth <your password>

> ping
pong
```

#### 相关错误

> MISCONF Redis is configured to save RDB snapshots, but it is currently not able to persist on disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails &#40;stop-writes-on-bgsave-error option&#41;. Please check the Redis logs for details about the RDB error.  

```bash
# 修改配置
vim /usr/local/redis/redis.conf

stop-writes-on-bgsave-error no # line.235 持久化失败报错 no，继续使用

# 重启redis
```