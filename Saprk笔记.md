# 一、Spark RDD程序执行入口

```PYTHON
程序执行入口SparkContext对象

Spark RDD编程的程序入口对象是SparkContext对象(不论何种编程语言)只有构建出SparkContext,基于它才能执行后续的API调用和计算
本质上, SparkContext对编程来说,主要功能就是创建第一个RDD出来

from pyspark import SparkConf，SparkContext

if _name_ = '__main_ ":
# 构建SparkConf对象
conf = SparkConf().setAppName("helloworld").setMaster("local[*]")
# 构建SparkContext执行环境入口对象
sc = SparkContext(conf = conf)

```

![image-20230818095730351](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230818095730351.png)

![image-20230818095901041](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230818095901041.png)

# 二、RDD创建方式

![image-20230806114316181](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806114316181.png)

## •并行化集合创建 ( 本地对象 转 分布式RDD )

### parallelize

![image-20230806114330559](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806114330559.png)

## •读取外部数据源 ( 读取文件 )

### textFile

![image-20230806110841625](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806110841625.png)

```
textfile读取文件数据的每一行为一个元素且元素的类型为字符串类型存放在RDD中
```



### wholeTextFile

![image-20230806110930392](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806110930392.png)

![image-20230806111045550](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806111045550.png)

# 三、spark on yarn

## 代码提交到spark on yarn下运行方式

### 本地提交

```python
本地提交,即直接通过pycharm提交,但是有三个前提

# 前提一 
是本地已经成功连接到服务器,

# 前提二 
是在代码开头通过import os导入HADOOP_CONF_DIR的环境变量
import os
os.environ['HADOOP_CONF_DIR'] = "/export/server/hadoop/etc/hadoop"

# 前提三 
是通过textFile算子读取文件的路径必须在HDFD里,因此要在HDFS里提前创建好数据文件
```

### 服务器提交

```
服务器提交,即在服务器上通过spark-submit提交

# 前提一
不用在创建sparkconf对象的时候指定spark的运行模式,因为会在spark-submit命令行指定spark的运行模式,所以为了不引起冲突,不用在创建sparkconf对象的时候指定spark的运行模式

# 前提二
在服务器上创建.py文件,粘贴pycharm代码
```

### 注意

```
如果提交到集群运行, 除了主代码以外, 还依赖了其它的代码文件
需要设置一个参数, 来告知spark ,还有依赖文件要同步上传到集群中
参数叫做: spark.submit.pyFiles
参数的值可以是 单个.py文件, 也可以是.zip压缩包(有多个依赖文件的时候可以用zip压缩后上传)
        conf.set("spark.submit.pyFiles", ".py")
        
在服务器上通过spark-submit提交到集群运行
--py-files可以帮你指定你依赖的其它python代码，支持.zip(一堆)，也可以单个.py文件都行.
/export/server/spark/bin/spark-submit --master yarn --py-files ./defs.zip ./main.py
```

# 四、算子是什么？

![image-20230806111111681](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806111111681.png)

![image-20230806114702936](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806114702936.png)

# 五、Transformation：转换算子

## map

![image-20230806112228161](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112228161.png)

![image-20230806112315416](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112315416.png)

## flatmap

![image-20230806112328173](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112328173.png)

## reduceByKey

![image-20230806112351114](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112351114.png)

## mapValues

![image-20230806113341041](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113341041.png)

## groupBy

![image-20230806112422328](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112422328.png)

## filter

![image-20230806112433402](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112433402.png)

## distinct

![image-20230806112445196](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112445196.png)

## union

![image-20230806112502444](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112502444.png)

## join

![image-20230806112517230](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112517230.png)

## intersection

![image-20230806112527951](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112527951.png)

## glom

```
功能：可以查看rdd每个分区的数据
```

![image-20230806112733100](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112733100.png)

## groupByKey

![image-20230806112747219](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112747219.png)

## sortBy

![image-20230806112800353](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112800353.png)



## sortByKey

![image-20230806112813408](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112813408.png)

## mapPartitions

![image-20230806113218528](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113218528.png)



## partitionBy

![image-20230806113241546](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113241546.png)

![image-20230806113300332](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113300332.png)

## repartition

![image-20230806113312355](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113312355.png)

## coalesce

![image-20230806113320500](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113320500.png)





# 六、Action：动作算子

## getNumPartitions

![image-20230806110758114](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806110758114.png)

## collect

![image-20230806111652778](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806111652778.png)

## countByKey

