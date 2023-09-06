# 一、Linux基础命令


## Linux的目录结构

- ```
  - /，根目录是最顶级的目录即根目录
  - Linux只有一个顶级目录：/
  - 路径描述的层次关系同样适用/来表示
  - /home/itheima/a.txt，表示根目录下的home文件夹内有itheima文件夹，内有a.txt文件
  ```

  


## su(switch user)命令

```
功能：用户切换

语法：su - 用户名,如：普通用户切换到root用户：su - root

切换用户后，可以通过exit退回上一用户，也可使用快捷键ctrl+d 
```



## sudo命令

```
在我们得知root密码的时候，可以通过su命令切换到root或得最大权限。

但是我们不建议长期使用root用户，避免带来系统损坏。

此时，我们可以使用sudo命令，为普通的明令授权，临时以root身份执行

语法：sudo 其他命令

功能：在普通用户内，能让一条普通命令带有root权限
```




## ls命令

```
功能：列出文件夹信息

语法：ls [-l -h -a] [参数]
```



- ```shell
  - 参数：被查看的文件夹，如果不提供参数，表示查看当前工作目录
  - -l，(list)以列表形式查看
  - -h，配合-l，以更加人性化的方式显示文件大小
  - -a，(all)显示隐藏文件
  ```

  



### 隐藏文件、文件夹

```
在Linux中以  .  开头的，均是隐藏的。

默认不显示出来，需要  -a  选项才可查看到。
```



## pwd命令

```
功能：展示当前工作目录

语法：`pwd`(print work directory)
```



## cd命令

```
功能：切换工作目录

语法：`cd [目标目录]`(change directory)

参数：目标目录即要切换去的地方，如果不提供目标目录,默认切换到`当前登录用户HOME目录`,所以 cd 也直接有回到home目录的功能
```



## 什么是HOME目录

```
每一个用户在Linux系统中都有自己的专属工作目录，称之为HOME目录。

- 普通用户的HOME目录，默认在：`/home/用户名`

- root用户的HOME目录，在：`/root`



FinalShell登陆终端后，默认的工作目录就是用户的HOME目录
```



## 相对路径、绝对路径

- ```
  - 相对路径，不以`/`开头的称之为相对路径
  
    相对路径表示以`当前目录`作为起点，去描述路径，如`test/a.txt`，表示当前工作目录内的test文件夹内的a.txt文件
  
  - 绝对路径，以`/`开头的称之为绝对路径
  
    绝对路径从`根目录`开始描述路径
  ```

  




## 特殊路径符

```
1   .  表示当前目录，比如cd ./Desktop，表示切换到当前目录下的Desktop目录内
2  ..  表示上级目录，比如cd .. 表示回退一级，cd ../.. 表示回退两级,cd ../../.. 表示回退三级
3  ~ 表示用户的HOME目录即 【~ 等同于 /home/xiao】，比如cd ~/Desktop，等同于cd /home/xiao/Desktop
```



## mkdir命令(make directory)

```
功能：创建文件夹

语法：`mkdir [-p] 参数`

- 参数：被创建文件夹的路径
- 选项：-p，可选，表示创建多个层级的文件夹,比如要在home目录下创建一个test1文件夹后又要在test1文件夹内创建test2文件夹
  最后还要在test2文件夹内创建test3文件夹
  就可以输入命令 mkdir -p ~/test1/test2/test3
  如果不写-p的话会报错
  注意:目前mkdir命令请确保是在home目录内操作,因为创建文件夹需要修改权限,home目录之外的目录会涉及到权限问题

拓展:Ctrl + l 清空当前终端所有命令
```



## touch命令

- ```
  功能：创建文件
  
  语法：`touch 参数`
  
  - 参数：被创建的文件路径
  ```

  



## cat命令

- ```
  功能：查看文件内容
  
  语法：`cat 参数`
  
  - 参数：被查看的文件路径
  ```

  



## more命令

```
功能：查看文件，可以支持翻页查看

语法：`more 参数`

- 参数：被查看的文件路径
- 在查看过程中：
  - `空格`键翻页
  - `q`退出查看


```



