# Npm

#### linux npm 全局安装权限不足的问题
> 一般非root用户操作会出现该问题  

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

#### node-sass安装失败

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
