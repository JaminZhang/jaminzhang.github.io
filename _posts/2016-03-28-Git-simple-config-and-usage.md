---
layout: post
title: Git简单配置使用
description: "Git简单配置使用"
category: Linux
avatarimg:
tags: [Git]
duoshuo: true
---

# 引言
昨天配置好了GitLab通过SSH协议来访问，今天我来git clone下GitLab上的库和推送一下新文件。

# 配置git

```bash
git config --global user.name "<用户名>"
git config --global user.email "<电子邮件>"

#让Git以彩色显示。
git config --global color.ui auto
```   

# 克隆远程数据库
使用clone指令可以复制数据库，在<repository>指定远程数据库的URL，在<directory>指定新目录的名称。

```bash
git clone <repository> <directory>
```    

# 提交文件
在库目录下新增或编辑文件

```bash
#使用status命令确认工作树和索引的状态。
git status

#将文件加入到索引，要使用add命令。在<file>指定加入索引的文件。用空格分割可以指定多个文件。
git add <file>..

# 指定参数「.」，可以把所有的文件加入到索引。
git add .

# 提交文件
git commit -m "COMMENT"

# 再次执行git status，看没有新的变更要提交
git status

#使用log命令，我们可以在数据库的提交记录看到新的提交。
git log
```    

# push到远程数据库

向远程数据库推送本地数据库的修改记录。
您可以给远程数据库取一个别名。这样，下次推送的时候就不需要输入长串的远程数据库地址了。

```bash
#使用remote指令添加远程数据库。在<name>处输入远程数据库名称，在<url>处指定远程数据库的URL。
git remote add <name> <url>
 
#使用push命令向数据库推送更改内容。<repository>处输入目标地址，<refspec>处指定推送的分支。
git push <repository> <refspec>...

```    

# Ref
[初期设定](http://backlogtool.com/git-guide/cn/intro/intro2_2.html)  
[克隆远程数据库](http://backlogtool.com/git-guide/cn/intro/intro4_3.html)  
[提交文件](http://backlogtool.com/git-guide/cn/intro/intro2_4.html)  
[push到远程数据库](http://backlogtool.com/git-guide/cn/intro/intro4_2.html)  

