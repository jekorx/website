# Nexus

> Nexus Repository OSS 3.x 版本，[下载地址](https://help.sonatype.com/repomanager3/download/download-archives---repository-manager-3)  
> 解压后，会有两个目录：  
> ```nexus-3.xx.x-xx```：nexus私服管理界面的容器，内部集成了jetty  
> ```sonatype-work```：私服的默认仓库，用于存储索引和组件资源  
> 搭建Maven私服，相关使用配置[请查看](./maven.md#使用nexus私服配置)  

#### CentOS环境

> CentOS版本```7.9```  
> Linux版依赖```Java 8```运行时环境，需先安装jdk1.8，[请查看](./jdk.md)  
> 启动后访问：```http://<ip地址>:8081```  

```bash
# 创建nexus目录
mkdir /opt/nexus

# 下载并解压nexus-3.33.0-01-unix.tar.gz到nexus目录
tar xzvf nexus-3.33.0-01-unix.tar.gz -C /opt/nexus/

# 创建nexus用户
useradd -d /opt/nexus/ nexus

# 设置权限
chown -R nexus /opt/nexus/

# 修改运行用户
vim /opt/nexus/nexus-3.33.0-01/bin/nexus.rc
# line.1
run_as_user="nexus"

# 如果jdk环境为后期自定义安装目录，需指定JAVA路径
vim /opt/nexus/nexus-3.33.0-01/bin/nexus
# line.14
INSTALL4J_JAVA_HOME_OVERRIDE=/opt/jdk1.8.0_191

# 加入系统服务，通过服务方式启动
vim /etc/systemd/system/nexus.service
# ------------------ nexus.service start -----------------
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/nexus-3.33.0-01/bin/nexus start
ExecStop=/opt/nexus/nexus-3.33.0-01/bin/nexus stop
User=nexus
Restart=on-abort
TimeoutSec=600

[Install]
WantedBy=multi-user.target
# ------------------ nexus.service end -------------------

# 重新加载systemctl
systemctl daemon-reload

# 启动服务
systemctl start nexus.service

# 开机自动启动
systemctl enable nexus.service
```

#### Windows环境

> Windows版本```Windows 10```  
> 自带```JRE```，无效额外安装  
> 启动后访问：```http://<ip地址>:8081```  

```bash
# 在 nexus-3.xx.x-xx/bin/ 目录下，以管理员身份运行命令行工具

# 安装nexus服务
nexus.exe /install <optional-service-name>

# 启动nexus服务
nexus.exe /start <optional-service-name>

# 停止nexus服务
nexus.exe /stop <optional-service-name>

# 卸载nexus服务
nexus.exe /uninstall <optional-service-name>
```

#### 配置

> 服务需启动过，完成初始化  

```bash
# 编辑配置文件
sonatype-work/nexus3/etc/nexus.properties

# 修改端口
application-port=8081 # line.2

# 修改配置文件后需重启服务
systemctl restart nexus.service # linux
nexus.exe /restart <optional-service-name> # windows
```