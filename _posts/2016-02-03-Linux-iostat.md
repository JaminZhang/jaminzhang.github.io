---
layout: post
title: Linux iostat 使用
description: "Linux iostat 使用"
category: Linux
avatarimg: 
tags: [Linux, iostat]
duoshuo: true
---

# 引言

某游戏业务进行合服，游戏区服数据库比较大，有 77G，合服前会先全备一下数据库。  
于是我想查看当前数据库备份时系统的 IO 情况，主要是 IO 的速度，以便估计整个备份所花费的时间。  
查看系统 IO 状态的常用命令是 iostat 和 iotop，这次我使用的 iostat。在此记录下。

# iostat 常用用法

1. 查看 TPS 和吞吐量信息

<pre>
iostat -d -m 1 10
</pre>

PS: 使用上面的命令查看 mysql 数据库备份时状态可以发现写入时并不是一直写入，而是间隔一段时间，读取积累了较多的数据再写入，
推测这里是运用了类似缓冲区的策略。



2. 查看设备使用率（%util）、响应时间（await）
iostat -d -x -m 1 10  

相关命令选项参见 man。



# Ref
[Linux iostat 监测 IO 状态](http://www.orczhou.com/index.php/2010/03/iostat-detail/)  
