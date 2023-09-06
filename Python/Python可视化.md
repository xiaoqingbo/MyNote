# pyechars包的使用

```
pyechars包专为数据可视化而生
```

## 一、json文件

```
json数据就是一个单独的字典或一个内部元素都是字典的列表所构成的字符串数据

说白了，json数据就是一个字符串，但是字符串的内容由字典或一个内部元素都是字典的列表构成
```

### json数据格式

```PY
# json数据的格式可以是： 
"{"name":"admin","age":18}" 


# 也可以是：  
"[{"name":"admin","age":18},{"name":"root","age":16},{"name":"张三","age":20}] "

```



### json数据 和 Python数据的相互转化

#### json数据 ——> Python数据

##### load方法

```PY
# 导入json模块 
import json 

# 通过 json.loads(json数据) 方法把json数据转化为了 python数据 (字典|内部元素都是字典的列表)
dict|list = json.loads(json数据)
```

```PY
"""
演示json数据 ——> Python数据
"""
import json

# 将JSON字符串转换为Python数据类型[{k: v, k: v}, {k: v, k: v}]
s = '[{"name": "张大山", "age": 11}, {"name": "王大锤", "age": 13}, {"name": "赵小虎", "age": 16}]'
l = json.loads(s)
print(type(l))
print(l)
# 将JSON字符串转换为Python数据类型{k: v, k: v}
s = '{"name": "周杰轮", "addr": "台北"}'
d = json.loads(s)
print(type(d))
print(d)

结果：
<class 'list'>
[{'name': '张大山', 'age': 11}, {'name': '王大锤', 'age': 13}, {'name': '赵小虎', 'age': 16}]
<class 'dict'>
{'name': '周杰轮', 'addr': '台北'}
```

#### Python数据 ——> json数据

##### dumps方法

```py
# 导入json模块 
import json 

# 通过 json.dumps(Python数据) 方法把Python数据转化为了 json数据 (字符串)
str = json.dumps(Python数据)
```



```py
"""
演示Python数据 ——> json数据
"""
import json

# 准备列表，列表内每一个元素都是字典，将其转换为JSON
data = [{"name": "张大山", "age": 11}, {"name": "王大锤", "age": 13}, {"name": "赵小虎", "age": 16}]
json_str = json.dumps(data, ensure_ascii=False)
print(type(json_str))
print(json_str)

# 准备字典，将字典转换为JSON
d = {"name":"周杰轮", "addr":"台北"}
json_str = json.dumps(d, ensure_ascii=False)
print(type(json_str))
print(json_str)

结果：
<class 'str'>
[{"name": "张大山", "age": 11}, {"name": "王大锤", "age": 13}, {"name": "赵小虎", "age": 16}]
<class 'str'>
{"name": "周杰轮", "addr": "台北"}	
```



## 二、折线图开发

### 所需数据

```
X 轴：列表类型

Y 轴：列表类型
```

### 基础语法

#### Line类

```PY
#导包，从pyecharts包下的charts模块里调用Line类
from pyecharts.charts import Line

#创建折线图Line对象
line = Line()

#调用Line里的成员方法add_xaxis,添加x轴数据
line.add_xaxis(["中国"，"美国"，"英国"])
               
#调用Line里的成员方法add_yaxis,添加x轴数据          
line.add_yaxis("GDP"，[30，20 ,10])
               
# 调用Line里的成员方法render，将代码生成为图像
line.render("每日的累计确诊病例数和死亡数.html")
```

### 全局配置选项

```
全局配置选项可以通过 set_global_opts 方法来进行配置, 相应的选项和选项的功能如下:

1、配置图表的标题
2、配置图例
3、配置鼠标移动效果
4、配置工具栏
5、视觉映射
```

![image-20230817132954654](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817132954654.png)

```python
from pyecharts.options import *

line.set_global_opts(
	title_opts=TitleOpts(title="标题",pos_left="center", pos_bottom="1%"),
	legend_opts=LegendOpts(is_show=True),
	toolbox_opts=ToolboxOpts(is_show=True),
	visualmap_opts=VisualMapOpts(is_show=True),
	tooltip_opts=TooltipOpts(is_show=True),
)
```



## 三、地图开发

### 所需数据

```py
列表类型，元素为元祖类型 ("位置",显示的内容)

data = [("北京",99),("上海",199),("湖南",299),("台湾",199),("安徽",299),("广州",399),("湖北",599)]
```

