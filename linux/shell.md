# Shell

### 介绍

```
1. 是一个命令解析器，为用户提供了一个向Linux内核发送请求以便运行程序的界面系统级程序
2. 由 C 语言编写
3. 既是一种命令语言，又是一种程序设计语言
4. 文件后缀 .sh（Unix、Linux、MacOS）
```

> 模型  

```
┌────────────────────────────┐
│  File System / Application │
│  ┌──────────────────────┐  │
│  │        Shell         │  │
│  │  ┌────────────────┐  │  │
│  │  │     Kernel     │  │  │
│  │  │  ┌──────────┐  │  │  │
│  │  │  │ Hardware │  │  │  │
│  │  │  └──────────┘  │  │  │
│  │  └────────────────┘  │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

> 文件基本属性  

```
drwxr-xr-x  2 username  staff    64B  8 18 14:58 params
drwxr-xr-x  4 username  staff   128B  8 18 14:58 symbol
-r-xr-xr-x  1 username  staff   245B  8 18 15:03 params.sh
┬└┬┘└┬┘└┬┘  ┬ ────┬───  ──┬──   ──┬─  ────┬───── ─┬─────────
│ │  │  │   │     │       │       │       │       └→ filename
│ │  │  │   │     │       │       │       └→ month/date/time last modified
│ │  │  │   │     │       │       └→ size
│ │  │  │   │     │       └→ group name
│ │  │  │   │     └→ user (owner) name
│ │  │  │   └→ number of hard links
│ │  │  └→ other (everyone) permissions
│ │  └→ group permissions
│ └→ user permissions
└→ file type (d: directory; -: file; l: link file;)

r w x
┬ ┬ ┬
│ │ └→ executable -> 1 (001)
│ └→ writeable    -> 2 (010)
└→ readable       -> 4 (100)

r-- = 4
r-x = 5
rwx = 7
```

```bash
# 更改文件属主
# chmod [-R] xyz 文件或目录
# -R: 递归修改
chmod 755 test.sh

# 用户 读、写、执行 权限，组 读、执行 权限，其他 读、执行 权限
# 能够执行的前提是能够读取该文件
```

### 环境（解析器）

```
Bourne Shell（/usr/bin/sh 或 /bin/sh）
Bourne Again Shell（/bin/bash）
C Shell（/usr/bin/csh）
K Shell（/usr/bin/ksh）
Shell for Root（/sbin/sh）
Z-shell（/bin/zsh）
```

```bash
# 查看系统 shell 环境（解析器）
cat /etc/shells

# 输出
/bin/bash
/bin/csh
/bin/dash
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh

# 查看默认 shell
echo $0

# -zsh
```

```bash
# 配置文件 - bash
# ~/.bash_profile

# 配置文件 - zsh
# ~/.zshrc

# 修改配置文件后，需要重新执行刚修改的配置，使之生效
source ~/.bash_profile
source ~/.zshrc
```

###### .sh 文件指定解析器

> 文件第一行加入  

```bash
#!/bin/zsh
```

### Hello World

```bash
echo 'Hello World!'

# Hello World!

cat stdin.txt

# 输出文件内容
```

### 特殊符号

###### 使用变量（$）

```bash
# $val 使用变量

val=123 # 定义变量

echo $val

# 123

unset val # 撤销变量
```

###### 注释（ # ）

```bash
# 这是一行注释
```

###### 单引号（ '' ）

```bash
# 单引号里面的内容不做特殊解析

echo 'val = $val'

# val = $val
```

###### 双引号（ "" ）

```bash
# 双引号里面的内容做特殊解析，如：变量

echo "val = $val"

# val = 123
```

###### 转译（ \ ）

```bash
# 双引号里面的内容做特殊解析，如：变量

echo "\"Hello World\!\""

# "Hello World!"
```

###### 连字符（ {} ）

```bash
# 主要与 $ 配合，作为连字符使用

echo ${val}${val}aa

