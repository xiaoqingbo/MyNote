# MySQL和SQL

```
MySQL是数据库,存储结构化数据的地方

SQL结构化查询语言,操作数据库,包括增查删改等操作
```

# SQL语法

## 一、特点

```
1、大小写不敏感
2、需以;号结尾
3、支持单行、多行注释
	单行注释： -- 注释内容（--后面一定要有一个空格）
	单行注释：# 注释内容（# 后面可以不加空格，推荐加上）
	多行注释：/*  注释内容  */
```



## 二、DDL

```
DDL（Data Definition Language）数据定义语言

功能：库的创建删除、表结构的创建删除等
```

### 1、对库操作

#### 查看有哪些数据库

```sql
show databases;
```

#### 使用数据库

```sql
use 数据库名称;
```

#### 创建数据库

```sql
create database 数据库名;
```

#### 删除数据库

```sql
drop database 数据库名;
```

#### 查看当前使用的数据库

```sql 
select database();
```

### 2、对表操作

#### 查看有哪些表

```sql
# 需要首先选择数据库
use 数据库名称;
show tables;
```

#### 创建表

```sql
create table 表名(
	列名称 列类型,
	列名称 列类型,
	列名称 列类型,
	......
);

-- 列类型有
int -- 整数
f1oat -- 浮点数
varchar(长度) -- 文本，长度为数字，做最大长度限制
date -- 日期类型
timestamp -- 时间戳类型
```

```sql
create table if not exists student(
	sid int,
	name varchar(20),
	gender varchar(20),
	age int,
	birth date,
	address varchar(20),
	score double
);
```

#### 查看表的创建语句

```sql
show create table 表名;
```

#### 查看表结构

```sql
desc 表名;
```

#### 删除表

```sql
drop table [if exists] 表名;
```

#### 修改表结构

##### 修改表名称

```sql
rename table 表名 to 新表名;
```

##### 删除表中的某一列

```sql
alter table 表名 drop 列名;
```

##### 向表中添加一个新列

```sql
alter table 表名 add 列名 类型 [约束];
```

##### 修改表中某列的名称和类型

```sql
alter table 表名 change 旧列名 新列名 类型 [约束]; 
```



## 三、DML

```
DML（Data Manipulation Language）是指数据操作语言

功能：对表中的数据进行操作(增、删、改)
```

### 1、数据插入

```sql
-- 语法1 
insert into 表名 (列名1,列名2,列名3...) values (值1,值2,值3...)；//向表中插入某一行的数据

-- 插入一行数据
insert into stu(sid,name,gender,age,birthday,address,score) values(222080092,'肖庆波','男',23,'1999-03-17','杭州',100);

-- 插入多行数据
insert into stu(sid,name,gender,age,birthday,address,score) 
	values(222080093,'王五','男',47,'1932-06-17','广州',99.5),
		(222080094,'李四','男',36,'1962-09-04','北京',99.9),
		(222080095,'张三','女',25,'1995-12-23','上海',99.2);


-- 插入单个或多个数据
insert into stu(sid) values(10010);
insert into stu(sid,name,score) values(10023,'特朗普',0);
```

```sql
-- 语法2 
insert into 表名 values (值1,值2,值3...);     //向表中插入所有行的数据
insert into stu values(10223,'zhao','男',12,'1780-01-28','湖北',78);
```




### 2、数据修改

```sql
-- 语法1 
update 表名 set 列名=值,列名=值...;

-- 将所有学生的地址修改为重庆 
update stu set address='重庆';

-- 将所有学生的地址修改为北京,成绩修改为100
update stu set address='北京',score=100;
```

```sql
-- 语法2 
update 表名 set 字段名=值,字段名=值... where 条件;
-- 将id为222080092的学生的地址修改为湖北 
update stu set address='湖北' where sid=222080092;

-- 将年龄大于30的学生的地址修改为北京，成绩修成绩修改为99
update stu set address='北京',score=99 where age > 30; 
```



### 3、数据删除(清空某一行数据)

```sql
-- 语法1 
delete from 表名 [where 条件];

-- 删除所有地址在上海的学生数据
delete from stu where address='上海';

-- 删除表中所有数据（注意：不是删除表）
delete from 表名;
```

```sql
-- 语法2 
truncate table 表名 
	或者 
truncate 表名（清空表数据）

-- 注意：delete和truncate原理不同，delete只删除内容，而truncate类似于drop table ，可以理解为是将整个表删除，然后再自动创建该表；
truncate table stu;
truncate stu;
```



## 四、DQL

```
DQL（Data Query Language）数据查询语言

功能：基于需求查询和计算数据
```

### 1、基础查询

```sql
select 列名1,列名2,... from 表名;
	
功能：从（FROM）表中，选择（SELECT）某些列进行展示
```

```
select * from 表名; -- * 代表所有列

功能：查询所有数据
```

```sql
select 列名1,列名2,... from | * 表名 where 条件;

供能:根据指定条件查询
```

### 2、运算符

#### 算术运算符

![image-20230819134710494](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819134710494.png)

#### 比较运算符

![image-20230819134818962](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819134818962.png)

