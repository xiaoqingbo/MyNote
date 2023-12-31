# day02_教育项目课程笔记

今日内容:

* 1) 教育项目的架构说明 (理解)
  2) cloudera manager 基本介绍 (了解)
  3) 教育项目环境搭建 (参考搭建笔记, 搭建成功)
  4) 数据仓库的基本介绍(回顾) -- 理解
  5) 维度分析的基本内容 -- 理解
  6) 数仓建模的基本内容 -- 理解
  7) 教育数仓分层架构 -- 理解

## 1. 教育项目的架构说明

![image-20210922093858947](day02_教育项目课程笔记.assets/image-20210922093858947.png)

```properties
项目的架构: 
	基于cloudera manager大数据统一管理平台, 在此平台之上构建大数据相关的软件(zookeeper,HDFS,YARN,HIVE,OOZIE,SQOOP,HUE...), 除此以外, 还使用FINEBI实现数据报表展示

各个软件相关作用:
	zookeeper: 集群管理工具, 主要服务于hadoop高可用以及其他基于zookeeper管理的大数据软件
	HDFS:  主要负责最终数据的存储
	YARN: 主要提供资源的分配
	HIVE: 用于编写SQL, 进行数据分析
	oozie:  主要是用来做自动化定时调度
	sqoop: 主要是用于数据的导入导出
	HUE: 提升操作hadoop用户体验, 可以基于HUE操作HDFS, HIVE ....
	FINEBI: 由帆软公司提供的一款进行数据报表展示工具

项目架构中: 数据流转的流程
	首先业务是存储在MySQL数据库中, 通过sqoop对MySQL的数据进行数据的导入操作, 将数据导入到HIVE的ODS层中, 对数据进行清洗转换成处理工作, 处理之后对数据进行统计分析, 将统计分析的结果基于sqoop在导出到MySQL中, 最后使用finebi实现图表展示操作, 由于分析工作是需要周期性干活, 采用ooize进行自动化的调度工作, 整个项目是基于cloudera manager进行统一监控管理


面试题: 
	请介绍一下最近做了一个什么项目? 为什么要做, 以及项目的架构和数据流转流程
	
	请介绍项目的架构是什么方案? 项目的架构和 数据流转的流程
	
	整个项目各个软件是如何交互的?   数据流转的流程

```



## 2. cloudera manager基本介绍

​		大数据的发行版本, 主要有三个发行版本: Apache 官方社区版本, cloudera 推出CDH商业版本, Hortworks推出的HDP商业免费版本, 目前HDP版本已经被cloudera 收购了



Apache版本Hadoop生态圈组件的优点和弊端:

优点:

* 完全开源，更新速度很快

* 大数据组件在部署过程中可以深刻了解其底层原理

* 可以了解各个组件的依赖关系

缺点

* 部署过程极其复杂，超过20个节点的时候，手动部署已经超级累 

* 各个组件部署完成后，各个为政，没有统一化管理界面

* 组件和组件之间的依赖关系很复杂，一环扣一环，部署过程心累

* 各个组件之间没有统一的metric可视化界面，比如说hdfs总共占用的磁盘空间、IO、运行状况等 

* 优化等需要用户自己根据业务场景进行调整（需要手工的对每个节点添加更改配置，效率极低，我们希望的是一个配置能够自动的分发到所有的节点上）



为了解决上述apache产生问题, 出现了一些**商业**化大数据组件, 其中以 cloudera 公司推出 CDH版本为主要代表

CDH是Apache Hadoop和相关项目中最完整、最稳定的、经过测试和最流行的发行版。 CDH出现帮助解决了各个软件之间的兼容问题, 同时内置大量的常规企业优化方案, 为了提供用户体验, 专门推出一款用于监控管理自家产品的大数据软件: cloudera manager



Cloudera Manager是用于管理CDH群集的B/S应用程序

使用Cloudera Manager，可以轻松部署和集中操作完整的CDH堆栈和其他托管服务（Hadoop、Hive、Spark、Kudu）。其特点：应用程序的**安装过程自动化**，将部署时间从几周缩短到几分钟; 并提供运行主机和服务的集群范围的**实时监控视图**; 提供单个中央控制台，以在整个群集中实施配置更改; 并集成了全套的报告和诊断工具，可帮助**优化性能**和利用率。



