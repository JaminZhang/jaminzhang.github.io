---
layout: post
title: find 命令用法总结
description: "find 命令用法总结"
category: Linux
avatarimg:
tags: [Linux, find, grep ]
duoshuo: true
---

# 实例 1

统计某目录下的所有文件个数（包含子目录）。

首先应该想到的方法便是使用 find 命令，如下：

```bash

[root@xxx_admin res]# find ./ -type f | wc -l
55490

```    

然后还看到这样不那么直接, 使用 grep 命令来查找并统计，如下：

```bash

[root@xxx_admin res]# ls -lR | grep "^-" | wc -l
55489

```    

上面统计的数目为什么相差 1，现在还没想明白。

# 实例 2

称动当前目录的 test.log 文件 到 /tmp 目录下

```bash

[root@VM_15_187_centos ~]# find ./ -type f -iname "test.log" -exec ls -l  {} \;
-rw-r--r-- 1 root root 27 Mar 21 15:23 ./test.log
[root@VM_15_187_centos ~]# find ./ -type f -iname "test.log" -exec mv {} /tmp/ \; # 注意 -exec 写法，经常以为是两个"-"
[root@VM_15_187_centos ~]# ll /root/test.log /tmp/test.log 
ls: cannot access /root/test.log: No such file or directory
-rw-r--r-- 1 root root 27 Mar 21 15:23 /tmp/test.log

```    

# Ref
[Linux 统计某文件夹下文件、文件夹的个数](http://blog.sina.com.cn/s/blog_464f6dba01012vwv.html)  