## cp（copy）命令

```
功能：复制文件\文件夹

语法：`cp [-r] 参数1 参数2`

- 参数1，Linux路径，表示被复制的文件或文件夹
- 参数2，Linux路径，表示要复制去的地方
- 选项：-r，可选，用于复制文件夹使用

示例：

- cp a.txt b.txt，复制当前目录下a.txt为b.txt存在
- cp a.txt test/，复制当前目录a.txt到test文件夹内
- cp -r test test2，复制文件夹test到当前文件夹内为test2存在


```



## mv(move)命令

```
功能：移动文件\文件夹

语法：`mv 参数1 参数2`

- 参数1：Linux路径，被移动的文件\文件夹
- 参数2：Linux路径，要移动去的地方(参数2如果不存在，则实现了改名操作)


```



## rm（remove）命令


> ```
> 功能：删除文件\文件夹
> 
> 语法：`rm [-r -f] 参数1、参数2...参数N`
> 
> - 参数1、参数2...参数N：每一个表示要删除的文件\文件夹，用空格进行分隔
> - 选项：-r，删除文件夹使用
> - 选项：-f，强制删除，不会给出确认提示，一般root用户会用到
> 
> rm命令支持通配符*，用来做模糊匹配
> .符号*表示通配符，即匹配任意内容（包含空)，示例:
> . test*，表示匹配任何以test开头的内容【rm test* 表示删除当前路径下所有以test开头的文件】
> . *test，表示匹配任何以test结尾的内容【rm *test 表示删除当前路径下所有以test结尾的文件】
> . *test*，表示匹配任何包含test的内容【rm *test* 表示删除当前路径下所有含test的文件】
> 
> 
> > rm命令很危险，一定要注意，特别是切换到root用户的时候。
> ```



## which命令

```
功能：查看"命令"的程序本体文件路径

语法：`which 参数`

- 参数：被查看的命令 

如：which cd
	which pwd
	which mkdir
```

## find命令

```
功能：搜索文件

语法1 按文件名搜索文件：find 起始路径 -name “参数”

- 起始路径，搜索的起始路径
- 参数，搜索的关键字，支持通配符*，同 rm 命令， 比如：*test表示搜索任意以test结尾的文件

语法2 按文件大小搜索文件：find 起始路径 -size +或者-文件大小（带单位【k、M、G】）

如：
从根目录查找小于10kb的文件：find / -size -10k
从根目录查找大于100M的文件：find / -size +100M
从根目录查找大于1G的文件：find / -size +1G
```




## grep命令

> ```
> 功能：过滤关键字所在的行/行号
> 
> 语法：`grep [-n] "关键字" 文件路径`
> 
> - 选项-n，可选，表示在结果中显示匹配的行的行号。
> - 关键字，必填，表示过滤的关键字，带有空格或其它特殊符号，建议使用""将关键字包围起来
> - 文件路径，必填，表示要过滤内容的文件路径，可作为内容输入端口
> 
> 
> 
> > 参数文件路径，可以作为管道符的输入
> ```


## 管道符|

```
写法：`|`

功能：将符号左边的结果，作为符号右边的输入

示例：

`cat a.txt | grep itheima`，将cat a.txt的结果，作为grep命令的输入，用来过滤`itheima`关键字



可以支持嵌套：

`cat a.txt | grep itheima | grep itcast`
```

## wc命令

```
功能：统计文件的行数、单次数量等

语法：`wc [-c -m -l -w] 文件路径`

- 选项，-c，统计bytes数量
- 选项，-m，统计字符数量
- 选项，-l，统计行数
- 选项，-w，统计单词数量
- 文件路径，被统计的文件，可作为内容输入端口

wc 直接加文件路径，输出的三个数分别表示 行数、单词数、字节数

> 参数文件路径，可作为管道符的输入


```



## echo命令

- ```
  功能：在命令行内输出指定内容
  
  语法： echo ”参数“
  
  - 参数：被输出的内容,建议用双引号包围起来
  ```

  



