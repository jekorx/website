# Node.js（Linux环境下）

> 以Centos 7.4，Node.js 10.15.3 二进制文件安装为例  

#### 安装

```bash
# 下载地址https://nodejs.org/en/download/
# 安装教程可参考https://github.com/nodejs/help/wiki/Installation

# 定义node版本
VERSION=v10.15.0
# 定义系统版本
DISTRO=linux-x64
# 创建安装目录
sudo mkdir -p /usr/local/lib/nodejs
# 解压到安装目录
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs 

# 修改profile
vim /etc/profile

# 末尾加入以下内容
# Nodejs VERSION=10.15.3
VERSION=v<版本号>
DISTRO=linux-x64
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

# 刷新profile
source /etc/profile

# 检查
node -v
npm -v
```

#### 相关问题

> 1、linux npm 全局安装权限不足的问题，一般非root用户操作会出现该问题  

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