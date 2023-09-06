![image-20230819114247062](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819114247062.png)

# MySQL约束

```
约束英文：constraint

约束实际上就是表中数据的限制条件
```



## 一、主键约束(primary key) PK

```sql
MySQL主键约束是一个列或者多个列的组合，其值能唯一地标识表中的每一行,方便在RDBMS中尽快的找到某一行。

主键约束相当于 唯一约束 + 非空约束 的组合，主键约束列不允许重复，也不允许出现空值。

每个表最多只允许一个主键

主键约束的关键字是：primary key

当创建主键的约束时，系统默认会在所在的列和列组合上建立对应的唯一索引。
```



### 1、单列主键

```sql
-- 创建单列主键有两种方式，一种是 在定义字段的同时指定主键，一种是 定义完字段之后指定主键
```

#### --  在定义字段的同时指定主键

```sql
语法格式如下：
create table 表名(
   ...
   <字段名> <数据类型> primary key 
   ...
)

create table emp1(
    eid int primay key,
    name VARCHAR(20),
    deptId int,
    salary double
);
```



#### -- 在定义字段之后再指定主键

```sql
语法格式如下：
create table 表名(
   ...
   [constraint <约束名>] primary key [字段名]
);

create table emp2(
    eid INT,
    name VARCHAR(20),
    deptId INT,
    salary double,
    constraint  pk1 primary key(id)
 );
```



### 2、联合主键

```sql
-- 所谓的联合主键，就是这个主键是由一张表中多个字段组成的。

-- 注意：
	1. 当主键是由多个字段组成时，不能直接在字段名后面声明主键约束。
   	2. 一张表只能有一个主键，联合主键也是一个主键
```

```sql
-- 语法：
create table 表名(
   ...
   primary key （字段1，字段2，…,字段n)
);

create table emp3( 
  name varchar(20), 
  deptId int, 
  salary double, 
  primary key(name,deptId) 
);
```



### 3、通过修改表结构添加主键

```sql

   create table 表名(
     ...
   );
   alter table <表名> add primary key（字段列表);

```



#### -- 添加单列主键

```sql
create table emp4(
  eid int, 
  name varchar(20), 
  deptId int, 
  salary double
);

alter table emp4 add primary key(eid);
```

#### -- 添加多列主键

```sql
create table emp5(
  eid int, 
  name varchar(20), 
  deptId int, 
  salary double
);

alter table emp5 add primary key(name, deptId);
```

### 3、删除主键

#### -- 删除单列主键

```sql
alter table 表名 drop primary key;
```

#### -- 删除多列主键

```sql
alter table 表名 drop primary key;
```



## 二、自增长约束(auto_increment)

### 1、创建方式

```
在 MySQL 中，当主键定义为自增长后，这个主键的值就不再需要用户输入数据了，而由数据库系统根据定义自动赋值。每增加一条记录，主键会自动以相同的步长进行增长。
```

```sql
create table t_user1 ( 
  id int primary key auto_increment, 
  name varchar(20)
);

insert into t_user1 values(NULL,'张三');
insert into t_user1(name) values('李四');

-- 注意：默认情况下，auto_increment 的初始值是 1，每新增一条记录，字段值自动加 1。
-- 一个表中只能有一个字段使用 auto_increment约束，且该字段必须有唯一索引，以避免序号重复（即为主键或主键的一部分）。
-- auto_increment约束的字段必须具备 NOT NULL 属性。
-- auto_increment约束的字段只能是整数类型（TINYINT、SMALLINT、INT、BIGINT 等。
-- auto_increment约束字段的最大值受该字段的数据类型约束，如果达到上限，auto_increment就会失效。
```



### 2、指定自增长的初始值

#### -- 方式一：创建表时指定

```sql
create table t_user2 ( 
  id int primary key auto_increment, 
  name varchar(20)
)auto_increment = 100;

insert into t_user2 values(NULL,'张三');
insert into t_user2 values(NULL,'张三');

```



#### -- 方式二：创建表之后指定

```sql
create table t_user3 ( 
  id int primary key auto_increment, 
  name varchar(20)
);

alter table t_user3 auto_increment = 200;

insert into t_user3 values(NULL,'张三');
insert into t_user3 values(NULL,'张三');
```



### 3、注意点

```sql
delete from t_user1;  -- delete删除数据之后，自增长还是在最后一个值基础上加1,也就是说delete不会删除自增长的数据

truncate t_user1; -- truncate删除之后，自增长从1开始,也就是说delete会删除自增长的数据
```



## 三、非空约束(not null)

```
MySQL 非空约束（NOT NULL）指字段的值不能为空。对于使用了非空约束的字段，如果用户在添加数据时没有指定值，数据库系统就会报错。
```

### 1、创建方式

#### --方式1，创建表时指定

```sql
create table mydb1.t_user6 ( 
  id int , 
  name varchar(20)  not null,   -- 指定非空约束
  address varchar(20) not null  -- 指定非空约束
);

insert into t_user6(id) values(1001); -- 不可以
insert into t_user6(id,name,address) values(1001,NULL,NULL); -- 不可以
insert into t_user6(id,name,address) values(1001,'NULL','NULL'); -- 可以（字符串：NULL）
insert into t_user6(id,name,address) values(1001,'',''); -- 可以（空串） 
```



#### --方式2，创建表之后指定

```sql
create table t_user7 ( 
  id int , 
  name varchar(20) ,   -- 指定非空约束
  address varchar(20)  -- 指定非空约束
);

alter table t_user7 modify name varchar(20) not null;
alter table t_user7 modify address varchar(20) not null;

```



### 2、删除非空约束

```sql
-- alter table 表名 modify 字段 类型 

alter table t_user7 modify name varchar(20) ;
alter table t_user7 modify address varchar(20) ;

```



