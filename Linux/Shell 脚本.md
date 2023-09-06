# 一、Shell 脚本

```
说白了就是自己写一个命令实现某种功能
```

## 1）脚本格式 

```shell
脚本以
	#!/bin/bash 
开头（指定解析器Centos 默认的解析器是 bash）
```

## 2）第一个 Shell 脚本：helloworld.sh 

（1）需求：创建一个 Shell 脚本，输出 helloworld 

（2）案例实操：

```shell
[atguigu@hadoop101 shells]$ touch helloworld.sh
[atguigu@hadoop101 shells]$ vim helloworld.sh

在 helloworld.sh 中输入如下内容
#!/bin/bash
echo "helloworld"
```



## 3）脚本的常用执行方式

### 第一种：

```
采用 bash 或 sh+脚本的相对路径或绝对路径（不用赋予脚本+x 权限）
```

![image-20230812171213314](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812171213314.png)

### 第二种：

```
采用输入脚本的绝对路径或相对路径执行脚本（必须具有可执行权限+x）
```

![image-20230812171345593](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812171345593.png)

### 注意：

![image-20230812171411380](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812171411380.png)

# 二、shell脚本语法

## 变量

### 1）系统预定义变量

```shell
$HOME、$PWD、$SHELL、$USER

$HOME：表示当前用户的主目录，即用户登录后所在的起始目录。在终端中输入 echo $HOME 可以显示当前用户的主目录路径。

$PWD：表示当前工作目录，即用户当前所在的目录路径。在终端中输入 echo $PWD 可以显示当前工作目录的路径。

$SHELL：表示当前用户所使用的 shell（命令行解释器）的路径。在终端中输入 echo $SHELL 可以显示当前 shell 的路径，例如 /bin/bash 表示使用的是 Bash shell。

$USER：表示当前登录的用户名。在终端中输入 echo $USER 可以显示当前登录的用户名。
```



### 2）自定义变量

#### 变量定义规则

```
（1）变量名称可以由字母、数字和下划线组成，但是不能以数字开头，环境变量名建
议大写。
（2）等号两侧不能有空格
（3）在 bash 中，变量默认类型都是字符串类型，无法直接进行数值运算。
（4）变量的值如果有空格，需要使用双引号或单引号括起来。
```

#### 基本语法

```
（1）定义变量：变量名=变量值，注意，=号前后不能有空格
（2）撤销变量：unset 变量名
（3）声明静态变量：readonly 变量，注意：不能 unset
```

#### 案例实操

![image-20230813131948252](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230813131948252.png)

![image-20230813132006104](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230813132006104.png)

![image-20230813132021672](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230813132021672.png)

### 3）特殊变量

```shell
$n 、$# 、$* 、$@ 、$?
```

#### $n 

```shell
功能：n 为数字，$0 代表该脚本名称，$1-$9 代表命令行中第一到第九个参数，十以上的参数需要用大括号包含，如${10}
```

```shell
(base) [root@node1 my_shells]# vim test.sh 

#!/bin/bash
echo '==========$n=========='
echo $0
echo $1
echo $2

(base) [root@node1 my_shells]# sh test.sh a b
=====================
test.sh
a
b
=====================
```



#### $# 

```
功能：获取所有输入参数个数
```

```shell
(base) [root@node1 my_shells]# vim test.sh 

#!/bin/bash
echo '==========$n=========='
echo $0
echo $1
echo $2
echo '==========$#=========='
echo $#

(base) [root@node1 my_shells]# sh test.sh a b c
=====================
test.sh
a
b
=====================
3
```



#### $* 、$@ 

```shell
功能：$*和$@都表示传递给函数或脚本的所有参数

	不被双引号""包含时，都以$1 $2 …$n的形式输出所有参数。

	当它们被双引号""包含时，
		$*会将所有的参数作为一个整体，以“$1 $2 …$n”的形式输出所有参数；
		$@会将各个参数分开，以“$1” “$2”…“$n”的形式输出所有参数。

```

```shell
演示不被双引号""包含时
[atguigu@hadoop101 shells]$ touch for3.sh
[atguigu@hadoop101 shells]$ vim for3.sh

#!/bin/bash
echo '=============$*============='
for i in $*
do
echo "ban zhang love $i"
done
echo '=============$@============='
for j in $@
do
echo "ban zhang love $j"
done

[atguigu@hadoop101 shells]$ chmod 777 for3.sh
[atguigu@hadoop101 shells]$ ./for3.sh cls mly wls
=============$*=============
banzhang love cls
banzhang love mly
banzhang love wls
=============$@=============
banzhang love cls
banzhang love mly
banzhang love wls
```

