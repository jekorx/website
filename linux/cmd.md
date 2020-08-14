# Linux命令行

###### 用户操作

```bash
# 创建用户并指定登录主目录
useradd -d /www/testuser testuser

# 设置密码，输入两遍密码即可
passwd testuser

# 设置访问权限
chown -R testuser /www/testuser
```

###### nohup后台执行命令

```bash
# nohup java -jar xxx.jar >/dev/null 2>&1 &
# >/dev/null：/dev/null表示空设备文件，也可指定输出文件
# 2>&1：2表示错误输出（0：表示stdin标准输入，1：表示stdout标准输出），&1表示重定向为stdout标准输出
nohup <命令> >/dev/null 2>&1 &
```

###### 查看端口占用

```bash
# 方式 1
lsof -i:<PORT>

# 方式 2
# -t (tcp) 仅显示tcp相关选项
# -u (udp) 仅显示udp相关选项
# -n 拒绝显示别名，能显示数字的全部转化为数字
# -l 仅列出在Listen(监听)的服务状态
# -p 显示建立相关链接的程序名
netstat -tunlp | grep <PORT>
```

##### 删除当前目录及其子目录下所有指定文件

```bash
# ./ 为当前目录及其子目录
# -type d 目标为文件夹
# -name "<文件通配符>" 查找要删除的文件
# xargs rm -rf 执行删除
# 删除指定文件
find ./ -name "<文件通配符>" | xargs rm -rf
# 删除指定文件夹
find ./ -type d -name "<文件夹通配符>" | xargs rm -rf

# 如：删除所有.md文件
find ./ -name "*.md" | xargs rm -rf

# 如：删除所有含有md的文件夹
find ./ -type d -name "*md*" | xargs rm -rf
```