# 123123aa
```

###### 标准输出 stdout（ > , >> ）

```bash
# > 将内容输出到文件，如果文件有内容，清空，重新写入
echo 'Hello World!' > stdout.txt

# Hello World!

# >> 将内容输出到文件，如果文件有内容，追加写入（新行），使用场景：持续记录日志
echo 'Hello World!' >> stdout.txt

# Hello World!
# Hello World!
```

###### 标准输入 stdin（ < ）

```bash
# < 将文件内容作为输入
grep 'l' < stdin.txt

# 搜索到包含 l 的内容
```

###### 参数传递

| 参数处理 | 说明 |
| :--: | -- |
| &#36;# | 传递到脚本的参数个数 |
| &#36;* | 以一个单字符串显示所有向脚本传递的参数。如"&#36;*"用「"」括起来的情况、以"&#36;1 &#36;2 … &#36;n"的形式输出所有参数。 |
| &#36;&#36; | 脚本运行的当前进程ID号 |
| &#36;! | 后台运行的最后一个进程的ID号 |
| &#36;? | 获得之前(上一个)进程结束的状态码 (0 表示成功, 1 表示失败) |
| &#36;@ | 与&#36;*相同，但是使用时加引号，并在引号中返回每个参数。如"&#36;@"用「"」括起来的情况、以"&#36;1" "&#36;2" … "&#36;n" 的形式输出所有参数。 |
| &#36;- | 显示Shell使用的当前选项，与set命令功能相同。 |
| &#36;_ | 表示的是打印上一个输入参数行, 当这个命令在开头时, 打印输出文档的绝对路径名. |

```bash
chmod 755 ./params.sh

./params.sh 1 2 3
```

```bash
#!/bin/zsh

echo "执行的文件名：$0";
echo "参数个数：$#";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
echo "后台运行的最后一个进程的ID号：$!";
echo "进程ID号：$$";
```

### 运算符

###### 算数运算符

| 运算符 | 说明 | 举例 |
| :--: | -- | -- |
| + | 加法 | &#96;expr &#36;a + &#36;b&#96; 结果为 30。 |
| - | 减法 | &#96;expr &#36;a - &#36;b&#96; 结果为 -10。 |
| * | 乘法 | &#96;expr &#36;a &#92;* &#36;b&#96; 结果为  200。 |
| / | 除法 | &#96;expr &#36;b / &#36;a&#96; 结果为 2。 |
| % | 取余 | &#96;expr &#36;b % &#36;a&#96; 结果为 0。 |
| = | 赋值 | a=&#36;b 把变量 b 的值赋给 a。 |
| = ，== | 相等。用于比较两个数字，相同则返回 true。 | &#91; &#36;a = &#36;b &#93; 或者 (( a == b )) 返回 false。 |
| != | 不相等。用于比较两个数字，不相同则返回 true。 | &#91; &#36;a != &#36;b &#93; 返回 true。 |

```bash
# demo

a=10
b=20

val=`expr $a + $b`
echo "a + b : $val"

val=`expr $a - $b`
echo "a - b : $val"

val=`expr $a \* $b`
echo "a * b : $val"

val=`expr $b / $a`
echo "b / a : $val"

val=`expr $b % $a`
echo "b % a : $val"

if [ $a = $b ] # zsh 下不是 == 而是 = ，如果使用 == ，则 (( a == b ))
then
  echo "a 等于 b"
fi
if [ $a != $b ]
then
  echo "a 不等于 b"
fi

