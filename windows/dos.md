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
open username:password@host 
put C:\test\a.zip /home/test/a.zip
close
exit
```

> 4、运行脚本```upload.bat```  

```bash
winscp.exe /console /script=upload.txt /log=log.txt
```

> 执行```upload.bat```会自动上传，初次会有登录提示，英文输入法状态下输入```Y```即可。  
> 注意：1、用户名、密码不能出现特殊符号；2、权限问题[可参照](../linux/cmd.md#用户操作)。  