```shell
演示被双引号""包含时
[atguigu@hadoop101 shells]$ vim for4.sh

#!/bin/bash
echo '=============$*============='
for i in "$*"
#$*中的所有参数看成是一个整体，所以这个 for 循环只会循环一次
do
echo "ban zhang love $i"
done
echo '=============$@============='
for j in "$@"
#$@中的每个参数都看成是独立的，所以“$@”中有几个参数，就会循环几次
do
echo "ban zhang love $j"
done

[atguigu@hadoop101 shells]$ chmod 777 for4.sh
[atguigu@hadoop101 shells]$ ./for4.sh cls mly wls
=============$*=============
banzhang love cls mly wls
=============$@=============
banzhang love cls
banzhang love mly
```



#### $?

```
功能：最后一次执行的命令的返回状态。
	如果这个变量的值为 0，证明上一个命令正确执行；
	如果这个变量的值为非 0（具体是哪个数，由命令自己来决定），则证明上一个命令执行不正确了。
```

```shell
(base) [root@node1 my_shells]# vim HelloWord.sh

#!/bin/bash
echo "HelloWorld!"

(base) [root@node1 my_shells]# sh HelloWord.sh 
HelloWorld!
(base) [root@node1 my_shells]# echo $?
0
(base) [root@node1 my_shells]# sh helloword
sh: helloword: 没有那个文件或目录
(base) [root@node1 my_shells]# echo $?
127

```

## 运算符

### 1）基本语法

```shell
在 bash 中，变量默认类型都是字符串类型，无法直接进行数值运算。如果要运算需要加特殊符号包裹

“$((运算式))” 或 “$[运算式]”

计算（2+3）* 4 的值
[atguigu@hadoop101 shells]# S=$[(2+3)*4]
[atguigu@hadoop101 shells]# echo $S
```

## 条件判断

```
1）基本语法
（1）test condition
（2）[ condition ]（注意 condition 前后要有空格）
注意：条件非空即为 true，[ atguigu ]返回 true，[ ] 返回 false。

2）常用判断条件
（1）两个整数之间比较
-eq 等于（equal） 			-ne 不等于（not equal）
-lt 小于（less than） 		-le 小于等于（less equal）
-gt 大于（greater than） 	-ge 大于等于（greater equal）
注：如果是字符串之间的比较 ，用等号“=”判断相等；用“!=”判断不等。

（2）按照文件权限进行判断
-r 有读的权限（read）
-w 有写的权限（write）
-x 有执行的权限（execute）

（3）按照文件类型进行判断
-e 文件存在（existence）
-f 文件存在并且是一个常规的文件（file）
-d 文件存在并且是一个目录（directory）
```

```shell

3）案例实操
（1）23 是否大于等于 22
[atguigu@hadoop101 shells]$ [ 23 -ge 22 ]
[atguigu@hadoop101 shells]$ echo $?
0

（2）helloworld.sh 是否具有写权限
[atguigu@hadoop101 shells]$ [ -w helloworld.sh ]
[atguigu@hadoop101 shells]$ echo $?
0

（3）/home/atguigu/cls.txt 目录中的文件是否存在
[atguigu@hadoop101 shells]$ [ -e /home/atguigu/cls.txt ]
[atguigu@hadoop101 shells]$ echo $?
1

（4）多条件判断（&& 表示前一条命令执行成功时，才执行后一条命令，|| 表示上一
条命令执行失败后，才执行下一条命令）
[atguigu@hadoop101 ~]$ [ atguigu ] && echo OK || echo notOK
OK
[atguigu@hadoop101 shells]$ [ ] && echo OK || echo notOK
notOK
```

### 1）if 判断

![image-20230814151533384](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230814151533384.png)

```shell
2）案例实操
(base) [root@node1 my_shells]# touch if.sh
(base) [root@node1 my_shells]# vim if.sh 

#!/bin/bash

if [ $1 -eq 1 ]
then
        echo "湖人"
elif [ $1 -eq 2 ]
then
        echo "总"
else
        echo "冠军"
fi

(base) [root@node1 my_shells]# sh if.sh 1
湖人
(base) [root@node1 my_shells]# sh if.sh 2
总
(base) [root@node1 my_shells]# sh if.sh 3
冠军

```



### 2）case 语句