### 基础语法

#### Map类

```py
#导包，从pyecharts包下的charts模块里调用Map类
from pyecharts.charts import Map

#创建地图Map对象
map = Map()

data = [("北京"，99),("上海"，199)，("湖南"，299),("台湾"，199),("安徽"，299)，("广州"，399)，("湖北"，599)]

#调用Map里的成员方法add,添加数据
map.add("参数1", data, "参数2" ) 
# 参数1 表示给地图起个名字  
# 参数2 表示使用哪个地区的地图，支持 全球国家地图|中国省级地图|中国市级地图|中国区级地图  

# 调用Map里的成员方法render，将代码生成为图像
map.render("**地图.html")
```

### 全局配置选项

#### 视觉映射器

```
就是调区域颜色
```

![image-20230817211126538](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817211126538.png)

![image-20230817210812334](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817210812334.png)

```PY
from pyecharts.options import *

map.set_global_opts(
	visualmap_opts=VisualMap0pts(
	is_show=True,
	is_piecewise=True,
	pieces=[
		{"min": 1,"max": 9,"label" : "1-9人","color" :"#CCFFFF"},
 		{"min": 10,"max" : 99,"label": "10-99人","color" : "#FFFF99"},
 		{"min": 100,"max": 499,"label": "99-499人","color":"#FF9966"},
		{"min": 500,"max": 999,"label": "499-999人","color ": "#FF6666"},
 		{"min": 1000,"max": 9999，"label": "1000-9999人","color":"#CC3333"},
 		{"min": 10000,"label" : "10000以上","color" : "#990033"}
	])
)
```



## 四、柱状图开发

### 所需数据

```
X 轴：列表类型

Y 轴：列表类型
```

### 基础语法

#### Bar类

```py
#导包，从pyecharts包下的charts模块里调用Bar类
from pyecharts.charts import Bar

#构建柱状图bar对象
bar = Bar()
#调用Bar里的成员方法add_xaxis,添加x轴数据
bar.add_xaxis(["中国","美国","英国"])
#调用Bar里的成员方法add_yaxis,添加y轴数据
bar.add_yaxis("GDP",[30,20,10])
#调用Bar里的成员方法render,将代码生成为图像
bar.render("基础柱状图.html")
```

![image-20230817212858896](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817212858896.png)



```py
# 若要 反转x和y轴 调用Bar里的成员方法reversal_axis
bar.reversal_axis()
```

![image-20230817212656583](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817212656583.png)

![image-20230817213022846](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817213022846.png)

```
数值标签在右侧

#添加y轴数据
bar.add_yaxis ("GDP",[30,20,10],label_opts = Labelopts(position="right"))
```

![image-20230817213105774](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817213105774.png)



## 五、基础的时间线配置动态图表

```
如果说一个Bar、Line对象是一张图表的话，时间线就是创建一个一维的x轴，轴上每一个点就是一个图表对象
```

![image-20230817213616174](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817213616174.png)

### Timeline类

```py
from pyecharts.charts import Bar，Timeline
from pyecharts.options import *

bar1 = Bar()
bar1.add_xaxis(["中[国","美国","英国"]
bar1.add_yaxis("GDP",[30,20,10],label_opts=Label0pts(position="right"))
bar1.reversal_axis()
    
bar2 = Bar()
bar2.add_xaxis(["中国","美国","英国"])
bar2.add_yaxis("GDP",[50,30,20],label_opts=Labelopts(position="right"))
bar2.reversal_axis()
    
#创建时问线对象
timeline = Timeline()
               
#timeline对象添加bar柱状图
timeline.add(bar1,"2021年GDP")
timeline.add(bar2,"2022年GDP")

#通过时问线绘图
timeline.render("基础柱状图-时间线.html")
```

### 设置自动播放

```py
#设置自动播放
timeline.add_schema(
	play_interval=1000,	#自动播放的时间间隔，单位毫秒
	is_timeline_show=True,	#是否在自动播放的时候，显示时间线
	is_auto_play=True,	#是否自动播放
	is_loop_play=True	#是否循环自动播放
)
```

### 设置主题

![image-20230817214748716](C:\Users\A\AppData\Roaming\Typora\typora-user-images\image-20230817214748716.png)