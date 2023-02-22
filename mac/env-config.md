# Mac常用环境配置

### oh-my-zsh

> 推荐命令行工具 [iterm2](https://iterm2.com/)  
> [oh-my-zsh官网](https://ohmyz.sh/)  

```bash
# 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 更新
omz update

# 卸载
uninstall_oh_my_zsh
```

```bash
# 相关环境变量配置
vim ~/.zshrc
#vim ~/.bash_profile

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# 重新加载配置文件
source ~/.zshrc
#source ~/.bash_profile
```

### Xcode Command Line Tools

> [xcode-select 可参照](https://github.com/nodejs/node-gyp/blob/main/macOS_Catalina.md#i-did-all-that-and-the-acid-test-still-does-not-pass--)  

### homebrew

> [Homebrew官网](https://brew.sh/index_zh-cn)  

###### 安装

```bash
# 配置环境变量
vim ~/.zshrc
#vim ~/.bash_profile

# 添加以下配置
# homebrew
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# 重新加载配置文件
source ~/.zshrc
#source ~/.bash_profile
```

```bash
# 安装
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# 卸载
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

> 如果安装慢或超时可以参照 [Github速度慢优化方法](../git-svn/git.md#github速度慢优化方法) 将```raw.githubusercontent.com```配置到```/etc/hosts```  

###### 常用命令及安装软件包

```bash
# 查看版本号
brew -v

# 更新brew
brew update

# 检测brew
brew doctor

# 查询可用包，安装前可先查一下
brew search <包名>

# 安装git
brew install git

# 安装svn
brew install subversion

# 安装yarn
brew install yarn
# 注意需要配置环境变量，才能访问到yarn安装的全局npm包
# other export path
export PATH=$PATH:~/.yarn/bin

# 查看安装的包
brew list

# 更新所有包
brew upgrade

# 更新指定包
brew upgrade <包名>

# 卸载包
brew uninstall <包名>
```

### nvm

> [Node Version Manager](https://github.com/nvm-sh/nvm) 获取最新```curl```远程安装命令  

```bash
# 配置环境变量
vim ~/.zshrc
#vim ~/.bash_profile

# 添加以下配置
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 重新加载配置文件
source ~/.zshrc
#source ~/.bash_profile
```

#### node.js

> 通过```nvm```命令安装  

```bash
# 安装指定版本 node.js
nvm install <node版本号>

# 指定 default 别名可以在新打开命令行工具时，使node命令生效
nvm alias default <node版本号>
```

### jdk

> Mac Arm版 [Azul Zulu](https://www.azul.com/downloads/?version=java-8-lts&os=macos&architecture=arm-64-bit&package=jdk) 下载地址  
> 下载```.tar.gz```格式，解压，将```zulu-8.jdk```放到```/Library/Java/JavaVirtualMachines```下  

```bash
# 配置环境变量
vim ~/.zshrc
#vim ~/.bash_profile

# 添加以下配置
# jdk
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home"
export CLASSPATH=".:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"
export PATH=$PATH:$JAVA_HOME/bin

# 重新加载配置文件
source ~/.zshrc
#source ~/.bash_profile
```

### maven

> [maven 下载页面](https://maven.apache.org/download.cgi)  
> 如果遇到 idea 版本限制，可使用 maven 3.6.3，[maven 3.6.3 下载地址](https://dlcdn.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz)  
> 下载后解压到```~/java```下  

```bash
# 配置环境变量
vim ~/.zshrc
#vim ~/.bash_profile

# 添加以下配置
# maven
export M2_HOME="$HOME/java/apache-maven-3.8.6"
export PATH=$PATH:$M2_HOME/bin

# 重新加载配置文件
source ~/.zshrc
#source ~/.bash_profile
```
