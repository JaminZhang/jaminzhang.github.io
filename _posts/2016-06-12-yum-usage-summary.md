---
layout: post
title: yum 用法总结
description: "yum 用法总结"
category: Linux
avatarimg: 
tags: [yum]
duoshuo: true
---

# 引言
经常碰到要查询某个命令属于什么软件包，比如这几天部署 smokeping 时遇到不知道 dig 命令是属于什么软件包。  
使用 yum provides 选项参数 即可查询。  
再比如只知道软件包部分关键字，想搜索对应软件包全称，这是可以使用 yum search all KEYWORDS 来搜索  
yum 使用的还是比较频繁的，所以这里准备不断总结 yum 在实际工作中常用的选项参数。


# 1 yum provides

> 
provides       Find what package provides the given value

查找有什么软件包能提供给定的值

例子：比如查询什么软件包提供 dig 命令

```bash  
[root@linux-node1 ~]# yum provides dig

32:bind-utils-9.9.4-29.el7_2.3.x86_64 : Utilities for querying DNS name servers
Repo        : updates
Matched from:
Filename    : /usr/bin/dig
```   

# Ref
yum --help  
