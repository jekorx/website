# Git常用命令

#### 全局属性配置

```bash
# 全局配置用户名
git config --global user.name "nameVal"
# 全局配置邮箱
git config --global user.email "eamil@qq.com"
```

#### 常用操作

> **注意：git对文件名称大小写不敏感**  

```bash
################### 提交 ####################
# 查看状态
git status

# 提交文件变化到暂存区
# 提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)
git add -u
# 提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件
git add .
# 提交所有变化
git add -A

# 提交文件至本地仓库区
git commit –m '<本次提交描述>'
# 以下两条命令相同，合并操作，提交文件变化，提交本地仓库区，等价于 git add . 之后 git commit –m '<本次提交描述>'
git commit –am '<本次提交描述>'
git commit –a –m '<本次提交描述>'

# 将本地版本库的分支推送到远程服务器
# git push <远程服务器> <分支>
git push origin master
# 当只关联一个远程，只有一个分支时，可以使用
git push

################### 更新 ####################
# 从远程主机的master分支拉取最新内容 
git fetch origin master
# 将拉取下来的最新内容合并到当前所在的分支中
git merge FETCH_HEAD

# git pull <远程主机名> <远程分支名>:<本地分支名>，等价于上面两步操作
git pull
```

#### 提交gh-pages分支以供展示

```bash
# _book为打包后的文件目录
git subtree push --prefix _book origin gh-pages
```

#### 分支

```bash
# 显示所有参数使用方法
git branch -h

# 查看所有分支，参数v显示版本号注释等附加信息，a显示所有
git branch -va
# * 开头的为当前本地分支，origin为远程分支
#   gh-pages                5c3cbe8 Create CNAME
# * master                  20575cc shouye
#   remotes/origin/HEAD     -> origin/master
#   remotes/origin/gh-pages 5c3cbe8 Create CNAME
#   remotes/origin/master   20575cc shouye
#   remotes/origin/test     20575cc shouye

# 创建分支
git branch <分支名>
# 提交分支到远程服务器
git push origin <分支名>

# 删除本地分支
git branch -d <分支名>
# 删除远程服务器分支
git push origin -d <分支名>

# 切换分支
git checkout <分支名>

# 创建并切换分支
git checkout -b <分支名>
```

#### git log 状态下如何退出

```bash
# 方法 1
# 英文状态摁 q
q

# 方法 2
# git bash 可能无效
ctrl + c
```

#### git撤销对远程仓库的push & commit提交

```bash
# 查看日志
git log

# commit **********c7be3d80f8c33889a211********** (HEAD -> master, origin/master, origin/HEAD)
# Author: user <example@example.com>
# Date:   Mon Apr 8 11:06:51 2019 +0800
# 
#     <注释1>
# 
# commit **********dfe5677d44a5e2f01768**********
# Author: user <example@example.com>
# Date:   Wed Apr 3 09:37:32 2019 +0800
# 
#     <注释2>

# 执行撤销到指定版本
# 如，撤销到<注释2> git reset -soft **********dfe5677d44a5e2f01768**********
# 
# git reset 命令分为两种： git reset –soft 与 git reset –hard ，区别是：
# 前者表示只是改变了HEAD的指向，本地代码不会变化，使用git status依然可以看到，同时也可以git commit提交。
# 后者直接回改变本地源码，不仅仅指向变化了，代码也回到了那个版本时的代码。
git reset –soft <版本号>

# 强制提交当前版本号，git push origin 分支名 –force
git push origin master –force
```

#### 统计贡献者代码行数

```bash
# --author="" 为贡献者用户名，$(git config --get user.name)表示当前用户
git log --author="$(git config --get user.name)" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
```