```shell
1）基本语法

case $变量名 in
"值 1")
如果变量的值等于值 1，则执行程序 1
;;
"值 2")
如果变量的值等于值 2，则执行程序 2
;;
…省略其他分支…
*)
如果变量的值都不是以上的值，则执行此程序
;;
esac

注意事项：
（1）case 行尾必须为单词“in”，每一个模式匹配必须以右括号“）”结束。
（2）双分号“;;”表示命令序列结束，相当于 java 中的 break。
（3）最后的“*）”表示默认模式，相当于 java 中的 default
```

```shell
2）案例实操
(base) [root@node1 my_shells]# touch case.sh
(base) [root@node1 my_shells]# vim case.sh 

#!/bin/bash

case $1 in
"1")
echo "周一工作"
;;
"2")
echo "周二工作"
;;
"3")
echo "周三工作"
;;
"4")
echo "周四工作"
;;
"5")
echo "周五工作"
;;
"6")
echo "周六出去玩"
;;
"7")
echo "周日出去玩"
;;
*)
echo "哪有周{$1}啊"
;;
esac

(base) [root@node1 my_shells]# sh case.sh 3
周三工作
(base) [root@node1 my_shells]# sh case.sh 6
周六出去玩
(base) [root@node1 my_shells]# sh case.sh 7
周日出去玩
(base) [root@node1 my_shells]# sh case.sh 8
哪有周{8}啊
```



## 循环

### 1）for循环

#### 基本语法 1

```shell
1）基本语法 1
for ((初始值;循环控制条件;变量变化))
do
	程序
done
```

```shell

2）案例实操
从 1 加到 100
[atguigu@hadoop101 shells]$ touch for1.sh
[atguigu@hadoop101 shells]$ vim for1.sh

#!/bin/bash
sum=0
for((i=0;i<=100;i++))
do
	sum=$[$sum+$i]
done
echo $sum

[atguigu@hadoop101 shells]$ chmod 777 for1.sh
[atguigu@hadoop101 shells]$ ./for1.sh
5050
```

#### 基本语法 2

```shell
3）基本语法 2 (功能和Python的for很像)
for 变量 in 值 1 值 2 值 3…
do
	程序
done
```

```shell

4）案例实操
(base) [root@node1 my_shells]# touch for2.sh
(base) [root@node1 my_shells]# vim fro2.sh

#!/bin/bash

for i in linux mysql hadoop hive spark python
do
	echo $i
done

(base) [root@node1 my_shells]# sh fro2.sh 
linux
mysql
hadoop
hive
spark
python
```



### 2）while循环

```shell
1）基本语法
while [ 条件判断式 ]
do
	程序
done
```

```shell
2）案例实操
从 1 加到 100
[atguigu@hadoop101 shells]$ touch while.sh
[atguigu@hadoop101 shells]$ vim while.sh

#!/bin/bash
sum=0
i=1
while [ $i -le 100 ]
do
	sum=$[$sum+$i]
	i=$[$i+1]
done
echo $sum

[atguigu@hadoop101 shells]$ chmod 777 while.sh
[atguigu@hadoop101 shells]$ ./while.sh
5050
```

## read 

```
功能：读取控制台输入的内容

1）基本语法
	read (选项) (参数)
	选项：
		-p：指定读取值时的提示符；
		-t：指定读取值时等待的时间（秒）如果-t不加表示一直等待
	参数：
		变量：指定读取值的变量名
```

```shell
提示 7 秒内，读取控制台输入的名称
[atguigu@hadoop101 shells]$ touch read.sh
[atguigu@hadoop101 shells]$ vim read.sh

#!/bin/bash
read -t 7 -p "Enter your name in 7 seconds :" a
echo $a

[atguigu@hadoop101 shells]$ ./read.sh
Enter your name in 7 seconds : atguigu
atguigu
```

## 函数

### 1）系统函数

```
系统函数本质上是Linux提供的命令
```

#### basename

```shell
功能：basename 命令会删掉所有的前缀包括最后一个（‘/’）字符，然后将字符串显示出来。

	basename可以理解为取路径里的文件名称,本质上是字符串的剪切

1）基本语法
basename string|path suffix
suffix 为后缀，如果 suffix 被指定了，basename 会将 path 或 string 中的 suffix 去掉。
```

```shell
截取该/home/atguigu/banzhang.txt 路径的文件名称。
[atguigu@hadoop101 shells]$ basename /home/atguigu/banzhang.txt
banzhang.txt
[atguigu@hadoop101 shells]$ basename /home/atguigu/banzhang.txt .txt
banzhang
```

#### dirname

