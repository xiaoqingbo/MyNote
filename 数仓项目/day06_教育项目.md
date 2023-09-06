# day06_教育项目课程笔记

今日内容:

* 1. 访问咨询主题看板_增量的流程 (操作)

     1.1: 数据的采集

     1.2: 数据的清洗转换处理

     1.3: 数据的统计分析处理

     1.4: 数据的导出操作

  2. 意向用户主题看板_需求分析 (重点理解, 能够自己尝试分析出来)
  3. 意向用户主题看板_业务数据准备工作
  4. 意向用户主题看板_建模分析 (重点理解, 能够自己尝试分析出来)

## 1. 教育项目的数仓分层

回顾: 原有的基础分层

```properties
ODS层: 源数据层
	作用: 对接数据源, 和数据源的数据保持相同的粒度(将数据源的数据完整的拷贝到ODS层中)
	注意:
		如果数据来源于文本文件, 可能会需要先对这些文本文件进行预处理(spark)操作, 将其中不规则的数据, 不完整的数据, 脏乱差的数据先过滤掉, 将其转换为一份结构化的数据, 然后灌入到ODS层
DW层:  数据仓库层
	作用:  进行数据分析的操作
DA层:  数据应用层
	作用: 存储DW层分析的结果, 用于对接后续的应用(图表, 推荐系统...)
```

教育数仓中:

```properties
ODS层: 源数据层
	作用: 对接数据源, 和数据源的数据保持相同的粒度(将数据源的数据完整的拷贝到ODS层中)
	注意:
		如果数据来源于文本文件, 可能会需要先对这些文本文件进行预处理(spark)操作, 将其中不规则的数据, 不完整的数据, 脏乱差的数据先过滤掉, 将其转换为一份结构化的数据, 然后灌入到ODS层
	
	一般放置 事实表数据和少量的维度表数据
DW层:  数据仓库层
	DWD层: 明细层
		作用: 用于对ODS层数据进行清洗转换工作 , 以及进行少量的维度退化操作
				少量: 
					1) 将多个事实表的数据合并为一个事实表操作
					2) 如果维度表放置在ODS层 一般也是在DWD层完成维度退化
	DWM层: 中间层
		作用:  1) 用于进行维度退化操作  2) 用于进行提前聚合操作(周期快照事实表)
	DWS层: 业务层
		作用: 进行细化维度统计分析操作
DA层:  数据应用层
	作用: 存储基于DWS层再次分析的结果, 用于对接后续的应用(图表, 推荐系统...)
	例如:
		比如DWS层的数据表完成了基于订单表各项统计结果信息,  但是图表只需要其中销售额, 此时从DWS层将销售额的数据提取出来存储到DA层

DIM层: 维度层
	作用: 存储维度表数据


什么叫做维度退化: 是为了减少维度表的关联工作
	做法: 将数据分析中可能在维度表中需要使用的字段, 将这些字段退化到事实表中, 这样后续在基于维度统计的时候, 就不需要在关联维度表, 事实表中已经涵盖了维度数据了
	例如:	订单表, 原有订单表中只有用户id, 当我们需要根据用户维度进行统计分析的时候, 此时需要关联用户表, 找到用户的名称, 那么如果我们提前将用户的名称放置到订单表中, 那么是不是就不需要关联用户表, 而则就是维度退化
	
	好处: 减少后续分析的表关联情况
	弊端: 造成数据冗余
```



## 2. 数仓工具的使用

### 2.1 HUE相关的使用

​		HUE:  hadoop 用户体验  

​		出现目的: 提升使用hadoop生态圈中相关软件便利性

​		核心: 是将各类hadoop生态圈的软件的操作界面集成在一个软件中 (大集成者)



* 如何HUE界面呢?

![image-20210923100816102](day06_教育项目.assets/image-20210923100816102.png)

![image-20210923100849937](day06_教育项目.assets/image-20210923100849937.png)



### 2.2 HUE操作OOZIE

什么是oozie:

```properties
	Oozie是一个用于管理Apache Hadoop作业的工作流调度程序系统。
	Oozie由Cloudera公司贡献给Apache的基于工作流引擎的开源框架,是用于Hadoop平台的开源的工作流调度引擎,是用来管理Hadoop作业,属于web应用程序，由Oozie client和Oozie Server两个组件构成,Oozie Server运行于Java Servlet容器（Tomcat）中的web程序。
```

什么是工作流呢?

```properties
	工作流（Workflow），指“业务过程的部分或整体在计算机应用环境下的自动化”。
```

能够使用工作流完成的业务一般具有什么特点呢?

```properties
1) 整个业务流程需要周期性重复干
2) 整个业务流程可以被划分为多个阶段
3) 每一个阶段存在依赖关系,前序没有操作, 后续也无法执行

如果发现实际生产中的某些业务满足了以上特征, 就可以尝试使用工作流来解决
```

请问, 大数据的工作流程是否可以使用工作流来解决呢? 完全可以的

![image-20210923103934187](day06_教育项目.assets/image-20210923103934187.png)

请问: 如何实现一个工作流呢? 已经有爱心人士将工作流软件实现了, 只需要学习如何使用这些软件配置工作流程即可

```properties
单独使用:
	azkaban: 来源于领英公司  配置工作流的方式是通过类似于properties文件的方式来配置, 只需要简单的几行即可配置,提供了一个非常的好可视化界面, 通过界面可以对工作流进行监控管理, 号称 只要能够被shell所执行, azkaban都可以进行调度, 所以azkaban就是一个shell客户端软件

	oozie: 来源于apache 出现时间较早一款工作流调度工具, 整个工作流的配置主要采用XML方式进行配置, 整个XML配置是非常繁琐的, 如果配置一个MR, 相当于将MR重写一遍, 而且虽然提供了一个管理界面, 但是这个界面仅能查看, 无法进行操作, 而且界面异常卡顿

总结:
	azkaban要比oozie更加好用
	

如何和HUE结合使用:
	azkaban由于不属于apache旗下, 所以无法和HUE集成
	hue是属于apache旗下的, 所以HUE像集成一款工作流的调度工具, 肯定优先集成自家产品
	ooize也是属于apache旗下的, HUE对oozie是可以直接集成的, 集成之后, 只需要用户通过鼠标的方式点一点即可实现工作流的配置
	
总结:
	hue加入后, oozie要比azkaban更加好用
```

oozie本质是将工作流翻译为MR程序来运行



### 2.3 sqoop相关的操作

​		sqoop是隶属于Apache旗下的, 最早是属于cloudera公司的,是一个用户进行数据的导入导出的工具, 主要是将关系型的数据库(MySQL, oracle...)导入到hadoop生态圈(HDFS,HIVE,Hbase...) , 以及将hadoop生态圈数据导出到关系型数据库中

![image-20210923112856681](day06_教育项目.assets/image-20210923112856681.png)

将导入或导出命令翻译成mapreduce程序来实现。



通过sqoop将数据导入到HIVE主要有二种方式:  原生API 和 hcatalog API

```properties
数据格式支持:
	原生API 仅支持 textFile格式
	hcatalog API 支持多种hive的存储格式(textFile ORC sequenceFile parquet...)

数据覆盖:
	原生API 支持数据覆盖操作
	hcatalog API 不支持数据覆盖,每一次都是追加操作

字段名:
	原生API: 字段名比较随意, 更多关注字段的顺序, 会将关系型数据库的第一个字段给hive表的第一个字段...
	hcatalog API: 按照字段名进行导入操作, 不关心顺序
	建议: 在导入的时候, 不管是顺序还是名字都保持一致
```

目前主要采用 hcatalog的方式



#### 2.3.1 sqoop的基本操作

* sqoop help    查看命令帮助文档

![image-20210923114333124](day06_教育项目.assets/image-20210923114333124.png)

* sqoop list-databases --help  查看某一个命令帮助文档
* 如何查看mysql中有那些库呢?

```shell
命令:
	sqoop list-databases --connect jdbc:mysql://192.168.52.150:3306 --username root --password 123456
```

![image-20210923114721667](day06_教育项目.assets/image-20210923114721667.png)

* 如何查看mysql中hue数据库下所有的表呢?

```shell
命令:
sqoop list-tables \
--connect jdbc:mysql://192.168.52.150:3306/hue \
--username root \
--password 123456 


注意:
	\ 表示当前命令没有写完, 换行书写
```

![image-20210923114952205](day06_教育项目.assets/image-20210923114952205.png)

#### 2.3.2 sqoop的数据导入操作

* 数据准备工作 : mysql中执行

```sql
create database test default character set utf8mb4 collate utf8mb4_unicode_ci;
use test;

create table emp
(
    id     int         not null
        primary key,
    name   varchar(32) null,
    deg    varchar(32) null,
    salary int         null,
    dept   varchar(32) null
);

INSERT INTO emp (id, name, deg, salary, dept) VALUES (1201, 'gopal', 'manager', 50000, 'TP');
INSERT INTO emp (id, name, deg, salary, dept) VALUES (1202, 'manisha', 'Proof reader', 50000, 'TP');
INSERT INTO emp (id, name, deg, salary, dept) VALUES (1203, 'khalil', 'php dev', 30000, 'AC');
INSERT INTO emp (id, name, deg, salary, dept) VALUES (1204, 'prasanth', 'php dev', 30000, 'AC');
INSERT INTO emp (id, name, deg, salary, dept) VALUES (1205, 'kranthi', 'admin', 20000, 'TP');

create table emp_add
(
    id     int         not null
        primary key,
    hno    varchar(32) null,
    street varchar(32) null,
    city   varchar(32) null
);

INSERT INTO emp_add (id, hno, street, city) VALUES (1201, '288A', 'vgiri', 'jublee');
INSERT INTO emp_add (id, hno, street, city) VALUES (1202, '108I', 'aoc', 'sec-bad');
INSERT INTO emp_add (id, hno, street, city) VALUES (1203, '144Z', 'pgutta', 'hyd');
INSERT INTO emp_add (id, hno, street, city) VALUES (1204, '78B', 'old city', 'sec-bad');
INSERT INTO emp_add (id, hno, street, city) VALUES (1205, '720X', 'hitec', 'sec-bad');

create table emp_conn
(
    id    int         not null
        primary key,
    phno  varchar(32) null,
    email varchar(32) null
);

INSERT INTO emp_conn (id, phno, email) VALUES (1201, '2356742', 'gopal@tp.com');
INSERT INTO emp_conn (id, phno, email) VALUES (1202, '1661663', 'manisha@tp.com');
INSERT INTO emp_conn (id, phno, email) VALUES (1203, '8887776', 'khalil@ac.com');
INSERT INTO emp_conn (id, phno, email) VALUES (1204, '9988774', 'prasanth@ac.com');
INSERT INTO emp_conn (id, phno, email) VALUES (1205, '1231231', 'kranthi@tp.com');
```

* 第一个: 如何将数据从mysql中导入到HDFS中 (全量)  

```shell
以emp表为例:

命令1:
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp

说明:
	默认情况下, 会将数据导入到操作sqoop用户的HDFS的家目录下,在此目录下会创建一个以导入表的表名为名称文件夹, 在此文件夹下莫每一条数据会运行一个mapTask, 数据的默认分隔符号为 逗号
	
思考: 是否更改其默认的位置呢?
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp \
--delete-target-dir \
--target-dir '/sqoop_works/emp_1'

思考: 是否调整map的数量呢?
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp \
--delete-target-dir \
--target-dir '/sqoop_works/emp_2' \
--split-by id \
-m 2 

思考: 是否调整默认分隔符号呢? 比如调整为 \001
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp \
--fields-terminated-by '\001' \
--delete-target-dir \
--target-dir '/sqoop_works/emp_3' \
-m 1 
```

* 第二个: 全量导入数据到Hive中

```sql
以emp_add 表为例

第一步: 在HIVE中创建一个目标表
create database hivesqoop;
use hivesqoop;
create table hivesqoop.emp_add_hive(
	id  int,
	hno string,
	street string,
	city string
) 
row format delimited fields terminated by '\t'
stored as  orc ;

第二步: 通过sqoop完成数据导入操作
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp_add \
--hcatalog-database hivesqoop \
--hcatalog-table emp_add_hive \
-m 1 
```

* 第三个: 如何进行条件导入到HDFS中

```sql
-- 以emp 表为例

方式一: 通过 where的方式
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp \
--where 'id > 1205' \
--delete-target-dir \
--target-dir '/sqoop_works/emp_2' \
--split-by id \
-m 2 

方式二: 通过SQL的方式
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--query 'select deg  from emp where 1=1 AND \$CONDITIONS' \
--delete-target-dir \
--target-dir '/sqoop_works/emp_4' \
--split-by id \
-m 1 

注意: 
	如果SQL语句使用 双引号包裹,  $CONDITIONS前面需要将一个\进行转义, 单引号是不需要的
```

* 第四个: 如何通过条件的方式导入到hive中 (后续模拟增量导入数据)

```sql
-- 以 emp_add

sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp_add \
--where 'id > 1205' \
--hcatalog-database hivesqoop \
--hcatalog-table emp_add_hive \
-m 1 

或者:
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--query 'select * from emp_add where id>1205 and $CONDITIONS'
--hcatalog-database hivesqoop \
--hcatalog-table emp_add_hive \
-m 1 
```

#### 2.3.3 sqoop的数据导出操作

需求: 将hive中  emp_add_hive 表数据导出到MySQL中

```shell
# 第一步: 在mysql中创建目标表 (必须创建)
create table test.emp_add_mysql(
	id     INT  ,
    hno    VARCHAR(32) NULL,
    street VARCHAR(32) NULL,
    city   VARCHAR(32) NULL
);

# 第二步: 执行sqoop命令导出数据
sqoop export \
--connect jdbc:mysql://192.168.52.150:3306/test \
--username root \
--password 123456 \
--table emp_add_mysql \
--hcatalog-database hivesqoop \
--hcatalog-table emp_add_hive \
-m 1 


存在问题: 如果hive中表数据存在中文, 通过上述sqoop命令, 会出现中文乱码的问题
```

#### 2.3.4 sqoop相关常用参数

| 参数                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| --connect                                                    | 连接关系型数据库的URL                                        |
| --username                                                   | 连接数据库的用户名                                           |
| --password                                                   | 连接数据库的密码                                             |
| --driver                                                     | JDBC的driver class                                           |
| --query或--e <statement>                                     | 将查询结果的数据导入，使用时必须伴随参--target-dir，--hcatalog-table，如果查询中有where条件，则条件后必须加上$CONDITIONS关键字。  如果使用双引号包含sql，则$CONDITIONS前要加上\以完成转义：\$CONDITIONS |
| --hcatalog-database                                          | 指定HCatalog表的数据库名称。如果未指定，default则使用默认数据库名称。提供 --hcatalog-database不带选项--hcatalog-table是错误的。 |
| --hcatalog-table                                             | 此选项的参数值为HCatalog表名。该--hcatalog-table选项的存在表示导入或导出作业是使用HCatalog表完成的，并且是HCatalog作业的必需选项。 |
| --create-hcatalog-table                                      | 此选项指定在导入数据时是否应自动创建HCatalog表。表名将与转换为小写的数据库表名相同。 |
| --hcatalog-storage-stanza 'stored as orc  tblproperties ("orc.compress"="SNAPPY")' \ | 建表时追加存储格式到建表语句中，tblproperties修改表的属性，这里设置orc的压缩格式为SNAPPY |
| -m                                                           | 指定并行处理的MapReduce任务数量。  -m不为1时，需要用split-by指定分片字段进行并行导入，尽量指定int型。 |
| --split-by id                                                | 如果指定-split by, 必须使用$CONDITIONS关键字, 双引号的查询语句还要加\ |
| --hcatalog-partition-keys  --hcatalog-partition-values       | keys和values必须同时存在，相当于指定静态分区。允许将多个键和值提供为静态分区键。多个选项值之间用，（逗号）分隔。比如：  --hcatalog-partition-keys year,month,day  --hcatalog-partition-values 1999,12,31 |
| --null-string '\\N'  --null-non-string '\\N'                 | 指定mysql数据为空值时用什么符号存储，null-string针对string类型的NULL值处理，--null-non-string针对非string类型的NULL值处理 |
| --hive-drop-import-delims                                    | 设置无视字符串中的分割符（hcatalog默认开启）                 |
| --fields-terminated-by '\t'                                  | 设置字段分隔符                                               |



## 3. 访问咨询主题看板_全量流程

### 3.1 访问咨询主题看板_需求分析

​		将调研需求转换为开发需求

```properties
如何转换呢? 
	将每一个需求中涉及到维度以及涉及到指标从需求中分析出来, 同时找到涉及到那些表, 以及那些字段

目的:
	涉及维度
	涉及指标
	涉及表
	涉及字段

在此基础上, 还需要找到需要清洗那些数据, 需要转换那些数据, 如果有多个表, 表与表关联条件是什么...
```

* 需求一:  统计指定时间段内，访问客户的总数量。能够下钻到小时数据。

```properties
涉及维度:
	时间维度 : 年 季度  月  天 小时
涉及指标: 
	访问量
	
涉及到表:
	web_chat_ems_2019_12 (事实表)
涉及到字段:
	时间维度:  create_time
		转换操作: 将create_time后期转换为 yearinfo , quarterinfo,monthinfo,dayinfo,hourinfo
		思想: 当发现一个字段中涵盖多个字段的数据时候, 可以尝试将其拆分出来
	指标字段:  sid
    	说明: 先去重在统计操作
```

* 需求二: 统计指定时间段内，访问客户中各区域人数热力图。能够下钻到小时数据。

```properties
涉及维度:
	时间维度: 年 季度  月  天 小时
	区域维度:

涉及指标:
	访问量

涉及到表:	
	web_chat_ems_2019_12 
	
涉及到字段:
	时间维度: create_time
	区域维度: area
	指标字段: sid
```

* 需求三: 统计指定时间段内，不同地区（省、市）访问的客户中发起咨询的人数占比；

  咨询率=发起咨询的人数/访问客户量；客户与网咨有说一句话的称为有效咨询。