![image-20230806112905077](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112905077.png)

```
对相同的key进行计数操作，也可用于单词计数
```



## reduce

![image-20230806112922721](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112922721.png)

## fold

![image-20230806112932332](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112932332.png)

## first

![image-20230806112939683](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112939683.png)

## take

![image-20230806112953249](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806112953249.png)

## top

![image-20230806113000732](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113000732.png)

## count

![image-20230806113010859](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113010859.png)

## takeSample

![image-20230806113020897](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113020897.png)

## takeOrdered

![image-20230806113031977](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113031977.png)

## foreach

![image-20230806113043274](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113043274.png)

## foreachPartion

![image-20230807082054815](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807082054815.png)

## RDD数据写出

### saveAsTextFile

![image-20230806113052499](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113052499.png)

![image-20230806113155909](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230806113155909.png)

# 七、RDD的持久化（优化）

## Cache

![image-20230807111826589](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807111826589.png)

```python
缓存
对于,上述的场景,肯定要执行优化,优化就是:
RDD3如果不消失，那么RDD1→RDD2→RDD3这个链条就不会执行2次,或者更多次
RDD的缓存技术: Spark提供了缓存APl,可以让我们通过调用APl,将指定的RDD数据保留在内存或者硬盘上缓存的API

# RDD3被2次使用,可以加入缓存进行优化
rdd3.cache()		#缓存到内存中．
rdd3.persist(storageLevel.MEMORY_ONLY)			#仅内存缓存
rdd3.persist(StorageLevel.MEMORY_ONLY_2)		#仅内存缓存，2个副本
rdd3.persist(storageLevel.DISK_ONLY)			#仅缓存硬盘上
rdd3.persist(StorageLevel.DISK_ONLY_2)			#仅缓存硬盘上，2个副本
rdd3.persist(storageLevel.DISK_ONLY_3)			#仅缓存硬盘上，3个副本
rdd3.persist(StorageLevel.MEMORY_AND_DISK)		#先放内存，不够放硬盘
rdd3.persist(StorageLevel.NENORY_AND_DISK_2)	#先放内存，不够放硬盘，2个副本
rdd3.persist(StorageLevel.OFF_HEAP)				#堆外内存(系统内存)

#如上API,自行选择使用即可,使用之前导包 from pyspark import StorageLevel
#一般建议使用rdd3.persist(StorageLevel.MEMORY_AND_DISK)
#如果内存比较小的集群，建议使用rdd3.persist(Sto=Q,Level.DISK_ONLY）或者就别用缓存了用CheckPoint

#主动清理缓存的API
rdd.unpersist()
```

## CheckPoint

![image-20230807112236057](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807112236057.png)

![image-20230807112312302](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807112312302.png)

```python
#设置checkPoint第一件事情,选择CP的保存路径
#如果是Local模式，可以支持本地文件系统，如果在集群运行，千万要用HDFS
sc.setCheckpointDir("hdfs://node1:8020/output/bj52ckp")
#用的时候,直接调用checkpoint算子即可.
rdd.checkpoint()
```

![image-20230807112402294](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807112402294.png)

## Cache和Checkpoint区别

![image-20230807112528429](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807112528429.png)

## Cache 和 CheckPoint的性能对比

![image-20230807112537971](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230807112537971.png)

# 八、共享变量

## 广播变量（优化）

![image-20230808092351453](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230808092351453.png)

![image-20230808092455216](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230808092455216.png)

![image-20230815213232218](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230815213232218.png)

## 累加器

![image-20230808092419100](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230808092419100.png)

```
使用方式
```

![image-20230808092828235](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230808092828235.png)

# 九、Spark 内核调度(重点理解、面试会问)

## DAG

![image-20230809090843289](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809090843289.png)

![image-20230809091119942](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091119942.png)

![image-20230809091015981](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091015981.png)

![image-20230809091305583](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091305583.png)

## DAG的宽窄依赖

![image-20230809091356814](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091356814.png)

![image-20230809091445174](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091445174.png)

![image-20230809091511765](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091511765.png)

## DAG的阶段划分

![image-20230809091603573](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809091603573.png)

## spark并行度

![image-20230809093419009](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809093419009.png)

![image-20230809093500198](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809093500198.png)

![image-20230809093525432](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809093525432.png)

## Spark的运行流程

![image-20230809094748241](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809094748241.png)

![image-20230809095106841](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809095106841.png)

# 十、SparkSQL

![image-20230809100613059](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809100613059.png)

