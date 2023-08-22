# Svn

> 以Centos 7.4，Subversion 1.7.14 为例  

### 客户端命令

| 命令 | 简写 | 说明 | 其它 |
|---|---|---|--|
| svn checkout &#60;PATH&#62; | svn co &#60;PATH&#62; | 将文件Checkout到本地目录 | PATH是服务器上的目录 |
| svn status &#60;PATH&#62; | svn st &#60;PATH&#62; | <div>查看文件或者目录状态</div><div>PATH空为当前目录</div> | <div>?：不在svn的控制中</div><div>M：内容被修改</div><div>C：发生冲突</div><div>A：预定加入到版本库</div><div>K：被锁定</div> |
| svn add &#60;FILE&#62; | - | 添加新文件到版本库 | 支持通配符 |

### 安装

```bash
# 安装
yum install -y subversion
# 查看版本
svnserve --version
```

### 配置

```bash
# subversion默认以/var/svn作为数据根目录
# 创建svn版本库目录
mkdir -p /opt/svn
# 创建版本库
svnadmin create /opt/svn

# 创建用户
vim /opt/svn/conf/passwd
# 增加用户，格式：用户名 = 密码
[users]
admin = admin
guest = guest

# 配置权限
vim /opt/svn/conf/authz
# 格式：用户名 = 权限，r读取权限，w写入权限
[/]
admin = rw
guest = r

# 最后设定snvserv.conf，使上面配置生效
vim /opt/svn/conf/svnserve.conf
# 修改以下
anon-access = none # 使非授权用户无法访问
auth-access = write # 使授权用户有写权限
password-db = password
authz-db = authz   # 访问控制文件
realm = /opt/svn # 认证命名空间，subversion会在认证提示里显示，并且作为凭证缓存的关键字。
```

### 启动svn

```bash
# 运行
svnserve -d -r /opt/svn
# --listen-port指定端口
# vnserve -d -r /opt/svn --listen-port 3391

# 开机自动启动，/etc/rc.local中加入
vim /etc/rc.local

svnserve -d -r /opt/svn
```

### Tips

```bash
# windows系统，桌面右击菜单隐藏svn，强迫症专用
svn setting -> General -> Context Menu
# 在Do not show the context menu for the following paths:
# 加入桌面路径，如
D:\users\desktop
```

### Global ignore pattern

```bash
# 增加以下忽略规则
node_modules dist .idea target *.iml
```