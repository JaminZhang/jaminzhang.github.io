---
layout: post
title: Linux iostat使用
description: "Linux iostat使用"
category: Linux
avatarimg: 
tags: [iostat]
duoshuo: true
---

# 引言
某游戏业务进行合服，游戏区服数据库比较大，有77G，合服前会先全备一下数据库。  
于是我想查看当前数据库备份时系统的IO情况，主要是IO的速度，以便估计整个备份所花费的时间。  
查看系统IO状态的常用命令是iostat和iotop，这次我使用的iostat。在此记录下。

# iostat常用用法

1.查看TPS和吞吐量信息
iostat -d -m 1 10

PS:使用上面的命令查看mysql数据库备份时状态可以发现写入时并不是一直写入，而是间隔一段时间，读取积累了较多的数据再写入，推测这里是运用了类似缓冲区的策略。



2.查看设备使用率（%util）、响应时间（await）
iostat -d -x -m 1 10  

相关命令选项参见man。



# Ref
[Linux iostat监测IO状态](http://www.orczhou.com/index.php/2010/03/iostat-detail/)  
