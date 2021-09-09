# DOS命令行

###### 删除所有指定文件

```bash
:: 删除当前目录下所有具有<文件名称通配符>的文件，包括下级目录
:: del /f/s/q "<文件名称通配符>"
:: 如：所有.md的文件
del /f/s/q "*.md"
```

###### 使用WinSCP上传文件到Linux系统

> 1、[WinSCP下载地址](https://winscp.net/eng/download.php)  
> 2、安装后需将```winscp.exe```的所在目录配置到环境变量  
> 3、创建运行脚本```upload.txt```  

```bash
option confirm off
open <username>:<password>@<host>
cd /opt/test/
rm file.txt
rmdir folder
put test\* ./
close
exit
```

```bash
# 说明：
# cd /opt/test/  改变服务器当前目录
# rm file.txt    删除文件
# rmdir folder   删除文件夹内全部文件及文件夹
# put test\* ./  上传本地当前目录到服务器cd的目录，本地目录也可使用绝对路径，如：C:\test\a.zip
```

> 4、运行脚本```upload.bat```  
> 执行```upload.bat```会自动上传，初次会有登录提示，英文输入法状态下输入```Y```即可。  
> 注意：1、用户名、密码不能出现特殊符号；2、权限问题[可参照](../linux/cmd.md#用户操作)。  

```bash
# 如需打印日志可添加参数 /log=log.txt
winscp.exe /console /script=upload.txt
```

> 5、使用Git Bash运行bat脚本  

```bash
cmd.exe /C upload.bat
```

> 参照：```winscp```命令  

| 命令 | 描述 |
|:--:|:--:|
| call | 执行任意远程 shell 命令 |
| cd | 更改远程工作目录 |
| checksum | 计算远程文件的校验和 |
| chmod | 更改远程文件的权限 |
| close | 关闭会话 |
| cp | 复制远程文件 |
| echo | 将消息打印到脚本输出 |
| exit | 关闭所有会话并终止程序 |
| get | 从远程目录下载文件到本地目录 |
| help | 显示帮助 |
| keepuptodate | 不断反映远程目录上本地目录的变化 |
| lcd | 更改本地工作目录 |
| lls | 列出本地目录的内容 |
| ln | 创建远程符号链接 |
| lpwd | 打印本地工作目录 |
| ls | 列出远程目录的内容 |
| mkdir | 创建远程目录 |
| mv | 移动或重命名远程文件 |
| open | 连接到服务器 |
| option | 设置或显示脚本选项的值 |
| put | 将文件从本地目录上传到远程目录 |
| pwd | 打印远程工作目录 |
| rm | 删除远程文件 |
| rmdir | 删除远程目录 |
| session | 列出连接的会话或选择活动会话 |
| stat | 检索远程文件的属性 |
| synchronize | 将远程目录与本地目录同步 |


###### net网络命令

```bash
# 建立IPC链接
net use \\<IP> <PASSWORD> /user:<USRENAME>

# 删除指定链接
net use \\<IP> /delete

# 删除全部链接，会有确认提示，可用于查看列表
net use * /delete
```

##### 刷新DNS缓存

```bash
ipconfig /flushdns
```

##### 复制文件/文件夹并添加到压缩文件

> 安装```winrar```，安装后需将```winrar.exe```的所在目录配置到环境变量  

```bash
:: 创建目录
md test

:: 使用xcopy命令拷贝folder1及其子目录与文件到test目录下，/E 参数表示包括空目录
xcopy folder1 test\folder1\ /E

:: 使用xcopy命令拷贝folder2及其子目录与文件到test目录下，排除exclude.txt指定的文件及文件夹：\dir\ 为忽略dir目录，.txt 为忽略扩展名的文件
xcopy folder2 test\folder2\ /E /exclude:exclude.txt

:: 使用copy命令拷贝exclude.txt到test目录下
copy exclude.txt .\test\

:: 压缩test文件夹到test.zip，完成后删除test目录
start winrar a test.zip .\test -dr
```

> ```xcopy```命令```/exclude```参数所需的```exclude.txt```内容  

```
folder2\dir\
folder2\ignore.txt
```