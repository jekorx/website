# Linux下JDK配置

```bash
vim /etc/profile

export JAVA_HOME=/home/jdk1.8.0_191
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin

source /etc/profile
```