echo "a : $a"
echo "b : $b"
```

###### 关系运算符

| 运算符 | 说明 | 举例 |
| :--: | -- | -- |
| -eq | 检测两个数是否相等，相等返回 true。 |	&#91; &#36;a -eq &#36;b &#93; 返回 false。 |
| -ne | 检测两个数是否不相等，不相等返回 true。 |	&#91; &#36;a -ne &#36;b &#93; 返回 true。 |
| -gt | 检测左边的数是否大于右边的，如果是，则返回 true。 |	&#91; &#36;a -gt &#36;b &#93; 返回 false。 |
| -lt | 检测左边的数是否小于右边的，如果是，则返回 true。 |	&#91; &#36;a -lt &#36;b &#93; 返回 true。 |
| -ge | 检测左边的数是否大于等于右边的，如果是，则返回 true。 |	&#91; &#36;a -ge &#36;b &#93; 返回 false。 |
| -le | 检测左边的数是否小于等于右边的，如果是，则返回 true。 |	&#91; &#36;a -le &#36;b &#93; 返回 true。 |

```bash
# demo

a=10
b=20

if [ $a -eq $b ]
then
  echo "$a -eq $b : a 等于 b"
else
  echo "$a -eq $b: a 不等于 b"
fi
if [ $a -ne $b ]
then
  echo "$a -ne $b: a 不等于 b"
else
  echo "$a -ne $b : a 等于 b"
fi
if [ $a -gt $b ]
then
  echo "$a -gt $b: a 大于 b"
else
  echo "$a -gt $b: a 不大于 b"
fi
if [ $a -lt $b ]
then
  echo "$a -lt $b: a 小于 b"
else
  echo "$a -lt $b: a 不小于 b"
fi
if [ $a -ge $b ]
then
  echo "$a -ge $b: a 大于或等于 b"
else
  echo "$a -ge $b: a 小于 b"
fi
if [ $a -le $b ]
then
  echo "$a -le $b: a 小于或等于 b"
else
  echo "$a -le $b: a 大于 b"
fi
```

###### 布尔运算符

| 运算符 | 说明 | 举例 |
| :--: | -- | -- |
| ! | 非运算，表达式为 true 则返回 false，否则返回 true。 | &#91; ! false &#93; 返回 true。 |
| -o | 或运算，有一个表达式为 true 则返回 true。 | &#91; &#36;a -lt 20 -o &#36;b -gt 100 &#93; 返回 true。 |
| -a | 与运算，两个表达式都为 true 才返回 true。 | &#91; &#36;a -lt 20 -a &#36;b -gt 100 &#93; 返回 false。 |

```bash
# demo

a=10
b=20

if [ ! $a = $b ]
then
  echo "$a != $b : a 不等于 b"
else
  echo "$a == $b: a 等于 b"
fi
if [ $a -lt 100 -a $b -gt 15 ]
then
  echo "$a 小于 100 且 $b 大于 15 : 返回 true"
else
  echo "$a 小于 100 且 $b 大于 15 : 返回 false"
fi
if [ $a -lt 100 -o $b -gt 100 ]
then
  echo "$a 小于 100 或 $b 大于 100 : 返回 true"
else
  echo "$a 小于 100 或 $b 大于 100 : 返回 false"
fi
if [ $a -lt 5 -o $b -gt 100 ]
then
  echo "$a 小于 5 或 $b 大于 100 : 返回 true"
else
  echo "$a 小于 5 或 $b 大于 100 : 返回 false"
fi
```

###### 逻辑运算符

| 运算符 | 说明 | 举例 |
| :--: | -- | -- |
| &#38;&#38; | 逻辑的 AND | &#91;&#91; &#36;a -lt 100 &#38;&#38; &#36;b -gt 100 &#93;&#93; 返回 false |
| &#124;&#124; | 逻辑的 OR | &#91;&#91; &#36;a -lt 100 &#124;&#124; &#36;b -gt 100 &#93;&#93; 返回 true |

```bash
# demo

a=10
b=20

if [[ $a -lt 100 && $b -gt 100 ]]
then
  echo "返回 true"
else
  echo "返回 false"
fi

if [[ $a -lt 100 || $b -gt 100 ]]
then
  echo "返回 true"
else
  echo "返回 false"
