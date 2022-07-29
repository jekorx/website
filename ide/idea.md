# IDEA

#### 远程调试

> jar包方式启动java项目，可以使用idea进行远程调试  
> 1、远程服务器启动项目  
> 2、IDEA run Debug &#60;REMOTE NAME&#62;  
> 3、IDEA 断点调试  

```bash
nohup java -Xms256m -Xmx256m -jar -Xdebug -Xrunjdwp:transport=dt_socket,suspend=n,server=y,address=<PORT> <JAR NAME>.jar >/dev/null 2>&1 &  
```

```bash
# IDEA 设置
run -> Edit Configurations -> + -> Remote

Name: <REMOTE NAME>
Host: <IP>
Port: <PORT>
```

#### 常用插件

> File -> Settings -> Plugins  

```bash
# 社区版Spring支持
Spring Assistant

# Flutter相关，自动安装Dart
Flutter

# JRebel IDEA上热部署
JRebel and XRebel for IntelliJ
# 破解
# 1、生成GUID：https://www.guidgen.com/
# 2、Help -> JRebel -> Activation -> Team URL分别填写
https://jrebel.qekang.com/<生成的GUID>
<邮箱>
# 3、 勾选协议，Activate JRebel
# 4、next enable JRebel -> I agree
# 5、重启IDEA，JRebel setup guide按照提示操作

# Mybatis扩展支持
Free Mybatis plugin
```

#### 常用设置

> 路径等配置

```bash
# 字体及大小
File -> Settings -> Editor -> Font
Font: Consolas
Size: 16
Line Spacing: 1.2

# Maven，使用本地Maven
File -> Settings -> Build, Execution, Deployment -> Build Tools -> Maven
Maven home directory: <选择本地Maven根目录>
User settings file: <勾选 Override，选择本地Maven中conf/setting.xml>

# JDK设置，一般系统会自动设置，无需手动设置
File -> Settings -> Build, Execution, Deployment -> Build Tools -> Maven -> Runner
JRE: <选择本地SDK>

# Flutter SDK路径设置，配置后，Dart会自动配置
File -> Settings -> Languages & Frameworks -> Flutter
Flutter SDK path: <选择本地Flutter根目录>

# 取消代码重复提示
File -> Settings -> Editor -> Inspections -> General -> Duplicated Code
<取消选中>

# 注释模版，java方法
File -> Settings -> Editor -> Live Templates
1、右侧 + 选择 Template Group
填写名字 <java comment template>
2、右侧 + 选择 Live Template
3、设置
（1）Abbreviation: <method comment>
（2）Description: <method comment>
（3）Template text:
*
 * $target$
 $param$
 * @return $return$
 */
（4）下方Applicable相关: <选择Java全部>
（5）Expand with: <选择Enter>
（6）Edit variables:
param: groovyScript("def result=''; def params=\"${_1}\".replaceAll('[\\\\[|\\\\]|\\\\s]', '').split(',').toList(); for(i = 0; i < params.size(); i++) {if(i==0){result ='* @param ' + params[i] + ((i < params.size() - 1) ? '\\n' : '');}else{result +=' * @param ' + params[i] + ((i < params.size() - 1) ? '\\n' : '');}}; return result", methodParameters())
return: methodReturnType()

# 注释模版，java类
File -> Settings -> Editor -> File and Code Templates
1、选中Files -> Class
2、选择Includes -> File Header
/**
 * ${ClassName}
 * @author <用户名>
 * @since ${YEAR}-${MONTH}-${DAY} ${HOUR}:${MINUTE}:00
 */
```

> 快捷键

```bash
# 代码补全，Eclipse中Alt + /
File -> Settings -> Keymap -> Main menu -> Code -> Code Completion
# 删除占用
Cyclic Expand Word: <右键，Remove Alt + />
Cyclic Expand Word (Backward): <右键，Remove Alt + />
# 添加
Basic: <Add Keyboard Shutcut Alt + />

# 自动折行
File -> Settings -> Keymap -> Main menu -> View -> Active Editor
# 添加
Soft-Wrap: <Add Keyboard Shutcut Alt + Z>

# 在项目视图中选择文件
File -> Settings -> Keymap -> Other
# 删除占用
Quick Switch Scheme: <右键，Remove Ctrl + ~>
# 添加
Select File in Project View: <Add Keyboard Shutcut Ctrl + ~>
```

> IDE优化设置  

```bash
# 自动续订试用，注意：版本2021.2.2及以前
Plugins -> Custom Plugin Repositories
# 增加
https://plugins.zhile.io
# 安装插件
IDE Eval Reset
# Help最后，Eval Reset，勾选 Auto reset before per restart，Reset

# 修改内存
Help -> Change Memory Settings

# 取消索引（web项目，WebStorm中必备）
Preferences -> Editor -> File Types
Ignored Files and Folders 中
# 添加
node_modules

# 关闭打开后自动进入项目
Preferences -> Appearance & Behavior -> System Settings
# 取消勾选
Reopen projects on startup

# 关闭更新
Preferences -> Appearance & Behavior -> System Settings -> Updates
# 取消全部勾选

# 取消自动保存
File -> Settings -> Appearance & Behavior -> System Settings -> 
Autosave # 全部取消勾选

# 自动折行
File -> Settings -> Editor -> Editor Tabs
Appearance -> Mark modified（*）# 勾选

# 控制台字体
File -> Settings -> Editor -> Color Scheme -> Console Font
Use console font instead of the default # 勾选，设置Size
```
