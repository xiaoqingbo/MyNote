# 尚硅谷HiveSQL练习题笔记

## 常用函数

### （1）year

```sql
year(string datestr)函数：

功能：返回日期所属年份，int类型
参数：datestr必须是标准的日期时间格式 "YYYY-MM-DD HH:MM:SS" 的字符串

如：
select year('2020-03-17')	-- 2020
select year('2020-03-17 07:50:00') -- 2020
```



### （2）datediff

```sql
datediff(string enddate, string startdate)函数：

功能：返回值为二者的天数差，int类型。如datediff('2022-03-01', '2022-02-21')返回值为8
参数：startdate和enddate均为yyyy-MM-dd格式的日期字符串
```



### （3）date_format

```sql
date_format(date/timestamp/string dt, string formatstr)：

功能：将date/timestamp/string类型的日期字段dt转换为formatstr格式的日期字符串。

如：
	select date_format('2022-03-01 07:50:00', 'yyyy-MM-dd')	-- 2022-03-01
```



### （4）cast

```sql
cast(expr as <type>)：

功能：将expr的执行结果转换为<type>类型的数据并返回，expr可以是函数（可以嵌套）、字段或字面值。转换失败返回null，对于cast(expr as boolean)，对任意的非空字符串expr返回true。

如：
	cast(user1_id as int)
```



### （5）collect_set

```
collect_set(col)：

功能：将col字段的所有值去重后置于一个array类型的对象中。
```



### （6）collect_list

```
collect_list(col)：

功能：将col字段的所有值置于一个array类型的对象中，不去重。
```



### （7）array_contains：

```
array_contains(数组, 元素)：

功能：用于检查一个数组中是否包含指定的元素。它返回一个布尔值，如果数组包含指定的元素，则返回 true，否则返回 false。
```



### （8）LAG

```sql
LAG(column, offset, default) OVER (PARTITION BY partition_col1, ... ORDER BY order_col1, ...)

column：要获取前一行值的列名或表达式。

offset：指定要访问的前一行的偏移量（整数值）。0表示当前行，1表示前一行，以此类推。

default：可选参数，如果没有前一行可供访问（例如，对于第一行），则返回的默认
```