fi
```

###### 字符串运算符

| 运算符 | 说明 | 举例 |
| :--: | -- | -- |
| = | 检测两个字符串是否相等，相等返回 true。 | &#91; &#36;a = &#36;b &#93; 返回 false。 |
| != | 检测两个字符串是否不相等，不相等返回 true。 | &#91; &#36;a != &#36;b &#93; 返回 true。 |
| -z | 检测字符串长度是否为0，为0返回 true。 | &#91; -z &#36;a &#93; 返回 false。 |
| -n | 检测字符串长度是否不为 0，不为 0 返回 true。 | &#91; -n "&#36;a" &#93; 返回 true。 |
| &#36; | 检测字符串是否不为空，不为空返回 true。 | &#91; &#36;a &#93; 返回 true。 |

```bash
# demo

a="abc"
b="efg"

if [ $a = $b ]
then
  echo "$a = $b : a 等于 b"
else
  echo "$a = $b: a 不等于 b"
fi
if [ $a != $b ]
then
  echo "$a != $b : a 不等于 b"
else
  echo "$a != $b: a 等于 b"
fi
if [ -z $a ]
then
  echo "-z $a : 字符串长度为 0"
else
  echo "-z $a : 字符串长度不为 0"
fi
if [ -n "$a" ]
then
  echo "-n $a : 字符串长度不为 0"
else
  echo "-n $a : 字符串长度为 0"
fi
if [ $a ]
then
  echo "$a : 字符串不为空"
else
  echo "$a : 字符串为空"
fi
```

###### 文件测试运算符

| 运算符 | 说明 | 举例 |
| :--: | -- | -- |
| -b file	| 检测文件是否是块设备文件，如果是，则返回 true。 | &#91; -b &#36;file &#93; 返回 false。 |
| -c file	| 检测文件是否是字符设备文件，如果是，则返回 true。 | &#91; -c &#36;file &#93; 返回 false。 |
| -d file	| 检测文件是否是目录，如果是，则返回 true。 | &#91; -d &#36;file &#93; 返回 false。 |
| -f file	| 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | &#91; -f &#36;file &#93; 返回 true。 |
| -g file	| 检测文件是否设置了 SGID 位，如果是，则返回 true。 | &#91; -g &#36;file &#93; 返回 false。 |
| -k file	| 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。 | &#91; -k &#36;file &#93; 返回 false。 |
| -p file	| 检测文件是否是有名管道，如果是，则返回 true。 | &#91; -p &#36;file &#93; 返回 false。 |
| -u file	| 检测文件是否设置了 SUID 位，如果是，则返回 true。 | &#91; -u &#36;file &#93; 返回 false。 |
| -r file	| 检测文件是否可读，如果是，则返回 true。 | &#91; -r &#36;file &#93; 返回 true。 |
| -w file	| 检测文件是否可写，如果是，则返回 true。 | &#91; -w &#36;file &#93; 返回 true。 |
| -x file	| 检测文件是否可执行，如果是，则返回 true。 | &#91; -x &#36;file &#93; 返回 true。 |
| -s file	| 检测文件是否为空（文件大小是否大于0），不为空返回 true。 | &#91; -s &#36;file &#93; 返回 true。 |
| -e file	| 检测文件（包括目录）是否存在，如果是，则返回 true。 | &#91; -e &#36;file &#93; 返回 true。 |

```bash
# demo

file="./arithmetic.sh"
if [ -r $file ]
then
  echo "文件可读"
else
  echo "文件不可读"
fi
if [ -w $file ]
then
  echo "文件可写"
else
  echo "文件不可写"
fi
if [ -x $file ]
then
  echo "文件可执行"
else
  echo "文件不可执行"
fi
if [ -f $file ]
then
  echo "文件为普通文件"
else
  echo "文件为特殊文件"
fi
if [ -d $file ]
then
  echo "文件是个目录"
else
  echo "文件不是个目录"
fi
if [ -s $file ]
then
  echo "文件不为空"
else
  echo "文件为空"
fi
if [ -e $file ]
then
  echo "文件存在"
