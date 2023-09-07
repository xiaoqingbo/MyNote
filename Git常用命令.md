# Git常用命令

## 1、查看当前Git软件的安装版本

```shell
git -v
git --version
```

## 2、获取软件的配置信息

```shell
git config -l
```

## 3、配置Git用户名以及用户邮箱

```shell
git config --global user.name 用户名
git config --global user.email 邮箱地址
```

## 4、初始化，创建文件版本库

```shell
# 在文件夹（版本库管理目录）内打开git命令界面输入该命令会生成.git文件夹，意味着当前文件夹里的文件版本受git管理
git init
```

## 5、查看版本库状态

```shell
git status
```

## 6、文件添加到暂存区

```shell
git add 文件名
```

## 7、文件提交至版本库

```shell
git commit -m "日志信息" 文件名

# commit表示真正地纳入到版本库中
# -m 表示提交时的信息（message），是必须输入的。用于描述不同版本之间的差别信息
```

```shell
# 简写：将上两步合为一步
git commit -a -m "日志信息" 文件名
```

## 8、查看当前提交

```shell
git show
```

## 9、查看文件历史版本号

```shell
git reflog
	或
git log
```

## 10、版本穿梭

```shell
git reset --hard 版本号 
# 这里的版本号可以通过git reflog获取
```

## 11、创建分支

```shell
git branch 分支名称
```

## 12、查看分支

```shell
git branch -v
```

## 13、切换分支

```shell
git checkout 分支名
```

## 14、删除分支

```shell
git branch -d 分支名称
```

## 15、分支合并

```shell
# 先切换回主干分支，然后执行分支合并指令
git merge 分支名称
```

## 16、分支合并冲突

```shell
1）编辑有冲突的文件，删除特殊符号，决定要使用的内容
特殊符号：<<<<<<< HEAD 当前分支的代码 ======= 合并过来的代码 >>>>>>> hot-fix

2）添加到暂存区

3）执行提交（注意：此时使用 git commit 命令时不能带文件名）
```

# GitHub

```
以下操作建立在GitHub上已经创建好了对应远程库的前提下
```

## 1、查看当前所有远程地址别名

```
git remote -v
```

## 2、添加远程仓库

```shell
git remote add 远程库别名 远程库地址
```

## 3、推送文件至GitHub远程仓库

```shell
# 前提是文件已经提交至本地仓库
git push 远程库别名 分支名
```

## 4、克隆远程仓库成为本地仓库

```shell
git clone 远程地址
# clone 会做如下操作。1、拉取代码。2、初始化本地仓库。3、创建别名
```

## 5、拉取远程库内容

```shell
git pull 远程库地址别名 远程分支名
```

![img](http://kmknkk.oss-cn-beijing.aliyuncs.com/image/git.jpg)

## 6、



## 7、



## 8、



## 9、



## 10、