```properties
简单来说sparkSQL和Hive一样,是一个分布式SQL计算引擎
```

## SparkSQL和Hive的异同

![image-20230809102307868](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809102307868.png)

## SparkSQL的数据抽象

![image-20230809103641446](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809103641446.png)

![image-20230809104122575](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809104122575.png)

## SparkSQL程序执行入口

![image-20230809105535418](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230809105535418.png)



```python
#coding: utf8
#SparkSession对象的导包，对象是来自于 pyspark.sqL包中

from pyspark.sql import SparkSession

if __name__ == '__main__ ':
#构建SparkSession执行环境入口对象
spark = SparkSession.builder.\
	appName( "test").\
	master("local[*]").\
	getOrCreate()
	
#通过SparkSession对象获取SparkContext对象
sc = spark.sparkContext
```



## DataFrame的组成

![image-20230810142602410](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230810142602410.png)

```python
StructType描述，如下

# 使用StructType之前要导包，包括表结构的包和列类型的包
from pyspark.sql.types import StructType, StringType, IntegerType

schema = StructType().\ 
	add("id", IntegerType(),False).\ 
	add("name", StringType(),True).\
	add("age", IntegerType(),False)
	
一个StructField记录:列名、列类型、列是否运行为空,多个StructField组成一个StructType对象。
一个StructType对象可以描述一个DataFrame:有几个列、每个列的名字和类型、每个列是否为空
同时，一行数据描述为Row对象，如Row(1,张三,11)
一列数据描述为Column对象，Column对象包含一列数据和列的信息

```



# 十一、DataFrame的创建方式

## 方式一：RDD —> DataFrame

```
DataFrame对象可以从RDD转换而来，都是分布式数据集 其实就是转换一下内部存储的结构，转换为二维表结构
```

### 算子：

#### createDataFrame

```
spark.createDataFrame()

​	用法1:只传列名, 类型靠推断, 是否允许为空是true  
​		spark.createDataFrame(rdd,schema = ['id', 'subject', 'score'])  
​	用法2:传入完整的Schema描述对象StructType  
​		spark.createDataFrame(rdd,schema)
```

#### toDF

```
rdd.toDF()

​		用法1:只传列名, 类型靠推断, 是否允许为空是true  
​			rdd.toDF(schema = ['id', 'subject', 'score'])  
​		用法2:传入完整的Schema描述对象StructType  
​			rdd.toDF(schema)
```



## 方式二：Pandas DataFrame —> SparkSQL DataFrame

### 算子:

#### createDataFrame

```
spark.createDataFrame(参数)
参数 Pandas的DataFrame对象
```

![image-20230810111337814](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230810111337814.png)

## 方式三：通过SparkSQL的统一API读取文件数据构建DataFrame 

### 算子：

#### read

```python
sparksession.read.\
	format("text|csv|json|parquet|orc|avro|jdbc|......").\
	option("K", "V").\ 		# option可选
	schema(StructType | String).\ 		
# STRING的语法是 schema("name STRING", "age INT") 和上面的 schema = ['id', 'subject', 'score']要区分开
	load("被读取文件的路径, 支持本地文件系统和HDFS")
```



### 读取text文件创建

```
读取text数据源
使用format(“text”)读取文本数据
读取到的DataFrame只会有一个列，列名默认称之为：value
```

```python
这里我们修改默认列名values 为data
schema = StructIype().add("data" , Stringlvpe(), nullable=True)

df = spark.read.\
	format("text").\
	schema(schema).\
	load("../data/sql/people.txt")
```



### 读取json文件创建

```
读取json数据源
使用format(“json”)读取json数据
```

```python
df = spark.read.\
	format("json").\
	load("../data/sql/people.json")
#JSON类型一般不用写.schema,因为json自带, json带有列名和列类型(字符串和数字)
```



### 读取CSV文件创建

```
读取csv数据源
使用format(“csv”)读取csv数据
```

```python
df = spark.read.\
	format("csv").\
	option("sep",";").\				# 列分隔符
	option("header", True|False).\		# 是否要csv标头（True是要|False是不要）
	option("encoding" , "utf-8").\	# 编码
	schema("name STRING, age lNT, job STRING").\	# 指定列名和类型
	load("../data/sql/people.csv")	# 路径
```



### 读取parquet文件创建 