## 3. 教育项目的环境搭建

​		参考<<项目环境构建初始化.docx>>  构建即可



浏览器访问的界面:

![image-20210922105921536](day02_教育项目课程笔记.assets/image-20210922105921536.png)

用户名和密码都是 admin

![image-20210922105955016](day02_教育项目课程笔记.assets/image-20210922105955016.png)

打开后, 可能会出现上述 yarn中存在问题, 点击yarn进行解决接口, 如果都是对勾,那么就OK了

![image-20210922110103068](day02_教育项目课程笔记.assets/image-20210922110103068.png)

点击 jobhistory server. 进去后, 点击启动即可

![image-20210922110143836](day02_教育项目课程笔记.assets/image-20210922110143836.png)

最终效果:

![image-20210922110236631](day02_教育项目课程笔记.assets/image-20210922110236631.png)

后续如何关机的问题:

```properties
	教育项目中虚拟机, 坚决不允许挂起, 以及强制关闭操作, 如果做了, 非常大的概率导致服务器出现内存以及磁盘问题, 需要重新解压
	
	关机必须在CRT上直接关机命令: shutdown -h now   (每一个节点都要执行)
	重启服务器: 执行 reboot (每一个节点都要执行)

	需要注意: 如果将虚拟机放置在机械磁盘的, 如果长时间不使用这几个虚拟机, 建议将其关闭, 固态盘一般没啥问题, 但是依然建议关闭
```

服务器内存资源调整:

```
16gb:
	hadoop01: 默认占用12GB内存, 可以调整到 10.5GB  
	hadoop02: 默认占用3.5GB, 可以调整到 3GB

不调整也没什么太大问题, 只不过刚刚启动后, 等待20分钟之后, 在操作电脑就好了

注意: CDH软件开机后, 整个所有服务恢复正常, 大约需要耗时10~20分钟左右, 所以如果一开机就访问hadoop01:7180 可能是无法访问

如果等到 10~20分钟以后, 依然有大量的都是红色感叹号, 建议重启试一下, 如果依然不行, 老找我
如果只有偶尔一两个, 建议点进去, 重启一下即可



如果是12GB内存: 
	建议调整为
		hadoop01: 默认占用12GB内存, 可以调整到 7.5GB  
		hadoop02: 默认占用3.5GB, 可以调整到 3GB
	同时关闭掉CM所有监控服务项: 看下图

弊端:	
	缺失了cm的监控服务, CM无法感知各个是否都启动了...
	只能通过手动方式检测: 进入各个软件的管理界面
```

![image-20210922113301264](day02_教育项目课程笔记.assets/image-20210922113301264.png)

## 4. 数据仓库的基本概念

回顾1: 什么是数据仓库

```properties
	存储数据的仓库, 主要是用于存储过去既定发生的历史数据, 对这些数据进行数据分析的操作, 从而对未来提供决策支持
```

回顾2: 数据仓库最大的特点:

```properties
	既不生产数据, 也不消耗数据, 数据来源于各个数据源
```

回顾3: 数据仓库的四大特征:

```properties
1) 面向于主题的: 面向于分析, 分析的内容是什么 什么就是我们的主题
2) 集成性: 数据是来源于各个数据源, 将各个数据源数据汇总在一起
3) 非易失性(稳定性): 存储在数据仓库中数据都是过去既定发生数据, 这些数据都是相对比较稳定的数据, 不会发生改变
4) 时变性:  随着的推移, 原有的分析手段以及原有数据可能都会出现变化(分析手动更换, 以及数据新增)
```

回顾3: ETL是什么

```properties
	ETL: 抽取 转换 加载
	
	指的: 数据从数据源将数据灌入到ODS层, 以及从ODS层将数据抽取出来, 对数据进行转换处理工作, 最终将数据加载到DW层, 然后DW层对数据进行统计分析, 将统计分析后的数据灌入到DA层, 整个全过程都是属于ETL范畴
	
	狭义上ETL: 从ODS层到DW层过程
```

回顾四: 数据仓库和 数据库的区别