```sql
-- 查询商品名称为“海尔洗衣机”的商品所有信息：
select * from product where pname = '海尔洗衣机';
 
-- 查询价格为800商品
select * from product where price = 800;
 
-- 查询价格不是800的所有商品
select * from product where price != 800;
select * from product where price <> 800;
select * from product where not(price = 800);
 
-- 查询商品价格大于60元的所有商品信息
select * from product where price > 60;
 
 
-- 查询商品价格在200到1000之间所有商品
select * from product where price >= 200 and price <=1000;
select * from product where price between 200 and 1000;

-- 查询商品价格是200或800的所有商品
select * from product where price = 200 or price = 800;
select * from product where price in (200,800);
 
-- 查询含有'裤'字的所有商品
select * from product where pname like '%裤%';
 
-- 查询以'海'开头的所有商品
select * from product where pname like '海%';
 
-- 查询第二个字为'蔻'的所有商品
select * from product where pname like '_蔻%';
 
-- 查询category_id为null的商品
select * from product where category_id is null;
 
-- 查询category_id不为null分类的商品
select * from product where category_id is not null;

```



#### 逻辑运算符

![image-20230819134842199](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819134842199.png)

#### 位运算符

```
位运算符是在二进制数上进行计算的运算符。位运算会先将操作数变成二进制数，进行位运算。然后再将计算结果从二进制数变回十进制数。
```

![image-20230819134933174](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819134933174.png)

### 3、排序查询

```
按照某个或者多个字段对读取的数据进行排序
```

#### order by

```sql
语法：
select 
	字段名1，字段名2，……
from 表名
order by 字段名1 [asc|desc]，字段名2[asc|desc]……

-- asc代表升序，desc代表降序，如果不写默认升序
-- order by用于子句中可以支持单个字段，多个字段，表达式，函数，别名
-- order by子句，放在查询语句的最后面。LIMIT子句除外
```



### 4、聚合查询

#### ![image-20230819135934891](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819135934891.png)

```
1、count函数对null值的处理
如果count函数的参数为星号（*），则统计所有记录的个数。而如果参数为某字段，不统计含null值的记录个数。

2、sum和avg函数对null值的处理
这两个函数忽略null值的存在，就好象该条记录不存在一样。

3、max和min函数对null值的处理
 max和min两个函数同样忽略null值的存在。
```



### 5、分组查询

#### group by

```SQL
select 字段1,字段2… from 表名 group by 分组字段 having 分组条件;

-- 如果要进行分组的话，则SELECT子句之后，只能出现分组的字段和聚合函数，其他的字段不能出现
-- 分组之后对统计结果进行筛选的话必须使用having，不能使用where
-- where子句用来筛选 FROM 子句中指定的操作所产生的行 
-- group  by  子句用来分组 WHERE 子句的输出。 
-- having 子句用来从分组的结果中筛选行
```

### 6、分页查询

```sql
-- 分页查询在项目开发中常见，由于数据量很大，显示屏长度有限，因此对数据需要采取分页显示方式。例如数据共有30条，每页显示5条，第一页显示1-5条，第二页显示6-10条。  
```

#### limit

```sql
-- 方式1-显示前n条
select 字段1，字段2... from 表明 limit n

-- 方式2-分页显示
select 字段1，字段2... from 表明 limit m,n

m: 整数，表示从第几条索引开始，计算方式 （当前页-1）*每页显示条数
n: 整数，表示查询多少条数据
```

```sql
-- 查询product表的前5条记录 
select * from product limit 5 

-- 从第4条开始显示，显示5条 
select * from product limit 3,5
```

### 7、将一张表的数据导入到另一张表中

#### insert into select

```sql
insert into Table2(field1,field2,…) select value1,value2,… from Table1 或者：
insert into Table2 select * from Table1

要求目标表Table2必须存在
```

#### select into

```sql
SELECT vale1, value2 into Table2 from Table1

要求目标表Table2不存在，因为在插入时会自动创建表Table2，并将Table1中指定字段数据复制到Table2中。
```

### 8、模糊匹配

#### like关键字

```sql
在 MySQL 中，LIKE 是用于在查询中模糊匹配字符串的关键字。它通常用于 WHERE 子句中，用于筛选满足特定模式的数据。

LIKE 关键字可以与通配符一起使用，有两种常用的通配符：

%：表示匹配任意数量的字符（包括零个字符）。
_：占位符,表示匹配单个字符
```

```sql
-- 查询含有'裤'字的所有商品
select * from product where pname like '%裤%';
 
-- 查询以'海'开头的所有商品
select * from product where pname like '海%';
 
-- 查询第二个字为'蔻'的所有商品
select * from product where pname like '_蔻%';
```

#### 正则表达式

```
本质上是模糊匹配
使用单个字符串来描述、匹配一系列符合某个语法规则的字符串。
```

##### REGEXP

```sql
MySQL通过 REGEXP 关键字（相当于 like）支持正则表达式进行字符串匹配。
```

#### 1）^a

```sql
功能：匹配所有以 a 开头的字符串

-- 查询以'海'开头的所有商品
select * from product where pname REGEXP '^海';
```

