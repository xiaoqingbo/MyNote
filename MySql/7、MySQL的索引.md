# MySQL的索引

## 一、概念

```
索引是存储引擎用来快速查找数据的一种数据结构
```

## 二、索引的分类

```
按照存储结构分：主要有Hash索引和B+Tree索引

按照功能方式类分:单列索引（又分为：普通索引、唯一索引、主键索引）、组合索引、全文索引、空间索引
```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230823123943982.png" alt="image-20230823123943982" style="zoom:50%;" />

## 三、单列索引

```
一个索引只包含单个列，但一个表中可以有多个单列索引;
```

### 1、普通索引

```
没有什么限制，允许在定义索引的列中插入重复值和空值，纯粹为了查询数据更快一点。
```

#### 创建方式

##### 方式一

```sql
create database mydb5;
use mydb5;

-- 方式1-创建表的时候直接指定
create  table student(
    sid int primary key,
    card_id varchar(20),
    name varchar(20),
    gender varchar(20),
    age int,
    birth date, 
    phone_num varchar(20),
    score double,
    index index_name(name) -- 给name列创建索引
);
```

##### 方式二

```sql
-- 方式2-直接创建
-- create index indexname on tablename(columnname); 
create index index_gender on student(gender); 
```

##### 方式三

```sql
-- 方式3-修改表结构(添加索引)
-- alter table tablename add index indexname(columnname)
alter table student add index index_age(age);
```

#### 查看索引

```sql
-- 1、查看数据库所有索引 
-- select * from mysql.`innodb_index_stats` a where a.`database_name` = '数据库名’; 
select * from mysql.`innodb_index_stats` a where a.`database_name` = 'mydb5';

-- 2、查看表中所有索引 
-- select * from mysql.`innodb_index_stats` a where a.`database_name` = '数据库名' and a.table_name like '%表名%’; 
select * from mysql.`innodb_index_stats` a where a.`database_name` = 'mydb5' and a.table_name like '%student%';

-- 3、查看表中所有索引 
-- show index from table_name; 
show index from student;
```

#### 删除索引

```sql
drop index 索引名 on 表名 
-- 或 
alter table 表名 drop index 索引名 
```

### 2、唯一索引

```
唯一索引与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。
```

#### 创建方式

##### 方式一

```sql
-- 方式1-创建表的时候直接指定
create  table student2(
    sid int primary key,
    card_id varchar(20),
    name varchar(20),
    gender varchar(20),
    age int,
    birth date, 
    phone_num varchar(20),
    score double,
    unique index_card_id(card_id) -- 给card_id列创建索引
);
唯一索引与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。
```

##### 方式二

```sql
-- 方式2-直接创建
-- create unique index 索引名 on 表名(列名) 
create unique index index_card_id on student2(card_id);
```

##### 方式三

```sql
-- 方式3-修改表结构(添加索引)
-- alter table 表名 add unique [索引名] (列名)
alter table student2 add unique index_phone_num(phone_num)
```

#### 删除索引

```sql
drop index 索引名 on 表名 
-- 或 
alter table 表名 drop index 索引名 
```

### 3、主键索引

```
每张表一般都会有自己的主键，当我们在创建表时，MySQL会自动在主键列上建立一个索引，这就是主键索引。主键是具有唯一性并且不允许为NULL，所以他是一种特殊的唯一索引。
```

## 四、组合索引

```
组合索引也叫复合索引，将多个字段建立索引，例如同时使用身份证和手机号建立索引，同样的可以建立为普通索引或者是唯一索引。
```

### 创建方式

```sql
-- 创建索引的基本语法 
create index 索引名 on table_name(字段1,字段2;) 
```