## ’‘反引号

```
功能：被两个反引号包围的内容，会作为命令执行

示例：

- echo "当前工作路径为：`pwd`"，会输出当前工作目录


```



## tail命令

- ```
	功能：查看文件尾部内容
	
	语法：`tail [-f/-具体的数字] 参数`
	
	- 参数：Linux路径，被查看的文件
	- 选项：-f，表示持续跟踪文件修改
	  	-具体的数字,表示查看尾部多少行，不填默认10行
	```
	
	

## head命令

- ```
  功能：查看文件头部内容
  
  语法：`head [-具体的数字] 参数`
  
  - 参数：Linux路径，被查看的文件
  - 选项：-具体的数字，表示总共查看的行数
  ```

  

## 重定向符

- ```
  功能：将符号左边的结果，输出到右边指定的文件中去
  
  -  将符号左边的结果，覆盖写入到符号右侧指定文件中，如：echo "hello linux" > test.txt
  -  将符号左边的结果，追加写入到符号右侧指定文件中，如：echo "hello linux" >> test.txt
  ```

  

## chmod命令

```
功能：修改文件、文件夹权限

语法1：`chmod [-R] 权限 参数`

- 选项-R，可选，对文件夹内所有内容应用相同规则

- 权限，用数字代表

权限的数字序号

4 代表 r（read可读）吗，2 代表 w(write可写)，1 代表 x（excute可执行）

rwx的相互结合可以得到从0~7的8种权限组合
```

![image-20230806120344558](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120344558.png)

- ```
  如：755（7=4+2+1=rwx,5=4+1=r-x），表示：`rwxr-xr-x`
  
  - 参数，被修改的文件、文件夹
  
  
  
  
  语法2：`chmod [-R] 权限 参数`
  
  - 权限：u=rwx,g=rx,o=rw，其中u==user，g==group，o==other
  ```

  


## chown命令

```
功能：修改文件、文件夹所属用户和用户组

限制：普通用户无法修改所属用户和用户组，因此此命令只适用于root用户执行

语法：`chown [-R] [用户][:][用户组] 文件或文件夹`

-R：同chmod,对文件夹内所有内容应用相同规则

用: 修改所属用户

:用户组 修改所属用户组

：，用于分隔用户和用户组

示例：
chown root hello.txt,将hello.txt所属用户修改为root用户

chown :root hello.txt，将hello.txt所属用户组修改为root用户

chown root:xiao hello.txt，将hello.txt所属用户修改为root用户，用户组修改为xiao用户

chown -R root test，将文件夹test的所属用户修改为root用户并对文件夹内全部内容应用同样规则
```

![image-20230806120408986](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120408986.png)


## 用户组管理

![image-20230806120427528](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120427528.png)



## 用户管理

![image-20230806120446227](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120446227.png)



## getent命令

- ```
  `getent group`，查看系统全部的用户组
  ```

  

![image-20230806120502651](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120502651.png)

- ```
  `getent passwd`，查看系统全部的用户
  ```

  

![image-20230806120517015](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120517015.png)



## env命令

```
查看系统全部的环境变量

语法：`env`
```



## vi编辑器

### 命令模式快捷键

![image-20230806120537909](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120537909.png)

![image-20230806120552399](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120552399.png)

![image-20230806120607433](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120607433.png)

### 底线命令快捷键

![image-20230806120622616](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120622616.png)

## help 命令

功能：查看命令的帮助手册

![image-20230806123003229](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806123003229.png)

## man命令

```
功能：`man 命令`查看某命令的详细手册
```




## 命令的选项

```
我们学习的一系列Linux命令，它们所拥有的选项都是非常多的。

比如，简单的ls命令就有：-a -A -b -c -C -d -D -f -F -g -G -h -H -i -I -k -l -L -m -n -N -o -p -q -Q -r-R -s -S -t -T -u -U -v -w -x -X -1等选项，可以发现选项是极其多的。

课程中， 并不会将全部的选项都进行讲解，否则，一个ls命令就可能讲解2小时之久。

课程中，会对常见的选项进行讲解， 足够满足绝大多数的学习、工作场景。
```

