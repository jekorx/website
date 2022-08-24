#!/usr/bin/env sh

# 当发生错误时中止脚本
set -e

rm -rf _book

# 构建
gitbook build

# 动态插入js
read -p "beian code: " code
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
                    sed -i '' "s/&#xFF0C;powered by Gitbook/ /g" $1"/"$file
                    sed -i '' '5i\
                    <script id="f0196b">((self.frameElement&&self.frameElement.tagName=="IFRAME")||(window.frames.length!=parent.frames.length)||(self!=top)||((window.location.host!="blog.wdg.pub")&&(window.location.host!="www.wdg.pub")))&&(!!(window.attachEvent&&!window.opera)?document.execCommand("stop"):window.stop());document.getElementById("f0196b").remove()</script>
                    ' $1"/"$file
                    #sed -i "/<\/body>/i <script id=\"b49ed9\">document.writeln('<script type=\"text/javascript\" color=\"77,77,77\" opcity=\"0.77\" count=\"'+(document.body.clientWidth?Math.floor(document.body.clientWidth/20):30)+'\" src=\"https://cdn.bootcdn.net/ajax/libs/canvas-nest.js/2.0.4/canvas-nest.js\">'+'<'+'/script>');document.getElementById(\"b49ed9\").remove()</script>" $1"/"$file
                    if [ -n "$code" ]
                    then
                        sed -i '' "s/本书使用 GitBook 发布/${code}/g" $1"/"$file
                        sed -i '' 's/<a href="https:\/\/www.gitbook.com" target="blank" class="gitbook-link">/<a href="https:\/\/beian.miit.gov.cn\/" style="text-align: center; margin-bottom: 7px" target="blank" class="gitbook-link">/g' $1"/"$file
                        #sed -i "/<\/body>/i <script id=\"b82fd9\">!function(){var t=document.querySelector('.gitbook-link');t.innerText='${code}',t.href='https://beian.miit.gov.cn/',t.style.textAlign='center',t.style.marginBottom='7px'}();document.getElementById(\"b82fd9\").remove()</script>" $1"/"$file
                    fi
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
#git subtree push --prefix _book origin gh-pages

#echo "确认Enforce HTTPS选项被勾选"

#rm _book/**/*.md
rm _book/.gitignore
rm _book/*.sh
rm _book/*.bat
rm _book/LICENSE

# cmd.exe /C winrarpkg.bat