```sql
-- 组合索引
use mydb5;
-- 创建索引的基本语法-- 普通索引
-- create index indexname on table_name(column1(length),column2(length)); 
create index index_phone_name on student(phone_num,name);
-- 操作-删除索引
 drop index index_phone_name on student; 
-- 创建索引的基本语法-- 唯一索引
create  unique index index_phone_name on student(phone_num,name); 

1、select * from student where name = '张三'; 
2、select * from student where phone_num = '15100046637'; 
3、select * from student where phone_num = '15100046637' and name = '张三'; 
4、select * from student where name = '张三' and phone_num = '15100046637'; 
/* 
  三条sql只有 2 、3、4能使用的到索引idx_phone_name,因为条件里面必须包含索引前面的字段  才能够进行匹配。
  而3和4相比where条件的顺序不一样，为什么4可以用到索引呢？
  是因为mysql本身就有一层sql优化，他会根据sql来识别出来该用哪个索引，我们可以理解为3和4在mysql眼中是等价的。
  
*/

```

### 删除索引

```sql
drop index 索引名 on 表名 
-- 或 
alter table 表名 drop index 索引名 
```



## 五、全文索引

```
全文索引主要用来查找文本中的关键字，而不是直接与索引中的值相比较，它更像是一个搜索引擎，基于相似度的查询，而不是简单的where语句的参数匹配。

用 like + % 就可以实现模糊匹配了，为什么还要全文索引？
like + % 在文本比较少时是合适的，但是对于大量的文本数据检索，是不可想象的。全文索引在大量的数据面前，能比 like + % 快 N 倍，速度不是一个数量级，但是全文索引可能存在精度问题。
```

### 注意

```properties
1、MySQL 5.6 以前的版本，只有 MyISAM 存储引擎支持全文索引；
   MySQL 5.6 及以后的版本，MyISAM 和 InnoDB 存储引擎均支持全文索引;

2、只有字段的数据类型为 char、varchar、text 及其系列才可以建全文索引；

3、尽量在对表中插入数据后在对表创建全文索引

4、全文索引对关键字的长度有最长和最短的限制
可以通过 show variables like '%ft%'; 来查看
```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230823134636899.png" alt="image-20230823134636899" style="zoom:50%;" />

### 创建方式

#### 方式一

```sql
-- 创建表的时候添加全文索引（不建议）
create table t_article (
     id int primary key auto_increment ,
     title varchar(255) ,
     content varchar(1000) ,
     writing_date date , 
     fulltext (content) -- 创建全文检索
);

insert into t_article values(null,"Yesterday Once More","When I was young I listen to the radio",'2021-10-01');
insert into t_article values(null,"Right Here Waiting","Oceans apart, day after day,and I slowly go insane",'2021-10-02'); 
insert into t_article values(null,"My Heart Will Go On","every night in my dreams,i see you, i feel you",'2021-10-03');
insert into t_article values(null,"Everything I Do","eLook into my eyes,You will see what you mean to me",'2021-10-04');
insert into t_article values(null,"Called To Say I Love You","say love you no new year's day, to celebrate",'2021-10-05');
insert into t_article values(null,"Nothing's Gonna Change My Love For You","if i had to live my life without you near me",'2021-10-06');
insert into t_article values(null,"Everybody","We're gonna bring the flavor show U how.",'2021-10-07');
```

#### 方式二

```sql
-- 直接添加全文索引
create fulltext index index_content on 表名(字段名);
```

#### 方式三

```sql
-- 修改表结构添加全文索引
alter table 表名 add fulltext index_content(字段名)
```

### 使用全文索引

```SQL
使用 match 和 against 关键字
select * from t_article where match(全文索引的字段名) against('要搜索的关键字’); 
功能同                                                     
select * from t_article where content like '要搜索的关键字'; 
但是当数据量特别大的时候，全文索引能比 like + % 快 N 倍，速度不是一个数量级，但是全文索引可能存在精度问题。
```



## 六、空间索引

```
空间索引是对空间数据类型的字段建立的索引
```

### 空间数据类型

| **类型**   | **含义** | **说明**           |
| ---------- | -------- | ------------------ |
| Geometry   | 空间数据 | 任何一种空间类型   |
| Point      | 点       | 坐标值             |
| LineString | 线       | 有一系列点连接而成 |
| Polygon    | 多边形   | 由多条线组成       |

### 创建方式

```sql
create table shop_info (
  id  int  primary key auto_increment comment 'id',
  shop_name varchar(64) not null comment '门店名称',
  geom_point geometry not null comment '经纬度’,
  spatial key geom_index(geom_point)
);
```