## 快捷操作

- ```shell
  - 强制停止
  
  语法：Ctrl+c
  
  功能：1、强制停止正在运行的程序
  	  2、假如某个命令输错，可以通过Ctrl+c实现退出当前输入，从下一行重新输入
  	  
  
  - 强制退出
  
  语法：ctrl+d
  
  功能：1、退出账户的登录，比如想从root用户退回到普通用户
        2、退出某些特定程序的专属页面
  	  
  
  - 历史命令搜索
  
  语法：history
  
  功能：查看历史输入过的命令
  
  
  - 光标移动
  
  ctrl+a，跳过命令开头
  
  ctrl+e，跳过命令结尾
  
  ctrl+键盘左键，向左跳一个单词
  
  ctrl+键盘右键，向右跳一个单词
  
  
  - 清屏
  
  语法：ctrl+l
  
  ```
  
- 

## yum命令

```
语法：yum [-y] [install remove search] 软件名称

功能：通过Linux自带的应用商城下载软件，相当于windoes系统里里面通过自带的应用商城下载软件
```

```shell
- y 表示自动确认，无需手动确认安装或者卸载过程
- install 安装
- remove 卸载
- search 搜索
```

```
限制：yum命令需要root权限，可以su切换到root，或者用sudo提权，且yum命令需要联网使用
```



## systemctl

```
功能：控制系统服务的启动、停止、开机自启等

语法：`systemctl start | stop | restart | disable | enable | status 服务名`
```

- ```shell
  - start，启动
  - stop，停止
  - status，查看状态
  - disable，关闭开机自启
  - enable，开启开机自启
  - restart，重启
  ```

  

```
系统内置的服务比较多，比如：

NetworkManager,主网络服务

network,副网络服务

firewalld，防火墙服务

sshd,ssh服务

除了内置的服务外，部分第三方软件安装后也可以以systemctl进行控制，因为这些软件会自动集成到systemctl中。

还有部分软件没有自动集成到systemctl中，我们需要手动添加。


```

## ln 命令

- ```
  功能：创建文件、文件夹软链接（类似Windows系统中的快捷方式）
  
  语法：`ln -s 参数1 参数2`
  
  - -s：必选，表示创建软链接
  - 参数1：被链接的文件或者文件夹
  - 参数2：要链接去的地方
  ```

  



## date命令

```shell
语法：`date [-d] [+格式化字符串]`

功能：在命令行中查看系统的的时间

- -d 按照给定的字符串显示日期，一般用于日期计算

- 格式化字符串：通过特定的字符串标记，来控制显示的日期格式
  - %Y   年
  - %y   年份后两位数字 (00..99)
  - %m   月份 (01..12)
  - %d   日 (01..31)
  - %H   小时 (00..23)
  - %M   分钟 (00..59)
  - %S   秒 (00..60)
  - %s   自 1970-01-01 00:00:00 UTC 到现在的秒数


```

示例：

- 按照2022-01-01的格式显示日期

![image-20230806120827817](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120827817.png)

- 按照2022-01-01 10:00:00的格式显示日期

![image-20230806120844699](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120844699.png)

- -d选项日期计算

![image-20230806120858311](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120858311.png)

  - 支持的时间标记为：

![image-20230806120915227](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120915227.png)





## 修改时区（要使用root用户）

修改时区为中国时区

![image-20230806120934817](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806120934817.png)



## ntp程序

```
功能：自动校准时间

安装：`yum install -y ntp`

启动管理：`systemctl start | stop | restart | status | disable | enable ntpd`



手动校准时间：`ntpdate -u ntp.aliyun.com`
```



## ip地址

```
格式：a.b.c.d

- abcd为0~255的数字，如192.168.10.1

- 可以通过ifconfig命令来查看本机IP地址



特殊IP：

- 127.0.0.1，指代本机
- 0.0.0.0
  - 可以指代本机
  - 也可以表示任意IP（看使用场景）

```

