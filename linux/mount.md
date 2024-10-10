# Linux硬盘存储相关

### Linux的dev/vda1文件满了导致数据库无法写入

> ```/dev/vda1``` 是 Linux 系统中的一个设备文件，它表示第一个虚拟磁盘（vda）的第一个分区（1）。在大多数 Linux 发行版中，这是系统根分区的默认位置。  
> 如果 ```/dev/vda1``` 使用到达 **100%** 会导致 ```MySQL、PostgreSQL``` 等无法写入等问题。 

```bash
# 以 PostgreSQL 数据库访问失败为例，报错信息如下
# FATAL:  could not write lock file "postmaster.pid": No space left on device

# 1、排查硬盘使用情况
df -h
# 发现 /dev/vda1 使用率 100%
# /dev/vda1  40G  38G  0 100%  /

# 2、进入 /dev/vdal 的磁盘挂载的目录 /，查看各个文件占用大小
cd /
du -sh *
# 发现 logs、www 文件占用大，手动对其清理即可
# 20G	www
# 31G	logs

# 3、查询一下查看已删除空间却没有释放的进程 id 然后 kill 掉
lsof -n | grep -i delete
kill -9 <pid>
```

### Linux下永久挂载硬盘到指定目录

> 以Centos 7.4为例

```bash
# 1、查看可挂载硬盘
fdisk -l

# 2、磁盘分区
fdisk /dev/vdb

# 3、参数：输入 n， p， 1， 回车，回车， wq

# 4、格式化硬盘
mkfs.ext4 /dev/vdb1

# 5、挂载到指定目录
mount /dev/vdb1 /opt

# 6、写入分区表（自动挂载）
echo '/dev/vdb1  /opt ext4 defaults 0  0' >> /etc/fstab

# 7、查看挂载结果
df -h
```



