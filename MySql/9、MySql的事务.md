# MySQL的事务

## 一、概念

```
MySQL的事务是一组关联操作，它们被视为一个单独的工作单元，要么全部成功执行，要么全部回滚（撤销），维护了数据库的完整性。

说白了事务就是把几条SQL语句绑在一起看做一个整体，这个整体要么成功要么失败
```

## 二、事务操作

```sql
1、开启事务：Start Transaction

任何一条DML语句(insert、update、delete)执行，标志事务的开启
命令：BEGIN 或 START TRANSACTION

2、提交事务：Commit Transaction
成功的结束，将所有的DML语句操作历史记录和底层硬盘数据来一次同步
命令：COMMIT

3、回滚事务：Rollback Transaction
失败的结束，将所有的DML语句操作历史记录全部清空
命令：ROLLBACK 

```

## 三、事物的特性

```
1、原子性（Atomicity）：意思是事务被视为一个原子操作，要么全部执行成功，要么全部回滚。

2、一致性（Consistency）：意思是事务在执行前和执行后，数据库都必须保持一致状态。

3、隔离性（Isolation）：意思是并发执行的事务相互隔离，一个事务的操作在未提交前对其他事务是不可见的。这确保了在多个事务同时执行时，它们之间不会相互干扰。

4、持久性（Durability）：意思是一旦事务提交，其对数据库的改变将持久保存，即使系统崩溃或发生故障，数据也不会丢失。
```

```sql
create database if not exists mydb12_transcation;
use mydb12_transcation;
-- 创建账户表
create table account(
    id int primary key, -- 账户id
    name varchar(20), -- 账户名
    money double -- 金额
);
 
 
--  插入数据
insert into account values(1,'zhangsan',1000);
insert into account values(2,'lisi',1000);
 


-- 设置MySQL的事务为手动提交(关闭自动提交事务)
select @@autocommit;
set autocommit = 0;
 
-- 模拟账户转账
-- 开启事务 
begin;
update account set money = money - 200 where name = 'zhangsan';
update account set money = money + 200 where name = 'lisi';
-- 提交事务
commit;
 
 
-- 如果转账中的任何一条出现问题，则回滚事务
rollback;

```



## 四、事务的隔离级别

```
事务的隔离顾名思义就是将事务与另一个事务隔离开，为什么要隔离呢？如果一个事务正在操作的数据被另一个事务修改或删除了，最后的执行结果可能无法达到预期。如果没有隔离性还会导致其他问题。
```

```
1、读未提交(Read uncommitted)
  一个事务可以读取另一个未提交事务的数据，最低级别，任何情况都无法保证。
　　　　
2、读已提交(Read committed)
   一个事务要等另一个事务提交后才能读取数据，可避免脏读的发生，会造成不可重复读。

3、可重复读(Repeatable read)
    就是在开始读取数据（事务开启）时，不再允许修改操作，可避免脏读、不可重复读的发生，但是会造成幻读。
	Mysql的默认隔离级别

4、串行(Serializable)
   是最高的事务隔离级别，在该级别下，事务串行化顺序执行，可以避免脏读、不可重复读与幻读。但是这种事务隔离级别效率低下，比较耗数据库性能，一般不使用。
```

## 五、事务的隔离级别操作

```sql
-- 查看隔离级别 
show variables like '%isolation%’; 

-- 设置隔离级别
/*
set session transaction isolation level 级别字符串
级别字符串：read uncommitted、read committed、repeatable read、serializable
*/
-- 设置read uncommitted
set session transaction isolation level read uncommitted;
 
-- 设置read committed
set session transaction isolation level read committed;
 
-- 设置repeatable read
set session transaction isolation level repeatable read;
 
-- 设置serializable
set session transaction isolation level serializable;
```

