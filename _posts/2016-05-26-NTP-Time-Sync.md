---
layout: post
title: NTP 时间同步
description: "NTP 时间同步"
category: Linux
avatarimg:
tags: [Linux, NTP]
duoshuo: true
---

# 引言
VMware CentOS 虚拟机在挂起时，时间也暂停了，查了下解决方法，看到比较多的是安装 VMware Tools，  
看起来不那么简单，于是决定使用 ntpdate 进行定时时间同步的方式。  

# NTP 简介
> 
NTP（Network Time Protocol，网络时间协议）是用来使网络中的各个计算机时间同步的一种协议。无论是平时使用的私人计算机还是在工作中搭建的服务器集群，时间的统一性和准确性是十分重要的。

# NTP 客户端配置
今天不涉及 NTP 服务端的安装配置。  

> 
如无特殊要求，一般使用 crontab 计划任务同步时间，如下：

```bash
[root@linux-node1 ~]# crontab -l
# Time sync
0 * * * * /usr/sbin/ntpdate cn.pool.ntp.org; /usr/sbin/hwclock -w
```    

还有另外一种以 ntpd 服务进程方式实时同步，暂时不涉及。

# Ref
[NTP Pool Time Servers](http://support.ntp.org/bin/view/Servers/NTPPoolServers)  
[Network Time Protocol Setup](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sect-Date_and_Time_Configuration-Command_Line_Configuration-Network_Time_Protocol.html)  
[NTP 配置实践](https://wsgzao.github.io/post/ntp/)  
[NTP 时间服务器](http://www.zyops.com/ntp)  
[解决 VMware 虚拟机时间同步问题](http://mingyue19850801.blog.163.com/blog/static/1952082020102301150477/)  