## 四、唯一约束(unique)

```
唯一约束（Unique Key）是指所有记录中字段的值不能重复出现。例如，为 id 字段加上唯一性约束后，每条记录的 id 值都是唯一的，不能出现重复的情况。
```

### 1、创建方式

#### -- 方式1：创建表时指定

```sql
create table t_user8 (
 id int , 
 name varchar(20) , 
 phone_number varchar(20) unique  -- 指定唯一约束 
);


insert into t_user8 values(1001,'张三',138);
insert into t_user8 values(1002,'张三2',139);

insert into t_user8 values(1003,'张三3',NULL);
insert into t_user8 values(1004,'张三4',NULL);  -- 在MySQL中NULL和任何值都不相同 甚至和自己都不相同
```



#### -- 方式2：创建表之后指定

```sql
-- 格式：alter table 表名 add constraint 约束名 unique(列);

create table t_user9 ( 
  id int , 
  name varchar(20) , 
  phone_number varchar(20) -- 指定唯一约束 
); 

alter table t_user9 add constraint unique_pn unique(phone_number);


insert into t_user9 values(1001,'张三',138);
insert into t_user9 values(1002,'张三2',138);
```




### 3. 删除唯一约束

```sql
-- 格式：alter table <表名> drop index <唯一约束名>;

alter table t_user9 drop index unique_pn;
```



## 五、默认约束(default)

```
MySQL 默认值约束用来指定某列的默认值。不插入数据该列就由默认值替代
```

### 1、创建方式

#### -- 方式1：创建表时指定

```sql
create table t_user10 ( 
  id int , 
  name varchar(20) ,
  address varchar(20) default '北京' -- 指定默认约束 
);

insert into t_user10(id,name,address) values(1001,'张三','上海');
insert into t_user10 values(1002,'李四',NULL);
```




#### -- 方式2：创建表之后指定

```sql
-- alter table 表名 modify 列名 类型 default 默认值; 
create table t_user11 ( 
  id int , 
  name varchar(20) , 
  address varchar(20)  
);

alter table t_user11 modify address varchar(20) default '深圳';

insert into t_user11(id,name) values(1001,'张三');
```



### 2.删除默认约束

```sql
-- alter table <表名> modify <字段名> <类型> default null; 

alter table t_user11 modify address varchar(20) default null;

insert into t_user11(id,name) values(1002,'李四');
```



## 六、零填充约束(zerofill)

```
1、插入数据时，当该字段的值的长度小于定义的长度时，会在该值的前面补上相应的0
2、zerofill默认为int(10)
3、当使用zerofill 时，默认会自动加unsigned（无符号）属性，使用unsigned属性后，数值范围是原值的2倍，例如，有符号为-128~+127，无符号为0~256。
```

### 1、 添加约束

```sql
create table t_user12 ( 
  id int zerofill  , -- 零填充约束
  name varchar(20)   
);

insert into t_user12 values(123, '张三');

insert into t_user12 values(1, '李四');

insert into t_user12 values(2, '王五');
```



### 2、删除约束

```sql
alter table t_user12 modify id int;
```



## 七、外键约束(foreign key) FK

```
MySQL 外键约束（FOREIGN KEY）是表的一个特殊字段，经常与主键约束一起使用。对于两个具有关联关系的表而言，相关联字段中主键所在的表就是主表（父表），外键所在的表就是从表（子表）。

外键用来建立主表与从表的关联关系，为两个表的数据建立连接，约束两个表中数据的一致性和完整性。
```

![image-20230819152621061](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819152621061.png)

```
定义一个外键时，需要遵守下列规则：

1、主表必须已经存在于数据库中，或者是当前正在创建的表。

2、必须为主表定义主键。

3、主键不能包含空值，但允许在外键中出现空值。也就是说，只要外键的每个非空值出现在指定的主键中，这 个外键的内容就是正确的。

4、在主表的表名后面指定列名或列名的组合。这个列或列的组合必须是主表的主键或候选键。

5、外键中列的数目必须和主表的主键中列的数目相同。

 6、外键中列的数据类型必须和主表主键中对应列的数据类型相同。
```

### 创建方式

#### 在创建表时设置外键约束

```sql
create database mydb3; 
use mydb3;
-- 创建部门表
create table if not exists dept(
  deptno varchar(20) primary key ,  -- 部门号
  name varchar(20) -- 部门名字
);


create table if not exists emp(
  eid varchar(20) primary key , -- 员工编号
  ename varchar(20), -- 员工名字
  age int,  -- 员工年龄
  dept_id varchar(20),  -- 员工所属部门
  constraint emp_fk foreign key (dept_id) references dept (deptno) –- 外键约束
);
```

#### 在修改表时添加外键约束

```sql
-- 创建部门表
create table if not exists dept2(
  deptno varchar(20) primary key ,  -- 部门号
  name varchar(20) -- 部门名字
);
-- 创建员工表
create table if not exists emp2(
  eid varchar(20) primary key , -- 员工编号
  ename varchar(20), -- 员工名字
  age int,  -- 员工年龄
  dept_id varchar(20)  -- 员工所属部门
 
);
-- 创建外键约束
alter table emp2 add constraint dept_id_fk foreign key(dept_id) references dept2 (deptno);

```

### 在外键约束下的数据操作

```sql
-- 3、删除数据
 /*
   注意：
       1：主表的数据被从表依赖时，不能删除，否则可以删除
       2: 从表的数据可以随便删除
 */
delete from dept where deptno = '1001'; -- 不可以删除
delete from dept where deptno = '1004'; -- 可以删除
delete from emp where eid = '7'; -- 可以删除
```

### 删除外键约束

```sql
alter table <表名> drop foreign key <外键约束名>;
```