## ifconfig

```
功能：查看本机IP地址
```



## hostname

```
功能：查看Linux系统的名称

语法：`hostname`


设置主机名语法：`hostnamectl set-hostname 主机名`
```



## 配置VMware固定IP

1. 修改VMware网络，参阅PPT，图太多

2. 设置Linux内部固定IP

   修改文件：`/etc/sysconfig/network-scripts/ifcfg-ens33`

   示例文件内容：

   ```shell
   TYPE="Ethernet"
   PROXY_METHOD="none"
   BROWSER_ONLY="no"
   BOOTPROTO="static"			# 改为static，固定IP
   DEFROUTE="yes"
   IPV4_FAILURE_FATAL="no"
   IPV6INIT="yes"
   IPV6_AUTOCONF="yes"
   IPV6_DEFROUTE="yes"
   IPV6_FAILURE_FATAL="no"
   IPV6_ADDR_GEN_MODE="stable-privacy"
   NAME="ens33"
   UUID="1b0011cb-0d2e-4eaa-8a11-af7d50ebc876"
   DEVICE="ens33"
   ONBOOT="yes"
   IPADDR="192.168.88.131"		# IP地址，自己设置，要匹配网络范围
   NETMASK="255.255.255.0"		# 子网掩码，固定写法255.255.255.0
   GATEWAY="192.168.88.2"		# 网关，要和VMware中配置的一致
   DNS1="192.168.88.2"			# DNS1服务器，和网关一致即可
   ```

## 什么是进程？

```
程序运行在操作系统中，是被操作系统所管理的。

为管理运行的程序，每一个程序在运行的时候,便被操作系统注册为系统中的一个进程并会为每一个进程都分配一个独有的进程ID(进程号)

Windows系统可以通过任务管理器来查看进程信息
```


​      
## ps命令

```
语法: ps [-e -f]

选项:-e,显示出全部的进程

选项:-f,以完全格式化的形式展示信息（展示全部信息一般来说，固定用法就是:ps -ef列出全部进程的全部信息）

ps命令还可搭配管道符实用，如：ps -ef | grep 某个命令
```



## kill命令

```
在windows系统中，可以通过任务管理器选择进程后，点击结束进程从而关闭它。同样，在Linux中，可以通过kill命令关闭进程。

语法: kill [-9] 进程ID

选项: -9,表示强制关闭进程。不使用此选项会向进程发送信号要求其关闭，但是否关闭看进程自身的处理机制。
```

![image-20230806123511457](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806123511457.png)

## 什么是端口?

```
端口是指计算机和外部交互的出入口，可以分为物理端口和虚拟端口

·物理端口:USB、HDMI、DP、VGA、RJ45等

·虚拟端口:操作系统和外部交互的出入口

IP只能确定计算机,通过端口才能锁定要交互的程序（IP相当于小区，端口相当于各家门的牌号）
```



## 端口的划分

```
·公认端口:1~1023,用于系统内置或常用知名软件绑定使用

·注册端口:1024~49151,用于松散绑定使用(用户自定义)

·动态端口:49152~65535，用于临时使用(多用于出口)
```




## nmap命令

```
功能：查看当前系统内端口占用情况（有哪些端口被占用了）

语法：nmap 被查看的IP地址
```

![image-20230806121007949](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121007949.png)


## netstat命令

```
功能：查看指定端口占用情况

语法：`netstat -anp | grep 端口号`
```



## ping命令

```
功能：检查网络是否联通

语法：`ping [-c 具体的数字] 参数`

-c 具体的数字 ,检查的次数，如 -c 3 表示检查3次。

若不使用-具体的数字将检查无限次，此时可通过ctrl+c来停止检查

参数，IP地址或者主机名
```

![image-20230806121041845](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121041845.png)



## wget命令

```
（和yum类似，wget可以理解为Windows系统里在浏览器里下载软件，而yum相当于Windows系统里在自带的应用商城下载软件）

功能：在命令行内下载网络文件

语法：wget [-b] url

选项：-b,可选，表示后台下载

参数：url,表示下载链接 
```