```
读取parquet数据源
使用format(“parquet”)读取parquet数据

parquet: 是Spark中常用的一种列式存储文件格式和Hive中的ORC差不多, 他俩都是列存储格式

parquet对比普通的文本文件的区别:
1、parquet 内置 schema (列名\ 列类型\ 是否为空)
2、存储是以列作为存储格式
3、存储是序列化存储在文件中的(有压缩属性体积小)
```

```python
# parquet自带schema,直接load啥也不需要了
df = spark.read.\
	format("parquet").\
	load("../data/sql/users.parquet")
```



### 读取MySQL数据库创建

```python
df = spark.read.\
	format("jdbc").\
	option("url", "jdbc:mysql://node1:3306/指定读取的数据库名?useSSL=false&useUnicode=true").\
	option ("dbtable" , "指定读取的表名").\
	option("user" , "root").\
	option("password", "990130").\
	load()
注意:
读出来是自带schema,不需要设置schema,因为数据库就有schema
load()不需要加参数,没有路径,从数据库中读取的啊
```



# 十二、DataFrame的编程风格

## •DSL风格

```
DSL称之为：领域特定语言。

其实就是指DataFrame的特有API

DSL风格意思就是以调用API的方式来处理DataFrame的数据 比如：df.where().limit()
```

### DSL 风格的 API

#### show

```
功能：展示DataFrame中的数据, 默认展示20条 

语法：
    # df.show(参数1,参数2)
    # 参数1 表示 展示出多少条数据, 默认不传的话是20
    # 参数2 表示是否对列进行截断, 如果列的数据长度超过20个字符串长度, 后续的内容不显示以...代替
    # 如果给False 表示不截断全部显示, 默认是True
```

#### printSchema

```
功能：打印输出df的schema信息 （打印表结构）

语法：
	df.printSchema()
```

#### select

```
功能：选择DataFrame中的指定列（通过传入参数进行指定）,对选中的列进行各种操作

语法：
	#支持字符串形式传入
	df.select(["id", "subject"]).show()
	df.select("id", "subject").show()
	
	#也支持column对象的方式传入
	df.select(df['id'], df['subject']).show()

```

#### filter和where

```
功能：过滤DataFrame内的数据，返回一个过滤后的DataFrame  where和filter功能上是等价的

语法：
df.filter()  df.where()

# filter
df.filter( "score < 99" ) .show( )
df.filter(df ['score'] < 99 ) .show( )

# where和filter等价
df.where( "score < 99" ) .show( )
df.where(df [ 'score ' ] < 99 ) .show( )

```

#### groupby

```
功能：按照指定的列进行数据的分组， 返回值是GroupedData对象 

语法：
df.groupBy()
传入参数和select一样，支持多种形式，不管怎么传意思就是告诉spark  按照哪个列分组

#groupBy
df.groupBy ("subject") .count() .show()
df.groupBy(df['subject']).count() .show()

```

```
GroupedData对象
GroupedData对象是一个特殊的DataFrame数据集
其类全名：<class 'pyspark.sql.group.GroupedData'>
这个对象是经过groupBy后得到的返回值， 内部记录了以分组形式存储的数据

GroupedData对象其实也有很多API，比如前面的count方法就是这个对象的内置方法 除此之外，像：min、max、avg、sum、等等许多方法都存在,类似于SQL中的group by
```

```python
在 groupby() 下调用多个聚合函数，你可以使用 agg() 方法。

# 使用 groupBy 和 agg 调用多个聚合函数 sum
from pyspark.sql.functions import sum
result = df.groupBy("category").agg(sum("value").alias("total_value"), sum("value").alias("sum_of_values"))
```



#### withColumnRenamed

```
功能：重命名 DataFrame 中的某一列

语法：
df.withColumnRenamed('参数1','参数2')
参数1 表示原始列名
参数2 表示新列名
```

#### orderBy

```
功能：用于对 Spark DataFrame 中的数据进行排序。它接受一个或多个列名作为参数，可以按照指定的列进行升序或降序排序。

语法：
df.orderBy("列名", ascending=True|False)
```

#### first

```
功能:用于从 Spark DataFrame 中获取第一行数据。

	它不需要任何参数，直接在 DataFrame 上调用即可。

	返回值结果是Row对象.
	
	Row对象就是一个数组, 你可以通过row['列名'] 来取出当前行中某一列的具体数值. 
	
	返回值不再是DF 或者GroupedData 或者Column
	
	而是具体的值(字符串, 数字等)
	
语法：
df.first()
```



#### withColumn

```
功能：用于对单列进行操作（添加、替换或重命名列）

语法：
DataFrame.withColumn(colName, col)

colName 是要添加、替换或重命名的列的名称。
col 是一个表达式，可以是一个已有的列、一个新的表达式，或者一个常量。
```

