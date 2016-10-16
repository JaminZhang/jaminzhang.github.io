---
layout: post
title: find 命令用法总结
description: "find 命令用法总结"
category: Linux
avatarimg:
tags: [bash, find, grep, commands]
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

# Ref
[Linux统计某文件夹下文件、文件夹的个数](http://blog.sina.com.cn/s/blog_464f6dba01012vwv.html)  
