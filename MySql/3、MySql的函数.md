![image-20230819084528093](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819084528093.png)

# MySQL函数

## 一、聚合函数

### count、sum、min、max、avg

### group_concat()

```sql
功能：
	首先根据group by指定的列进行分组，并且用分隔符分隔，将同一个分组中的值连接起来，返回一个字符串结果。
	
语法：
	group_concat([distinct] 字段名 [order by 排序字段 asc/desc] [separator '分隔符'])

说明：
　　（1）使用distinct可以排除重复值；
　　（2）如果需要对结果中的值进行排序，可以使用order by子句；
　　（3）separator是一个字符串值，默认为逗号。
```

```sql
-- 将所有员工的名字合并成一行 
select group_concat(emp_name) from emp;
```

![image-20230819161836007](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819161836007.png)

```sql
-- 指定分隔符合并 
select department,group_concat(emp_name separator ';' ) from emp group by department; 
```

![image-20230819161900715](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819161900715.png)

```sql
-- 指定排序方式和分隔符 

select department,group_concat(emp_name order by salary desc separator ';' ) from emp group by department;
```

![image-20230819161958763](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819161958763.png)

## 二、数学函数

| **函数名**                              | **描述**                    | **实例**                                                     |
| --------------------------------------- | --------------------------- | ------------------------------------------------------------ |
| **ABS(x)**                              | 返回 x 的绝对值             | 返回 -1 的绝对值：  SELECT  ABS(-1) -- 返回1                 |
| **CEIL(x)**                             | 返回大于或等于 x 的最小整数 | SELECT  CEIL(1.5) -- 返回2                                   |
| **FLOOR(x)**                            | 返回小于或等于 x 的最大整数 | 小于或等于  1.5 的整数：  SELECT  FLOOR(1.5) -- 返回1        |
| **GREATEST(expr1, expr2, expr3,  ...)** | 返回列表中的最大值          | 返回以下数字列表中的最大值：  SELECT  GREATEST(3, 12, 34, 8, 25); -- 34  返回以下字符串列表中的最大值：  SELECT  GREATEST("Google", "Runoob", "Apple");  -- Runoob |
| **LEAST(expr1, expr2, expr3, ...)**     | 返回列表中的最小值          | 返回以下数字列表中的最小值：  SELECT  LEAST(3, 12, 34, 8, 25); -- 3  返回以下字符串列表中的最小值：  SELECT  LEAST("Google", "Runoob",  "Apple");  -- Apple |

