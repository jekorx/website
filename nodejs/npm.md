# Npm

#### 设置淘宝镜像源

```bash
# 解决npm或者某些依赖于npm的命令（gitbook等）安装依赖慢的问题
npm config set registry=http://registry.npm.taobao.org
# 解决node-sass安装失败的问题
npm config set sass_binary_site=https://npm.taobao.org/mirrors/node-sass
```

#### 版本

```bash
# 版本号
# <主版本号>.<次版本号>.<修补版本号>
x.y.z
# 修复bug，小改动，增加z
# 增加新特性，可向后兼容，增加y
# 有很大的改动，无法向下兼容，增加x


# 大于等于修补版本号
# 如：~1.2.3，表示从>=1.2.3到<1.3.0
~version

# 大于等于次版本号
# 如：^2.3.4，表示从>=2.3.4到<3.0.0
^version

# 版本完全匹配
# 如：2.3.4，表示版本=2.3.4
version

# 必须大于某个版本
# 如：>1.1.2，表示必须大于1.1.2版
>version

# 可大于或等于某个版本
# 如：>=1.1.2，表示可以等于1.1.2，也可以大于1.1.2版本
>=version

# 必须小于某个版本
# 如：<1.1.2，表示必须小于1.1.2版本
<version

# 可以小于或等于某个版本
# 如：<=1.1.2，表示可以等于1.1.2，也可以小于1.1.2版本
<=version

# x的位置表示任意版本
# 如：1.2.x，表示可以1.2.0，1.2.1，.....，1.2.n
x

# 任意版本，""也表示任意版本
# 如：*，表示>=0.0.0的任意版本
*

# 大于等于version1，小于等于version2
# 如：1.1.2 - 1.3.1，表示包括1.1.2和1.3.1以及他们件的任意版本
version1 - version2

# 满足range1或者满足range2，可以多个范围
# 如：<1.0.0 || >=2.3.1 <2.4.5 || >=2.5.2 <3.0.0，表示满足这3个范围的版本都可以
range1 || range2

# 获取最新版本
latest
```

#### 发布npm包

> 1、注册npm帐号，[点击前往npm官网](https://www.npmjs.com/)  
> 2、登录npm帐号  

```bash
# 根据提示输入创建的账号、密码和邮箱
npm login
```

> 3、发布包，```.gitignore```或```.npmignore```中的文件将会被忽略  
> 版本更新时，需要提升版本号  

```bash
npm publish
```

> 4、撤销发布  
> 删除npm市场的包同名的24小时后才能重新发布  

```bash
# 删除某个版本
npm unpublish <npm包名>@<版本号>

# 删除整个npm市场的包
npm unpublish <npm包名> --force

# 不删除，安装时会提示，版本号可忽略
# 如：npm deprecate <npm包名> '这个包已经不再维护了'
npm deprecate <npm包名>[@<版本号>] <message>
```

#### linux npm 全局安装权限不足的问题

> 一般非root用户操作会出现该问题  

> Windows系统：
> 1、通常是因为项目位置导致，如：电脑桌面的项目；  
> 2、需要以管理员身份运行命令行工具。

```bash
# 相关报错信息
error code EACCES
error syscall access
error path /usr/local/lib/nodejs/node-v12.16.2-linux-x64/lib/node_modules
error errno -13
error Error: EACCES: permission denied, access '/usr/local/lib/nodejs/node-v12.16.2-linux-x64/lib/node_modules'
error  [Error: EACCES: permission denied, access '/usr/local/lib/nodejs/node-v12.16.2-linux-x64/lib/node_modules'] {
error   stack: "Error: EACCES: permission denied, access '/usr/local/lib/nodejs/node-v12.16.2-linux-x64/lib/node_modules'",
error   errno: -13,
error   code: 'EACCES',
error   syscall: 'access',
error   path: '/usr/local/lib/nodejs/node-v12.16.2-linux-x64/lib/node_modules'
error }
error The operation was rejected by your operating system.
error It is likely you do not have the permissions to access this file as the current user
error
error If you believe this might be a permissions issue, please double-check the
error permissions of the file and its containing directories, or try running
error the command again as root/Administrator.
```

> 解决方法  

```bash
# 1、在命令行的主目录中，为全局安装创建目录：
mkdir ~/.npm-global

# 2、配置npm以使用新的目录路径：
npm config set prefix '~/.npm-global'

# 3、打开或创建一个 ~/.bash_profile 文件并添加以下行：
export PATH=$PATH:~/.npm-global/bin

# 4、在命令行上，更新系统变量：
source ~/.bash_profile

# 5、要测试新配置，请在不使用的情况下全局安装软件包sudo：
npm install -g yarn


# 可以使用相应的ENV变量代替步骤1-3（例如，如果您不想修改~/.bash_profile
NPM_CONFIG_PREFIX=~/.npm-global

# npm 5.2或更高版本，则可能要考虑将npx作为运行全局命令的替代方法
npx
```

#### node-sass安装失败的问题

> win10环境  

```bash
Error: Can't find Python executable "python", you can set the PYTHON env variable.
```

> 解决方法  

```bash
# node-gyp
npm install -g node-gyp

# 用管理员权限打开命令行执行
npm install --global --production windows-build-tools
# 该命令会安装
# 1、python(v2.7，3.x不支持)
# 2、visual C++ Build Tools，或者 （vs2015以上（包含15））
# 3、.net framework 4.5.1
```
