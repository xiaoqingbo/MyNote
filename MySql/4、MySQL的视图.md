# MySQL的视图

```sql
-- 就是将使用查询语句查询到的数据封装为一张表来使用并，为其命名，用户使用时只需使用视图名称即可获取结果集。

-- 视图中的数据是依赖于原来的表中的数据的。一旦表中的数据发生改变，显示在视图中的数据也会发生改变。
```

## 一、创建语法

```sql
create [or replace] view 视图名 as (select语句)
```

```sql
create or replace view view1_emp
as 
select ename,job from emp; 

-- 查看表和视图 
show full tables;
```



## 二、修改视图

```
修改视图是指修改数据库中已存在的表的定义。当基本表的某些字段发生改变时，可以通过修改视图来保持视图和基本表之间一致。
```

```sql
alter view 视图名 as select语句
```

```sql
alter view view1_emp
as 
select a.deptno,a.dname,a.loc,b.ename,b.sal from dept a, emp b where a.deptno = b.deptno;

```



## 三、更新视图

```
不推荐做
```

## 四、重命名视图

```sql
-- rename table 视图名 to 新视图名; 
rename table view1_emp to my_view1
```

## 五、删除视图

```sql
-- drop view 视图名[,视图名…];
drop view if exists view_student;
```

