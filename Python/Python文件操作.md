# Python文件操作

## 一、文件的打开

```
文件的打开目的是创建文件对象
```

### open

```python
语法：f = open("文件路径", "r|w|a", encoding="UTF-8")

# 注意：文件路径的层级用  /  分隔

功能：打开一个已经存在的文件，或者创建一个新文件，来创建文件对象
	其中：
    
		'r' 
    		表示以只读的方式打开文件
        
		'w' 
    		表示打开一个文件只用于写入。
    		如果该文件已存在则打开文件，并从开头开始编辑，原有内容会被删除。如果该文件不存在，创建新文件。
        
		'a' 
    		打开一个文件用于追加。如果该文件已存在，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。      
```

```python
如：f = open("D:/测试.txt", "r", encoding="UTF-8")
```

### with open

```
语法：with open("文件路径", "r|w|a", encoding="UTF-8") as f:

功能：# 通过在with open的语句块创建文件对象，可以在操作完成后自动关闭close文件，避免遗忘掉close方法
```

```py
如：with open("D:/测试.txt", "r", encoding="UTF-8") as f:
```



## 二、文件的读取

### read

```
语法：文件对象.read(num)

功能：num表示要从文件中读取的数据的长度（单位是字节），如果没有传入num，那么就表示读取文件中所有的数据，返回的是字符串。
```

```PY
f = open("D:/word.txt", "r", encoding="UTF-8")

# 读取文件
content = f.read()
# 打印文件内容
print(content)
print(type(content))
# 关闭文件
f.close()

结果：

itheima itcast python
itheima python itcast
beijing shanghai itheima
shenzhen guangzhou itheima
wuhan hangzhou itheima
zhengzhou bigdata itheima

<class 'str'>
```



### readlines

```
语法：文件对象.readlines(num)

功能：readlines可以按照行的方式把整个文件中的内容进行一次性读取，并且返回的是一个列表，其中每一行的数据为一个元素,元素为字符串类型。
```

```PY
f = open("D:/word.txt", "r", encoding="UTF-8")

# 读取文件的全部行，封装到列表中
content = f.readlines()   
print(content)
print(type(content))
# 关闭文件
f.close()

结果：
['itheima itcast python\n', 'itheima python itcast\n', 'beijing shanghai itheima\n', 'shenzhen guangzhou itheima\n', 'wuhan hangzhou itheima\n', 'zhengzhou bigdata itheima\n']
<class 'list'>
```

### readline

```
语法：文件对象.readline(num)

功能：一次读取一行内容,返回的是字符串。
```

```python
f = open("D:/word.txt", "r", encoding="UTF-8")

# 读取文件 - readline()
line1 = f.readline()
line2 = f.readline()
line3 = f.readline()
print(f"第一行数据是：{line1}")
print(type(line1))
print(f"第二行数据是：{line2}")
print(type(line2))
print(f"第三行数据是：{line3}")
print(type(line3))

# 关闭文件
f.close()

结果：
第一行数据是：itheima itcast python

<class 'str'>
第二行数据是：itheima python itcast

<class 'str'>
第三行数据是：beijing shanghai itheima

<class 'str'>
```

### for循环读取文件行

```
语法：for line in 文件对象:
    print(line)

功能：每一个line临时变量，就记录了文件的一行数据
```

```py
with open("D:/word.txt", "r", encoding="UTF-8") as f:
    for line in f:
        print(f"每一行数据是：{line}")
        
结果：
每一行数据是：itheima itcast python

每一行数据是：itheima python itcast

每一行数据是：beijing shanghai itheima

每一行数据是：shenzhen guangzhou itheima

每一行数据是：wuhan hangzhou itheima

每一行数据是：zhengzhou bigdata itheima
```



## 三、文件的写入

write

```python
语法：
	# 1. 打开文件
	f = open("文件路径", "w|a", encoding="UTF-8")
    # 2.文件写入
	f.write("写入的内容")
    # 3. 刷新内容到硬盘中
	f.flush()
	

功能：
		'w' 
    		表示打开一个文件只用于写入。
    		如果该文件已存在则打开文件，并从开头开始编辑，原有内容会被删除。如果该文件不存在，创建新文件。
        
		'a' 
    		打开一个文件用于追加。如果该文件已存在，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。 

            
注意：
	1、直接调用write，内容并未真正写入文件，而是会积攒在程序的内存中，称之为缓冲区，当调用flush的时候，内容会真正写入文件
	这样做是避免频繁的操作硬盘，导致效率下降（攒一堆，一次性写磁盘）
    2、close()方法，带有flush()方法的功能,所以可以不写flush
```



## 四、文件的关闭

### close

```
语法：文件对象.close()

功能：关闭文件对象，也就是关闭对文件的占用
	如果不调用close,同时程序没有停止运行，那么这个文件将一直被Python程序占用。
```

### with open 

```
语法：with open("文件路径", "r|w|a", encoding="UTF-8") as f:

功能：# 通过在with open的语句块创建文件对象，可以在操作完成后自动关闭close文件，避免遗忘掉close方法

```