![image-20230806121100279](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121100279.png)


## curl命令

```
功能：下载文件、获取信息

语法：curl [-O] url

选项：可选，用于下载文件，当url是下载链接时，可以使用此选项表示存文件，此时同wget url，不加-O相当于打开某个网站的网页

参数：url，要求发起请求的网络地址
```

![image-20230806121122900](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121122900.png)

![image-20230806121138055](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121138055.png)



## top命令

```
功能：查看Linux系统内cup、内存使用情况，类似于Windows系统里的任务管理器

语法：`top` 

按q或者ctrl+c退出


top命令也支持选项:

选项功能

-p只显示某个进程的信息

-d设置刷新时间，默认是5s

-c显示产生进程的完整命令，默认是进程名

-n指定刷新次数，比如top -n 3，刷新输出3次后退出

-b以非交互非全屏模式运行，以批次的方式执行top，一般配合-n指定输出几次统计信息，将输出重定向到指定文件，

比如 top -b -n 3 > /tmp/top.tmp

-i不显示任何闲置(idle)或无用(zombie)的进程-u查找特定用户启动的进程


可用选项：
```

![image-20230806121157500](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121157500.png)



交互式模式中，可用快捷键：

![image-20230806121223825](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121223825.png)



## df命令

```
功能：查看磁盘使用率

语法：df [-h]

选项:-h,以更人性化的单位显示
```

![image-20230806121241490](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121241490.png)



## iostat命令

```
功能：查看CPU、磁盘的相关信息，查看磁盘速率等信息

语法:iostat [-x] [num1] [num2]

选项:-x，可选，显示更多信息

num1:可选，数字，刷新间隔, num2:可选，数字，刷新几次
```

![image-20230806121257470](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121322034.png)



## sar命令

```
网络状态监控

功能：查看网络情况(sar命令非常复杂，这里仅简单用于统计网络)

语法: sar -n DEV num1 num2

选项:-n,查看网络，DEV表示查看网络接口

num1:可选，刷新间隔（不填就查看一次结束) , num2:可选，查看次数（不填无限次数)，同iostat中的num1，num2
```


![image-20230806121338626](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806121338626.png)



## 环境变量  

- ```
  - 临时设置，语法：export 变量名=变量值
  
  - 永久设置：
    - 针对当前用户生效，配置在当前用户的：`~/.bashrc`文件中(vi ~/.bashrc)
    - 针对所有用户生效，配置在系统的`/etc/profile`文件中(vi /etc/profile)
    - 并通过语法：‘source 配置文件’，进行立即生效，或重新登录finalshell生效
  
  
  ```

  


### PATH变量

```
记录了执行程序的搜索路径

可以将自定义路径加入PATH内，实现自定义命令在任意地方均可执行的效果
```



### $符号

```
可以取出指定的环境变量的值

语法：`$变量名`

示例：

`echo $PATH`，输出PATH环境变量的值

`echo ${PATH}ABC`，输出PATH环境变量的值以及ABC

如果变量名和其它内容混淆在一起，可以使用${}
```




## 压缩、解压

```
Linux和Mac系统常用有2种压缩格式，后缀名分别是:

.tar,称之为tarball,归档文件,即简单的将文件组装到一个.tar的文件内，并没有太多文件体积的减少，仅仅是简单的封装

.gZ，也常见为.tar.gz,gzip格式压缩文件,即使用gzip压缩算法将文件压缩到一个文件内,可以极大的减少压缩后的体积

针对这两种格式,使用tar命令均可以进行压缩和解压缩的操作

语法: 

tar [-c -v -x -f -z -C] 参数1 参数2 ... 参数N

-c,创建压缩文件，用于压缩模式

-v,显示压缩、解压过程，用于查看进度

-f,要创建的文件，或要解压的文件，-f选项必须在所有选项中位置处于最后一个

-z, gzip模式,不使用-z就是普通的tarball格式

-x,解压模式

-C,选择解压的目的地，用于解压模式


常用压缩组合为:

tar -cvf test.tar 1.txt 2.txt 3.txt 

表示将1.txt 2.txt 3.txt压缩到test.tar文件内

tar -zcvf test.tar.gz 1.txt 2.txt 3.txt

表示将1.txt 2.txt 3.txt使用gzip模式压缩到test.tar.gz文件内

注意:

-z选项如果使用的话，一般处于选项位第一个

-f选项，必须在选项位最后一个
```