```properties
涉及维度:
	时间维度:  年 季度  月  天
	地区维度:

涉及指标:
	咨询人数
	访问量 (在需求二中已经计算完成了, 此处可以省略)

涉及到表:
	web_chat_ems_2019_12

涉及到字段:
	时间维度: create_time
    地区维度: area
	指标字段: sid
	区分咨询人数: msg_count 必须 >= 1

说明:
	当遇到指标需要计算比率问题的, 一般的处理方案是只需要计算其分子和分母的指标, 在最后DWS以及DA层进行统计计算
```

* 需求四: 统计指定时间段内，每日客户访问量/咨询率双轴趋势图。能够下钻到小时数据。

```properties
涉及维度:
	时间维度: 年 季度  月 天 小时

涉及指标:
	访问量 (需求一, 已经计算完成, 不需要关心)
	咨询人数

涉及到表:
	web_chat_ems_2019_12

涉及到字段:
	时间维度: create_time
	指标字段: sid
	区分咨询人数: msg_count 必须 >= 1
	
```

* 需求五: 统计指定时间段内，1-24h之间，每个时间段的访问客户量。

  横轴：1-24h，间隔为一小时，纵轴：指定时间段内同一小时内的总访问客户量。

```properties
涉及维度:
	时间维度: 天 小时
涉及指标:
	访问量  (需求一, 已经实现了)
```

* 需求六: 统计指定时间段内，不同来源渠道的访问客户量占比。能够下钻到小时数据。

  占比: 

  ​         各个渠道访问量 / 总访问量 

  ​		 **各个渠道下  咨询量/访问量占比**

```properties
涉及维度:
	时间维度: 年 季度 月  天 小时
	各个渠道
涉及指标:
	咨询量
	访问量
	
涉及表:
	web_chat_ems_2019_12
涉及字段: 
	各个渠道字段:  origin_channel
	时间维度: create_time
	指标: sid

访问量和咨询量的划分: 
	msg_count >= 1
```

* 需求七: 统计指定时间段内，不同搜索来源的访问客户量占比。能够下钻到小时数据。

  占比: 

  ​		**各个搜索来源访问量 / 总访问量**

  ​		各个搜索来源下 咨询量 / 各个搜索来源访问量 

```properties
涉及维度:
	时间维度: 年 季度 月  天 小时
	不同搜索来源

涉及指标:
	访问量

涉及表:
	web_chat_ems_2019_12
涉及字段:
	搜索来源:  seo_source
	时间维度:  create_time
	指标字段:  sid
```

* 需求八: 统计指定时间段内，产生访问客户量最多的页面排行榜TOPN。能够下钻到小时数据。

```properties
涉及维度:
	时间维度: 年 季度 月  天 小时
	各个页面
涉及指标:
	访问量

涉及表:
	web_chat_text_ems_2019_11 (事实表)

涉及字段:
	各个页面: from_url
	指标字段: count(1)

缺失: 时间维度字段


解决方案:
	1) 查看这个表中是否有时间字段
	2) 如果没有, 这个表是否另一个表有关联
	3) 如果都解决不了, 找需求方
```



汇总:

```properties
涉及维度:
	固有维度: 
		时间维度: 年 季度 月 天 小时
	产品属性维度:
		地区维度
		来源渠道
		搜索来源
		受访页面

涉及指标: 
	访问量
	咨询量
	
	
涉及表 : 
	事实表: web_chat_ems_2019_12 和 web_chat_text_ems_2019_11 
	维度表: 没有 (数仓建模, 不需要DIM层)

涉及字段: 
	时间维度: 
		web_chat_ems: create_time
	地区维度: 
		web_chat_ems:  area
	来源渠道:
		web_chat_ems: origin_channel
	搜索来源:
		web_chat_ems: seo_source
	受访页面:
		web_chat_text_ems: from_url
	指标字段: 
		访问量: sid
		咨询量: sid

	区分访问和咨询:  
		web_chat_ems: msg_count >= 1 即为咨询数据

需要清洗数据: 没有清洗
	
需要转换字段: 时间字段
	需要将create_time 转换为 yearinfo, quarterinfo,monthinfo,dayinfo,hourinfo
	
一对一关系 :  id = id
	一对一关系其实本质就是一张表
```

### 3.2 访问咨询主题看板_业务数据准备

两个表关系图:

![image-20210923171012891](day06_教育项目.assets/image-20210923171012891.png)

第一步: 在hadoop01的mysql中建一个数据库

```sql
create database nev default character set utf8mb4 collate utf8mb4_unicode_ci;
```

第二步: 将项目资料中 nev.sql 脚本数据导入到nev数据库中

![image-20210923171301669](day06_教育项目.assets/image-20210923171301669.png)

![image-20210923171334825](day06_教育项目.assets/image-20210923171334825.png)

![image-20210923171434399](day06_教育项目.assets/image-20210923171434399.png)

结果数据:

![image-20210923171516733](day06_教育项目.assets/image-20210923171516733.png)



此准备工作在实际生产环境中是不存在的...



### 3.3 访问咨询主题看板_建模分析

​		建模: 如何在hive中构建各个层次的表

* ODS层: 源数据层

```properties
作用: 对接数据源, 一般和数据源保持相同的粒度(将数据源数据完整的拷贝到ODS层)

建表比较简单: 
	业务库中对应表有那些字段, 需要在ODS层建一个与之相同字段的表即可, 额外在建表的时候, 需要构建为分区表, 分区字段为时间字段, 用于标记在何年何月何日将数据抽取到ODS层
	
此层会有二个表
```

* DIM层: 维度层

```properties
作用: 存储维度表数据

此时不需要, 因为当前主题, 压根没有维度表
```

* DWD层: 明细层

```properties
作用:  1) 清洗转换    2) 少量维度退化

思考1: 当前需要做什么清洗操作?
	 不需要进行清洗

思考2: 当前需要做什么转换操作?
	需要对时间字段进行转换, 需要转换为  yearinfo, quarterinfo,monthinfo,dayinfo,hourinfo

思考3: 当前需要做什么维度退化操作?
	两个事实表合并在一起
	
建表字段 : 原有表的字段 + 转换后的字段+ 清洗后字段
	sid,session_id,ip,create_time,area,origin_channel,seo_source,
	from_url,msg_count,yearinfo,quarterinfo,monthinfo,dayinfo,
	hourinfo,referrer,landing_page_url,url_title,
	platform_description,other_params,history

思想:
	当合并表个表的时候, 获取抽取数据时候, 处理方案有三种:
	1) 当表中字段比较多的时候, 只需要抽取需要用的字段
	2) 当无法确定需要用那些字段的时候, 采用全部抽取
	3) 如果表中字段比较少, 不管用得上, 还是用不上, 都抽取
```

* DWM层:  中间层  (省略)

```properties
作用: 1) 维度退化操作  2) 提前聚合

思考1: 当前需要进行什么维度退化操作?
	没有任何维度退化操作, 压根都没有DIM层
	
思考2: 当前需要进行什么提前聚合操作?
	可以尝试先对小时进行提前聚合操作, 以便于后统计方便
	

思考3: 当前主题是否可以按照小时提前聚合呢? 
	目前不可以, 因为数据存在重复的问题, 无法提前聚合, 一旦聚合后, 会导致后续的统计出现不精确问题
```

![image-20210923175927877](day06_教育项目.assets/image-20210923175927877.png)



* DWS层: 业务层

```properties
作用: 细化维度统计操作

一般是一个指标会对应一个统计结果表


访问量: 
	涉及维度:
		固有维度: 
			时间维度: 年 季度 月 天 小时
		产品属性维度:
			地区维度
			来源渠道
			搜索来源
			受访页面

建表字段: 指标统计字段 + 各个维度字段 + 三个经验字段(time_type,group_time,time_str)
	sid_total,sessionid_total,ip_total,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,
	area,origin_channel,seo_source,from_url, time_type,group_time,time_str



咨询量:
	涉及维度:
		固有维度: 
			时间维度: 年 季度 月 天 小时
		产品属性维度:
			地区维度
			来源渠道

建表字段: 指标统计字段 + 各个维度字段 + 三个经验字段(time_type,group_time,time_str)
	sid_total,sessionid_total,ip_total,yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,
	area,origin_channel, time_type,group_time,time_str


注意: 如果不存在的维度字段的值, 设置为 -1 (业务指定, 表示没有这个维度)
```

* DA层:

```properties
作用: 对接应用, 应用需要什么数据, 从DWS层获取什么数据即可

此层目前不做任何处理, 已经全部需要都细化统计完成了, 后续具体用什么, 看图表支持了...
```



### 3.4 访问咨询主题看板_建模操作

​	思考: 在创建表的时候, 需要考虑那些问题呢?

```properties
1) 表需要采用什么存储格式
2) 表需要采用什么压缩格式
3) 表需要构建什么类型表
```

#### 3.4.1 数据存储格式和压缩方案

存储格式选择:  

```properties
情况一: 如果数据不是来源于普通文本文件的数据, 一般存储格式选择为列式的ORC存储
情况二: 如果数据来源于普通文本文件的数据, 一般存储格式选择为行式的textFile格式

当前项目: 数据是存储在mysql中, 选择为ORC存储格式
```

压缩方案选择:

```properties
写多,读少: 优先考虑压缩比  建议选择 zlib  gz
写多,读多: 优先考虑解压缩性能  建议选择 snappy  LZO

如果空间比较充足, 建议各个层次都选择snappy压缩方案

一般情况下:
	hive中ODS层, 选择 zlib压缩方案
	hive中其他层次, 选择 snappy

当前项目: 
	ODS: zlib
	其他层次:  snappy
```

最终:

ODS: orc + zlib

其他层次: orc + snappy

#### 3.4.2 全量和增量

​		在进行数据统计分析的时候, 一般来说, 第一次统计分析都是全量统计分析 而后续的操作, 都是在结果基础上进行增量化统计操作

```properties
全量统计:  需要面对公司所有的数据进行统计分析, 数据体量一般比较大的
	解决方案: 采用分批次执行(比如按年)

增量统计:  一般是以T+1模式统计, 当前的数据, 在第二天才会进行统计操作
	每一天都是统计上一天的数据
```

#### 3.4.3 hive分区

​		后续的hive中构建表大部分的表都是分区表

```properties
思考: 分区表有什么作用呢? 
	当查询的时候, 指定分区字段, 可以减少查询表数据扫描量, 从而提升效率
```

回顾: 内部表和外部表如何选择呢?

```properties
	判断当前这份数据是否具有绝对的控制权
```

如何向分区表添加数据呢?

```properties
1) 静态分区:
	格式:
		load data [local] inpath '路径' into table 表名 partition(分区字段=值...)
		insert into  table  表名  partition(分区字段=值....) + select语句

2) 动态分区:
	格式:
		insert into  table  表名  partition(分区字段1,分区字段2....) + select语句
	
	注意事项: 
		1) 必须开启hive对动态分区的支持:
		2) 必须开启hive的非严格模式
		3) 保证select语句的最后的字段必须是分区字段数据(保证顺序)
			insert into table order partition(yearinfo,monthinfo,dayinfo)
				select .... yearinfo,monthinfo,dayinfo from  xxx;

3) 动静混合:
	格式:
		insert into  table  表名  partition(分区字段1,分区字段2=值1,分区字段3....) + select语句
	
	注意事项:
		1) 必须开启hive对动态分区的支持:
		2) 必须开启hive的非严格模式
		3) 保证select语句的最后的字段必须是动态分区字段数据(保证顺序)
			insert into table order partition(yearinfo,monthinfo='05',dayinfo)
				select .... yearinfo,dayinfo from  xxx;
```



动态分区的优化点:  有序动态分区

```
什么时候需要优化? 
	有时候表中动态分区比较多, hive提升写入效率, 会启动多个reduce程序进行并行写入操作, 此时对内存消耗比较大, 有可能会出现内存溢出问题

解决方案: 开启有序动态分区
	开启后, reduce不会再并行运行了, 只会运行一个, 大大降低了内存消耗, 从而能够正常的运行完成,但是效率会降低
	
	需要在CM的hive的配置窗口下, 开启此配置
	
注意: 目前不改, 后续出现动态分区问题后, 在尝试开启

通过CM更改, 是全局更改, 是全局有效的, 相当于直接在hive-site.xml中更改
```

![image-20210924101102462](day06_教育项目.assets/image-20210924101102462.png)

#### 3.4.4 建模操作

* ODS层:

```sql
CREATE DATABASE IF NOT EXISTS `itcast_ods`;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

-- 访问咨询表
CREATE EXTERNAL TABLE IF NOT EXISTS itcast_ods.web_chat_ems (
  id INT comment '主键',
  create_date_time STRING comment '数据创建时间',
  session_id STRING comment '七陌sessionId',
  sid STRING comment '访客id',
  create_time STRING comment '会话创建时间',
  seo_source STRING comment '搜索来源',
  seo_keywords STRING comment '关键字',
  ip STRING comment 'IP地址',
  area STRING comment '地域',
  country STRING comment '所在国家',
  province STRING comment '省',
  city STRING comment '城市',
  origin_channel STRING comment '投放渠道',
  user_match STRING comment '所属坐席',
  manual_time STRING comment '人工开始时间',
  begin_time STRING comment '坐席领取时间 ',
  end_time STRING comment '会话结束时间',
  last_customer_msg_time_stamp STRING comment '客户最后一条消息的时间',
  last_agent_msg_time_stamp STRING comment '坐席最后一下回复的时间',
  reply_msg_count INT comment '客服回复消息数',
  msg_count INT comment '客户发送消息数',
  browser_name STRING comment '浏览器名称',
  os_info STRING comment '系统名称')
comment '访问会话信息表'
PARTITIONED BY(starts_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
location '/user/hive/warehouse/itcast_ods.db/web_chat_ems_ods'
TBLPROPERTIES ('orc.compress'='ZLIB');

-- 访问咨询附属表
CREATE EXTERNAL TABLE IF NOT EXISTS itcast_ods.web_chat_text_ems (
  id INT COMMENT '主键来自MySQL',
  referrer STRING comment '上级来源页面',
  from_url STRING comment '会话来源页面',
  landing_page_url STRING comment '访客着陆页面',
  url_title STRING comment '咨询页面title',
  platform_description STRING comment '客户平台信息',
  other_params STRING comment '扩展字段中数据',
  history STRING comment '历史访问记录'
) comment 'EMS-PV测试表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc
location '/user/hive/warehouse/itcast_ods.db/web_chat_text_ems_ods'
TBLPROPERTIES ('orc.compress'='ZLIB');

```

* DWD层:

```sql
CREATE DATABASE IF NOT EXISTS `itcast_dwd`;

create table if not exists itcast_dwd.visit_consult_dwd(
  session_id STRING comment '七陌sessionId',
  sid STRING comment '访客id',
  create_time bigint comment '会话创建时间',
  seo_source STRING comment '搜索来源',
  ip STRING comment 'IP地址',
  area STRING comment '地域',
  msg_count int comment '客户发送消息数',
  origin_channel STRING COMMENT '来源渠道',
  referrer STRING comment '上级来源页面',
  from_url STRING comment '会话来源页面',
  landing_page_url STRING comment '访客着陆页面',
  url_title STRING comment '咨询页面title',
  platform_description STRING comment '客户平台信息',
  other_params STRING comment '扩展字段中数据',
  history STRING comment '历史访问记录',
  hourinfo string comment '小时'
)
comment '访问咨询DWD表'
partitioned by(yearinfo String,quarterinfo string, monthinfo String, dayinfo string)
row format delimited fields terminated by '\t'
stored as orc
location '/user/hive/warehouse/itcast_dwd.db/visit_consult_dwd'
tblproperties ('orc.compress'='SNAPPY');

```

* DWS层

```sql
CREATE DATABASE IF NOT EXISTS `itcast_dws`;
-- 访问量统计结果表
CREATE TABLE IF NOT EXISTS itcast_dws.visit_dws (
  sid_total INT COMMENT '根据sid去重求count',
  sessionid_total INT COMMENT '根据sessionid去重求count',
  ip_total INT COMMENT '根据IP去重求count',
  area STRING COMMENT '区域信息',
  seo_source STRING COMMENT '搜索来源',
  origin_channel STRING COMMENT '来源渠道',
  hourinfo STRING COMMENT '创建时间，统计至小时',
  time_str STRING COMMENT '时间明细',
  from_url STRING comment '会话来源页面',
  groupType STRING COMMENT '产品属性类型：1.地区；2.搜索来源；3.来源渠道；4.会话来源页面；5.总访问量',
  time_type STRING COMMENT '时间聚合类型：1、按小时聚合；2、按天聚合；3、按月聚合；4、按季度聚合；5、按年聚合；')
comment 'EMS访客日志dws表'
PARTITIONED BY(yearinfo STRING,quarterinfo STRING,monthinfo STRING,dayinfo STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
location '/user/hive/warehouse/itcast_dws.db/visit_dws'
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 咨询量统计结果表
CREATE TABLE IF NOT EXISTS itcast_dws.consult_dws
(
  sid_total INT COMMENT '根据sid去重求count',
  sessionid_total INT COMMENT '根据sessionid去重求count',
  ip_total INT COMMENT '根据IP去重求count',
  area STRING COMMENT '区域信息',
  origin_channel STRING COMMENT '来源渠道',
  hourinfo STRING COMMENT '创建时间，统计至小时',
  time_str STRING COMMENT '时间明细',
  groupType STRING COMMENT '产品属性类型：1.地区；2.来源渠道',
  time_type STRING COMMENT '时间聚合类型：1、按小时聚合；2、按天聚合；3、按月聚合；4、按季度聚合；5、按年聚合；'
)
COMMENT '咨询量DWS宽表'
PARTITIONED BY (yearinfo string,quarterinfo STRING, monthinfo STRING, dayinfo string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS ORC
LOCATION '/user/hive/warehouse/itcast_dws.db/consult_dws'
TBLPROPERTIES ('orc.compress'='SNAPPY');

```

### 3.5 hive的基础优化(不需要修改)

#### 3.5.1 HDFS的副本数量

​		默认情况HDFS的副本有 3个副本 

```
实际生产环境中, 一般HDFS副本也是以3个
如果数据不是特别重要, 也可以设置为只有2个副本

如果使用hadoop3.x以上的版本, 支持设置副本数量为 1.5
	其中 0.5 不是指的存储了一半, 而是采用纠删码来存储这一份数据的信息, 而纠删码只占用数据的一半
```