#### 2）a$

```sql
功能：匹配所有以 a 结尾的字符串

-- 查询以'海'结尾的所有商品
select * from product where pname REGEXP '海$';
```

#### 3）.

```sql
功能： . 占位符，代表一个任意字符

-- 查询以'海'结尾且商品名为三个字的所有商品
select * from product where pname REGEXP '..海$';
```

#### 4）*

```shell
功能：不单独使用，他和上一个字符连用，表示匹配上一个字符 0 次或多次

例如，zo* 能匹配 "z" 以及 "zoo"。* 等价于{0,}。
```

#### 5）+

```sql
功能：不单独使用，他和上一个字符连用，表示匹配上一个字符 1 次或多次

例如，'zo+' 能匹配 "zo" 以及 "zoo"，但不能匹配 "z"。+ 等价于 {1,}。
```

#### 6）a? 

```
功能：不单独使用，他和上一个字符连用，表示匹配上一个字符 0 次或 1次
```

#### 7）{n}

```
功能：n 是一个非负整数。匹配确定的 n 次。

例如，'o{2}' 不能匹配 "Bob" 中的 'o'，但是能匹配 "food" 中的两个 o。
```

#### 8）{n,m}

```
功能：m 和 n 均为非负整数，其中n <= m。最少匹配 n 次且最多匹配 m 次。
```

#### 9）[abc]

```
功能：匹配括号内的任意单个字符

例如，[abc] 可以匹配"plain"中的'a'。
```

#### 10）[^abc] 

```
功能：匹配不是括号内的任意单个字符

例如，[^abc] 可以匹配"plain"中的'p'。
```

#### 11）a|b|c|...

```
功能：匹配a或者b或者c

例如，'z|food'能匹配"z"或"food"。'(z|f)ood'则匹配"zood"或"food"。
```

#### 12）(abc) 

```
abc作为一个序列匹配，不用括号括起来都是用单个字符去匹配，如果要把多个字符作为一个整体去匹配就需要用到括号，所以括号适合上面的所有情况。
```

### 9、多表联合查询

#### 交叉连接查询

```sql
交叉连接查询返回被连接的两个表所有数据行的笛卡尔积
笛卡尔积可以理解为一张表的每一行去和另外一张表的任意一行进行匹配
假如A表有m行数据，B表有n行数据，则返回m*n行数据
笛卡尔积会产生很多冗余的数据，后期的其他查询可以在该集合的基础上进行条件筛选

语法：select * from A,B; 
```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819154809563.png" alt="image-20230819154809563" style="zoom: 50%;" />

#### 内连接查询

```sql
内连接查询(使用的关键字 inner join  -- inner可以省略)
    隐式内连接（SQL92标准）：select * from A,B where 条件;
    显示内连接（SQL99标准）：select * from A inner join B on 条件;
```

#### 外连接查询

```sql
外连接查询(使用的关键字 outer join -- outer可以省略)
        左外连接：left outer join
            select * from A left outer join B on 条件;
        右外连接：right outer join
            select * from A right outer join B on 条件;
        满外连接: full outer join
             select * from A full outer join B on 条件
```

#### 子查询

```
子查询就是指的在一个完整的查询语句之中，嵌套若干个不同功能的小查询，从而一起完成复杂查询的一种编写形式，通俗一点就是包含select嵌套的查询。
```

##### 子查询关键字

###### ALL

```sql
功能：
	ALL表示指定列中的值必须要大于子查询集的每一个值，即必须要大于子查询集的最大值；如果是小于号即小于子查询集的最小值。同理可	以推出其它的比较运算符的情况。

语法：
	select …from …where c > all(子查询语句)
```

```sql
-- 查询年龄大于‘1003’部门所有年龄的员工信息
select * from emp3 where age > all(select age from emp3 where dept_id = '1003’);
                                   
-- 查询不属于任何一个部门的员工信息 
select * from emp3 where dept_id != all(select deptno from dept3); 
```

###### ANY、SOME

```sql
供能：
	表示制定列中的值要大于子查询中的任意一个值，即必须要大于子查询集中的最小值。同理可以推出其它的比较运算符的情况。SOME和ANY	的作用一样，SOME可以理解为ANY的别名

语法：
	select …from …where c > any(子查询语句)
```

```sql
-- 查询年龄大于‘1003’部门任意一个员工年龄的员工信息
select * from emp3 where age > all(select age from emp3 where dept_id = '1003’);
```

###### IN

```sql
功能：IN关键字，用于判断某个记录的值，是否在指定的集合中在IN关键字前边加上not可以将条件反过来


语法：
	select …from …where c in(子查询语句)
```

```sql
-- 查询研发部和销售部的员工信息，包含员工号、员工名字
select eid,ename,t.name from emp3 where dept_id in (select deptno from dept3 where name = '研发部' or name = '销售部') ;
```

###### EXISTS

```

```

#### 表自关联

```
MySQL有时在信息查询时需要进行对表自身进行关联查询，即一张表自己和自己关联，一张表当成多张表来用。注意自关联时表必须给表起别名。
```