### 解压

```
常用的解压组合为：

tar -xvf test.tar

表示解压test.tar,将文件解压至当前目录

tar -xvf test.tar -C /home/itheima

表示解压test.tar,将文件解压至指定目录(/home/itheima)

tar -zxvf test.tar.gz -C /home/itheima

表示以gzip模式解压test.tar.gz,将文件解压至指定目录( /home/itheima)

注意:

-f选项，必须在选项组合体的最后一位

对于解压的话

-z选项，建议在开头位置

-C选项单独使用，和解压所需的其它参数分开




zip命令压缩文件

可以使用zip命令，压缩文件为zip压缩包语法: 

zip [-r] 参数1 参数2 ... 参数N

-r，被压缩的包含文件夹的时候，需要使用-r选项，和rm、cp等命令的-r效果一致

示例:

zip test.zip a.txt b.txt c.txt

表示将a.txt b.txt c.txt压缩到test.zip文件内

zip -r test.zip test itheima a.txt

表示将test、itheima两个文件夹和a.txt文件，压缩到test.zip文件内
```




### 解压

```
unzip命令解压文件

使用unzip命令，可以方便的解压zip压缩包语法: 

unzip [-d] 参数

-d,指定要解压去的位置，同tar的-C选项

参数，被解压的zip压缩包文件

示例:

unzip test.zip,表示将test.zip解压到当前目录

unzip test.zip -d /home/itheima,表示将test.zip解压到指定文件夹(/home/itheima)内
```



## scp命令

```shell
scp [-r] 参数1 参数2

- -r选项用于复制文件夹使用，如果复制文件夹，必须使用-r
- 参数1：本机路径 或 远程目标路径
- 参数2：远程目标路径 或 本机路径

如：
scp -r /export/server/jdk root@node2:/export/server/
将本机上的jdk文件夹， 以root的身份复制到node2的/export/server/内
同SSH登陆一样，账户名可以省略（使用本机当前的同名账户登陆）

如：
scp -r node2:/export/server/jdk /export/server/
将远程node2的jdk文件夹，复制到本机的/export/server/内
```




### scp命令的高级用法
```shell
cd /export/server
scp -r jdk node2:`pwd`/    # 将本机当前路径的jdk文件夹，复制到node2服务器的同名路径下
scp -r jdk node2:$PWD      # 将本机当前路径的jdk文件夹，复制到node2服务器的同名路径下
```

## rz命令

```
功能：用于从本地计算机向远程计算机上传文件
```

## reboot命令

```
功能：重启服务器
```

## shutdown命令

```shell
语法：shutdown -h now
功能：服务器关机
```

## 启动集群的Hdfs、yarn
```
start-all.sh
```

## 启动单台服务器的hdfs命令
```
start-dfs.sh
```

## 启动单台服务器的yarn命令
```
start-yarn.sh
```

## 启动hive客户端命令
```shell
cd /export/server/hive

# 首先启动metastore元数据管理服务
nohup bin/hive --service metastore >> logs/metastore.log 2>&1 &

# 再启动客户端hiveserver2服务
nohup bin/hive --service hiveserver2 >> logs/hiveserver2.log 2>&1 &
```



## 启动spark客户端命令
```shell
cd /export/server/spark
sbin/start-thriftserver.sh \
--hiveconf hive.server2.thrift.port=10000 \
--hiveconf hive.server2.thrift.bind.host=node1 \
--master local[*]
#master选择local,每一条sql都是local进程执行
#master选择yarn,每一条sql都是在YARN集群中执行
```

## 进入MySQL命令

```shell
mysql -uroot -p
```