```
以下是 withColumn 的几个用法示例：
```

```python
添加新列：

from pyspark.sql import SparkSession

# 创建SparkSession
spark = SparkSession.builder.appName("example").getOrCreate()

# 创建DataFrame
data = [("Alice", 25), ("Bob", 30), ("Carol", 28)]
employee_df = spark.createDataFrame(data, ["name", "age"])

# 添加新列 "department"
employee_with_department = employee_df.withColumn("department", "HR")

# 显示新的DataFrame
employee_with_department.show()

```

```python
替换现有列：

# 替换 "age" 列的值为 "31"
employee_with_updated_age = employee_df.withColumn("age", 31)

# 显示新的DataFrame
employee_with_updated_age.show()

```

```python
使用表达式创建新列：

from pyspark.sql.functions import expr

# 使用表达式创建 "is_adult" 列
employee_with_is_adult = employee_df.withColumn("is_adult", expr("age >= 18"))

# 显示新的DataFrame
employee_with_is_adult.show()

```



#### dropDuplicates 

```python
功能：数据去重

语法1：
		df.dropDuplicates()  
		
		无参数使用, 对全部的列 联合起来进行比较, 去除重复值, 只保留一条
		
语法2:
		df.dropDuplicates(['列名1','列名2']) 
		
		指定具体的字段去重
```



#### dropna

```python
功能：去除含缺失值的行

语法1：
		df.dropna()
	
		无参数为 how=any执行，只要有一个列是nu1ll数据整行删除，如果填入how='all’表示全部列为空才会删除，how参数默认是any
	
语法2：
        df.dropna(thresh=3)
		
		指定阀值进行删除,thresh=3表示，有效的列最少有3个，这行数据才保留,设定thresh后, how参数无效了
		
语法3：
        df.dropna(thresh=2,subset = ['name' , 'age'] )
		
		指定阀值以及配合指定列进行工作
		thresh=2,subset=['name', 'age']表示针对这2个列，有效列最少为2个才保留数据
```



####  fillna

```python
功能：填充缺失值数据

语法1：
		df.fillna("填充值")
		
		将所有的空，按照你指定的值进行填充
语法2：
		df.fillna("填充值" , subset=['列名'])
		
		指定列进行填充
语法3：
		df.fillna({ "name": "未知姓名","age": 1, "job": "worker" } )
		
		给定字典设定各个列的填充规则

```



## •SQL风格

```
SQL风格就是使用SQL语句处理DataFrame的数据 

比如：spark.sql("SELECT * FROM xxx")

前提是将DataFrame注册成为表才可以执行SQL
```

### SQL风格的 API

#### createTempView

```
功能：注册一个临时视图(表)

语法：
df.createTempView( "给临时表起个名字")	
```

#### create0rReplaceTempView

```
功能：注册一个临时表，如果存在进行替换.

语法：
df.create0rReplaceTempView("给临时表起个名字")	
```

#### createGlobalTempView

```
功能：#注册一个全局表

语法：
df.createGlobalTempView( "给全局表起个名字")
```

#### sparksession.sql

```python
功能：执行sql查询

语法：
sparksession.sql("sql语句")
返回值是一个新的df

示例:
#注册好表后就可以写sql查询
df2 = spark.sql("SELECT * FROM score WHERE score < 99")
df2.show ( )
```

# 十三、DataFrame数据写出

## API:

### write

```python
SparkSQL统─API写出DataFrame数据
统一API语法:

df.write.\
mode().\		# mode，传入模式字符串可选: append追加,overwrite覆盖,ignore 忽略，error重复就报异常(默认的)
format().\		# format，传入格式字符串，可选:text,csv,json,parquet, orc,avro,jdbc
option(K,V).\	# option设置属性，如: .option( "sep" , " , " )
save(PATH)		#save写出的路径,支持本地文件和HDFS

#注意text源只支持单列df写出

```



## 以text格式写出

```python
# Write text 写出，只能写出一个单列数据
df.select(F.concat_ws("---", "user_id","movie_id", "rank","ts")).\
	write. \
	mode("overwrite"). \
	format("text"). \
	save("../data/output/sql/text")
```

## 以csv格式写出

```python
# write csv写出
df.write.\
	mode("overwrite"). \
	format("csv"). \
	option("sep", ","). \
	option("header" , True). \
	save("../data/output/sql/csv")
```