```properties
数据库(OLTP):  面向于事务(业务)的 , 主要是用于捕获数据 , 主要是存储的最近一段时间的业务数据, 交互性强 一般不允许出现数据冗余
数据仓库(OLAP): 面向于分析(主题)的 , 主要是用于分析数据, 主要是存储的过去历史数据 , 交互性较弱 可以允许出现一定的冗余
```

![image-20210922114839324](day02_教育项目课程笔记.assets/image-20210922114839324.png)



数据仓库和数据集市:

```properties
	数据仓库其实指的集团数据中心: 主要是将公司中所有的数据全部都聚集在一起进行相关的处理操作   (ODS层)
		此操作一般和主题基本没有什么太大的关系
	数据的集市(小型数据仓库): 在数据仓库基础之上, 基于主题对数据进行抽取处理分析工作, 形成最终分析的结果
	
	一个数据仓库下, 可以有多个数据集市
```



## 5. 维度分析

维度分析: 针对某一个主题, 可以从不同的维度的进行统计分析, 从而得出各种指标的过程

* 什么是维度:

```properties
	维度一般指的分析的角度, 看待一个问题的时候, 可以多个角度来看待, 而这些角度指的就是维度
	比如: 有一份2020年订单数据, 请尝试分析
		可以从时间, 地域 , 商品, 来源 , 用户....
	
	维度的分类:
		定性维度: 指的计算每天 每月 各个的维度 , 一般来说定性维度的字段都是放置在group by 中
		定量维度: 指的统计某一个具体的维度或者某一个范围下信息, 比如说: 2020年度订单额, 统计20~30岁区间人群的人数 ,一般来说这种维度的字段都是放置在where中
		
		
	维度的分层和分级:  本质上对维度进行细分的过程
		比如按年统计:  
			按季度
			按照月份
			按照天
			按照每个小时
		比如: 按省份统计:
			按市
			按县
		
		从实际分析中, 统计的层级越多, 意味统计的越细化 设置维度内容越多
	
	维度的下钻和上卷: 以某一个维度为基准, 往细化统计的过程称为下钻, 往粗粒度称为上卷
		比如: 按照 天统计, 如果需要统计出 小时, 指的就是下钻, 如果需要统计 季度 月 年, 称为上卷统计
		
		从实际分析中, 下钻和上卷, 意味统计的维度变得更多了
	
```

* 什么是指标

```properties
	指标指的衡量事务发展的标准,	就是度量值
	常见的度量值: count() sum() max() min() avg()  还有一些 比例指标(转化率, 流失率, 同比..)
	
	指标的分类:
		绝对指标: 计算具体的值指标
			count() sum() max() min() avg()
		相对指标: 计算比率问题的指标
			转化率, 流失率, 同比
```



案例:

```sql
需求: 请求出在2020年度, 女性 未婚 年龄在18~25岁区间的用户每一天的订单量?

维度:  时间维度 , 性别, 婚姻状态, 年龄
	定性维度:  每一天
    定量维度: 2020年度,18~25岁,女性,未婚

指标: 订单量(绝对指标) --> count()

select day,count(1)   from  表  where year ='2020' and age between 18 and 25 and 婚姻='未婚' and sex = '女性' group by  day;
```

## 6. 数仓建模

​		**数仓建模指的规定如何在hive中构建表,** 数仓建模中主要提供两种理论来进行数仓建模操作:  三范式建模和维度建模理论

​		三范式建模:  主要是存在关系型数据库建模方案上, 主要规定了比如建表的每一个表都应该有一个主键, 数据要经历的避免冗余发生等等

​		维度建模: 主要是存在分析性数据库建模方案上, 主要一切以分析为目标, 只要是利于分析的建模, 都是OK的, 允许出现一定的冗余, 表也可以没有主键

![image-20210922155158759](day02_教育项目课程笔记.assets/image-20210922155158759.png)

维度建模的两个核心概念：事实表和维度表。

### 6.1 事实表

​		事实表: 事实表一般指的就是分析主题所对应的表,每一条数据用于描述一个具体的事实信息, 这些表一般都是一坨主键(外键)和描述事实字段的聚集