else
  echo "文件不存在"
fi
```

### test 命令

###### 数值测试

| 参数 | 说明 |
| :--: | -- |
| -eq |	等于则为真 |
| -ne |	不等于则为真 |
| -gt |	大于则为真 |
| -ge |	大于等于则为真 |
| -lt |	小于则为真 |
| -le |	小于等于则为真 |

```bash
num1=100
num2=100
if test $[num1] -eq $[num2]
then
  echo '两个数相等！'
else
  echo '两个数不相等！'
fi
```

###### 字符串测试

| 参数 | 说明 |
| :--: | -- |
| = | 等于则为真 |
| != | 不相等则为真 |
| -z | 字符串	字符串的长度为零则为真 |
| -n | 字符串	字符串的长度不为零则为真 |

```bash
num1="abc"
num2="a1bc"
if test $num1 = $num2
then
  echo '两个字符串相等!'
else
  echo '两个字符串不相等!'
fi
```

###### 文件测试

| 参数 | 说明 |
| :--: | -- |
| -e 文件名 |	如果文件存在则为真 |
| -r 文件名 |	如果文件存在且可读则为真 |
| -w 文件名 |	如果文件存在且可写则为真 |
| -x 文件名 |	如果文件存在且可执行则为真 |
| -s 文件名 |	如果文件存在且至少有一个字符则为真 |
| -d 文件名 |	如果文件存在且为目录则为真 |
| -f 文件名 |	如果文件存在且为普通文件则为真 |
| -c 文件名 |	如果文件存在且为字符型特殊文件则为真 |
| -b 文件名 |	如果文件存在且为块特殊文件则为真 |

```bash
if test -e ./noFile
then
  echo '文件已存在!'
else
  echo '文件不存在!'
fi
```

### 流程控制

###### if else

```bash
# [...] 判断语句中，大于使用 -gt，小于使用 -lt
# ((...)) 判断语句中，大于和小于可以直接使用 > 和 <
# test 命令

# if
if condition
then
  command1 
  command2
  ...
  commandN 
fi

# if else
if condition
then
  command1 
  command2
  ...
  commandN
else
  command
fi

# if else-if else
if condition1
then
  command1
elif condition2 
then 
  command2
else
  commandN
fi
```

###### for 循环

```bash
for var in item1 item2 ... itemN
do
  command1
  command2
  ...
  commandN
done
```

```bash
# for demo 1
for loop in 1 2 3 4 5
do
  echo "The value is: $loop"
done

# for demo 2
for str in This is a string
do
  echo $str
done
```

###### while 语句

```bash
while condition
do
  command
done
```

```bash
i=1
sum=0
while ((i <= 100))
do
  ((sum += i))
  ((i++))
done
echo "The sum is: $sum"
```

###### 无限循环

```bash
while :
do
  command
done
```

```bash
while true
do
  command
done
```

```bash
for (( ; ; ))
```

###### until 循环

```bash
# until 循环执行一系列命令直至条件为 true 时停止
# until 循环与 while 循环在处理方式上刚好相反
until condition
do
  command
done
```

```bash
a=0

until [ ! $a -lt 10 ]
do
  echo $a
  a=`expr $a + 1`
done
```

###### case ... esac

```bash
# 类似于 switch ... case
# 每个 case 分支用右圆括号开始
# * 捕获未匹配
# 两个分号 ;; 表示 break
case 值 in
模式1)
  command1
  command2
  ...
  commandN
  ;;
模式2)
  command1
  command2
  ...
  commandN
  ;;
esac
```

```bash
num=2

case $num in
  1) echo "num is 1"
  ;;
  2|3) echo "num is $num" # 多个 case 用 | 隔开
  ;;
  4) echo "num is 4"
  ;;
esac
```

###### 跳出循环 break continue

```bash
#!/bin/zsh