## 以json格式写出

```python
# write Json写出
df.write.\
	mode("overwrite"). \
	format("json"). \
	save("../data/output/sql/json")
```

## 以parquet格式写出

```python
#write Parquet写出
df.write.\
	mode("overwrite"). \
	format("parquet"). \
	save("../data/output/sql/parquet")

#不给format，默认以parquet写出
df.write.\
	mode("overwrite").\
	save("../data/output/sql/default")
```

## 写出到MySQL

```python
# 写出到MySQL中
df.write.\
	format("jdbc"). \
	option("url", "jdbc:mysql://node1:3306/指定的数据库"). \
	option("dbtable", "给写入的表起个名字"). \
	option("user", "root"). \
	option("password", "990130"). \
	mode("append"). \
	save()


mode：
指定写入模式，可以设置为 "append"（追加数据）、"overwrite"（覆盖数据）、"ignore"（忽略，如果表已存在则不写入）或 "error"（如果表已存在则报错）。

url：
指定连接数据库的 URL，格式为 jdbc:mysql://host:port/database，其中 host 和 port 是 MySQL 服务器的主机名和端口号，database 是要连接的数据库名。

dbtable：
指定要写入的表名。

user 和 password：
数据库的用户名和密码，用于连接数据库。
```

## 写出到Hive

```python
# saveAsTable 可以将表写入到Hive的数据仓库中 要求已经配置好Spark On Hive
    df.write.\
    	mode("overwrite").\
    	saveAsTable("给导出的表起个名字", "parquet")
```



# 十四、SparkSQL的自动优化

```
RDD的运行会完全按照开发者的代码执行， 如果开发者水平有限，RDD的执行效率也会受到影响。

而SparkSQL会对写完的代码，执行“自动优化”， 以提升代码运行效率，避免开发者水平影响到代码执行效率。

思考：为什么SparkSQL可以自动优化而RDD不可以？

	RDD：内含数据类型不限格式和结构
	DataFrame：100% 是二维表结构，可以被针对
```

## Catalyst优器

```
SparkSQL的自动优化，依赖于：Catalyst优化器
```

![image-20230811114401222](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230811114401222.png)

## 自动优化2个大的优化项

- 断言（谓词）下推（行过滤） 
- 列值裁剪（列过滤）

![image-20230811114557640](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230811114557640.png)

# 十五、SparkSQL的运行流程

![image-20230811113741374](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230811113741374.png)

# 十六、Spark on Hive

## 原理

![image-20230812110936535](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812110936535.png)

![image-20230812110406709](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812110406709.png)

![image-20230812105919362](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812105919362.png)

![image-20230812110121750](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230812110121750.png)

## 在代码中集成SparkOnHive

```python
前提:确保MetaStore服务是启动好的

spark = SparkSession.builder. \
	appName ("create df"). \
	master("local[*]").\
	config("spark.sql.shuffle.paratitions","2"). \
	config("spark.sql.warehouse.dir" ,"hdfs://node1:8020/user/hive/warehouse"). \
	config("hive.metastore.uris", "thrift://node1: 9083").\
	enableHiveSupport(). \
	getOrCreate()
    
spark.sql(""""SELECT * FROM test.student""" ).show()
#如上加入3条语句:
#告知Spark默认创建表存到哪里
config("spark.sql.warehouse.dir","hdfs://node1:8020/user/hive/warehouse").\
#告知Spark Hive的MetaStore在哪
config("hive.metastore.uris", "thrift://node1:9083"").\
#告知Spark开启对Hive的支持
enableHiveSupport(). \
```



## 客户端操作

### ThriftServer服务

```
Spark中有一个服务叫做: ThriftServer服务（相当于hive中的hiveserver2服务），可以启动并监听在10000端口
这个服务对外提供功能,我们可以用数据库工具或者代码连接上来直接写SQL即可操作spark
```

### 启动ThriftServer服务

```shell
注意：启动ThriftServer之前要确保已经启动了hive的metastore服务

# 首先启动metastore元数据管理服务
cd /export/server/hive
nohup bin/hive --service metastore >> logs/metastore.log 2>&1 &

# 再启动客户端ThriftServer服务服务
cd /export/server/spark
sbin/start-thriftserver.sh \
--hiveconf hive.server2.thrift.port=10000 \
--hiveconf hive.server2.thrift.bind.host=node1 \
--master local[*]
#master选择local,每一条sql都是local进程执行
#master选择yarn,每一条sql都是在YARN集群中执行
```