如何配置副本数量:  直接在CM上HDFS的配置目录下配置

![image-20210924104807623](day06_教育项目.assets/image-20210924104807623.png)

#### 3.5.2 yarn的基础配置

​		yarn: 用于资源的分配 (资源: 内存 CPU)

```properties
其中 nodemanager 用于出内存和CPU
其中datanode 用于出磁盘
```

* cpu的配置

```properties
注意: 每一个nodemanager 会向resourcemanager报告自己当前节点有多少核心数 
默认: 8核   yarn不会自动校验每一个节点有多少核CUP
推荐调整配置:  当前节点有多少核, 就要向resourcemanager汇报多少核

如何查看当前这个节点有多少核呢? 
	方式一: 通过CM的主机目录来查看每一节点有多少核
	方式二: 通过命令的方式来查看
		grep 'processor' /proc/cpuinfo | sort -u | wc -l

如何在yarn中配置各个节点的核心数呢? 
	直接在cm的yarn的配置目录下搜索: yarn.nodemanager.resource.cpu-vcores
```

![image-20210924105915243](day06_教育项目.assets/image-20210924105915243.png)

* 内存配置

```properties
注意: 每一个nodemanager 会向resourcemanager报告自己当前节点有多少内存
默认: 8GB   yarn不会自动校验每一个节点有多少内存
推荐配置:  剩余内存 * 80%

如何知道当前节点内存还剩余多少呢?
	1) 通过CM的主机目录来查看每一节点有多少剩余内存
	2) 通过命令方式查看: free -m

如何配置各个节点内存: 
	直接在cm的yarn的配置目录下搜索:
		yarn.nodemanager.resource.memory-mb
		yarn.scheduler.maximum-allocation-mb : 与第一个保持一致
		yarn.app.mapreduce.am.command-opts : 略小于第一个配置的值(0.9)
注意，要同时设置yarn.scheduler.maximum-allocation-mb为一样的值，yarn.app.mapreduce.am.command-opts（JVM内存）的值要同步修改为略小的值（-Xmx1024m）。
```

![image-20210924110328736](day06_教育项目.assets/image-20210924110328736.png)



* yarn本地目录的配置

```properties
配置项:yarn.nodemanager.local-dirs

推荐配置: 当前服务器挂载了几块磁盘, 就需要配置几个目录

目的: yarn在运行的过程中, 会产生一些临时文件, 这些临时文件应该存储在那些位置呢? 由这个本地目录配置决定

如何查看每一个磁盘挂载到了linux的什么目录下:
	df -h   查看对应磁盘挂载点即可
```

![image-20210924110831230](day06_教育项目.assets/image-20210924110831230.png)

#### 3.5.3 MapReduce基础配置

```
mapreduce.map.memory.mb : 在运行MR的时候, 一个mapTask需要占用多大内存
mapreduce.map.java.opts : 在运行MR的时候, 一个mapTask对应jvm需要占用多大内容

mapreduce.reduce.memory.mb: 在运行MR的时候, 一个reduceTask需要占用多大内存
mapreduce.reduce.java.opts : 在运行MR的时候, 一个reduceTask对应jvm需要占用多大内容

注意:
	jvm的内存配置要略小于对应内存
	所有内存配置大小, 不要超过nodemanager的内存大小
	
此处推荐: 
	一般不做任何修改 默认即可 
```

![image-20210924112803648](day06_教育项目.assets/image-20210924112803648.png)

#### 3.5.4 hive的基础配置

* hiveserver2的内存大小配置

```
配置项: HiveServer2 的 Java 堆栈大小（字节）
```

![image-20210924113030636](day06_教育项目.assets/image-20210924113030636.png)

```properties
说明: 如果这个配置比较少, 在执行SQL的时候, 就会出现以下的问题:
	此错误, 说明hiveserver2已经宕机了, 此时需要条件hiveserver2的内存大小,调整后, 重启
```

![image-20210924113106745](day06_教育项目.assets/image-20210924113106745.png)

* 动态生成分区的线程数

```properties
配置: hive.load.dynamic.partitions.thread

说明:
	在执行动态分区的时候, 最多允许多少个线程来运行动态分区操作, 线程越多 , 执行效率越高, 但是占用资源越大
默认值: 15

推荐:
	先采用默认, 如果动态分区执行慢, 而且还有剩余资源, 可以尝试调大

调整位置;
	直接在cm的hive的配置目录下调整
```

* 监听输入文件的线程数量

```properties
配置项: hive.exec.input.listing.max.threads

说明:
	在运行SQL的时候, 可以使用多少个线程读取HDFS上数据, 线程越多, 读取效率越高, 占用资源越大

默认值: 15

推荐:
	先采用默认, 如果读取数据执行慢, 而且还有剩余资源, 可以尝试调大
```

#### 3.5.5 hive压缩的配置

```properties
map中间结果压缩配置:
	建议: 在hive的会话窗口配置
	hive.exec.compress.intermediate: 是否hive对中间结果压缩
	
	以下两个建议直接在cm上yarn的配置目录下直接配置
	mapreduce.map.output.compress : 是否开启map阶段的压缩
	mapreduce.map.output.compress.codec : 选择什么压缩方案
		推荐配置:
			org.apache.hadoop.io.compress.SnappyCodec

reduce最终结果压缩配置:
	建议: 在hive的会话窗口配置
	hive.exec.compress.output: 是否开启对hive最终结果压缩配置
	
	以下两个建议直接在cm上yarn的配置目录下直接配置
	mapreduce.output.fileoutputformat.compress: 是否开启reduce端压缩配置
	mapreduce.output.fileoutputformat.compress.codec: 选择什么压缩方案
		推荐配置:
			org.apache.hadoop.io.compress.SnappyCodec
	mapreduce.output.fileoutputformat.compress.type : 压缩方案
		推荐配置:
			BLOCK
			
说明:
	如果hive上没有开启压缩, 及时配置MR的压缩, 那么也不会生效
```

#### 3.5.6 hive的执行引擎切换

```
配置项: hive.execution.engine
```

![image-20210924114438300](day06_教育项目.assets/image-20210924114438300.png)



### 3.6 访问咨询主题看板_数据采集

​		目的: 将业务端的数据导入到ODS层对应表中

```properties
业务端数据: mysql
ODS层表:  hive

如何将mysql的数据灌入到hive中:  apache  sqoop
```

导入数据的SQL语句:

```sql
-- 访问咨询主表:
SELECT
id,create_date_time,session_id,sid,create_time,seo_source,seo_keywords,ip,
AREA,country,province,city,origin_channel,USER AS user_match,manual_time,begin_time,end_time,
last_customer_msg_time_stamp,last_agent_msg_time_stamp,reply_msg_count,
msg_count,browser_name,os_info, '2021-09-24' AS starts_time
FROM web_chat_ems_2019_07

-- 访问咨询附属表
SELECT 
  *, '2021-09-24' AS start_time
FROM web_chat_text_ems_2019_07
```

执行sqoop脚本, 完成数据采集

```shell
-- 访问咨询主表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/nev \
--username root \
--password 123456 \
--query 'SELECT
id,create_date_time,session_id,sid,create_time,seo_source,seo_keywords,ip,
AREA,country,province,city,origin_channel,USER AS user_match,manual_time,begin_time,end_time,
last_customer_msg_time_stamp,last_agent_msg_time_stamp,reply_msg_count,
msg_count,browser_name,os_info, "2021-09-24" AS starts_time
FROM web_chat_ems_2019_07 where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems \
-m 1 

-- 访问咨询附属表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/nev \
--username root \
--password 123456 \
--query 'SELECT 
  *, "2021-09-24" AS start_time
FROM web_chat_text_ems_2019_07 where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_text_ems \
-m 1 
```

校验数据是否导入成功:

```sql
1) 查看mysql共计有多少条数据
	SELECT COUNT(1) FROM web_chat_ems_2019_07; 211197
	SELECT COUNT(1) FROM web_chat_text_ems_2019_07; 105599
2) 到hive中对表查询一下一共多少条数据
	SELECT COUNT(1) FROM itcast_ods.web_chat_ems; 211197
	SELECT COUNT(1) FROM itcast_ods.web_chat_text_ems; 105599
3) 查询其中一部分数据, 观察数据映射是否OK
	select * from itcast_ods.web_chat_ems limit 10;
	SELECT * FROM itcast_ods.web_chat_text_ems limit 10;
```



可能报出一下错误:

![image-20210924150445743](day06_教育项目.assets/image-20210924150445743.png)

从cm上查看hive的hiveserver2的服务, 服务给出报出信息为:

![image-20210924150645290](day06_教育项目.assets/image-20210924150645290.png)

解决方案:

```properties
调整 hiveserver2的内存大小

直接在cm的hive的配置目录下, 寻找此配置:  调整为3GB
	配置项: HiveServer2 的 Java 堆栈大小（字节）

调整后, 重启服务
```

![image-20210924150748067](day06_教育项目.assets/image-20210924150748067.png)



### 3.7 访问咨询主题看板_数据清洗转换

​		目的: 将ODS层数据导入到DWD层

```properties
DWD层作用:  
	1) 清洗转换操作  2) 少量维度退化操作

思考1: 是否需要做清洗转换操作, 如果需要做什么呢?
	清洗操作: 不需要
	转换操作: 将create_time日期 转换为 yearinfo quarterinfo monthinfo dayinfo hourinfo
	额外加一个转换: 将create_time日期数据转换为时间戳
思考2: 是否需要进行维度退化操作, 如果需要做什么呢? 
	需要的, 将两个事实表合并称为一个事实表
```

SQL的实现:  未完成转换操作

```sql
select
    wce.session_id,
    wce.sid,
    wce.create_time,  -- 此处需要转换: 将字符串日期转换时间戳
    wce.seo_source,
    wce.ip,
    wce.area,
    wce.msg_count,
    wce.origin_channel,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    wce.create_time as hourinfo,  -- 此处需求转换
    wce.create_time as yearinfo,   -- 此处需求转换
    wce.create_time as quarterinfo,   -- 此处需求转换
    wce.create_time as monthinfo,   -- 此处需求转换
    wce.create_time as dayinfo   -- 此处需求转换
from itcast_ods.web_chat_ems wce join itcast_ods.web_chat_text_ems wcte
    on wce.id = wcte.id;
```

思考: 如何进行转换操作:

```sql
转换1: 将create_time 转换为 int类型的数据 (说白: 转换为时间戳)
	方案:  日期 转换时间戳的函数  unix_timestamp(string date, string pattern)
		案例:
			select  unix_timestamp('2019-07-01 23:45:00', 'yyyy-MM-dd HH:mm:ss')

转换2: 将create_time转换为 yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo:
	方案一: 通过 year() quarter() month() day() hour()
		select year('2019-07-01 23:45:00') ; -- 2019
		select month('2019-07-01 23:45:00') ; -- 7
		select day('2019-07-01 23:45:00') ; -- 1
		select hour('2019-07-01 23:45:00') ; -- 23
		select quarter('2019-07-01 23:45:00'); -- 3
	 
	 方案二: 通过字符串的截取操作 substr('字符串',从第几个截取, 截取多少个)
	 	select substr('2019-07-01 23:45:00',1,4); --2019
		select substr('2019-07-01 23:45:00',6,2); -- 07
		select substr('2019-07-01 23:45:00',9,2); -- 01
		select substr('2019-07-01 23:45:00',12,2); -- 23
```

实现最终转换的SQL

```sql
select
    wce.session_id,
    wce.sid,
    unix_timestamp(wce.create_time) as create_time,  
    wce.seo_source,
    wce.ip,
    wce.area,
    wce.msg_count,
    wce.origin_channel,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    substr(wce.create_time,12,2) as hourinfo,
    substr(wce.create_time,1,4) as yearinfo, 
    quarter(wce.create_time) as quarterinfo,
    substr(wce.create_time,6,2) as monthinfo,
    substr(wce.create_time,9,2) as dayinfo
from itcast_ods.web_chat_ems wce join itcast_ods.web_chat_text_ems wcte
    on wce.id = wcte.id;
```



可能会出现的错误:

![image-20210924155011031](day06_教育项目.assets/image-20210924155011031.png)

```properties
注意: 
	在执行转换操作的时候, 由于需要进行二表联查操作, 其中一个表数据量比较少, 此时hive会对其优化, 采用map join的方案进行处理, 而map join需要将小表的数据加载到内存中, 但是内存不足, 导致出现内存溢出错误, 此错误的报错可能会两个信息:
		第一个错误信息: return code 1
		第二个错误信息: return code -137  (等待一会会爆出来)
```

解决方案:

```shell
关闭掉map join 让其采用reduce join即可

如何关闭呢? 
	set hive.auto.convert.join= false;
```



接下来: 将结果数据灌入到DWD层的表中

````sql
--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


insert into table itcast_dwd.visit_consult_dwd partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    wce.session_id,
    wce.sid,
    unix_timestamp(wce.create_time) as create_time,  
    wce.seo_source,
    wce.ip,
    wce.area,
    wce.msg_count,
    wce.origin_channel,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    substr(wce.create_time,12,2) as hourinfo,
    substr(wce.create_time,1,4) as yearinfo, 
    quarter(wce.create_time) as quarterinfo,
    substr(wce.create_time,6,2) as monthinfo,
    substr(wce.create_time,9,2) as dayinfo
from itcast_ods.web_chat_ems wce join itcast_ods.web_chat_text_ems wcte
    on wce.id = wcte.id;
````



### 3.8 访问咨询主题看板_数据分析

​		目的: 将DWD层数据灌入到DWS层

```
DWS层作用: 细化维度统计操作
```



* 如何计算访问量:

````properties
访问量: 
	固有维度: 
		时间维度:  年 季度 月 天 小时
	产品属性维度:
		地区维度
		来源渠道
		搜索来源
		受访页面
		总访问量
````

以时间为基准, 统计总访问量

```sql
-- 统计每年的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  yearinfo as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '5' as time_type,
  yearinfo,
  '-1' as quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo;
-- 统计每年每季度的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'_',quarterinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '4' as time_type,
  yearinfo,
  quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo;
-- 统计每年每季度每月的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '3' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo;
-- 统计每年每季度每月每天的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '2' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,dayinfo;
-- 统计每年每季度每月每天每小时的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '1' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo;
```

基于时间统计各个受访页面的访问量

```sql
-- 统计每年各个受访页面的访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  yearinfo as time_str,
  from_url,
  '4' as grouptype,
  '5' as time_type,
  yearinfo,
  '-1' as quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,from_url;

-- 统计每年,每季度各个受访页面的访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'_',quarterinfo) as time_str,
  from_url,
  '4' as grouptype,
  '4' as time_type,
  yearinfo,
  quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,from_url;

-- 统计每年,每季度,每月各个受访页面的访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo) as time_str,
  from_url,
  '4' as grouptype,
  '3' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,from_url;

-- 统计每年,每季度,每月.每天各个受访页面的访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
  from_url,
  '4' as grouptype,
  '2' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,dayinfo,from_url;
-- 统计每年,每季度,每月.每天,每小时各个受访页面的访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
  from_url,
  '4' as grouptype,
  '1' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,from_url;
```



* 咨询量

```properties
咨询量
	维度: 
		固有维度:
			时间: 年 季度 月 天 小时
		产品属性维度:
			地区
			来源渠道
			总咨询量

咨询和访问的区别:
	msg_count >=1 即为咨询数据
```

基于时间统计总咨询量

```sql
-- 统计每年的总咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    '-1' as area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    yearinfo as time_str,
    '3' as grouptype,
    '5' as time_type,
    yearinfo,
    '-1' as quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo;
-- 统计每年每季度的总咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    '-1' as area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'_',quarterinfo) as time_str,
    '3' as grouptype,
    '4' as time_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo;
-- 统计每年每季度每月的总咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    '-1' as area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo) as time_str,
    '3' as grouptype,
    '3' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo;
-- 统计每年每季度每月每天的总咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    '-1' as area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
    '3' as grouptype,
    '2' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,dayinfo;
-- 统计每年每季度每月每天每小时的总咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    '-1' as area,
    '-1' as origin_channel,
    hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
    '3' as grouptype,
    '1' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo;
```

基于时间,统计各个地区的咨询量

```sql
-- 统计每年各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    yearinfo as time_str,
    '1' as grouptype,
    '5' as time_type,
    yearinfo,
    '-1' as quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,area;
-- 统计每年每季度各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'_',quarterinfo) as time_str,
    '1' as grouptype,
    '4' as time_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,area;
-- 统计每年每季度每月各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo) as time_str,
    '1' as grouptype,
    '3' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,area;
-- 统计每年每季度每月每天各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
    '1' as grouptype,
    '2' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,dayinfo,area;
-- 统计每年每季度每月每天每小时各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
    '1' as grouptype,
    '1' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area;
```

### 3.9 访问咨询主题看板_数据导出

​		目的:  从hive的DWS层将数据导出到mysql中对应目标表中

```
技术:
	Apache sqoop
```

* 第一步: 在mysql中创建目标表:

```sql
create database scrm_bi default character set utf8mb4 collate utf8mb4_general_ci;

-- 访问量的结果表:
CREATE TABLE IF NOT EXISTS scrm_bi.visit_dws (
  sid_total INT COMMENT '根据sid去重求count',
  sessionid_total INT COMMENT '根据sessionid去重求count',
  ip_total INT COMMENT '根据IP去重求count',
  area varchar(32) COMMENT '区域信息',
  seo_source varchar(32) COMMENT '搜索来源',
  origin_channel varchar(32) COMMENT '来源渠道',
  hourinfo varchar(32) COMMENT '创建时间，统计至小时',
  time_str varchar(32) COMMENT '时间明细',
  from_url varchar(32) comment '会话来源页面',
  groupType varchar(32) COMMENT '产品属性类型：1.地区；2.搜索来源；3.来源渠道；4.会话来源页面；5.总访问量',
  time_type varchar(32) COMMENT '时间聚合类型：1、按小时聚合；2、按天聚合；3、按月聚合；4、按季度聚合；5、按年聚合；',
  yearinfo varchar(32) COMMENT '年' ,
  quarterinfo varchar(32) COMMENT '季度',
  monthinfo varchar(32) COMMENT '月',
  dayinfo varchar(32) COMMENT '天'
)comment 'EMS访客日志dws表';

-- 咨询量的结果表:
CREATE TABLE IF NOT EXISTS scrm_bi.consult_dws
(
  sid_total INT COMMENT '根据sid去重求count',
  sessionid_total INT COMMENT '根据sessionid去重求count',
  ip_total INT COMMENT '根据IP去重求count',
  area varchar(32) COMMENT '区域信息',
  origin_channel varchar(32) COMMENT '来源渠道',
  hourinfo varchar(32) COMMENT '创建时间，统计至小时',
  time_str varchar(32) COMMENT '时间明细',
  groupType varchar(32) COMMENT '产品属性类型：1.地区；2.来源渠道',
  time_type varchar(32) COMMENT '时间聚合类型：1、按小时聚合；2、按天聚合；3、按月聚合；4、按季度聚合；5、按年聚合；',
  yearinfo varchar(32) COMMENT '年' ,
  quarterinfo varchar(32) COMMENT '季度',
  monthinfo varchar(32) COMMENT '月',
  dayinfo varchar(32) COMMENT '天'
)COMMENT '咨询量DWS宽表';

```

第二步执行sqoop的数据导出

```shell
-- 先导出 咨询量数据
sqoop export \
--connect jdbc:mysql://192.168.52.150:3306/scrm_bi \
--username root \
--password 123456 \
--table consult_dws \
--hcatalog-database itcast_dws \
--hcatalog-table consult_dws \
-m 1
```

![image-20210924170640174](day06_教育项目.assets/image-20210924170640174.png)

解决乱码:

```shell
sqoop export \
--connect "jdbc:mysql://192.168.52.150:3306/scrm_bi?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password 123456 \
--table consult_dws \
--hcatalog-database itcast_dws \
--hcatalog-table consult_dws \
-m 1
```



完成访问量数据导出

```shell
sqoop export \
--connect "jdbc:mysql://192.168.52.150:3306/scrm_bi?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password 123456 \
--table visit_dws \
--hcatalog-database itcast_dws \
--hcatalog-table visit_dws \
-m 1
```

![image-20210924171542879](day06_教育项目.assets/image-20210924171542879.png)

```properties
此错误是sqoop在运行导出的时候, 一旦执行MR后, 能够报出的唯一的错误: 标识导出失败

而具体因为什么导出失败, sqoop不知道


如何查阅具体报了什么错误呢? 必须查看MR的运行日志

如何查看MR的日志呢? jobHistory(19888)
```

![image-20210924171939095](day06_教育项目.assets/image-20210924171939095.png)

![image-20210924172009204](day06_教育项目.assets/image-20210924172009204.png)



点击job id后,进入页面后点击 logs

![image-20210924172046894](day06_教育项目.assets/image-20210924172046894.png)

![image-20210924172145161](day06_教育项目.assets/image-20210924172145161.png)

![image-20210924172302243](day06_教育项目.assets/image-20210924172302243.png)

```properties
解决方案:
	将mysql中的from_url字段的varchar长度改的更长一些即可
```



## 4. 访问咨询主题看板_增量流程

### 4.1 业务库中模拟增量数据(实际生产中不存在)

* 模拟上一天数据: 在mysql中执行

```sql
-- 模拟访问咨询主表数据
CREATE TABLE web_chat_ems_2021_09 AS
SELECT *  FROM web_chat_ems_2019_07 WHERE  create_time BETWEEN '2019-07-01 00:00:00' AND '2019-07-01 23:59:59';

-- 修改表中的时间字段
UPDATE web_chat_ems_2021_09 SET create_time = CONCAT('2021-09-25 ',SUBSTR(create_time,12));


-- 模拟访问咨询附属表数据
CREATE TABLE web_chat_text_ems_2021_09 AS
SELECT 
  temp2.*
FROM
(SELECT *  FROM web_chat_ems_2019_07 
	WHERE  create_time BETWEEN '2019-07-01 00:00:00' AND '2019-07-01 23:59:59') temp1
	JOIN web_chat_text_ems_2019_07 temp2 ON temp1.id = temp2.id ;
	
-- 注意: 
	在生产环境中, 每个表中应该都是有若干天的数据, 而不是仅仅只有一天
```



### 4.2 增量数据采集操作

​	只需要采集新增的这一天的数据即可

* 思考1: 如何从表中获取新增的这一天的数据呢?

```sql
-- 访问咨询的主表数据:
SELECT 
id,create_date_time,session_id,sid,create_time,seo_source,seo_keywords,ip,
AREA,country,province,city,origin_channel,USER AS user_match,manual_time,begin_time,end_time,
last_customer_msg_time_stamp,last_agent_msg_time_stamp,reply_msg_count,
msg_count,browser_name,os_info, '2021-09-26' AS starts_time	
FROM web_chat_ems_2021_09 WHERE create_time BETWEEN '2021-09-25 00:00:00' AND '2021-09-25 23:59:59' 

-- 访问咨询的附属表的数据
SELECT 
	temp2.*, '2021-09-26' AS start_time
FROM (SELECT id FROM web_chat_ems_2021_09 WHERE create_time BETWEEN '2021-09-25 00:00:00' AND '2021-09-25 23:59:59') temp1
	JOIN web_chat_text_ems_2021_09 temp2 ON temp1.id = temp2.id
```

* 思考2: 将增量的SQL集成到增量的sqoop脚本中

```shell
-- 访问咨询主表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/nev \
--username root \
--password 123456 \
--query "SELECT 
id,create_date_time,session_id,sid,create_time,seo_source,seo_keywords,ip,
AREA,country,province,city,origin_channel,USER AS user_match,manual_time,begin_time,end_time,
last_customer_msg_time_stamp,last_agent_msg_time_stamp,reply_msg_count,
msg_count,browser_name,os_info, '2021-09-26' AS starts_time	
FROM web_chat_ems_2021_09 WHERE create_time BETWEEN '2021-09-25 00:00:00' AND '2021-09-25 23:59:59' and \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems \
-m 1 

-- 访问咨询附属表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/nev \
--username root \
--password 123456 \
--query "SELECT 
	temp2.*, '2021-09-26' AS start_time
FROM (SELECT id FROM web_chat_ems_2021_09 WHERE create_time BETWEEN '2021-09-25 00:00:00' AND '2021-09-25 23:59:59') temp1
	JOIN web_chat_text_ems_2021_09 temp2 ON temp1.id = temp2.id where 1=1 and \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_text_ems \
-m 1 
```

* 思考3: 此脚本为增量化的脚本操作, 随着时间的推移, 每一天都需要执行一次, 而且每次执行只需要修改日期数据即可, 请问有什么简单方案呢?

```properties
解决方案:
	通过shell脚本的方式来执行, 通过脚本自动获取上一天的日期, 最后将shell脚本放置在ooize中, 进行自动化调度操作
```

* 思考4: 如何编写shell脚本呢?

  要求: 此脚本能够实现自动获取上一天的日期数据, 并且还支持采集指定日期下数据	

```properties
难度1: 如何通过shell脚本获取上一天的日期呢? 
	date -d '-2 day' : 获取前二天的日期
	date -d '-1 year': 获取上一年日期
	date -d '-1 week': 获取上一周的日期
	date -d '-1 hour': 获取上一个小时日期

注意上述命令获取后的日期格式为: 2021年 09月 26日 星期日 08:48:12 CST 
	但是sqoop基本需要的是 2021-09-25  如何解决呢?
		date -d '-1 day' +'%Y-%m-%d %H:%M:%S'
		输出为: 
			2021-09-25 09:51:42

难度2: 如何让shell脚本接收外部的参数呢?
	$#: 获取外部传递了几个参数
	$N: 获取第几个参数
	
难度3: 如何在shell中实现判断操作
	需求: 如果传递了参数（即指定抽取的日期）, 设置为参数的值即可, 如果没有传递, 设置为上一天
	
	if [ $# == 1 ]
      then
       # 当条件成立的时候, 执行
         dateStr=$1
      else
         # 当条件不成立的执行
         dateStr=`date -d '-1 day' +'%Y-%m-%d'`
      fi

    echo ${dateStr}
    
    注意:
    	[] 两边都需要留有空格
    	= 左右两边不能有空格
    	如果需要将命令执行结果赋值给一个变量, 必须给这个命令使用飘号引起来 (`)  esc下面那个键
    		如：dateStr=`date -d '-1 day' +'%Y-%m-%d'`
    	如果获取某一个变量的值: ${变量名}
    		如：echo ${dateStr}
```

* 编写增量数据采集的shell脚本

```shell
hadoop01: 家目录

cd /root

vim edu_mode_1_collect.sh

内容如下:

#!/bin/bash

export SQOOP_HOME=/usr/bin/sqoop

if [ $# == 1 ]
   then
      dateStr=$1
   else
      dateStr=`date -d '-1 day' +'%Y-%m-%d'`
fi

dateNowStr=`date +'%Y-%m-%d'`

yearStr=`date -d ${dateStr} +'%Y'`
monthStr=`date -d ${dateStr} +'%m'`

jdbcUrl='jdbc:mysql://192.168.52.150:3306/nev'
username='root'
password='123456'
m='1'

${SQOOP_HOME} import \
--connect ${jdbcUrl} \
--username ${username} \
--password ${password} \
--query "SELECT 
id,create_date_time,session_id,sid,create_time,seo_source,seo_keywords,ip,
AREA,country,province,city,origin_channel,USER AS user_match,manual_time,begin_time,end_time,
last_customer_msg_time_stamp,last_agent_msg_time_stamp,reply_msg_count,
msg_count,browser_name,os_info, '${dateNowStr}' AS starts_time  
FROM web_chat_ems_${yearStr}_${monthStr} WHERE create_time BETWEEN '${dateStr} 00:00:00' AND '${dateStr} 
23:59:59' and \$CONDITIONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_ems \
-m ${m}

${SQOOP_HOME} import \
--connect ${jdbcUrl} \
--username ${username} \
--password ${password} \
--query "SELECT 
        temp2.*, '${dateNowStr}' AS start_time
FROM (SELECT id FROM web_chat_ems_${yearStr}_${monthStr} WHERE create_time BETWEEN '${dateStr} 00:00:00' 
AND '${dateStr} 23:59:59') temp1
        JOIN web_chat_text_ems_${yearStr}_${monthStr} temp2 ON temp1.id = temp2.id where 1=1 and \$CONDIT
IONS" \
--hcatalog-database itcast_ods \
--hcatalog-table web_chat_text_ems \
-m ${m}
```

* 测试脚本是否可以正常执行

```properties
sh edu_mode_1_collect.sh 

可以在hive中查看对应分区下的数据, 如果有, 说明抽取成功了
	select * from itcast_ods.web_chat_ems where starts_time='2021-09-26' limit 10;
```

* 将shell脚本放置到ooize中,完成自动化调度操作

  * 第一步骤: 配置工作流

  ![image-20210926105156368](day06_教育项目.assets/image-20210926105156368.png)

  ![image-20210926105350222](day06_教育项目.assets/image-20210926105350222.png)

  * 第二步: 配置自动化调度

  ![image-20210926105419286](day06_教育项目.assets/image-20210926105419286.png)

  ![image-20210926110016710](day06_教育项目.assets/image-20210926110016710.png)

点击运行启动即可



### 4.3 增量数据清洗转换操作

* 原有的全量的清洗转换SQL

```sql
--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


insert into table itcast_dwd.visit_consult_dwd partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    wce.session_id,
    wce.sid,
    unix_timestamp(wce.create_time) as create_time,  
    wce.seo_source,
    wce.ip,
    wce.area,
    wce.msg_count,
    wce.origin_channel,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    substr(wce.create_time,12,2) as hourinfo,
    substr(wce.create_time,1,4) as yearinfo, 
    quarter(wce.create_time) as quarterinfo,
    substr(wce.create_time,6,2) as monthinfo,
    substr(wce.create_time,9,2) as dayinfo
from itcast_ods.web_chat_ems wce join itcast_ods.web_chat_text_ems wcte
    on wce.id = wcte.id;
```

* 改造后,增量的清洗转换的SQL

```sql
--动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;


insert into table itcast_dwd.visit_consult_dwd partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    wce.session_id,
    wce.sid,
    unix_timestamp(wce.create_time) as create_time,  
    wce.seo_source,
    wce.ip,
    wce.area,
    wce.msg_count,
    wce.origin_channel,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    substr(wce.create_time,12,2) as hourinfo,
    substr(wce.create_time,1,4) as yearinfo, 
    quarter(wce.create_time) as quarterinfo,
    substr(wce.create_time,6,2) as monthinfo,
    substr(wce.create_time,9,2) as dayinfo
from (select * from itcast_ods.web_chat_ems where starts_time='2021-09-26') wce join (select * from itcast_ods.web_chat_text_ems where start_time='2021-09-26') wcte   
    on wce.id = wcte.id;
```

* 思考: 如何在shell下执行hive的SQL

```properties
解决方案:
	./hive -e|-f 'sql语句|SQL脚本' -S

说明 
	-S 表示静默执行
```

* 编写shell脚本, 实现增量数据清洗转换操作

```shell
hadoop01:
	cd /root
	vim edu_mode_1_handle.sh
	内容如下
#!/bin/bash

export HIVE_HOME=/usr/bin/hive

if [ $# == 1 ]
then
  dateStr=$1

  else
     dateStr=`date +'%Y-%m-%d'`
fi

sqlStr="
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
set hive.exec.orc.compression.strategy=COMPRESSION;

insert into table itcast_dwd.visit_consult_dwd partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select
    wce.session_id,
    wce.sid,
    unix_timestamp(wce.create_time) as create_time,  
    wce.seo_source,
    wce.ip,
    wce.area,
    wce.msg_count,
    wce.origin_channel,
    wcte.referrer,
    wcte.from_url,
    wcte.landing_page_url,
    wcte.url_title,
    wcte.platform_description,
    wcte.other_params,
    wcte.history,
    substr(wce.create_time,12,2) as hourinfo,
    substr(wce.create_time,1,4) as yearinfo, 
    quarter(wce.create_time) as quarterinfo,
    substr(wce.create_time,6,2) as monthinfo,
    substr(wce.create_time,9,2) as dayinfo
from (select * from itcast_ods.web_chat_ems where starts_time='${dateStr}') wce join (select * from itcast_ods.web_chat_text_ems where start_time='${dateStr}') wcte   
    on wce.id = wcte.id;
"

${HIVE_HOME} -e "${sqlStr}" -S

```

* 将shell脚本配置到ooize中, 从而实现自动化调度

  * 第一步: 配置工作流(在原有的采集工作流后续最近一个阶段即可)

  ![image-20210926114456349](day06_教育项目.assets/image-20210926114456349.png)

  * 第二步: 配置自动化调度(可以直接省略....)



### 4.4 增量数据统计分析操作

* 全量的统计SQL:

```sql
-- 访问量: 5条
-- 统计每年的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  yearinfo as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '5' as time_type,
  yearinfo,
  '-1' as quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo;
-- 统计每年每季度的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'_',quarterinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '4' as time_type,
  yearinfo,
  quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo;
-- 统计每年每季度每月的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '3' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo;
-- 统计每年每季度每月每天的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '2' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,dayinfo;
-- 统计每年每季度每月每天每小时的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '1' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo;

-- 咨询量: 5条
-- 统计每年各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    yearinfo as time_str,
    '1' as grouptype,
    '5' as time_type,
    yearinfo,
    '-1' as quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,area;
-- 统计每年每季度各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'_',quarterinfo) as time_str,
    '1' as grouptype,
    '4' as time_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,area;
-- 统计每年每季度每月各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo) as time_str,
    '1' as grouptype,
    '3' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,area;
-- 统计每年每季度每月每天各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
    '1' as grouptype,
    '2' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,dayinfo,area;
-- 统计每年每季度每月每天每小时各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
    '1' as grouptype,
    '1' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area;
```

增量的SQL统计:

```sql
-- 访问量: 5条
-- 统计每年的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  yearinfo as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '5' as time_type,
  yearinfo,
  '-1' as quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where yearinfo='2021'
group by yearinfo;
-- 统计每年每季度的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'_',quarterinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '4' as time_type,
  yearinfo,
  quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where yearinfo='2021' and quarterinfo='3'
group by yearinfo,quarterinfo;
-- 统计每年每季度每月的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '3' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where  yearinfo='2021' and quarterinfo='3' and monthinfo='09'
group by yearinfo,quarterinfo,monthinfo;
-- 统计每年每季度每月每天的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '2' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd where  yearinfo='2021' and quarterinfo='3' and monthinfo='09' and dayinfo='25'
group by yearinfo,quarterinfo,monthinfo,dayinfo;
-- 统计每年每季度每月每天每小时的总访问量
insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '1' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd where  yearinfo='2021' and quarterinfo='3' and monthinfo='09' and dayinfo='25' 
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo;

-- 咨询量: 5条
-- 统计每年各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    yearinfo as time_str,
    '1' as grouptype,
    '5' as time_type,
    yearinfo,
    '-1' as quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='2021'
group by yearinfo,area;
-- 统计每年每季度各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'_',quarterinfo) as time_str,
    '1' as grouptype,
    '4' as time_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='2021' and quarterinfo='3' 
group by yearinfo,quarterinfo,area;
-- 统计每年每季度每月各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo) as time_str,
    '1' as grouptype,
    '3' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='2021' and quarterinfo='3' and monthinfo='09'
group by yearinfo,quarterinfo,monthinfo,area;
-- 统计每年每季度每月每天各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
    '1' as grouptype,
    '2' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='2021' and quarterinfo='3' and monthinfo='09' and dayinfo='25'