# 需要在脚本文件中执行
while :
do
  echo -n "输入 1 到 5 之间的数字，输入 q 结束循环，其他输入跳过该次循环:"
  read aNum
  case $aNum in
    1|2|3|4|5) echo "你输入的数字为 $aNum!"
    ;;
    q) echo "结束循环"
      break
    ;;
    *) echo "跳过该次循环"
      continue
    ;;
  esac
done
```

### 函数

```bash
[ function ] funname [()]
{

  action;

  [return int;]
}
```

```bash
demoFun(){
  echo "这是我的第一个 shell 函数!"
}
demoFun
```

###### 函数参数

[参照 - 【参数传递】](#参数传递)

```bash
#!/bin/zsh

# 需要在脚本文件中执行
funWithParam(){
  echo "第一个参数为 $1 !"
  echo "第二个参数为 $2 !"
  echo "第十个参数为 $10 !"
  echo "第十个参数为 ${10} !"
  echo "第十一个参数为 ${11} !"
  echo "参数总数有 $# 个!"
}
funWithParam 1 2 3 4 5 6 7 8 9 10 11
```

### 一些操作

###### 查找指定目录下所有指定后缀的文件

```bash
read_dir(){
  for file in `ls -a $1`
  do
    if [ -d $1"/"$file ]
    then
      if [[ $file != '.' && $file != '..' ]]
      then
        read_dir $1"/"$file $2 $3
      fi
    else
      if [ "${file##*.}" = $2 ]
      then
        $3 $1"/"$file
      fi
    fi
  done
}
callback(){
  #echo $1
  #rm $1
  echo " -> $1"
}
# 支持通过回调函数的方式调用 callback
read_dir . txt callback
```

> 通常可以使用`find`命令查找指定文件 

```bash
# find [path] [expression]
find . -name "*.txt"

find ./_trash -name params.sh
```

```bash
read_dir(){
  for file in `find $1 -name "*.$2"`
  do
    $3 $file
  done
}
callback(){
  #echo $1
  #rm $1
  echo " -> $1"
}
# 支持通过回调函数的方式调用 callback
read_dir . txt callback
```

###### 连接远程服务器

> 如不支持`ssh`命令，需安装`Zlib` `openSSL` `openSSH`  
> 服务端需启动`sshd`服务，需要开发相关端口`22端口`  
> 21 → ftp  
> 22 → ssh  
> 23 → telnet  
> 25 → smtp 邮件发送服务  

```bash
# -p 短裤，默认为：22
ssh <USERNAME>@<IP> [-p <PORT>]
```

###### 远程拷贝文件

```bash
# -r： 递归复制整个目录
scp [-r] file_source file_target 

# 远程目录写法
<USERNAME>@<IP>:<ABSOLUTE PATH>

# file_target 为远程目录，从本地拷贝到远程服务器
scp ./shell.md root@<IP>:/root/
# file_source 为远程目录，从远程服务器拷贝到本地
scp root@<IP>:/root/shell.md ./ssh/
```

###### 修改文件内容

```bash
sed -i [-e <script>] [-f <script文件>] [文本文件]

# -i vi vim 的 i 命令，修改文件
# -e 后面跟脚步内容，-f 后面跟脚本文件
# script：
# a ：新增，a 后面可以接字串，而这些字串会在新的一行出现(目前的下一行)
# c ：取代，c 后面可以接字串，这些字串可以取代 n1,n2 之间的行
# d ：删除，d 后面通常不接任何内容
# i ：插入，i 后面可以接字串，而这些字串会在新的一行出现(目前的上一行)
# p ：打印，通常 p 会与参数 sed -n 一起运行
# s ：取代，通常这个 s 的动作可以搭配正则表达式，例如：s/old/new/g，/g 全局替换

sed -i -e "s/Hello/Hi/g" ./sed.txt
```

```bash
# demo
read_dir(){
  for file in `find $1 -name "*.$2"`
  do
    $3 $file
  done
}
callback(){
  sed -i -e "s/Hi/Hello/g" $1
}
read_dir . txt callback
```
