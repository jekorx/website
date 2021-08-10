# Maven（Linux环境下）

> 以Centos 7.4，Maven 3.6.0 为例  

#### 安装

```bash
# 下载二进制文件压缩包http://mirrors.shu.edu.cn/apache/maven/maven-3/
# 或者直接下载然后通过ftp工具上传到服务器
wget http://mirrors.shu.edu.cn/apache/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz

# 解压
tar -xzvf apache-maven-3.6.0-bin.tar.gz

# 修改profile
vim /etc/profile
export M2_HOME=/opt/apache-maven-3.6.0 # 最后面添加
export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin # 修改PATH

# 重新初始化profile
source /etc/profile

# 查看配置结果
mvn -v
```

#### 基本配置

> ```<Maven安装目录>/conf/settings.xml```  

```xml
<!-- 修改本地maven存放路径，line.53 -->
<localRepository>${user.home}/.m2/repository</localRepository>

<!-- 使用华为存储仓库，line.155 -->
<mirrors>
  <mirror>
    <id>huaweimaven</id>
    <name>Huawei Maven</name>
    <mirrorOf>*</mirrorOf>
    <url>https://mirrors.huaweicloud.com/repository/maven/</url>
  </mirror>
</mirrors>
```

#### 使用Nexus私服配置

> Nexus搭建[请查看](./nexus.md)  
> ```<Maven安装目录>/conf/settings.xml```  

```xml
<mirrors>
  <mirror>
    <id>nexus</id>
    <name>Nexus</name>
    <mirrorOf>*</mirrorOf>
    <url>http://127.0.0.1:8081/repository/maven-public/</url>
  </mirror>
  <mirror>
    <id>huaweimaven</id>
    <name>Huawei Maven</name>
    <mirrorOf>central</mirrorOf>
    <url>https://mirrors.huaweicloud.com/repository/maven/</url>
  </mirror>
</mirrors>

<!-- 配置仓库 -->
<profiles>
  <profile>
    <id>nexus</id>
    <repositories>
      <repository>
        <id>nexus</id>
        <name>Nexus</name>
        <url>http://127.0.0.1:8081/repository/maven-public/</url>
        <layout>default</layout>
        <releases>
          <enabled>true</enabled>
        </releases>
        <snapshots>
          <enabled>true</enabled>
        </snapshots>
      </repository>
    </repositories>
    <pluginRepositories>
      <pluginRepository>
        <id>nexus</id>
        <name>Nexus</name>
        <url>http://127.0.0.1:8081/repository/maven-public/</url>
        <releases>
          <enabled>true</enabled>
        </releases>
        <snapshots>
          <enabled>true</enabled>
        </snapshots>
      </pluginRepository>
    </pluginRepositories>
  </profile>
</profiles>
<!-- 激活nexus配置 -->
<activeProfiles>
  <activeProfile>nexus</activeProfile>
</activeProfiles>

<!-- 配置服务器 -->
<servers>
  <server>
    <id>releases</id> <!-- 与pom.xml中配置的id一致 -->
    <username>username</username>
    <password>passoword</password>
  </server>
  <server>
    <id>snapshots</id> <!-- 与pom.xml中配置的id一致 -->
    <username>username</username>
    <password>passoword</password>
  </server>
</servers>
```

> 在项目```pom.xml```添加  

```xml
<!-- pom.xml -->
<distributionManagement>
    <snapshotRepository>
        <id>snapshots</id> <!-- 需要与settings.xml文件中一致 -->
        <name>Snapshot</name>
        <url>http://127.0.0.1:8081/repository/maven-snapshots/</url> <!-- snapshots仓库地址 -->
        <uniqueVersion>true</uniqueVersion> <!-- 是否分配一个包含时间戳的构建号，不分配 -->
    </snapshotRepository>
    <repository>
        <id>releases</id> <!-- 需要与settings.xml文件中一致 -->
        <name>Release</name>
        <url>http://127.0.0.1:8081/repository/maven-releases/</url> <!-- releases仓库地址 -->
    </repository>
</distributionManagement>
```

> ```pom.xml```部分说明  

```xml
<!-- pom.xml -->
<groupId>groupId</groupId>
<artifactId>artifactId</artifactId>
<packaging>jar</packaging>
<version>1.0</version> <!--也可能为：<version>1.0-SNAPSHOT</version> -->
```

> 其中**groupId**和**artifactId**将会是发布到私服后的包路径；  
> **packaging**是打包方式；  
> **version**中是包的版本。如果version版本号包括```-SNAPSHOT```则该包会被发布到**spapshots**仓库，否则会被发布到**releases**仓库。  
