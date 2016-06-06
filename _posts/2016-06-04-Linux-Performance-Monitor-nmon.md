---
layout: post
title: Linux 系统监控和性能分析工具 nmon
description: "Linux 系统监控和性能分析工具 nmon"
category: Linux
avatarimg:
tags: [Linux, nmon, Performance]
duoshuo: true
---

## 引言
之前并没有怎么使用这个系统监控和性能分析工具，现在来学习学习。

## 简介

> 
nmon is short for Nigel's performance Monitor for Linux on POWER, x86, x86_64, Mainframe & now ARM (Raspberry Pi)
	
该工具比较有用！用于生成系统性能测试数据，并可使用 nmon_analyser 生成对应图形报表。

>
[root@linux-node1 ~]# ./nmon16e_x86_rhel72 -f -s 5 -c 10 -f

在当前目录下生成了 .nmon 结尾的数据文件，然后下载 nmon_analyser(其实是一个启用了宏的 Excel Workbook)。  
导入 .nmon 数据文件后，就可以生成对应的包含图形的报表。


# Ref
[nmon performance: A free tool to analyze AIX and Linux performance](https://www.ibm.com/developerworks/aix/library/au-analyze_aix/)  
[nmon for Linux](http://nmon.sourceforge.net/pmwiki.php)  
[nmon_analyser](https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Power+Systems/page/nmon_analyser)  
[《性能之巅》](https://book.douban.com/subject/26586598/)  



