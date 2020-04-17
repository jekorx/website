# Linux命令行

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