group by yearinfo,quarterinfo,monthinfo,dayinfo,area;
-- 统计每年每季度每月每天每小时各个地区的咨询量
insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
    '1' as grouptype,
    '1' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='2021' and quarterinfo='3' and monthinfo='09' and dayinfo='25'
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area;
```



说明:

```properties
在统计年的时候, 只需要统计加上这一天以后这一年的数据即可, 之前年的数据是不需要统计的
在统计季度的时候,只需要统计加上这一天以后这一年对应的这一季度的数据即可, 之前的季度是不需要统计的
在统计月份的时候, 只需要统计加上这一天以后这一年对应的这一月份的数据即可,之前的月份不需要统计
在统计天的时候, 只需要统计新增的这一天即可
在统计小时的时候, 只需要统计新增的这一天的每个小时
```

思考: 在统计的过程中,  比如以年统计, 得到一个新的年的统计结果, 那么在DWS层表中是不是还有一个历史的结果呢? 如何解决呢

```properties
说明:	
	在统计的过程中, 会对之前的统计结果产生影响, 主要受影响:
		年统计当年结果数据
		季度统计当季度结果数据
		月统计当月统计结果数据
	注意: 天 和 小时是不受历史结果影响

解决方案:
	将之前的结果受影响的结果值删除即可

如何删除呢?  注意hive不支持直接对表中某条数据删除
	可以通过删除分区的方案进行处理

思考:
	当年的统计结构数据在那个分区下存储着呢?
		yearinfo='2021' and quarterinfo='-1' and monthinfo ='-1' and dayinfo='-1'
		此分区了存储了按年统计的各个产品属性维度的结果数据
	当年当季度的统计结构数据再那个分区下
		yearinfo='2021' and quarterinfo='3' and monthinfo ='-1' and dayinfo='-1'
	当年当季度当月的统计结果在那个分区下:
		yearinfo='2021' and quarterinfo='3' and monthinfo ='09' and dayinfo='-1'

执行删除:
	alter table xxx drop partition(yearinfo='2021' and quarterinfo='-1' and monthinfo ='-1' and dayinfo='-1');
	alter table xxx drop partition(yearinfo='2021' and quarterinfo='3' and monthinfo ='-1' and dayinfo='-1');
	alter table xxx drop partition(yearinfo='2021' and quarterinfo='3' and monthinfo ='09' and dayinfo='-1');
```

编写shell脚本:

```shell
hadoop01:
	cd /root
	vim edu_mode_1_analyse.sh
	内容如下:
#!/bin/bash
export HIVE_HOME=/usr/bin/hive

if [ $# == 1 ]

then
   dateStr=$1
   
   else 
      dateStr=`date -d '-1 day' +'%Y-%m-%d'`

fi

yearStr=`date -d ${dateStr} +'%Y'`

monthStr=`date -d ${dateStr} +'%m'`

month_for_quarter=`date -d ${dateStr} +'%-m'`
quarterStr=$((($month_for_quarter-1)/3+1))

dayStr=`date -d ${dateStr} +'%d'`


sqlStr="
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
set hive.exec.orc.compression.strategy=COMPRESSION;

alter table itcast_dws.visit_dws drop partition(yearinfo='${yearStr}',quarterinfo='-1',monthinfo='-1',dayinfo='-1');
alter table itcast_dws.visit_dws drop partition(yearinfo='${yearStr}',quarterinfo='${quarterStr}',monthinfo='-1',dayinfo='-1');
alter table itcast_dws.visit_dws drop partition(yearinfo='${yearStr}',quarterinfo='${quarterStr}',monthinfo='${monthStr}}',dayinfo='-1');

alter table itcast_dws.consult_dws drop partition(yearinfo='${yearStr}',quarterinfo='-1',monthinfo='-1',dayinfo='-1');
alter table itcast_dws.consult_dws drop partition(yearinfo='${yearStr}',quarterinfo='${quarterStr}',monthinfo='-1',dayinfo='-1');
alter table itcast_dws.consult_dws drop partition(yearinfo='${yearStr}',quarterinfo='${quarterStr}',monthinfo='${monthStr}}',dayinfo='-1');

insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  yearinfo as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '5' as time_type,
  yearinfo,
  '-1' as quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where yearinfo='${yearStr}'
group by yearinfo;

insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'_',quarterinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '4' as time_type,
  yearinfo,
  quarterinfo,
  '-1' as monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where yearinfo='${yearStr}' and quarterinfo='${quarterStr}'
group by yearinfo,quarterinfo;

insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '3' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where  yearinfo='${yearStr}' and quarterinfo='${quarterStr}' and monthinfo='${monthStr}'
group by yearinfo,quarterinfo,monthinfo;

insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  '-1' as hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '2' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd where  yearinfo='${yearStr}' and quarterinfo='${quarterStr}' and monthinfo='${monthStr}' and dayinfo='${dayStr}'
group by yearinfo,quarterinfo,monthinfo,dayinfo;

insert into table itcast_dws.visit_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
  count(distinct sid) as  sid_total,
  count(distinct session_id) as sessionid_total,
  count(distinct ip) as ip_total,
  '-1' as area,
  '-1' as seo_source,
  '-1' as origin_channel,
  hourinfo,
  concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
  '-1' as from_url,
  '5' as grouptype,
  '1' as time_type,
  yearinfo,
  quarterinfo,
  monthinfo,
  dayinfo
from  itcast_dwd.visit_consult_dwd where  yearinfo='${yearStr}' and quarterinfo='${quarterStr}' and monthinfo='${monthStr}' and dayinfo='${dayStr}'
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo;


insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    yearinfo as time_str,
    '1' as grouptype,
    '5' as time_type,
    yearinfo,
    '-1' as quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='${yearStr}'
group by yearinfo,area;

insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'_',quarterinfo) as time_str,
    '1' as grouptype,
    '4' as time_type,
    yearinfo,
    quarterinfo,
    '-1' as monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='${yearStr}' and quarterinfo='${quarterStr}'
group by yearinfo,quarterinfo,area;

insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo) as time_str,
    '1' as grouptype,
    '3' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    '-1' as dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='${yearStr}' and quarterinfo='${quarterStr}' and monthinfo='${monthStr}'
group by yearinfo,quarterinfo,monthinfo,area;

insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    '-1' as hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
    '1' as grouptype,
    '2' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='${yearStr}' and quarterinfo='${quarterStr}' and monthinfo='${monthStr}' and dayinfo='${dayStr}'
group by yearinfo,quarterinfo,monthinfo,dayinfo,area;

insert into table itcast_dws.consult_dws partition(yearinfo,quarterinfo,monthinfo,dayinfo)
select  
    count(distinct sid) as sid_total,
    count(distinct session_id) as sessionid_total,
    count(distinct ip) as ip_total,
    area,
    '-1' as origin_channel,
    hourinfo,
    concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
    '1' as grouptype,
    '1' as time_type,
    yearinfo,
    quarterinfo,
    monthinfo,
    dayinfo
from  itcast_dwd.visit_consult_dwd where msg_count >= 1 and yearinfo='${yearStr}' and quarterinfo='${quarterStr}' and monthinfo='${monthStr}' and dayinfo='${dayStr}'
group by yearinfo,quarterinfo,monthinfo,dayinfo,hourinfo,area;

"

${HIVE_HOME} -e "${sqlStr}" -S

```

测试shell脚本

```shell
sh  edu_mode_1_analyse.sh

测试: 
	select  * from itcast_dws.visit_dws where  yearinfo='2021';
```

最后,将shell脚本配置到oozie (省略)



### 4.5  增量数据导出操作

​		说明:

```properties
	在执行导出的时候, 也需要将mysql中之前的统计的当年当季度和当月的结果数据删除, 然后重新导入操作

	此时我们处理的方案, 要进行简化一些, 受影响最大范围当年的数据,  可以直接将当年的统计结果数据全部都删除, 然后重新到DWS层当年的所有数据
```

编写shell脚本:

```shell
hadoop01: 
	cd /root
	vim edu_mode_1_export.sh
内容如下:
#!/bin/bash

export SQOOP_HOME=/usr/bin/sqoop

if [ $# == 1 ]
then
   TD_DATE=$1  
else
   TD_DATE=`date -d '-1 day' +'%Y-%m-%d'`
fi

TD_YEAR=`date -d ${TD_DATE} +%Y`

mysql -uroot -p123456 -h192.168.52.150 -P3306 -e "delete from scrm_bi.visit_dws where yearinfo='$TD_YEAR'; delete from scrm_bi.consult_dws where yearinfo='$TD_YEAR';"

jdbcUrl='jdbc:mysql://192.168.52.150:3306/scrm_bi?useUnicode=true&characterEncoding=utf-8'
username='root'
password='123456'

${SQOOP_HOME} export \
--connect ${jdbcUrl} \
--username ${username} \
--password ${password} \
--table visit_dws \
--hcatalog-database itcast_dws \
--hcatalog-table visit_dws \
--hcatalog-partition-keys yearinfo \
--hcatalog-partition-values $TD_YEAR \
-m 1

${SQOOP_HOME} export \
--connect ${jdbcUrl} \
--username ${username} \
--password ${password} \
--table consult_dws \
--hcatalog-database itcast_dws \
--hcatalog-table consult_dws \
--hcatalog-partition-keys yearinfo \
--hcatalog-partition-values $TD_YEAR \
-m 1

```

将shell脚本设置到oozie中(省略)



## 5. 意向用户主题看板_全量流程

### 5.1  需求分析

```properties
主要分析什么内容:
	1) 每一个需求涉及到那些维度, 那些直白
	2) 每一个需求涉及到那些表, 表的字段
	3) 找出需要进行清洗 转换的操作
	4) 如果表涉及到多表, 需要找到表与表关联条件
```

* 需求一: 计期内，新增意向客户（包含自己录入的意向客户）总数。

```properties
涉及维度:
	时间维度: 年 月  天 小时
	新老维度
	线上线下
涉及指标:
	意向量
	
涉及到表:
	customer_relationship (客户意向表)  (事实表)

涉及到字段:
	时间维度: create_date_time
		此处有转换操作: 将时间转换为yearinfo, monthinfo, dayinfo, hourinfo
	新老维度:  ?
	线上线下:  ?
	指标字段: customer_id 
		计算方案: 先去重在统计
		说明: 无法在DWM层进行提前聚合
```

* 需求二: 统计指定时间段内，新增的意向客户，所在城市区域人数热力图。

```properties
涉及维度:
	时间维度: 年 月 天 小时
	新老维度:
	地区维度:
	线上线下
涉及指标:
	意向量


涉及表:
	customer (客户表) (维度表)
	customer_relationship(客户意向表) (事实表)

涉及字段:
	时间维度: 客户意向表.create_date_time
	地区维度: 客户表.area
	指标字段: 客户意向表.customer_id
表与表关联条件:
	客户意向表.customer_id = 客户表.id
```

* 需求三:  统计指定时间段内，新增的意向客户中，意向学科人数排行榜。学科名称要关联查询出来。

```properties
涉及维度:
	时间维度: 年  月  天 小时
	新老维度:
	学科维度:
 	线上线下:
涉及指标:
	意向量

涉及表: 
     customer_clue(客户线索表) (维度表)
     customer_relationship(客户意向表)  (事实表)
     itcast_subject(学科表) (维度表)

涉及字段: 
	时间维度: 
		客户意向表.create_date_time
	新老维度: 
		客户线索表.clue_state
			说明: 当字段的值为 'VALID_NEW_CLUES' 为新用户
					暂定: 其他的值都是老用户
			此处有转换: 将clue_state转换为clue_state_stat, 此新字段的值只有 0(老) 和 1(新)
	线上线下维度:
		客户意向表.origin_type
			说明: 当字段的值为 'NETSERVICE' 或者 'PRESIGNUP' 表示为线上
				暂定: 其他值都为线下
			此处有转换: 将 	origin_type 转换为 origin_type_stat 其中值只有 0(线下)   1(线上)
	学科维度: 
		客户意向表.itcast_subject_id
		学科.name
	指标字段: 
		客户意向表.customer_id
	
表与表关联条件: 
	客户意向表.itcast_subject_id = 学科表.id
	客户线索表.customer_relationship_id = 客户意向表.id

清洗操作: 
	客户线索表.deleted = false 数据保留下, 为true清洗掉
转换操作:
	将学科id为 0 或者为  null的时候, 将其转换为 -1

原则:
	1) 事实表存在的字段 要优先使用, 如果没有从维度表中查询
	2) 当维度出现二元(比如: 新 老, 线上 线下...)的维度的时候, 建议将其转换为 0 和 1来标记
```

* 需求四: 统计指定时间段内，新增的意向客户中，意向校区人数排行榜

```properties
涉及维度:
	时间维度: 年 月 天 小时
	新老维度:
	校区维度:
	线上线下:

涉及指标:
	意向量

涉及表:
	customer_clue(线索表)
	customer_relationship(客户意向表)
	itcast_school(校区表)
涉及字段:
	新老维度: 线索表.clue_state (需要转换) --> clue_state_stat
	线上线下: 客户意向表.origin_type(需要转换) --> origin_type_stat
	时间维度: 客户意向表.create_date_time
	校区维度: 
		客户意向表.itcast_school_id
		校区表.name
	指标字段: 
		客户意向表.customer_id
	
清洗操作: 
	线索表.deleted = false
表与表关系: 
	客户意向表.itcast_school_id = 校区表.id
	客户线索表.customer_relationship_id = 客户意向表.id

转换操作:
	将校区id为 0 或者为  null的时候, 将其转换为 -1
```

* 需求五: 统计指定时间段内，新增的意向客户中，不同来源渠道的意向客户占比。

```properties
涉及维度:
	时间维度: 年 月  天 小时
	新老维度:
	来源渠道:
	线上线下:

涉及指标:
	意向量
	
涉及表:
	customer_relationship(客户意向表)
	customer_clue(线索表)
涉及字段:
	新老维度: 线索表.clue_state (需要转换) --> clue_state_stat
	线上线下: 客户意向表.origin_type(需要转换) --> origin_type_stat
	时间维度: 客户意向表.create_date_time
	来源渠道: 客户意向表.origin_type
	指标字段: 
		客户意向表.customer_id
说明:
	线上线下是各个来源渠道的上卷维度
清洗操作: 
	线索表.deleted = false

表与表关联条件:
	线索表.customer_relationship_id = 客户意向表.id
```

* 需求六: 统计指定时间段内，新增的意向客户中，各咨询中心产生的意向客户数占比情况。

```properties
涉及维度:
	时间维度: 年 月  天 小时
	新老维度:
	各咨询中心维度:
	线上线下维度:

涉及指标:
	意向量
    
涉及表:
	customer_relationship(客户意向表)
	employee(员工表)
	scrm_department(部门表)
	customer_clue(线索表)
涉及字段: 
	新老维度: 线索表.clue_state (需要转换) --> clue_state_stat
	线上线下: 客户意向表.origin_type(需要转换) --> origin_type_stat
	时间维度: 客户意向表.create_date_time
	各咨询中心: 
		员工表.tdepart_id
		部门表.name
	指标字段: 
		客户意向表.customer_id
	
表与表的关联条件:
	客户意向表.creator = 员工表.id
	员工表.tdepart_id = 部门表.id
	线索表.customer_relationship_id = 客户意向表.id
	
```



总结:

```properties
指标: 
	意向量

维度: 
	固有维度:
		时间维度: 年 月  天 小时
		线上线下:
		新老维度:
	产品属性维度: 
		地区维度:
		校区维度:
		学科维度;
		来源渠道:
		各咨询中心

涉及表: 
	customer_relationship(客户意向表)  (事实表)
	employee(员工表)  (维度表)
	scrm_department(部门表)  (维度表)
	customer_clue(线索表)  (维度表)
	itcast_school(校区表)  (维度表)
	itcast_subject(学科表)  (维度表)
	customer (客户表)  (维度表)

表与表关系:  
	客户意向表.creator = 员工表.id
	员工表.tdepart_id = 部门表.id
	线索表.customer_relationship_id = 客户意向表.id
	客户意向表.itcast_school_id = 校区表.id
	客户意向表.itcast_subject_id = 学科表.id
	客户意向表.customer_id = 客户表.id

涉及字段: 
	时间维度: 客户意向表.create_date_time
	线上线下: 客户意向表.origin_type --> origin_type_stat
	新老维度: 线索表.clue_state --> clue_state_stat
	地区维度: 客户表.area
	校区维度: 客户意向表.itcast_school_id 和 校区表.name
	学科维度: 客户意向表.itcast_subject_id 和 学科表.name
	来源渠道: 客户意向表.origin_type
	各咨询中心: 员工表.tdepart_id 和 部门表.name
	指标字段: 客户意向表.customer_id
	清洗字段: 线索表.deleted 
	
需要清洗的内容: 将删除标记为true的数据删除
	过滤出: 客户意向表.deleted = false

需要转换的内容:
	1) 日期: 客户意向表.create_date_time
		需要转换为: yearinfo  monthinfo dayinfo hourinfo
	2) 新老维度: 线索表.clue_state
		说明: 当字段的值为 'VALID_NEW_CLUES' 为新用户
					暂定: 其他的值都是老用户
		需要转换为一个新的字段: clue_state_stat 
			此字段只有二个值: 0(老)   1(新)
	3) 线上线下: 客户意向表.origin_type
		说明: 当字段的值为 'NETSERVICE' 或者 'PRESIGNUP' 表示为线上
				暂定: 其他值都为线下
		需要转换为一个新的字段: origin_type_stat
			此字段只有二个值  0(线下)    1(线上)
	4) 校区和学科的id转换 
			需要将客户意向表中, 校区id 和 学科id 如果为 0或者 null 转换为 -1
```

### 5.2 业务数据的准备工作

* 需要在mysql中创建一个库

```sql
create database scrm default character set utf8mb4 collate utf8mb4_unicode_ci;
```

* 将项目资料中, 提供的业务数据集导入到这个库中

![image-20210926175331847](day06_教育项目.assets/image-20210926175331847.png)

![image-20210926175500112](day06_教育项目.assets/image-20210926175500112.png)



### 5.3 建模分析

* ODS层: 源数据层
  * 作用: 对接数据源, 一般和数据源保持相同粒度 (直白: 将数据源中拷贝到ODS层中)
  * 一般放置是事实表和少量的维度表

```properties
放置事实表即可:
     customer_relationship(意向表 )  -- 本次主题的事实表
     customer_clue(线索表)  -- 本次主题的维度表, 下次主题的事实表