```
功能描述：从给定的包含绝对路径的文件名中去除文件名（非目录的部分），然后返回剩下的路径（目录的部分））

	dirname 可以理解为取文件路径的绝对路径名称,本质上是字符串的剪切
	
1）基本语法
dirname 文件的绝对路径
```

```shell
获取 banzhang.txt 文件的路径。
[atguigu@hadoop101 ~]$ dirname /home/atguigu/banzhang.txt
/home/atguigu
```

```shell
如果在脚本内调用系统函数：
	$(系统函数|命令)
```



### 2）自定义函数

```shell
1）基本语法
[ function ] 函数名[()]
{
	函数体;
	[return int;]
}

# []表示里面的内容可写可不写

# 注意:Linux自定义的函数是不写参数的,也就是说在 函数名[()] ()里面为空或者直接不写(),但是并不是说不传参数,linux默认传参的方式是命令行传入,$1就表示传入的第一个参数,$2就表示传入的第二个参数

```

```shell
3）案例实操
计算两个输入参数的和。
[atguigu@hadoop101 shells]$ touch fun.sh
[atguigu@hadoop101 shells]$ vim fun.sh

#!/bin/bash
function sum()
{
	s=$[$1+$2]
	echo "$s"
}

read -p "Please input the number1: " n1;
read -p "Please input the number2: " n2;
sum $n1 $n2;

[atguigu@hadoop101 shells]$ chmod 777 fun.sh
[atguigu@hadoop101 shells]$ ./fun.sh
Please input the number1: 2
Please input the number2: 5
7
```

## 正则表达式

```
本质上是模糊匹配
使用单个字符串来描述、匹配一系列符合某个语法规则的字符串。
```

### 常规匹配

```shell
# 匹配所有包含 atguigu 的行
[atguigu@hadoop101 shells]$ cat /etc/passwd | grep atguigu 
```



### 特殊字符匹配

#### 1）特殊字符：^

```shell
功能：匹配一行的开头

# 匹配所有以 a 开头的行
[atguigu@hadoop101 shells]$ cat /etc/passwd | grep ^a
```



#### 2）特殊字符：$

```shell
功能：匹配一行的结尾

# 会匹配所有以 t 结尾的
[atguigu@hadoop101 shells]$ cat /etc/passwd | grep t$
```



#### 3）特殊字符：.

```shell
功能： . 代表一个任意字符

# 匹配所有r..t的行
[atguigu@hadoop101 shells]$ cat /etc/passwd | grep r..t
```



#### 4）特殊字符：*

```shell
功能：不单独使用，他和上一个字符连用，表示匹配上一个字符 0 次或多次

# 匹配 rt, rot, root, rooot, roooot
[atguigu@hadoop101 shells]$ cat /etc/passwd | grep ro*t
```



#### 5）字符区间（中括号）：[ ]

```shell
[ ] 表示匹配某个范围内的一个字符，例如
[6,8]------匹配 6 或者 8
[0-9]------匹配一个 0-9 的数字
[0-9]*------匹配任意长度的数字字符串
[a-z]------匹配一个 a-z 之间的字符
[a-z]* ------匹配任意长度的字母字符串
[a-c, e-f]-匹配 a-c 或者 e-f 之间的任意字符
```



#### 6）特殊字符：\

```shell
功能：匹配特殊字符

[atguigu@hadoop101 shells]$ cat /etc/passwd | grep ‘a\$b’ 
# 就会匹配所有包含 a$b 的行。注意需要使用单引号将表达式
```

## 文本处理工具

### cut命令

```
功能：在文件中负责剪切数据用的。
```

```
1）基本用法
cut [选项参数] filename
说明：默认分隔符是制表符

2）选项参数说明
-f 列号，提取第几列
-d 分隔符，按照指定分隔符分割列，默认是制表符“\t”
-c 按字符进行切割 后加加 n 表示取第几列 比如 -c 1
```

```shell
[atguigu@hadoop101 shells]$ touch cut.txt
[atguigu@hadoop101 shells]$ vim cut.txt

dong shen hu
guan zhen ren
wo wo zong
lai lai guan
le le jun

切割 cut.txt 第一列
[atguigu@hadoop101 shells]$ cut -d " " -f 1 cut.txt
dong
guan
wo
lai
le

切割 cut.txt 第二、三列
[atguigu@hadoop101 shells]$ cut -d " " -f 2,3 cut.txt
shen hu
zhen ren
wo zong
lai guan
le jun

在 cut.txt 文件中切割出 guan
[atguigu@hadoop101 shells]$ cat cut.txt | grep guan | cut -d " " -f 1
guan
```

### awk命令

```
功能：
```