```properties
例如: 比如说统计2020年度订单销售情况 

主题:  订单 
相关表: 订单表(事实表)
思考: 在订单表, 一条数据, 是不是描述一个具体的订单信息呢?  是的
思考: 在订单表, 一般有那些字段呢? 
	订单的ID, 商品id,单价,购买的数量,下单时间, 用户id,商家id, 省份id, 市区id, 县id 商品价格...

进行统计分析的时候, 可以结合 商品维度, 用户维度, 商家维度, 地区维度 进行统计分析, 在进行统计分析的时候, 可能需要关联到其他的表(维度表)

注意:
	一般需要计算的指标字段所在表, 都是事实表
```

事实表的分类:

```properties
1) 事务事实表:
	保存的是最原子的数据，也称“原子事实表”或“交易事实表”。沟通中常说的事实表，大多指的是事务事实表。
2) 周期快照事实表:
	周期快照事实表以具有规律性的、可预见的时间间隔来记录事实，时间间隔如每天、每月、每年等等
	周期表由事务表加工产生
3) 累计快照事实表:
	完全覆盖一个事务或产品的生命周期的时间跨度，它通常具有多个日期字段，用来记录整个生命周期中的关键时间点
```

![image-20210922163704822](day02_教育项目课程笔记.assets/image-20210922163704822.png)



### 6.2 维度表

​		维度表: 指的是在基于某一个维度对事实表进行统计分析的时候, 而这个维度信息可能来源于其他表中, 这些表就是维度表

```properties
维度表并不一定存在, 但是维度是一定存在:
	比如: 根据用户维度进行统计, 如果在事实表只存储了用户id, 此时需要关联用户表, 这个时候就是维度表
	比如: 根据用户维度进行统计, 如果在事实表不仅仅存储了用户id,还存储用户名称, 这个时候有用户维度, 但是不需要用户表的参与, 意味着没有这个维度表
```

维度表的分类:

```properties
高基数维度表: 指的表中的数据量是比较庞大的, 而且数据也在发送的变化
	例如: 商品表, 用户表

低基数维度表: 指的表中的数据量不是特别多, 一般在几十条到几千条左右,而且数据相对比较稳定
	例如: 日期表,配置表,区域表
```



### 6.3 维度建模的三种模型

* 第一种: 星型模型
  * 特点:  只有一个事实表, 那么也就意味着只有一个分析的主题, 在事实表的周围围绕了多个维度表, 维度表与维度表之间没有任何的依赖
  * 反映数仓发展初期最容易产生模型
* 第二种: 雪花模型
  * 特点: 只有一个事实表, 那么也就意味着只有一个分析的主题, 在事实表的周围围绕了多个维度表, 维度表可以接着关联其他的维度表
  * 反映数仓发展出现了畸形产生模型, 这种模型一旦大量出现, 对后期维护是非常繁琐, 同时如果依赖层次越多, SQL分析的难度也会加大 
  * 此种模型在实际生产中,建议尽量减少这种模型产生
* 第三种: 星座模型
  * 特点: 有多个事实表, 那么也就意味着有了多个分析的主题, 在事实表的周围围绕了多个维度表, 多个事实表在条件符合的情况下, 可以共享维度表
  * 反映数仓发展中后期最容易产生模型

![image-20210922172757259](day02_教育项目课程笔记.assets/image-20210922172757259.png)

### 6.4 缓慢渐变维

​	解决问题: 解决历史变更数据是否需要维护的情况

* SCD1:  直接覆盖, 不维护历史变化数据 
  * 主要适用于: 对错误数据处理
* **SCD2:**不删除、不修改已存在的数据, 当数据发生变更后, 会添加一条新的版本记录的数据, 在建表的时候, 会多加两个字段(起始时间, 截止时间), 通过这两个字段来标记每条数据的起止时间  , 一般称为**拉链表**
  * 好处:  适用于保存多个历史版本, 方便维护实现
  * 弊端:  会造成数据冗余情况, 导致磁盘占用率提升
* SCD3:  通过在增加列的方式来维护历史变化数据
  * 好处: 减少数据的冗余, 适用于少量历史版本的记录以及磁盘空间不是特别充足情况
  * 弊端: 无法记录更多的历史版本, 以及维护比较繁琐

```properties
面试题:
	1) 在项目中, 如何实现历史变化维护工作的
	2) 如何实现历史版本数据维护, 你有几种方案呢?   三种 
	3) 请简述如何实现拉链表
```