建表操作:   
    表中字段与数据源中字段保持一致, 只需要多加一个 抽取时间的字段即可
请注意:
    意向表  和 线索表中数据存在数据变更操作,需要采用缓慢渐变维的方式来解决
```

* DIM层: 数据维度层

```properties
放置维度表: 
	5张表
	 customer(客户表)                  ---  维度表
	 itcast_subject(学科表)            ---  维度表
	 itcast_school(校区表)             ---  维度表
	 employee(员工表)                  ---  维度表
	 scrm_department(部门表)           ---  维度表

建表:
   与数据源保持一致的字段即可, 多加一个 抽取时间的字段
```

* DW层: 数据仓库层

  * DWD层: 数据明细层

    * 作用:  1) 清洗转换处理工作   2)  少量维度退化(此层不需要执行)

    ```properties
    需要清洗内容: 
    	将标记为删除的数据进行过滤掉 
    
    需要转换内容:
       1) 将create_date_time 转换为 yearinfo  monthinfo dayinfo hourinfo
       2) 将origin_type 转换为 origin_type_state (用于统计线上线下)
       		转换逻辑: origin_type的值为: NETSERVICE 或者 PRESIGNUP 认为线上 其余认为线下
       3) 将clue_state 转换为 clue_state_stat (用于统计新老维度)
            转换逻辑:clue_state的值为 VALID_NEW_CLUES 为新客户  其余暂定为老客户
       4) 将校区和学科的 id字段, 如果为 0 或者 null 转换为 -1
    ```

    * 建模内容

    ```properties
    DWD层表的构建: 必须字段(只能是事实表中字段) + 清洗的字段 + 转换的字段+ join字段
    
    customer_relationship(意向表 )    ---  事实表
    	 	时间维度: create_date_time
       		线上线下: origin_type --> origin_type_stat
       		来源渠道: origin_type
       		校区维度:  itcast_school_id
       		学科维度:  itcast_subject_id 
       		指标字段: customer_id,
       		关联条件的字段: creator,id
    
    表字段的组成:
       customer_id, create_date_time,origin_type,itcast_school_id,itcast_subject_id,creator,id
       deleted,origin_type_stat,yearinfo  monthinfo dayinfo hourinfo
    
    ```

  * DWM层: 数据中间层

    * 作用: 1) 提前聚合的操作( 由于有去重,导致无法实施)  2) 维度退化操作

    ```properties
    此层后期处理的时候, 需要进行七表关联的操作
    
    DWM层表的构建: 指标字段  + 各个表维度相关的字段
    
    维度: 
    	固有维度:
    		时间维度: 年  月  天 小时
    		新老维度:
    		线上线下
    	
    	产品属性维度:
    		总意向量
    		地区(区域)维度
    		学科维度
    		校区维度
    		来源渠道
    		各咨询中心
    
    DWM表的字段:
    customer_id,
    create_date_time, yearinfo  monthinfo dayinfo hourinfo
    deleted (意义不大)
    clue_state_stat(此字段需要转换)
    origin_type_stat
    area,
    itcast_subject_id,itcast_subject_name
    itcast_school_id,itcast_school_name
    origin_type
    tdepart_id,tdepart_name
    ```

    

  * DWS层: 数据业务层

    * 作用: 细化统计各个维度的数据

    ```properties
    DWS层表字段构成:  统计的字段 + 各个维度的字段 + 三个用于查询的字段
    
    维度: 
    	固有维度:
    		时间维度: 年  月  天 小时
    		新老维度:
    		线上线下
    	
    	产品属性维度:
    		总意向量
    		地区(区域)维度
    		学科维度
    		校区维度
    		来源渠道
    		各咨询中心
    
    DWS层表字段:
       customerid_total, 
       yearinfo,monthinfo,dayinfo,hourinfo
       clue_state_stat,
       origin_type_stat,
       area
       itcast_subject_id,itcast_subject_name
       itcast_school_id,itcast_school_name
       origin_type
       tdepart_id,tdepart_name
       group_type
       time_type
       time_str 
    ```

* DA层:  数据应用层

  * 此层不需要

### 5.4 分桶表优化方案:

思考: 什么是分桶表?

```properties
	主要是用于分文件的, 在建表的时候, 指定按照那些字段执行分桶操作, 并可以设置需要分多少个桶, 当插入数据的时候, 执行MR的分区的操作, 将数据分散各个分区(hive分桶)中, 默认分发方案: hash 取模
```

如何构建一个分桶表呢?

```sql
create table test_buck(id int, name string)
clustered by(id) sorted by (id asc) into 6 buckets   -- 创建分桶表的SQL
row format delimited fields terminated by '\t';
```

如何向分桶表添加数据呢?

```properties
标准格式: 
	1) 创建一张与分桶表一样的临时表,唯一区别这个表不是一个分桶表
	2) 将数据加载到这个临时表中
	3) 通过 insert into + select 语句将数据导入到分桶表中

说明: sqoop不支持直接对分桶表导入数据
```

分桶表有什么作用呢?

```properties
1) 进行数据采样
	案例1: 数据质量校验工作(一般会先判断各个字段数据的结构信息是否完整)
	案例2:  在进行数据分析的时候, 一天需要编写N多条SQL, 但是每编写一条SQL后, 都需要对SQL做一个校验, 如果直接面对完整的数据集做校验, 会导致校验时间过长, 影响开发进度, 此时可以先采样出一部分数据
	案例3:  在计算一些比率值,或者 在计算相对指标的时候, 也会基于采样数据来计算相对指标
		比如: 计算当前月的销售额相对上个月 环比增长了百分之多少? 
			可以选择当前月和上个月抽取出百分之30的数据, 基于这个数据来计算
2) 提升查询的效率(单表|多表)
```

![image-20210927104716938](day06_教育项目.assets/image-20210927104716938.png)

#### 5.4.1 如何进行数据采样

* 采样函数: tablesample(bucket x out of y on column)

```properties
采样函数:
    tablesample(bucket x out of y on column)

放置位置: 紧紧放置表的后面  如果表有别名 必须放置别名的前面

说明:
    x:  从第几个桶开始进行采样
    y:  抽样比例(总桶数/y=分多少个桶)
    column: 分桶的字段, 可以省略的

注意:
   x 不能大于 y
   y 必须是表的分桶数量的倍数或者因子


案例: 
    1) 假设 A表有10个桶,  请分析, 下面的采样函数, 会将那些桶抽取出来
         tablesample(bucket 2 out of 5 on xxx)
       
       会抽取几个桶呢?    总桶 / y =  分桶数量    2
       抽取第几个编号的桶?  (x+y)
           2,7
    2)  假设 A表有20个桶,  请分析, 下面的采样函数, 会将那些桶抽取出来
   		 tablesample(bucket 4 out of 4 on xxx)
   	   
   	   会抽取几个桶呢?    总桶 / y =  分桶数量    5
       抽取第几个编号的桶?  (x+y)
           4,8,12,16,20
```

#### 5.4.2 如何提升查询的效率

​		对于单表效率的提升, 已经在前面讲过了, 这里不再讲解....

以下主要来讲解, 关于多表的效率的提升



思考: 当多表进行join的时候, 如何提升join效率呢?

reduce端join的流程:

![image-20210927112750681](day06_教育项目.assets/image-20210927112750681.png)

```properties
可能出现的问题:
	1) 可能出现数据倾斜的问题
	2) 导致reduce压力较大
```



* 小表和大表:

  * 采用 map join的方案

  ```properties
  	在进行join的时候, 将小表的数据放置到每一个读取大表的mapTask的内存中, 让mapTask每读取一次大表的数据都和内存中小表的数据进行join操作, 将join上的结果输出到reduce端即可, 从而实现在map端完成join的操作
  ```

  ![image-20210927112543264](day06_教育项目.assets/image-20210927112543264.png)

  ```sql
  如何开启map Join
  	set hive.auto.convert.join=true;  -- 是否开启map Join
  	set hive.auto.convert.join.noconditionaltask.size=512000000; -- 设置小表最大的阈值(设置block cache 缓存大小)
  	
  map Join  不限制任何表
  ```

* 中型表和大表:

  * 中型表: 与小表相比 大约是小表3~10倍左右

  * 解决方案: 

    * 1) 能提前过滤就提前过滤掉(一旦提前过滤后, 会导致中型表的数据量会下降, 有可能达到小表阈值)
      2) 如果join的字段值有大量的null, 可以尝试添加随机数(保证各个reduce接收数据量差不多的, 减少数据倾斜问题)
      3) 基于分桶表的: bucket map join

      ```properties
      bucket map join的生效条件:
      1） set hive.optimize.bucketmapjoin = true;  --开启bucket map join 支持
      2） 一个表的bucket数是另一个表bucket数的整数倍
      3） bucket列 == join列
      4） 必须是应用在map join的场景中
      
      注意：如果表不是bucket的，则只是做普通join。
      ```

      ![image-20210927115223412](day06_教育项目.assets/image-20210927115223412.png)

* 大表和大表:

  * 解决方案:

    * 1. 能提前过滤就提前过滤掉(减少join之间的数量, 提升reduce执行效率)
    * 2. 如果join的字段值有大量的null, 可以尝试添加随机数(保证各个reduce接收数据量差不多的, 减少数据倾斜问题)

    * 3. SMB Map join (sort merge bucket map join)

      ```properties
      实现SMB map join的条件要求: 
      1） 一个表的bucket数等于另一个表bucket数(分桶数量是一致)
      2） bucket列 == join列 == sort 列
      3） 必须是应用在bucket map join的场景中
      4) 开启相关的参数:
      	-- 开启SMB map join
      	set hive.auto.convert.sortmerge.join=true;
      	set hive.auto.convert.sortmerge.join.noconditionaltask=true;
      	--写入数据强制排序
      	set hive.enforce.sorting=true;
      	set hive.optimize.bucketmapjoin.sortedmerge = true; -- 开启自动尝试SMB连接
      ```

      

### 5.5 建模操作

* ODS层: 

```sql
set hive.exec.orc.compression.strategy=COMPRESSION;
-- 客户意向表(内部 分区 分桶表, 拉链表)
CREATE TABLE IF NOT EXISTS itcast_ods.`customer_relationship` (
  `id` int COMMENT '客户关系id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '最后更新时间',
  `deleted` int COMMENT '是否被删除（禁用）',
  `customer_id` int COMMENT '所属客户id',
  `first_id` int COMMENT '第一条客户关系id',
  `belonger` int COMMENT '归属人',
  `belonger_name` STRING COMMENT '归属人姓名',
  `initial_belonger` int COMMENT '初始归属人',
  `distribution_handler` int COMMENT '分配处理人',
  `business_scrm_department_id` int COMMENT '归属部门',
  `last_visit_time` STRING COMMENT '最后回访时间',
  `next_visit_time` STRING COMMENT '下次回访时间',
  `origin_type` STRING COMMENT '数据来源',
  `itcast_school_id` int COMMENT '校区Id',
  `itcast_subject_id` int COMMENT '学科Id',
  `intention_study_type` STRING COMMENT '意向学习方式',
  `anticipat_signup_date` STRING COMMENT '预计报名时间',
  `level` STRING COMMENT '客户级别',
  `creator` int COMMENT '创建人',
  `current_creator` int COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
  `creator_name` STRING COMMENT '创建者姓名',
  `origin_channel` STRING COMMENT '来源渠道',
  `comment` STRING COMMENT '备注',
  `first_customer_clue_id` int COMMENT '第一条线索id',
  `last_customer_clue_id` int COMMENT '最后一条线索id',
  `process_state` STRING COMMENT '处理状态',
  `process_time` STRING COMMENT '处理状态变动时间',
  `payment_state` STRING COMMENT '支付状态',
  `payment_time` STRING COMMENT '支付状态变动时间',
  `signup_state` STRING COMMENT '报名状态',
  `signup_time` STRING COMMENT '报名时间',
  `notice_state` STRING COMMENT '通知状态',
  `notice_time` STRING COMMENT '通知状态变动时间',
  `lock_state` STRING COMMENT '锁定状态',
  `lock_time` STRING COMMENT '锁定状态修改时间',
  `itcast_clazz_id` int COMMENT '所属ems班级id',
  `itcast_clazz_time` STRING COMMENT '报班时间',
  `payment_url` STRING COMMENT '付款链接',
  `payment_url_time` STRING COMMENT '支付链接生成时间',
  `ems_student_id` int COMMENT 'ems的学生id',
  `delete_reason` STRING COMMENT '删除原因',
  `deleter` int COMMENT '删除人',
  `deleter_name` STRING COMMENT '删除人姓名',
  `delete_time` STRING COMMENT '删除时间',
  `course_id` int COMMENT '课程ID',
  `course_name` STRING COMMENT '课程名称',
  `delete_comment` STRING COMMENT '删除原因说明',
  `close_state` STRING COMMENT '关闭装填',
  `close_time` STRING COMMENT '关闭状态变动时间',
  `appeal_id` int COMMENT '申诉id',
  `tenant` int COMMENT '租户',
  `total_fee` DECIMAL COMMENT '报名费总金额',
  `belonged` int COMMENT '小周期归属人',
  `belonged_time` STRING COMMENT '归属时间',
  `belonger_time` STRING COMMENT '归属时间',
  `transfer` int COMMENT '转移人',
  `transfer_time` STRING COMMENT '转移时间',
  `follow_type` int COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
  `transfer_bxg_oa_account` STRING COMMENT '转移到博学谷归属人OA账号',
  `transfer_bxg_belonger_name` STRING COMMENT '转移到博学谷归属人OA姓名',
  `end_time` STRING COMMENT '有效截止时间')
comment '客户关系表'
PARTITIONED BY(start_time STRING)
clustered by(id) sorted by(id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='ZLIB');

-- 客户线索表: (内部分区分桶表, 拉链表)
CREATE TABLE IF NOT EXISTS itcast_ods.customer_clue (
  id int COMMENT 'customer_clue_id',
  create_date_time STRING COMMENT '创建时间',
  update_date_time STRING COMMENT '最后更新时间',
  deleted STRING COMMENT '是否被删除（禁用）',
  customer_id int COMMENT '客户id',
  customer_relationship_id int COMMENT '客户关系id',
  session_id STRING COMMENT '七陌会话id',
  sid STRING COMMENT '访客id',
  status STRING COMMENT '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
  users STRING COMMENT '所属坐席',
  create_time STRING COMMENT '七陌创建时间',
  platform STRING COMMENT '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
  s_name STRING COMMENT '用户名称',
  seo_source STRING COMMENT '搜索来源',
  seo_keywords STRING COMMENT '关键字',
  ip STRING COMMENT 'IP地址',
  referrer STRING COMMENT '上级来源页面',
  from_url STRING COMMENT '会话来源页面',
  landing_page_url STRING COMMENT '访客着陆页面',
  url_title STRING COMMENT '咨询页面title',
  to_peer STRING COMMENT '所属技能组',
  manual_time STRING COMMENT '人工开始时间',
  begin_time STRING COMMENT '坐席领取时间 ',
  reply_msg_count int COMMENT '客服回复消息数',
  total_msg_count int COMMENT '消息总数',
  msg_count int COMMENT '客户发送消息数',
  comment STRING COMMENT '备注',
  finish_reason STRING COMMENT '结束类型',
  finish_user STRING COMMENT '结束坐席',
  end_time STRING COMMENT '会话结束时间',
  platform_description STRING COMMENT '客户平台信息',
  browser_name STRING COMMENT '浏览器名称',
  os_info STRING COMMENT '系统名称',
  area STRING COMMENT '区域',
  country STRING COMMENT '所在国家',
  province STRING COMMENT '省',
  city STRING COMMENT '城市',
  creator int COMMENT '创建人',
  name STRING COMMENT '客户姓名',
  idcard STRING COMMENT '身份证号',
  phone STRING COMMENT '手机号',
  itcast_school_id int COMMENT '校区Id',
  itcast_school STRING COMMENT '校区',
  itcast_subject_id int COMMENT '学科Id',
  itcast_subject STRING COMMENT '学科',
  wechat STRING COMMENT '微信',
  qq STRING COMMENT 'qq号',
  email STRING COMMENT '邮箱',
  gender STRING COMMENT '性别',
  level STRING COMMENT '客户级别',
  origin_type STRING COMMENT '数据来源渠道',
  information_way STRING COMMENT '资讯方式',
  working_years STRING COMMENT '开始工作时间',
  technical_directions STRING COMMENT '技术方向',
  customer_state STRING COMMENT '当前客户状态',
  valid STRING COMMENT '该线索是否是网资有效线索',
  anticipat_signup_date STRING COMMENT '预计报名时间',
  clue_state STRING COMMENT '线索状态',
  scrm_department_id int COMMENT 'SCRM内部部门id',
  superior_url STRING COMMENT '诸葛获取上级页面URL',
  superior_source STRING COMMENT '诸葛获取上级页面URL标题',
  landing_url STRING COMMENT '诸葛获取着陆页面URL',
  landing_source STRING COMMENT '诸葛获取着陆页面URL来源',
  info_url STRING COMMENT '诸葛获取留咨页URL',
  info_source STRING COMMENT '诸葛获取留咨页URL标题',
  origin_channel STRING COMMENT '投放渠道',
  course_id int COMMENT '课程编号',
  course_name STRING COMMENT '课程名称',
  zhuge_session_id STRING COMMENT 'zhuge会话id',
  is_repeat int COMMENT '是否重复线索(手机号维度) 0:正常 1：重复',
  tenant int COMMENT '租户id',
  activity_id STRING COMMENT '活动id',
  activity_name STRING COMMENT '活动名称',
  follow_type int COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
  shunt_mode_id int COMMENT '匹配到的技能组id',
  shunt_employee_group_id int COMMENT '所属分流员工组',
  ends_time STRING COMMENT '有效时间')
comment '客户关系表'
PARTITIONED BY(starts_time STRING)
clustered by(customer_relationship_id) sorted by(customer_relationship_id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='ZLIB');

