#!/usr/bin/env sh

# 当发生错误时中止脚本
set -e

# 构建
gitbook build

# 防盗处理
#((self.frameElement&&self.frameElement.tagName=="IFRAME")||(window.frames.length!=parent.frames.length)||(self!=top)||(window.location.host!="blog.wdg.pub")||(window.location.host!="www.wdg.pub"))&&(!!(window.attachEvent&&!window.opera)?document.execCommand("stop"):window.stop());document.getElementById("handle").remove()
read_dir(){
    for file in `ls -a $1`
    do
        if [ -d $1"/"$file ]
        then
            if [[ $file != '.' && $file != '..' ]]
            then
                read_dir $1"/"$file
            fi
        else
            if [ "${file##*.}"x = "html"x ]
            then
                if test $file != "sitemap.html"
                then
                    sed -i '5i\<script id="handle">((self.frameElement&&self.frameElement.tagName=="IFRAME")||(window.frames.length!=parent.frames.length)||(self!=top)||(window.location.host!="blog.wdg.pub")||(window.location.host!="www.wdg.pub"))&&(!!(window.attachEvent&&!window.opera)?document.execCommand("stop"):window.stop());document.getElementById("handle").remove()</script>' $1"/"$file
                fi
            fi
        fi
    done
}
read_dir _book

# 注释
read -p "comment: " comment

git add -A

git commit -m "$comment"

# 提交代码
git push

# 删除gh-pages分支
#git push origin --delete gh-pages

# 重新提交gh-pages分支
git subtree push --prefix _book origin gh-pages

echo "确认Enforce HTTPS选项被勾选"