| **函数名**          | **描述**                       | **实例**                                                     |
| ------------------- | ------------------------------ | ------------------------------------------------------------ |
| **MAX(expression)** | 返回字段 expression 中的最大值 | 返回数据表  Products 中字段  Price 的最大值：  SELECT  MAX(Price) AS LargestPrice FROM Products; |
| **MIN(expression)** | 返回字段 expression 中的最小值 | 返回数据表  Products 中字段  Price 的最小值：  SELECT  MIN(Price) AS MinPrice FROM Products; |
| **MOD(x,y)**        | 返回 x 除以 y 以后的余数       | 5 除于 2 的余数：  SELECT  MOD(5,2) -- 1                     |
| **PI()**            | 返回圆周率(3.141593）          | SELECT  PI() --3.141593                                      |
| **POW(x,y)**        | 返回 x 的 y 次方               | 2 的 3 次方：  SELECT  POW(2,3) -- 8                         |

| **函数名**                | **描述**                                                     | **实例**                             |
| ------------------------- | ------------------------------------------------------------ | ------------------------------------ |
| **RAND()**                | 返回 0 到 1 的随机数                                         | SELECT  RAND() --0.93099315644334    |
| **ROUND(x)**              | 返回离 x 最近的整数（遵循四舍五入）                          | SELECT  ROUND(1.23456) --1           |
| **ROUND(****x,y****)**    | 返回指定位数的小数（遵循四舍五入）                           | SELECT  ROUND(1.23456,3) –1.235      |
| **TRUNCATE(****x,y****)** | 返回数值 x 保留到小数点后 y 位的值（与  ROUND 最大的区别是不会进行四舍五入） | SELECT  TRUNCATE(1.23456,3) -- 1.234 |

## 三、字符串函数

| **函数**                     | **描述**                                                     | **实例**                                                     |
| ---------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **CHAR_LENGTH(s)**           | 返回字符串 s 的字符数                                        | 返回字符串  RUNOOB 的字符数  SELECT  CHAR_LENGTH("RUNOOB") AS LengthOfString; |
| **CHARACTER_LENGTH(s)**      | 返回字符串 s 的字符数                                        | 返回字符串  RUNOOB 的字符数  SELECT  CHARACTER_LENGTH("RUNOOB") AS LengthOfString; |
| **CONCAT(s1,s2...sn)**       | 字符串 s1,s2 等多个字符串合并为一个字符串                    | 合并多个字符串  SELECT  CONCAT("SQL ", "Runoob ", "Gooogle ",  "Facebook") AS ConcatenatedString; |
| **CONCAT_WS(x, s1,s2...sn)** | 同 CONCAT(s1,s2,...) 函数，但是每个字符串之间要加上 x，x 可以是分隔符 | 合并多个字符串，并添加分隔符：  SELECT  CONCAT_WS("-", "SQL", "Tutorial",  "is", "fun!")AS ConcatenatedString; |
| **FIELD(s,s1,s2...)**        | 返回第一个字符串 s 在字符串列表(s1,s2...)中的位置            | 返回字符串 c 在列表值中的位置：  SELECT  FIELD("c", "a", "b", "c",  "d", "e"); |

| **函数**              | **描述**                                                     | **实例**                                                     |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **LTRIM(s)**          | 去掉字符串 s 开始处的空格                                    | 去掉字符串  RUNOOB开始处的空格：  SELECT  LTRIM("  RUNOOB") AS  LeftTrimmedString;-- RUNOOB |
| **MID(s,n,len)**      | 从字符串 s 的 n 位置截取长度为 len 的子字符串，同  SUBSTRING(s,n,len) | 从字符串  RUNOOB 中的第 2 个位置截取 3个  字符：  SELECT  MID("RUNOOB", 2, 3) AS ExtractString; -- UNO |
| **POSITION(s1 IN s)** | 从字符串 s 中获取 s1 的开始位置                              | 返回字符串  abc 中 b 的位置：  SELECT  POSITION('b' in 'abc') -- 2 |
| **REPLACE(s,s1,s2)**  | 将字符串 s2 替代字符串 s 中的字符串 s1                       | 将字符串  abc 中的字符 a 替换为字符 x：  SELECT  REPLACE('abc','a','x') --xbc |
| **REVERSE(s)**        | 将字符串s的顺序反过来                                        | 将字符串 abc 的顺序反过来：  SELECT  REVERSE('abc')  -- cba  |

| **函数**                        | **描述**                                                     | **实例**                                                     |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **RIGHT(s,n)**                  | 返回字符串 s 的后 n 个字符                                   | 返回字符串  runoob 的后两个字符：  SELECT  RIGHT('runoob',2) -- ob |
| **RTRIM(s)**                    | 去掉字符串 s 结尾处的空格                                    | 去掉字符串  RUNOOB 的末尾空格：  SELECT  RTRIM("RUNOOB   ") AS  RightTrimmedString;  -- RUNOOB |
| **STRCMP(s1,s2)**               | 比较字符串 s1 和 s2，如果 s1  与 s2  相等返回 0 ，如果  s1>s2 返回 1，如果  s1<s2 返回 -1 | 比较字符串：  SELECT  STRCMP("runoob", "runoob"); -- 0       |
| **SUBSTR(s, start, length)**    | 从字符串 s 的 start 位置截取长度为  length 的子字符串        | 从字符串  RUNOOB 中的第 2 个位置截取 3个  字符：  SELECT  SUBSTR("RUNOOB", 2, 3) AS ExtractString; -- UNO |
| **SUBSTRING(s, start, length)** | 从字符串 s 的 start 位置截取长度为  length 的子字符串        | 从字符串  RUNOOB 中的第 2 个位置截取 3个  字符：  SELECT  SUBSTRING("RUNOOB", 2, 3) AS ExtractString;  -- UNO |

| **函数**     | **描述**                            | **实例**                                                     |
| ------------ | ----------------------------------- | ------------------------------------------------------------ |
| **TRIM(s)**  | 去掉字符串 s 开始和结尾处的空格     | 去掉字符串  RUNOOB 的首尾空格：  SELECT  TRIM('  RUNOOB  ') AS TrimmedString; |
| **UCASE(s)** | 将字符串转换为大写                  | 将字符串  runoob 转换为大写：  SELECT  UCASE("runoob"); -- RUNOOB |
| **UPPER(s)** | 将字符串转换为大写                  | 将字符串  runoob 转换为大写：  SELECT  UPPER("runoob"); -- RUNOOB |
| **LCASE(s)** | 将字符串  s  的所有字母变成小写字母 | 字符串  RUNOOB 转换为小写：  SELECT LCASE('RUNOOB') --  runoob |
| **LOWER(s)** | 将字符串  s  的所有字母变成小写字母 | 字符串  RUNOOB 转换为小写：  SELECT LOWER('RUNOOB') -- runoob |

## 四、日期函数

| **函数名**                                           | **描述**                               | **实例**                                                     |
| ---------------------------------------------------- | -------------------------------------- | ------------------------------------------------------------ |
| **UNIX_TIMESTAMP()**                                 | 返回从1970-01-01  00:00:00到当前毫秒值 | select  UNIX_TIMESTAMP() -> 1632729059                       |
| **UNIX_TIMESTAMP(DATE_STRING)**                      | 将制定日期转为毫秒值时间戳             | SELECT  UNIX_TIMESTAMP('2011-12-07 13:01:03');               |
| **FROM_UNIXTIME(BIGINT UNIXTIME[,  STRING FORMAT])** | 将毫秒值时间戳转为指定格式日期         | SELECT  FROM_UNIXTIME(1598079966,'%Y-%m-%d %H:%i:%s'); ->  2020-08-22  15-06-06 |
| **CURDATE()**                                        | 返回当前日期                           | SELECT  CURDATE();  ->  2018-09-19                           |
| **CURRENT_DATE()**                                   | 返回当前日期                           | SELECT  CURRENT_DATE();  ->  2018-09-19                      |

| **函数名**                                           | **描述**                               | **实例**                                                     |
| ---------------------------------------------------- | -------------------------------------- | ------------------------------------------------------------ |
| **UNIX_TIMESTAMP()**                                 | 返回从1970-01-01  00:00:00到当前毫秒值 | select  UNIX_TIMESTAMP() -> 1632729059                       |
| **UNIX_TIMESTAMP(****DATE_STRING****)**              | 将制定日期转为毫秒值时间戳             | SELECT  UNIX_TIMESTAMP('2011-12-07 13:01:03');               |
| **FROM_UNIXTIME(BIGINT UNIXTIME[,  STRING FORMAT])** | 将毫秒值时间戳转为指定格式日期         | SELECT  FROM_UNIXTIME(1598079966,'%Y-%m-%d %H:%i:%s'); ->  2020-08-22  15-06-06 |
| **CURDATE()**                                        | 返回当前日期                           | SELECT  CURDATE();  ->  2018-09-19                           |
| **CURRENT_DATE()**                                   | 返回当前日期                           | SELECT  CURRENT_DATE();  ->  2018-09-19                      |

| **函数名**              | **描述**                           | **实例**                                             |
| ----------------------- | ---------------------------------- | ---------------------------------------------------- |
| **CURRENT_TIME**        | 返回当前时间                       | SELECT  CURRENT_TIME();  ->  19:59:02                |
| **CURTIME()**           | 返回当前时间                       | SELECT  CURTIME();  ->  19:59:02                     |
| **CURRENT_TIMESTAMP()** | 返回当前日期和时间                 | SELECT  CURRENT_TIMESTAMP()  ->  2018-09-19 20:57:43 |
| **DATE()**              | 从日期或日期时间表达式中提取日期值 | SELECT  DATE("2017-06-15");    ->  2017-06-15        |
| **DATEDIFF(d1,d2)**     | 计算日期 d1->d2 之间相隔的天数     | SELECT  DATEDIFF('2001-01-01','2001-02-02')  ->  -32 |

| **函数名**                            | **描述**                       | **实例**                                                     |
| ------------------------------------- | ------------------------------ | ------------------------------------------------------------ |
| **TIMEDIFF(time1, time2)**            | 计算时间差值                   | SELECT  TIMEDIFF("13:10:11", "13:10:10");  ->  00:00:01      |
| **DATE_FORMAT(d,f)**                  | 按表达式 f的要求显示日期 d     | SELECT  DATE_FORMAT('2011-11-11 11:11:11','%Y-%m-%d %r')  ->  2011-11-11 11:11:11 AM |
| **STR_TO_DATE(string, format_mask)**  | 将字符串转变为日期             | SELECT  STR_TO_DATE("August 10 2017", "%M %d %Y");  ->  2017-08-10 |
| **DATE_SUB(date,INTERVAL expr type)** | 函数从日期减去指定的时间间隔。 | Orders 表中 OrderDate 字段减去 2 天：  SELECT  OrderId,DATE_SUB(OrderDate,INTERVAL 2  DAY) AS OrderPayDate  FROM  Orders |

| **函数名**                                          | **描述**                                                     | **实例**                                                     |
| --------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **ADDDATE/DATE_ADD(d****，****INTERVAL expr type)** | 计算起始日期 d 加上一个时间段后的日期，type  值可以是：  ·MICROSECOND  ·SECOND  ·MINUTE  ·HOUR  ·DAY  ·WEEK  ·MONTH  ·QUARTER  ·YEAR  ·DAY_MINUTE  ·DAY_HOUR  ·YEAR_MONTH | SELECT  DATE_ADD("2017-06-15", INTERVAL 10 DAY);    ->  2017-06-25     SELECT  DATE_ADD("2017-06-15 09:34:21", INTERVAL 15 MINUTE);  ->  2017-06-15 09:49:21     SELECT  DATE_ADD("2017-06-15 09:34:21", INTERVAL -3 HOUR);  ->2017-06-15  06:34:21     SELECT  DATE_ADD("2017-06-15 09:34:21", INTERVAL -3 HOUR);  ->2017-04-15 |

| **函数名**                                  | **描述**                                                     | **实例**                                                     |
| ------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **DATE_ADD(d****，****INTERVAL expr type)** | 计算起始日期 d 加上一个时间段后的日期，type  值可以是：  ·SECOND_MICROSECOND  ·MINUTE_MICROSECOND  ·MINUTE_SECOND  ·HOUR_MICROSECOND  ·HOUR_SECOND  ·HOUR_MINUTE  ·DAY_MICROSECOND  ·DAY_SECOND  ·DAY_MINUTE  ·DAY_HOUR  ·YEAR_MONTH | SELECT  DATE_ADD("2017-06-15", INTERVAL 10 DAY);    ->  2017-06-25     SELECT  DATE_ADD("2017-06-15 09:34:21", INTERVAL 15 MINUTE);  ->  2017-06-15 09:49:21     SELECT  DATE_ADD("2017-06-15 09:34:21", INTERVAL -3 HOUR);  ->2017-06-15  06:34:21     SELECT  DATE_ADD("2017-06-15 09:34:21", INTERVAL -3 HOUR);  ->2017-04-15 |

| **EXTRACT(type FROM d)**        | **从日期** **d** **中获取指定的值，****type** **指定返回的值。****     type****可取值为：**  ·**MICROSECOND**  ·**SECOND**  ·**MINUTE**  ·**HOUR**  **…..** | **SELECT EXTRACT(MINUTE FROM '2011-11-11 11:11:11')**   **-> 11** |
| ------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **LAST_DAY(d)**                 | 返回给给定日期的那一月份的最后一天                           | SELECT  LAST_DAY("2017-06-20");  ->  2017-06-30              |
| **MAKEDATE(year, day-of-year)** | 基于给定参数年份 year 和所在年中的天数序号  day-of-year 返回一个日期 | SELECT  MAKEDATE(2017, 3);  ->  2017-01-03                   |

| **函数名**     | **描述**                         | **实例**                                      |
| -------------- | -------------------------------- | --------------------------------------------- |
| **YEAR(d)**    | 返回年份                         | SELECT  YEAR("2017-06-15");  ->  2017         |
| **MONTH(d)**   | 返回日期d中的月份值，1 到 12     | SELECT  MONTH('2011-11-11 11:11:11')  ->11    |
| **DAY(d)**     | 返回日期值 d 的日期部分          | SELECT  DAY("2017-06-15");   ->  15           |
| **HOUR(t)**    | 返回 t 中的小时值                | SELECT  HOUR('1:2:3')  ->  1                  |
| **MINUTE(t)**  | 返回 t 中的分钟值                | SELECT  MINUTE('1:2:3')  ->  2                |
| **SECOND(t)**  | 返回 t 中的秒钟值                | SELECT  SECOND('1:2:3')  ->  3                |
| **QUARTER(d)** | 返回日期d是第几季节，返回 1 到 4 | SELECT  QUARTER('2011-11-11 11:11:11')  ->  4 |

| **函数名**        | **描述**                                          | **实例**                                               |
| ----------------- | ------------------------------------------------- | ------------------------------------------------------ |
| **MONTHNAME(d)**  | 返回日期当中的月份名称，如  November              | SELECT  MONTHNAME('2011-11-11 11:11:11')  ->  November |
| **MONTH(d)**      | 返回日期d中的月份值，1 到 12                      | SELECT  MONTH('2011-11-11 11:11:11')  ->11             |
| **DAYNAME(d)**    | 返回日期 d 是星期几，如  Monday,Tuesday           | SELECT  DAYNAME('2011-11-11 11:11:11')  ->Friday       |
| **DAYOFMONTH(d)** | 计算日期 d 是本月的第几天                         | SELECT  DAYOFMONTH('2011-11-11 11:11:11')  ->11        |
| **DAYOFWEEK(d)**  | 日期 d 今天是星期几，1 星期日，2 星期一，以此类推 | SELECT  DAYOFWEEK('2011-11-11 11:11:11')  ->6          |
| **DAYOFYEAR(d)**  | 计算日期 d 是本年的第几天                         | SELECT  DAYOFYEAR('2011-11-11 11:11:11')  ->315        |

| **函数名**               | **描述**                                                     | **实例**                                          |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------- |
| **WEEK(d)**              | 计算日期 d 是本年的第几个星期，范围是 0 到 53                | SELECT  WEEK('2011-11-11 11:11:11')  ->  45       |
| **WEEKDAY(d)**           | 日期 d 是星期几，0 表示星期一，1 表示星期二                  | SELECT  WEEKDAY("2017-06-15");  ->  3             |
| **WEEKOFYEAR(d)**        | 计算日期 d 是本年的第几个星期，范围是 0 到 53                | SELECT  WEEKOFYEAR('2011-11-11 11:11:11')  ->  45 |
| **YEARWEEK(date, mode)** | 返回年份及第几周（0到53），mode 中 0 表示周天，1表示周一，以此类推 | SELECT  YEARWEEK("2017-06-15");  ->  201724       |
| **NOW()**                | 返回当前日期和时间                                           | SELECT  NOW()  ->  2018-09-19 20:57:43            |

## 五、控制流函数

### if逻辑判断语句

| **格式**                                                     | **解释**                                                     | **案例**                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------ |
| **IF(expr,v1,v2)**                                           | 如果表达式 expr 成立，返回结果 v1；否则，返回结果 v2。       | SELECT  IF(1 > 0,'正确','错误')    ->正确        |
| **[IFNULL(v1,v2)](https://www.runoob.com/mysql/mysql-func-ifnull.html)** | 如果 v1 的值不为  NULL，则返回 v1，否则返回 v2。             | SELECT  IFNULL(null,'Hello Word')  ->Hello  Word |
| **ISNULL(expression)**                                       | 判断表达式是否为 NULL                                        | SELECT  ISNULL(NULL);  ->1                       |
| **NULLIF(expr1, expr2)**                                     | 比较两个字符串，如果字符串  expr1 与  expr2 相等  返回  NULL，否则返回  expr1 | SELECT  NULLIF(25, 25);  ->                      |

### case when语句

![image-20230819220949737](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819220949737.png)

## 六、窗口函数

```
窗口函数又被称为开窗函数
```

![image-20230819221348219](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819221348219.png)

### 序号函数

```sql

ROW_NUMBER()、RANK() 和 DENSE_RANK() 是 MySQL（以及其他关系型数据库）中用于对结果集中的行进行排名的窗口函数。它们通常与 OVER() 子句一起使用，根据指定的条件对行进行分区和排序。以下是它们之间区别的详细说明：

-- ROW_NUMBER()：

如果多行具有相同的值和排名，它们将获得不同的行号。
行号是连续的，没有间隔。

-- RANK()：

如果多行具有相同的值和排名，它们将获得相同的排名，下一个排名将被跳过。
例如，如果两行的排名都是 2，下一行将被分配一个排名 4。

-- DENSE_RANK()：

如果多行具有相同的值和排名，它们将获得相同的排名，下一个排名将连续（不会跳过）。
例如，如果两行的密集排名是 2，下一行将被分配一个密集排名 3。
```

#### row_number

```sql
-- 对每个部门的员工按照薪资排序，并给出排名
select 
dname,
ename,
salary,
row_number() over(partition by dname order by salary desc) as rn 
from employee;


-- 分区（PARTITION BY）
PARTITION BY选项用于将数据行拆分成多个分区（组），它的作用类似于GROUP BY分组。如果省略了 PARTITION BY，所有的数据作为一个组进行计算
-- 排序（ORDER BY）
ORDER BY选项用于指定分区内的排序方式，与 ORDER BY 子句的作用类似
```

![image-20230819221916274](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819221916274.png)

#### rank

```sql
-- 对每个部门的员工按照薪资排序，并给出排名 rank
select 
dname,
ename,
salary,
rank() over(partition by dname order by salary desc) as rn 
from employee;

```

![image-20230819222226554](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819222226554.png)

#### dense_rank

```sql
-- 对每个部门的员工按照薪资排序，并给出排名 dense-rank
select 
dname,
ename,
salary,
dense_rank() over(partition by dname order by salary desc) as rn 
from employee;

```

![image-20230819222214021](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819222214021.png)

```sql
-- 对所有员工进行全局排序（不分组）
-- 不加partition by表示全局排序
select 
     dname,
     ename,
     salary,
     dense_rank() over( order by salary desc)  as rn
from employee;

```

![image-20230819223232207](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819223232207.png)

```sql
-- 求出每个部门薪资排在前三名的员工- 分组求TOPN
select 
* 
from 
(
    select 
     dname,
     ename,
     salary,
     dense_rank() over(partition by dname order by salary desc)  as rn
    from employee
)t
where t.rn <= 3

```

![image-20230819223404722](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819223404722.png)

### 开窗聚合函数

#### sum

```sql
use mydb3;
select
	dept_id,
	age,
	sum(age) over(partition by dept_id order by age) as pv1 
from emp3;
```

![image-20230819225435237](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819225435237.png)

```sql
-- 如果没有order  by排序语句  默认把分组内的所有数据进行sum操作
use mydb3;
select
	dept_id,
	age,
	sum(age) over(partition by dept_id) as pv1 
from emp3;
```

![image-20230819230839848](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819230839848.png)

```sql
-- 如果没有order  by 排序语句 也没有partition by 分区语句  默认把整个数据作为一组进行sum操作
use mydb3;
select
	dept_id,
	age,
	sum(age) over() as pv1 
from emp3;
```

![image-20230819232649209](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819232649209.png)

#### avg

```sql
use mydb3;
select
	dept_id,
	age,
	avg(age) over(partition by dept_id order by age) as pv1 
from emp3;
```

![image-20230819225559028](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819225559028.png)

```sql
-- 如果没有order  by排序语句  默认把分组内的所有数据进行avg操作
use mydb3;
select
	dept_id,
	age,
	avg(age) over(partition by dept_id) as pv1 
from emp3;
```

![image-20230819231035725](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819231035725.png)

```sql
-- 如果没有order  by 排序语句 也没有partition by 分区语句  默认把整个数据作为一组进行avg操作
use mydb3;
select
	dept_id,
	age,
	avg(age) over() as pv1 
from emp3;
```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819232712451.png" alt="image-20230819232712451"  />

#### max

```sql
use mydb3;
select
	dept_id,
	age,
	max(age) over(partition by dept_id order by age) as pv1 
from emp3;
```

![image-20230819225643709](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819225643709.png)

```sql
-- 如果没有order  by排序语句  默认把分组内的所有数据进行max操作
use mydb3;
select
	dept_id,
	age,
	max(age) over(partition by dept_id) as pv1 
from emp3;
```

![image-20230819231254164](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819231254164.png)

```sql
-- 如果没有order  by 排序语句 也没有partition by 分区语句  默认把整个数据作为一组进行max操作
use mydb3;
select
	dept_id,
	age,
	max(age) over() as pv1 
from emp3;
```

![image-20230819232734636](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819232734636.png)

#### min

```sql
use mydb3;
select
	dept_id,
	age,
	min(age) over(partition by dept_id order by age) as pv1 
from emp3;
```

![image-20230819225716324](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819225716324.png)

```sql
-- 如果没有order  by排序语句  默认把分组内的所有数据进行max操作
use mydb3;
select
	dept_id,
	age,
	min(age) over(partition by dept_id) as pv1 
from emp3;
```

![image-20230819231338580](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819231338580.png)

```sql
-- 如果没有order  by 排序语句 也没有partition by 分区语句  默认把整个数据作为一组进行min操作
use mydb3;
select
	dept_id,
	age,
	min(age) over() as pv1 
from emp3;
```

![image-20230819232755152](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819232755152.png)

#### count

```sql
use mydb3;
select
	dept_id,
	age,
	count(age) over(partition by dept_id order by age) as pv1 
from emp3;
```

![image-20230819225803548](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819225803548.png)

```sql
-- 如果没有order  by排序语句  默认把分组内的所有数据进行count操作
use mydb3;
select
	dept_id,
	age,
	count(age) over(partition by dept_id) as pv1 
from emp3;
```

![image-20230819231429835](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819231429835.png)



```sql
-- 如果没有order  by 排序语句 也没有partition by 分区语句  默认把整个数据作为一组进行count操作
use mydb3;
select
	dept_id,
	age,
	count(age) over() as pv1 
from emp3;
```

![image-20230819232821651](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230819232821651.png)

### 分布函数

#### CUME_DIST

```sql
 -- 用途：返回（分组内小于、等于当前行对应值有多少行 / 分组内总行数）的值
 
 -- 应用场景：查询小于等于当前薪资（salary）的比例
```

```sql
select  
 dname,
 ename,
 salary,
 cume_dist() over(order by salary) as rn1, -- 没有partition语句 所有的数据位于一组
 cume_dist() over(partition by dept order by salary) as rn2 
from employee;

/*
rn1: 没有partition,所有数据均为1组，总行数为12，
     第一行：小于等于3000的行数为3，因此，3/12=0.25
     第二行：小于等于4000的行数为5，因此，5/12=0.4166666666666667
rn2: 按照部门分组，dname='研发部'的行数为6,
     第一行：研发部小于等于3000的行数为1，因此，1/6=0.16666666666666666
*/

```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820091640793.png" alt="image-20230820091640793" style="zoom:50%;" />

#### PERCENT_RANK

```sql
-- 用途：每行按照公式(rank-1) / (rows-1)进行计算。其中，rank为RANK()函数产生的序号，rows为当前窗口的记录总行数

-- 应用场景：不常用
```

```sql
select 
 dname,
 ename,
 salary,
 rank() over(partition by dname order by salary desc ) as rn,
 percent_rank() over(partition by dname order by salary desc ) as rn2
from employee;

/*
 rn2:
  第一行: (1 - 1) / (6 - 1) = 0
  第二行: (1 - 1) / (6 - 1) = 0
  第三行: (3 - 1) / (6 - 1) = 0.4
*/
```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820092303773.png" alt="image-20230820092303773" style="zoom:50%;" />

### 前后函数

#### LAG

```sql
-- 用途：返回位于当前行的前n行（LAG(expr,n)）或后n行（LEAD(expr,n)）的expr的值

-- 应用场景：查询前1名同学的成绩和当前同学成绩的差值
```

```sql
-- lag的用法
select 
 dname,
 ename,
 hiredate,
 salary,
 lag(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as last_1_time,
 lag(hiredate,2) over(partition by dname order by hiredate) as last_2_time 
from employee;

/*
last_1_time: 指定了往上第1行的值，default为'2000-01-01'  
                         第一行，往上1行为null,因此取默认值 '2000-01-01'
                         第二行，往上1行值为第一行值，2021-11-01 
                         第三行，往上1行值为第二行值，2021-11-02 
last_2_time: 指定了往上第2行的值，为指定默认值
                         第一行，往上2行为null
                         第二行，往上2行为null
                         第四行，往上2行为第二行值，2021-11-01 
                         第七行，往上2行为第五行值，2021-11-02 
*/

```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820092803481.png" alt="image-20230820092803481" style="zoom:50%;" />

#### LEAD

```sql
-- lead的用法
select 
 dname,
 ename,
 hiredate,
 salary,
 lead(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as last_1_time,
 lead(hiredate,2) over(partition by dname order by hiredate) as last_2_time 
from employee;

```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820092827835.png" alt="image-20230820092827835" style="zoom:50%;" />

### 头尾函数

```sql
-- 用途：返回第一个（FIRST_VALUE(expr)）或最后一个（LAST_VALUE(expr)）expr的值

-- 应用场景：截止到当前，按照日期排序查询第1个入职和最后1个入职员工的薪资
```

```sql
-- 注意,  如果不指定ORDER BY，则进行排序混乱，会出现错误的结果
select
  dname,
  ename,
  hiredate,
  salary,
  first_value(salary) over(partition by dname order by hiredate) as first,
  last_value(salary) over(partition by dname order by  hiredate) as last 
from  employee;
```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820092917726.png" alt="image-20230820092917726" style="zoom:50%;" />

### 其他函数

#### NTH_VALUE(expr, n)

```sql
-- 用途：返回窗口中第n个expr的值。expr可以是表达式，也可以是列名

-- 应用场景：截止到当前薪资，显示每个员工的薪资中排名第2或者第3的薪资
```

```sql
-- 查询每个部门截止目前薪资排在第二和第三的员工信息
select 
  dname,
  ename,
  hiredate,
  salary,
  nth_value(salary,2) over(partition by dname order by hiredate) as second_score,
  nth_value(salary,3) over(partition by dname order by hiredate) as third_score
from employee

```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820093132693.png" alt="image-20230820093132693" style="zoom:50%;" />

#### NTILE(n)

```sql
-- 用途：将分区中的有序数据分为n个等级，记录等级数

-- 应用场景：将每个部门员工按照入职日期分成3组
```

```sql
-- 根据入职日期将每个部门的员工分成3组
select 
  dname,
  ename,
  hiredate,
  salary,
ntile(3) over(partition by dname order by  hiredate  ) as rn 
from employee;

```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820093158236.png" alt="image-20230820093158236" style="zoom:50%;" />

```sql
-- 取出每个部门的第一组员工
select
*
from
(
    SELECT 
        dname,
        ename,
        hiredate,
        salary,
    NTILE(3) OVER(PARTITION BY dname ORDER BY  hiredate  ) AS rn 
    FROM employee
)t
where t.rn = 1;

```

<img src="C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230820093301251.png" alt="image-20230820093301251" style="zoom:50%;" />
