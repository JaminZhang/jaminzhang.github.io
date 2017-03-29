---
layout: post
title: Linux 系统性能监测分析相关资料学习
description: "Linux 系统性能监测分析相关资料学习"
category: Linux
avatarimg: 
tags: [Linux, OS, Perfermance]
duoshuo: true
---

# 引言

作为一个 Linux 运维工程师，必须得清楚地了解 Linux 系统当前的运行状况和性能。如何了解呢？  
Linux 系统本身就提供了各种查看系统性能的命令，当然还有很多其他开源的监控工具和软件。  
如何系统化学习这些相关的系统命令和工具？有没有一个好的学习路线？
最近几天看了一些关于 Linux 系统性能监测学习的资料，个人觉得值得学习的资料整理如下。

# 学习资料

## 1.1 Brendan Gregg 大神的 Linux Perfermance 相关资料与演讲

可以去其个人网站学习，非常全面和深入  
http://www.brendangregg.com/linuxperf.html

谁是 Brendan Gregg？类 UNIX 系统的性能分析大神，相信很多人都看过下面这张 Linux Performance Observability Tools 的图，就是出自于他
![linux_observability_tools](http://www.brendangregg.com/Perf/linux_observability_tools.png)

下面将上图的相关命令及工具进行如下分类（不定期总结）：

**OS Scheduler 与 CPU 相关命令及工具**  

* top - display Linux tasks.
* ps - report a snapshot of the current processes.
* mpstat - Report processors related statistics.
* 

## 1.2 《高性能 Linux 服务器构建实战》第 10 章 基于 Linux 服务器的性能分析与优化

> 10.1　系统性能分析的目的 / 248  
10.1.1　找到系统性能的瓶颈 / 248  
10.1.2　提供性能优化方案 / 248  
10.1.3　使系统硬件和软件资源的使用达到平衡 / 249  
10.2　分析系统性能涉及的人员 / 249  
10.2.1　Linux 系统管理人员 / 249  
10.2.2　系统架构设计人员 / 249  
10.2.3　软件开发人员 / 250  
10.3　影响 Linux 性能的各种因素 / 250  
10.3.1　系统硬件资源 / 250  
10.3.2　操作系统相关资源 / 252  
10.3.3　应用程序软件资源 / 253   
10.4　系统性能分析标准和优化原则 / 253  
10.5　几种典型应用对系统资源使用的特点 / 254  
10.5.1　以静态内容为主的 Web 应用 / 254  
10.5.2　以动态内容为主的 Web 应用 / 254  
10.5.3　数据库应用 / 255  
10.5.4　软件下载应用 / 255   
10.5.5　流媒体服务应用 / 256   
10.6　Linux 下常见的性能分析工具 / 256  
10.6.1　vmstat 命令 / 256  
10.6.2　sar 命令 / 258  
10.6.3　iostat 命令 / 260  
10.6.4　free 命令 / 262  
10.6.5　uptime 命令 / 263  
10.6.6　netstat 命令 / 263   
10.6.7　top 命令 / 265  
10.7　基于 Web 应用的性能分析及优化案例 / 268  
10.7.1　基于动态内容为主的网站优化案例 / 268  
10.7.2　基于动态、静态内容结合的网站优化案例 / 270  

## 1.3 《网站运维技术与实践》第1章 服务器监测

> 1.1 理解监测的意义 1  
1.2 通过命令了解系统的性能概况 2  
1.2.1 ifconfig 2  
1.2.2 w 3  
1.2.3 df 4  
1.2.4 ps 6  
1.2.5 vmstat 8  
1.2.6 netstat 8  
1.2.7 iostat 9  
1.3 其他常用工具 13  
1.3.1 sar 13  
1.3.2 dstat 14  
1.3.3 mtr 17  
1.3.4 IPtraf 18  
1.3.5 TcpDump 19  
1.3.6 Wireshark 22  
1.3.7 strace 23  
1.3.8 stap 24  
1.4 SmokePing 网络质量监测 34  
1.4.1 原理 35  
1.4.2 配置说明 37  
1.4.3 报警 39  
1.4.4 WebUI 40  
1.5 Nagios 分布式监测 41  
1.5.1 架构原理 42  
1.5.2 Plugin 编写 45  
1.5.3 SNMP 网络监控 46   
1.5.4 Gearman 分布式 50  
1.5.5 OMD 介绍 55  


## 学习情况
不定期更新


