# 存储引擎

## 一、概念

```
数据库存储引擎是数据库底层软件组织，数据库管理系统（DBMS）使用数据引擎进行创建、查询、更新和删除数据。
不同的存储引擎提供不同的存储机制、索引技巧、锁定水平等功能。现在许多不同的数据库管理系统都支持多种不同的数据引擎。
MySQL的核心就是存储引擎。
用户可以根据不同的需求为数据表选择不同的存储引擎
```

## 二、MySql有哪些存储引擎

```properties
MyISAM：Mysql 5.5之前的默认数据库引擎，最为常用。拥有较高的插入，查询速度，但不支持事务

InnoDB：事务型速记的首选引擎，支持ACID事务，支持行级锁定，MySQL5.5成为默认数据库引擎

Memory： 所有数据置于内存的存储引擎，拥有极高的插入，更新和查询效率。但是会占用和数据量成正比的内存空间。并且其内容会在MYSQL重新启动是会丢失。

Archive ：非常适合存储大量的独立的，作为历史记录的数据。因为它们不经常被读取。Archive 拥有高效的插入速度，但其对查询的支持相对较差

Federated ：将不同的 MySQL 服务器联合起来，逻辑上组成一个完整的数据库。非常适合分布式应用

CSV ：逻辑上由逗号分割数据的存储引擎。它会在数据库子目录里为每个数据表创建一个 .csv 文件。这是一种普通文本文件，每个数据行占用一个文本行。CSV 存储引擎不支持索引。

BlackHole： 黑洞引擎，写入的任何数据都会消失，一般用于记录 binlog 做复制的中继

ERFORMANCE_SCHEMA存储引擎该引擎主要用于收集数据库服务器性能参数。

Mrg_Myisam Merge存储引擎，是一组MyIsam的组合，也就是说，他将MyIsam引擎的多个表聚合起来，但是他的内部没有数据，真正的数据依然是MyIsam引擎的表中，但是可以直接进行查询、删除更新等操作。
```



## 三、相关操作

```sql
-- 查询当前数据库支持的存储引擎：
show engines;
 
-- 查看当前的默认存储引擎：
show variables like ‘%default_storage_engine%’;

-- 查看某个表用了什么引擎(在显示结果里参数engine后面的就表示该表当前用的存储引擎): 
show create table student; 
 
-- 创建新表时指定存储引擎：
create table(...) engine=MyISAM;
 
-- 修改数据库引擎
alter table student engine = INNODB;
alter table student engine = MyISAM;

-- 修改MySQL默认存储引擎方法
1. 关闭mysql服务 
2. 找到mysql安装目录下的my.ini文件： 
3. 找到default-storage-engine=INNODB 改为目标引擎，
   如：default-storage-engine=MYISAM 
4. 启动mysql服务
```