```

* DIM层: 

```sql
CREATE DATABASE IF NOT EXISTS itcast_dimen;
-- 客户表
CREATE TABLE IF NOT EXISTS itcast_dimen.`customer` (
  `id` int COMMENT 'key id',
  `customer_relationship_id` int COMMENT '当前意向id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '最后更新时间',
  `deleted` int  COMMENT '是否被删除（禁用）',
  `name` STRING COMMENT '姓名',
  `idcard` STRING  COMMENT '身份证号',
  `birth_year` int COMMENT '出生年份',
  `gender` STRING COMMENT '性别',
  `phone` STRING COMMENT '手机号',
  `wechat` STRING COMMENT '微信',
  `qq` STRING COMMENT 'qq号',
  `email` STRING COMMENT '邮箱',
  `area` STRING COMMENT '所在区域',
  `leave_school_date` date COMMENT '离校时间',
  `graduation_date` date COMMENT '毕业时间',
  `bxg_student_id` STRING COMMENT '博学谷学员ID，可能未关联到，不存在',
  `creator` int COMMENT '创建人ID',
  `origin_type` STRING COMMENT '数据来源',
  `origin_channel` STRING COMMENT '来源渠道',
  `tenant` int,
  `md_id` int COMMENT '中台id')
comment '客户表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 学科表
CREATE TABLE IF NOT EXISTS itcast_dimen.`itcast_subject` (
  `id` int COMMENT '自增主键',
  `create_date_time` timestamp COMMENT '创建时间',
  `update_date_time` timestamp COMMENT '最后更新时间',
  `deleted` STRING COMMENT '是否被删除（禁用）',
  `name` STRING COMMENT '学科名称',
  `code` STRING COMMENT '学科编码',
  `tenant` int COMMENT '租户')
comment '学科字典表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 校区表
CREATE TABLE IF NOT EXISTS itcast_dimen.`itcast_school` (
  `id` int COMMENT '自增主键',
  `create_date_time` timestamp COMMENT '创建时间',
  `update_date_time` timestamp  COMMENT '最后更新时间',
  `deleted` STRING COMMENT '是否被删除（禁用）',
  `name` STRING COMMENT '校区名称',
  `code` STRING COMMENT '校区标识',
  `tenant` int COMMENT '租户')
comment '校区字典表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 员工表
CREATE TABLE IF NOT EXISTS itcast_dimen.employee (
  id int COMMENT '员工id',
  email STRING COMMENT '公司邮箱，OA登录账号',
  real_name STRING COMMENT '员工的真实姓名',
  phone STRING COMMENT '手机号，目前还没有使用；隐私问题OA接口没有提供这个属性，',
  department_id STRING COMMENT 'OA中的部门编号，有负值',
  department_name STRING COMMENT 'OA中的部门名',
  remote_login STRING COMMENT '员工是否可以远程登录',
  job_number STRING COMMENT '员工工号',
  cross_school STRING COMMENT '是否有跨校区权限',
  last_login_date STRING COMMENT '最后登录日期',
  creator int COMMENT '创建人',
  create_date_time STRING COMMENT '创建时间',
  update_date_time STRING COMMENT '最后更新时间',
  deleted STRING COMMENT '是否被删除（禁用）',
  scrm_department_id int COMMENT 'SCRM内部部门id',
  leave_office STRING COMMENT '离职状态',
  leave_office_time STRING COMMENT '离职时间',
  reinstated_time STRING COMMENT '复职时间',
  superior_leaders_id int COMMENT '上级领导ID',
  tdepart_id int COMMENT '直属部门',
  tenant int COMMENT '租户',
  ems_user_name STRING COMMENT 'ems用户名称'
)
comment '员工表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

-- 部门表
CREATE TABLE IF NOT EXISTS itcast_dimen.`scrm_department` (
  `id` int COMMENT '部门id',
  `name` STRING COMMENT '部门名称',
  `parent_id` int COMMENT '父部门id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '更新时间',
  `deleted` STRING COMMENT '删除标志',
  `id_path` STRING COMMENT '编码全路径',
  `tdepart_code` int COMMENT '直属部门',
  `creator` STRING COMMENT '创建者',
  `depart_level` int COMMENT '部门层级',
  `depart_sign` int COMMENT '部门标志，暂时默认1',
  `depart_line` int COMMENT '业务线，存储业务线编码',
  `depart_sort` int COMMENT '排序字段',
  `disable_flag` int COMMENT '禁用标志',
  `tenant` int COMMENT '租户')
comment 'scrm部门表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');
```

* DWD层

```sql
CREATE TABLE IF NOT EXISTS itcast_dwd.`itcast_intention_dwd` (
  `rid` int COMMENT 'id',
  `customer_id` STRING COMMENT '客户id',
  `create_date_time` STRING COMMENT '创建时间',
  `itcast_school_id` STRING COMMENT '校区id',
  `deleted` STRING COMMENT '是否被删除',
  `origin_type` STRING COMMENT '来源渠道',
  `itcast_subject_id` STRING COMMENT '学科id',
  `creator` int COMMENT '创建人',
  `hourinfo` STRING COMMENT '小时信息',
  `origin_type_stat` STRING COMMENT '数据来源:0.线下；1.线上'
)
comment '客户意向dwd表'
PARTITIONED BY(yearinfo STRING,monthinfo STRING,dayinfo STRING)
clustered by(rid) sorted by(rid) into 10 buckets
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');
```

* DWM层:

```sql
create database itcast_dwm;

CREATE TABLE IF NOT EXISTS itcast_dwm.`itcast_intention_dwm` (
  `customer_id` STRING COMMENT 'id信息',
  `create_date_time` STRING COMMENT '创建时间',
  `area` STRING COMMENT '区域信息',
  `itcast_school_id` STRING COMMENT '校区id',
  `itcast_school_name` STRING COMMENT '校区名称',
  `deleted` STRING COMMENT '是否被删除',
  `origin_type` STRING COMMENT '来源渠道',
  `itcast_subject_id` STRING COMMENT '学科id',
  `itcast_subject_name` STRING COMMENT '学科名称',
  `hourinfo` STRING COMMENT '小时信息',
  `origin_type_stat` STRING COMMENT '数据来源:0.线下；1.线上',
  `clue_state_stat` STRING COMMENT '新老客户：0.老客户；1.新客户',
  `tdepart_id` STRING COMMENT '创建者部门id',
  `tdepart_name` STRING COMMENT '咨询中心名称'
)
comment '客户意向dwm表'
PARTITIONED BY(yearinfo STRING,monthinfo STRING,dayinfo STRING)
clustered by(customer_id) sorted by(customer_id) into 10 buckets
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');

```

* DWS层:

```sql
CREATE TABLE IF NOT EXISTS itcast_dws.itcast_intention_dws (
   `customer_total` INT COMMENT '聚合意向客户数',
   `area` STRING COMMENT '区域信息',
   `itcast_school_id` STRING COMMENT '校区id',
   `itcast_school_name` STRING COMMENT '校区名称',
   `origin_type` STRING COMMENT '来源渠道',
   `itcast_subject_id` STRING COMMENT '学科id',
   `itcast_subject_name` STRING COMMENT '学科名称',
   `hourinfo` STRING COMMENT '小时信息',
   `origin_type_stat` STRING COMMENT '数据来源:0.线下；1.线上',
   `clue_state_stat` STRING COMMENT '客户属性：0.老客户；1.新客户',
   `tdepart_id` STRING COMMENT '创建者部门id',
   `tdepart_name` STRING COMMENT '咨询中心名称',
   `time_str` STRING COMMENT '时间明细',
   `groupType` STRING COMMENT '产品属性类别：1.总意向量；2.区域信息；3.校区、学科组合分组；4.来源渠道；5.咨询中心;',
   `time_type` STRING COMMENT '时间维度：1、按小时聚合；2、按天聚合；3、按周聚合；4、按月聚合；5、按年聚合；'
)
comment '客户意向dws表'
PARTITIONED BY(yearinfo STRING,monthinfo STRING,dayinfo STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='SNAPPY');

```

### 5.6 数据采集

指的: 将业务库中的数据一对一导入到ODS层的对应表中

```properties
业务库: mysql
ODS层:  hive

技术: 使用apache sqoop
```

* DIM层:

```shell
# 客户表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  *, "2021-09-27" AS start_time
FROM customer where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_dimen \
--hcatalog-table customer \
-m 1 

# 学科表:
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  *, "2021-09-27" AS start_time
FROM itcast_subject where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_dimen \
--hcatalog-table itcast_subject \
-m 1 

# 校区表:
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  *, "2021-09-27" AS start_time
FROM itcast_school where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_dimen \
--hcatalog-table itcast_school \
-m 1 

# 员工表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  *, "2021-09-27" AS start_time
FROM employee where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_dimen \
--hcatalog-table employee \
-m 1

# 部门表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  *, "2021-09-27" AS start_time
FROM scrm_department where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_dimen \
--hcatalog-table scrm_department \
-m 1
```

* ODS层:

```sql
-- 客户意向表
-- 第一步: 创建一张客户意向表的临时表
CREATE TABLE IF NOT EXISTS itcast_ods.`customer_relationship_temp` (
  `id` int COMMENT '客户关系id',
  `create_date_time` STRING COMMENT '创建时间',
  `update_date_time` STRING COMMENT '最后更新时间',
  `deleted` int COMMENT '是否被删除（禁用）',
  `customer_id` int COMMENT '所属客户id',
  `first_id` int COMMENT '第一条客户关系id',
  `belonger` int COMMENT '归属人',
  `belonger_name` STRING COMMENT '归属人姓名',
  `initial_belonger` int COMMENT '初始归属人',
  `distribution_handler` int COMMENT '分配处理人',
  `business_scrm_department_id` int COMMENT '归属部门',
  `last_visit_time` STRING COMMENT '最后回访时间',
  `next_visit_time` STRING COMMENT '下次回访时间',
  `origin_type` STRING COMMENT '数据来源',
  `itcast_school_id` int COMMENT '校区Id',
  `itcast_subject_id` int COMMENT '学科Id',
  `intention_study_type` STRING COMMENT '意向学习方式',
  `anticipat_signup_date` STRING COMMENT '预计报名时间',
  `level` STRING COMMENT '客户级别',
  `creator` int COMMENT '创建人',
  `current_creator` int COMMENT '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
  `creator_name` STRING COMMENT '创建者姓名',
  `origin_channel` STRING COMMENT '来源渠道',
  `comment` STRING COMMENT '备注',
  `first_customer_clue_id` int COMMENT '第一条线索id',
  `last_customer_clue_id` int COMMENT '最后一条线索id',
  `process_state` STRING COMMENT '处理状态',
  `process_time` STRING COMMENT '处理状态变动时间',
  `payment_state` STRING COMMENT '支付状态',
  `payment_time` STRING COMMENT '支付状态变动时间',
  `signup_state` STRING COMMENT '报名状态',
  `signup_time` STRING COMMENT '报名时间',
  `notice_state` STRING COMMENT '通知状态',
  `notice_time` STRING COMMENT '通知状态变动时间',
  `lock_state` STRING COMMENT '锁定状态',
  `lock_time` STRING COMMENT '锁定状态修改时间',
  `itcast_clazz_id` int COMMENT '所属ems班级id',
  `itcast_clazz_time` STRING COMMENT '报班时间',
  `payment_url` STRING COMMENT '付款链接',
  `payment_url_time` STRING COMMENT '支付链接生成时间',
  `ems_student_id` int COMMENT 'ems的学生id',
  `delete_reason` STRING COMMENT '删除原因',
  `deleter` int COMMENT '删除人',
  `deleter_name` STRING COMMENT '删除人姓名',
  `delete_time` STRING COMMENT '删除时间',
  `course_id` int COMMENT '课程ID',
  `course_name` STRING COMMENT '课程名称',
  `delete_comment` STRING COMMENT '删除原因说明',
  `close_state` STRING COMMENT '关闭装填',
  `close_time` STRING COMMENT '关闭状态变动时间',
  `appeal_id` int COMMENT '申诉id',
  `tenant` int COMMENT '租户',
  `total_fee` DECIMAL COMMENT '报名费总金额',
  `belonged` int COMMENT '小周期归属人',
  `belonged_time` STRING COMMENT '归属时间',
  `belonger_time` STRING COMMENT '归属时间',
  `transfer` int COMMENT '转移人',
  `transfer_time` STRING COMMENT '转移时间',
  `follow_type` int COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
  `transfer_bxg_oa_account` STRING COMMENT '转移到博学谷归属人OA账号',
  `transfer_bxg_belonger_name` STRING COMMENT '转移到博学谷归属人OA姓名',
  `end_time` STRING COMMENT '有效截止时间')
comment '客户关系表'
PARTITIONED BY(start_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='ZLIB');

-- 第二步: 编写sqoop命令 将数据导入到临时表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  *, "9999-12-31" as end_time , "2021-09-27" AS start_time
FROM customer_relationship where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table customer_relationship_temp \
-m 1

-- 第三步: 执行 insert into + select 导入到目标表
-- 动态分区配置
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
-- hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
-- 写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;

insert into table itcast_ods.customer_relationship partition(start_time)
select * from itcast_ods.customer_relationship_temp;
```

客户线索表

```sql
-- 第一步: 创建客户线索表的临时表
CREATE TABLE IF NOT EXISTS itcast_ods.customer_clue_temp (
  id int COMMENT 'customer_clue_id',
  create_date_time STRING COMMENT '创建时间',
  update_date_time STRING COMMENT '最后更新时间',
  deleted STRING COMMENT '是否被删除（禁用）',
  customer_id int COMMENT '客户id',
  customer_relationship_id int COMMENT '客户关系id',
  session_id STRING COMMENT '七陌会话id',
  sid STRING COMMENT '访客id',
  status STRING COMMENT '状态（undeal待领取 deal 已领取 finish 已关闭 changePeer 已流转）',
  users STRING COMMENT '所属坐席',
  create_time STRING COMMENT '七陌创建时间',
  platform STRING COMMENT '平台来源 （pc-网站咨询|wap-wap咨询|sdk-app咨询|weixin-微信咨询）',
  s_name STRING COMMENT '用户名称',
  seo_source STRING COMMENT '搜索来源',
  seo_keywords STRING COMMENT '关键字',
  ip STRING COMMENT 'IP地址',
  referrer STRING COMMENT '上级来源页面',
  from_url STRING COMMENT '会话来源页面',
  landing_page_url STRING COMMENT '访客着陆页面',
  url_title STRING COMMENT '咨询页面title',
  to_peer STRING COMMENT '所属技能组',
  manual_time STRING COMMENT '人工开始时间',
  begin_time STRING COMMENT '坐席领取时间 ',
  reply_msg_count int COMMENT '客服回复消息数',
  total_msg_count int COMMENT '消息总数',
  msg_count int COMMENT '客户发送消息数',
  comment STRING COMMENT '备注',
  finish_reason STRING COMMENT '结束类型',
  finish_user STRING COMMENT '结束坐席',
  end_time STRING COMMENT '会话结束时间',
  platform_description STRING COMMENT '客户平台信息',
  browser_name STRING COMMENT '浏览器名称',
  os_info STRING COMMENT '系统名称',
  area STRING COMMENT '区域',
  country STRING COMMENT '所在国家',
  province STRING COMMENT '省',
  city STRING COMMENT '城市',
  creator int COMMENT '创建人',
  name STRING COMMENT '客户姓名',
  idcard STRING COMMENT '身份证号',
  phone STRING COMMENT '手机号',
  itcast_school_id int COMMENT '校区Id',
  itcast_school STRING COMMENT '校区',
  itcast_subject_id int COMMENT '学科Id',
  itcast_subject STRING COMMENT '学科',
  wechat STRING COMMENT '微信',
  qq STRING COMMENT 'qq号',
  email STRING COMMENT '邮箱',
  gender STRING COMMENT '性别',
  level STRING COMMENT '客户级别',
  origin_type STRING COMMENT '数据来源渠道',
  information_way STRING COMMENT '资讯方式',
  working_years STRING COMMENT '开始工作时间',
  technical_directions STRING COMMENT '技术方向',
  customer_state STRING COMMENT '当前客户状态',
  valid STRING COMMENT '该线索是否是网资有效线索',
  anticipat_signup_date STRING COMMENT '预计报名时间',
  clue_state STRING COMMENT '线索状态',
  scrm_department_id int COMMENT 'SCRM内部部门id',
  superior_url STRING COMMENT '诸葛获取上级页面URL',
  superior_source STRING COMMENT '诸葛获取上级页面URL标题',
  landing_url STRING COMMENT '诸葛获取着陆页面URL',
  landing_source STRING COMMENT '诸葛获取着陆页面URL来源',
  info_url STRING COMMENT '诸葛获取留咨页URL',
  info_source STRING COMMENT '诸葛获取留咨页URL标题',
  origin_channel STRING COMMENT '投放渠道',
  course_id int COMMENT '课程编号',
  course_name STRING COMMENT '课程名称',
  zhuge_session_id STRING COMMENT 'zhuge会话id',
  is_repeat int COMMENT '是否重复线索(手机号维度) 0:正常 1：重复',
  tenant int COMMENT '租户id',
  activity_id STRING COMMENT '活动id',
  activity_name STRING COMMENT '活动名称',
  follow_type int COMMENT '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
  shunt_mode_id int COMMENT '匹配到的技能组id',
  shunt_employee_group_id int COMMENT '所属分流员工组',
  ends_time STRING COMMENT '有效时间')
comment '客户关系表'
PARTITIONED BY(starts_time STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
stored as orc
TBLPROPERTIES ('orc.compress'='ZLIB');

-- 第二步: 编写sqoop命令 将数据导入到临时表
sqoop import \
--connect jdbc:mysql://192.168.52.150:3306/scrm \
--username root \
--password 123456 \
--query 'SELECT 
  id,create_date_time,update_date_time,deleted,customer_id,customer_relationship_id,session_id,sid,status,user as users,create_time,platform,s_name,seo_source,seo_keywords,ip,referrer,from_url,landing_page_url,url_title,to_peer,manual_time,begin_time,reply_msg_count,total_msg_count,msg_count,comment,finish_reason,finish_user,end_time,platform_description,browser_name,os_info,area,country,province,city,creator,name,"-1" as idcard,"-1" as phone,itcast_school_id,itcast_school,itcast_subject_id,itcast_subject,"-1" as wechat,"-1" as qq,"-1" as email,gender,level,origin_type,information_way,working_years,technical_directions,customer_state,valid,anticipat_signup_date,clue_state,scrm_department_id,superior_url,superior_source,landing_url,landing_source,info_url,info_source,origin_channel,course_id,course_name,zhuge_session_id,is_repeat,tenant,activity_id,activity_name,follow_type,shunt_mode_id,shunt_employee_group_id, "9999-12-31" as ends_time , "2021-09-27" AS starts_time
FROM customer_clue where 1=1 and $CONDITIONS' \
--hcatalog-database itcast_ods \
--hcatalog-table customer_clue_temp \
-m 1

-- 第三步:  通过 insert into + select 导入到目标表
insert into table itcast_ods.customer_clue partition(starts_time)
select * from itcast_ods.customer_clue_temp;
```

### 5.7 清洗转换操作

#### 5.7.1 生成DWD层数据

作用: 清洗 和 转换 以及少量的维度退化

```properties
维度退化操作: 此层不需要做

清洗操作: 
	将标记删除的数据过滤掉
	
转换操作: 
	1) 将create_date_time 转换为 yearinfo  monthinfo dayinfo hourinfo
    2) 将origin_type 转换为 origin_type_state (用于统计线上线下)
   		转换逻辑: origin_type的值为: NETSERVICE 或者 PRESIGNUP 认为线上 其余认为线下
    3) 将clue_state 转换为 clue_state_stat (用于统计新老维度)  -- 当前层无法转换的 (只能在DWM)
        转换逻辑:clue_state的值为 VALID_NEW_CLUES 为新客户  其余暂定为老客户
    4) 将校区和学科的 id字段, 如果为 0 或者 null 转换为 -1
```

编写SQL:

```sql
select  
    id as rid,
    customer_id,
    create_date_time,
    if(itcast_school_id is null OR itcast_school_id = 0 , '-1',itcast_school_id) as itcast_school_id, 
    deleted,
    origin_type,
    if(itcast_subject_id is not null, if(itcast_subject_id != 0,itcast_subject_id,'-1'),'-1') as itcast_subject_id, 
    creator,
    substr(create_date_time,12,2) as hourinfo, 
    if(origin_type in('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_stat,
    substr(create_date_time,1,4) as yearinfo,
    substr(create_date_time,6,2) as monthinfo,
    substr(create_date_time,9,2) as dayinfo 

from itcast_ods.customer_relationship where deleted = 0 ;
```

将转换的SQL的结果保存到DWD层表中 (此操作, 并未执行, 而是执行后续的采样SQL)

```sql
insert  into table itcast_dwd.itcast_intention_dwd partition(yearinfo,monthinfo,dayinfo)
select  
    id as rid,
    customer_id,
    create_date_time,
    if(itcast_school_id is null OR itcast_school_id = 0 , '-1',itcast_school_id) as itcast_school_id, 
    deleted,
    origin_type,
    if(itcast_subject_id is not null, if(itcast_subject_id != 0,itcast_subject_id,'-1'),'-1') as itcast_subject_id, 
    creator,
    substr(create_date_time,12,2) as hourinfo, 
    if(origin_type in('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_stat,
    substr(create_date_time,1,4) as yearinfo,
    substr(create_date_time,6,2) as monthinfo,
    substr(create_date_time,9,2) as dayinfo 

from itcast_ods.customer_relationship  where deleted = 0 ;
```

如果希望在灌入到DWD层的时候, 对数据进行采样操作: 比如只想要第5个桶

```sql
explain
insert  into table itcast_dwd.itcast_intention_dwd partition(yearinfo,monthinfo,dayinfo)
select  
    id as rid,
    customer_id,
    create_date_time,
    if(itcast_school_id is null OR itcast_school_id = 0 , '-1',itcast_school_id) as itcast_school_id, 
    deleted,
    origin_type,
    if(itcast_subject_id is not null, if(itcast_subject_id != 0,itcast_subject_id,'-1'),'-1') as itcast_subject_id, 
    creator,
    substr(create_date_time,12,2) as hourinfo, 
    if(origin_type in('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_stat,
    substr(create_date_time,1,4) as yearinfo,
    substr(create_date_time,6,2) as monthinfo,
    substr(create_date_time,9,2) as dayinfo 

from itcast_ods.customer_relationship tablesample(bucket 5 out of 10 on id) where deleted = 0 ;
```

![image-20210927162116323](day06_教育项目.assets/image-20210927162116323.png)

执行采样导入到DWD层

```sql
--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true; -- 开启分桶支持, 默认就是true
set hive.enforce.sorting=true; -- 开启强制排序

insert  into table itcast_dwd.itcast_intention_dwd partition(yearinfo,monthinfo,dayinfo)
select  
    id as rid,
    customer_id,
    create_date_time,
    if(itcast_school_id is null OR itcast_school_id = 0 , '-1',itcast_school_id) as itcast_school_id, 
    deleted,
    origin_type,
    if(itcast_subject_id is not null, if(itcast_subject_id != 0,itcast_subject_id,'-1'),'-1') as itcast_subject_id, 
    creator,
    substr(create_date_time,12,2) as hourinfo, 
    if(origin_type in('NETSERVICE','PRESIGNUP'),'1','0') as origin_type_stat,
    substr(create_date_time,1,4) as yearinfo,
    substr(create_date_time,6,2) as monthinfo,
    substr(create_date_time,9,2) as dayinfo 

from itcast_ods.customer_relationship tablesample(bucket 5 out of 10 on id) where deleted = 0 ;
```

#### 5.7.2 生成DWM层数据

​		由于DWM层的字段是来源于事实表和所有维度表中的字段, 此时如果生成DWM层数据, 必须要先将所有的表关联在一起

```properties
所有表的表与表之间的关联条件 
	客户意向表.creator = 员工表.id
	员工表.tdepart_id = 部门表.id
	线索表.customer_relationship_id = 客户意向表.id
	客户意向表.itcast_school_id = 校区表.id
	客户意向表.itcast_subject_id = 学科表.id
	客户意向表.customer_id = 客户表.id
```

* SQL实现

```sql
select  
    iid.customer_id,
    iid.create_date_time,
    c.area,
    iid.itcast_school_id,
    sch.name as itcast_school_name,
    iid.deleted,
    iid.origin_type,
    iid.itcast_subject_id,
    sub.name as itcast_subject_name,
    iid.hourinfo,
    iid.origin_type_stat,
    -- if(cc.clue_state = 'VALID_NEW_CLUES',1,if(cc.clue_state = 'VALID_PUBLIC_NEW_CLUE','0','-1')) as clue_state_stat, -- 此处有转换
    case cc.clue_state 
        when 'VALID_NEW_CLUES' then '1'
        when 'VALID_PUBLIC_NEW_CLUE' then '0'
        else '-1' 
    end as clue_state_stat,
    emp.tdepart_id,
    dept.name as tdepart_name,
    iid.yearinfo,
    iid.monthinfo,
    iid.dayinfo
from itcast_dwd.itcast_intention_dwd  iid
    left join itcast_ods.customer_clue cc on cc.customer_relationship_id = iid.rid
    left join itcast_dimen.customer c on  iid.customer_id = c.id
    left join itcast_dimen.itcast_subject sub on  iid.itcast_subject_id = sub.id
    left join itcast_dimen.itcast_school sch  on iid.itcast_school_id = sch.id
    left join itcast_dimen.employee emp on iid.creator = emp.id
    left join itcast_dimen.scrm_department dept on emp.tdepart_id = dept.id;
```

查看这条SQL语句, 相关的优化是否执行了呢?

```sql
开启优化: 
--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true; -- 开启分桶支持, 默认就是true
set hive.enforce.sorting=true; -- 开启强制排序

-- 优化: 
set hive.auto.convert.join=true;  -- map join
set hive.optimize.bucketmapjoin = true; -- 开启 bucket map join
-- 开启SMB map join
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.sortmerge.join.noconditionaltask=true;
-- 写入数据强制排序
set hive.enforce.sorting=true;
set hive.optimize.bucketmapjoin.sortedmerge = true; -- 开启自动尝试SMB连接


通过 执行计划, 查看是否生效: explain

```

![image-20210927172246270](day06_教育项目.assets/image-20210927172246270.png)



除了这个SMB 优化生效后, 其他的表的都是存在有map join的方案

![image-20210927172336329](day06_教育项目.assets/image-20210927172336329.png)

最后执行SQL, 查看是否可以正常执行:

```properties
说明:
	通过执行发现, 开启优化, 执行速度, 异常的缓慢, 一分钟才可以执行  1% 

原因:	
	当前这种优化方案, 需要有非常的内存资源才可以运行, 如果没有, yarn会安排这些依次执行,导致执行效率更差
	如果在生产环境中, 是完全可以开启的

目前解决方案: 关闭掉所有的优化来执行
set hive.auto.convert.join=false; 
set hive.optimize.bucketmapjoin = false; 

set hive.auto.convert.sortmerge.join=false;
set hive.auto.convert.sortmerge.join.noconditionaltask=false;

set hive.enforce.sorting=false;

set hive.optimize.bucketmapjoin.sortedmerge = false; 
```



最终: 将查询出来的数据灌入到目标表即可

```sql
--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
--分桶
set hive.enforce.bucketing=true; -- 开启分桶支持, 默认就是true
set hive.enforce.sorting=true; -- 开启强制排序

-- 优化: 
set hive.auto.convert.join=false;  -- map join
set hive.optimize.bucketmapjoin = false; -- 开启 bucket map join
-- 开启SMB map join
set hive.auto.convert.sortmerge.join=false;
set hive.auto.convert.sortmerge.join.noconditionaltask=false;
-- 写入数据强制排序
set hive.enforce.sorting=false;
-- 开启自动尝试SMB连接
set hive.optimize.bucketmapjoin.sortedmerge = false; 

insert into table itcast_dwm.itcast_intention_dwm partition(yearinfo,monthinfo,dayinfo)
select  
    iid.customer_id,
    iid.create_date_time,
    c.area,
    iid.itcast_school_id,
    sch.name as itcast_school_name,
    iid.deleted,
    iid.origin_type,
    iid.itcast_subject_id,
    sub.name as itcast_subject_name,
    iid.hourinfo,
    iid.origin_type_stat,
    -- if(cc.clue_state = 'VALID_NEW_CLUES',1,if(cc.clue_state = 'VALID_PUBLIC_NEW_CLUE','0','-1')) as clue_state_stat, -- 此处有转换
    case cc.clue_state 
        when 'VALID_NEW_CLUES' then '1'
        when 'VALID_PUBLIC_NEW_CLUE' then '0'
        else '-1' 
    end as clue_state_stat,
    emp.tdepart_id,
    dept.name as tdepart_name,
    iid.yearinfo,
    iid.monthinfo,
    iid.dayinfo
from itcast_dwd.itcast_intention_dwd  iid
    left join itcast_ods.customer_clue cc on cc.customer_relationship_id = iid.rid
    left join itcast_dimen.customer c on  iid.customer_id = c.id
    left join itcast_dimen.itcast_subject sub on  iid.itcast_subject_id = sub.id
    left join itcast_dimen.itcast_school sch  on iid.itcast_school_id = sch.id
    left join itcast_dimen.employee emp on iid.creator = emp.id
    left join itcast_dimen.scrm_department dept on emp.tdepart_id = dept.id;
    
```



### 5.8 统计分析操作

​	目的: 生产DWS层的数据, 数据来源于DWM

```properties
指标: 意向量

维度: 
	固有维度:  时间(年 月 日 小时), 线上线下, 新老维度
	产品属性维度: 地区, 学科维度, 校区维度, 咨询中心维度, 来源渠道,总意向量
```

* 统计总意向量

```sql
-- 统计每年 线上线下 新老用户的总意向量
insert into table itcast_dws.itcast_intention_dws partition(yearinfo,monthinfo,dayinfo)
select 
	count( distinct customer_id) as customer_total, 
	'-1' as area,
	'-1' as itcast_school_id,
	'-1' as itcast_school_name,
	'-1' as origin_type,
	'-1' as itcast_subject_id,
	'-1' as itcast_subject_name,
	'-1' as hourinfo,
	origin_type_stat,
	clue_state_stat,
	'-1' as tdepart_id,
	'-1' as tdepart_name,
	yearinfo as time_str,
	'1' as grouptype,
	'5' as time_type,
	yearinfo,
	'-1' as monthinfo,
	'-1' as dayinfo
from itcast_dwm.itcast_intention_dwm
group by yearinfo,origin_type_stat,clue_state_stat;

-- 统计每年每月 线上线下 新老用户的总意向量
insert into table itcast_dws.itcast_intention_dws partition(yearinfo,monthinfo,dayinfo)
select 
	count( distinct customer_id) as customer_total, 
	'-1' as area,
	'-1' as itcast_school_id,
	'-1' as itcast_school_name,
	'-1' as origin_type,
	'-1' as itcast_subject_id,
	'-1' as itcast_subject_name,
	'-1' as hourinfo,
	origin_type_stat,
	clue_state_stat,
	'-1' as tdepart_id,
	'-1' as tdepart_name,
	concat(yearinfo,'-',monthinfo) as time_str,
	'1' as grouptype,
	'4' as time_type,
	yearinfo,
	monthinfo,
	'-1' as dayinfo
from itcast_dwm.itcast_intention_dwm
group by yearinfo,monthinfo,origin_type_stat,clue_state_stat;
-- 统计每年每月每日 线上线下 新老用户的总意向量
insert into table itcast_dws.itcast_intention_dws partition(yearinfo,monthinfo,dayinfo)
select 
	count( distinct customer_id) as customer_total, 
	'-1' as area,
	'-1' as itcast_school_id,
	'-1' as itcast_school_name,
	'-1' as origin_type,
	'-1' as itcast_subject_id,
	'-1' as itcast_subject_name,
	'-1' as hourinfo,
	origin_type_stat,
	clue_state_stat,
	'-1' as tdepart_id,
	'-1' as tdepart_name,
	concat(yearinfo,'-',monthinfo,'-',dayinfo) as time_str,
	'1' as grouptype,
	'2' as time_type,
	yearinfo,
	monthinfo,
	dayinfo
from itcast_dwm.itcast_intention_dwm
group by yearinfo,monthinfo,dayinfo,origin_type_stat,clue_state_stat;
-- 统计每年每月每日每小时 线上线下 新老用户的总意向量
insert into table itcast_dws.itcast_intention_dws partition(yearinfo,monthinfo,dayinfo)
select 
	count( distinct customer_id) as customer_total, 
	'-1' as area,
	'-1' as itcast_school_id,
	'-1' as itcast_school_name,
	'-1' as origin_type,
	'-1' as itcast_subject_id,
	'-1' as itcast_subject_name,
	hourinfo,
	origin_type_stat,
	clue_state_stat,
	'-1' as tdepart_id,
	'-1' as tdepart_name,
	concat(yearinfo,'-',monthinfo,'-',dayinfo,' ',hourinfo) as time_str,
	'1' as grouptype,
	'1' as time_type,
	yearinfo,
	monthinfo,
	dayinfo
from itcast_dwm.itcast_intention_dwm
group by yearinfo,monthinfo,dayinfo,hourinfo,origin_type_stat,clue_state_stat;
```

* 统计 咨询中心维度

```sql
-- 统计每年线上线下, 新老用户产生各个咨询中心的意向量
insert into table itcast_dws.itcast_intention_dws partition(yearinfo,monthinfo,dayinfo)
select 
	count( distinct customer_id) as customer_total, 
	'-1' as area,
	'-1' as itcast_school_id,
	'-1' as itcast_school_name,
	'-1' as origin_type,
	'-1' as itcast_subject_id,
	'-1' as itcast_subject_name,
	'-1' as hourinfo,
	origin_type_stat,
	clue_state_stat,
	tdepart_id,
	tdepart_name,
	yearinfo as time_str,
	'5' as grouptype,
	'5' as time_type,
	yearinfo,
	'-1' as monthinfo,
	'-1' as dayinfo
from itcast_dwm.itcast_intention_dwm
group by yearinfo,origin_type_stat,clue_state_stat,tdepart_id,tdepart_name;
```



### 5.9 数据导出操作

​	指的: 从DWS层将数据导出到MYSQL中

* 第一步: 在mysql中创建目标表

```sql
CREATE TABLE IF NOT EXISTS scrm_bi.itcast_intention (
   `customer_total` INT COMMENT '聚合意向客户数',
   `area` varchar(100) COMMENT '区域信息',
   `itcast_school_id` varchar(100) COMMENT '校区id',
   `itcast_school_name` varchar(100) COMMENT '校区名称',
   `origin_type` varchar(100) COMMENT '来源渠道',
   `itcast_subject_id` varchar(100) COMMENT '学科id',
   `itcast_subject_name` varchar(100) COMMENT '学科名称',
   `hourinfo` varchar(100) COMMENT '小时信息',
   `origin_type_stat` varchar(100) COMMENT '数据来源:0.线下；1.线上',
   `clue_state_stat` varchar(100) COMMENT '客户属性：0.老客户；1.新客户',
   `tdepart_id` varchar(100) COMMENT '创建者部门id',
   `tdepart_name` varchar(100) COMMENT '咨询中心名称',
   `time_str` varchar(100) COMMENT '时间明细',
   `groupType` varchar(100) COMMENT '产品属性类别：1.总意向量；2.区域信息；3.校区、学科组合分组；4.来源渠道；5.咨询中心;',
   `time_type` varchar(100) COMMENT '时间维度：1、按小时聚合；2、按天聚合；3、按周聚合；4、按月聚合；5、按年聚合；',
    yearinfo varchar(100) COMMENT '年' ,
    monthinfo varchar(100) COMMENT '月',
    dayinfo varchar(100) COMMENT '日'
)
comment '客户意向dws表';
```

* 第二步:执行sqoop, 将数据全部到导出 MySQL中

```shell
sqoop export \
--connect "jdbc:mysql://192.168.52.150:3306/scrm_bi?useUnicode=true&characterEncoding=utf-8" \
--username root \
--password 123456 \
--table itcast_intention \
--hcatalog-database itcast_dws \
--hcatalog-table itcast_intention_dws \
-m 1
```

